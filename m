Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4883278C67;
	Wed,  7 Aug 2024 15:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043405; cv=none; b=YDvZmn6uXjSvLmt3DbETzCOS3sUQfqrZlulJkIPLOm4yDttcpeMCQ6Jv2QYN4AGZqybA+slBvTVMPf6gOzWLIgsnBZxVz21ytHVXAvyf9Vchc/GQ13MYDg78p4Fn1xwj9T2e6igXoK9alAgvV5mF0toHJrW+ak4dmmX4YUiqa5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043405; c=relaxed/simple;
	bh=Ou6hYk7syy6ei7ZXjogeaRlJZ3goKPyaaSFT09BSBiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyybiqNREq6w5KiZEBTGxzQLvtTddC2dakZ45o1viLDuYe485TBsr9mlyL51BaqpbVK9J50F59yQ6eA8y/NSqNZlJ5QqbLs517zxkgzbWB5oOgFrrZHxaoxPVKXh7n5PMbY99Gtjxmm6473FvfKRZzrdCcwESYRRnFU5UP2CzIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YW1DbAbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YW1DbAbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDB8C32781;
	Wed,  7 Aug 2024 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043404;
	bh=Ou6hYk7syy6ei7ZXjogeaRlJZ3goKPyaaSFT09BSBiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YW1DbAbMnsEFhYW7tvGGHhu6Mz4hncM3sEGns10Km3vRnTvQF9qcaNJH7oTgiCIod
	 kIgmzH7zI79AtyQ475XeCHASLTwinqqzBoqEPxtB+9UuIDX5lWHrml6WXXEIhxvv0W
	 cjfZJQ2jvZtqx/pWoPfjAjJ65elIJG/+uuk8cef8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kawahara <takawaha@amazon.co.jp>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/121] netfilter: iptables: Fix null-ptr-deref in iptable_nat_table_init().
Date: Wed,  7 Aug 2024 17:00:10 +0200
Message-ID: <20240807150021.964914708@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 5830aa863981d43560748aa93589c0695191d95d ]

We had a report that iptables-restore sometimes triggered null-ptr-deref
at boot time. [0]

The problem is that iptable_nat_table_init() is exposed to user space
before the kernel fully initialises netns.

In the small race window, a user could call iptable_nat_table_init()
that accesses net_generic(net, iptable_nat_net_id), which is available
only after registering iptable_nat_net_ops.

Let's call register_pernet_subsys() before xt_register_template().

[0]:
bpfilter: Loaded bpfilter_umh pid 11702
Started bpfilter
BUG: kernel NULL pointer dereference, address: 0000000000000013
 PF: supervisor write access in kernel mode
 PF: error_code(0x0002) - not-present page
PGD 0 P4D 0
PREEMPT SMP NOPTI
CPU: 2 PID: 11879 Comm: iptables-restor Not tainted 6.1.92-99.174.amzn2023.x86_64 #1
Hardware name: Amazon EC2 c6i.4xlarge/, BIOS 1.0 10/16/2017
RIP: 0010:iptable_nat_table_init (net/ipv4/netfilter/iptable_nat.c:87 net/ipv4/netfilter/iptable_nat.c:121) iptable_nat
Code: 10 4c 89 f6 48 89 ef e8 0b 19 bb ff 41 89 c4 85 c0 75 38 41 83 c7 01 49 83 c6 28 41 83 ff 04 75 dc 48 8b 44 24 08 48 8b 0c 24 <48> 89 08 4c 89 ef e8 a2 3b a2 cf 48 83 c4 10 44 89 e0 5b 5d 41 5c
RSP: 0018:ffffbef902843cd0 EFLAGS: 00010246
RAX: 0000000000000013 RBX: ffff9f4b052caa20 RCX: ffff9f4b20988d80
RDX: 0000000000000000 RSI: 0000000000000064 RDI: ffffffffc04201c0
RBP: ffff9f4b29394000 R08: ffff9f4b07f77258 R09: ffff9f4b07f77240
R10: 0000000000000000 R11: ffff9f4b09635388 R12: 0000000000000000
R13: ffff9f4b1a3c6c00 R14: ffff9f4b20988e20 R15: 0000000000000004
FS:  00007f6284340000(0000) GS:ffff9f51fe280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000013 CR3: 00000001d10a6005 CR4: 00000000007706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 ? show_trace_log_lvl (arch/x86/kernel/dumpstack.c:259)
 ? show_trace_log_lvl (arch/x86/kernel/dumpstack.c:259)
 ? xt_find_table_lock (net/netfilter/x_tables.c:1259)
 ? __die_body.cold (arch/x86/kernel/dumpstack.c:478 arch/x86/kernel/dumpstack.c:420)
 ? page_fault_oops (arch/x86/mm/fault.c:727)
 ? exc_page_fault (./arch/x86/include/asm/irqflags.h:40 ./arch/x86/include/asm/irqflags.h:75 arch/x86/mm/fault.c:1470 arch/x86/mm/fault.c:1518)
 ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:570)
 ? iptable_nat_table_init (net/ipv4/netfilter/iptable_nat.c:87 net/ipv4/netfilter/iptable_nat.c:121) iptable_nat
 xt_find_table_lock (net/netfilter/x_tables.c:1259)
 xt_request_find_table_lock (net/netfilter/x_tables.c:1287)
 get_info (net/ipv4/netfilter/ip_tables.c:965)
 ? security_capable (security/security.c:809 (discriminator 13))
 ? ns_capable (kernel/capability.c:376 kernel/capability.c:397)
 ? do_ipt_get_ctl (net/ipv4/netfilter/ip_tables.c:1656)
 ? bpfilter_send_req (net/bpfilter/bpfilter_kern.c:52) bpfilter
 nf_getsockopt (net/netfilter/nf_sockopt.c:116)
 ip_getsockopt (net/ipv4/ip_sockglue.c:1827)
 __sys_getsockopt (net/socket.c:2327)
 __x64_sys_getsockopt (net/socket.c:2342 net/socket.c:2339 net/socket.c:2339)
 do_syscall_64 (arch/x86/entry/common.c:51 arch/x86/entry/common.c:81)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
