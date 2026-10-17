Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A543B19BF;
	Sat, 17 Oct 2026 17:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256983; cv=none; b=T0xCMuejfxihoLyhYmfSurbbGFOLjQ99c0Dky4neb/wTn6q7TWGk5U0Yd5YbiljMVNkzDTIhr0tm23ywwloTlfnbFRztJ+G1YLSgy0gA4lZm9j7IRBWBv1M5S3hpGIrmI+/O6Uf63kRAssgscTSogdI4SuxnXCM0Xy/nN6ej8tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256983; c=relaxed/simple;
	bh=o+AHn16NYSHeMi633JGwJ6a9yaSWt4rdFxwPftaA2S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mXn704QnDLEFaNilXX3Phr8SqDwZauwbH7u5OpBR5CEVAhyFtR9pIAesCgjiemr7qjeP4A+oqMyaJLZT3bjMR1iEMMbDTh4uMYjSVcb9S95lJBr0bJXhWPw1of8h4iniOS87JIRYFCuNrz5kdsF7BN0+KtFbnqmv6uX5y5G5OQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCeGtxcR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCeGtxcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923111F000C4;
	Sat, 17 Oct 2026 17:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256982;
	bh=YDCJW1B2IkaJ02FaVVUmarnU/BBgDLvddh1dRjbr7vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCeGtxcRW26O4gHdEn1wnniFGbBe5+uytH2kOiRPfrhfbqwr63dXnzo8MQF0lO2lt
	 uhpMYzZbtnIXYuTx9i1cHoGt2Vg/aM3x21jgrKlvSynmk1vt6KAtu+LvYpziWvGtQK
	 vw80AwgjDHbs/NHgEPxD5mtgW3Fp/BuwkdTVssn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0414/1674] mtd: spinand: Enable QE on all dies
Date: Sat, 17 Oct 2026 17:44:46 +0200
Message-ID: <20261017160441.753602408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Xu <han.xu@nxp.com>

[ Upstream commit 63d6cace2c4a7f36c1cb44f1bb5e0f3ef19e5c7f ]

The QUAD ENABLE (QE) bit is stored in a per-die configuration
register on some SPI-NAND devices. When a device contains multiple
dies, updating the QE bit only on the currently selected die can
leave the remaining dies operating in non-quad mode.
 
Iterate over all targets and update the QE setting on each die
during initialization to ensure consistent quad I/O operation
across the entire device.

Tested on ISSI IS38SMW04G8B.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[ sashal: Adapted to spinand_init_quad_enable() computing enable internally instead of accepting it as an argument. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 9143553bc5704..79d6d6d12107b 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -179,7 +179,10 @@ static int spinand_init_cfg_cache(struct spinand_device *spinand)
 
 static int spinand_init_quad_enable(struct spinand_device *spinand)
 {
+	struct nand_device *nand = spinand_to_nand(spinand);
+	unsigned int target;
 	bool enable = false;
+	int ret;
 
 	if (!(spinand->flags & SPINAND_HAS_QE_BIT))
 		return 0;
@@ -189,8 +192,22 @@ static int spinand_init_quad_enable(struct spinand_device *spinand)
 	    spinand->op_templates.update_cache->data.buswidth == 4)
 		enable = true;
 
-	return spinand_upd_cfg(spinand, CFG_QUAD_ENABLE,
-			       enable ? CFG_QUAD_ENABLE : 0);
+	/*
+	 * QE is a per-die setting on some devices. Program each target
+	 * individually when enabling or disabling quad I/O mode.
+	 */
+	for (target = 0; target < nand->memorg.ntargets; target++) {
+		ret = spinand_select_target(spinand, target);
+		if (ret)
+			return ret;
+
+		ret = spinand_upd_cfg(spinand, CFG_QUAD_ENABLE,
+				      enable ? CFG_QUAD_ENABLE : 0);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int spinand_ecc_enable(struct spinand_device *spinand,
-- 
2.53.0



