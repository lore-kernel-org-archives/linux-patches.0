Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9FE34D3B9;
	Tue, 16 Dec 2025 11:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885348; cv=none; b=tRrMH7Ma/PmQZj/Xf0FOT5mCJSeAJ34eXZFX3LGRae2jj3T/ZlOCXoKKl3BFpz0sXfpRt9+HMa5uFohA4zdbiq/dNC9F7/ko3GhNZ2mioT0QrkarDjMzNz/r7LzW/VgqF7IeeCK1HZPNquWCVGwF2HyfYhKUtFhFfqImlHQK0KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885348; c=relaxed/simple;
	bh=UIndcyj4qQpV7XLr9zOz4zRQipPsOlnjkoazX6vgn68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8b8qEvmvpbuU7K3zrwAAeV4zq74QnR+G5puNCXemPzUgs3ggXZBQtSqlvR44Na3xfwUE43jf219Mm4Csj4emTQZ/+vSwrFmjGqDoKQeY+GGulA7aeIu1QSU9wk/kfUD5oF3XEfzM5eLjpS8knE6HOkSx33jnvXUVAQHONQzHjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnNjhy4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnNjhy4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136B4C4CEF1;
	Tue, 16 Dec 2025 11:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885348;
	bh=UIndcyj4qQpV7XLr9zOz4zRQipPsOlnjkoazX6vgn68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnNjhy4w9hMpT/kfxUYOyq/xkIsd7/VAEulR0EF2CZJMzmGouY7K4ZqkJsUPFqt7M
	 qgqqiS+ixW6BK9hmz5TDd68udWw35I1qA/cN0Y09W6vTfp7Fmr7RzFdVN3xemcJQ3w
	 /tDBDrZMBABMhCkEZYY2WIQ7Ha/Ir9CtFbwFm7S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 113/507] Revert "mtd: rawnand: marvell: fix layouts"
Date: Tue, 16 Dec 2025 12:09:14 +0100
Message-ID: <20251216111349.628846606@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>

[ Upstream commit fbd72cb463fdea3a0c900dd5d6e813cdebc3a73c ]

This reverts commit e6a30d0c48a1e8a68f1cc413bee65302ab03ddfb.

This change resulted in the 8bit ECC layouts having the incorrect amount
of read/write chunks, the last spare bytes chunk would always be missed.

Fixes: e6a30d0c48a1 ("mtd: rawnand: marvell: fix layouts")
Signed-off-by: Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/marvell_nand.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index 303b3016a070b..38b7eb5b992c8 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -290,13 +290,16 @@ static const struct marvell_hw_ecc_layout marvell_nfc_layouts[] = {
 	MARVELL_LAYOUT( 2048,   512,  4,  1,  1, 2048, 32, 30,  0,  0,  0),
 	MARVELL_LAYOUT( 2048,   512,  8,  2,  1, 1024,  0, 30,1024,32, 30),
 	MARVELL_LAYOUT( 2048,   512,  8,  2,  1, 1024,  0, 30,1024,64, 30),
-	MARVELL_LAYOUT( 2048,   512,  16, 4,  4, 512,   0, 30,  0, 32, 30),
+	MARVELL_LAYOUT( 2048,   512,  12, 3,  2, 704,   0, 30,640,  0, 30),
+	MARVELL_LAYOUT( 2048,   512,  16, 5,  4, 512,   0, 30,  0, 32, 30),
 	MARVELL_LAYOUT( 4096,   512,  4,  2,  2, 2048, 32, 30,  0,  0,  0),
-	MARVELL_LAYOUT( 4096,   512,  8,  4,  4, 1024,  0, 30,  0, 64, 30),
-	MARVELL_LAYOUT( 4096,   512,  16, 8,  8, 512,   0, 30,  0, 32, 30),
+	MARVELL_LAYOUT( 4096,   512,  8,  5,  4, 1024,  0, 30,  0, 64, 30),
+	MARVELL_LAYOUT( 4096,   512,  12, 6,  5, 704,   0, 30,576, 32, 30),
+	MARVELL_LAYOUT( 4096,   512,  16, 9,  8, 512,   0, 30,  0, 32, 30),
 	MARVELL_LAYOUT( 8192,   512,  4,  4,  4, 2048,  0, 30,  0,  0,  0),
-	MARVELL_LAYOUT( 8192,   512,  8,  8,  8, 1024,  0, 30,  0, 160, 30),
-	MARVELL_LAYOUT( 8192,   512,  16, 16, 16, 512,  0, 30,  0,  32, 30),
+	MARVELL_LAYOUT( 8192,   512,  8,  9,  8, 1024,  0, 30,  0, 160, 30),
+	MARVELL_LAYOUT( 8192,   512,  12, 12, 11, 704,  0, 30,448,  64, 30),
+	MARVELL_LAYOUT( 8192,   512,  16, 17, 16, 512,  0, 30,  0,  32, 30),
 };
 
 /**
-- 
2.51.0



