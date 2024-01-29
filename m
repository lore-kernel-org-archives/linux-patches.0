Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A827405B;
	Mon, 29 Jan 2024 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548567; cv=none; b=IwaNjVTKnXi0uVtkkUO7OgKIxYVlUkz+rWK3U1Eltcf6xQz1u1dVTwdXyzOA3vzvCI4po0DV1Plrh1TjL3ONwveM4+ppVjIpn+FhHX2ZIkN1rnRHDHA4+q3IkqGHKTF2uo5eebQSXLgOmG2b0+OkfRfn8W15L9YkCGmjQrCl4B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548567; c=relaxed/simple;
	bh=LzHNkTRH8ajxD+70Ud8LAAM3cwjODlcTACiudmtaCVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPqNomu6sWewkVJ3B504WjuW/4xQQ+gjxSTI8xkGCIbQ5pHG3k7BGOe9qXCg2+s+tRvBdhzevP86Q54gX4JnsgaEwQ6628wNtHThTjjTz1Oz0u8FQy5mivTph4e3YCeTm/PJMqNa9/D4a0pckHaCRdDX8mMVJXF52fq8AO+0afI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kc3SqkS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kc3SqkS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4892CC433C7;
	Mon, 29 Jan 2024 17:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548567;
	bh=LzHNkTRH8ajxD+70Ud8LAAM3cwjODlcTACiudmtaCVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kc3SqkS7kNLlea3frTbfflN7wLeG9XUvVAh8ndAUtl9QjSdabXfi4ROy9aBMsgFzD
	 0ajCA0rHDrUMPfyF9FjUk3GqhfmUzqLkbKoC/2zOAG+Gk8Q2yst9ZeaHCBv7I4VWW2
	 gka1hP0QR1nuCSCTfmwl1nj3fxyQ4tiyzZwtQLYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>
Subject: [PATCH 6.6 216/331] xsk: fix usage of multi-buffer BPF helpers for ZC XDP
Date: Mon, 29 Jan 2024 09:04:40 -0800
Message-ID: <20240129170021.195971809@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit c5114710c8ce86b8317e9b448f4fd15c711c2a82 ]

Currently when packet is shrunk via bpf_xdp_adjust_tail() and memory
type is set to MEM_TYPE_XSK_BUFF_POOL, null ptr dereference happens:

[1136314.192256] BUG: kernel NULL pointer dereference, address:
0000000000000034
[1136314.203943] #PF: supervisor read access in kernel mode
[1136314.213768] #PF: error_code(0x0000) - not-present page
[1136314.223550] PGD 0 P4D 0
[1136314.230684] Oops: 0000 [#1] PREEMPT SMP NOPTI
[1136314.239621] CPU: 8 PID: 54203 Comm: xdpsock Not tainted 6.6.0+ #257
[1136314.250469] Hardware name: Intel Corporation S2600WFT/S2600WFT,
BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
[1136314.265615] RIP: 0010:__xdp_return+0x6c/0x210
[1136314.274653] Code: ad 00 48 8b 47 08 49 89 f8 a8 01 0f 85 9b 01 00 00 0f 1f 44 00 00 f0 41 ff 48 34 75 32 4c 89 c7 e9 79 cd 80 ff 83 fe 03 75 17 <f6> 41 34 01 0f 85 02 01 00 00 48 89 cf e9 22 cc 1e 00 e9 3d d2 86
[1136314.302907] RSP: 0018:ffffc900089f8db0 EFLAGS: 00010246
[1136314.312967] RAX: ffffc9003168aed0 RBX: ffff8881c3300000 RCX:
0000000000000000
[1136314.324953] RDX: 0000000000000000 RSI: 0000000000000003 RDI:
ffffc9003168c000
[1136314.336929] RBP: 0000000000000ae0 R08: 0000000000000002 R09:
0000000000010000
[1136314.348844] R10: ffffc9000e495000 R11: 0000000000000040 R12:
0000000000000001
[1136314.360706] R13: 0000000000000524 R14: ffffc9003168aec0 R15:
0000000000000001
[1136314.373298] FS:  00007f8df8bbcb80(0000) GS:ffff8897e0e00000(0000)
knlGS:0000000000000000
[1136314.386105] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1136314.396532] CR2: 0000000000000034 CR3: 00000001aa912002 CR4:
00000000007706f0
[1136314.408377] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[1136314.420173] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[1136314.431890] PKRU: 55555554
[1136314.439143] Call Trace:
[1136314.446058]  <IRQ>
[1136314.452465]  ? __die+0x20/0x70
[1136314.459881]  ? page_fault_oops+0x15b/0x440
[1136314.468305]  ? exc_page_fault+0x6a/0x150
[1136314.476491]  ? asm_exc_page_fault+0x22/0x30
[1136314.484927]  ? __xdp_return+0x6c/0x210
[1136314.492863]  bpf_xdp_adjust_tail+0x155/0x1d0
[1136314.501269]  bpf_prog_ccc47ae29d3b6570_xdp_sock_prog+0x15/0x60
[1136314.511263]  ice_clean_rx_irq_zc+0x206/0xc60 [ice]
[1136314.520222]  ? ice_xmit_zc+0x6e/0x150 [ice]
[1136314.528506]  ice_napi_poll+0x467/0x670 [ice]
[1136314.536858]  ? ttwu_do_activate.constprop.0+0x8f/0x1a0
[1136314.546010]  __napi_poll+0x29/0x1b0
[1136314.553462]  net_rx_action+0x133/0x270
[1136314.561619]  __do_softirq+0xbe/0x28e
[1136314.569303]  do_softirq+0x3f/0x60

