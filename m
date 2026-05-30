Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5066B23392B;
	Sat, 30 May 2026 18:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164295; cv=none; b=Wt9xoLj6dvtSaQv3FEbNxj1apYgUr5d75+CeBtXb9ZHz3QG6krdQAh7EDO385ZvxzsNcy3UCFAW1vbbkOJ32GFbMMfq9vHIYr1XHeJvUnP6c/82vdrXGlgqpwGaSe/8xu2i5kfncXpp3+nDvfNojmBmkOwvPKUvusWKAMg+7jcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164295; c=relaxed/simple;
	bh=VHQenzzENymqOLnftR1TJa4XuD/5oV78qMEeTRBotEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0hIcaPMLHn0O1Glg0tVIp7ZvgJFObCIeRY2HLJ6TwjJg2jtsNpoKrNmYT8DP/QafC+8uR7GpURKRw28S+ItCqbUnsiB82X4/+Jjgrvsb4jXPdDTl2YhH49qaOZq+MDGFZZOAElr1apa5yN+hNZ5zXlB2PnNtxi9aw+YgcfJHGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q535AVyr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q535AVyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEC51F00893;
	Sat, 30 May 2026 18:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164294;
	bh=t1VGjkYSwE7g3CjY0F1tAivxxd9SfyuakVhbtAk22GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q535AVyredoXjgq856ThJBotzWCw9S/LukdMevGB/WJ3kZtWZ8p5oqLm6qeyCvKB7
	 +j1Hq6W/ZLNwv9EU5Icl8jSrx516jXwGfMsLzuavP5LgMc34kHeWZ3p4i6nigsNMcj
	 YPw8L6VIaDNJxx0gimSHb2qJ6MEei1prQD0s/u74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Richard Genoud <richard.genoud@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 511/776] mtd: rawnand: sunxi: fix sunxi_nfc_hw_ecc_read_extra_oob
Date: Sat, 30 May 2026 18:03:45 +0200
Message-ID: <20260530160253.467011487@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 11f656e9affb5..aa59b884206e0 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -898,9 +898,9 @@ static void sunxi_nfc_hw_ecc_read_extra_oob(struct nand_chip *nand,
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



