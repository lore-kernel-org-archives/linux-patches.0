Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8B1335BAD;
	Mon, 18 Aug 2025 13:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524899; cv=none; b=lraAhj1lGd/mVstXY1WANqaJXKcB1zLmAsv5W6ETaf1v96lEmcKdB78RB833/hKa4UlKdc9NhQwr0W1BZ6yF2AhJTUjgwOrZGAI5OzC8+lSrefe8LCQYE2arBa5vtVMzvJQRjzUx427ZXCEKhd9OsD6mmcy4dxtsvk2uRXDFDXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524899; c=relaxed/simple;
	bh=yXBFMcEdsB9INA4aOaZPMpjaMvJeveekvBpyqMYawXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAGdNyHdqPUnAfaI6qOn7t+LD/qSwYuwitxr1z9HE0TSfSNvKD36ayGcYE82Vijd+NbYhsr9pyLzwzS9L9y2+6NhkDAFEj1jOYK0ymY2Y8yG5TmBE4s9TVI3jHe4sNjZ3PCBqg4pOOlKQN6KGLgUS/2qcUNqd9RYov0Ok95Y0Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnmWPr03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnmWPr03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A869CC4CEEB;
	Mon, 18 Aug 2025 13:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524899;
	bh=yXBFMcEdsB9INA4aOaZPMpjaMvJeveekvBpyqMYawXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnmWPr039Zly9pZomG8kdEuUIwbjLoeVVdsE+ihH2vmiToQIaUTtfe+qCepN4wHUR
	 2hjQFI/LtiK9wrHMXvZqhRcOGrjgdV/SxSGK5TuQKcVC0N3yYW/ivvzwweC+KyfIKm
	 mvID1lAHCwoWd2xWZxAvNs+NlqEAdaK51KH2BNsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 065/570] netfilter: ctnetlink: fix refcount leak on table dump
Date: Mon, 18 Aug 2025 14:40:52 +0200
Message-ID: <20250818124508.318745975@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit de788b2e6227462b6dcd0e07474e72c089008f74 ]

There is a reference count leak in ctnetlink_dump_table():
      if (res < 0) {
                nf_conntrack_get(&ct->ct_general); // HERE
                cb->args[1] = (unsigned long)ct;
                ...

While its very unlikely, its possible that ct == last.
If this happens, then the refcount of ct was already incremented.
This 2nd increment is never undone.

This prevents the conntrack object from being released, which in turn
keeps prevents cnet->count from dropping back to 0.

This will then block the netns dismantle (or conntrack rmmod) as
nf_conntrack_cleanup_net_list() will wait forever.

This can be reproduced by running conntrack_resize.sh selftest in a loop.
It takes ~20 minutes for me on a preemptible kernel on average before
I see a runaway kworker spinning in nf_conntrack_cleanup_net_list.

One fix would to change this to:
        if (res < 0) {
		if (ct != last)
	                nf_conntrack_get(&ct->ct_general);

But this reference counting isn't needed in the first place.
We can just store a cookie value instead.

A followup patch will do the same for ctnetlink_exp_dump_table,
it looks to me as if this has the same problem and like
ctnetlink_dump_table, we only need a 'skip hint', not the actual
object so we can apply the same cookie strategy there as well.

Fixes: d205dc40798d ("[NETFILTER]: ctnetlink: fix deadlock in table dumping")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2cc0fde23344..5fdcae45e0bc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -884,8 +884,6 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 
 static int ctnetlink_done(struct netlink_callback *cb)
 {
-	if (cb->args[1])
-		nf_ct_put((struct nf_conn *)cb->args[1]);
 	kfree(cb->data);
 	return 0;
 }
@@ -1208,19 +1206,26 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 	return 0;
 }
 
+static unsigned long ctnetlink_get_id(const struct nf_conn *ct)
+{
+	unsigned long id = nf_ct_get_id(ct);
+
+	return id ? id : 1;
+}
+
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	unsigned int flags = cb->data ? NLM_F_DUMP_FILTERED : 0;
 	struct net *net = sock_net(skb->sk);
-	struct nf_conn *ct, *last;
+	unsigned long last_id = cb->args[1];
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
 	struct nf_conn *nf_ct_evict[8];
+	struct nf_conn *ct;
 	int res, i;
 	spinlock_t *lockp;
 
-	last = (struct nf_conn *)cb->args[1];
 	i = 0;
 
 	local_bh_disable();
@@ -1257,7 +1262,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 				continue;
 
 			if (cb->args[1]) {
-				if (ct != last)
+				if (ctnetlink_get_id(ct) != last_id)
 					continue;
 				cb->args[1] = 0;
 			}
@@ -1270,8 +1275,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 					    NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
 					    ct, true, flags);
 			if (res < 0) {
-				nf_conntrack_get(&ct->ct_general);
-				cb->args[1] = (unsigned long)ct;
+				cb->args[1] = ctnetlink_get_id(ct);
 				spin_unlock(lockp);
 				goto out;
 			}
@@ -1284,12 +1288,10 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 out:
 	local_bh_enable();
-	if (last) {
+	if (last_id) {
 		/* nf ct hash resize happened, now clear the leftover. */
-		if ((struct nf_conn *)cb->args[1] == last)
+		if (cb->args[1] == last_id)
 			cb->args[1] = 0;
-
-		nf_ct_put(last);
 	}
 
 	while (i) {
-- 
2.50.1



