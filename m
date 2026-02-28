Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9248F340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301122; cv=none; b=DQ2mOmPs5qzf8K0XtQaUMHGtHT2UoM5W/iR0WEVzRQSpufLTQCwbzTLkPhUoPFfmAwPs5aX8tfE6UMVCugjmd+k6dPO3Dwn5GvHE2u0tEl0VV/5Yvy6q2tPhp0OIxPMZjr3Z4xZkez85xwMKVU37U2aPYHi01+0mspw7enSrCuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301122; c=relaxed/simple;
	bh=tJUV87vTmT9dZ7DTNLMeknaRoS7GilMtgP0SK0dQ57U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iwRaaJtzKVIJTaj0UZU65+prvggGkjYwLKZBUfZFZVs1W0SnACyYlxlxXezUUHNTcKvojNRFsObl021XFmeVavanGKWOvcVnATpSU021hxUyR+MKEZkDc47aiYUrj5ZmWxxtYW/TLreKvu74Pg/ImnVUP5WjIly+n0btCcMEKd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IIzk+eCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IIzk+eCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB15C19423;
	Sat, 28 Feb 2026 17:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301122;
	bh=tJUV87vTmT9dZ7DTNLMeknaRoS7GilMtgP0SK0dQ57U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIzk+eCg0z8cGgmIbTJ6V6pGInZwB6+w4rasr4IOfW6Ik/Ccq1kR/pqZswwylWrSk
	 xfHg3xIMpeO1Lp5UcNH0SaipTszeEbWRTZD3210BzUegBSP/u6OhHtT7bBEyIqKfs+
	 V/bSvct1mH9Ynd22bfamRvQJcF9LAyqBax0Pcbry7bvb8WSX5zbCjb4iNpeNOlvqst
	 ivBw70+zq2K3J9EOgX8VGMBqtz4cCw+5BGAjOOFJCs9GJ7w7Rh5Wy/QHxiueEFciQn
	 pyungRKN/8o9a/qyZlagpbAtsuU3BqgceySWzOPDnEbNpcnCsB9BB0GZLxWOZ34Rb5
	 UP9rX/Ggan32A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Geetha sowjanya <gakula@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 280/752] octeontx2-af: Workaround SQM/PSE stalls by disabling sticky
Date: Sat, 28 Feb 2026 12:39:51 -0500
Message-ID: <20260228174750.1542406-280-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 70e9a5760abfb6338d63994d4de6b0778ec795d6 ]

NIX SQ manager sticky mode is known to cause stalls when multiple SQs
share an SMQ and transmit concurrently. Additionally, PSE may deadlock
on transitions between sticky and non-sticky transmissions. There is
also a credit drop issue observed when certain condition clocks are
gated.

work around these hardware errata by:
- Disabling SQM sticky operation:
  - Clear TM6 (bit 15)
  - Clear TM11 (bit 14)
- Disabling sticky → non-sticky transition path that can deadlock PSE:
  - Clear TM5 (bit 23)
- Preventing credit drops by keeping the control-flow clock enabled:
  - Set TM9 (bit 21)

These changes are applied via NIX_AF_SQM_DBG_CTL_STATUS. With this
configuration the SQM/PSE maintain forward progress under load without
credit loss, at the cost of disabling sticky optimizations.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260127125147.1642-1-gakula@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 828316211b245..c9c65ac69ead8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4932,12 +4932,18 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 	/* Set chan/link to backpressure TL3 instead of TL2 */
 	rvu_write64(rvu, blkaddr, NIX_AF_PSE_CHANNEL_LEVEL, 0x01);
 
-	/* Disable SQ manager's sticky mode operation (set TM6 = 0)
+	/* Disable SQ manager's sticky mode operation (set TM6 = 0, TM11 = 0)
 	 * This sticky mode is known to cause SQ stalls when multiple
-	 * SQs are mapped to same SMQ and transmitting pkts at a time.
+	 * SQs are mapped to same SMQ and transmitting pkts simultaneously.
+	 * NIX PSE may deadlock when there are any sticky to non-sticky
+	 * transmission. Hence disable it (TM5 = 0).
 	 */
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SQM_DBG_CTL_STATUS);
-	cfg &= ~BIT_ULL(15);
+	cfg &= ~(BIT_ULL(15) | BIT_ULL(14) | BIT_ULL(23));
+	/* NIX may drop credits when condition clocks are turned off.
+	 * Hence enable control flow clk (set TM9 = 1).
+	 */
+	cfg |= BIT_ULL(21);
 	rvu_write64(rvu, blkaddr, NIX_AF_SQM_DBG_CTL_STATUS, cfg);
 
 	ltdefs = rvu->kpu.lt_def;
-- 
2.51.0

