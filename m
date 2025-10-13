Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EB3313E03;
	Mon, 13 Oct 2025 15:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370072; cv=none; b=oqXALe6BcjuPG/HoA61JN7lFy+px4bHvdTDxDTpdF/2RNHC4TkpphG7sxgeorDK3iyKuxLd7rOC5hNjf/NARGwo5N1DRhu+X+413Du7Lc842vAjl2E5BwM42Rp9eDhQ2L/NmeoTglXDZQJxl5xkfJVOZcDuTpkqOkSJiCHGDuV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370072; c=relaxed/simple;
	bh=Uc14KJC5DaVwDc09Be6bUNwNFVKZpOTYpJOyTp0weZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EopPLMLXuw7mfjqJMrh+5x8LFCOoz+NQFyLtZbQ5MIO1HHJ3ljqj/KbA7gsfRdUqdIyZXG3PHgi0Vgf95815LC1wi4sC9wj0Bz414lBEemaXV86+s2wYqjNuiKaID2RTw2Ntu+ZhAZZDkbhDs42w6YebXaxJV7ZbqzCDA3i2hLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQzyXwRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQzyXwRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADFDC4CEE7;
	Mon, 13 Oct 2025 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370071;
	bh=Uc14KJC5DaVwDc09Be6bUNwNFVKZpOTYpJOyTp0weZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQzyXwRXljuuBhuun+s1u68rLwEbK/31vYm79gEb8uZHvjGYZsPqvMNlra3Mge+0q
	 gJNKtzUv09tDJIOEFQ2BTqaxZLNR6w7qKG8WowmRGvqQOwxLygXbsIGf0Jnr5VifZb
	 W4z/TvPP2ldEnrXdAiy8uiOj4FCMeSTOP0U375+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Karanja <karanja99erick@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 468/563] mtd: rawnand: atmel: Fix error handling path in atmel_nand_controller_add_nands
Date: Mon, 13 Oct 2025 16:45:29 +0200
Message-ID: <20251013144428.243366138@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Erick Karanja <karanja99erick@gmail.com>

[ Upstream commit 8ed4728eb9f10b57c3eb02e0f6933a89ffcb8a91 ]

In case of a jump to the  err label due to atmel_nand_create() or
atmel_nand_controller_add_nand() failure, the reference to nand_np
need to be released

Use for_each_child_of_node_scoped() to fix the issue.

Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")

Signed-off-by: Erick Karanja <karanja99erick@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index db94d14a3807f..49e00458eebeb 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -1858,7 +1858,7 @@ atmel_nand_controller_legacy_add_nands(struct atmel_nand_controller *nc)
 
 static int atmel_nand_controller_add_nands(struct atmel_nand_controller *nc)
 {
-	struct device_node *np, *nand_np;
+	struct device_node *np;
 	struct device *dev = nc->dev;
 	int ret, reg_cells;
 	u32 val;
@@ -1885,7 +1885,7 @@ static int atmel_nand_controller_add_nands(struct atmel_nand_controller *nc)
 
 	reg_cells += val;
 
-	for_each_child_of_node(np, nand_np) {
+	for_each_child_of_node_scoped(np, nand_np) {
 		struct atmel_nand *nand;
 
 		nand = atmel_nand_create(nc, nand_np, reg_cells);
-- 
2.51.0



