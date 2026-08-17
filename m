Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEC3443E22;
	Mon, 17 Aug 2026 15:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980283; cv=none; b=BpqD0pRdQBugKTRf7zUzUCBYjG/jrQkTLXxUzGgvYamEd/wcHr4ILMrViBUjxprTgHLAkKahHpGoI+2omb46Xyc2DoQ+wEEXtrJ/r5gmdPBJ7Jh6Cflav+KVmEL8D++iBKjP3BUCLqzVZ8TG4tAMCe+ZMdE4qIi9uthm8eNS7Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980283; c=relaxed/simple;
	bh=8uW3MV6lhajFsvFt35ClnFibktg5vHBKa0XLYDe77fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HznylbhbuV6A6eOpX41ileKUzfknXsgq5+j2FX/t972PJCupCoYEpQEyTC4IOvuRLaJDQsUH2NspzNBuUodqHNAkP+XVPhTEOutBKN9FywLxMec/XhaerRLY1UMkEnw1IB3VUIlV+r3BqMKiCmaYRviwNTLLm1tRa1kmIZ4PKg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+zBvhnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+zBvhnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118E81F000E9;
	Mon, 17 Aug 2026 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980282;
	bh=nO1GG/zc/gPepdLnPjmjgXmXawZTxtym/S0u3W/ZCJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+zBvhnv0vgqvQ7G/1aPE3d9dEzABRSSBPyUiMt1+2UioMwww5G8MnvECdFdDf+xU
	 jVeyZG1GxYdn4Y7Sx8KlNL3AMcTmMcHa2bEf0oOl+20Jji7X//+lREYGZn3hKeslWE
	 gC2z6i5ygT2JJLdAsnp93pz+t6kDjNwgLqFxSqZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 518/609] bnxt_en: Disable EOP for TPA on all chips to prevent data corruption
Date: Mon, 17 Aug 2026 15:33:34 +0200
Message-ID: <20260817132601.166389430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit c3faf548a00f4c17100cc9204746975fa46a73b9 ]

EOP (End of frame padding) on the AGG ring may cause overlapping of
zero padding at the end of one segment with the next segment's data.
If Relaxed Ordering (RO) is enabled, the zero padding may overwrite
valid data in the next segment and corrupt the data.  Older chips
(P5 and older) do not automatically disable RO when EOP is enabled.
On some ARM systems, data corruption was reported on 57508 (P5)
chips with RO enabled.

Always disable EOP on all chips on the AGG rings when TPA is enabled
to fix the data corruption.

Fixes: bfcd8d791ec1 ("bnxt_en: Add fast path logic for TPA on 57500 chips.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260731190937.807270-5-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f11ca14c5c4d3..f69ad1ffc0c9d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3766,11 +3766,14 @@ static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
 		type = ((u32)BNXT_RX_PAGE_SIZE << RX_BD_LEN_SHIFT) |
 			RX_BD_TYPE_RX_AGG_BD;
 
-		/* On P7, setting EOP will cause the chip to disable
-		 * Relaxed Ordering (RO) for TPA data.  Disable EOP for
-		 * potentially higher performance with RO.
+		/* Disable EOP if TPA is enabled to prevent overlapping zero
+		 * padding with the next segment's data.  On P7_PLUS, EOP will
+		 * automatically disable Relaxed Ordering (RO) to prevent
+		 * potential data corruption (and may degrade performance).  On
+		 * older chips, RO will not be automatically disabled and may
+		 * cause corruption.
 		 */
-		if (BNXT_CHIP_P5_AND_MINUS(bp) || !(bp->flags & BNXT_FLAG_TPA))
+		if (!(bp->flags & BNXT_FLAG_TPA))
 			type |= RX_BD_FLAGS_AGG_EOP;
 
 		bnxt_init_rxbd_pages(ring, type);
-- 
2.53.0



