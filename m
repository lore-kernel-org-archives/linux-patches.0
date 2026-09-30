Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF4A404882;
	Wed, 30 Sep 2026 19:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795186; cv=none; b=s5wE0WFbfLfgMfWL1ucKGpWvzi0ZJRDtOK0rtGsLPOL05WkqsdkLKkqqDfmRL2BVeZR76ewOTNxmOx1bBy1uBiVAqxradtJ3umGVn4v9hzG9Yd7nqGHGoOt+wJ6GDEpYETQl6S1BXR+nhW9CLVPxCW20KCrUyY4CzuBKbCLhOX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795186; c=relaxed/simple;
	bh=PpISj8sr9jmd9uQcBIyPp7pcW5CAA8o6pjH+dfNoKC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPC7ls0Fm5wc/dyRtjSmwowBs+yrHRXeJ6lYtFVxSQmSUd8D23dGnmj4rJTBgqwFo6AW6j7kg+hi4NQlttKrrd+fYhNCiaZhHZTGsh9s0LkFYSWuI2DZ2HO/tP4+INRospNR9UDlmMA5FWdGTTm05GzA+sIMcRue17mz6/0HO9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mLhvFGnZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLhvFGnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9E61F000FF;
	Wed, 30 Sep 2026 19:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795185;
	bh=ch6OipuWh6bC+SBYGPz/ep0OK10BAeaAk1KH/9OxX0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLhvFGnZ/lLxa7Sf1OP95vLegF6+4lRGB6YzdZxp7g6hRofJ3AYNHZk0Ln21q49A1
	 6KU+tpCuDCBzKw6h2+UpQmUbmf8peHteWs6bTsTsdOOdknCzVBiZgveKWwqMM/mx+I
	 IrWfkWeR9aipL7KFDKRmR4BI3UslYjXnk56xYF+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0428/1193] tipc: fix NULL deref in tipc_named_node_up() on empty publication list
Date: Wed, 30 Sep 2026 17:18:32 +0200
Message-ID: <20260930152443.706787139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tung Nguyen <tung.quang.nguyen@est.tech>

[ Upstream commit b3b76e9f4f2476f1135b2ba7743a821db4a0df4b ]

User-space applications can bind a large number of service addresses to
one or more sockets. Each binding of a local-scope service address inserts
one entry (publication) into the TIPC name table. If the number of these
publications exceeds TIPC_MAX_PUBL (65535), protocol service types
(such as node state and link state) are no longer inserted into the name
table. This causes two issues:

1. User-space applications subscribing to node or link up/down events
   stop receiving notifications.

2. A NULL pointer dereference can occur:

   BUG: kernel NULL pointer dereference, address: 00000000000000d0
   ...
   CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.2.0-rc4-default+ #5 PREEMPT(full)
   ...
   RIP: 0010:tipc_named_node_up (./include/linux/skbuff.h:2251 net/tipc/name_distr.c:195 net/tipc/name_distr.c:221)
   ...
   Call Trace:
   <IRQ>
   tipc_node_write_unlock (net/tipc/node.c:428)
   tipc_rcv (net/tipc/node.c:934 net/tipc/node.c:2189)
   tipc_udp_recv (net/tipc/udp_media.c:389)

   Thread 1 (tipc_net_finalize) | Thread 2 (named_distribute)
   -----------------------------|-----------------------------
                                | ...
                                | list_for_each_entry(publ, pls, binding_node) {
                                | ...
                                | __skb_queue_tail(list, skb);
                                | ...
                                | }
                                | ...
                                | hdr = buf_msg(skb_peek_tail(list));
   ...                          |
   tipc_nametbl_publish();      |

   If 'tipc_nametbl_publish()' (Thread 1) fails because the number of
   local publications reaches TIPC_MAX_PUBL, list (Thread 2) will be empty. As a
   result, NULL is passed to 'buf_msg()', leading to a NULL pointer dereference.

Fix these issues by allowing protocol service types (node state, link state,
and topology server) to be inserted into the name table unconditionally.
This ensures that users subscribing to these types always receive
notifications. In addition, the maximum number of local user publications is
reduced to (TIPC_MAX_PUBL - 1). This ensures that the maximum bulk size
calculated in tipc_link_set_queue_limits() remains valid.

Fixes: a5e7ac5ce134 ("tipc: fix regression bug where node events are not being generated")
Reported-by: Xiang Mei <xmei5@asu.edu>
Tested-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260827111418.164957-1-tung.quang.nguyen@est.tech
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/name_table.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index e6555254ddb85..d28fe53d2cb06 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -763,21 +763,40 @@ struct publication *tipc_nametbl_publish(struct net *net, struct tipc_uaddr *ua,
 					 struct tipc_socket_addr *sk, u32 key)
 {
 	struct name_table *nt = tipc_name_table(net);
+	u32 max_user_pub = TIPC_MAX_PUBL - 1;
 	struct tipc_net *tn = tipc_net(net);
 	struct publication *p = NULL;
 	struct sk_buff *skb = NULL;
+	bool protocol_type = false;
 	u32 rc_dests;
 
+	if (ua->sr.type == TIPC_NODE_STATE || ua->sr.type == TIPC_LINK_STATE ||
+	    ua->sr.type == TIPC_TOP_SRV)
+		protocol_type = true;
+
 	spin_lock_bh(&tn->nametbl_lock);
+	if (protocol_type)
+		goto insert;
 
-	if (nt->local_publ_count >= TIPC_MAX_PUBL) {
-		pr_warn("Bind failed, max limit %u reached\n", TIPC_MAX_PUBL);
+	/* Reserve one entry for node state service type because it has cluster
+	 * scope and it is distributed in bulk. So, the maximum number of user's
+	 * publications is (TIPC_MAX_PUBL - 1).
+	 */
+	if (nt->local_publ_count >= max_user_pub) {
+		pr_warn("Bind failed, max limit %u reached\n", max_user_pub);
 		goto exit;
 	}
 
+insert:
 	p = tipc_nametbl_insert_publ(net, ua, sk, key);
 	if (p) {
-		nt->local_publ_count++;
+		/* Not count node state, link state and topology server types
+		 * so that maximum nt->local_publ_count does not prevent
+		 * protocol service types from being inserted into the name
+		 * table.
+		 */
+		if (!protocol_type)
+			nt->local_publ_count++;
 		skb = tipc_named_publish(net, p);
 	}
 	rc_dests = nt->rc_dests;
@@ -810,7 +829,10 @@ void tipc_nametbl_withdraw(struct net *net, struct tipc_uaddr *ua,
 
 	p = tipc_nametbl_remove_publ(net, ua, sk, key);
 	if (p) {
-		nt->local_publ_count--;
+		if (p->sr.type != TIPC_NODE_STATE &&
+		    p->sr.type != TIPC_LINK_STATE &&
+		    p->sr.type != TIPC_TOP_SRV)
+			nt->local_publ_count--;
 		skb = tipc_named_withdraw(net, p);
 		list_del_init(&p->binding_sock);
 		kfree_rcu(p, rcu);
-- 
2.53.0



