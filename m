Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FB331619A;
	Mon, 13 Apr 2026 16:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099155; cv=none; b=K74CMwM99/OD1Z8JrH+ue4co6xWvbYRYE2psmut0WaoMwzb55TddfUwyOl5yvA4OqV28esHo7XwilV9koQ1anP2gcWYxU/R0oQXCAv/lMfT0sARNmgaf0v1u2MzT4gfPiSwmc/6vp/AVs1xOBiBMltzLEOm0WFl82nHyluN2Hsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099155; c=relaxed/simple;
	bh=5PsR/0TisOBiu6wevd/BUprl1FXmOzeaqzm8Dqkvdw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtnIeSFwGBPQQ/Jd/jrAonlQzmr0jVbcCfkbKos8o64wj10E1IFChRuEXzwObWA0Rz45hjsCzcvvHqPkF/GdGPZpxf5rvURAcsdGjQ+p83tg0ckv7nCwqkyUx8LEY1WvbJOXHGukeTnBNxXiYBlhUDxCLvSvz+zGxNyd/sgFsVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGDV83Vz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGDV83Vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474DAC2BCAF;
	Mon, 13 Apr 2026 16:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099155;
	bh=5PsR/0TisOBiu6wevd/BUprl1FXmOzeaqzm8Dqkvdw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGDV83VzmUwRVfqPlRb+Xl8LVYjvDmDKyIdNBXTbRZVBZ0GCfjnn3JdhfbME4EJFZ
	 BMdcOos7f1bL5IklyzTpFmxkk0CLW29I293y/tByvkmzdd5mqHBBkeOnmdtNpG0mJj
	 KRo4XZJ0MmeaBxWIWRnjIzMSuQOlb5khLe+3IFF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kdasu.kdev@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/491] mtd: rawnand: brcmnand: move to polling in pio mode on oops write
Date: Mon, 13 Apr 2026 17:57:56 +0200
Message-ID: <20260413155827.708138982@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Dasu <kdasu.kdev@gmail.com>

[ Upstream commit 22ca05b82d3e3abc2b116a11ee41b6b692b95530 ]

This change makes sure that Broadcom NAND driver moves to interrupt
polling on the first brcmnand_write() call.

Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210311170909.9031-2-kdasu.kdev@gmail.com
Stable-dep-of: da9ba4dcc01e ("mtd: rawnand: brcmnand: skip DMA during panic write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index a101df3b19f70..669c332d37ee8 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2399,6 +2399,10 @@ static int brcmnand_write(struct mtd_info *mtd, struct nand_chip *chip,
 	for (i = 0; i < ctrl->max_oob; i += 4)
 		oob_reg_write(ctrl, i, 0xffffffff);
 
+	if (mtd->oops_panic_write)
+		/* switch to interrupt polling and PIO mode */
+		disable_ctrl_irqs(ctrl);
+
 	if (use_dma(ctrl) && (has_edu(ctrl) || !oob) && flash_dma_buf_ok(buf)) {
 		if (ctrl->dma_trans(host, addr, (u32 *)buf, oob, mtd->writesize,
 				    CMD_PROGRAM_PAGE))
-- 
2.51.0



