Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375B91C6A6;
	Sat,  3 Feb 2024 04:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933833; cv=none; b=D+2l7NvLFM2/Q1xxCxRhvaNVtZowCyx5Hf65RiqGf2Tt0shZMBFexJttaoEGcfLYdDw4lauP9hn5tTfV5Mi4F4Hf4xHEh0y50EMrL9xiJKRhYrTrikEqotcQ85FhoRjfb53+APLVBaE0LRSR7n/8J3h0ekEmg2exZ6z3oC8cstw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933833; c=relaxed/simple;
	bh=dGqdXI1MAbKuELzdEdGvKu+K2DHtm0Ss+8CVxPkuR4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEnNbYBhK3jx4bRBZxP/8UtPvoQDzcNNlKRQdcnFUHpQWIYV6FmjahjsvEtxsKFDMofC4DS09PFg5DMQsX2yzil1n5D+HAYbtc90VEFbXaVmxChi96YZhrFRsWyhCHkedUT6Jp6JI2T6bNFQbY3u46308k29L+ajc0/ui6JEJ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rr8WlhWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rr8WlhWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBC2C433F1;
	Sat,  3 Feb 2024 04:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933833;
	bh=dGqdXI1MAbKuELzdEdGvKu+K2DHtm0Ss+8CVxPkuR4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rr8WlhWzSWGct59CY/epH+GNNpLtaDG6OV5qF4sm/2m2f7XEXpQz0TEUy7zk94g+r
	 8z7ZH5f909HZb4on+FfnHX1+o0AQbtiYRpxVKCmF7ewcyrOPnIZ4AoO6WN9/3jPEXp
	 2LBXy7IiMKugSDwlRiTIAVxFTWWTn2j0nNtGFoC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 157/353] octeontx2-af: Fix max NPC MCAM entry check while validating ref_entry
Date: Fri,  2 Feb 2024 20:04:35 -0800
Message-ID: <20240203035408.622424248@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



