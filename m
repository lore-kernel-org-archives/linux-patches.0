Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AC11EF36C;
	Wed, 17 Sep 2025 12:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113037; cv=none; b=J9ZW9lNk4PCZ+wxBqc/+XcITTr8V0kDQAiNY8rco7blLfVo4rTBp46sc7MXNCHFKo253vdhZ1Fqs9DQ4CqWPvNOKdCpp9PxFtcT29ioK82EnVCW9LVjzXvo1qJiMhp+Mfk72y8vufZmaAVaE5yDzD9I/RPzWam8gD2ZVh8fte30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113037; c=relaxed/simple;
	bh=00teFDujugHzMCAxUhpAuS72xLRco5mmJAuW6GP1Lu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pF7GiHuBiuhdfoBGKnLI/ohzdsogU/IIFalWaH6z/biQNox0PNCtUwH4UMBoQVynDWVvHUUDgJMPK3KZ431md0COm7y+nmplEQwkEfazZVfoLLkw1Vl1PusIQxjCddbtnnR1rP44HLjM5nPtjplClGszrBB5xmLllSjjwFzgS1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leWazWKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leWazWKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8254C4CEF0;
	Wed, 17 Sep 2025 12:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113037;
	bh=00teFDujugHzMCAxUhpAuS72xLRco5mmJAuW6GP1Lu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leWazWKz4YJiZ3kdUTeqRm+beaEKK03FFfrawSStcpQrY6Geajs1TgAnr98073Llj
	 bxdcy2LkcFyGEZod0JTMfzTAXOMXZ2tgec1qAHrrqtMFsmsvdRHoPvc4BeFbwbZl3i
	 ZBcf5eUXk9m7g2hLzh1pBfWB7xDoTMnTSJVpkUco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sridharan S N <quic_sridsn@quicinc.com>,
	Santhosh Kumar K <s-k6@ti.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 107/189] mtd: spinand: winbond: Fix oob_layout for W25N01JW
Date: Wed, 17 Sep 2025 14:33:37 +0200
Message-ID: <20250917123354.482488939@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/winbond.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -162,6 +162,36 @@ static const struct mtd_ooblayout_ops w2
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
 static int w35n01jw_ooblayout_ecc(struct mtd_info *mtd, int section,
 				  struct mtd_oob_region *region)
 {
@@ -192,6 +222,11 @@ static int w35n01jw_ooblayout_free(struc
 	return 0;
 }
 
+static const struct mtd_ooblayout_ops w25n01jw_ooblayout = {
+	.ecc = w25n01jw_ooblayout_ecc,
+	.free = w25n01jw_ooblayout_free,
+};
+
 static const struct mtd_ooblayout_ops w35n01jw_ooblayout = {
 	.ecc = w35n01jw_ooblayout_ecc,
 	.free = w35n01jw_ooblayout_free,
@@ -307,7 +342,7 @@ static const struct spinand_info winbond
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     0,
-		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL),
+		     SPINAND_ECCINFO(&w25n01jw_ooblayout, NULL),
 		     SPINAND_CONFIGURE_CHIP(w25n0xjw_hs_cfg)),
 	SPINAND_INFO("W25N01KV", /* 3.3V */
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xae, 0x21),


