Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFC31ABECB;
	Mon, 14 Oct 2024 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917668; cv=none; b=gmwH/D62KHeCIFlYZUi/FLgINIaEHDW2QF5eGrnq693THDp71444f3oupQHJkQ3ZUyRdeTlKFfjKjnobKgHBuXKCXQMB7ik81Y4BOfwcKscUXaH2cF6Gq+jLxd2eLkXa3GDvjDQABVd4JwjkXrbSuq09SNcU4v5oy8lLASofQ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917668; c=relaxed/simple;
	bh=tFh9ion9O0q4mD2YTUJVlc6uZk6qXA8360OQ+B8MIqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkWNI4xsugHpUZDLu1uKAqm56GGx/JyFpJlp7MCd2nJrYesvejSFvFcxfpmniBn2BANcJxv/C60FQ0qazPx2d7Y1ZpLHiP6tzz5IMT+pMh5CkoXgpBbZLNcVQqN46+Q9VMb5XOMIA9tquK/EsRYbz0udMCoBZwZDp/LNE+hGFtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJIq2fb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJIq2fb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FEAC4CEC3;
	Mon, 14 Oct 2024 14:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917668;
	bh=tFh9ion9O0q4mD2YTUJVlc6uZk6qXA8360OQ+B8MIqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJIq2fb8v330l2YkwFPYfZ7kZj2LIynOBI/eFyVvGMo2ujft+cTgPyiEQmWswWFg2
	 l1LqjKKYaVTJawBWFqqEgUTs75XgIofP+5De0bqitoZeIVquHfbwhY7+jlDNHLUP08
	 CtyanI/pp3kxzhALM+5Ztj1d2foEY023Bc6XPWNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/798] mtd: rawnand: mtk: Use for_each_child_of_node_scoped()
Date: Mon, 14 Oct 2024 16:10:53 +0200
Message-ID: <20241014141221.820614376@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 8795952679494b111b7b2ba08bb54ac408daca3b ]

Avoids the need for manual cleanup of_node_put() in early exits
from the loop.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240826094328.2991664-8-ruanjinjie@huawei.com
Stable-dep-of: 2073ae37d550 ("mtd: rawnand: mtk: Fix init error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/mtk_nand.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/raw/mtk_nand.c b/drivers/mtd/nand/raw/mtk_nand.c
index d540454cbbdfa..537ac81e661fc 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -1459,15 +1459,12 @@ static int mtk_nfc_nand_chip_init(struct device *dev, struct mtk_nfc *nfc,
 static int mtk_nfc_nand_chips_init(struct device *dev, struct mtk_nfc *nfc)
 {
 	struct device_node *np = dev->of_node;
-	struct device_node *nand_np;
 	int ret;
 
-	for_each_child_of_node(np, nand_np) {
+	for_each_child_of_node_scoped(np, nand_np) {
 		ret = mtk_nfc_nand_chip_init(dev, nfc, nand_np);
-		if (ret) {
-			of_node_put(nand_np);
+		if (ret)
 			return ret;
-		}
 	}
 
 	return 0;
-- 
2.43.0



