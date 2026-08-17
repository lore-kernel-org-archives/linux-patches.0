Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0CA442110;
	Mon, 17 Aug 2026 14:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976154; cv=none; b=SOo7DQfA2tHTv/l/QPeZcarKj5+xOv32X8U2HZbZmzIvf0iD/LGdIVeuBzQWwEwY+tOBl5jctzeYWuqqaMvdqaa34VU3b4cobwgWRyqMi/9Beh3DrYl74ZeJYZONjNDE3HX3EE7VEWRYT3WTmt7rvJcJSWNqyYySlD3ZHVqoR/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976154; c=relaxed/simple;
	bh=XquiH/C5MZNYuKUkw1N39iAz+6T3c4I4p2RqQhlZfQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dstaW+NtEn3SfT/5JUHOhfXLt6vvyzPJbm+jO+sPIX0tlT+H5Fr+HLA4AbSJ/nY+WcwtudrpzGr9pXHOplWGvVl95mV1HofguHjh8CD1fQwhB2UISd2qbiyNTD6VOPw7QqUxinAR55j3l0DOjqX0Xx93ckNotqAzresl027Ccx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKbf7Xuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKbf7Xuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DAD1F000E9;
	Mon, 17 Aug 2026 14:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976153;
	bh=TjYWUdqzbl0VvMOxUdp++tSh60suuCDD4QqvLLkArfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKbf7XuuYzhzB9m7tKNju4pI9VSBvGTmhxpykuJcZE3cm6TlaxCtUktZN7SA51YNt
	 p2kEO+b00b4KGWvBX8MAz6YANLtGc3dK7n5QYGGXQ5dcDBLMD2p1VRYinS6czc0fkm
	 UIgrdIGjTKkzb77gkbzOCyKK9i3JOi5ioAFhDmRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Zhang <zhangfeionline@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/389] ipv6: fib6: fix NULL deref in fib6_walk_continue() on multi-batch dump
Date: Mon, 17 Aug 2026 15:31:17 +0200
Message-ID: <20260817132548.557444460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengfei Zhang <zhangfeionline@gmail.com>

commit 9facb861dc6b9b9ea9793ef5032a9a826f7a4229 upstream.

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
[Adapted to 5.10/6.1/6.6: inet6_dump_fib() there predates 22e36ea9f5d7
 and 5fc68320c1fb, so the return variable is "res" not "err" and the
 RCU-protected hash walk exits via "out_unlock" instead of "unlock".
 Context-only change; the fix itself is identical.]
Signed-off-by: Pengfei Zhang <zhangfeionline@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 83f15e930b57a..12568b7ab703a 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -620,11 +620,11 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	const struct nlmsghdr *nlh = cb->nlh;
 	struct net *net = sock_net(skb->sk);
 	unsigned int h, s_h;
-	unsigned int e = 0, s_e;
 	struct fib6_walker *w;
 	struct fib6_table *tb;
 	struct hlist_head *head;
 	int res = 0;
+	u32 s_id;
 
 	if (cb->strict_check) {
 		int err;
@@ -682,25 +682,24 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 
 	s_h = cb->args[0];
-	s_e = cb->args[1];
+	s_id = cb->args[1];
 
 	rcu_read_lock();
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
 			res = fib6_dump_table(tb, skb, cb);
 			if (res != 0)
 				goto out_unlock;
-next:
-			e++;
 		}
 	}
 out_unlock:
 	rcu_read_unlock();
-	cb->args[1] = e;
 	cb->args[0] = h;
 out:
 	res = res < 0 ? res : skb->len;
-- 
2.53.0



