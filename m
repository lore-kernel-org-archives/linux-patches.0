Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048F3370D47;
	Sat, 12 Sep 2026 10:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208315; cv=none; b=sgZ/rWpGB72rrRtinFTIYSMil7byhiSKDtImYRpWK0q3r4DgHKhucWG96Al6iIW+nR/Upmxzthgp4F626Oi/yLyCj1D+4z5WX/WcDYHw4yru3bUBnrPQ+rrWLB3Vq2v+BFzsMLakTcZKSWe+Iv1yXlA0oefsVUGTD9DuAt33eC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208315; c=relaxed/simple;
	bh=PaTgHRussxQGO3OVydF//4HeqwwxYfQ6n2L1tBsNXPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6iou5nr83xNkAyRQuZyjtn+IPmG4sE3vRI54A8xqRMxGjWBLickPiabYpdSB7ZGfPzPBOMxL0r6lMQpMvi9O759u0drtThHPjxykcA0SRzO7lXi74eqoT8YqRq7Neq8sQdETHeKBP4QNoH6eR1O60uzIjVKH33JUMIYX1H7veo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzpkPPL6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzpkPPL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A0A1F000FF;
	Sat, 12 Sep 2026 10:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208312;
	bh=cnGfipFc3x7eyupfwMV6RwG5LmzPa3QGZ8SE0/l9CoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BzpkPPL62VevCVsE9hhIprjaANZFdb3VY95iPyUTgIqdPeLPOL4+2Z2TwKCoe2uWc
	 LqM2pAdrG7OCDyPBg7hBGNO3MO0nLfBxhNZIRe+H9qN7sJpLRrwKzgiLS5bCX3EFlr
	 rU7qSKsWlNGbJS/xhJVccnGc5ngjB2LLHu3vh56Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0590/1518] spi: oc-tiny: switch to managed controller allocation
Date: Sat, 12 Sep 2026 08:45:59 +0200
Message-ID: <20260912065636.773487910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index cba2299203573..cc5bceb1cc88b 100644
--- a/drivers/spi/spi-oc-tiny.c
+++ b/drivers/spi/spi-oc-tiny.c
@@ -211,11 +211,11 @@ static int tiny_spi_probe(struct platform_device *pdev)
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
@@ -233,10 +233,8 @@ static int tiny_spi_probe(struct platform_device *pdev)
 
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
@@ -244,7 +242,7 @@ static int tiny_spi_probe(struct platform_device *pdev)
 		err = devm_request_irq(&pdev->dev, hw->irq, tiny_spi_irq, 0,
 				       pdev->name, hw);
 		if (err)
-			goto exit;
+			return err;
 	}
 	/* find platform data */
 	if (platp) {
@@ -253,29 +251,23 @@ static int tiny_spi_probe(struct platform_device *pdev)
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



