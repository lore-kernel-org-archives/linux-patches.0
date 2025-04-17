Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F4A18DB2B
	for <patches@lists.linux.dev>; Thu, 17 Apr 2025 07:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744876703; cv=none; b=iVl6i4T6Fwmb/8Q8nv8O9dS+KvWRbQPiYmnqzRZ6m+teVjLQ3XYDHJcqwA4cvzn+rjM5XJGyaF4wlThjC31hUPqgg4AnK1XQBlo94+kQ0YKiuF94eAynIHG18ZDPIKdSFz1+lwdxQb/2PR/yOT9IShSbiplA4K3rpuFbXCEBCjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744876703; c=relaxed/simple;
	bh=NMd9FAxF1iRZDVFTbxG71T/gwRwztLcWuH6WBjodWpM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=K2DUwbdhMuU8bsTjTI5QxUjwbcTschFOj2mTDUSmWb/gMpU+exsZzafAipPiWNiZfGov/7/rg3w97zAtN/Mj5v0AWYVlbo8DNqur1Pi+cOGPhJJsUIDN4sIUZVo5mQbo1A/bsqDEA34ijXcE6FWxTxNHXJ5iDp2MUUgijmkXJMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53H602qE019651;
	Thu, 17 Apr 2025 00:57:46 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45yqpknpe6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 17 Apr 2025 00:57:46 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Thu, 17 Apr 2025 00:57:45 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Thu, 17 Apr 2025 00:57:41 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <sashal@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <cascardo@igalia.com>, <yajun.deng@linux.dev>,
        <yuehaibing@huawei.com>, <dan.streetman@canonical.com>,
        <steffen.klassert@secunet.com>, <netdev@vger.kernel.org>,
        <i.maximets@ovn.org>, <kuniyu@amazon.com>
Subject: [PATCH 5.10.y] net: defer final 'struct net' free in netns dismantle
Date: Thu, 17 Apr 2025 15:57:40 +0800
Message-ID: <20250417075740.1747626-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: MMfemu-Lcjb2KfFTZnYSvbNiOZimDoIX
X-Proofpoint-GUID: MMfemu-Lcjb2KfFTZnYSvbNiOZimDoIX
X-Authority-Analysis: v=2.4 cv=UZBRSLSN c=1 sm=1 tr=0 ts=6800b47a cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=bC-a23v3AAAA:8 a=1XWaLZrsAAAA:8 a=P8mRVJMrAAAA:8 a=20KFwNOVAAAA:8
 a=vggBfdFIAAAA:8 a=t7CeM3EgAAAA:8 a=sogmP-z4RixR6Pyh5rEA:9 a=-FEs8UIgK8oA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=Vc1QvrjMcIoGonisw6Ob:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-17_01,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1011
 priorityscore=1501 mlxscore=0 impostorscore=0 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2504170061

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0f6ede9fbc747e2553612271bce108f7517e7a45 ]

Ilya reported a slab-use-after-free in dst_destroy [1]

Issue is in xfrm6_net_init() and xfrm4_net_init() :

They copy xfrm[46]_dst_ops_template into net->xfrm.xfrm[46]_dst_ops.

But net structure might be freed before all the dst callbacks are
called. So when dst_destroy() calls later :

if (dst->ops->destroy)
    dst->ops->destroy(dst);

dst->ops points to the old net->xfrm.xfrm[46]_dst_ops, which has been freed.

See a relevant issue fixed in :

ac888d58869b ("net: do not delay dst_entries_add() in dst_release()")

A fix is to queue the 'struct net' to be freed after one
another cleanup_net() round (and existing rcu_barrier())

[1]

BUG: KASAN: slab-use-after-free in dst_destroy (net/core/dst.c:112)
Read of size 8 at addr ffff8882137ccab0 by task swapper/37/0
Dec 03 05:46:18 kernel:
CPU: 37 UID: 0 PID: 0 Comm: swapper/37 Kdump: loaded Not tainted 6.12.0 #67
Hardware name: Red Hat KVM/RHEL, BIOS 1.16.1-1.el9 04/01/2014
Call Trace:
 <IRQ>
dump_stack_lvl (lib/dump_stack.c:124)
print_address_description.constprop.0 (mm/kasan/report.c:378)
? dst_destroy (net/core/dst.c:112)
print_report (mm/kasan/report.c:489)
? dst_destroy (net/core/dst.c:112)
? kasan_addr_to_slab (mm/kasan/common.c:37)
kasan_report (mm/kasan/report.c:603)
? dst_destroy (net/core/dst.c:112)
? rcu_do_batch (kernel/rcu/tree.c:2567)
dst_destroy (net/core/dst.c:112)
rcu_do_batch (kernel/rcu/tree.c:2567)
? __pfx_rcu_do_batch (kernel/rcu/tree.c:2491)
? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4339 kernel/locking/lockdep.c:4406)
rcu_core (kernel/rcu/tree.c:2825)
handle_softirqs (kernel/softirq.c:554)
__irq_exit_rcu (kernel/softirq.c:589 kernel/softirq.c:428 kernel/softirq.c:637)
irq_exit_rcu (kernel/softirq.c:651)
sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1049 arch/x86/kernel/apic/apic.c:1049)
 </IRQ>
 <TASK>
