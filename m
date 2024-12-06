Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A05A14A4F0;
	Fri,  6 Dec 2024 14:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496184; cv=none; b=AbTm8VidYZzLdxb1nQvpqaqPweB1Ae2wDIDQ/O3sDQwcuw2C9q1CFRO0vAiCOoWlnxtUjcXYBJnaXLRbLNMWHzscnHcLrC4RCTJo+MseroZO/54WKZCt1njWKQnlxUbIRr+mIGBKP/xuOPjbva7Y4VLaZ2U3faFVoz+KbpXRYew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496184; c=relaxed/simple;
	bh=iE5DPlyIwq3ScdzMOcayj8t0eKBKbCDNiCLnk/Eg0MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRWjDx/SIwava+X0ZcUj5PtxMMN/dcnoDmg8ZoH/nWa2JgzIQgtHIp/hqjai0FMARfrUxkmqPKf0RSEof32F9YZEQ+m1uJT0jD0VwtCTTA8q86yH1oP83UBlOWCOt5BXUJ50eftB45K5arop1GA0DUTJ57e+V82iC4gO9sJExBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDV+7EgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDV+7EgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB15EC4CED1;
	Fri,  6 Dec 2024 14:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496184;
	bh=iE5DPlyIwq3ScdzMOcayj8t0eKBKbCDNiCLnk/Eg0MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDV+7EgRctyEOpUCeA+VnQWLvbyalB5xkkJOVIjtQEynMR+PtGJhBSZBXXwgDl8Mz
	 3sHdIVftG/yPE/TNzCigLs6hlqdLw3dl3XdFXPA5EhZ54NIsIbxxLam91orqzuQQSE
	 TcC9gqSsuFfXUU+G5Gb/pkBb/+thOBf54qlaF2YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: [PATCH 6.12 075/146] mtd: spinand: winbond: Fix 512GW, 01GW, 01JW and 02JW ECC information
Date: Fri,  6 Dec 2024 15:36:46 +0100
Message-ID: <20241206143530.551608019@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit fee9b240916df82a8b07aef0fdfe96785417a164 upstream.

These four chips:
* W25N512GW
* W25N01GW
* W25N01JW
* W25N02JW
all require a single bit of ECC strength and thus feature an on-die
Hamming-like ECC engine. There is no point in filling a ->get_status()
callback for them because the main ECC status bytes are located in
standard places, and retrieving the number of bitflips in case of
corrected chunk is both useless and unsupported (if there are bitflips,
then there is 1 at most, so no need to query the chip for that).

Without this change, a kernel warning triggers every time a bit flips.

Fixes: 6a804fb72de5 ("mtd: spinand: winbond: add support for serial NAND flash")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/linux-mtd/20241009125002.191109-3-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/winbond.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -201,30 +201,30 @@ static const struct spinand_info winbond
 	SPINAND_INFO("W25N01JW",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xbc, 0x21),
 		     NAND_MEMORG(1, 2048, 64, 64, 1024, 20, 1, 1, 1),
-		     NAND_ECCREQ(4, 512),
+		     NAND_ECCREQ(1, 512),
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     0,
-		     SPINAND_ECCINFO(&w25m02gv_ooblayout, w25n02kv_ecc_get_status)),
+		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL)),
 	SPINAND_INFO("W25N02JWZEIF",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xbf, 0x22),
 		     NAND_MEMORG(1, 2048, 64, 64, 1024, 20, 1, 2, 1),
-		     NAND_ECCREQ(4, 512),
+		     NAND_ECCREQ(1, 512),
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     0,
-		     SPINAND_ECCINFO(&w25m02gv_ooblayout, w25n02kv_ecc_get_status)),
+		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL)),
 	SPINAND_INFO("W25N512GW",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xba, 0x20),
 		     NAND_MEMORG(1, 2048, 64, 64, 512, 10, 1, 1, 1),
-		     NAND_ECCREQ(4, 512),
+		     NAND_ECCREQ(1, 512),
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     0,
-		     SPINAND_ECCINFO(&w25m02gv_ooblayout, w25n02kv_ecc_get_status)),
+		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL)),
 	SPINAND_INFO("W25N02KWZEIR",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xba, 0x22),
 		     NAND_MEMORG(1, 2048, 128, 64, 2048, 40, 1, 1, 1),
@@ -237,12 +237,12 @@ static const struct spinand_info winbond
 	SPINAND_INFO("W25N01GWZEIG",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xba, 0x21),
 		     NAND_MEMORG(1, 2048, 64, 64, 1024, 20, 1, 1, 1),
-		     NAND_ECCREQ(4, 512),
+		     NAND_ECCREQ(1, 512),
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     0,
-		     SPINAND_ECCINFO(&w25m02gv_ooblayout, w25n02kv_ecc_get_status)),
+		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL)),
 	SPINAND_INFO("W25N04KV",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xaa, 0x23),
 		     NAND_MEMORG(1, 2048, 128, 64, 4096, 40, 2, 1, 1),


