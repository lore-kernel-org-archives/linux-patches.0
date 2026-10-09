Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DB581ACD;
	Fri,  9 Oct 2026 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557601; cv=none; b=pqDSG7jYSaaD+QjGM5fi9CCK/ilAAM9QNc/3InkPkNA29OqrUL6coHSSDYHQXKsOfTHOpWhPtsxnJwzydYzaTQ73mmOL7tHWgrOruc6xYbKhUlV1+KNsS8QTZXovgz6mnSzG0QkO85kzWv97uU6iJuMdFbJqggA+2kLddxaOoPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557601; c=relaxed/simple;
	bh=pIVZcNG/SuZbom5p3JniWg9HN/w3uHKu+iBLJYCEVY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=butPN3tVzTzu8fA6AbDynQDA5Chzx3vtyYAzMP6wh7fGO70hnWGVs/9r+0EcJjEugXpZebsgD0k3ho6CowtnEXNypozj1WamZlUmt72j9WALK7sfiH4v8pLFlGAplIl/seuHnf0XrhCnFZJ6/DdgS2/QoTIW5aQvZVg39tYa8gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnaGXPmY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnaGXPmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F53E1F000FF;
	Fri,  9 Oct 2026 14:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557600;
	bh=vNmRv5IVRBAMFUzs6BLWbAjkXysrzZuraTLzVp8ki4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnaGXPmYH9k0iYgEbkD7LEgo5k5lIqUuHUQfC1klxP5PpXqFGBgEegYm2VviRO5o4
	 kZpj0N4y7wgEEVZvzJY75JpNuXH2ISXgva2Gf41peAn54B78bjSRjZH9juYktBXabj
	 kL/2cuZvwOaSaEDv5HqTfLoKCNG0vY9lvgaqw03Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Karpicz <webmaster@toradex.com>,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 416/428] mtd: rawnand: vf610_nfc: fix false bitflips on reads of erased pages
Date: Fri,  9 Oct 2026 16:12:33 +0200
Message-ID: <20261009140955.371631680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

[ Upstream commit 68fe2faf5c69d0e21f94cd695d28f0ba677d484f ]

When the ECC engine fails to decode a page, the driver re-reads the OOB
area with the engine bypassed, but runs the erased-page check for the
data area on the buffer left in the controller SRAM by the failed
transfer.

That buffer does not hold what is on the flash: the failing engine
writes a bogus single-bit "correction" into it. In the 60-byte ECC mode
the all-0xff content of an erased page always decodes to the same error
location, so every erased page shows one stale zero bit at data offset
0x5FD, which the erased-page check then reports as a corrected bitflip.

Edward Karpicz discovered this behaviour and identified the offset on a
Colibri VF61; the analysis and the fix build on his finding. Measured
with an instrumented driver on a Colibri VF50 (MX30LF1G18AC, 32-bit
ECC): reading a 126 MiB partition with nanddump increased the corrected
counter by 18035, exactly one per erased page, while raw reads of the
same pages return clean 0xff. A v4.4 kernel on the VF61 (MX30LF4G28AC)
accumulates the same false counts, so the behaviour follows the
controller rather than the chip or the driver generation. Neither the
Vybrid reference manual nor the published mask set errata (VFXXX_2N02G)
document it. The 45-byte ECC mode is not affected.

Restoring the known byte is not enough: on pages that fail to decode
with content other than all-0xff the engine writes its correction
wherever the syndrome points (measured at a different offset on such a
page), so the check has to run on what the flash holds. Re-read the data
area with the ECC engine bypassed, exactly as already done for the OOB
area. The corrected counter then stays at zero on both boards.

Reported-by: Edward Karpicz <webmaster@toradex.com>
Link: https://community.toradex.com/t/colibri-vf50-vf61-on-the-current-bsp-mainline-u-boot-v2026-07-and-linux-6-18-lts/30735
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/vf610_nfc.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/vf610_nfc.c b/drivers/mtd/nand/raw/vf610_nfc.c
index 1c3e7b167e533..1b9b370adfab6 100644
--- a/drivers/mtd/nand/raw/vf610_nfc.c
+++ b/drivers/mtd/nand/raw/vf610_nfc.c
@@ -519,6 +519,7 @@ static inline int vf610_nfc_correct_data(struct nand_chip *chip, uint8_t *dat,
 	u8 ecc_status;
 	u8 ecc_count;
 	int flips_threshold = nfc->chip.ecc.strength / 2;
+	int ret;
 
 	ecc_status = vf610_nfc_read(nfc, ecc_status_off) & 0xff;
 	ecc_count = ecc_status & ECC_STATUS_ERR_COUNT;
@@ -526,15 +527,21 @@ static inline int vf610_nfc_correct_data(struct nand_chip *chip, uint8_t *dat,
 	if (!(ecc_status & ECC_STATUS_MASK))
 		return ecc_count;
 
+	/* The failed decode leaves a bogus correction in SRAM; re-read without ECC */
 	nfc->data_access = true;
-	nand_read_oob_op(&nfc->chip, page, 0, oob, vf610_nfc_spare_size(mtd));
+	ret = nand_read_page_op(&nfc->chip, page, 0, dat, mtd->writesize);
+	if (!ret)
+		ret = nand_read_oob_op(&nfc->chip, page, 0, oob,
+				       vf610_nfc_spare_size(mtd));
 	nfc->data_access = false;
+	if (ret)
+		return ret;
 
 	/*
-	 * On an erased page, bit count (including OOB) should be zero or
-	 * at least less then half of the ECC strength.
+	 * Run the erased-page check with the driver's historic threshold
+	 * of half the ECC strength.
 	 */
-	return nand_check_erased_ecc_chunk(dat, nfc->chip.ecc.size, oob,
+	return nand_check_erased_ecc_chunk(dat, mtd->writesize, oob,
 					   vf610_nfc_spare_size(mtd), NULL, 0,
 					   flips_threshold);
 }
-- 
2.53.0



