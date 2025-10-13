Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE4930DEB2;
	Mon, 13 Oct 2025 14:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367406; cv=none; b=k7D1bEp9VQAb8MGXOYcqifnrsgm2WhPTVgUXfFi2wDjzhMsxgHRbV2qMZeSVuiQ1584FHYp6BXYUWtVxVJs9N+oh1b1Hd9id0dpMq2EG/LMAzV3GIqRPZytPTFmr3ud4M1AzpNVgY9h7fv6AbxfyeqbZsMUmJt0rgqfYY6U7cDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367406; c=relaxed/simple;
	bh=TYEVtNvxvBjWeZhJ7lAIclThH8shAw50q8ZAW1WXN6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2aauP9scuGf0lDpmB0XYVF18vNkufjl5qIjQnURGEV53+kFiqjwpBK07tN+sJVxz7uiwBDy8h+a8rNaoP+A/HsKIrkFpgL7DsQMG0WBJepRC10XvU8RavSCePk7PM1YgJhUSCFHhXeoUBXSwAr4GyTfaMg7hkPyWHx1IlMtI+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eg2ioAzd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eg2ioAzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7BEC4CEE7;
	Mon, 13 Oct 2025 14:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367406;
	bh=TYEVtNvxvBjWeZhJ7lAIclThH8shAw50q8ZAW1WXN6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eg2ioAzdIZL7Shu5nzgZ1qis11OtxMDQc7fi85N7wtjvfGMQyBmjU+e7MCPANMpeO
	 /K68NpIUkVdGm5y/HKB0C/6ieiwuelGr265cB43vE4MWQ9TOKGyIFtEU+DkFqAmCwV
	 gKMYM58+CyMSnJT6i7FqUZ8Bhkc8S1ormzUCr66g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Karanja <karanja99erick@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/196] mtd: rawnand: atmel: Fix error handling path in atmel_nand_controller_add_nands
Date: Mon, 13 Oct 2025 16:45:37 +0200
Message-ID: <20251013144320.631835756@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 78f317ac04afa..56fd897721ad5 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -1859,7 +1859,7 @@ atmel_nand_controller_legacy_add_nands(struct atmel_nand_controller *nc)
 
 static int atmel_nand_controller_add_nands(struct atmel_nand_controller *nc)
 {
-	struct device_node *np, *nand_np;
+	struct device_node *np;
 	struct device *dev = nc->dev;
 	int ret, reg_cells;
 	u32 val;
@@ -1886,7 +1886,7 @@ static int atmel_nand_controller_add_nands(struct atmel_nand_controller *nc)
 
 	reg_cells += val;
 
-	for_each_child_of_node(np, nand_np) {
+	for_each_child_of_node_scoped(np, nand_np) {
 		struct atmel_nand *nand;
 
 		nand = atmel_nand_create(nc, nand_np, reg_cells);
-- 
2.51.0



