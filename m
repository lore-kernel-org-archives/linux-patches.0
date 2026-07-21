Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AC0376A06;
	Tue, 21 Jul 2026 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653450; cv=none; b=gtt7Qj1t5jQKpWJ+gG1jXRG2Z8k1yJcDIPxg2DnnrpycjLZr4pvBLzLAoQYFyuH98XrZvFNKNlVXpHUaRJJC7sOyremS1PEM8Yen61nqgWJv2+YyGBnMWneG62RGWEqPaMoBCeoPyE1HPaBTz+POzx58N1OF2wmdrWa4sepp2uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653450; c=relaxed/simple;
	bh=67alPaiqJTZtBMjAm96EdnDzBQxELfLZVRnCYSBKlwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyXCO/13VpE2a1Q93MUavXzMb/O0y4Cil72Z8SDd8FhipJvB4AFdieJVLaPrWZpDeiMnqTlbpoAcZrUAMxHM18N/zURKJiOHpTMIR+RiWI5A5CFoNn7Gj7GjJ7axiZVwCBi1PYXVU4kogP0gvOu5p5TwbWxRgJaEJFHnSgzrMd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKSK0AHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKSK0AHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774781F000E9;
	Tue, 21 Jul 2026 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653449;
	bh=Jd21HjtF3ICGlK73hJIciK4khPgPua8bWUMf74RDnks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKSK0AHLl5n1PZXuwRW0pT4FcAIynrSjSHXhtlj9nvjZ3jZxNh86+uEn2fCHJ2hwf
	 /acS7DxkXUnWCCvXvpDVGLhLGCFTJroS/9CNrE2fbd4RFBp9FeHRAfpAX7oyPRC+M7
	 mBf8yGa13TmTelfCn1ieIawCQTG2Vj2ee/qIAM9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Zhang <zhangfeionline@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1329/2077] ipv6: fib6: fix NULL deref in fib6_walk_continue() on multi-batch dump
Date: Tue, 21 Jul 2026 17:16:42 +0200
Message-ID: <20260721152624.162139451@linuxfoundation.org>
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
index b897b3c5023b27..414fc3c5673608 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -637,12 +637,12 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -702,23 +702,22 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
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



