Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E619A2F2358;
	Tue, 17 Jun 2025 15:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175527; cv=none; b=BIITHqKLnM01NULPUMVJlLPwqNvvKkqb1hUR8VoQ2QrXoUZF3EAF5S/8RptjEOyFLvvbZMdnnCEO86ElofmmDwG8ZHXqF0Y0hsBmCot8iU1vY2GdAvcZKQ+J3rar/5NVnJ0/yUdjqcePRiT5QXuFc9SgNsUl6Gv8vq3sCuh1pow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175527; c=relaxed/simple;
	bh=RRDQrPuJ8oOL4n0g3CnfxZ1b4BjxBGDuVVxj3qygvTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DG3/40Ht5H2EfVtmXv5m5OQV6tn8Z8nA7Okfq0ceEX6yBGEIwRq/LgP6/qdsj96oFRrQNEnNC/BvEkLkVsvs/B7dQ/LvlClrLc1Ne/tCbLW2ZbLU5ZIGV4a4dsxv07mTMWVH27sFlifpz6yXytLdFqUrFy6bXEhyTOVgPZD8sa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAOMsxX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAOMsxX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BC2C4CEE7;
	Tue, 17 Jun 2025 15:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175526;
	bh=RRDQrPuJ8oOL4n0g3CnfxZ1b4BjxBGDuVVxj3qygvTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAOMsxX4USrYtolyG5NiPOQQYaCwY+JasqWgDK3sqB5bYZE7Aqq1Dx46LgayZkHMK
	 fW8zY6uxmUw/WPZl5xh8XznPsj4d88RtFKAsyxc1sbGFjgyaRsiwZKUYEzp+LxjH+g
	 n2Vu9G/q5z2nQIETrhz4YYX2nWNb+DEYl05hPfYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 079/780] spi: spi-qpic-snand: validate user/chip specific ECC properties
Date: Tue, 17 Jun 2025 17:16:27 +0200
Message-ID: <20250617152454.725797700@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 65cb56d49f6edea409600a3c61effc70ee5d43d8 ]

The driver only supports 512 bytes ECC step size and 4 bit ECC strength
at the moment, however it does not reject unsupported step/strength
configurations. Due to this, whenever the driver is used with a flash
chip which needs stronger ECC protection, the following warning is shown
in the kernel log:

  [    0.574648] spi-nand spi0.0: GigaDevice SPI NAND was found.
  [    0.635748] spi-nand spi0.0: 256 MiB, block size: 128 KiB, page size: 2048, OOB size: 128
  [    0.649079] nand: WARNING: (null): the ECC used on your system is too weak compared to the one required by the NAND chip

Although the message indicates that something is wrong, but it often gets
unnoticed, which can cause serious problems. For example when the user
writes something into the flash chip despite the warning, the written data
may won't be readable by the bootloader or by the boot ROM. In the worst
case, when the attached SPI NAND chip is the boot device, the board may not
be able to boot anymore.

