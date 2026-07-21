Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED8033ADB0;
	Tue, 21 Jul 2026 19:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660964; cv=none; b=QU+y9Sn5H9YnRlW6WumQeySOa42sEk641Ev3XvPlpERJMfrLsiblltpL6uI/K231pnefP1GY8jWg4gMwp6ZOsfYWX8Aii1ciBQs6IgGilD3JiLDMXdd70BlI/W21Cmv4ueTss9qybMPTOcc5U834DMjgS691vzfS9kOaCl9NwG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660964; c=relaxed/simple;
	bh=ixKD82ouBNpBstbN5NyRaJAzhjjChE6xXNQksAD+iqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/Xu8Ws5ZiAk3ugBIHxMRJyN+Vno9RAa5D5Os0XZNZ//pOpAOhH3yquuhPMd9jWeDzrzdcOMZ8fbBRcrs7zBbwP2QVtYkqHeVGxKdFoiwPLEB3EMz4QGEbgYICapszqOtPwyVBwiQ+pvgjdlhDazFU6ZblFoW+1oWmJO2vevbUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQtJYAch; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQtJYAch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CB11F000E9;
	Tue, 21 Jul 2026 19:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660963;
	bh=AzO9W6he5U69tOVP89tGZFUTuJDI8A5pAr1JWEzcWsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQtJYAchwYufqkib8doUgjXEnRLa6w/oxzd+9ApI5SvlcIU8p8GUfbNNqWT1VjcVk
	 xZ9AIipvLhR5J6/BYN8n6URiKB8XpEkLEd99ZtpDH6n36kGhGmYNXdUERNEKYv/kbO
	 IlbF37luZSbiQbUFUmjXaw9mlQbt3tqahPckjY2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1179/2077] octeontx2-af: npc: cn20k: fix NPC defrag
Date: Tue, 21 Jul 2026 17:14:12 +0200
Message-ID: <20260721152620.628821634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 48b67c0e8af65acd59d81ddaedd3442b5e4c27b7 ]

npc_defrag_alloc_free_slots() always passed NPC_MCAM_KEY_X2 into
__npc_subbank_alloc(), which must match sb->key_type, so defrag never
allocated replacement slots on X4 banks. Pass the subbank key type for
bank 0, and only extend the search into bank 1 for X2 (X4 MCAM indices
are confined to b0b..b0t).

Fixes: 645c6e3c1999 ("octeontx2-af: npc: cn20k: virtual index support")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260617102149.1309913-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
index fe8c4ffcd8f738..5dfdfbabfaddc2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
@@ -3542,15 +3542,18 @@ static int npc_defrag_alloc_free_slots(struct rvu *rvu,
 	alloc_cnt2 = 0;
 
 	rc = __npc_subbank_alloc(rvu, sb,
-				 NPC_MCAM_KEY_X2, sb->b0b,
+				 f->key_type, sb->b0b,
 				 sb->b0t,
 				 NPC_MCAM_LOWER_PRIO,
 				 false, cnt, save, cnt, true,
 				 &alloc_cnt1);
 
-	if (alloc_cnt1 < cnt) {
+	/* X4 entries only occupy bank 0 (b0b..b0t); see npc_subbank_idx_2_mcam_idx().
+	 * X2 uses both halves of the subbank, so spill into bank 1 if needed.
+	 */
+	if (alloc_cnt1 < cnt && f->key_type == NPC_MCAM_KEY_X2) {
 		rc = __npc_subbank_alloc(rvu, sb,
-					 NPC_MCAM_KEY_X2, sb->b1b,
+					 f->key_type, sb->b1b,
 					 sb->b1t,
 					 NPC_MCAM_LOWER_PRIO,
 					 false, cnt - alloc_cnt1,
-- 
2.53.0



