Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6DF12B72;
	Tue, 16 Jul 2024 15:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144928; cv=none; b=b7wcsOk/+7JBAvmPpaJ3RDsJdG762/XamwmyXS72p6LQDolftiOWakidJxbbAJox+TCvUJEPVrLO6DeNpFwYjejZRzZSecKYosl6/kTAcTShxS9ynEJPylXpx1JqfrdMldL+gZ5t9NxsbFdyyYpYOZw9x36Kjj3VrRwkMjTVeAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144928; c=relaxed/simple;
	bh=7adI8O+peV0Zx4VW9pzkT9ERLgCJMnxlSFUWyewvbys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3qKqYT1/MTDF6HuE7ygVWQuQi3cQqH2XColu/LT30sNbguVPd2/BL3EG/y4WKeQF+IFVknHbXj2hmNOGPoZhxwasRWksc4DwTRblkT4O3wDeheBRyl5QyOAiFsrQFPdIECAMsdnVTB0mf1yR6Ihs8RgQgzoUVZri/BxnNtCdRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V45sd8GX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V45sd8GX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CBBC4AF0D;
	Tue, 16 Jul 2024 15:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144928;
	bh=7adI8O+peV0Zx4VW9pzkT9ERLgCJMnxlSFUWyewvbys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V45sd8GX/d77WoimEyFOfPcKOnL4iwUJFZquE7KNFd5A1H0vkUzeijSL/cR+PIxV0
	 Cd1F7wFg1f+bEUBfCMcvOH0nyGRpRVFGkNVeZaoWES5c1fr41kuhR/+bDjcf8Lv2sI
	 3qOUTnGwlc93KMLK3JabDqAwoUrYsTrtNtlxV86I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Yang <gerald.yang@canonical.com>,
	Chengen Du <chengen.du@canonical.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 043/143] net/sched: Fix UAF when resolving a clash
Date: Tue, 16 Jul 2024 17:30:39 +0200
Message-ID: <20240716152757.645576432@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengen Du <chengen.du@canonical.com>

[ Upstream commit 26488172b0292bed837b95a006a3f3431d1898c3 ]

KASAN reports the following UAF:

 BUG: KASAN: slab-use-after-free in tcf_ct_flow_table_process_conn+0x12b/0x380 [act_ct]
 Read of size 1 at addr ffff888c07603600 by task handler130/6469

 Call Trace:
  <IRQ>
  dump_stack_lvl+0x48/0x70
  print_address_description.constprop.0+0x33/0x3d0
  print_report+0xc0/0x2b0
  kasan_report+0xd0/0x120
  __asan_load1+0x6c/0x80
  tcf_ct_flow_table_process_conn+0x12b/0x380 [act_ct]
  tcf_ct_act+0x886/0x1350 [act_ct]
  tcf_action_exec+0xf8/0x1f0
  fl_classify+0x355/0x360 [cls_flower]
  __tcf_classify+0x1fd/0x330
  tcf_classify+0x21c/0x3c0
  sch_handle_ingress.constprop.0+0x2c5/0x500
  __netif_receive_skb_core.constprop.0+0xb25/0x1510
  __netif_receive_skb_list_core+0x220/0x4c0
  netif_receive_skb_list_internal+0x446/0x620
  napi_complete_done+0x157/0x3d0
  gro_cell_poll+0xcf/0x100
  __napi_poll+0x65/0x310
  net_rx_action+0x30c/0x5c0
  __do_softirq+0x14f/0x491
  __irq_exit_rcu+0x82/0xc0
  irq_exit_rcu+0xe/0x20
  common_interrupt+0xa1/0xb0
  </IRQ>
  <TASK>
  asm_common_interrupt+0x27/0x40

 Allocated by task 6469:
  kasan_save_stack+0x38/0x70
  kasan_set_track+0x25/0x40
  kasan_save_alloc_info+0x1e/0x40
  __kasan_krealloc+0x133/0x190
  krealloc+0xaa/0x130
  nf_ct_ext_add+0xed/0x230 [nf_conntrack]
  tcf_ct_act+0x1095/0x1350 [act_ct]
  tcf_action_exec+0xf8/0x1f0
  fl_classify+0x355/0x360 [cls_flower]
  __tcf_classify+0x1fd/0x330
  tcf_classify+0x21c/0x3c0
  sch_handle_ingress.constprop.0+0x2c5/0x500
  __netif_receive_skb_core.constprop.0+0xb25/0x1510
  __netif_receive_skb_list_core+0x220/0x4c0
  netif_receive_skb_list_internal+0x446/0x620
  napi_complete_done+0x157/0x3d0
  gro_cell_poll+0xcf/0x100
  __napi_poll+0x65/0x310
  net_rx_action+0x30c/0x5c0
  __do_softirq+0x14f/0x491

 Freed by task 6469:
  kasan_save_stack+0x38/0x70
  kasan_set_track+0x25/0x40
  kasan_save_free_info+0x2b/0x60
  ____kasan_slab_free+0x180/0x1f0
  __kasan_slab_free+0x12/0x30
  slab_free_freelist_hook+0xd2/0x1a0
  __kmem_cache_free+0x1a2/0x2f0
  kfree+0x78/0x120
  nf_conntrack_free+0x74/0x130 [nf_conntrack]
  nf_ct_destroy+0xb2/0x140 [nf_conntrack]
  __nf_ct_resolve_clash+0x529/0x5d0 [nf_conntrack]
  nf_ct_resolve_clash+0xf6/0x490 [nf_conntrack]
  __nf_conntrack_confirm+0x2c6/0x770 [nf_conntrack]
  tcf_ct_act+0x12ad/0x1350 [act_ct]
  tcf_action_exec+0xf8/0x1f0
  fl_classify+0x355/0x360 [cls_flower]
  __tcf_classify+0x1fd/0x330
  tcf_classify+0x21c/0x3c0
  sch_handle_ingress.constprop.0+0x2c5/0x500
  __netif_receive_skb_core.constprop.0+0xb25/0x1510
  __netif_receive_skb_list_core+0x220/0x4c0
  netif_receive_skb_list_internal+0x446/0x620
  napi_complete_done+0x157/0x3d0
  gro_cell_poll+0xcf/0x100
  __napi_poll+0x65/0x310
  net_rx_action+0x30c/0x5c0
  __do_softirq+0x14f/0x491

The ct may be dropped if a clash has been resolved but is still passed to
the tcf_ct_flow_table_process_conn function for further usage. This issue
can be fixed by retrieving ct from skb again after confirming conntrack.

Fixes: 0cc254e5aa37 ("net/sched: act_ct: Offload connections with commit action")
Co-developed-by: Gerald Yang <gerald.yang@canonical.com>
Signed-off-by: Gerald Yang <gerald.yang@canonical.com>
Signed-off-by: Chengen Du <chengen.du@canonical.com>
Link: https://patch.msgid.link/20240710053747.13223-1-chengen.du@canonical.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 2a96d9c1db65b..6fa3cca87d346 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1077,6 +1077,14 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		 */
 		if (nf_conntrack_confirm(skb) != NF_ACCEPT)
 			goto drop;
+
+		/* The ct may be dropped if a clash has been resolved,
+		 * so it's necessary to retrieve it from skb again to
+		 * prevent UAF.
+		 */
+		ct = nf_ct_get(skb, &ctinfo);
+		if (!ct)
+			skip_add = true;
 	}
 
 	if (!skip_add)
-- 
2.43.0



