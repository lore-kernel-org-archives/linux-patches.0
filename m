Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6D81FECBA;
	Thu, 30 Jul 2026 16:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427216; cv=none; b=dsPGDQyb+gYQQsH7FQ+CZlOiZIvBVOrXD25xJWXjxtW+MoXL84avgFlV1zByRTR3VSIcXDkZnEAmnTRPMeAA3gS61OSDuPbOqAW23npZTUMqh7y3GXJqK7QeJNv2rEpJPnMIUUpsLPpdSN7Zlk9HAAeLdpD5HohOqtahhoBFPHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427216; c=relaxed/simple;
	bh=w5iQlrphRgclk5R4769AalMNcQ6YebPIwZ2k9skrh3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUK2JAdVWia/YSpMpEbPY4hAki5fUVZF+g2nurkKeEsDA6tpNoZu+FUJ9EcNnD8SNs4/yvW81NYPXge4SVqEL8TaPqr4ImW9fF+atFrtEH0QJv0bAiPuXkbML53vK4qVLzbn4SSWbRvnn56R1zHWdL8k8zcp2kZQFMFV5yS0z7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiaskcAS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiaskcAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14991F000E9;
	Thu, 30 Jul 2026 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427215;
	bh=4g7TBO/jmMSVJ/QmlXuvL9tIttrAdUY6nqqvt0IW6lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yiaskcASPLfSKktBIk6WLRz3fuA2X3Gt4cvpgz4CGC64sVmRE4jrAQg2fRrMxjzkj
	 f561dTmO78hKA0YOaM9zq2kPlq7iX8dq2dipx5hzE/crnt4Wt6JH/O18SM8VMNo6el
	 EGxHP+zb/UlQuE+2af7hPXOUrPZKYAynYOTKU7F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/484] net/sched: act_tunnel_key: Defer dst_release to RCU callback
Date: Thu, 30 Jul 2026 16:09:50 +0200
Message-ID: <20260730141425.468114601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit f1f5c8a3955f8fda3f84ed883ac8daa1847e724c ]

Fix a race-condition use-after-free in tunnel_key_release_params().

The function releases the metadata_dst of the old params synchronously
via dst_release() while deferring the params struct free with
kfree_rcu(). A concurrent tunnel_key_act() reader on the datapath may
still hold the old params pointer (under rcu_read_lock_bh) and proceed
to call dst_clone(&params->tcft_enc_metadata->dst) after the writer's
dst_release has already pushed the dst's rcuref to RCUREF_DEAD.

zdi-disclosures@trendmicro.com produced a poc which i (and Victor) verified
that KASAN reports:

==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read_write include/linux/instrumented.h:112
BUG: KASAN: slab-use-after-free in atomic_sub_return_release include/linux/atomic/atomic-instrumented.h:326
BUG: KASAN: slab-use-after-free in __rcuref_put include/linux/rcuref.h:109
BUG: KASAN: slab-use-after-free in rcuref_put include/linux/rcuref.h:173
BUG: KASAN: slab-use-after-free in dst_release+0x5b/0x370 net/core/dst.c:168
Write of size 4 at addr ffff88806158de40 by task poc/9388