asm_sysvec_apic_timer_interrupt (./arch/x86/include/asm/idtentry.h:702)
RIP: 0010:default_idle (./arch/x86/include/asm/irqflags.h:37 ./arch/x86/include/asm/irqflags.h:92 arch/x86/kernel/process.c:743)
Code: 00 4d 29 c8 4c 01 c7 4c 29 c2 e9 6e ff ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 90 0f 00 2d c7 c9 27 00 fb f4 <fa> c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 90
RSP: 0018:ffff888100d2fe00 EFLAGS: 00000246
RAX: 00000000001870ed RBX: 1ffff110201a5fc2 RCX: ffffffffb61a3e46
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffb3d4d123
RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed11c7e1835d
R10: ffff888e3f0c1aeb R11: 0000000000000000 R12: 0000000000000000
R13: ffff888100d20000 R14: dffffc0000000000 R15: 0000000000000000
? ct_kernel_exit.constprop.0 (kernel/context_tracking.c:148)
? cpuidle_idle_call (kernel/sched/idle.c:186)
default_idle_call (./include/linux/cpuidle.h:143 kernel/sched/idle.c:118)
cpuidle_idle_call (kernel/sched/idle.c:186)
? __pfx_cpuidle_idle_call (kernel/sched/idle.c:168)
? lock_release (kernel/locking/lockdep.c:467 kernel/locking/lockdep.c:5848)
? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4347 kernel/locking/lockdep.c:4406)
? tsc_verify_tsc_adjust (arch/x86/kernel/tsc_sync.c:59)
do_idle (kernel/sched/idle.c:326)
cpu_startup_entry (kernel/sched/idle.c:423 (discriminator 1))
start_secondary (arch/x86/kernel/smpboot.c:202 arch/x86/kernel/smpboot.c:282)
? __pfx_start_secondary (arch/x86/kernel/smpboot.c:232)
? soft_restart_cpu (arch/x86/kernel/head_64.S:452)
common_startup_64 (arch/x86/kernel/head_64.S:414)
 </TASK>
