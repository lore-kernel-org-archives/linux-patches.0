Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017BF3C2F;
	Wed, 21 Feb 2024 13:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522667; cv=none; b=joC8dHNWONphZGemTM5Zz+xVPpbE5dyurSWeEnoViS0eE1lFvVE73AsJ/LJpBz9FInwOi/Hb6mPa/NEGNwDqzZuvlA8fsLUnROxeU58MmmRxDextZN/gn/cA3i1hE697rh92Yj+Cw0H9ESUh0b3Hw4lpvPh5UmGOXzuH7fspEpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522667; c=relaxed/simple;
	bh=tF89mTYlCHXQNVRw7UkYcQbBXj2QzkGpopUuYDJLyVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSksu9PSHJQnt3jN+5MThfPsbDp+sLap+cZ62jl065KZVdaNdFWubPrrC5Vikv3p6bddJI8a3Cfd7vQ4j2UAK/ZGaDTky/Xk8gLvZmsiu6OSQP10v/5V9Vatho3iJmFEhVrS1uYrN2Txh9Cnh2UEc3oxHtagxBHs5QhvwBkWRxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xp1ohmaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xp1ohmaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67391C433C7;
	Wed, 21 Feb 2024 13:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522666;
	bh=tF89mTYlCHXQNVRw7UkYcQbBXj2QzkGpopUuYDJLyVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xp1ohmajIvrqPTvR3VRgAPD/SSCQbwPbWNv8ORdhbQteOaq6vxw9ecyxWVaprx5CE
	 lf2gcjQsAHHl6JW++SvNzax1iFrwoEj05ZHyRivcVp0Gjrkm3Y43OfnfNs5VWIfq04
	 ltZyCEmcd5CSMW4KLBPtwS582gSJUPjvQftlmBSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/476] octeontx2-af: Fix max NPC MCAM entry check while validating ref_entry
Date: Wed, 21 Feb 2024 14:04:18 +0100
Message-ID: <20240221130015.573887583@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8b16738e249f..70b4f2a3b02f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2625,18 +2625,17 @@ int rvu_mbox_handler_npc_mcam_alloc_entry(struct rvu *rvu,
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



