Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B972D370D54;
	Wed, 20 May 2026 17:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298606; cv=none; b=MyT+gYVJTg0OcagvMIUopIQ1NfADgFf+fAy0PFr2eBDcout/3nPQFEIqCfQRs7X9ZahRpfgNwlITNQkCP0hmNfsFsL0Q/AS1rlutCAzj+qaGQtg5XreEPlOQJpJ1QKIRETeBZ+u6aPG+B9rf6FjOgEQxmzt2McWWmqkAVtVvsN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298606; c=relaxed/simple;
	bh=u7cY0Q6vkb/AGANRJ7zsn8LJHbTEs0iwt4x07HE1oS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehyP2s9c0M2tYs0+B4TNpPcQpaaCZNJSyq05ZEawN+Qgv7jtbmAGYo0aKNRl6kDwCN/Arc8OF0jBVXo0k4/37QKITW7s8UmRT1Nk17oMxTEHKV/4vQneGlhFjkchkJa0dQ4MUWN0KE4lzCrCaRcONsbBH6D5fyCO9PKD25wIc3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydgAT3rH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydgAT3rH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0FF1F000E9;
	Wed, 20 May 2026 17:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298604;
	bh=EzTphhO+6UHF2kiJ4p2tZ3URkmU8EYs66tQJYi0z5ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydgAT3rHikNs137grwHgotVhOl8PMgACc378eSqxP1llfbdqVS+eRgn1CT1Xf3Qt8
	 uuV3azaCQLBCpkkf4k6z8dE7sZsPzXYsHrnh2srobYGNLJ4P5nlCVq0xHJJt/51XQ8
	 TX4dgL1ZDd2F3eOjHBcrI3ETl9JKk3KprNQFqXoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Richard Genoud <richard.genoud@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 473/957] mtd: rawnand: sunxi: fix sunxi_nfc_hw_ecc_read_extra_oob
Date: Wed, 20 May 2026 18:15:56 +0200
Message-ID: <20260520162144.783990694@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Genoud <richard.genoud@bootlin.com>

[ Upstream commit 848c13996c55fe4ea6bf5acc3ce6c8c5c944b5f6 ]

When dumping the OOB, the bytes at the end where actually copied from
the beginning of the OOB instead of current_offset.

That leads to something like:
OOB: ff ff ff ff ff ff ff ff ea 19 00 3a 83 db aa 8d
OOB: 99 09 c8 9a 90 36 35 7d aa 15 13 07 3d 97 b2 a4
OOB: a8 bb 19 b3 07 e9 f6 25 52 d7 1a 23 e2 7e 0a e4
OOB: 52 8a 09 d2 1a 86 3d cf b4 99 43 13 d3 90 33 0b
OOB: ff ff ff ff ff ff ff ff ea 19 00 3a 83 db aa 8d
OOB: 99 09 c8 9a 90 36 35 7d aa 15 13 07 3d 97 b2 a4
OOB: a8 bb 19 b3 07 e9 f6 25 52 d7 1a 23 e2 7e 0a e4
OOB: 52 8a 09 d2 1a 86 3d cf b4 99 43 13 d3 90 33 0b
instead of:
OOB: ff ff ff ff ff ff ff ff ea 19 00 3a 83 db aa 8d
OOB: 99 09 c8 9a 90 36 35 7d aa 15 13 07 3d 97 b2 a4
OOB: a8 bb 19 b3 07 e9 f6 25 52 d7 1a 23 e2 7e 0a e4
OOB: 52 8a 09 d2 1a 86 3d cf b4 99 43 13 d3 90 33 0b
OOB: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
OOB: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
OOB: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
OOB: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
(example with BCH16, user data [8,0], no scrambling)

*cur_off (offset from the beginning of the page) was compared to offset
(offset from the beginning of the OOB), and then, the
nand_change_read_column_op() sets the current position to the beginning
of the OOB instead of OOB+offset

Fixes: 15d6f118285f ("mtd: rawnand: sunxi: Stop supporting ECC_HW_SYNDROME mode")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Richard Genoud <richard.genoud@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index f6a8e8ae819d4..75db1713e6177 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -886,9 +886,9 @@ static void sunxi_nfc_hw_ecc_read_extra_oob(struct nand_chip *nand,
 	if (len <= 0)
 		return;
 
-	if (!cur_off || *cur_off != offset)
-		nand_change_read_column_op(nand, mtd->writesize, NULL, 0,
-					   false);
+	if (!cur_off || *cur_off != (offset + mtd->writesize))
+		nand_change_read_column_op(nand, mtd->writesize + offset,
+					   NULL, 0, false);
 
 	if (!randomize)
 		sunxi_nfc_read_buf(nand, oob + offset, len);
-- 
2.53.0