Dec 03 05:46:18 kernel:
Allocated by task 12184:
kasan_save_stack (mm/kasan/common.c:48)
kasan_save_track (./arch/x86/include/asm/current.h:49 mm/kasan/common.c:60 mm/kasan/common.c:69)
__kasan_slab_alloc (mm/kasan/common.c:319 mm/kasan/common.c:345)
kmem_cache_alloc_noprof (mm/slub.c:4085 mm/slub.c:4134 mm/slub.c:4141)
copy_net_ns (net/core/net_namespace.c:421 net/core/net_namespace.c:480)
create_new_namespaces (kernel/nsproxy.c:110)
unshare_nsproxy_namespaces (kernel/nsproxy.c:228 (discriminator 4))
ksys_unshare (kernel/fork.c:3313)
__x64_sys_unshare (kernel/fork.c:3382)
do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
Dec 03 05:46:18 kernel:
Freed by task 11:
kasan_save_stack (mm/kasan/common.c:48)
kasan_save_track (./arch/x86/include/asm/current.h:49 mm/kasan/common.c:60 mm/kasan/common.c:69)
kasan_save_free_info (mm/kasan/generic.c:582)
__kasan_slab_free (mm/kasan/common.c:271)
kmem_cache_free (mm/slub.c:4579 mm/slub.c:4681)
cleanup_net (net/core/net_namespace.c:456 net/core/net_namespace.c:446 net/core/net_namespace.c:647)
process_one_work (kernel/workqueue.c:3229)
worker_thread (kernel/workqueue.c:3304 kernel/workqueue.c:3391)
kthread (kernel/kthread.c:389)
ret_from_fork (arch/x86/kernel/process.c:147)
ret_from_fork_asm (arch/x86/entry/entry_64.S:257)
Dec 03 05:46:18 kernel:
Last potentially related work creation:
kasan_save_stack (mm/kasan/common.c:48)
__kasan_record_aux_stack (mm/kasan/generic.c:541)
insert_work (./include/linux/instrumented.h:68 ./include/asm-generic/bitops/instrumented-non-atomic.h:141 kernel/workqueue.c:788 kernel/workqueue.c:795 kernel/workqueue.c:2186)
__queue_work (kernel/workqueue.c:2340)
queue_work_on (kernel/workqueue.c:2391)
xfrm_policy_insert (net/xfrm/xfrm_policy.c:1610)
xfrm_add_policy (net/xfrm/xfrm_user.c:2116)
xfrm_user_rcv_msg (net/xfrm/xfrm_user.c:3321)
netlink_rcv_skb (net/netlink/af_netlink.c:2536)
xfrm_netlink_rcv (net/xfrm/xfrm_user.c:3344)
netlink_unicast (net/netlink/af_netlink.c:1316 net/netlink/af_netlink.c:1342)
netlink_sendmsg (net/netlink/af_netlink.c:1886)
sock_write_iter (net/socket.c:729 net/socket.c:744 net/socket.c:1165)
vfs_write (fs/read_write.c:590 fs/read_write.c:683)
ksys_write (fs/read_write.c:736)
do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
Dec 03 05:46:18 kernel:
Second to last potentially related work creation:
kasan_save_stack (mm/kasan/common.c:48)
__kasan_record_aux_stack (mm/kasan/generic.c:541)
insert_work (./include/linux/instrumented.h:68 ./include/asm-generic/bitops/instrumented-non-atomic.h:141 kernel/workqueue.c:788 kernel/workqueue.c:795 kernel/workqueue.c:2186)
__queue_work (kernel/workqueue.c:2340)
queue_work_on (kernel/workqueue.c:2391)
__xfrm_state_insert (./include/linux/workqueue.h:723 net/xfrm/xfrm_state.c:1150 net/xfrm/xfrm_state.c:1145 net/xfrm/xfrm_state.c:1513)
xfrm_state_update (./include/linux/spinlock.h:396 net/xfrm/xfrm_state.c:1940)
xfrm_add_sa (net/xfrm/xfrm_user.c:912)
xfrm_user_rcv_msg (net/xfrm/xfrm_user.c:3321)
netlink_rcv_skb (net/netlink/af_netlink.c:2536)
xfrm_netlink_rcv (net/xfrm/xfrm_user.c:3344)
netlink_unicast (net/netlink/af_netlink.c:1316 net/netlink/af_netlink.c:1342)
netlink_sendmsg (net/netlink/af_netlink.c:1886)
sock_write_iter (net/socket.c:729 net/socket.c:744 net/socket.c:1165)
vfs_write (fs/read_write.c:590 fs/read_write.c:683)
ksys_write (fs/read_write.c:736)
do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Fixes: a8a572a6b5f2 ("xfrm: dst_entries_init() per-net dst_ops")
Reported-by: Ilya Maximets <i.maximets@ovn.org>
Closes: https://lore.kernel.org/netdev/CANn89iKKYDVpB=MtmfH7nyv2p=rJWSLedO5k7wSZgtY_tO8WQg@mail.gmail.com/T/#m02c98c3009fe66382b73cfb4db9cf1df6fab3fbf
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20241204125455.3871859-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[Minor conflict resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 include/net/net_namespace.h |  1 +
 net/core/net_namespace.c    | 21 ++++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 3cf6a5c17b84..1f985b64a666 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -80,6 +80,7 @@ struct net {
 						 * or to unregister pernet ops
 						 * (pernet_ops_rwsem write locked).
 						 */
+	struct llist_node	defer_free_list;
 	struct llist_node	cleanup_list;	/* namespaces on death row */
 
 #ifdef CONFIG_KEYS
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index bcf3533cb8ff..feee95cf2991 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -455,11 +455,28 @@ static struct net *net_alloc(void)
 	goto out;
 }
 
+static LLIST_HEAD(defer_free_list);
+
+static void net_complete_free(void)
+{
+	struct llist_node *kill_list;
+	struct net *net, *next;
+
+	/* Get the list of namespaces to free from last round. */
+	kill_list = llist_del_all(&defer_free_list);
+
+	llist_for_each_entry_safe(net, next, kill_list, defer_free_list)
+		kmem_cache_free(net_cachep, net);
+
+}
+
 static void net_free(struct net *net)
 {
 	if (refcount_dec_and_test(&net->passive)) {
 		kfree(rcu_access_pointer(net->gen));
-		kmem_cache_free(net_cachep, net);
+
+		/* Wait for an extra rcu_barrier() before final free. */
+		llist_add(&net->defer_free_list, &defer_free_list);
 	}
 }
 
@@ -643,6 +660,8 @@ static void cleanup_net(struct work_struct *work)
 	 */
 	rcu_barrier();
 
+	net_complete_free();
+
 	/* Finally it is safe to free my network namespace structure */
 	list_for_each_entry_safe(net, tmp, &net_exit_list, exit_list) {
 		list_del_init(&net->exit_list);
-- 
2.34.1

