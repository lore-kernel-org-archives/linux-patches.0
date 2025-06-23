Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC0D1EE7C6;
	Mon, 23 Jun 2025 21:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714473; cv=none; b=WN3e3qWUX5mstoTb5X3NSbpP1VO4gHV+SNAtie1kc0T66kyCmPVrjuAW+rnaKFxxhWyZUxJUiA2jOLhb5WL0IJ0ZW7FHZLNhQHfj62UvPfUqYsRVXwT55eJFXRUDG+DkHBPnvKnbwWBWUoweudYrJ5gLTQDI0j33dXtMOdRGUQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714473; c=relaxed/simple;
	bh=JB4OHD9VRlTdBZ/bVkRLwE0h3mPEujYheARk7jd5UL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewCzJwoQmXHhC/JMhDkKfycAWir464kYE/g7g9/z4yZQCwLjssSqJ3E2yA2+5mKw30u31bttCsr/E12d8L8MiqMJ9DXGGT6cpNASpLX4E4bX2B/IzGj3iLKGQ3G9LLyCFEcu6gaWK0CEjB625AU4yRj4nbeNRxMUpHKHc1Zjfas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=og4ddLzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="og4ddLzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8318BC4CEED;
	Mon, 23 Jun 2025 21:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714472;
	bh=JB4OHD9VRlTdBZ/bVkRLwE0h3mPEujYheARk7jd5UL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=og4ddLzO/ximJOZWR23prchiApzK5WMTs8UFDBM/Oet8KJsA3w2ib2yS/3a50axds
	 810IZh15JO6vrGIgefbjJS2ZNM7aCGouJ+AjQQjybhk1UNfaV4djuUQyPREnnbXiXZ
	 9mrF6RAX5yDVo/Kum5qZE9e5rwnOsdYGpO0GwhnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiming Cheng <shiming.cheng@mediatek.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/508] net: fix udp gso skb_segment after pull from frag_list
Date: Mon, 23 Jun 2025 15:03:45 +0200
Message-ID: <20250623130649.703414702@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiming Cheng <shiming.cheng@mediatek.com>

[ Upstream commit 3382a1ed7f778db841063f5d7e317ac55f9e7f72 ]

Commit a1e40ac5b5e9 ("net: gso: fix udp gso fraglist segmentation after
pull from frag_list") detected invalid geometry in frag_list skbs and
redirects them from skb_segment_list to more robust skb_segment. But some
packets with modified geometry can also hit bugs in that code. We don't
know how many such cases exist. Addressing each one by one also requires
touching the complex skb_segment code, which risks introducing bugs for
other types of skbs. Instead, linearize all these packets that fail the
basic invariants on gso fraglist skbs. That is more robust.

If only part of the fraglist payload is pulled into head_skb, it will
always cause exception when splitting skbs by skb_segment. For detailed
call stack information, see below.

Valid SKB_GSO_FRAGLIST skbs
- consist of two or more segments
- the head_skb holds the protocol headers plus first gso_size
- one or more frag_list skbs hold exactly one segment
- all but the last must be gso_size

Optional datapath hooks such as NAT and BPF (bpf_skb_pull_data) can
modify fraglist skbs, breaking these invariants.

In extreme cases they pull one part of data into skb linear. For UDP,
this  causes three payloads with lengths of (11,11,10) bytes were
pulled tail to become (12,10,10) bytes.

The skbs no longer meets the above SKB_GSO_FRAGLIST conditions because
payload was pulled into head_skb, it needs to be linearized before pass
to regular skb_segment.

    skb_segment+0xcd0/0xd14
    __udp_gso_segment+0x334/0x5f4
    udp4_ufo_fragment+0x118/0x15c
    inet_gso_segment+0x164/0x338
    skb_mac_gso_segment+0xc4/0x13c
    __skb_gso_segment+0xc4/0x124
    validate_xmit_skb+0x9c/0x2c0
    validate_xmit_skb_list+0x4c/0x80
    sch_direct_xmit+0x70/0x404
    __dev_queue_xmit+0x64c/0xe5c
    neigh_resolve_output+0x178/0x1c4
    ip_finish_output2+0x37c/0x47c
    __ip_finish_output+0x194/0x240
    ip_finish_output+0x20/0xf4
    ip_output+0x100/0x1a0
    NF_HOOK+0xc4/0x16c
    ip_forward+0x314/0x32c
    ip_rcv+0x90/0x118
    __netif_receive_skb+0x74/0x124
    process_backlog+0xe8/0x1a4
    __napi_poll+0x5c/0x1f8
    net_rx_action+0x154/0x314
    handle_softirqs+0x154/0x4b8

    [118.376811] [C201134] rxq0_pus: [name:bug&]kernel BUG at net/core/skbuff.c:4278!
    [118.376829] [C201134] rxq0_pus: [name:traps&]Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
    [118.470774] [C201134] rxq0_pus: [name:mrdump&]Kernel Offset: 0x178cc00000 from 0xffffffc008000000
    [118.470810] [C201134] rxq0_pus: [name:mrdump&]PHYS_OFFSET: 0x40000000
    [118.470827] [C201134] rxq0_pus: [name:mrdump&]pstate: 60400005 (nZCv daif +PAN -UAO)
    [118.470848] [C201134] rxq0_pus: [name:mrdump&]pc : [0xffffffd79598aefc] skb_segment+0xcd0/0xd14
    [118.470900] [C201134] rxq0_pus: [name:mrdump&]lr : [0xffffffd79598a5e8] skb_segment+0x3bc/0xd14
    [118.470928] [C201134] rxq0_pus: [name:mrdump&]sp : ffffffc008013770

Fixes: a1e40ac5b5e9 ("gso: fix udp gso fraglist segmentation after pull from frag_list")
Signed-off-by: Shiming Cheng <shiming.cheng@mediatek.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index d415b4fb2f1f4..1a51c4b44c006 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -331,6 +331,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	bool copy_dtor;
 	__sum16 check;
 	__be16 newlen;
+	int ret = 0;
 
 	mss = skb_shinfo(gso_skb)->gso_size;
 	if (gso_skb->len <= sizeof(*uh) + mss)
@@ -353,6 +354,10 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 		if (skb_pagelen(gso_skb) - sizeof(*uh) == skb_shinfo(gso_skb)->gso_size)
 			return __udp_gso_segment_list(gso_skb, features, is_ipv6);
 
+		ret = __skb_linearize(gso_skb);
+		if (ret)
+			return ERR_PTR(ret);
+
 		 /* Setup csum, as fraglist skips this in udp4_gro_receive. */
 		gso_skb->csum_start = skb_transport_header(gso_skb) - gso_skb->head;
 		gso_skb->csum_offset = offsetof(struct udphdr, check);
-- 
2.39.5



