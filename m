Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36388217F35;
	Tue, 12 Aug 2025 19:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026371; cv=none; b=HAk+ZGfmMDdlPfa7cmb88j8zCaA261WhAqTbYWwrEi/EMbQqjw9BAS/dtBiTuXnAw6i981spR4kG5ipJzqiivqE6CPv8sBq+/kF6K8h4LMfg+d9WL7euun+YixMFMn6vWfwuxWO8mh7dH3QccZGBgPp08ibGoEUCyaW+rIa8630=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026371; c=relaxed/simple;
	bh=e3lj1qF35CuOMeI7YCHIGEC/SlJsNnj/BX/Olbtowuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uU/Q27mdisHCsjvcF5RLAYpunsu7+l+IDTGw3EmaHhwW/KKR+dnzzdia3MaZJvS6p5M+9uGyejJzSYNkqZ7FnaVqtCrWQkz30JYuo4xpeXlG63dSXIA1q4fqfqwiV0fR/cwTdUROZYZy+298I8my5PUC00ffu+d416tFuYuzx7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7gKPhcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7gKPhcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB93C4CEF0;
	Tue, 12 Aug 2025 19:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026371;
	bh=e3lj1qF35CuOMeI7YCHIGEC/SlJsNnj/BX/Olbtowuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7gKPhcy09sG7Kv5stp2P5cnelZkkFFlU7I9qUdwnKa8M1YQ9yrU2XhhkdrW9zGF8
	 kaWi9RI1QMffXFBMnVL8rFWHU2J1r3l2802BaVpt9+myKioznCMwpVRwnKXbOLuXqH
	 o98tE5Xu7YSrrZFqjaGcoXC9PQCe8+pVEfr7mA9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 317/480] mtd: rawnand: atmel: Fix dma_mapping_error() address
Date: Tue, 12 Aug 2025 19:48:45 +0200
Message-ID: <20250812174410.507794791@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit e1e6b933c56b1e9fda93caa0b8bae39f3f421e5c ]

It seems like what was intended is to test if the dma_map of the
previous line failed but the wrong dma address was passed.

Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Rule: add
Link: https://lore.kernel.org/stable/20250702064515.18145-2-fourier.thomas%40gmail.com
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index dedcca87defc..84ab4a83cbd6 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -373,7 +373,7 @@ static int atmel_nand_dma_transfer(struct atmel_nand_controller *nc,
 	dma_cookie_t cookie;
 
 	buf_dma = dma_map_single(nc->dev, buf, len, dir);
-	if (dma_mapping_error(nc->dev, dev_dma)) {
+	if (dma_mapping_error(nc->dev, buf_dma)) {
 		dev_err(nc->dev,
 			"Failed to prepare a buffer for DMA access\n");
 		goto err;
-- 
2.39.5



