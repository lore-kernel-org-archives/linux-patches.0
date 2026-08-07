Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85453422531;
	Fri,  7 Aug 2026 15:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117422; cv=none; b=pk2mJIaf6k5/ZEDL5RBW42npLPDqatgmiQPPZg0EgPwHwkrgyV0BmStQKaEDOxilsI/2F2m+yxySMsDzjh5L+3ZT5FtFVeEK1fhmSt2x3cwwAy+nLn5VrGkzKGckmR0Mt7e4uLIsvlqxf5wedLOty99s1OA1appBSvZiW4umcSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117422; c=relaxed/simple;
	bh=YAn6nKXHcvAUaOzWs1swDcY1Uor1K7WLTCgadbJQa44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xzn/nHmU8iLraoQSXywV92KDHEo1XOCwLHsUeJcAjONBi6AMmZJP6iXFtRmZS+s6KfjFadp72EZ9BWeQK2RuHplYAed2UIDCdtBCeBK+Z0Rw5miZVkSM3ZZkMlh++Uqam4FZIxj6V0LFf2fDQC4zs8oPD337bvXlEW0vNDGjAnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HA6aGC1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HA6aGC1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6A81F000E9;
	Fri,  7 Aug 2026 15:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117421;
	bh=dWAkqqRfRL9SNYJu+7ppA82ZmItMpKgcGZOfG52xM7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HA6aGC1AmXG87teB+Gn8enY3LnY4Utxq9M9Bn56aS8Sj8GECcDjIT3h9xprzUcMmp
	 RvhNnKXUE0E4PDmMkhd1VHCMSLFW7H5XlMcR8oneTaPD8w6SXxG6UMfAr9evK6n3qV
	 e8MPX66ZEJIA4JAurvo/ci12fskRbJgfNmyEJ6PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Pal <kuncy7@gmail.com>,
	Md Sadre Alam <md.alam@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 314/438] spi: spi-qpic-snand: write the feature value before executing SET_FEATURE
Date: Fri,  7 Aug 2026 16:38:30 +0200
Message-ID: <20260807143434.663067484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Pal <kuncy7@gmail.com>

commit 8fd62901d6bf03f274a49dd0060793cc07dd51b0 upstream.

qcom_spi_send_cmdaddr() programs NAND_FLASH_CMD/NAND_EXEC_CMD and submits
the descriptors, which makes the controller execute the command
immediately. For SPINAND_SET_FEATURE the value to be written is only
placed into NAND_FLASH_FEATURES afterwards, by qcom_spi_io_op(), in a
second submission - so the chip is programmed with whatever that register
happened to hold from a previous operation, and the intended value is only
applied by the *next* SET_FEATURE.

Measured on a TP-Link Archer AX55 v1 (IPQ5018, ESMT F50L1G41LB): writing
0x40 to the configuration register (0xb0) leaves the chip at 0x00, and the
subsequent write of 0x00 leaves it at 0x40 - every write lands one
operation late.

This stayed unnoticed until v6.18 added SPI-NAND OTP support together
with OTP entries for ESMT chips. spinand_otp_rw() enables OTP mode,
reads, and disables it again, and mtd_otp_nvmem_add() does this during
MTD registration. With the off-by-one, the "disable" write actually
applies the previously requested value, so CFG_OTP_ENABLE ends up set:
the chip stays in OTP mode, every subsequent array read returns the OTP
area instead of the array (UBI reports an empty device) and all writes
fail with -EIO because the OTP area is write protected. On this board
that makes the whole flash unusable and the device unbootable.

Write the feature value into NAND_FLASH_FEATURES as part of the same
transaction, before NAND_EXEC_CMD. While at it, copy only the bytes the
operation actually carries - the previous code dereferenced a 4-byte
pointer on a one-byte buffer (spinand->scratchbuf).

With this patch the flash contents read back bit-identical to a
known-good dump of the same board taken under the vendor firmware
(md5-verified across partitions), and writes work.

Fixes: 7304d1909080 ("spi: spi-qpic: add driver for QCOM SPI NAND flash Interface")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Pal <kuncy7@gmail.com>
Reviewed-by: Md Sadre Alam <md.alam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260727163216.109938-1-kuncy7@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-qpic-snand.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -1358,6 +1358,22 @@ static int qcom_spi_send_cmdaddr(struct
 	snandc->regs->addr0 = cpu_to_le32(op->addr.val);
 	snandc->regs->addr1 = cpu_to_le32(0);
 
+	/*
+	 * The feature value has to reach NAND_FLASH_FEATURES before the
+	 * command is executed, otherwise the controller programs the chip
+	 * with whatever the register happened to hold from a previous
+	 * operation.
+	 */
+	if (opcode == SPINAND_SET_FEATURE) {
+		u32 ftr = 0;
+
+		memcpy(&ftr, op->data.buf.out,
+		       min_t(size_t, op->data.nbytes, sizeof(ftr)));
+		snandc->regs->flash_feature = cpu_to_le32(ftr);
+		qcom_write_reg_dma(snandc, &snandc->regs->flash_feature,
+				   NAND_FLASH_FEATURES, 1, NAND_BAM_NEXT_SGL);
+	}
+
 	qcom_write_reg_dma(snandc, &snandc->regs->cmd, NAND_FLASH_CMD, 3, NAND_BAM_NEXT_SGL);
 	qcom_write_reg_dma(snandc, &snandc->regs->exec, NAND_EXEC_CMD, 1, NAND_BAM_NEXT_SGL);
 
@@ -1395,10 +1411,8 @@ static int qcom_spi_io_op(struct qcom_na
 		copy_ftr = true;
 		break;
 	case SPINAND_SET_FEATURE:
-		snandc->regs->flash_feature = cpu_to_le32(*(u32 *)op->data.buf.out);
-		qcom_write_reg_dma(snandc, &snandc->regs->flash_feature,
-				   NAND_FLASH_FEATURES, 1, NAND_BAM_NEXT_SGL);
-		break;
+		/* fully handled by qcom_spi_send_cmdaddr() */
+		return 0;
 	case SPINAND_PROGRAM_EXECUTE:
 	case SPINAND_WRITE_EN:
 	case SPINAND_RESET:


