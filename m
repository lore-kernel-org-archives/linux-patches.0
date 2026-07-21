Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51052D8376;
	Tue, 21 Jul 2026 20:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666685; cv=none; b=gGA5+LCz9JofnqLqXB0pIXcBHQhdxu7zyBsQMCJ7kkOlZrDMyrRyZG9IsBp7zGxkOI3nhp2w5z5r2JY7P2a7pJ8NYRwiOECOUDUHfcyUvBb5/OM55CXeONu3ya7nC74WjjBAQTjpU8IIEHI6ztX57T3awT2P2YrOBzzBrJRmmdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666685; c=relaxed/simple;
	bh=uxMlD5rDS/CYvWZcNb0e8nni5tmzRrKkDq4bOBwYMMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PBi08KrXbeqt8Y9vk5p6qx4t5zgN84y7U5sxj49AgPSaXmXPshHNFrycNTeiy48YrHaOl64tuno5nWYMEzw5ASC0MHUrjT+1q593RAbRb3RuLjks36h7sgPcWJ8d1qsidKQBgU/l208nvkNgRnolED1gizaNj+eOoAXUNZf3C4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0RfPMd4v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0RfPMd4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B1E1F000E9;
	Tue, 21 Jul 2026 20:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666683;
	bh=8EwoxIrOZIWq88+A39buskO5+IJ0J8+tPwMVR9qeU8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0RfPMd4v+TIFzz0An4TrPDu0j46rgsw+Fu9tBPLX5LIPDB1yyUAm02z5ksQT/VpPY
	 DKEomZ4Qit167rCfcQKOCBPoyJqOb3/keblsb1FPtT4Y6wL1yBv6wQUWI1SMPmUuY/
	 CP9l5pKQSHLgyOoObyK0qi1zveZxRGcjnbQwZAHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0774/1266] netfilter: nf_nat: avoid invalid nat_net pointer use on failed nf_nat_init()
Date: Tue, 21 Jul 2026 17:20:11 +0200
Message-ID: <20260721152459.184533200@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@grsecurity.net>

[ Upstream commit 069cfe3de2a5e16069485893cd04665ab769c1d8 ]

We ran into below KASAN splat, which is mostly uninteresting, beside
for having nf_nat_register_fn() in the call chain as a cause for the
offending access:

==================================================================
BUG: KASAN: slab-out-of-bounds in nf_nat_register_fn+0x5f9/0x640
Read of size 8 at addr ffff890031e54c20 by task iptables/9510

CPU: 0 UID: 0 PID: 9510 Comm: iptables Not tainted 6.18.18-grsec-full-20260320181326 #1 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 […] dump_stack_lvl+0xee/0x160 ffff88004117eeb8
 […] print_report+0x6e/0x640 ffff88004117eee0
 […] ? __phys_addr+0x8e/0x140 ffff88004117eef0
 […] ? kasan_addr_to_slab+0x51/0xe0 ffff88004117ef08
 […] ? complete_report_info+0xec/0x1c0 ffff88004117ef20
 […] ? nf_nat_register_fn+0x5f9/0x640 ffff88004117ef48
 […] kasan_report+0xbc/0x140 ffff88004117ef50
 […] ? nf_nat_register_fn+0x5f9/0x640 ffff88004117ef90
 […] nf_nat_register_fn+0x5f9/0x640 ffff88004117eff8
 […] ? nf_nat_icmp_reply_translation+0x6e0/0x6e0 ffff88004117f070
 […] nf_tables_register_hook.part.0+0xa0/0x220 ffff88004117f080
 […] nf_tables_addchain.constprop.0+0x1054/0x1fc0 ffff88004117f0b8
 […] ? nft_chain_lookup.part.0+0x4ce/0xac0 ffff88004117f130
 […] ? nf_tables_abort+0x3d80/0x3d80 ffff88004117f190
 […] ? nf_tables_dumpreset_obj+0x100/0x100 ffff88004117f1c8
 […] ? nft_table_lookup.part.0+0x255/0x300 ffff88004117f310
 […] ? nf_tables_newchain+0x21a4/0x2fa0 ffff88004117f358
 […] nf_tables_newchain+0x21a4/0x2fa0 ffff88004117f360
 […] ? nf_tables_addchain.constprop.0+0x1fc0/0x1fc0 ffff88004117f458
 […] ? nla_get_range_signed+0x4a0/0x4a0 ffff88004117f488
 […] ? lock_acquire+0x16f/0x320 ffff88004117f490
 […] ? find_held_lock+0x3b/0xe0 ffff88004117f4b0
 […] ? __nla_parse+0x45/0x80 ffff88004117f500
 […] nfnetlink_rcv_batch+0xbca/0x19a0 ffff88004117f550
 […] ? nfnetlink_net_exit_batch+0x120/0x120 ffff88004117f618
 […] ? __sanitizer_cov_trace_switch+0x63/0xe0 ffff88004117f720
 […] ? gr_acl_handle_mmap+0x1c4/0x320 ffff88004117f7c0
 […] ? nla_get_range_signed+0x4a0/0x4a0 ffff88004117f7e8
 […] ? gr_is_capable+0x6f/0xe0 ffff88004117f830
 […] ? __nla_parse+0x45/0x80 ffff88004117f860
 […] ? skb_pull+0x103/0x1a0 ffff88004117f880
 […] nfnetlink_rcv+0x3db/0x4a0 ffff88004117f8b0
 […] ? nfnetlink_rcv_batch+0x19a0/0x19a0 ffff88004117f8d8
 […] ? netlink_lookup+0xe2/0x240 ffff88004117f900
 […] netlink_unicast+0x74b/0xb00 ffff88004117f930
 […] ? netlink_attachskb+0xb20/0xb20 ffff88004117f980
 […] ? __check_object_size+0x3e/0xaa0 ffff88004117f998
 […] ? security_netlink_send+0x51/0x160 ffff88004117f9c8
 […] netlink_sendmsg+0xa03/0x1200 ffff88004117f9f8
 […] ? netlink_unicast+0xb00/0xb00 ffff88004117fa70
 […] ? netlink_unicast+0xb00/0xb00 ffff88004117fac8
 […] ? ____sys_sendmsg+0xe2a/0x1040 ffff88004117faf8
 […] ____sys_sendmsg+0xe2a/0x1040 ffff88004117fb00
 […] ? kernel_recvmsg+0x300/0x300 ffff88004117fb60
 […] ? reacquire_held_locks+0xe9/0x260 ffff88004117fbc8
 […] ___sys_sendmsg+0x138/0x200 ffff88004117fbf8
 […] ? do_recvmmsg+0x7e0/0x7e0 ffff88004117fc30
 […] ? lockdep_hardirqs_on_prepare+0x101/0x1e0 ffff88004117fc50
 […] ? lock_acquire+0x16f/0x320 ffff88004117fd20
 […] ? lock_acquire+0x16f/0x320 ffff88004117fd58
 […] ? find_held_lock+0x3b/0xe0 ffff88004117fd70
 […] __sys_sendmsg+0x17a/0x260 ffff88004117fdc8
 […] ? __sys_sendmsg_sock+0x80/0x80 ffff88004117fdf0
 […] ? syscall_trace_enter+0x15e/0x2c0 ffff88004117fe98
 […] do_syscall_64+0x7d/0x400 ffff88004117fec8
 […] entry_SYSCALL_64_safe_stack+0x4a/0x60 ffff88004117fef8
 </TASK>
==================================================================

The out-of-bounds report, though, is a red herring as it is for an
access that shouldn't have happened in the first place.

When nf_nat_init() fails to register its BPF kfuncs, it'll unwind and,
among others, call unregister_pernet_subsys() to deregister its per-net
ops. This makes the previously allocated net id available for reuse by
the next caller of register_pernet_subsys(), in our case, synproxy.
However, 'nat_net_id' will still hold the previously allocated value.

If nf_nat.o gets build as a module, all this doesn't matter. A failed
initialization routine makes the module fail to load and any dependent
module won't be able to load either. However, if nf_nat.o is built-in,
a failing init won't /completely/ make its functionality unavailable to
dependent modules, namely the code and static data is still there, free
to be called by modules like nft_chain_nat.ko.

Case in point, nft_chain_nat registers hooks that'll call into nf_nat
which, in our case, failed to initialize and therefore won't have a
valid net id nor related net_nat object any more.

Code in nf_nat, namely nf_nat_register_fn() and nf_nat_unregister_fn(),
still making use of the reallocated net id, lead to a type confusion as
the call to net_generic() will no longer return memory belonging to an
object suited to fit 'struct nat_net' but 'struct synproxy_net' instead.
The latter is only 24 bytes on 64-bit systems, much smaller than struct
nat_net which is 176 bytes, perfectly explaining the OOB KASAN report.

Detect and handle a failed nf_nat_init() by testing the 'nf_nat_hook'
pointer which will be reset to NULL on initialization errors to prevent
the usage of an invalid nat_net pointer.

As this check is only needed when nf_nat.o is built-in, guard it by
'#ifndef MODULE...'.

Fixes: cbc1dd5b659f ("netfilter: nf_nat: Fix possible memory leak in nf_nat_init()")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 2500e409757d0d..d29767646ffa54 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1204,6 +1204,16 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	struct nf_hook_ops *nat_ops;
 	int i, ret;
 
+#ifndef MODULE
+	/* If nf_nat_core is built-in and nf_nat_init() fails, dependent
+	 * modules like nft_chain_nat.ko may still call this function.
+	 * However, nat_net would be invalid, likely pointing to some other
+	 * per-net structure.
+	 */
+	if (WARN_ON_ONCE(!nf_nat_hook))
+		return -EOPNOTSUPP;
+#endif
+
 	if (WARN_ON_ONCE(pf >= ARRAY_SIZE(nat_net->nat_proto_net)))
 		return -EINVAL;
 
-- 
2.53.0



