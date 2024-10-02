Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6436C198837;
	Wed,  2 Oct 2024 14:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877814; cv=none; b=eiKkyzIeRZ9/ldbkH14/ILmfImid6LIdAj0kPVxbyGLvzd9Dcw9EiRkR1p+NGwX1wBFMq2j3Q4XGomWL+OgTDT97vUvG2nO+WxxyCOgL5RNkHrSXTLg4jfUlgOSk4bRRP9LASuXgmBPNCo6OLDyCHEIVULcNVKcf9z8X0hcNx9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877814; c=relaxed/simple;
	bh=i72cZpsdgiMw9HddKA9HIvshlAei4wENccCCi/JfJzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fP4V5ihcZrWgcd4/IxY+RRZslUpauaKuZ2Jnyr6QI/8kYt7KCL5qfbhiohUe0EzMAzY3XBs3/cTDYbuiYpWu636GWdZKwY151POKZYjw/7SiGy18R/OrhEPtPCQTa1zRS4PggLDUuHdL8OL9S7zAtgf4kMm1GWwPxYoQAF0wO70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8Tacbio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8Tacbio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDEBC4CEC2;
	Wed,  2 Oct 2024 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877814;
	bh=i72cZpsdgiMw9HddKA9HIvshlAei4wENccCCi/JfJzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8TacbiorXYvkSoWB0lAHPuzr96bMCakvIsEhJ/sNFyd7taOpIlOd3NOoBpm7ofvZ
	 fWFyTdmrRzCzjf0EBQxUvGZT+9bABUdZCSzdzXCQDKzpV12GjVRnodyfM+QbUMJgnU
	 xeDY9b9oVWjinmK1w2g9cJFft9/PR9bgTkoaan88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 172/634] mtd: rawnand: mtk: Use for_each_child_of_node_scoped()
Date: Wed,  2 Oct 2024 14:54:32 +0200
Message-ID: <20241002125817.898300663@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 17477bb2d48ff..d65e6371675bb 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -1432,15 +1432,12 @@ static int mtk_nfc_nand_chip_init(struct device *dev, struct mtk_nfc *nfc,
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



