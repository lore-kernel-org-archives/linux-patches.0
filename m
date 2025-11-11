Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42364C97;
	Tue, 11 Nov 2025 00:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822536; cv=none; b=P4kIvs+oXuG0bUfL/hON4c0uiWveU48Oql4itwtLdFvyodS7/SAJ9scJvJEm/ofD6Jr3gVwcvjum51VR4ou4/En3AD154XpCVeT7TrtUSKbF9yB96AGG8j8qrqPWZW312Uwqi1L1+60NATXr3ONrzX+5BTxZFzasxTtNapnQcV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822536; c=relaxed/simple;
	bh=xULsslHUPj45kgDuifVkKabVLoFmzHXkiW9mnmczbtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDF5ei3uW8d93S8oOCIjSJVIJLuxCMYshp98QHoywf3DmGpOsK1f4DkQYpozbMAamfZTSWsoQaBILvaHsIaGPnoi9yP5/4jf+M55D/PKK8+NO2nkM+L9Qb+U6qnsDr0vs9rz68eOtjXQ4t7+BKvrs7Grt0fRJXc0VIBa7mgbchE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsVxDx5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsVxDx5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6363EC19425;
	Tue, 11 Nov 2025 00:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822536;
	bh=xULsslHUPj45kgDuifVkKabVLoFmzHXkiW9mnmczbtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsVxDx5r41CJvVmmH+aYUlRVAwIQwBU9PZn1GLv7J9qsq2jg9/wUw9qorFJKlY/Ch
	 E2g+93T9ROroRaxAzRqzJV/EkvkCVDR6F6S40h7yTjV+UE8FdOVQO7EBpoD/wtctw2
	 3EOuCBBlzx1gZcHjkBYVqAtE1i91DRreVQlzBfPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 122/849] spi: spi-qpic-snand: handle use_ecc parameter of qcom_spi_config_cw_read()
Date: Tue, 11 Nov 2025 09:34:52 +0900
Message-ID: <20251111004539.346972829@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 9c45f95222beecd6a284fd1284d54dd7a772cf59 ]

During raw read, neither the status of the ECC correction nor the erased
state of the codeword gets checked by the qcom_spi_read_cw_raw() function,
so in case of raw access reading the corresponding registers via DMA is
superfluous.

Extend the qcom_spi_config_cw_read() function to evaluate the existing
(but actually unused) 'use_ecc' parameter, and configure reading only
the flash status register when ECC is not used.

With the change, the code gets in line with the corresponding part of
the config_nand_cw_read() function in the qcom_nandc driver.

Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20250808-qpic-snand-handle-use_ecc-v1-1-67289fbb5e2f@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qpic-snand.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index 780abb967822a..5a247eebde4d9 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -494,9 +494,14 @@ qcom_spi_config_cw_read(struct qcom_nand_controller *snandc, bool use_ecc, int c
 	qcom_write_reg_dma(snandc, &snandc->regs->cmd, NAND_FLASH_CMD, 1, NAND_BAM_NEXT_SGL);
 	qcom_write_reg_dma(snandc, &snandc->regs->exec, NAND_EXEC_CMD, 1, NAND_BAM_NEXT_SGL);
 
-	qcom_read_reg_dma(snandc, NAND_FLASH_STATUS, 2, 0);
-	qcom_read_reg_dma(snandc, NAND_ERASED_CW_DETECT_STATUS, 1,
-			  NAND_BAM_NEXT_SGL);
+	if (use_ecc) {
+		qcom_read_reg_dma(snandc, NAND_FLASH_STATUS, 2, 0);
+		qcom_read_reg_dma(snandc, NAND_ERASED_CW_DETECT_STATUS, 1,
+				  NAND_BAM_NEXT_SGL);
+	} else {
+		qcom_read_reg_dma(snandc, NAND_FLASH_STATUS, 1,
+				  NAND_BAM_NEXT_SGL);
+	}
 }
 
 static int qcom_spi_block_erase(struct qcom_nand_controller *snandc)
-- 
2.51.0



