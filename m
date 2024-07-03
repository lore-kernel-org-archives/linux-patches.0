Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7539183077;
	Wed,  3 Jul 2024 11:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004846; cv=none; b=uDPO8Y26miVNtXy+0BLXdukvaNnjlEa9WxoKHBHmNpKtH2Dy2Ce1Lg8Y4sIDYMqqHDGnLYGStgq0J8NmZdT5k1saauqvLXe1lF1d1bigIM9ay+ji+BTzAzQm3gkI5ZGFL5os9diqD4jyGgbjAe5YhCXEWwGzfF677TRmj6xTWWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004846; c=relaxed/simple;
	bh=Vumlpc+llwP+FG3a4s6mKuLHenZ/Eb3DcgNfXq9swAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2bPfjYvFkbGXIJ5z+H5UySmsOgvUy7lzlff6byh0Nh/rzpzIZ1mis5gGbmB0QaEUezctHUy0EndKjTcTGEo0/0tieJ2BQFKzdiKeOmR3I3/gc5yuYiB2zPJdtscUTA2K2/t9Xq9AOInHYh8f5JS8C+NVGTXM7dRTjEfPhtkjHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmGYt6OI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmGYt6OI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C348C2BD10;
	Wed,  3 Jul 2024 11:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004846;
	bh=Vumlpc+llwP+FG3a4s6mKuLHenZ/Eb3DcgNfXq9swAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmGYt6OIe7Qz3nvTunspXxwvJ5yB88ImLuDita4mjNHo2SLIuwWBplGEvZISYkAeG
	 y75d+YPqvz8zq7oNFCSeCDBjqrZcKDSvVqJ4rv7Vn/QZ5JZdvcKIIxkjTNgNoi+Nbf
	 zaJg0w+k4eYLe3ykaRDEOz3Vf+njnxdONN2KWdso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vamshi Gajjela <vamshigajjela@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/290] spmi: hisi-spmi-controller: Do not override device identifier
Date: Wed,  3 Jul 2024 12:39:19 +0200
Message-ID: <20240703102910.897604714@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vamshi Gajjela <vamshigajjela@google.com>

[ Upstream commit eda4923d78d634482227c0b189d9b7ca18824146 ]

'nr' member of struct spmi_controller, which serves as an identifier
for the controller/bus. This value is a dynamic ID assigned in
spmi_controller_alloc, and overriding it from the driver results in an
ida_free error "ida_free called for id=xx which is not allocated".

Signed-off-by: Vamshi Gajjela <vamshigajjela@google.com>
Fixes: 70f59c90c819 ("staging: spmi: add Hikey 970 SPMI controller driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240228185116.1269-1-vamshigajjela@google.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20240507210809.3479953-5-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/hikey9xx/hisi-spmi-controller.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/hikey9xx/hisi-spmi-controller.c b/drivers/staging/hikey9xx/hisi-spmi-controller.c
index 29f226503668d..eee3dcf96ee79 100644
--- a/drivers/staging/hikey9xx/hisi-spmi-controller.c
+++ b/drivers/staging/hikey9xx/hisi-spmi-controller.c
@@ -303,7 +303,6 @@ static int spmi_controller_probe(struct platform_device *pdev)
 
 	spin_lock_init(&spmi_controller->lock);
 
-	ctrl->nr = spmi_controller->channel;
 	ctrl->dev.parent = pdev->dev.parent;
 	ctrl->dev.of_node = of_node_get(pdev->dev.of_node);
 
-- 
2.43.0



