Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E373D522C;
	Wed,  8 Apr 2026 18:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672923; cv=none; b=SoXaVneHacYMPJl4BptWkKh+X9TbzkEZn3fqEr+P6MsIy97Hbi1lcOW5q2AlFF19dMD6z39PsrmP9DtyT7P11yIVc+XDb98vATUDw2gsN5jrPf+be10Eai0Whn+5tAUcCl38UqIIQ9FODdulLFVTtZwQmgjaY96nTPdFD+Io5Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672923; c=relaxed/simple;
	bh=fOmAZbX93pI4eQIQmyLJT7nyxAtvco4CWMSGELFz/wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbpKL14mtoawkcgbl5PnCUIWksw3M4gMi/noOUkdSgiN9jgECu7IZYOLM7qysbK87XdueHhdBM4jpJ+rUCczuLtucmxuwszYC2h5TNlYJXazw2/XPr0vdWNSk+gi9FlPxwim+kDO7PIOdP60ag07f+k8OK7iAReYjuhvCBd6T3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wETJypIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wETJypIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7016AC19421;
	Wed,  8 Apr 2026 18:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672922;
	bh=fOmAZbX93pI4eQIQmyLJT7nyxAtvco4CWMSGELFz/wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wETJypInoMrIMDkPE02reoXoE6OwZEA5kDY84YbqJV/edrseNcGCFjtEYlZRK1fVQ
	 wQuc4KjK6dM9o2kz1tMXEAwMC9xzdhyYd8atMx+tK+ouOVGlkFtLmDgMl8cA6vpugY
	 lkyJrVXkq84G8kuybWEcXQZRVGX5Z43O6Kb6zCqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/277] net: enetc: reset PIR and CIR if they are not equal when initializing TX ring
Date: Wed,  8 Apr 2026 20:00:17 +0200
Message-ID: <20260408175935.052657439@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d97a76718dd89..b5dd49337513d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2570,6 +2570,7 @@ EXPORT_SYMBOL_GPL(enetc_free_si_resources);
 
 static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 {
+	struct enetc_si *si = container_of(hw, struct enetc_si, hw);
 	int idx = tx_ring->index;
 	u32 tbmr;
 
@@ -2583,10 +2584,20 @@ static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
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



