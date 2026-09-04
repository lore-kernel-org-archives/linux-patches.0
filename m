Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135EF3B7B7B;
	Fri,  4 Sep 2026 05:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499345; cv=none; b=qeC0RrYWTHBh0lYy+UTxwVvUwvUfYCfR9te/n7ybG6TPt6hxwLraAXM6qDvmQgIrJBNK6XZxEJDLk/Rz5C+m+xtGqiQFfR1dYnc+teY3x/GxBJb/2Bmnmx2W23qTxD3WDfByzuU5j+2FnQIfJPobF7g7EwqtK/9JGaVjMThIFMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499345; c=relaxed/simple;
	bh=YQPeQWwx7gnPNcMrotmBM7aTrkumJ+ic9VKuTM68uzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFlxXp7bLFl5FTALvG8b97Yv1TbCefBD8nwC5n/S/UBhkBMCerhckNbSgABDVOR+Hemz5pzS6dg7xl3I0/tojkImTE3fTh/PKKB50/ofVF7eydWzrCxLN7LX/RlMH5Gcojy/8yhmWhGV7MO0ZbkasmzUNjAY7lS9+MiVQMFvYos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOKHVE9E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOKHVE9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCB51F00A3D;
	Fri,  4 Sep 2026 05:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499344;
	bh=kRjs5ddDBpEQL61xT38lbGCADzjzUH0qCiqfljyDPcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xOKHVE9EKC5XVjqD38IfNli4oEka9NJXmB48QMhuw1rdEos+/G602WaKfknnJiWFs
	 ua+qotmXxlIYi3t1OoCeeQh39iOMvY4JWzqM4a2eLsQma4dxMbNMin+O8WpNPkMiMC
	 +leNbbZcMNEYvXEnJE0vSJCKlYDTdRjqF3mnmGw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuyang Huang <sigefriedhyy@gmail.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 357/713] ipv6: use RCU iterator to dump route exceptions
Date: Fri,  4 Sep 2026 06:55:25 +0200
Message-ID: <20260904045811.832624437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuyang Huang <sigefriedhyy@gmail.com>

commit 47cdab0d51aaa9bd85f8e4904585bd5bd4df4488 upstream.

rt6_nh_dump_exceptions() uses hlist_for_each_entry() to iterate over
RCU-protected exception lists. The caller holds rcu_read_lock(), but does
not hold rt6_exception_lock, so rt6_insert_exception() can concurrently
add an entry with hlist_add_head_rcu().

KCSAN reports this race (irrelevant details omitted):

  ==================================================================
  BUG: KCSAN: data-race in rt6_insert_exception / rt6_nh_dump_exceptions

  write (marked) to 0xffff8a7c44c59620 of 8 bytes by interrupt on cpu 5:
    rt6_insert_exception+0x3bb/0x760
    __ip6_rt_update_pmtu+0x4fe/0x750
    ip6_sk_update_pmtu+0x19a/0x3b0
    udpv6_err+0x3ff/0x800
    icmpv6_notify+0x1e1/0x440
    icmpv6_rcv+0x8c0/0xab0
    ip6_protocol_deliver_rcu+0x616/0x840
    ip6_input_finish+0xb9/0x160
    ...
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

  read to 0xffff8a7c44c59620 of 8 bytes by task 549 on cpu 14:
    rt6_nh_dump_exceptions+0xb3/0x260
    rt6_dump_route+0x53e/0x5f0
    fib6_dump_node+0x6d/0xf0
    fib6_walk_continue+0x290/0x2d0
    fib6_dump_table+0x28d/0x360
    inet6_dump_fib+0x37d/0x620
    rtnl_dumpit+0x7b/0xd0
    netlink_dump+0x3ae/0x7e0
    ...
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

  4 locks held by dumper/549:
    ...
    #1: (rcu_read_lock){....}-{1:3}, at: inet6_dump_fib+0x88/0x620
    #2: (&tb->tb6_lock){+.-.}-{3:3}, at: fib6_dump_table+0x1e9/0x360
    #3: (rcu_read_lock){....}-{1:3}, at: rt6_dump_route+0x483/0x5f0

  value changed: 0xffff8a7c44e05700 -> 0xffff8a7c45d60100

  Reported by Kernel Concurrency Sanitizer on:
  CPU: 14 UID: 0 PID: 549 Comm: dumper Not tainted
  7.2.0-rc7-virtme #38 PREEMPT(lazy)
  ...

Use hlist_for_each_entry_rcu() to safely iterate over the exception list.

Fixes: 1e47b4837f3b ("ipv6: Dump route exceptions if requested")
Cc: stable@vger.kernel.org
Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260815084651.69477-1-sigefriedhyy@gmail.com
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6029,7 +6029,7 @@ static int rt6_nh_dump_exceptions(struct
 		return 0;
 
 	for (i = 0; i < FIB6_EXCEPTION_BUCKET_SIZE; i++) {
-		hlist_for_each_entry(rt6_ex, &bucket->chain, hlist) {
+		hlist_for_each_entry_rcu(rt6_ex, &bucket->chain, hlist) {
 			if (w->skip) {
 				w->skip--;
 				continue;