CPU: 0 UID: 0 PID: 9388 Comm: poc Tainted: G        W           7.1.0-rc7 #7 PREEMPT(lazy)
Tainted: [W]=WARN
Hardware name: QEMU Ubuntu 25.10 PC v2 (i440FX + PIIX, + 10.1 machine, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378
 print_report+0x139/0x4ad mm/kasan/report.c:482
 kasan_report+0xe4/0x1d0 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:186
 kasan_check_range+0x125/0x200 mm/kasan/generic.c:200
 instrument_atomic_read_write include/linux/instrumented.h:112
 atomic_sub_return_release include/linux/atomic/atomic-instrumented.h:326
 __rcuref_put include/linux/rcuref.h:109
 rcuref_put include/linux/rcuref.h:173
 dst_release+0x5b/0x370 net/core/dst.c:168
 refdst_drop include/net/dst.h:272
 skb_dst_drop include/net/dst.h:284
 skb_release_head_state+0x293/0x400 net/core/skbuff.c:1163
 skb_release_all net/core/skbuff.c:1187
[..]
Allocated by task 9391:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398
 __kasan_kmalloc+0x9a/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263
 __do_kmalloc_node mm/slub.c:5296
 __kmalloc_noprof+0x2f1/0x830 mm/slub.c:5308
 kmalloc_noprof include/linux/slab.h:954
 kzalloc_noprof include/linux/slab.h:1188
 offload_action_alloc+0x2f/0x130 net/core/flow_offload.c:35
 tcf_action_offload_add_ex+0x1ba/0x880 net/sched/act_api.c:258
 tcf_action_offload_add net/sched/act_api.c:293
 tcf_action_init+0x66e/0xa20 net/sched/act_api.c:1547
 tcf_action_add+0xf6/0x5d0 net/sched/act_api.c:2101
[..]
Freed by task 9391:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253
 __kasan_slab_free+0x6b/0x90 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235
 slab_free_hook mm/slub.c:2689
 slab_free mm/slub.c:6251
 kfree+0x21f/0x6b0 mm/slub.c:6566
 tcf_action_offload_add_ex+0x4ad/0x880 net/sched/act_api.c:284
 tcf_action_offload_add net/sched/act_api.c:293
 tcf_action_init+0x66e/0xa20 net/sched/act_api.c:1547
 tcf_action_add+0xf6/0x5d0 net/sched/act_api.c:2101

The buggy address belongs to the object at ffff88806158de00
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 64 bytes inside of
 freed 256-byte region [ffff88806158de00, ffff88806158df00)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88806158d600 pfn:0x6158c
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x4fff00000000240(workingset|head|node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000240 ffff88801c841b40 ffffea0001856290 ffffea0001856190
raw: ffff88806158d600 0000000800100009 00000000f5000000 0000000000000000
head: 04fff00000000240 ffff88801c841b40 ffffea0001856290 ffffea0001856190
head: ffff88806158d600 0000000800100009 00000000f5000000 0000000000000000
head: 04fff00000000001 ffffffffffffff81 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd2820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 9391, tgid 9378 (poc), ts 123227323196, free_ts 0
 set_page_owner include/linux/page_owner.h:32
 post_alloc_hook+0xfe/0x140 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861
 get_page_from_freelist+0x110c/0x2fc0 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x263/0x2bc0 mm/page_alloc.c:5221
 alloc_slab_page mm/slub.c:3278
 allocate_slab mm/slub.c:3467
 new_slab+0xa6/0x690 mm/slub.c:3525
 refill_objects+0x271/0x420 mm/slub.c:7272
 refill_sheaf mm/slub.c:2816
 __pcs_replace_empty_main+0x373/0x630 mm/slub.c:4652
 alloc_from_pcs mm/slub.c:4750
 slab_alloc_node mm/slub.c:4884
 __do_kmalloc_node mm/slub.c:5295
 __kmalloc_noprof+0x66d/0x830 mm/slub.c:5308
 kmalloc_noprof include/linux/slab.h:954
 metadata_dst_alloc+0x26/0x90 net/core/dst.c:298
 tun_rx_dst include/net/dst_metadata.h:144
 __ip_tun_set_dst include/net/dst_metadata.h:208
 tunnel_key_init+0xb01/0x1b90 net/sched/act_tunnel_key.c:451
 tcf_action_init_1+0x46b/0x6c0 net/sched/act_api.c:1428
 tcf_action_init+0x448/0xa20 net/sched/act_api.c:1503
 tcf_action_add+0xf6/0x5d0 net/sched/act_api.c:2101
[..]
==================================================================

Fix by moving dst_release() into a custom RCU callback that runs
after the grace period, matching the lifetime of the containing
params struct.  Readers in the datapath therefore always find a live
rcuref when calling dst_clone().

Fixes: 9174c3df1cd18 ("net/sched: act_tunnel_key: fix memory leak in case of action replace")
Reported-by: zdi-disclosures@trendmicro.com
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
Link: https://patch.msgid.link/20260711150537.7946-1-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_tunnel_key.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 99fb869aee91b7..65664e530c73b5 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -344,14 +344,20 @@ static const struct nla_policy tunnel_key_policy[TCA_TUNNEL_KEY_MAX + 1] = {
 	[TCA_TUNNEL_KEY_ENC_TTL]      = { .type = NLA_U8 },
 };
 
-static void tunnel_key_release_params(struct tcf_tunnel_key_params *p)
+static void tunnel_key_release_params_rcu(struct rcu_head *head)
 {
-	if (!p)
-		return;
+	struct tcf_tunnel_key_params *p = container_of(head, typeof(*p), rcu);
+
 	if (p->tcft_action == TCA_TUNNEL_KEY_ACT_SET)
 		dst_release(&p->tcft_enc_metadata->dst);
+	kfree(p);
+}
 
-	kfree_rcu(p, rcu);
+static void tunnel_key_release_params(struct tcf_tunnel_key_params *p)
+{
+	if (!p)
+		return;
+	call_rcu(&p->rcu, tunnel_key_release_params_rcu);
 }
 
 static int tunnel_key_init(struct net *net, struct nlattr *nla,
-- 
2.53.0



