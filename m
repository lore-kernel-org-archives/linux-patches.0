Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C891A2389;
	Thu, 15 Jan 2026 17:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498734; cv=none; b=AdjSJLyTarqMng1Iij21O8VwmxQCarhUuQyuIIYbvsHoBrHI1MmexgC1A3GIk0p/9TOfRoDUb9BhA0oSEjUBKfiA9uCUxY/+TX81DMzHhviPXHbQSB7r/M2Gm6UzfF0BsrJlJt8TTNdqdQYc0ZNwANqMOdNv+eYJYOgmFFFanno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498734; c=relaxed/simple;
	bh=zKyaV/IL6eKwJ6C/kmgq33YpkFpFuuQiZUfvu2UZwiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ro1alQ/gWam1kzyydyCnyjXlvnrB5iDsmi3XxbiaNbgcWe/0ZC+m6hGfDXG45OjpQ35l+f/X4+WuvJ4WSoTEIdxiYiohikq3HofWVLElYQh2LalLs/8uxRoUuXjrBxSoFcja5zZmwB+q9HG9fU7qY6FQIo0yszI1fDZBtNH5Twg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9CFz6tp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9CFz6tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561FDC116D0;
	Thu, 15 Jan 2026 17:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498734;
	bh=zKyaV/IL6eKwJ6C/kmgq33YpkFpFuuQiZUfvu2UZwiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9CFz6tpficxMzmsyIJEJmDWO6/Fwile8Z2bhM2Yz8iVdbgHq+yCZbZtIS6WLboA6
	 WtAX/cipLkQyHYntEzCuPwzfSjxLF5tx5QyiGsUd+93iay6FZCVKGF7YDS+Rn3TEVb
	 BO9sM1OpqhjGs1s1FtL9o9mFXSvgAv9Eofl2KpIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Jui <ray.jui@broadcom.com>,
	Srijit Bose <srijit.bose@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 536/554] bnxt_en: Fix potential data corruption with HW GRO/LRO
Date: Thu, 15 Jan 2026 17:50:02 +0100
Message-ID: <20260115164305.728269719@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srijit Bose <srijit.bose@broadcom.com>

[ Upstream commit ffeafa65b2b26df2f5b5a6118d3174f17bd12ec5 ]

Fix the max number of bits passed to find_first_zero_bit() in
bnxt_alloc_agg_idx().  We were incorrectly passing the number of
long words.  find_first_zero_bit() may fail to find a zero bit and
cause a wrong ID to be used.  If the wrong ID is already in use, this
can cause data corruption.  Sometimes an error like this can also be
seen:

bnxt_en 0000:83:00.0 enp131s0np0: TPA end agg_buf 2 != expected agg_bufs 1

Fix it by passing the correct number of bits MAX_TPA_P5.  Use
DECLARE_BITMAP() to more cleanly define the bitmap.  Add a sanity
check to warn if a bit cannot be found and reset the ring [MChan].

Fixes: ec4d8e7cf024 ("bnxt_en: Add TPA ID mapping logic for 57500 chips.")
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Srijit Bose <srijit.bose@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20251231083625.3911652-1-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 15 ++++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  4 +---
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 90719916184db..74344722d63d1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1264,9 +1264,11 @@ static u16 bnxt_alloc_agg_idx(struct bnxt_rx_ring_info *rxr, u16 agg_id)
 	struct bnxt_tpa_idx_map *map = rxr->rx_tpa_idx_map;
 	u16 idx = agg_id & MAX_TPA_P5_MASK;
 
-	if (test_bit(idx, map->agg_idx_bmap))
-		idx = find_first_zero_bit(map->agg_idx_bmap,
-					  BNXT_AGG_IDX_BMAP_SIZE);
+	if (test_bit(idx, map->agg_idx_bmap)) {
+		idx = find_first_zero_bit(map->agg_idx_bmap, MAX_TPA_P5);
+		if (idx >= MAX_TPA_P5)
+			return INVALID_HW_RING_ID;
+	}
 	__set_bit(idx, map->agg_idx_bmap);
 	map->agg_id_tbl[agg_id] = idx;
 	return idx;
@@ -1299,6 +1301,13 @@ static void bnxt_tpa_start(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	if (bp->flags & BNXT_FLAG_CHIP_P5) {
 		agg_id = TPA_START_AGG_ID_P5(tpa_start);
 		agg_id = bnxt_alloc_agg_idx(rxr, agg_id);
+		if (unlikely(agg_id == INVALID_HW_RING_ID)) {
+			netdev_warn(bp->dev, "Unable to allocate agg ID for ring %d, agg 0x%x\n",
+				    rxr->bnapi->index,
+				    TPA_START_AGG_ID_P5(tpa_start));
+			bnxt_sched_reset_rxr(bp, rxr);
+			return;
+		}
 	} else {
 		agg_id = TPA_START_AGG_ID(tpa_start);
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index ae4695fc067d5..56aae0d654e8a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -872,11 +872,9 @@ struct bnxt_tpa_info {
 	struct rx_agg_cmp	*agg_arr;
 };
 
-#define BNXT_AGG_IDX_BMAP_SIZE	(MAX_TPA_P5 / BITS_PER_LONG)
-
 struct bnxt_tpa_idx_map {
 	u16		agg_id_tbl[1024];
-	unsigned long	agg_idx_bmap[BNXT_AGG_IDX_BMAP_SIZE];
+	DECLARE_BITMAP(agg_idx_bmap, MAX_TPA_P5);
 };
 
 struct bnxt_rx_ring_info {
-- 
2.51.0



