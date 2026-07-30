Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E52411689;
	Thu, 30 Jul 2026 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426911; cv=none; b=dzbBPIh1sLVRyfVfybOE+4794H0SCxvLboih/xU9myF7+gDXUiuiSxanNi5jI5LoZxbz0ZThN5TVO51qHRwcSSNg5zgvm7KsPS8DiqwWJiSBuZ8fZt4Z0YLt8W9pEPpPk36oK9hrDNskKvV+KGOwEbA5aXJYn4xRDKff+ap3+dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426911; c=relaxed/simple;
	bh=k5bvJBlHhIji2agiFcSnCIgrs/wXjuXXJJjgtWfsZJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2Nt36JpGkZVeZ3jie5EUaeqch5OjfkNPKrct6MR4+2asvOg8lU8o7jfI7qHmYdb2y/YxelrvF9T8HmbJMvLMxoY2mKuqKP09wQDA87qL+VSbO7Jn2Yhv2XpGnLHyJrrh5JHLBD1uMUG7H01ABlrwSBUwarlEMnvgrCA19FWH0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqvIwH0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqvIwH0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B0F1F00A3A;
	Thu, 30 Jul 2026 15:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426910;
	bh=O+OLn9vVfO5wrQ4uRxzDUidaPEcBBeHj/ODWEE76e8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqvIwH0k6nwyn0dI7XzJ4yK7JF2NY5xWDlHHrwmEdjRKZcyQWqGVppT6XAWOi64+O
	 2+AXW+M3X/rymTVZaE+VzHfNBDbTvo8zciK5IUQxqDVAyJtcdLG+L6mBBkJK6rbUIs
	 WfKro76CYVVNiiDxHJWS+4Vowzuc/aoZdnVqgugM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 585/602] usb: musb: omap2430: clean up probe error handling
Date: Thu, 30 Jul 2026 16:16:17 +0200
Message-ID: <20260730141448.347371342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 51d4b0a44c82e5eff056ef76acd2c3c605a8eb74 upstream.

Using numbered error labels is discouraged (e.g. as it requires
renumbering them when adding a new intermediate error path).

Rename the error labels after what they do.

While at it, drop the redundant platform allocation failure dev_err()
as the error would already have been logged by the allocator.

Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250724091910.21092-6-johan@kernel.org
Stable-dep-of: c947360ae63e ("usb: musb: omap2430: Do not put borrowed of_node in probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -318,13 +318,11 @@ static int omap2430_probe(struct platfor
 
 	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue)
-		goto err0;
+		return -ENOMEM;
 
 	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
-	if (!musb) {
-		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err0;
-	}
+	if (!musb)
+		return -ENOMEM;
 
 	musb->dev.parent		= &pdev->dev;
 	musb->dev.dma_mask		= &omap2430_dmamask;
@@ -348,15 +346,15 @@ static int omap2430_probe(struct platfor
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
-		goto err2;
+		goto err_put_musb;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
-		goto err2;
+		goto err_put_musb;
 
 	config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
 	if (!config)
-		goto err2;
+		goto err_put_musb;
 
 	of_property_read_u32(np, "mode", (u32 *)&pdata->mode);
 	of_property_read_u32(np, "interface-type",
@@ -379,7 +377,7 @@ static int omap2430_probe(struct platfor
 		if (!control_pdev) {
 			dev_err(&pdev->dev, "Failed to get control device\n");
 			ret = -EINVAL;
-			goto err2;
+			goto err_put_musb;
 		}
 		glue->control_otghs = &control_pdev->dev;
 	}
@@ -455,22 +453,21 @@ static int omap2430_probe(struct platfor
 	ret = platform_device_add(musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device\n");
-		goto err3;
+		goto err_disable_rpm;
 	}
 	of_node_put(np);
 
 	return 0;
 
-err3:
+err_disable_rpm:
 	pm_runtime_disable(glue->dev);
 err_put_control_otghs:
 	if (!IS_ERR(glue->control_otghs))
 		put_device(glue->control_otghs);
-err2:
+err_put_musb:
 	of_node_put(np);
 	platform_device_put(musb);
 
-err0:
 	return ret;
 }
 


