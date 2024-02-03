Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADA212B6D;
	Sat,  3 Feb 2024 04:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933615; cv=none; b=SF6OzaK4WgP9I+qZdk3SwgODS04KB/qB0UG/gMPMX2AFAYK2RxU2GQ7Qs4WSLqi+eoGnQ8+dWRRV13wXZcylmoTuZ4NuyZFuTvbSU0NyoMuuiJThWwa5zbbS8c2tOGlAtsHU81/i1VnMD9o1+Wmr8VayLMV+/4vXQn0RN1/cVVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933615; c=relaxed/simple;
	bh=ute1/YNO8ax1hdySBM31DO5zquvdHAzZioX6q0fjoI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRciTzV7t2HYBlp1DLchODiOwnTjRyfao/KDOyvD/4iWn6/Sy/VraQzdTcUfXJ1XhQqCNFtkyeatXdRBPt352cANeAPW+ySwVTQttNITQQaTmzm9iQbipf04895r0wGuFSMbdlNGnZf1r4zc8chH4bQ9SSApck1SaYrWfxLQGf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0fKWaTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0fKWaTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F3BC433C7;
	Sat,  3 Feb 2024 04:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933615;
	bh=ute1/YNO8ax1hdySBM31DO5zquvdHAzZioX6q0fjoI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0fKWaTLdHTX7lwOz3qdvRKpAvvj20py5Z/xA5NmkEzWUHICbw+ZbrGdpgCdAVVKQ
	 l2KOeB/IaSJAxJ6kW3eG5uT3aVEFmrtkiQoDqDv/f5wWYDvMsqDv5kdLxKuYa481Lm
	 4Sia+MbcjfgsEhjGZlPuIXdYoaOmKt8YV0Bug+Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/322] octeontx2-af: Fix max NPC MCAM entry check while validating ref_entry
Date: Fri,  2 Feb 2024 20:04:11 -0800
Message-ID: <20240203035404.185274947@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 4ebb1f95e0c3c3e0eec5bb21aa43097580c4b6e4 ]

As of today, the last MCAM entry was not getting allocated because of
a <= check with the max_bmap count. This patch modifies that and if the
requested entry is greater than the available entries then set it to the
max value.

Signed-off-by: Suman Ghosh <sumang@marvell.com>
Link: https://lore.kernel.org/r/20240101145042.419697-1-sumang@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 0bcf3e559280..3784347b6fd8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2678,18 +2678,17 @@ int rvu_mbox_handler_npc_mcam_alloc_entry(struct rvu *rvu,
 	rsp->entry = NPC_MCAM_ENTRY_INVALID;
 	rsp->free_count = 0;
 
-	/* Check if ref_entry is within range */
-	if (req->priority && req->ref_entry >= mcam->bmap_entries) {
-		dev_err(rvu->dev, "%s: reference entry %d is out of range\n",
-			__func__, req->ref_entry);
-		return NPC_MCAM_INVALID_REQ;
-	}
+	/* Check if ref_entry is greater that the range
+	 * then set it to max value.
+	 */
+	if (req->ref_entry > mcam->bmap_entries)
+		req->ref_entry = mcam->bmap_entries;
 
 	/* ref_entry can't be '0' if requested priority is high.
 	 * Can't be last entry if requested priority is low.
 	 */
 	if ((!req->ref_entry && req->priority == NPC_MCAM_HIGHER_PRIO) ||
-	    ((req->ref_entry == (mcam->bmap_entries - 1)) &&
+	    ((req->ref_entry == mcam->bmap_entries) &&
 	     req->priority == NPC_MCAM_LOWER_PRIO))
 		return NPC_MCAM_INVALID_REQ;
 
-- 
2.43.0



