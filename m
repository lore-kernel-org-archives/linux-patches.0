Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D0016F84F;
	Wed,  2 Oct 2024 13:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875789; cv=none; b=Ts74965TKxU1nlJOc/y9welQw5aBn3PcPhaxC1+rnBXUJgrbh1J8VxgFJjmgn4cqE7RNS4u807bwvcTdK9FJ2ag8HjwhrhmlyTOkJbttO6wImvTd/6Jp51e9dUVEYscMbtse4vp+32NcUakJRUGFfpFJsQ8iAWtbx/nuvWnFqqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875789; c=relaxed/simple;
	bh=5oujHb+UQf57YzOxPaBmfQk7/tLN7cBNUyFN4O7/CxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJE4hIfrcSc6zIIP3df+03DQB5szcY/MFndZjyS0DexrD9HVL02cfOv6ImP7hCzUdcjl+Ob57lPab3ixtaTLqFQIbbUDyt08k0LKy0iEJMyEJQy+IyRmcqL8p2MvKkxVPyTJDJJhvzhCqWzpM7GC3ONcXJ11f32D8tbu/jWbnkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+D4fV/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+D4fV/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4100C4CEC5;
	Wed,  2 Oct 2024 13:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875789;
	bh=5oujHb+UQf57YzOxPaBmfQk7/tLN7cBNUyFN4O7/CxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+D4fV/n34Dj5qtqqodAk966zaaNRnxWA5eE0w3kumxBvXiShaNokXdzKNrfLjN/L
	 nmZubl6GSeSifa1eQhLfgBIzkserOflvJaAxw0imX/CFASjZsDrWilRIjfrn4xEE4T
	 qD6YTXJDOnP20qCen2AtW9cC66WCgQ4ACwPeU6gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 190/695] mtd: rawnand: mtk: Use for_each_child_of_node_scoped()
Date: Wed,  2 Oct 2024 14:53:08 +0200
Message-ID: <20241002125830.053874773@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



