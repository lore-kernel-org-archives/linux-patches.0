Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F19216E27;
	Thu, 12 Dec 2024 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015869; cv=none; b=Qt2cADP+aB7HNChQYf809J8pdPZ+MntrNzeqb61XkCCHFMZ4ESixvAns4Sgcg2XvXLs5Xz/I1pvRDTHzvXZetgeWoRPBNV8EMjKHft/nFAY6S6IkDiWbbTUm7NNS1LOtcG6MOCsQG6DTrqs5BSVJO0EQov0b8QsS90GWh/AYBYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015869; c=relaxed/simple;
	bh=erBys8g8BErfjIKbqmIclmq1QTaAGPO+mRK2KIWBaj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPCsbJPpE4uiwt1Xs6DUGdcdxeHEFRFEj+YWd3H7pBnFupdOp9LhJQToJajYmTmCvX3oQiFyay01GH4thWz6SDjHAxTPBBSU/6bDkZsXty3ItsQW/qdlOIKxUUUVj2GqGZlI76pIigWPI+p3l7PUlx3Hw8LxVHFULslMy8q/m8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xa/VR85/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xa/VR85/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ACBC4CECE;
	Thu, 12 Dec 2024 15:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015869;
	bh=erBys8g8BErfjIKbqmIclmq1QTaAGPO+mRK2KIWBaj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xa/VR85/Zk3/cFJWo3ohYGB+m/hxnUyzeHJgCsl44DEMc8/Gd9ARrvobjLGwgEpss
	 VU7telqt3Hitl0tZpRPvTIahP5gTEE7MG+aCAv+Tpxq4vh/B2W07/SG5o7pMbXNGBP
	 lnKmNjHk34Gf1EJ3ejQIPZaHgnqOX9cE5iesFqTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/466] mmc: core: Adjust ACMD22 to SDUC
Date: Thu, 12 Dec 2024 15:53:57 +0100
Message-ID: <20241212144309.502785763@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avri Altman <avri.altman@wdc.com>

[ Upstream commit 449f34a34088d02457fa0f3216747e8a35bc03ae ]

ACMD22 is used to verify the previously write operation.  Normally, it
returns the number of written sectors as u32.  SDUC, however, returns it
as u64.  This is not a superfluous requirement, because SDUC writes may
exceeds 2TB.  For Linux mmc however, the previously write operation
could not be more than the block layer limits, thus we make room for a
u64 and cast the returning value to u32.

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20241006051148.160278-8-avri.altman@wdc.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[Stephen Rothwell: Fix build error when moving to new rc from Linus's tree]
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Stable-dep-of: 869d37475788 ("mmc: core: Use GFP_NOIO in ACMD22")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index ef06a4d5d65bb..64ae6116b1fa0 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -50,6 +50,7 @@
 #include <linux/mmc/sd.h>
 
 #include <linux/uaccess.h>
+#include <linux/unaligned.h>
 
 #include "queue.h"
 #include "block.h"
@@ -993,11 +994,10 @@ static int mmc_sd_num_wr_blocks(struct mmc_card *card, u32 *written_blocks)
 	int err;
 	u32 result;
 	__be32 *blocks;
-
+	u8 resp_sz = mmc_card_ult_capacity(card) ? 8 : 4;
 	struct mmc_request mrq = {};
 	struct mmc_command cmd = {};
 	struct mmc_data data = {};
-
 	struct scatterlist sg;
 
 	err = mmc_app_cmd(card->host, card);
@@ -1008,7 +1008,7 @@ static int mmc_sd_num_wr_blocks(struct mmc_card *card, u32 *written_blocks)
 	cmd.arg = 0;
 	cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
 
-	data.blksz = 4;
+	data.blksz = resp_sz;
 	data.blocks = 1;
 	data.flags = MMC_DATA_READ;
 	data.sg = &sg;
@@ -1018,15 +1018,27 @@ static int mmc_sd_num_wr_blocks(struct mmc_card *card, u32 *written_blocks)
 	mrq.cmd = &cmd;
 	mrq.data = &data;
 
-	blocks = kmalloc(4, GFP_KERNEL);
+	blocks = kmalloc(resp_sz, GFP_KERNEL);
 	if (!blocks)
 		return -ENOMEM;
 
-	sg_init_one(&sg, blocks, 4);
+	sg_init_one(&sg, blocks, resp_sz);
 
 	mmc_wait_for_req(card->host, &mrq);
 
-	result = ntohl(*blocks);
+	if (mmc_card_ult_capacity(card)) {
+		/*
+		 * Normally, ACMD22 returns the number of written sectors as
+		 * u32. SDUC, however, returns it as u64.  This is not a
+		 * superfluous requirement, because SDUC writes may exceed 2TB.
+		 * For Linux mmc however, the previously write operation could
+		 * not be more than the block layer limits, thus just make room
+		 * for a u64 and cast the response back to u32.
+		 */
+		result = clamp_val(get_unaligned_be64(blocks), 0, UINT_MAX);
+	} else {
+		result = ntohl(*blocks);
+	}
 	kfree(blocks);
 
 	if (cmd.error || data.error)
-- 
2.43.0



