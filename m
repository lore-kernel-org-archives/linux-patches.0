Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353A73AE198;
	Sat, 17 Oct 2026 17:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256815; cv=none; b=tH2lM2d1BwYdeMqDYC0LK/SK31ezkyiys0xEI0ar5qxJLZO6aBtqLOWLPQJAf6vfR/D8UQKhNfzTLcSrJSuQFmJF8UmvTg0l4TgzBiZy2FAK+q6qV5X51nSA/2d8rapATTtBuJ977I7Q0HU7xW9n2D0RBmu0NAuldGQD8DfquZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256815; c=relaxed/simple;
	bh=hioRnIUrA0zkUq1lnzGkGZpvfC1b0sa9HntgpKS8yb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWQbnTg5PNHU9Ux/AE0i0qjJVqu8INUFnxa79S6zkzFiRN2MAckiv1BPjoAIU34d9f9ue3RmW7slsZFfJZRtAft163quYxvNnw6vDTZOW5gca48i3YR8oawmEPqh4l5cT59tubVTeqxFdmIFhCc/4Cfda+3DQJUTN1cWEG454Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbZIbYqv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbZIbYqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA83D1F000C4;
	Sat, 17 Oct 2026 17:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256813;
	bh=0ClAoRUfEfGWIsMX4S/6pBvfdxRY9RFspoZI/ZFYDQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WbZIbYqv5VVljUVZEOfGyRv1TZRSVIvI4Gatk37/sPrSsQBir0EL1otfOZRC5VC3K
	 v1VGzfUox54so2U2E0WspGH/E8imKrjjZiaOBnr5OBJ/5KNb7Odc6MmMUYmAbOQDyM
	 lhjCCTK29VvHtYhcYmrmjf9MWpBYs5gxgutDgr+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Karpicz <webmaster@toradex.com>,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0360/1674] mtd: rawnand: vf610_nfc: fix false bitflips on reads of erased pages
Date: Sat, 17 Oct 2026 17:43:52 +0200
Message-ID: <20261017160440.361990877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6dbdd9fb5f865..243c43c3dc02c 100644
--- a/drivers/mtd/nand/raw/vf610_nfc.c
+++ b/drivers/mtd/nand/raw/vf610_nfc.c
@@ -518,6 +518,7 @@ static inline int vf610_nfc_correct_data(struct nand_chip *chip, uint8_t *dat,
 	u8 ecc_status;
 	u8 ecc_count;
 	int flips_threshold = nfc->chip.ecc.strength / 2;
+	int ret;
 
 	ecc_status = vf610_nfc_read(nfc, ecc_status_off) & 0xff;
 	ecc_count = ecc_status & ECC_STATUS_ERR_COUNT;
@@ -525,15 +526,21 @@ static inline int vf610_nfc_correct_data(struct nand_chip *chip, uint8_t *dat,
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



