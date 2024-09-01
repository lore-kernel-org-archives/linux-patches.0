Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAA133987;
	Sun,  1 Sep 2024 16:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208008; cv=none; b=MeK+0OaEE0IAcQf/S/UYvMjqU8DAoD32WdJujrvr5/KptK+xhYDjhAbRn56n7n2Isk5WsdLS+voXsCTiGsBq6i3mfNGvFDx54Q/6LVI4lPDIidVKeMTyBP4FLL0q0ve47MXrx5dFBm6rTITgLSQYJYatDnjRf0qd5ZnLYQAkDu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208008; c=relaxed/simple;
	bh=5Q9fQIbce9r1E64vOO1kod4XQoL2UPdOzApLwh1rU4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ/IBpHSz/4cXX3DMPpn7gCOugRPvbvbhUL/kQhfRBneP0w2B/blco+tafe+U72gP5mJ2TLTmVPHDOebte+R4TZcwOrEE1lBgZw5O+WQw0WZoOMJ+iqPqS5L/mM9YdeucvrJ37P/msH4BSHS2OjHSbUdYt3ZP9KG55fQAjLpgKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3dTtkOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3dTtkOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7E4C4CEC3;
	Sun,  1 Sep 2024 16:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208008;
	bh=5Q9fQIbce9r1E64vOO1kod4XQoL2UPdOzApLwh1rU4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3dTtkOTaweTa19/Z60lHVB53hyHAChvbTWb9Dz88DNcIH0k94+u2lRunEIc2ok1s
	 m6mvrjsHrwwZnVTLTRkvMQXhGsEyMAfUZN99pfgEC760NSwbuYcv8uf1AZyzWfpSSz
	 xe2FFszWbUK06irnxWAwDW+5+Pux/XPHUv26+Ti0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mrinmay Sarkar <quic_msarkar@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 46/93] dmaengine: dw-edma: Fix unmasking STOP and ABORT interrupts for HDMA
Date: Sun,  1 Sep 2024 18:16:33 +0200
Message-ID: <20240901160809.095563125@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mrinmay Sarkar <quic_msarkar@quicinc.com>

commit 383baf5c8f062091af34c63f28d37642a8f188ae upstream.

The current logic is enabling both STOP_INT_MASK and ABORT_INT_MASK
bit. This is apparently masking those particular interrupts rather than
unmasking the same. If the interrupts are masked, they would never get
triggered.

So fix the issue by unmasking the STOP and ABORT interrupts properly.

Fixes: e74c39573d35 ("dmaengine: dw-edma: Add support for native HDMA")
cc: stable@vger.kernel.org
Signed-off-by: Mrinmay Sarkar <quic_msarkar@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1724674261-3144-2-git-send-email-quic_msarkar@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-hdma-v0-core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-hdma-v0-core.c b/drivers/dma/dw-edma/dw-hdma-v0-core.c
index 10e8f0715114..2addaca3b694 100644
--- a/drivers/dma/dw-edma/dw-hdma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-hdma-v0-core.c
@@ -247,10 +247,11 @@ static void dw_hdma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
 	if (first) {
 		/* Enable engine */
 		SET_CH_32(dw, chan->dir, chan->id, ch_en, BIT(0));
-		/* Interrupt enable&unmask - done, abort */
-		tmp = GET_CH_32(dw, chan->dir, chan->id, int_setup) |
-		      HDMA_V0_STOP_INT_MASK | HDMA_V0_ABORT_INT_MASK |
-		      HDMA_V0_LOCAL_STOP_INT_EN | HDMA_V0_LOCAL_ABORT_INT_EN;
+		/* Interrupt unmask - stop, abort */
+		tmp = GET_CH_32(dw, chan->dir, chan->id, int_setup);
+		tmp &= ~(HDMA_V0_STOP_INT_MASK | HDMA_V0_ABORT_INT_MASK);
+		/* Interrupt enable - stop, abort */
+		tmp |= HDMA_V0_LOCAL_STOP_INT_EN | HDMA_V0_LOCAL_ABORT_INT_EN;
 		if (!(dw->chip->flags & DW_EDMA_CHIP_LOCAL))
 			tmp |= HDMA_V0_REMOTE_STOP_INT_EN | HDMA_V0_REMOTE_ABORT_INT_EN;
 		SET_CH_32(dw, chan->dir, chan->id, int_setup, tmp);
-- 
2.46.0



