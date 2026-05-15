Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E40305669;
	Fri, 15 May 2026 15:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860593; cv=none; b=FqImy5DoHHXg5LQ3Yiy0O7m4O8dojmImMxv41u7fTR4t30UhnQwluw0yWOuKM9aP1ioSoO79X1YlPBMXEJRUVy+chnOn7giE2WkdVSQe9jmv4yXQBxditUte2/ID/4tFGkRsSnFF73xDFTVxe2FTiiwHl1b5lXdRcKfGCkk9GQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860593; c=relaxed/simple;
	bh=cZUhkxV0HCrm12lQ6c4yMe+XSo+kJlSGOb7JIGeAWhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCuF0bBHNWbHK1b+Eo6ANrwNPSJYZYrpHB1JYPUYAl/UAr1lgso/WYcfBQpeu92ifBrL/d4j6sLb22NfucwlOQoOuzha7TluEArd+DAgiaWYZbhWJPiMUlNqLfjgqk1CS17r70xWyONDJ4oripjrhdIW/xM8Kn1voQfKV7e8s9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCn2ThjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCn2ThjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2F7C2BCB0;
	Fri, 15 May 2026 15:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860593;
	bh=cZUhkxV0HCrm12lQ6c4yMe+XSo+kJlSGOb7JIGeAWhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCn2ThjDSro6zgJVX9pGy5tPmXWaFdpWy+v+z76W8Xw0xJg1VMYFh5q/1kORpNw4C
	 uClWOdu+diNpi8jQ6Qk4rL9iH2IiZhPeXS95AwZu7RURbZd2Uz4jP9WBn85UrxRLf5
	 LkwAJC2VKJDwPQxOEbpS2q5AlOBPg6dLfRAv90uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/144] spi: zynq-qspi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:57 +0200
Message-ID: <20260515154656.064798302@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

[ Upstream commit c9c012706c9fa8ca6d129a9161caf92ab625a3fd ]

Make sure to deregister the controller before disabling it during driver
unbind.

Note that clocks were also disabled before the recent commit
1f8fd9490e31 ("spi: zynq-qspi: Simplify clock handling with
devm_clk_get_enabled()").

Fixes: 67dca5e580f1 ("spi: spi-mem: Add support for Zynq QSPI controller")
Cc: stable@vger.kernel.org	# 5.2: 8eb2fd00f65a
Cc: stable@vger.kernel.org	# 5.2
Cc: Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-27-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-zynq-qspi.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -641,7 +641,7 @@ static int zynq_qspi_probe(struct platfo
 
 	xqspi = spi_controller_get_devdata(ctlr);
 	xqspi->dev = dev;
-	platform_set_drvdata(pdev, xqspi);
+	platform_set_drvdata(pdev, ctlr);
 	xqspi->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(xqspi->regs)) {
 		ret = PTR_ERR(xqspi->regs);
@@ -699,9 +699,9 @@ static int zynq_qspi_probe(struct platfo
 	/* QSPI controller initializations */
 	zynq_qspi_init_hw(xqspi, ctlr->num_chipselect);
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret) {
-		dev_err(&pdev->dev, "devm_spi_register_controller failed\n");
+		dev_err(&pdev->dev, "failed to register controller\n");
 		goto remove_ctlr;
 	}
 
@@ -725,9 +725,16 @@ remove_ctlr:
  */
 static void zynq_qspi_remove(struct platform_device *pdev)
 {
-	struct zynq_qspi *xqspi = platform_get_drvdata(pdev);
+	struct spi_controller *ctlr = platform_get_drvdata(pdev);
+	struct zynq_qspi *xqspi = spi_controller_get_devdata(ctlr);
+
+	spi_controller_get(ctlr);
+
+	spi_unregister_controller(ctlr);
 
 	zynq_qspi_write(xqspi, ZYNQ_QSPI_ENABLE_OFFSET, 0);
+
+	spi_controller_put(ctlr);
 }
 
 static const struct of_device_id zynq_qspi_of_match[] = {


