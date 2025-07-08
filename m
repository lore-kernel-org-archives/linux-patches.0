Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1642E5411;
	Tue,  8 Jul 2025 16:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993527; cv=none; b=TASmyUKk1Wphm6eVzUH0o507nv4mOhxUf7m84mB3UQeZ6n60bb+YbLoIWbfN8GiHdNiHSjJo4EPwUi+KqgGx8Vyqpbvk3zTjCd3Q0WaMoosi8VUyjSjJiRIQtGxJZbKxDfBWTgaBJ5P2sHTjpLGioMv2qmqt+hsEEfxSSwonuNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993527; c=relaxed/simple;
	bh=Yjfk15MsjFXBjNBQYtJz7PuGALF3BX3OIm0Z79ee2f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kML5WfG6LyYcO51eEahOCeGMYs4pKfjejDxmXblb59flo1bBRdU8q9vNkqAzFZcoSpU4k1bHcVCtKuT6I/Kwt4HL+ECoe4QDRXEUTV0npn4MF2eqOt88brTypDkJ2B9r/EPupQjBtM/H/aSiROTl9KVC4bQx0UG9hg09PjCHOgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz7lnUry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz7lnUry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0580AC4CEED;
	Tue,  8 Jul 2025 16:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993527;
	bh=Yjfk15MsjFXBjNBQYtJz7PuGALF3BX3OIm0Z79ee2f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vz7lnUryR7MQIeUbnEAGO/fcfrQojteC0hYF9YnLRuWkEgTaHgxzwZZdtNxs1CA2G
	 Oaaa3WuqGCCNMSp4dGqUJ4Ks5YakiqeT2UI3VDNmVozcrFPW/JKqLSMSzIIv3tlrUH
	 qB7XFEftBv9zrIEwaeOIYW2bKkCyLf5MQLRo1xvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 074/178] spi: spi-qpic-snand: reallocate BAM transactions
Date: Tue,  8 Jul 2025 18:21:51 +0200
Message-ID: <20250708162238.609019913@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

[ Upstream commit d85d0380292a7e618915069c3579ae23c7c80339 ]

Using the mtd_nandbiterrs module for testing the driver occasionally
results in weird things like below.

1. swiotlb mapping fails with the following message:

  [   85.926216] qcom_snand 79b0000.spi: swiotlb buffer is full (sz: 4294967294 bytes), total 512 (slots), used 0 (slots)
  [   85.932937] qcom_snand 79b0000.spi: failure in mapping desc
  [   87.999314] qcom_snand 79b0000.spi: failure to write raw page
  [   87.999352] mtd_nandbiterrs: error: write_oob failed (-110)

  Rebooting the board after this causes a panic due to a NULL pointer
  dereference.

2. If the swiotlb mapping does not fail, rebooting the board may result
   in a different panic due to a bad spinlock magic:

  [  256.104459] BUG: spinlock bad magic on CPU#3, procd/2241
  [  256.104488] Unable to handle kernel paging request at virtual address ffffffff0000049b
  ...

Investigating the issue revealed that these symptoms are results of
memory corruption which is caused by out of bounds access within the
driver.

The driver uses a dynamically allocated structure for BAM transactions,
which structure must have enough space for all possible variations of
different flash operations initiated by the driver. The required space
heavily depends on the actual number of 'codewords' which is calculated
from the pagesize of the actual NAND chip.

Although the qcom_nandc_alloc() function allocates memory for the BAM
transactions during probe, but since the actual number of 'codewords'
is not yet know the allocation is done for one 'codeword' only.

Because of this, whenever the driver does a flash operation, and the
number of the required transactions exceeds the size of the allocated
arrays the driver accesses memory out of the allocated range.

To avoid this, change the code to free the initially allocated BAM
transactions memory, and allocate a new one once the actual number of
'codewords' required for a given NAND chip is known.

Fixes: 7304d1909080 ("spi: spi-qpic: add driver for QCOM SPI NAND flash Interface")
Reviewed-by: Md Sadre Alam <quic_mdalam@quicinc.com>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://patch.msgid.link/20250618-qpic-snand-avoid-mem-corruption-v3-1-319c71296cda@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qpic-snand.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index d3a4e091dca4e..80856d2fa35c6 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -316,6 +316,22 @@ static int qcom_spi_ecc_init_ctx_pipelined(struct nand_device *nand)
 
 	mtd_set_ooblayout(mtd, &qcom_spi_ooblayout);
 
+	/*
+	 * Free the temporary BAM transaction allocated initially by
+	 * qcom_nandc_alloc(), and allocate a new one based on the
+	 * updated max_cwperpage value.
+	 */
+	qcom_free_bam_transaction(snandc);
+
+	snandc->max_cwperpage = cwperpage;
+
+	snandc->bam_txn = qcom_alloc_bam_transaction(snandc);
+	if (!snandc->bam_txn) {
+		dev_err(snandc->dev, "failed to allocate BAM transaction\n");
+		ret = -ENOMEM;
+		goto err_free_ecc_cfg;
+	}
+
 	ecc_cfg->cfg0 = FIELD_PREP(CW_PER_PAGE_MASK, (cwperpage - 1)) |
 			FIELD_PREP(UD_SIZE_BYTES_MASK, ecc_cfg->cw_data) |
 			FIELD_PREP(DISABLE_STATUS_AFTER_WRITE, 1) |
-- 
2.39.5



