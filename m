Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1EE18787E;
	Tue, 10 Sep 2024 10:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962609; cv=none; b=LmGR8fWM6DlncCBNVaDs/hRqYYdXpxnJwELX8bDPF748aV8WNRJZe0r/6KKIKCPINOW1DeWhlZKpVdcoK2dz9DyQ19iACrZAkWHPtwhSOoRrjXw/BN6fHVQAfpZO1sQJ5veK4ZqJK23VyjMC4uJ0XydnYnJuihRHwsxKVLPztmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962609; c=relaxed/simple;
	bh=/qnrScxAg4XB+qd36YPz2Puuvuw7bZypGOcpdyoFx18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOrwSwi+meTcgEIMUOImmhFP4trPALiyvtNJBjqo4y9rkTaaGbT/5FJ4sw8ustKihyayqHUZZB+8OasR25ZRnaaGUFJwakLNKEEec4GxociYGgMzkETPOn9jJ9nY1ARn7weSJCUlLU8iJ4Jh9iHW1ibXmzgjzYbhFWbyST6LLV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w12LNlsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w12LNlsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A85C4CEC3;
	Tue, 10 Sep 2024 10:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962609;
	bh=/qnrScxAg4XB+qd36YPz2Puuvuw7bZypGOcpdyoFx18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w12LNlskEAaR8ReTk5UkY2QD5/nAKDfa9v6yzAGVNP/GXtq9DlmCmDh+BbLdgRTcb
	 B+cLF6MP8Sw6qhOTL0mysdaCKzHYYUfJYo+zqhEfu+MBqiD8paIsix07KpRSx2rOux
	 /Xv4Q92naTChSRoAt2++OJNfICbSITwHgxFJ4eSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/121] net: bridge: fdb: convert is_sticky to bitops
Date: Tue, 10 Sep 2024 11:32:19 +0200
Message-ID: <20240910092548.899628977@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit e0458d9a733ba71a2821d0c3fc0745baac697db0 ]

Straight-forward convert of the is_sticky field to bitops.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bee2ef946d31 ("net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_fdb.c     | 12 ++++++------
 net/bridge/br_private.h |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 1c890e2d694b..3645c1172b50 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -509,7 +509,6 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 		fdb->added_by_user = 0;
 		fdb->added_by_external_learn = 0;
 		fdb->offloaded = 0;
-		fdb->is_sticky = 0;
 		fdb->updated = fdb->used = jiffies;
 		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
 						  &fdb->rhnode,
@@ -590,7 +589,8 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			unsigned long now = jiffies;
 
 			/* fastpath: update of existing entry */
-			if (unlikely(source != fdb->dst && !fdb->is_sticky)) {
+			if (unlikely(source != fdb->dst &&
+				     !test_bit(BR_FDB_STICKY, &fdb->flags))) {
 				fdb->dst = source;
 				fdb_modified = true;
 				/* Take over HW learned entry */
@@ -662,7 +662,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 		ndm->ndm_flags |= NTF_OFFLOADED;
 	if (fdb->added_by_external_learn)
 		ndm->ndm_flags |= NTF_EXT_LEARNED;
-	if (fdb->is_sticky)
+	if (test_bit(BR_FDB_STICKY, &fdb->flags))
 		ndm->ndm_flags |= NTF_STICKY;
 
 	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
@@ -809,7 +809,7 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 			 const u8 *addr, u16 state, u16 flags, u16 vid,
 			 u8 ndm_flags)
 {
-	u8 is_sticky = !!(ndm_flags & NTF_STICKY);
+	bool is_sticky = !!(ndm_flags & NTF_STICKY);
 	struct net_bridge_fdb_entry *fdb;
 	bool modified = false;
 
@@ -866,8 +866,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		modified = true;
 	}
 
-	if (is_sticky != fdb->is_sticky) {
-		fdb->is_sticky = is_sticky;
+	if (is_sticky != test_bit(BR_FDB_STICKY, &fdb->flags)) {
+		change_bit(BR_FDB_STICKY, &fdb->flags);
 		modified = true;
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7b46323584be..b495778911a2 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -176,6 +176,7 @@ struct net_bridge_vlan_group {
 enum {
 	BR_FDB_LOCAL,
 	BR_FDB_STATIC,
+	BR_FDB_STICKY,
 };
 
 struct net_bridge_fdb_key {
@@ -190,8 +191,7 @@ struct net_bridge_fdb_entry {
 	struct net_bridge_fdb_key	key;
 	struct hlist_node		fdb_node;
 	unsigned long			flags;
-	unsigned char			is_sticky:1,
-					added_by_user:1,
+	unsigned char			added_by_user:1,
 					added_by_external_learn:1,
 					offloaded:1;
 
-- 
2.43.0



