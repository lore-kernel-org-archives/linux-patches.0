Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ED5421EE4;
	Tue, 31 Mar 2026 16:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976153; cv=none; b=EuUfRsegpkR5uLdPnNTMKNY3DmTTC+kum3bCXeqHxLnzWwXrVdLmNBYPPOUFjSIXZgmBudKgq/cUIjXWKtrHDtUtH5Btgb5c4eydBK+wXb0p90Sh6kOHtNXPbSFUwfuZmLlrAAuPf+/8bUtbqP0qgrzdEKCxzo4Ml2j9J36po3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976153; c=relaxed/simple;
	bh=Sdp0e1kEckKlHMU6Ar6G9hCy7thRn3XswreAc0UNPiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vd0nYFxeRPKouLxCouiotiAJUWJZNNpt7QemjjPIeVdGR4teucMKnUUOTM7GR7li5hdCyL03k5mqZNQjaH1t1iw0W7auJFXppcJqHtofDCEzN/AFdAfx498XcPQsMjz4djX5D6zbBUoX1m/a0q/5R+/FvjprM9aaXfVL2EZGiW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfrxD0RO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfrxD0RO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D667CC19423;
	Tue, 31 Mar 2026 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976153;
	bh=Sdp0e1kEckKlHMU6Ar6G9hCy7thRn3XswreAc0UNPiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfrxD0ROEjQber/z44Y3Kl9jdFAFEevgh5FUnA15IIoea0m0VGVTS1gtdOvMjqWB3
	 crPz+AxidFOKugCU3mXA3HhUU7Xh2QstVvUkygt/vfxCWQZ8emirUpXQCNTPiaoDUu
	 T7zcvC1ZcRbQZ9zHzATMzWLtIAArrRwahX7j6uy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LUO Haowen <luo-hw@foxmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/244] dmaengine: dw-edma: Fix multiple times setting of the CYCLE_STATE and CYCLE_BIT bits for HDMA.
Date: Tue, 31 Mar 2026 18:22:58 +0200
Message-ID: <20260331161750.186884453@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: LUO Haowen <luo-hw@foxmail.com>

[ Upstream commit 3f63297ff61a994b99d710dcb6dbde41c4003233 ]

Others have submitted this issue (https://lore.kernel.org/dmaengine/
20240722030405.3385-1-zhengdongxiong@gxmicro.cn/),
but it has not been fixed yet. Therefore, more supplementary information
is provided here.

As mentioned in the "PCS-CCS-CB-TCB" Producer-Consumer Synchronization of
"DesignWare Cores PCI Express Controller Databook, version 6.00a":

1. The Consumer CYCLE_STATE (CCS) bit in the register only needs to be
initialized once; the value will update automatically to be
~CYCLE_BIT (CB) in the next chunk.
2. The Consumer CYCLE_BIT bit in the register is loaded from the LL
element and tested against CCS. When CB = CCS, the data transfer is
executed. Otherwise not.

The current logic sets customer (HDMA) CS and CB bits to 1 in each chunk
while setting the producer (software) CB of odd chunks to 0 and even
chunks to 1 in the linked list. This is leading to a mismatch between
the producer CB and consumer CS bits.

This issue can be reproduced by setting the transmission data size to
exceed one chunk. By the way, in the EDMA using the same "PCS-CCS-CB-TCB"
mechanism, the CS bit is only initialized once and this issue was not
found. Refer to
drivers/dma/dw-edma/dw-edma-v0-core.c:dw_edma_v0_core_start.

So fix this issue by initializing the CYCLE_STATE and CYCLE_BIT bits
only once.

Fixes: e74c39573d35 ("dmaengine: dw-edma: Add support for native HDMA")
Signed-off-by: LUO Haowen <luo-hw@foxmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/tencent_CB11AA9F3920C1911AF7477A9BD8EFE0AD05@qq.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-hdma-v0-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-hdma-v0-core.c b/drivers/dma/dw-edma/dw-hdma-v0-core.c
index e3f8db4fe909a..ce8f7254bab21 100644
--- a/drivers/dma/dw-edma/dw-hdma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-hdma-v0-core.c
@@ -252,10 +252,10 @@ static void dw_hdma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
 			  lower_32_bits(chunk->ll_region.paddr));
 		SET_CH_32(dw, chan->dir, chan->id, llp.msb,
 			  upper_32_bits(chunk->ll_region.paddr));
+		/* Set consumer cycle */
+		SET_CH_32(dw, chan->dir, chan->id, cycle_sync,
+			HDMA_V0_CONSUMER_CYCLE_STAT | HDMA_V0_CONSUMER_CYCLE_BIT);
 	}
-	/* Set consumer cycle */
-	SET_CH_32(dw, chan->dir, chan->id, cycle_sync,
-		  HDMA_V0_CONSUMER_CYCLE_STAT | HDMA_V0_CONSUMER_CYCLE_BIT);
 
 	dw_hdma_v0_sync_ll_data(chunk);
 
-- 
2.53.0



