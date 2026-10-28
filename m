Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208813;
	b=mC8Rf0pikF5WJBnGwQLmk4NejK88EQdUpYONp6CfApvOHPDOR0fH0dReI2qAu3LU8eXf
	 Le/JaStSNUgpw0595UWoc3ECTJHGsF30U68OrgWrJpiWDnSiAAbMduL9/I6e6hQMERxFR
	 H0E5HgwqNfDQsQXmMG30bJrZ44HSebkVu3hP6mgB85pBv892JclDqqX7s9Mkv61htB1rk
	 5PH//JBdQM8UH32TCIi5Ofi3RhzPC21F22S4T2kIU54VdQqIL1Ef26SsFO/0yzd1QD4Jv
	 p7/zRd6OYptF5gjeB4bY/qqy1pZQoho3EB3qeYuS2551nMcjmyP/LpgVMQ3J0ERJ5FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=foXxKP3l+cku9kXrdQom7Cnv4Ox7TSNK17Trk8DHhMA=;
	b=tfAG6iWN071UJs9i/OKCcTw1vHCYg+2S4mLiYDi7AzgxDB7P9XV7vyVuVhZ4vVVdGMDO
	 lUj+d1ma44RgUVC/YNNLFOc+DbJr5KIshaOKt7JfJ6E1IeAohE3i/lbJhUarWz59pXCe1
	 d2BmW+C3REh6PeGPqJwRWsdNCodJ9bEHFp7UJV/UTEPLYJSL93Hi2MQIK0ZwhTORQInTS
	 NvJKksaEYIGk6teIpyKWNCFyDTrW38jtcWxmIpus0SmOc0QXY/BHHqUlyLLbFLpkseX/m
	 wQYdswN6a9Xvo0SjCn3/11JDqJIji6qOZqjnZMKykvUk5Q0qA6NSJaJ6P/92m20my9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eWkSXR6K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03A8606A327;
	Wed, 28 Oct 2026 17:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eWkSXR6K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1DA1F031E6;
	Wed, 28 Oct 2026 17:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208812;
	bh=foXxKP3l+cku9kXrdQom7Cnv4Ox7TSNK17Trk8DHhMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eWkSXR6Kx2k8DJ/sE2BkcUSQoYN+AVVGQojnZlItwVYsPsPpfJKxiW3OZtsVLEZjd
	 ic+yN2d6FLZa/BfrT/h5NXwnv9BdJp06X/qNpsYbdIQCczetekyNYsJl4kN73Et2wt
	 ogFqEi3AIq0SvOBzCr1oTwgVXyBl9ETcWp7oUUBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Karpicz <webmaster@toradex.com>,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/516] mtd: rawnand: vf610_nfc: fix false bitflips on reads of erased pages
Date: Wed, 28 Oct 2026 17:56:44 +0100
Message-ID: <20261028170009.465296060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6332e5c2765f1..4e536e53df9b7 100644
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



