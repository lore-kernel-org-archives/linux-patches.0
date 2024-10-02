Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2D71CF284;
	Wed,  2 Oct 2024 13:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875795; cv=none; b=MEOdQzq5vUY7z5u2IzqiglhYyhDQzyztue8EtWDBTJsua4hIVxsMiHv1c7hfewDr7kB2ZLKdop5ahQIkTMeKh/p0juPfjkfuEofU6R/a4YezLBJgeRbnLngXnpRcFbSe7taDmzcNBXZr/akDuOP/LI4zlD6D3C8Sw2wm0wSvMsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875795; c=relaxed/simple;
	bh=Xy60c250GkPiQLOnGNTQZur1/6cF5EpwqQKEtppgdek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F20i5e9pi6m7+6TsOo8c7rYSKA9ZOQhBeDrfo+D54ErHnLhjNZuz61DaFi2ffqUzvl7cBA2C88UL/OkJJwbf2llV+V4puLDQBWfmiIDCdP5bWf1VEO3+9b0YDk2ShSZ5rnDq5o3cOdL2RxLcxdwLkod9VJjXBS2ooCnU3coRpBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYQ0mCbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYQ0mCbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF5CC4CEC5;
	Wed,  2 Oct 2024 13:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875795;
	bh=Xy60c250GkPiQLOnGNTQZur1/6cF5EpwqQKEtppgdek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYQ0mCbVDksFYLjNfOVIdFF/7DIdhxmGsLWNejiWjhsJawO3QJPkYMXL+Y4OXYIDQ
	 04XAPo5gsk2wD2XZ1f3uq5CPk3SAMFXEmfs/Zycvde/RlMMi/D18IFqU8D4UoopP82
	 e3Km0yQGg+rYNWji9iosan9Vrm8GLo2mGXKV8lQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Matthias Brugger <matthias.bgg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 192/695] mtd: rawnand: mtk: Fix init error path
Date: Wed,  2 Oct 2024 14:53:10 +0200
Message-ID: <20241002125830.132914157@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 2073ae37d550ea32e8545edaa94ef10b4fef7235 ]

Reviewing a series converting the for_each_chil_of_node() loops into
their _scoped variants made me realize there was no cleanup of the
already registered NAND devices upon error which may leak memory on
systems with more than a chip when this error occurs. We should call the
_nand_chips_cleanup() function when this happens.

Fixes: 1d6b1e464950 ("mtd: mediatek: driver for MTK Smart Device")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Matthias Brugger <matthias.bgg@kernel.org>
Link: https://lore.kernel.org/linux-mtd/20240826153019.67106-2-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/mtk_nand.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/mtk_nand.c b/drivers/mtd/nand/raw/mtk_nand.c
index bf845dd167374..586868b4139f5 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -1453,8 +1453,10 @@ static int mtk_nfc_nand_chips_init(struct device *dev, struct mtk_nfc *nfc)
 
 	for_each_child_of_node_scoped(np, nand_np) {
 		ret = mtk_nfc_nand_chip_init(dev, nfc, nand_np);
-		if (ret)
+		if (ret) {
+			mtk_nfc_nand_chips_cleanup(nfc);
 			return ret;
+		}
 	}
 
 	return 0;
-- 
2.43.0



