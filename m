Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066CA1891A5;
	Tue, 10 Sep 2024 09:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961081; cv=none; b=Jpbm/fsTrf1CysGGUbzZh5oAFLlxd4ehB5SaamBNZB+SaObcdQn+dCPi5+WvTR3HvzG9YmlYTDHSMm4UWRJpSlGYRdIcNChrPU0BItqLJxXI5eYvfVCJ7MLqtpEA0zcCWZM42o9WEfXpZGLQQU/+IM4Drk2DpVRPhEwI2dqEb34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961081; c=relaxed/simple;
	bh=yySG0NbyU0DQesgIqwJ9bw/65HZ5LFRqMtS/u+AbyAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFx2fNt2bAokvHHrW5Kv+NamqAfFipqlFt7BTYVwQ9WCI7S0j1FL/WM8eVG098kwLoPNR2/aOaBlI7TlvEQSoc6t9cBdwDeNZVsLg7DnmOYpQMxaFqgjWgp6i4DgpzStMwKh/PNLqPXWgQ0/7mL6kOe42kqFQiLNU/2YwtgbKoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOxSewz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOxSewz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F95CC4CEC3;
	Tue, 10 Sep 2024 09:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961080;
	bh=yySG0NbyU0DQesgIqwJ9bw/65HZ5LFRqMtS/u+AbyAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOxSewz8orBuCQYssr+7OInsLQeOpPWID+nAct0WrBKkg0UwdI78R/rcz9GyifAY2
	 reev+NaRwfkAj0v2ND3CEZwNzVISqtREC1kXdH9jGUKIsdwQeLLsEw0tn7acNKfUCL
	 W2S7LHFqlSJ7sthV5Hw+T2ynWKJUuYUPgJoOtPHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/96] net: bridge: fdb: convert is_sticky to bitops
Date: Tue, 10 Sep 2024 11:31:49 +0200
Message-ID: <20240910092543.600747835@linuxfoundation.org>
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

[ Upstream commit e0458d9a733ba71a2821d0c3fc0745baac697db0 ]

Straight-forward convert of the is_sticky field to bitops.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bee2ef946d31 ("net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_fdb.c     | 11 ++++++-----
 net/bridge/br_private.h |  4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 2639cc744bca..25aeaedce762 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -594,7 +594,8 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			unsigned long now = jiffies;
 
 			/* fastpath: update of existing entry */
-			if (unlikely(source != fdb->dst && !fdb->is_sticky)) {
+			if (unlikely(source != fdb->dst &&
+				     !test_bit(BR_FDB_STICKY, &fdb->flags))) {
 				fdb->dst = source;
 				fdb_modified = true;
 				/* Take over HW learned entry */
@@ -666,7 +667,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 		ndm->ndm_flags |= NTF_OFFLOADED;
 	if (fdb->added_by_external_learn)
 		ndm->ndm_flags |= NTF_EXT_LEARNED;
-	if (fdb->is_sticky)
+	if (test_bit(BR_FDB_STICKY, &fdb->flags))
 		ndm->ndm_flags |= NTF_STICKY;
 
 	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
@@ -787,7 +788,7 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 			 const u8 *addr, u16 state, u16 flags, u16 vid,
 			 u8 ndm_flags)
 {
-	u8 is_sticky = !!(ndm_flags & NTF_STICKY);
+	bool is_sticky = !!(ndm_flags & NTF_STICKY);
 	struct net_bridge_fdb_entry *fdb;
 	bool modified = false;
 
@@ -844,8 +845,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		modified = true;
 	}
 
-	if (is_sticky != fdb->is_sticky) {
-		fdb->is_sticky = is_sticky;
+	if (is_sticky != test_bit(BR_FDB_STICKY, &fdb->flags)) {
+		change_bit(BR_FDB_STICKY, &fdb->flags);
 		modified = true;
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index c3160d73e6ed..131e5be58468 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -172,6 +172,7 @@ struct net_bridge_vlan_group {
 enum {
 	BR_FDB_LOCAL,
 	BR_FDB_STATIC,
+	BR_FDB_STICKY,
 };
 
 struct net_bridge_fdb_key {
@@ -186,8 +187,7 @@ struct net_bridge_fdb_entry {
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



