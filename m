Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D061A680D;
	Mon, 23 Mar 2026 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274167; cv=none; b=m4dNKxxH6BUBx20oCXMFkqS/VjdjogJ2gNzUbzHvwzac0LN6GZ9Tz/ZDMLHWnPBKtUb5yDERehTIj64uH2PP461dJpDoL/DWRV4hs089ozhDVuU9rB/oBx7RyhlPzx1Oh8Df7ys5c/Pa9c1XQUk9meerG7Termlorr8fz7MgMdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274167; c=relaxed/simple;
	bh=lIso+3JQqj6ehbGK1bvVVqJKutTd8FP+OAVTSrn26Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VN6CbUcOdnJqU9Lwu3azSVU2X3oa36Q79ME3BUDLBZ9+h5WzYR1XfLFCSnKFPJ+3tw2EkodKu+NgqwwDsnXbLqwCXy8HmSsVEF3FOpGNKX8t0hj0chBM1L30yKliy+YqNjgBhFg/UTLDHw3qAWYhN02oOoA8jGjlVyq4lfAbvsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vENcUOjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vENcUOjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2A9C4CEF7;
	Mon, 23 Mar 2026 13:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274167;
	bh=lIso+3JQqj6ehbGK1bvVVqJKutTd8FP+OAVTSrn26Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vENcUOjKqDAaJYwfzXL+w+t3ygzyb3VySVD1mK7a2dZlwqaSU5UlD1MX56B9ufjaz
	 cb52/oqxFdfQIydrfSmIJwOp+/SFemn4S0MVKYl33lOG3EFXnsWFLWuxBLgGd7hF7Q
	 /OTwSGpMYOkkglasOq3EBO8OCHupI6lJyhyHG18k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 132/220] netfilter: ctnetlink: fix use-after-free in ctnetlink_dump_exp_ct()
Date: Mon, 23 Mar 2026 14:45:09 +0100
Message-ID: <20260323134508.751492569@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 5cb81eeda909dbb2def209dd10636b51549a3f8a ]

ctnetlink_dump_exp_ct() stores a conntrack pointer in cb->data for the
netlink dump callback ctnetlink_exp_ct_dump_table(), but drops the
conntrack reference immediately after netlink_dump_start().  When the
dump spans multiple rounds, the second recvmsg() triggers the dump
callback which dereferences the now-freed conntrack via nfct_help(ct),
leading to a use-after-free on ct->ext.

The bug is that the netlink_dump_control has no .start or .done
callbacks to manage the conntrack reference across dump rounds.  Other
dump functions in the same file (e.g. ctnetlink_get_conntrack) properly
use .start/.done callbacks for this purpose.

Fix this by adding .start and .done callbacks that hold and release the
conntrack reference for the duration of the dump, and move the
nfct_help() call after the cb->args[0] early-return check in the dump
callback to avoid dereferencing ct->ext unnecessarily.

 BUG: KASAN: slab-use-after-free in ctnetlink_exp_ct_dump_table+0x4f/0x2e0
 Read of size 8 at addr ffff88810597ebf0 by task ctnetlink_poc/133

 CPU: 1 UID: 0 PID: 133 Comm: ctnetlink_poc Not tainted 7.0.0-rc2+ #3 PREEMPTLAZY
 Call Trace:
  <TASK>
  ctnetlink_exp_ct_dump_table+0x4f/0x2e0
  netlink_dump+0x333/0x880
  netlink_recvmsg+0x3e2/0x4b0
  ? aa_sk_perm+0x184/0x450
  sock_recvmsg+0xde/0xf0

 Allocated by task 133:
  kmem_cache_alloc_noprof+0x134/0x440
  __nf_conntrack_alloc+0xa8/0x2b0
  ctnetlink_create_conntrack+0xa1/0x900
  ctnetlink_new_conntrack+0x3cf/0x7d0
  nfnetlink_rcv_msg+0x48e/0x510
  netlink_rcv_skb+0xc9/0x1f0
  nfnetlink_rcv+0xdb/0x220
  netlink_unicast+0x3ec/0x590
  netlink_sendmsg+0x397/0x690
  __sys_sendmsg+0xf4/0x180

 Freed by task 0:
  slab_free_after_rcu_debug+0xad/0x1e0
  rcu_core+0x5c3/0x9c0

Fixes: e844a928431f ("netfilter: ctnetlink: allow to dump expectation per master conntrack")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3a04665adf992..f261dd48973fe 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3211,7 +3211,7 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	struct nf_conn *ct = cb->data;
-	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conn_help *help;
 	u_int8_t l3proto = nfmsg->nfgen_family;
 	unsigned long last_id = cb->args[1];
 	struct nf_conntrack_expect *exp;
@@ -3219,6 +3219,10 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	if (cb->args[0])
 		return 0;
 
+	help = nfct_help(ct);
+	if (!help)
+		return 0;
+
 	rcu_read_lock();
 
 restart:
@@ -3248,6 +3252,24 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int ctnetlink_dump_exp_ct_start(struct netlink_callback *cb)
+{
+	struct nf_conn *ct = cb->data;
+
+	if (!refcount_inc_not_zero(&ct->ct_general.use))
+		return -ENOENT;
+	return 0;
+}
+
+static int ctnetlink_dump_exp_ct_done(struct netlink_callback *cb)
+{
+	struct nf_conn *ct = cb->data;
+
+	if (ct)
+		nf_ct_put(ct);
+	return 0;
+}
+
 static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
 				 struct sk_buff *skb,
 				 const struct nlmsghdr *nlh,
@@ -3263,6 +3285,8 @@ static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
 	struct nf_conntrack_zone zone;
 	struct netlink_dump_control c = {
 		.dump = ctnetlink_exp_ct_dump_table,
+		.start = ctnetlink_dump_exp_ct_start,
+		.done = ctnetlink_dump_exp_ct_done,
 	};
 
 	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASTER,
-- 
2.51.0



