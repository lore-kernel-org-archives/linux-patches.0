Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F6B14A4CF;
	Tue, 23 Jan 2024 00:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969230; cv=none; b=DIJZPoX5nlHFUFG14hNsSRpNlADNyDBWNcd1JLpMfystvBAXaMFqWmFz8oy+xrWLPuISOoTINERWeFnoz1KKxMGwGBqtUTBK9+LpeoCeT+l3TG2CEdGWjEZLjdY4xbCTnouoS0SWwsSedNdOKGoAmVhLDO17ewucEimnINZeHl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969230; c=relaxed/simple;
	bh=Qvu+UPf/r4swf/teRwK4K4qAxxMUCc5WeTyrVAvG8X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktRYMSWAhD+zK/lO4RIbfyJ8Z+M+Jq+N0X8+2pbbV5ZsmZaCVz2VqSYgoiHXahAuXMWGJHibi0iSBrVMgFFc7j/Ianx0DMxryrJMaNBMDQzG7+8S+s9YsLeLzOL2rfJOKzdrdVlFISb+MDNx5qy/3xiW7x62Y90uf3CYY5TFrAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aY9xG6DK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aY9xG6DK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA2BC433B2;
	Tue, 23 Jan 2024 00:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969230;
	bh=Qvu+UPf/r4swf/teRwK4K4qAxxMUCc5WeTyrVAvG8X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aY9xG6DKsd5uu81RmGGBobX98uKLb45XK2dfXD4M7q46j2mJkWuEUeo6f4uD5Kta8
	 heB0hDbTH/9unQjTwa5WKsOsj1AxcAIcFUpH4FZzodOdN39cUL5/U5fkHsy8JsOHoy
	 X2aAoDKFoZQTAGrJER+wWMhasnENmCouXw5XdR4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 106/641] firmware: ti_sci: Fix an off-by-one in ti_sci_debugfs_create()
Date: Mon, 22 Jan 2024 15:50:10 -0800
Message-ID: <20240122235821.358260728@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 964946b88887089f447a9b6a28c39ee97dc76360 ]

The ending NULL is not taken into account by strncat(), so switch to
snprintf() to correctly build 'debug_name'.

Using snprintf() also makes the code more readable.

Fixes: aa276781a64a ("firmware: Add basic support for TI System Control Interface (TI-SCI) protocol")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/7158db0a4d7b19855ddd542ec61b666973aad8dc.1698660720.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/ti_sci.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/ti_sci.c b/drivers/firmware/ti_sci.c
index 7041befc756a..8b9a2556de16 100644
--- a/drivers/firmware/ti_sci.c
+++ b/drivers/firmware/ti_sci.c
@@ -164,7 +164,7 @@ static int ti_sci_debugfs_create(struct platform_device *pdev,
 {
 	struct device *dev = &pdev->dev;
 	struct resource *res;
-	char debug_name[50] = "ti_sci_debug@";
+	char debug_name[50];
 
 	/* Debug region is optional */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
@@ -181,10 +181,10 @@ static int ti_sci_debugfs_create(struct platform_device *pdev,
 	/* Setup NULL termination */
 	info->debug_buffer[info->debug_region_size] = 0;
 
-	info->d = debugfs_create_file(strncat(debug_name, dev_name(dev),
-					      sizeof(debug_name) -
-					      sizeof("ti_sci_debug@")),
-				      0444, NULL, info, &ti_sci_debug_fops);
+	snprintf(debug_name, sizeof(debug_name), "ti_sci_debug@%s",
+		 dev_name(dev));
+	info->d = debugfs_create_file(debug_name, 0444, NULL, info,
+				      &ti_sci_debug_fops);
 	if (IS_ERR(info->d))
 		return PTR_ERR(info->d);
 
-- 
2.43.0



