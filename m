Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063279;
	b=vUFstdVMhovF7ADMzKRIWFjAubnWuRxxfmD65hAXLDWgkI92Nd59BkRcBfL7LxaUwH2c
	 tN29cDhSAoCrYK58yz5oRK3Q105kxlfoohuG72sFkM9dCV+eFPus+uTdw0J8avLSnxR50
	 ZHnH3hTlhL7x9PBtIXal65X9niBNLA/JtSFfo2eG/8pWI4rO3kPJyZ6loKgZ9PAY8BpXE
	 aZO0/fku87a7+SXTRSfN+MrYcEGkNf6c1ee/kLIKquvjsSIn/5cwewkyp9p87Cp8VJScz
	 Q5DSSBd7hUjds41ezLqFluo4iZMeQOWWLTRoAdtUMqwV3rsLYXnRpRWonrmaONIFMOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qejeGeao8DxSDNTCWzD+FeaY1Q6A1tTSafBskxOXWVs=;
	b=LkNBRXvlbYN52mXhvhncrOLyE0QTo8MJqVjF0LPjNIIg8O7giFF2KJi9w1EFslZB5EWh
	 wQY4sqJjQxUHPeDNzbOoDZ65FsXksKYm5D0Kgnbiqhtsbo5kzwB3Bn8PklrmaSAQboPzF
	 wkeqGUX0kZdklZ+9zXB+ANJ+jctAiWFqHfRswKOaIUV/2qfOthATihmsVQ3KV9XlF+Ivs
	 5WFtX4KNX0MHM/OncHEGr6KenZp+wE1pXB4daAS1g6txzVC5bXH2wpIvKAHWKdqptbpCZ
	 0ag2lAP4oaNX2J9LkhfEWYFFRDKYUHeDkH9X6yFlINopdvhdwLQkxKt2O1rI4XdkvKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWkpEbMe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152D2606D803;
	Sat,  7 Nov 2026 14:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWkpEbMe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38C81F0089F;
	Sat,  7 Nov 2026 14:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063278;
	bh=qejeGeao8DxSDNTCWzD+FeaY1Q6A1tTSafBskxOXWVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWkpEbMeGiB+aOqPWeB84Hb2ByExJKEill/JLXaeAcfyyKPn0kulEU7JdxDIeAO2o
	 gOa6JDh6NlXyVpDkLBE7+F3X441OG9/bkGxg8gkG+QSPvlliEB22IFNn2Rvf1cRhDq
	 oGZO+Hs6wLFSJcXvmSTe1OhCwxmNYjTr+0ug3y/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 473/869] mtd: rawnand: qcom: fix read location register usage in config_nand_cw_read()
Date: Sat,  7 Nov 2026 08:52:35 -0500
Message-ID: <20261107134909.660719746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 94623942a66e031826756f9c92dbde9a12e2b4d2 ]

On QPIC v2 controllers, when the last codeword is being read, the read
location values must be programmed into the READ_LOCATION_LAST_CW_*
registers. Prior to commit 8c52932da5e6 ("mtd: rawnand: qcom: cleanup
qcom_nandc driver"), the config_nand_cw_read() function did it right,
but since then it always writes the read location values to the
READ_LOCATION_* registers even if the actual codeword is the last one.

Change the function to always configure the registers corresponding to
the actual codeword to restore the correct behaviour.

Cc: stable@vger.kernel.org
Fixes: 8c52932da5e6 ("mtd: rawnand: qcom: cleanup qcom_nandc driver")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/qcom_nandc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index 4dd6f1a4e7978..b469c01aacf97 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -328,14 +328,16 @@ config_nand_cw_read(struct nand_chip *chip, bool use_ecc, int cw)
 {
 	struct qcom_nand_controller *nandc = get_qcom_nand_controller(chip);
 	struct nand_ecc_ctrl *ecc = &chip->ecc;
-
 	__le32 *reg = &nandc->regs->read_location0;
+	int reg_base = NAND_READ_LOCATION_0;
 
-	if (nandc->props->qpic_version2 && qcom_nandc_is_last_cw(ecc, cw))
+	if (nandc->props->qpic_version2 && qcom_nandc_is_last_cw(ecc, cw)) {
 		reg = &nandc->regs->read_location_last0;
+		reg_base = NAND_READ_LOCATION_LAST_CW_0;
+	}
 
 	if (nandc->props->supports_bam)
-		qcom_write_reg_dma(nandc, reg, NAND_READ_LOCATION_0, 4, NAND_BAM_NEXT_SGL);
+		qcom_write_reg_dma(nandc, reg, reg_base, 4, NAND_BAM_NEXT_SGL);
 
 	qcom_write_reg_dma(nandc, &nandc->regs->cmd, NAND_FLASH_CMD, 1, NAND_BAM_NEXT_SGL);
 	qcom_write_reg_dma(nandc, &nandc->regs->exec, NAND_EXEC_CMD, 1, NAND_BAM_NEXT_SGL);
-- 
2.53.0



