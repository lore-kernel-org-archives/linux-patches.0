Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C3819E58
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7669C433D2;
	Wed,  7 Jun 2023 20:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170349;
	bh=0NaPn0n7paGYnoCX699k1g9XXVtv3i7bvyujp3Itry4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYqVIvAqviRZWQsk+mg8V8P4leGNlKAGZpu+0rlxkFYxnMTn5mE4hHCSspstlE2M7
	 /dL45ODDsKlNz7yfgxTibwkk6BrN9Mv8rZMPVe3Oq0yI0XJ0GgPCd0sSBPnlzgDYQK
	 o3oj0c3AxlsbVT2NGE2PGL7Jr8qlf6QMH4nR16pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/225] mtd: rawnand: marvell: ensure timing values are written
Date: Wed,  7 Jun 2023 22:14:03 +0200
Message-ID: <20230607200915.998858580@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 8a6f4d346f3bad9c68b4a87701eb3f7978542d57 ]

When new timing values are calculated in marvell_nfc_setup_interface()
ensure that they will be applied in marvell_nfc_select_target() by
clearing the selected_chip pointer.

Fixes: b25251414f6e ("mtd: rawnand: marvell: Stop implementing ->select_chip()")
Suggested-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230525003154.2303012-1-chris.packham@alliedtelesis.co.nz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/marvell_nand.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index b9d1e96e33345..72069a8643563 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -2449,6 +2449,12 @@ static int marvell_nfc_setup_interface(struct nand_chip *chip, int chipnr,
 			NDTR1_WAIT_MODE;
 	}
 
+	/*
+	 * Reset nfc->selected_chip so the next command will cause the timing
+	 * registers to be updated in marvell_nfc_select_target().
+	 */
+	nfc->selected_chip = NULL;
+
 	return 0;
 }
 
-- 
2.39.2



