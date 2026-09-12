Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F383361DD0;
	Sat, 12 Sep 2026 08:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200058; cv=none; b=P3okB5XHKGW0SJqwxVwbVRVxbHnrcDbr7vQGOp8Tya9cU3UawiKV/gRIo9kLiwKvylWtIIuce2AermBNbnlt5htHZEDah6k/QEJMRjGRIyOMvk37ao48BHzPou9VssI9udY7Tr7d4IjMknTnSbLU9E07ubYJCilmKQiKXWKIF5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200058; c=relaxed/simple;
	bh=Ffm19O00jjKQWqSzAgTSlgxcaEkyJXiKQQO/kybHPc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ikr2rMn5O80yUrouG0/IYFcsOS+EmdVla3u4acYGr1N5E4uN9uTu819KLNEVEOEpS07W7tKPy85Ir2hpUrsVAyxH7glEDNYKoMDYCv8chcFlGNgA9NKABS0URu9jgdcU9wMD18Mt4WX7FzMhar4U9t25Gkq8k9UiHmRmJXAv8ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOviQw7T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOviQw7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D540B1F000FF;
	Sat, 12 Sep 2026 08:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200055;
	bh=nHLszybgTsnVpGWaV3s/mYq0a4AeXKJcf5BJfFC3SHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOviQw7TTdMBg6N8AslzeJI+68VW6rwATrJxYXWfMSWF6EIk3OQNaC7OwvVvXZQaq
	 VoYQAkAeGu1GEXxFVqisKurRjFwFz7tYDsRijtSeJS1BFBqc9I85yt68DVc9l0G4pY
	 vmEN16efj/vLFVRUeBkrgSnsRVrR4RFW1g2np01I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0685/1815] spi: oc-tiny: switch to managed controller allocation
Date: Sat, 12 Sep 2026 08:40:35 +0200
Message-ID: <20260912065704.970977802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 29333b1f82d7a..1cd2a934c0329 100644
--- a/drivers/spi/spi-oc-tiny.c
+++ b/drivers/spi/spi-oc-tiny.c
@@ -210,11 +210,11 @@ static int tiny_spi_probe(struct platform_device *pdev)
 	struct tiny_spi_platform_data *platp = dev_get_platdata(&pdev->dev);
 	struct tiny_spi *hw;
 	struct spi_controller *host;
-	int err = -ENODEV;
+	int err;
 
-	host = spi_alloc_host(&pdev->dev, sizeof(struct tiny_spi));
+	host = devm_spi_alloc_host(&pdev->dev, sizeof(struct tiny_spi));
 	if (!host)
-		return err;
+		return -ENOMEM;
 
 	/* setup the host state. */
 	host->bus_num = pdev->id;
@@ -232,10 +232,8 @@ static int tiny_spi_probe(struct platform_device *pdev)
 
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
@@ -243,7 +241,7 @@ static int tiny_spi_probe(struct platform_device *pdev)
 		err = devm_request_irq(&pdev->dev, hw->irq, tiny_spi_irq, 0,
 				       pdev->name, hw);
 		if (err)
-			goto exit;
+			return err;
 	}
 	/* find platform data */
 	if (platp) {
@@ -252,29 +250,23 @@ static int tiny_spi_probe(struct platform_device *pdev)
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
-	spi_controller_put(host);
-	return err;
 }
 
 static void tiny_spi_remove(struct platform_device *pdev)
 {
 	struct tiny_spi *hw = platform_get_drvdata(pdev);
-	struct spi_controller *host = hw->bitbang.ctlr;
 
 	spi_bitbang_stop(&hw->bitbang);
-	spi_controller_put(host);
 }
 
 #ifdef CONFIG_OF
-- 
2.53.0



