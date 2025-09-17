Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78790330D39;
	Wed, 17 Sep 2025 12:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113565; cv=none; b=YK5mcp/qfUHaq+E5HxKfKnNW5kDHHrJH3zjjVtbbBCr7Ukw0HSJ/3ECqwoOG1WR5GUzbnUPUnXZvzroyVsBhElzgD4YsyIpXcY4K9KU4dfyE3zoPCZF3NYj89tswOA18M5YoybNXurQsndpYXJrlcku4cpgVjK8isYftQ99UxHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113565; c=relaxed/simple;
	bh=Ms4lgE9LI13RbzWgX+YPYY46Rm+YSOeKO62tMe7yTaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbI0cc4RWUGAxiwUhinvTd1+RXIUkIm6/oyiCh6U8VmHEA3F/kTYfNHJTFEDuHdVMKUL0EL9VLOlPNY3SBEV9fZrpM1CpxvrxcCCm83xchduWow691yVyU26lBpgIGaLm2Hp4N9MT4OzOH5vSPkhchoISXe+kaWp8fh9aERPTe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybeXdx32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybeXdx32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6484C4CEF5;
	Wed, 17 Sep 2025 12:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113565;
	bh=Ms4lgE9LI13RbzWgX+YPYY46Rm+YSOeKO62tMe7yTaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybeXdx32ltte1PLeHpkgDvrR7o57y7niNxJ0Jx6XLHt3WORlj3wuyxi83G5QHow3r
	 KNz0gmoIoCFXEWhjYl6XBJ5shBajAuudV5L9TTez+wddo+iGyb1dwP7ig9j/0+uObV
	 x06/ZS+ICFOO8lim1U6lgjPWnCWp0GT/vGHeXJKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sridharan S N <quic_sridsn@quicinc.com>,
	Santhosh Kumar K <s-k6@ti.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/140] mtd: spinand: winbond: Fix oob_layout for W25N01JW
Date: Wed, 17 Sep 2025 14:34:14 +0200
Message-ID: <20250917123346.314333959@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santhosh Kumar K <s-k6@ti.com>

[ Upstream commit 4550d33e18112a11a740424c4eec063cd58e918c ]

Fix the W25N01JW's oob_layout according to the datasheet [1]

[1] https://www.winbond.com/hq/product/code-storage-flash-memory/qspinand-flash/?__locale=en&partNo=W25N01JW

Fixes: 6a804fb72de5 ("mtd: spinand: winbond: add support for serial NAND flash")
Cc: Sridharan S N <quic_sridsn@quicinc.com>
Cc: stable@vger.kernel.org
Signed-off-by: Santhosh Kumar K <s-k6@ti.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/winbond.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -122,6 +122,41 @@ static const struct mtd_ooblayout_ops w2
 	.free = w25n02kv_ooblayout_free,
 };
 
+static int w25n01jw_ooblayout_ecc(struct mtd_info *mtd, int section,
+				  struct mtd_oob_region *region)
+{
+	if (section > 3)
+		return -ERANGE;
+
+	region->offset = (16 * section) + 12;
+	region->length = 4;
+
+	return 0;
+}
+
+static int w25n01jw_ooblayout_free(struct mtd_info *mtd, int section,
+				   struct mtd_oob_region *region)
+{
+	if (section > 3)
+		return -ERANGE;
+
+	region->offset = (16 * section);
+	region->length = 12;
+
+	/* Extract BBM */
+	if (!section) {
+		region->offset += 2;
+		region->length -= 2;
+	}
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops w25n01jw_ooblayout = {
+	.ecc = w25n01jw_ooblayout_ecc,
+	.free = w25n01jw_ooblayout_free,
+};
+
 static int w25n02kv_ecc_get_status(struct spinand_device *spinand,
 				   u8 status)
 {
@@ -206,7 +241,7 @@ static const struct spinand_info winbond
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     0,
-		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL)),
+		     SPINAND_ECCINFO(&w25n01jw_ooblayout, NULL)),
 	SPINAND_INFO("W25N02JWZEIF",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xbf, 0x22),
 		     NAND_MEMORG(1, 2048, 64, 64, 1024, 20, 1, 2, 1),


