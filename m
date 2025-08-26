Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A42534F484;
	Tue, 26 Aug 2025 13:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216074; cv=none; b=DouquPDdL9uBjRrARwT7+fxV7jtlNlTjb1wdB7CXntPO8/BJ7bRN93ZrlwuXob/bfr10iD7esw0cyVWGsIDE7oKwUOpmJrF3xJ6kBIioSL17umf/llvAcdXBfCSsjtoP7t2uRBQKRpDGOQIiiyepA6VmBIA/c8/qQBptJtP8UYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216074; c=relaxed/simple;
	bh=mNQ8s86myPV5XnwSEewQtYknTKzXTQ/lW5OaJ8NY9J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqmBqm0G19OYRhP5p25p8cgKxdHsPeRxDj9QxocFcmyS4Ty7XHXktBrliOep7DA48+pnsdSDVYHKKwrFH1d2u0LAzo1GxknTj5sVXZYwjPitmhQS0HWNDN4Kiw+WQCTHq0Z2eD4ALToJAS9tgFq6dkdus3EQA+QgGtC22hWSl/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gY+Txd12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gY+Txd12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4AFC4CEF1;
	Tue, 26 Aug 2025 13:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216074;
	bh=mNQ8s86myPV5XnwSEewQtYknTKzXTQ/lW5OaJ8NY9J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gY+Txd12DR7kbHEPa3jVpsj9Ko9XfCF4gG14trE+UarGOEHLb1r+rpY3h0LUa0QZj
	 wg0W+5O4O7zgl6utfgd9dZ5ZCSXLAzTC5sesv7otZQ3ZrgaSYEG/sRxLT667OWuyuC
	 Wk60B14hASAl7OnDSyOC3qD3H7q+5iNvuAAfDRhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 275/644] netfilter: ctnetlink: fix refcount leak on table dump
Date: Tue, 26 Aug 2025 13:06:06 +0200
Message-ID: <20250826110953.189873877@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 585103c16a8a..50f7531221c3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -848,8 +848,6 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 
 static int ctnetlink_done(struct netlink_callback *cb)
 {
-	if (cb->args[1])
-		nf_ct_put((struct nf_conn *)cb->args[1]);
 	kfree(cb->data);
 	return 0;
 }
@@ -1164,19 +1162,26 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
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
@@ -1211,7 +1216,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 				continue;
 
 			if (cb->args[1]) {
-				if (ct != last)
+				if (ctnetlink_get_id(ct) != last_id)
 					continue;
 				cb->args[1] = 0;
 			}
@@ -1224,8 +1229,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 					    NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
 					    ct, true, flags);
 			if (res < 0) {
-				nf_conntrack_get(&ct->ct_general);
-				cb->args[1] = (unsigned long)ct;
+				cb->args[1] = ctnetlink_get_id(ct);
 				spin_unlock(lockp);
 				goto out;
 			}
@@ -1238,12 +1242,10 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
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



