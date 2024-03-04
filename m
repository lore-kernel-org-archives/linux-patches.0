Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475CE1C6AB;
	Mon,  4 Mar 2024 21:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588154; cv=none; b=jTknj6l7S9lDrdlF3uXl2N5eQKuCIJBMb9VfVxPf3HQa14Y2DCKUArfHGTB2OFC6AUEBYXvV09R4r42MNbGaJ+Yj5mftgyd7YcrZBe4v3yIB/6slckNCm2BEj3Y+I9Ke084MMI6wC/jv9mIf5Y7E4eo1hAefGs7jso2/Zzp8Dcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588154; c=relaxed/simple;
	bh=1ilBn9BjHUPKqwhgpHu/1GX8j++bvmapU14ZoiKBJVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gs7wwYOybWaddQLJuiz8MJ2/BuxXyToOzpvo1Wh58sMYPhnUy9a6PH2MTEwPOHrMmJBYaAIdj6DZLaNbYQJg7K95jTKX64mEoEJ02BdXuoHITQ9ZraQKMgpv5BnC6jvolRs0rwVZBeEiGTy/+TVHEyvn73N87OzR81zI+MyBYd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWxEZb/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWxEZb/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD220C433F1;
	Mon,  4 Mar 2024 21:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588154;
	bh=1ilBn9BjHUPKqwhgpHu/1GX8j++bvmapU14ZoiKBJVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWxEZb/tTxhXhZOAORZc/1A9C4oRiZZjmvjiXvpI6F/m8rgM+bBqM8DLw+Q4P31yW
	 XHPMmGbm4y9RExOMAYigo9yvKltoXGTclG9qw0aHAMhXd60k/SrtD3nl5hW1lkpwK7
	 LmybFqR1YDqK1osmvT2mgIhby+MuQoZyxnKj5RZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 41/42] mtd: spinand: gigadevice: fix Quad IO for GD5F1GQ5UExxG
Date: Mon,  4 Mar 2024 21:24:08 +0000
Message-ID: <20240304211539.032009668@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

From: Chuanhong Guo <gch981213@gmail.com>

commit a4f9dd55c5e1bb951db6f1dee20e62e0103f3438 upstream.

Read From Cache Quad IO (EBH) uses 2 dummy bytes on this chip according
to page 23 of the datasheet[0].

[0]: https://www.gigadevice.com/datasheet/gd5f1gq5xexxg/

Fixes: 469b99248985 ("mtd: spinand: gigadevice: Support GD5F1GQ5UExxG")
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220320100001.247905-2-gch981213@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/gigadevice.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/spi/gigadevice.c
+++ b/drivers/mtd/nand/spi/gigadevice.c
@@ -39,6 +39,14 @@ static SPINAND_OP_VARIANTS(read_cache_va
 		SPINAND_PAGE_READ_FROM_CACHE_OP_3A(true, 0, 1, NULL, 0),
 		SPINAND_PAGE_READ_FROM_CACHE_OP_3A(false, 0, 0, NULL, 0));
 
+static SPINAND_OP_VARIANTS(read_cache_variants_1gq5,
+		SPINAND_PAGE_READ_FROM_CACHE_QUADIO_OP(0, 2, NULL, 0),
+		SPINAND_PAGE_READ_FROM_CACHE_X4_OP(0, 1, NULL, 0),
+		SPINAND_PAGE_READ_FROM_CACHE_DUALIO_OP(0, 1, NULL, 0),
+		SPINAND_PAGE_READ_FROM_CACHE_X2_OP(0, 1, NULL, 0),
+		SPINAND_PAGE_READ_FROM_CACHE_OP(true, 0, 1, NULL, 0),
+		SPINAND_PAGE_READ_FROM_CACHE_OP(false, 0, 1, NULL, 0));
+
 static SPINAND_OP_VARIANTS(write_cache_variants,
 		SPINAND_PROG_LOAD_X4(true, 0, NULL, 0),
 		SPINAND_PROG_LOAD(true, 0, NULL, 0));
@@ -341,7 +349,7 @@ static const struct spinand_info gigadev
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0x51),
 		     NAND_MEMORG(1, 2048, 128, 64, 1024, 20, 1, 1, 1),
 		     NAND_ECCREQ(4, 512),
-		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
+		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants_1gq5,
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     SPINAND_HAS_QE_BIT,