Also, it is not even possible to create a backup of the flash, because
reading its content results in bogus data. For example, dumping the first
page of the flash gives this:

  # hexdump -C -n 2048 /dev/mtd0
  00000000  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  *
  00000040  0f 0f 0f 0f 0f 0f 0f 0d  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  00000050  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  *
  000001c0  0f 0f 0f 0f ff 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  000001d0  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  *
  00000200  0f 0f 0f 0f f5 5b ff ff  0f 0f 0f 0f 0f 0f 0f 0f  |.....[..........|
  00000210  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  *
  000002f0  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 1f 0f 0f  |................|
  00000300  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  *
  000003c0  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f ff 0f 0f 0f  |................|
  000003d0  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  *
  00000400  0f 0f 0f 0f 0f 0f 0f 0f  e9 74 c9 06 f5 5b ff ff  |.........t...[..|
  00000410  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  *
  000005d0  0f 0f 0f 0f ff 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  000005e0  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  *
  00000600  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f c6 be 0f c3  |................|
  00000610  e9 74 c9 06 f5 5b ff ff  0f 0f 0f 0f 0f 0f 0f 0f  |.t...[..........|
  00000620  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  *
  00000770  0f 0f 0f 0f 8f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  00000780  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  *
  00000800
  #

Doing the same by using the downstream kernel results in different output:

  # hexdump -C -n 2048 /dev/mtd0
  00000000  0f 0f 0f 0f 0f 0f 0f 0f  0f 0f 0f 0f 0f 0f 0f 0f  |................|
  *
  00000800
  #

This patch adds some sanity checks to the code to prevent using the driver
with unsupported ECC step/strength configurations. After the change, probing
of the driver fails in such cases:

  [    0.655038] spi-nand spi0.0: GigaDevice SPI NAND was found.
  [    0.659159] spi-nand spi0.0: 256 MiB, block size: 128 KiB, page size: 2048, OOB size: 128
  [    0.669138] qcom_snand 79b0000.spi: only 4 bits ECC strength is supported
  [    0.677476] nand: No suitable ECC configuration
  [    0.689909] spi-nand spi0.0: probe with driver spi-nand failed with error -95

This helps to avoid the aforementioned hassles until support for 8 bit ECC
strength gets implemented.

Fixes: 7304d1909080 ("spi: spi-qpic: add driver for QCOM SPI NAND flash Interface")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://patch.msgid.link/20250501-qpic-snand-validate-ecc-v1-1-532776581a66@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qpic-snand.c | 42 +++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index 924aa8461963f..44a8f58e46fe1 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -250,9 +250,11 @@ static const struct mtd_ooblayout_ops qcom_spi_ooblayout = {
 static int qcom_spi_ecc_init_ctx_pipelined(struct nand_device *nand)
 {
 	struct qcom_nand_controller *snandc = nand_to_qcom_snand(nand);
+	struct nand_ecc_props *reqs = &nand->ecc.requirements;
+	struct nand_ecc_props *user = &nand->ecc.user_conf;
 	struct nand_ecc_props *conf = &nand->ecc.ctx.conf;
 	struct mtd_info *mtd = nanddev_to_mtd(nand);
-	int cwperpage, bad_block_byte;
+	int cwperpage, bad_block_byte, ret;
 	struct qpic_ecc *ecc_cfg;
 
 	cwperpage = mtd->writesize / NANDC_STEP_SIZE;
@@ -261,11 +263,39 @@ static int qcom_spi_ecc_init_ctx_pipelined(struct nand_device *nand)
 	ecc_cfg = kzalloc(sizeof(*ecc_cfg), GFP_KERNEL);
 	if (!ecc_cfg)
 		return -ENOMEM;
+
+	if (user->step_size && user->strength) {
+		ecc_cfg->step_size = user->step_size;
+		ecc_cfg->strength = user->strength;
+	} else if (reqs->step_size && reqs->strength) {
+		ecc_cfg->step_size = reqs->step_size;
+		ecc_cfg->strength = reqs->strength;
+	} else {
+		/* use defaults */
+		ecc_cfg->step_size = NANDC_STEP_SIZE;
+		ecc_cfg->strength = 4;
+	}
+
+	if (ecc_cfg->step_size != NANDC_STEP_SIZE) {
+		dev_err(snandc->dev,
+			"only %u bytes ECC step size is supported\n",
+			NANDC_STEP_SIZE);
+		ret = -EOPNOTSUPP;
+		goto err_free_ecc_cfg;
+	}
+
+	if (ecc_cfg->strength != 4) {
+		dev_err(snandc->dev,
+			"only 4 bits ECC strength is supported\n");
+		ret = -EOPNOTSUPP;
+		goto err_free_ecc_cfg;
+	}
+
 	snandc->qspi->oob_buf = kmalloc(mtd->writesize + mtd->oobsize,
 					GFP_KERNEL);
 	if (!snandc->qspi->oob_buf) {
-		kfree(ecc_cfg);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_free_ecc_cfg;
 	}
 
 	memset(snandc->qspi->oob_buf, 0xff, mtd->writesize + mtd->oobsize);
@@ -280,8 +310,6 @@ static int qcom_spi_ecc_init_ctx_pipelined(struct nand_device *nand)
 	ecc_cfg->bytes = ecc_cfg->ecc_bytes_hw + ecc_cfg->spare_bytes + ecc_cfg->bbm_size;
 
 	ecc_cfg->steps = 4;
-	ecc_cfg->strength = 4;
-	ecc_cfg->step_size = 512;
 	ecc_cfg->cw_data = 516;
 	ecc_cfg->cw_size = ecc_cfg->cw_data + ecc_cfg->bytes;
 	bad_block_byte = mtd->writesize - ecc_cfg->cw_size * (cwperpage - 1) + 1;
@@ -339,6 +367,10 @@ static int qcom_spi_ecc_init_ctx_pipelined(struct nand_device *nand)
 		ecc_cfg->strength, ecc_cfg->step_size);
 
 	return 0;
+
+err_free_ecc_cfg:
+	kfree(ecc_cfg);
+	return ret;
 }
 
 static void qcom_spi_ecc_cleanup_ctx_pipelined(struct nand_device *nand)
-- 
2.39.5



