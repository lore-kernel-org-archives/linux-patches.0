Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B7531E0FB;
	Mon, 18 Aug 2025 12:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521551; cv=none; b=sB8EyrlzKasTwgqBJFHJY5/opByn7V9qMdx245uMqN4+4YQdIa/Lm6fiEziZDJBzX4d0lhTnysua3+V4G1QG0ysoSWrxfZXXkZctVQc2d+hiCv+YT7lS32NCqJN3ajjGa4Suo8Pg1VhA5FAq3eolxiEYVDFGh/YfoxGDnZ39HTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521551; c=relaxed/simple;
	bh=5hIu3wfjaIBC2jnkXIrNoOMYOBxmDXoY4NMvJMn8jUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpvxhEfo76YEFnpTAU1xFJtH4lZjGl6jm5YWXhQ/S4Fr5+TMlWq+WgVzMCNOnPivdPnwYLY5XtfAFAmOiUutsECXA1e0t2z+IJ57hZP+7lJhGVfl5qlHHsOEVKV2ap4aJNmwnTl3UB4aSiFJRU59Np4ZTQjtzuwcvI5hXR6bk3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w62IW3ts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w62IW3ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D805BC4CEEB;
	Mon, 18 Aug 2025 12:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521551;
	bh=5hIu3wfjaIBC2jnkXIrNoOMYOBxmDXoY4NMvJMn8jUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w62IW3tsuBb2xzjYwBLJV3YfQ/VRCfFbm7iVm91pW06x77QEtCzC+OPj582hyyyZS
	 a7H4Q2/ygVzrS5T224153uUtlgWbTMbuwzTv198nvqEdcmhGhOz5OJHdYa4hypYIIw
	 V0s1La0do1DVKPx0Q0+/PD41QxFJ/uI71ftg+4Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/444] netfilter: ctnetlink: fix refcount leak on table dump
Date: Mon, 18 Aug 2025 14:41:21 +0200
Message-ID: <20250818124450.991202394@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6a1239433830..18a91c031554 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -860,8 +860,6 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 
 static int ctnetlink_done(struct netlink_callback *cb)
 {
-	if (cb->args[1])
-		nf_ct_put((struct nf_conn *)cb->args[1]);
 	kfree(cb->data);
 	return 0;
 }
@@ -1184,19 +1182,26 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
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
@@ -1233,7 +1238,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 				continue;
 
 			if (cb->args[1]) {
-				if (ct != last)
+				if (ctnetlink_get_id(ct) != last_id)
 					continue;
 				cb->args[1] = 0;
 			}
@@ -1246,8 +1251,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 					    NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
 					    ct, true, flags);
 			if (res < 0) {
-				nf_conntrack_get(&ct->ct_general);
-				cb->args[1] = (unsigned long)ct;
+				cb->args[1] = ctnetlink_get_id(ct);
 				spin_unlock(lockp);
 				goto out;
 			}
@@ -1260,12 +1264,10 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
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



