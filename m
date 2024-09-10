Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC08F188CC1;
	Tue, 10 Sep 2024 09:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961069; cv=none; b=bamFpYGywOVQ4mFCDDbWZUgQLn7srIyn9mwbqWgrJxldjKMach8ZRDaMSyMMr2R4xzL1g1xD7wAbMgxTHFq/IEo8Wc3SeaeeEaA7oXLQynTqW+DQGsgcQ6Otmk3d+1LK+z8fCKwdZf2MnPmtRBwlb5ZTZqyZiEsF0IBVMEuMyZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961069; c=relaxed/simple;
	bh=KntH8ygOtx5uIYAT0J6f3/24CdXCfsPSh7ItyEce8gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKoOx41UJF2l7Y+ui+Gz5BsNQt0UyHP0c5iHcy+1i5ogHb6bVx+MfnlW85IuKok/5+gFIk24OiDrt7A+uQ16W9PqzKBOjnw1/SDEj99mThb/keqfj8ABS0E2T6SL93+4XUFJNop3l9GOdz4LrY4zhvQX93JqdKjKNwzs88C08ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMyvFZgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMyvFZgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6484EC4CECC;
	Tue, 10 Sep 2024 09:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961068;
	bh=KntH8ygOtx5uIYAT0J6f3/24CdXCfsPSh7ItyEce8gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xMyvFZgvDfJEEjJGMbDLy3HdhRdOj90WsCERC131ndIOrdN9bF43ICZkEyyAvfwy+
	 E3bD56da2wwNuY4qkJToe2zcGZmU+H6Jcj62gjgw+C/k51YEgiYK74+1esNRYXECtx
	 S7LgQ3xK/lZLNquTq7SBPAvYDThLG/yhJb6dy1BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/96] net: bridge: add support for sticky fdb entries
Date: Tue, 10 Sep 2024 11:31:45 +0200
Message-ID: <20240910092543.437783356@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit 435f2e7cc0b783615d7fbcf08f5f00d289f9caeb ]

Add support for entries which are "sticky", i.e. will not change their port
if they show up from a different one. A new ndm flag is introduced for that
purpose - NTF_STICKY. We allow to set it only to non-local entries.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bee2ef946d31 ("net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/neighbour.h |  1 +
 net/bridge/br_fdb.c            | 19 ++++++++++++++++---
 net/bridge/br_private.h        |  1 +
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index 904db6148476..998155444e0d 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -43,6 +43,7 @@ enum {
 #define NTF_PROXY	0x08	/* == ATF_PUBL */
 #define NTF_EXT_LEARNED	0x10
 #define NTF_OFFLOADED   0x20
+#define NTF_STICKY	0x40
 #define NTF_ROUTER	0x80
 
 /*
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 4d4b9b5ea1c1..1714f4e91fca 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -584,7 +584,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			unsigned long now = jiffies;
 
 			/* fastpath: update of existing entry */
-			if (unlikely(source != fdb->dst)) {
+			if (unlikely(source != fdb->dst && !fdb->is_sticky)) {
 				fdb->dst = source;
 				fdb_modified = true;
 				/* Take over HW learned entry */
@@ -656,6 +656,8 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 		ndm->ndm_flags |= NTF_OFFLOADED;
 	if (fdb->added_by_external_learn)
 		ndm->ndm_flags |= NTF_EXT_LEARNED;
+	if (fdb->is_sticky)
+		ndm->ndm_flags |= NTF_STICKY;
 
 	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
 		goto nla_put_failure;
@@ -772,8 +774,10 @@ int br_fdb_dump(struct sk_buff *skb,
 
 /* Update (create or replace) forwarding database entry */
 static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
-			 const __u8 *addr, __u16 state, __u16 flags, __u16 vid)
+			 const u8 *addr, u16 state, u16 flags, u16 vid,
+			 u8 ndm_flags)
 {
+	u8 is_sticky = !!(ndm_flags & NTF_STICKY);
 	struct net_bridge_fdb_entry *fdb;
 	bool modified = false;
 
@@ -789,6 +793,9 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		return -EINVAL;
 	}
 
+	if (is_sticky && (state & NUD_PERMANENT))
+		return -EINVAL;
+
 	fdb = br_fdb_find(br, addr, vid);
 	if (fdb == NULL) {
 		if (!(flags & NLM_F_CREATE))
@@ -832,6 +839,12 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 
 		modified = true;
 	}
+
+	if (is_sticky != fdb->is_sticky) {
+		fdb->is_sticky = is_sticky;
+		modified = true;
+	}
+
 	fdb->added_by_user = 1;
 
 	fdb->used = jiffies;
@@ -865,7 +878,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 	} else {
 		spin_lock_bh(&br->hash_lock);
 		err = fdb_add_entry(br, p, addr, ndm->ndm_state,
-				    nlh_flags, vid);
+				    nlh_flags, vid, ndm->ndm_flags);
 		spin_unlock_bh(&br->hash_lock);
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7ca3b469242e..4e0c6f9d9c16 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -181,6 +181,7 @@ struct net_bridge_fdb_entry {
 	struct hlist_node		fdb_node;
 	unsigned char			is_local:1,
 					is_static:1,
+					is_sticky:1,
 					added_by_user:1,
 					added_by_external_learn:1,
 					offloaded:1;
-- 
2.43.0



