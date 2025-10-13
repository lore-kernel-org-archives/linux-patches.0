Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C2927A477;
	Mon, 13 Oct 2025 15:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368604; cv=none; b=HwfmNUC7zMZqcOP9JiXhzMT2S4z1Ds2PdTVM9eIQ4Lt3qXcC8HEZm4DLRTy0NmMGBj3ud6jAgX9vl0H5J9iIUxuShv2VtCgephm81HQY4qhxxvDJrGZZnW74UZTpL1GKLZb0o865J6n32m0tpdtVIWr+8PnPEI2PSSLlAm49gjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368604; c=relaxed/simple;
	bh=zUNQ3Dg+ZcKDe7zvWyYHJrrfgwibo3lZk59eELRkZkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+cPf9vscPJwCYYms/1F2LxXB+ZAml2UijvYQcbBSVI/wuhqZgDP3e2k8+eF5+HYfQHUKEQa2HDTv6hWeJVbZM1DLRbpJEMOybZ8cRJ/ewoYAno+Ekzqj8bes2GlsH5iXbXT+emVpbZdzQZ0COIeCNb01k/ptgo20tv23U0o6+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwIVUMBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwIVUMBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9628EC4CEE7;
	Mon, 13 Oct 2025 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368604;
	bh=zUNQ3Dg+ZcKDe7zvWyYHJrrfgwibo3lZk59eELRkZkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwIVUMBIe9TSDgruOhRPPjLfYKADNMa628lx0yn7KxofO2+29UQhvUyyRdBdvLGZU
	 ApMrQZBgYkAb40RG9opwBftE9P0l9DqN22PrULB+yVxApGdCDsmU1dpGqON5BAxGC4
	 CGyfVGczPv4UQ0VLSIbZIv1G1sLSvriwT5QM7OaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Karanja <karanja99erick@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/262] mtd: rawnand: atmel: Fix error handling path in atmel_nand_controller_add_nands
Date: Mon, 13 Oct 2025 16:45:53 +0200
Message-ID: <20251013144333.842494583@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5b02119d8ba23..543a0be9dc645 100644
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



