Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EB62F25E4;
	Tue, 21 Jul 2026 20:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665126; cv=none; b=M4jcVSCdgpuvH2/UfuIkjiwcjMaoct0UyaFB7imJaEfvFaUF/STMfB8iVRNAHkXHbJ6zXLIoUF2mAg96JqBXElH7t/Ir1LDTXOrTRe+pzTF43kHlsHyGhMnYJdF1kjSTR7FDnvcgbajLQipBHvL/Os6Uhbw3Bfsmp7C6T9WhGkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665126; c=relaxed/simple;
	bh=tFoDQchoYEVh/SyHvzEI0EpWniSOAcQGxYpM47aUkwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYOrnFDyFJZL7jBsS9+RxHVEhQxIbC7U/PYaPvTK29O4FbF3/nj7GzfU+p4JPhe7wofHwzehgYzQYVyj/c2wTUaOdTBzlbUTBRBYlEvHJ5qcsRim9pQLPCJAVkjScrZ7YJwBde9MVsoKYKIM669zWKE+kDUnKQEulllvB55PTKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esYzP31O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esYzP31O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A39B1F000E9;
	Tue, 21 Jul 2026 20:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665124;
	bh=QqpkaDQLu9Go+Oz46uDMDzvqk2o8kaeOzw4jEDakrNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=esYzP31OOTmtfehtqldwekR11iGZyEZzrqwVLTvV4ea/rvnXC6QHkCAR8SzE9GrpH
	 RWdjLrzGaF8eI2TYJbI/TyA4feTB8aLLeJRlcE9GJ4FjNegnodJgcZ0UFDgODoZnZP
	 nvVHnHzkweoTqy9TbmaP/DnxWIBLAZ1PC29wyDQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.6 0133/1266] netfilter: ipset: fix race between dump and ip_set_list resize
Date: Tue, 21 Jul 2026 17:09:30 +0200
Message-ID: <20260721152444.782927259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

commit 7cd9103283b26b917360ec99d7d2f2d761bcf1ab upstream.

The release path of ip_set_dump_do() and ip_set_dump_done() read
inst->ip_set_list via ip_set_ref_netlink(), a plain rcu_dereference_raw()
of the array pointer. These run from netlink_recvmsg() without the nfnl
mutex and without an RCU read-side critical section.

A concurrent ip_set_create() can grow the array: it publishes the new
array, calls synchronize_net() and then kvfree()s the old one. Since the
dump paths read the array outside any RCU reader, synchronize_net() does
not wait for them and the old array can be freed while they still index
into it, causing a use-after-free.

The dumped set itself stays pinned via set->ref_netlink, so only the
array load needs protecting. Take rcu_read_lock() around it, matching
ip_set_get_byname() and __ip_set_put_byindex().

  BUG: KASAN: slab-use-after-free in ip_set_dump_do (net/netfilter/ipset/ip_set_core.c:1697)
  Read of size 8 at addr ffff88800b5c4018 by task exploit/150
  Call Trace:
   ...
   kasan_report (mm/kasan/report.c:595)
   ip_set_dump_do (net/netfilter/ipset/ip_set_core.c:1697)
   netlink_dump (net/netlink/af_netlink.c:2325)
   netlink_recvmsg (net/netlink/af_netlink.c:1976)
   sock_recvmsg (net/socket.c:1159)
   __sys_recvfrom (net/socket.c:2315)
   ...
  Oops: general protection fault, probably for non-canonical address ... KASAN NOPTI
  KASAN: maybe wild-memory-access in range [0x02d6...d0-0x02d6...d7]
  RIP: 0010:ip_set_dump_do (net/netfilter/ipset/ip_set_core.c:1698)
  Kernel panic - not syncing: Fatal exception

Fixes: 8a02bdd50b2e ("netfilter: ipset: Fix calling ip_set() macro at dumping")
Cc: stable@vger.kernel.org
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1480,7 +1480,11 @@ ip_set_dump_done(struct netlink_callback
 		struct ip_set_net *inst =
 			(struct ip_set_net *)cb->args[IPSET_CB_NET];
 		ip_set_id_t index = (ip_set_id_t)cb->args[IPSET_CB_INDEX];
-		struct ip_set *set = ip_set_ref_netlink(inst, index);
+		struct ip_set *set;
+
+		rcu_read_lock();
+		set = ip_set_ref_netlink(inst, index);
+		rcu_read_unlock();
 
 		if (set->variant->uref)
 			set->variant->uref(set, cb, false);
@@ -1685,7 +1689,9 @@ next_set:
 release_refcount:
 	/* If there was an error or set is done, release set */
 	if (ret || !cb->args[IPSET_CB_ARG0]) {
+		rcu_read_lock();
 		set = ip_set_ref_netlink(inst, index);
+		rcu_read_unlock();
 		if (set->variant->uref)
 			set->variant->uref(set, cb, false);
 		pr_debug("release set %s\n", set->name);


