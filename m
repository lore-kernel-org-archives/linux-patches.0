Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF5E47CC7E;
	Tue, 16 Jun 2026 18:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634704; cv=none; b=mmHURZTXjggqvS2pQsgaf+6IT1sKMpX5Xiz7kNeMdFYxBI98v6V9Wt+p3GOTKpzvhVomRyzNuCBd4xOprcHsJR7xk1n8Akc0wstPYGN/76MPG4BOEr6GqFXKlTUnA2+W65K64EpzFRsiurP5grp5IsT5jY/SAZedQGJCYTmmnBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634704; c=relaxed/simple;
	bh=fH0TQkwwahMTQLXi7ddvuJm1fKZ+SxfNyY/pNzLh8oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2hG1P4GL2seiwWDRj0swD6CN9WBMciV1DVxN+tRujL07nduC9RbMN/tKvwrShU8pkE2ScrBJKDX9VZd6Eu9F7GcctTd46pjCdMEkStQDUvl5NrZlwLUQjH6gVGbfimDzVeuN9nGKWMC8sJfzFpPxOqDaHSKjwYpFGOavXvkdRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8FI17ka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8FI17ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3181F000E9;
	Tue, 16 Jun 2026 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634702;
	bh=22T+FMyj7IoVVnFhSTcmyj6FwfOUQpS4XXLkRgOds7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8FI17ka8MIuffmrM69lvP1EEZ89688QWTcjBi/KxHjeVkKrTFcwLn323jPsnhamU
	 O4K1vnRT9Y8J+xawd4gNQ2BzOUTmLcNsmI9w6p/MCz8MuA5sddY0r32+gZ2LLyjGmk
	 TGaG48v8/e8F9aapeLxfMS0qyInGit65bbAr8GrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 315/411] spi: zynq-qspi: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:13 +0530
Message-ID: <20260616145117.886684326@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ kept int-returning remove() with manual clk_disable_unprepare() calls and routed probe error through existing clk_dis_all cascade instead of upstream's remove_ctlr label ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-zynq-qspi.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -652,7 +652,7 @@ static int zynq_qspi_probe(struct platfo
 
 	xqspi = spi_controller_get_devdata(ctlr);
 	xqspi->dev = dev;
-	platform_set_drvdata(pdev, xqspi);
+	platform_set_drvdata(pdev, ctlr);
 	xqspi->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(xqspi->regs)) {
 		ret = PTR_ERR(xqspi->regs);
@@ -722,9 +722,9 @@ static int zynq_qspi_probe(struct platfo
 	/* QSPI controller initializations */
 	zynq_qspi_init_hw(xqspi, ctlr->num_chipselect);
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret) {
-		dev_err(&pdev->dev, "spi_register_master failed\n");
+		dev_err(&pdev->dev, "failed to register controller\n");
 		goto clk_dis_all;
 	}
 
@@ -752,13 +752,20 @@ remove_master:
  */
 static int zynq_qspi_remove(struct platform_device *pdev)
 {
-	struct zynq_qspi *xqspi = platform_get_drvdata(pdev);
+	struct spi_controller *ctlr = platform_get_drvdata(pdev);
+	struct zynq_qspi *xqspi = spi_controller_get_devdata(ctlr);
+
+	spi_controller_get(ctlr);
+
+	spi_unregister_controller(ctlr);
 
 	zynq_qspi_write(xqspi, ZYNQ_QSPI_ENABLE_OFFSET, 0);
 
 	clk_disable_unprepare(xqspi->refclk);
 	clk_disable_unprepare(xqspi->pclk);
 
+	spi_controller_put(ctlr);
+
 	return 0;
 }
 


