Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF1112BF15;
	Tue, 23 Jan 2024 00:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968897; cv=none; b=g5qjPHCd0miWr8c7cscXApUh8WAeiwNAUgzHKjQIS/BgAdxgVElx8PkehltRL9NI7UXF/OK8gr2DqpUShfqOQL/qMZU0rGDbFqwuW8+LrrhJpR7TON5+UPleeYvov2xiinj15Z1lL994cRLewXyHaRQMrZNkcU59jd54aXzKJFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968897; c=relaxed/simple;
	bh=/StakKvAQeXFNPJtNN5wV3yGrrwUf+ufOxsI2SCOwvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu2ZZZvCbEMPOLjs8uYUP6xjXkoTRr5ljE9VS3uc43AtCkOiklvdeKDeulaGWBaCZBu3nj1VYbzrF1EAfzsWuKVA/SHSF1pkvS2sy8kQ6ekq+coekQBgIct9IKjL6LjhpocWvP6EO3SdvggbZ72CY8RWTVtSlLDwLTWBtWbfqHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zokyo5fS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zokyo5fS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2EBC43390;
	Tue, 23 Jan 2024 00:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968896;
	bh=/StakKvAQeXFNPJtNN5wV3yGrrwUf+ufOxsI2SCOwvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zokyo5fSrGw/9SUpJfvuM9KLjJ1TBFrGlaKFIskZsgZoQmbwKMgLNkIkGFtbEhAgN
	 xWV4Vm/1ENkqKNHSd4OC4cXTfQHUAmrsPfugZ5Bvt5ujkNgK8eLM09z/NS3tYJvCS+
	 jvy08BRRHtWjtDvIhhMgIHqEQ0q0JO1iRGZHVqAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/194] firmware: ti_sci: Fix an off-by-one in ti_sci_debugfs_create()
Date: Mon, 22 Jan 2024 15:56:56 -0800
Message-ID: <20240122235722.942508120@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 54340869e682..00259a5f3b3b 100644
--- a/drivers/firmware/ti_sci.c
+++ b/drivers/firmware/ti_sci.c
@@ -179,7 +179,7 @@ static int ti_sci_debugfs_create(struct platform_device *pdev,
 {
 	struct device *dev = &pdev->dev;
 	struct resource *res;
-	char debug_name[50] = "ti_sci_debug@";
+	char debug_name[50];
 
 	/* Debug region is optional */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
@@ -196,10 +196,10 @@ static int ti_sci_debugfs_create(struct platform_device *pdev,
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



