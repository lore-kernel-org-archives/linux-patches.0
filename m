Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70E23BE659;
	Mon, 23 Mar 2026 15:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279348; cv=none; b=dRabxmZtAwj2tir6ldprqYAd6wiebY6ZjjUiWZjNZQyJAWHrwsTd97t7xJInYXuJYLKaiEUQP2xjcApjqW8Uw22YxqJ3HyFbhNyKabd8WLOZmI5QfHO0SrWO+vaVdKNad+Lku73ESX9RnRR7Qq6tMilUFbhUMMe4ZlAQ/ZXSPSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279348; c=relaxed/simple;
	bh=O+AM+Wzu4prtqjNG7+WWsJE1Mn5uRBOKwFgZ7EBfZm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZ8voyOMskkpeGNZq74kAlI4CCsY+hJarB9DeUJyJO3Bm+jvYvKjR39fH4qInwO/ErRQ71xfh9mgDH3zmL5qUkqzkp6zUJq18i8wtZIg7L/RV24kHZhcM1jmDMBazMBsah9JM52jq/teoTaZxVedKXpO1z0m8aS3NzNkZfTPALQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Fe3jrYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Fe3jrYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CBEC2BCB1;
	Mon, 23 Mar 2026 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279348;
	bh=O+AM+Wzu4prtqjNG7+WWsJE1Mn5uRBOKwFgZ7EBfZm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Fe3jrYmANZ/C1d1OsxPbid8pzl2S+g+yGevpZPfJ08zX/Chm56j4bempgZ+mv22Q
	 usD7N9VzH9zVJv5o/zrGzwfHAhnwvDZsHCb4qD/ZEivgkfyMXqInP+JFvvo1CKmbGM
	 G4xlYn4rcv13CCS83O6sGO7/kOutzEfKdl4StmqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 513/567] netfilter: ctnetlink: remove refcounting in expectation dumpers
Date: Mon, 23 Mar 2026 14:47:13 +0100
Message-ID: <20260323134546.708357498@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1492e3dcb2be3aa46d1963da96aa9593e4e4db5a ]

Same pattern as previous patch: do not keep the expectation object
alive via refcount, only store a cookie value and then use that
as the skip hint for dump resumption.

AFAICS this has the same issue as the one resolved in the conntrack
dumper, when we do
  if (!refcount_inc_not_zero(&exp->use))

to increment the refcount, there is a chance that exp == last, which
causes a double-increment of the refcount and subsequent memory leak.

Fixes: cf6994c2b981 ("[NETFILTER]: nf_conntrack_netlink: sync expectation dumping with conntrack table dumping")
Fixes: e844a928431f ("netfilter: ctnetlink: allow to dump expectation per master conntrack")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 5cb81eeda909 ("netfilter: ctnetlink: fix use-after-free in ctnetlink_dump_exp_ct()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 41 ++++++++++++----------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 928bd2013289a..237468202a0be 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3140,23 +3140,27 @@ ctnetlink_expect_event(unsigned int events, const struct nf_exp_event *item)
 	return 0;
 }
 #endif
-static int ctnetlink_exp_done(struct netlink_callback *cb)
+
+static unsigned long ctnetlink_exp_id(const struct nf_conntrack_expect *exp)
 {
-	if (cb->args[1])
-		nf_ct_expect_put((struct nf_conntrack_expect *)cb->args[1]);
-	return 0;
+	unsigned long id = (unsigned long)exp;
+
+	id += nf_ct_get_id(exp->master);
+	id += exp->class;
+
+	return id ? id : 1;
 }
 
 static int
 ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net = sock_net(skb->sk);
-	struct nf_conntrack_expect *exp, *last;
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
+	unsigned long last_id = cb->args[1];
+	struct nf_conntrack_expect *exp;
 
 	rcu_read_lock();
-	last = (struct nf_conntrack_expect *)cb->args[1];
 	for (; cb->args[0] < nf_ct_expect_hsize; cb->args[0]++) {
 restart:
 		hlist_for_each_entry_rcu(exp, &nf_ct_expect_hash[cb->args[0]],
@@ -3168,7 +3172,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 				continue;
 
 			if (cb->args[1]) {
-				if (exp != last)
+				if (ctnetlink_exp_id(exp) != last_id)
 					continue;
 				cb->args[1] = 0;
 			}
@@ -3177,9 +3181,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 						    cb->nlh->nlmsg_seq,
 						    IPCTNL_MSG_EXP_NEW,
 						    exp) < 0) {
-				if (!refcount_inc_not_zero(&exp->use))
-					continue;
-				cb->args[1] = (unsigned long)exp;
+				cb->args[1] = ctnetlink_exp_id(exp);
 				goto out;
 			}
 		}
@@ -3190,32 +3192,30 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 out:
 	rcu_read_unlock();
-	if (last)
-		nf_ct_expect_put(last);
-
 	return skb->len;
 }
 
 static int
 ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct nf_conntrack_expect *exp, *last;
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	struct nf_conn *ct = cb->data;
 	struct nf_conn_help *help = nfct_help(ct);
 	u_int8_t l3proto = nfmsg->nfgen_family;
+	unsigned long last_id = cb->args[1];
+	struct nf_conntrack_expect *exp;
 
 	if (cb->args[0])
 		return 0;
 
 	rcu_read_lock();
-	last = (struct nf_conntrack_expect *)cb->args[1];
+
 restart:
 	hlist_for_each_entry_rcu(exp, &help->expectations, lnode) {
 		if (l3proto && exp->tuple.src.l3num != l3proto)
 			continue;
 		if (cb->args[1]) {
-			if (exp != last)
+			if (ctnetlink_exp_id(exp) != last_id)
 				continue;
 			cb->args[1] = 0;
 		}
@@ -3223,9 +3223,7 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 					    cb->nlh->nlmsg_seq,
 					    IPCTNL_MSG_EXP_NEW,
 					    exp) < 0) {
-			if (!refcount_inc_not_zero(&exp->use))
-				continue;
-			cb->args[1] = (unsigned long)exp;
+			cb->args[1] = ctnetlink_exp_id(exp);
 			goto out;
 		}
 	}
@@ -3236,9 +3234,6 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	cb->args[0] = 1;
 out:
 	rcu_read_unlock();
-	if (last)
-		nf_ct_expect_put(last);
-
 	return skb->len;
 }
 
@@ -3257,7 +3252,6 @@ static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
 	struct nf_conntrack_zone zone;
 	struct netlink_dump_control c = {
 		.dump = ctnetlink_exp_ct_dump_table,
-		.done = ctnetlink_exp_done,
 	};
 
 	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASTER,
@@ -3307,7 +3301,6 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 		else {
 			struct netlink_dump_control c = {
 				.dump = ctnetlink_exp_dump_table,
-				.done = ctnetlink_exp_done,
 			};
 			return netlink_dump_start(info->sk, skb, info->nlh, &c);
 		}
-- 
2.51.0