This comes from __xdp_return() call with xdp_buff argument passed as
NULL which is supposed to be consumed by xsk_buff_free() call.

To address this properly, in ZC case, a node that represents the frag
being removed has to be pulled out of xskb_list. Introduce
appropriate xsk helpers to do such node operation and use them
accordingly within bpf_xdp_adjust_tail().

Fixes: 24ea50127ecf ("xsk: support mbuf on ZC RX")
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com> # For the xsk header part
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20240124191602.566724-4-maciej.fijalkowski@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock_drv.h | 26 +++++++++++++++++++++++
 net/core/filter.c          | 42 ++++++++++++++++++++++++++++++++------
 2 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 7290eb721c07..5425f7ad5ebd 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -147,6 +147,23 @@ static inline struct xdp_buff *xsk_buff_get_frag(struct xdp_buff *first)
 	return ret;
 }
 
+static inline void xsk_buff_del_tail(struct xdp_buff *tail)
+{
+	struct xdp_buff_xsk *xskb = container_of(tail, struct xdp_buff_xsk, xdp);
+
+	list_del(&xskb->xskb_list_node);
+}
+
+static inline struct xdp_buff *xsk_buff_get_tail(struct xdp_buff *first)
+{
+	struct xdp_buff_xsk *xskb = container_of(first, struct xdp_buff_xsk, xdp);
+	struct xdp_buff_xsk *frag;
+
+	frag = list_last_entry(&xskb->pool->xskb_list, struct xdp_buff_xsk,
+			       xskb_list_node);
+	return &frag->xdp;
+}
+
 static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
 {
 	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
@@ -310,6 +327,15 @@ static inline struct xdp_buff *xsk_buff_get_frag(struct xdp_buff *first)
 	return NULL;
 }
 
+static inline void xsk_buff_del_tail(struct xdp_buff *tail)
+{
+}
+
+static inline struct xdp_buff *xsk_buff_get_tail(struct xdp_buff *first)
+{
+	return NULL;
+}
+
 static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
 {
 }
diff --git a/net/core/filter.c b/net/core/filter.c
index cbc395d96479..46ee0f5433e3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -82,6 +82,7 @@
 #include <net/mptcp.h>
 #include <net/netfilter/nf_conntrack_bpf.h>
 #include <linux/un.h>
+#include <net/xdp_sock_drv.h>
 
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
@@ -4084,6 +4085,40 @@ static int bpf_xdp_frags_increase_tail(struct xdp_buff *xdp, int offset)
 	return 0;
 }
 
+static void bpf_xdp_shrink_data_zc(struct xdp_buff *xdp, int shrink,
+				   struct xdp_mem_info *mem_info, bool release)
+{
+	struct xdp_buff *zc_frag = xsk_buff_get_tail(xdp);
+
+	if (release) {
+		xsk_buff_del_tail(zc_frag);
+		__xdp_return(NULL, mem_info, false, zc_frag);
+	} else {
+		zc_frag->data_end -= shrink;
+	}
+}
+
+static bool bpf_xdp_shrink_data(struct xdp_buff *xdp, skb_frag_t *frag,
+				int shrink)
+{
+	struct xdp_mem_info *mem_info = &xdp->rxq->mem;
+	bool release = skb_frag_size(frag) == shrink;
+
+	if (mem_info->type == MEM_TYPE_XSK_BUFF_POOL) {
+		bpf_xdp_shrink_data_zc(xdp, shrink, mem_info, release);
+		goto out;
+	}
+
+	if (release) {
+		struct page *page = skb_frag_page(frag);
+
+		__xdp_return(page_address(page), mem_info, false, NULL);
+	}
+
+out:
+	return release;
+}
+
 static int bpf_xdp_frags_shrink_tail(struct xdp_buff *xdp, int offset)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
@@ -4098,12 +4133,7 @@ static int bpf_xdp_frags_shrink_tail(struct xdp_buff *xdp, int offset)
 
 		len_free += shrink;
 		offset -= shrink;
-
-		if (skb_frag_size(frag) == shrink) {
-			struct page *page = skb_frag_page(frag);
-
-			__xdp_return(page_address(page), &xdp->rxq->mem,
-				     false, NULL);
+		if (bpf_xdp_shrink_data(xdp, frag, shrink)) {
 			n_frags_free++;
 		} else {
 			skb_frag_size_sub(frag, shrink);
-- 
2.43.0



