Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B45D3BF317;
	Thu, 15 Jan 2026 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497129; cv=none; b=O3O5Kx3RXY7H68WpKd36ShOlF2ZWCgnD36Q658VHKGJIjKUl1eaV6uv6WIzH0wlx0ccfsBPd7MxRGgHv3KH1qCq1011VkcqGf6Ry7gd9gATKHIM5XMFn4SlMo02KQXfMoph7nvDgot8A+FnCZ3FVIk8RSCabBh2Vwz3CUDvLtKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497129; c=relaxed/simple;
	bh=pvwEwWRZ5wtI1lSWnT2M3N/eU8O4HzIHTP6pEO21n2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFFhPHxl0O/YL5BcPVxd3kDMdeuDN/3c0Pg7SxBM5JbVB7acnhLkEJ6riGbRUkUSi6QcN7oLSdELpMGWy61gUPCV6OPqzZ2OMf8R1nT/c8lHCy+aG8+1Tf/Hh0QXiJIi78h2lF4qhZVbhzP05fi5Ymd2NtA5VB6Azpoh0dWUc/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSgszoQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSgszoQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A08C16AAE;
	Thu, 15 Jan 2026 17:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497129;
	bh=pvwEwWRZ5wtI1lSWnT2M3N/eU8O4HzIHTP6pEO21n2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSgszoQA54tA8wKlc1Y4oxyCrb1XWnOTdxb7tGAjR0NkTL8zdoHhrFb4hJIl7Rqcl
	 7lJ/0v2i+a1HI8Qbp7cymCuuxKJr4pQqjbwOQBUSCxDqlzlo/r8/oEslnk7+sH/NAQ
	 GYNrW8obSccLnJ1Glj2prCzw/eHlLrOjcJ7z8Y98=
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
Subject: [PATCH 6.1 45/72] bnxt_en: Fix potential data corruption with HW GRO/LRO
Date: Thu, 15 Jan 2026 17:48:55 +0100
Message-ID: <20260115164145.128388931@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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
index 2540402030bf1..a70870393b65c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1306,9 +1306,11 @@ static u16 bnxt_alloc_agg_idx(struct bnxt_rx_ring_info *rxr, u16 agg_id)
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
@@ -1341,6 +1343,13 @@ static void bnxt_tpa_start(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
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
index 111098b4b6062..4d27636aa200d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -897,11 +897,9 @@ struct bnxt_tpa_info {
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



