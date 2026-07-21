Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACF1443E3C;
	Tue, 21 Jul 2026 22:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672196; cv=none; b=KBleZsPZ5mvZ07LQI38vECfni3nwoWSGp/QZGkJOGkTKQ8/Sx+iylWazPrPqR/FH24F+22WJw4ScfX5f27/6aXI2ZXImy2IbRRO2lIfxdb8wzBl+mV/IOleR8RJPveoQleh/IcWsn3QQJ+HZEbWFMMyDQ7tWLJHsHVB5LZ2gWe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672196; c=relaxed/simple;
	bh=WJoMkLRMDpmaF7EnhsMLMO8HabxcyHgAxqAeqxKti/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofseW96NoxMuG4EpQLt5X4CtFzL7uGPQ8nCO3OXEmWH3B9AW2OnqZSHkz58X2EtSKfMYGy6YqGzUywrQeq2BBxI3x+DvLI4KlKS9wfLsA4Ma/dxw+UoE4SDKDqnJlV0eAUbJin7tSXZAAadhgNYxdkaCAPD2Auu46jaHUFlySGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfXiZxfc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfXiZxfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2FD1F000E9;
	Tue, 21 Jul 2026 22:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672195;
	bh=jc7GA2zajlxYHc6aJaCW6dJrv1QbgHBhLfDtmjp0Boo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UfXiZxfcvLnGD5BZ6og6+Jo7YHekMltlWN1SXRqjiFxYxp8U/7fP6Igi3E2lHkd34
	 KcLTtgecifv4MaD72fKdzPopUcjOKQk7VxM7CQFpnf6XcigAqBhv7tQNdrOqcSYXwE
	 P8YpA05KDP9oWvm0CpeQ++4SAZ8qSLFQnLwqSUTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Zhang <zhangfeionline@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 496/843] ipv6: fib6: fix NULL deref in fib6_walk_continue() on multi-batch dump
Date: Tue, 21 Jul 2026 17:22:11 +0200
Message-ID: <20260721152417.191908355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengfei Zhang <zhangfeionline@gmail.com>

[ Upstream commit 9facb861dc6b9b9ea9793ef5032a9a826f7a4229 ]

inet6_dump_fib() saves its progress in cb->args[1] as a positional
index within the current hash chain.  Between batches, a concurrent
fib6_new_table() can insert a new table at the chain head, shifting
all existing entries.  The saved index then lands on a different
table, causing fib6_dump_table() to set w->root to the wrong table
while w->node still points into the previous one.
fib6_walk_continue() dereferences w->node->parent (NULL) and panics:

  BUG: kernel NULL pointer dereference, address: 0000000000000008
  RIP: 0010:fib6_walk_continue+0x6e/0x170
  Call Trace:
   <TASK>
   fib6_dump_table.isra.0+0xc5/0x240
   inet6_dump_fib+0xf6/0x420
   rtnl_dumpit+0x30/0xa0
   netlink_dump+0x15b/0x460
   netlink_recvmsg+0x1d6/0x2a0
   ____sys_recvmsg+0x17a/0x190

Fix by storing tb->tb6_id in cb->args[1] instead of a positional
index.  On resume, skip entries until the id matches; a concurrent
head-insert can never match the saved id, so the walker always
resumes on the correct table.

Fixes: 1b43af5480c3 ("[IPV6]: Increase number of possible routing tables to 2^32")
Signed-off-by: Pengfei Zhang <zhangfeionline@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260625070517.965597-1-zhangfeionline@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 3dbc6d582325c6..cb3de8e39e3379 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -624,12 +624,12 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	};
 	const struct nlmsghdr *nlh = cb->nlh;
 	struct net *net = sock_net(skb->sk);
-	unsigned int e = 0, s_e;
 	struct hlist_head *head;
 	struct fib6_walker *w;
 	struct fib6_table *tb;
 	unsigned int h, s_h;
 	int err = 0;
+	u32 s_id;
 
 	rcu_read_lock();
 	if (cb->strict_check) {
@@ -689,23 +689,22 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 
 	s_h = cb->args[0];
-	s_e = cb->args[1];
+	s_id = cb->args[1];
 
-	for (h = s_h; h < FIB6_TABLE_HASHSZ; h++, s_e = 0) {
-		e = 0;
+	for (h = s_h; h < FIB6_TABLE_HASHSZ; h++, s_id = 0) {
 		head = &net->ipv6.fib_table_hash[h];
 		hlist_for_each_entry_rcu(tb, head, tb6_hlist) {
-			if (e < s_e)
-				goto next;
+			if (s_id && tb->tb6_id != s_id)
+				continue;
+
+			s_id = 0;
+			cb->args[1] = tb->tb6_id;
 			err = fib6_dump_table(tb, skb, cb);
 			if (err != 0)
 				goto out;
-next:
-			e++;
 		}
 	}
 out:
-	cb->args[1] = e;
 	cb->args[0] = h;
 
 unlock:
-- 
2.53.0



