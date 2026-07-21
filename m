Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E7146A5FD;
	Tue, 21 Jul 2026 15:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649195; cv=none; b=EGtlKsNlNWGV7OlnR8fMGPUQdDRE4GNmn6Gl25IaIZNf3I/vQXzTOD+QrhXZSIql1+YMlwSqBVOo7WrWgfP3W9POMTjuwYjOpz+c5MAO+FKGqH71vtTvG5D/KDf1AXEvOGGzL4pYmEFgwjGSF0/5+8EV7RpI38DaCn3nzp0sVto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649195; c=relaxed/simple;
	bh=U/uL6f+t96L2t6LEvfUBLA57LNQImSONMWLbnluwZ+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIMi2EE+D+MAFfZK/Z/Ny2LNJMhqw9NEnLVxjguxnj/sIl4QQzyVflEsvttESLAVyDHoMcaz1Kjc4tbL4sDMJpJuglDzudyH1vd5qb3Jh1wVjyjsJnfzHMBiispc9N4Y0FSjVheEaj4HWGoz20SW9Mt/G7gcdwXYvgSEAo2dR4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVGDPmYL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVGDPmYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEA01F00A3A;
	Tue, 21 Jul 2026 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649194;
	bh=2ODq4HHAxYgkTeMZcsNhAecg9ERpxcbdHMa3qcKWIhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xVGDPmYLVpOeM5ZmVpMWeoHPFw36kLIkw6Vx9ngXmVCYTF5bs9RcjOw52bcYpXQ0d
	 cvgv91uLzp3+EuLHYyrbN7JrTBQGWteSJGcbo7ic+TcRz8bjsC+cPU2smhNg1G1har
	 iCeQGUfz9nLgtiP/ADYqFpNu/criSIuIomqJJitQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0485/2077] netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags
Date: Tue, 21 Jul 2026 17:02:38 +0200
Message-ID: <20260721152604.249372759@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f8bf5edf7157984bb8e288c8b04fdb041223b80c ]

Conntrack helper flags are accessed from packet and netlink dump path.
Concurrent update of userspace helper flags is not possible, because the
nfnl_mutex in held on updates. These flags are only used by userspace
helpers. Use {READ,WRITE}_ONCE() to access this flags from lockless
paths.

Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c  |  4 +++-
 net/netfilter/nfnetlink_cthelper.c | 20 +++++++++++++-------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b521b5ebd66449..c072a14a306afe 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2213,6 +2213,7 @@ static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
 {
 	const struct nf_conntrack_helper *helper;
 	const struct nf_conn_help *help;
+	unsigned int helper_flags;
 	int protoff;
 
 	help = nfct_help(ct);
@@ -2223,7 +2224,8 @@ static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
 	if (!helper)
 		return NF_ACCEPT;
 
-	if (!(helper->flags & NF_CT_HELPER_F_USERSPACE))
+	helper_flags = READ_ONCE(helper->flags);
+	if (!(helper_flags & NF_CT_HELPER_F_USERSPACE))
 		return NF_ACCEPT;
 
 	switch (nf_ct_l3num(ct)) {
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 0d16ad82d70c01..61a2407b53bd36 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -41,8 +41,9 @@ static int
 nfnl_userspace_cthelper(struct sk_buff *skb, unsigned int protoff,
 			struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
-	const struct nf_conn_help *help;
 	struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	unsigned int helper_flags;
 
 	help = nfct_help(ct);
 	if (help == NULL)
@@ -53,8 +54,10 @@ nfnl_userspace_cthelper(struct sk_buff *skb, unsigned int protoff,
 	if (helper == NULL)
 		return NF_DROP;
 
+	helper_flags = READ_ONCE(helper->flags);
+
 	/* This is a user-space helper not yet configured, skip. */
-	if ((helper->flags &
+	if ((helper_flags &
 	    (NF_CT_HELPER_F_USERSPACE | NF_CT_HELPER_F_CONFIGURED)) ==
 	     NF_CT_HELPER_F_USERSPACE)
 		return NF_ACCEPT;
@@ -404,10 +407,10 @@ nfnl_cthelper_update(const struct nlattr * const tb[],
 
 		switch(status) {
 		case NFCT_HELPER_STATUS_ENABLED:
-			helper->flags |= NF_CT_HELPER_F_CONFIGURED;
+			WRITE_ONCE(helper->flags, helper->flags | NF_CT_HELPER_F_CONFIGURED);
 			break;
 		case NFCT_HELPER_STATUS_DISABLED:
-			helper->flags &= ~NF_CT_HELPER_F_CONFIGURED;
+			WRITE_ONCE(helper->flags, helper->flags & ~NF_CT_HELPER_F_CONFIGURED);
 			break;
 		}
 	}
@@ -529,8 +532,8 @@ static int
 nfnl_cthelper_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 			int event, struct nf_conntrack_helper *helper)
 {
-	struct nlmsghdr *nlh;
 	unsigned int flags = portid ? NLM_F_MULTI : 0;
+	struct nlmsghdr *nlh;
 	int status;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTHELPER, event);
@@ -554,7 +557,7 @@ nfnl_cthelper_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (nla_put_be32(skb, NFCTH_PRIV_DATA_LEN, htonl(helper->data_len)))
 		goto nla_put_failure;
 
-	if (helper->flags & NF_CT_HELPER_F_CONFIGURED)
+	if (READ_ONCE(helper->flags) & NF_CT_HELPER_F_CONFIGURED)
 		status = NFCT_HELPER_STATUS_ENABLED;
 	else
 		status = NFCT_HELPER_STATUS_DISABLED;
@@ -575,6 +578,7 @@ static int
 nfnl_cthelper_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nf_conntrack_helper *cur, *last;
+	unsigned int helper_flags;
 
 	rcu_read_lock();
 	last = (struct nf_conntrack_helper *)cb->args[1];
@@ -583,8 +587,10 @@ nfnl_cthelper_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 		hlist_for_each_entry_rcu(cur,
 				&nf_ct_helper_hash[cb->args[0]], hnode) {
 
+			helper_flags = READ_ONCE(cur->flags);
+
 			/* skip non-userspace conntrack helpers. */
-			if (!(cur->flags & NF_CT_HELPER_F_USERSPACE))
+			if (!(helper_flags & NF_CT_HELPER_F_USERSPACE))
 				continue;
 
 			if (cb->args[1]) {
-- 
2.53.0