RIP: 0033:0x7f62844685ee
Code: 48 8b 0d 45 28 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 0a c3 66 0f 1f 84 00 00 00 00 00 48 8b 15 09
RSP: 002b:00007ffd1f83d638 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00007ffd1f83d680 RCX: 00007f62844685ee
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000004 R08: 00007ffd1f83d670 R09: 0000558798ffa2a0
R10: 00007ffd1f83d680 R11: 0000000000000246 R12: 00007ffd1f83e3b2
R13: 00007f628455baa0 R14: 00007ffd1f83d7b0 R15: 00007f628457a008
 </TASK>
Modules linked in: iptable_nat(+) bpfilter rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache veth xt_state xt_connmark xt_nat xt_statistic xt_MASQUERADE xt_mark xt_addrtype ipt_REJECT nf_reject_ipv4 nft_chain_nat nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_comment nft_compat nf_tables nfnetlink overlay nls_ascii nls_cp437 vfat fat ghash_clmulni_intel aesni_intel ena crypto_simd ptp cryptd i8042 pps_core serio button sunrpc sch_fq_codel configfs loop dm_mod fuse dax dmi_sysfs crc32_pclmul crc32c_intel efivarfs
CR2: 0000000000000013

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Reported-by: Takahiro Kawahara <takawaha@amazon.co.jp>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/iptable_nat.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 56f6ecc43451e..12ca666d6e2c1 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -145,25 +145,27 @@ static struct pernet_operations iptable_nat_net_ops = {
 
 static int __init iptable_nat_init(void)
 {
-	int ret = xt_register_template(&nf_nat_ipv4_table,
-				       iptable_nat_table_init);
+	int ret;
 
+	/* net->gen->ptr[iptable_nat_net_id] must be allocated
+	 * before calling iptable_nat_table_init().
+	 */
+	ret = register_pernet_subsys(&iptable_nat_net_ops);
 	if (ret < 0)
 		return ret;
 
-	ret = register_pernet_subsys(&iptable_nat_net_ops);
-	if (ret < 0) {
-		xt_unregister_template(&nf_nat_ipv4_table);
-		return ret;
-	}
+	ret = xt_register_template(&nf_nat_ipv4_table,
+				   iptable_nat_table_init);
+	if (ret < 0)
+		unregister_pernet_subsys(&iptable_nat_net_ops);
 
 	return ret;
 }
 
 static void __exit iptable_nat_exit(void)
 {
-	unregister_pernet_subsys(&iptable_nat_net_ops);
 	xt_unregister_template(&nf_nat_ipv4_table);
+	unregister_pernet_subsys(&iptable_nat_net_ops);
 }
 
 module_init(iptable_nat_init);
-- 
2.43.0



