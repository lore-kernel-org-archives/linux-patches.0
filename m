Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFCD34AB06;
	Wed,  8 Apr 2026 18:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674299; cv=none; b=oulIuiyE0BpNIpIFwTWUPbcGdUAdibc9tcbzsLQaEmc8LBex0Kmzma+n1ClbGhUDjydHI11qLgRjUs6o5gSDZ4egUJd5ct8Pq4r7Wot71GT5f/INpmwVuh/Ty4+64qqr6QI+VOoebqw+6/g/5Id+ZqvZUW+PYR55rBuxvkaY7lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674299; c=relaxed/simple;
	bh=fkxg01jIPQ/zArKolKKgTROpnbvKaKP3kunt8EQY3cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2FQwxH5o5PMBbdUWUeRa1l0L08E6HwnDc9+spm+A7oS+kCrertWI0IO2kcog7tG+DUeXy6M2C1LG4mVLyc5BeYyQWDAM0vVAg9+EvZ8gK/4HX1A95cMSMRbVxBqFYrWX4LMwJXD2X+sEEuVoI91ApMUqc+kEMs3CaKkWxqO62s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uB41zSVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uB41zSVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B81C19421;
	Wed,  8 Apr 2026 18:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674299;
	bh=fkxg01jIPQ/zArKolKKgTROpnbvKaKP3kunt8EQY3cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uB41zSVekKuiulF4vJ+eataWGJr0Mo7TCRhDGxjbWbNwRgqhGptT/qeAKzo4yy7WL
	 T7xNOd/vFr+0Ovh2rNes4+KOJ1qQJbsyTOeLKRI74/2dnPbT63fd6WEy0uuw4IhUNi
	 vnmabGAt1j166hpL6FFTn9mMs1lNdl725MRFEW3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 044/311] net: enetc: reset PIR and CIR if they are not equal when initializing TX ring
Date: Wed,  8 Apr 2026 20:00:44 +0200
Message-ID: <20260408175941.060900904@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 0239fd701d33475a39428daa3dc627407cd417a6 ]

Currently the driver does not reset the producer index register (PIR) and
consumer index register (CIR) when initializing a TX BD ring. The driver
only reads the PIR and CIR and initializes the software indexes. If the
TX BD ring is reinitialized when it still contains unsent frames, its PIR
and CIR will not be equal after the reinitialization. However, the BDs
between CIR and PIR have been freed and become invalid and this can lead
to a hardware malfunction, causing the TX BD ring will not work properly.

For ENETC v4, it supports software to set the PIR and CIR, so the driver
can reset these two registers if they are not equal when reinitializing
the TX BD ring. Therefore, add this solution for ENETC v4. Note that this
patch does not work for ENETC v1 because it does not support software to
set the PIR and CIR.

Fixes: 99100d0d9922 ("net: enetc: add preliminary support for i.MX95 ENETC PF")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260324062121.2745033-2-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 9fdd448e602f1..8ec96f39e1263 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2579,6 +2579,7 @@ EXPORT_SYMBOL_GPL(enetc_free_si_resources);
 
 static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 {
+	struct enetc_si *si = container_of(hw, struct enetc_si, hw);
 	int idx = tx_ring->index;
 	u32 tbmr;
 
@@ -2592,10 +2593,20 @@ static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 	enetc_txbdr_wr(hw, idx, ENETC_TBLENR,
 		       ENETC_RTBLENR_LEN(tx_ring->bd_count));
 
-	/* clearing PI/CI registers for Tx not supported, adjust sw indexes */
+	/* For ENETC v1, clearing PI/CI registers for Tx not supported,
+	 * adjust sw indexes
+	 */
 	tx_ring->next_to_use = enetc_txbdr_rd(hw, idx, ENETC_TBPIR);
 	tx_ring->next_to_clean = enetc_txbdr_rd(hw, idx, ENETC_TBCIR);
 
+	if (tx_ring->next_to_use != tx_ring->next_to_clean &&
+	    !is_enetc_rev1(si)) {
+		tx_ring->next_to_use = 0;
+		tx_ring->next_to_clean = 0;
+		enetc_txbdr_wr(hw, idx, ENETC_TBPIR, 0);
+		enetc_txbdr_wr(hw, idx, ENETC_TBCIR, 0);
+	}
+
 	/* enable Tx ints by setting pkt thr to 1 */
 	enetc_txbdr_wr(hw, idx, ENETC_TBICR0, ENETC_TBICR0_ICEN | 0x1);
 
-- 
2.53.0



