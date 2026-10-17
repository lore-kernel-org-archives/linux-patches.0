Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56473CB2FD;
	Sat, 17 Oct 2026 18:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260194; cv=none; b=ft+meiKNLvcd3IfGzKnaYURXbxzYVIz6QEzj+HN4ryoOYxEuqsCWX/5ET7BrgpkMIXBEEPzFPoxiK6TehFYqwsrf11Pk4plrvTFfH7nZIf/hJv6/KCk5MiXVnqGW/peNj/5i6xOvgiV2m8WXqMsewaSTEbZ+VNIOWTGXi9YMRBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260194; c=relaxed/simple;
	bh=yGt2Y/SqYWIqw5c8zhj+P2RGYkT9ZHgeBHpLcDCVP1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htFwwJt1JfCsAxU5umBX3rDMb/4tiUplEOzFhWsG0RQfhE2GpOftY20IWjXvSZ6hyK5kvgiE8zhJbQoUFMVHfEdEHLEP0wDrBKBCRxeRQxIH1XzdZpmTd4aavb4OKknQTQSfZjfsfmaB7eid0yzn77Iw99Ld/ChuPXtL+xX3pBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgUkQ6PK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgUkQ6PK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0261B1F000C4;
	Sat, 17 Oct 2026 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260192;
	bh=gj/hz76KsnZBrffenXZtu3trsujxjotydQG7PUf8DuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgUkQ6PKjv41B96tw1RZvPcNEEfRbp+kydeKDWBMog3wwhI4odd7la7mRoG7AzkkA
	 uwk9WM5YGHwORqiHK9l1MHC6ab1euVbcBy6PdmauBpXrEvAgCWqzLG/ez25VgiL9WS
	 3QDgwllZHeG1f2KCIIwv+QgKsO3DayMiCMuv33Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1465/1674] spi: oc-tiny: switch to managed controller allocation
Date: Sat, 17 Oct 2026 18:02:17 +0200
Message-ID: <20261017160508.775216531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit d710f43ce30975d197f73c543bfe47b958d8ba17 ]

The controller is allocated with the non-managed spi_alloc_host() while
the interrupt is registered with devm_request_irq().  During removal,
spi_bitbang_stop() only unregisters the controller; the subsequent
spi_controller_put() then frees the controller together with its
embedded driver-private devdata, which is the IRQ handler's dev_id.  The
devm_request_irq() release action (free_irq()), which drains the
handler, does not run until after .remove() returns.  A late or latched
interrupt can therefore reach tiny_spi_irq() and dereference
already-freed memory (e.g. hw->base).

Switch to devm_spi_alloc_host() so that the devres LIFO order releases
the controller only after free_irq() has drained the handler, and drop
the now-redundant spi_controller_put() from .remove().  The probe error
path is simplified to direct returns.

This issue was found by an in-house static analysis tool.

Fixes: ce792580ea2c ("spi: add OpenCores tiny SPI driver")
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260719010014.3163356-1-fanwu01@zju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-oc-tiny.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spi-oc-tiny.c b/drivers/spi/spi-oc-tiny.c
index 3af499838e844..7ed76a9e72732 100644
--- a/drivers/spi/spi-oc-tiny.c
+++ b/drivers/spi/spi-oc-tiny.c
@@ -213,11 +213,11 @@ static int tiny_spi_probe(struct platform_device *pdev)
 	struct tiny_spi_platform_data *platp = dev_get_platdata(&pdev->dev);
 	struct tiny_spi *hw;
 	struct spi_master *master;
-	int err = -ENODEV;
+	int err;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct tiny_spi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct tiny_spi));
 	if (!master)
-		return err;
+		return -ENOMEM;
 
 	/* setup the master state. */
 	master->bus_num = pdev->id;
@@ -235,10 +235,8 @@ static int tiny_spi_probe(struct platform_device *pdev)
 
 	/* find and map our resources */
 	hw->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(hw->base)) {
-		err = PTR_ERR(hw->base);
-		goto exit;
-	}
+	if (IS_ERR(hw->base))
+		return PTR_ERR(hw->base);
 	/* irq is optional */
 	hw->irq = platform_get_irq(pdev, 0);
 	if (hw->irq >= 0) {
@@ -246,7 +244,7 @@ static int tiny_spi_probe(struct platform_device *pdev)
 		err = devm_request_irq(&pdev->dev, hw->irq, tiny_spi_irq, 0,
 				       pdev->name, hw);
 		if (err)
-			goto exit;
+			return err;
 	}
 	/* find platform data */
 	if (platp) {
@@ -255,29 +253,23 @@ static int tiny_spi_probe(struct platform_device *pdev)
 	} else {
 		err = tiny_spi_of_probe(pdev);
 		if (err)
-			goto exit;
+			return err;
 	}
 
 	/* register our spi controller */
 	err = spi_bitbang_start(&hw->bitbang);
 	if (err)
-		goto exit;
+		return err;
 	dev_info(&pdev->dev, "base %p, irq %d\n", hw->base, hw->irq);
 
 	return 0;
-
-exit:
-	spi_master_put(master);
-	return err;
 }
 
 static void tiny_spi_remove(struct platform_device *pdev)
 {
 	struct tiny_spi *hw = platform_get_drvdata(pdev);
-	struct spi_master *master = hw->bitbang.master;
 
 	spi_bitbang_stop(&hw->bitbang);
-	spi_master_put(master);
 }
 
 #ifdef CONFIG_OF
-- 
2.53.0



