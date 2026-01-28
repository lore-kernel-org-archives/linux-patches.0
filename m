Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BCF288C22;
	Wed, 28 Jan 2026 15:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615691; cv=none; b=QFQs2cF06s4m006exL4Y5Oyhu3HUPQhXFIWSRlN3pV2mz6N5fD4KNgMhpdzUkvAJeMStNSNv6GoKatljvGV15xrBqGcTVq6A59jJsDgSGifqdNSl1k8IhriqFV5M+VumBvWyj1kbg7mXD5qW+rUlr3dj3aivo8wYBaPAsPHxUOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615691; c=relaxed/simple;
	bh=qDMwj5EjWfoyfS6ZgjS6uMCLsscC6ZX/OYaGn6A9dMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryRjfTssQ2sZHVxwbIIDCq9OsxpuxsH/1kBBDBm1ZoPp5DZqZisr9Zu1upo1C0cnWlLVzXvyE6gGlugqSR2ctfUpL91+GRzukU7uPOHlg1/Xnx6VpTu0b50zi+DqevynQynyBZM5MKPAolizA25yZUPNnyzRi7tWVA7Y4gj8Fvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rozsuadg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rozsuadg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188F4C4CEF1;
	Wed, 28 Jan 2026 15:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615691;
	bh=qDMwj5EjWfoyfS6ZgjS6uMCLsscC6ZX/OYaGn6A9dMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rozsuadgrhc9mxQrNv1wjHKfQ9wr7tlUSaDIOahOCoYyYjNXA/QDVjXnSG8iIU8oU
	 uAWcMvKfDFe/glbVWKpfqMbu3gJCZ5X3SfNh9s30X0dvZ0pnDD3p6LkUaz2pMRahYQ
	 Q9ISRgF2jkFjJADjojV4bG1cLY5hyk/jcMHDW/4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/227] spi: spi-sprd-adi: Fix double free in probe error path
Date: Wed, 28 Jan 2026 16:22:10 +0100
Message-ID: <20260128145347.398209360@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <gu_0233@qq.com>

[ Upstream commit 383d4f5cffcc8df930d95b06518a9d25a6d74aac ]

The driver currently uses spi_alloc_host() to allocate the controller
but registers it using devm_spi_register_controller().

If devm_register_restart_handler() fails, the code jumps to the
put_ctlr label and calls spi_controller_put(). However, since the
controller was registered via a devm function, the device core will
automatically call spi_controller_put() again when the probe fails.
This results in a double-free of the spi_controller structure.

Fix this by switching to devm_spi_alloc_host() and removing the
manual spi_controller_put() call.

Fixes: ac17750 ("spi: sprd: Add the support of restarting the system")
Signed-off-by: Felix Gu <gu_0233@qq.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://patch.msgid.link/tencent_AC7D389CE7E24318445E226F7CDCCC2F0D07@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sprd-adi.c | 33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/spi/spi-sprd-adi.c b/drivers/spi/spi-sprd-adi.c
index 262c11d977ea3..f25b34a91756f 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -528,7 +528,7 @@ static int sprd_adi_probe(struct platform_device *pdev)
 	pdev->id = of_alias_get_id(np, "spi");
 	num_chipselect = of_get_child_count(np);
 
-	ctlr = spi_alloc_host(&pdev->dev, sizeof(struct sprd_adi));
+	ctlr = devm_spi_alloc_host(&pdev->dev, sizeof(struct sprd_adi));
 	if (!ctlr)
 		return -ENOMEM;
 
@@ -536,10 +536,8 @@ static int sprd_adi_probe(struct platform_device *pdev)
 	sadi = spi_controller_get_devdata(ctlr);
 
 	sadi->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
-	if (IS_ERR(sadi->base)) {
-		ret = PTR_ERR(sadi->base);
-		goto put_ctlr;
-	}
+	if (IS_ERR(sadi->base))
+		return PTR_ERR(sadi->base);
 
 	sadi->slave_vbase = (unsigned long)sadi->base +
 			    data->slave_offset;
@@ -551,18 +549,15 @@ static int sprd_adi_probe(struct platform_device *pdev)
 	if (ret > 0 || (IS_ENABLED(CONFIG_HWSPINLOCK) && ret == 0)) {
 		sadi->hwlock =
 			devm_hwspin_lock_request_specific(&pdev->dev, ret);
-		if (!sadi->hwlock) {
-			ret = -ENXIO;
-			goto put_ctlr;
-		}
+		if (!sadi->hwlock)
+			return -ENXIO;
 	} else {
 		switch (ret) {
 		case -ENOENT:
 			dev_info(&pdev->dev, "no hardware spinlock supplied\n");
 			break;
 		default:
-			dev_err_probe(&pdev->dev, ret, "failed to find hwlock id\n");
-			goto put_ctlr;
+			return dev_err_probe(&pdev->dev, ret, "failed to find hwlock id\n");
 		}
 	}
 
@@ -579,26 +574,18 @@ static int sprd_adi_probe(struct platform_device *pdev)
 	ctlr->transfer_one = sprd_adi_transfer_one;
 
 	ret = devm_spi_register_controller(&pdev->dev, ctlr);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register SPI controller\n");
-		goto put_ctlr;
-	}
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "failed to register SPI controller\n");
 
 	if (sadi->data->restart) {
 		ret = devm_register_restart_handler(&pdev->dev,
 						    sadi->data->restart,
 						    sadi);
-		if (ret) {
-			dev_err(&pdev->dev, "can not register restart handler\n");
-			goto put_ctlr;
-		}
+		if (ret)
+			return dev_err_probe(&pdev->dev, ret, "can not register restart handler\n");
 	}
 
 	return 0;
-
-put_ctlr:
-	spi_controller_put(ctlr);
-	return ret;
 }
 
 static struct sprd_adi_data sc9860_data = {
-- 
2.51.0



