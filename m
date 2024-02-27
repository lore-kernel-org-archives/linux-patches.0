Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453E613B798;
	Tue, 27 Feb 2024 14:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044081; cv=none; b=RvPCGeYi4M55YBzzUrlpNTNBRXKzsmpS880Kvq4u1M42OGNXWwqLDjUKDGTRekNkzrSVnPz0t2HOsPl49hUi7SzSldLdnr5EibmyDftCQ/kUUFNaZLgCYMXk0WNNXHHZOtbN7RCr4fM8WUYFascc+vMGs2ElnHEMr2XI43RIhhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044081; c=relaxed/simple;
	bh=B09dAHuGtjuizEpbNCwUmHNiNB9JhoGCQR6Ihkq96JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRe6AQJ/4n4rdkDEjkoDTfRyOf05Qz7RacaxzA374IhmKTbJuYRNRkWkiEMT9SJLMsg9pw7YVj6V6gOa6jxXSjSr7MPqz1DyzlqbcnyEJ8YplODRDA35XuC77PURDcXzQiqxdHV38o+4D9mCrSqUPKoEAKO3QhmF6OXtxJy0RX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAL/5t90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAL/5t90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91B8C433F1;
	Tue, 27 Feb 2024 14:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044081;
	bh=B09dAHuGtjuizEpbNCwUmHNiNB9JhoGCQR6Ihkq96JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAL/5t90sveaArJ8emfHhy+siTiZiMHh2hEpRuxHWSTWEP6SbnFbmUeAQpcOkwSsC
	 FF1PuABl6yko0/Bv+fHgRRuyQdaNFVKkf93rTewoYALUXxyXJP/hK2MvXEDFRra4se
	 Ejqk2R/gKKALOPsf8M2T/tgAgGwQ2uu/8YV9TEzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YouChing Lin <ycllin@mxic.com.tw>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/122] mtd: spinand: macronix: Add support for MX35LFxGE4AD
Date: Tue, 27 Feb 2024 14:26:57 +0100
Message-ID: <20240227131600.541519040@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YouChing Lin <ycllin@mxic.com.tw>

[ Upstream commit 5ece78de88739b4c68263e9f2582380c1fd8314f ]

The Macronix MX35LF2GE4AD / MX35LF4GE4AD are 3V, 2G / 4Gbit serial
SLC NAND flash device (with on-die ECC).

Validated by read, erase, read back, write, read back and nandtest
on Xilinx Zynq PicoZed FPGA board which included Macronix SPI Host
(drivers/spi/spi-mxic.c).

Signed-off-by: YouChing Lin <ycllin@mxic.com.tw>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/1604561020-13499-1-git-send-email-ycllin@mxic.com.tw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/macronix.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/mtd/nand/spi/macronix.c b/drivers/mtd/nand/spi/macronix.c
index cd7a9cacc3fbf..8bd3f6bf9b103 100644
--- a/drivers/mtd/nand/spi/macronix.c
+++ b/drivers/mtd/nand/spi/macronix.c
@@ -119,6 +119,26 @@ static const struct spinand_info macronix_spinand_table[] = {
 					      &update_cache_variants),
 		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&mx35lfxge4ab_ooblayout, NULL)),
+	SPINAND_INFO("MX35LF2GE4AD",
+		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0x26),
+		     NAND_MEMORG(1, 2048, 64, 64, 2048, 40, 1, 1, 1),
+		     NAND_ECCREQ(8, 512),
+		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
+					      &write_cache_variants,
+					      &update_cache_variants),
+		     0,
+		     SPINAND_ECCINFO(&mx35lfxge4ab_ooblayout,
+				     mx35lf1ge4ab_ecc_get_status)),
+	SPINAND_INFO("MX35LF4GE4AD",
+		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0x37),
+		     NAND_MEMORG(1, 4096, 128, 64, 2048, 40, 1, 1, 1),
+		     NAND_ECCREQ(8, 512),
+		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
+					      &write_cache_variants,
+					      &update_cache_variants),
+		     0,
+		     SPINAND_ECCINFO(&mx35lfxge4ab_ooblayout,
+				     mx35lf1ge4ab_ecc_get_status)),
 	SPINAND_INFO("MX31LF1GE4BC",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0x1e),
 		     NAND_MEMORG(1, 2048, 64, 64, 1024, 20, 1, 1, 1),
-- 
2.43.0



