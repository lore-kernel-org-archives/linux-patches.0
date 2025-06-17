Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EB31E8332;
	Tue, 17 Jun 2025 16:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176292; cv=none; b=NKYUsxpZANT+Lod7MEmsYoLCFb3g4DG31GxrzXtVXKR7xo8kUz95yNxv4Lr3/01PM5UildcR91cWSwEy5fRwwY+ZI/g+oS/cBNhpoOXg/lv9YoVQg6nxTkcvjsSYYzD4FyUvr4gOhWULT7Q5BwyukJ7aNS0psux2mAnKKcXDIjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176292; c=relaxed/simple;
	bh=fcKLchJVI4r/1zHF+TTqiKKi6rKL90wDzJlOGS23hqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjz18kHxD/AUI/MOChzXEuZ/T3Tp6o/7fAwsk9UaI+JyoTCQOIvU/WrQ8kevUwnQPTl+P59mpXyh1JgmB+j6e00Ocg46tSbyr1W9pP2FMMwxd87Jz6VwIeW0GcWPXl7aC33oj2xxabSj55sxuDW1dSnMEfKcfbWoraN9Gb1Zg2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWWNfmil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWWNfmil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D961C4CEE7;
	Tue, 17 Jun 2025 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176291;
	bh=fcKLchJVI4r/1zHF+TTqiKKi6rKL90wDzJlOGS23hqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWWNfmilvbKgKh5cfPN9DKPKVXJlj/zmua6GzphKOzsIhK/PNYvId7cQpfFfLz69U
	 jsbUyGD9CspVChbiwPY6lmGrGlf4aWRnMusHLGQ4G3q+bMQDSdPsNfYBvP1kazgXIH
	 WgYfUxyvzx2/L8OEUXWL6vtAapHvqUFEpPzDbAc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faicker Mo <faicker.mo@zenlayer.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/512] net: openvswitch: Fix the dead loop of MPLS parse
Date: Tue, 17 Jun 2025 17:23:00 +0200
Message-ID: <20250617152428.308273060@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Faicker Mo <faicker.mo@zenlayer.com>

[ Upstream commit 0bdc924bfb319fb10d1113cbf091fc26fb7b1f99 ]

The unexpected MPLS packet may not end with the bottom label stack.
When there are many stacks, The label count value has wrapped around.
A dead loop occurs, soft lockup/CPU stuck finally.

stack backtrace:
UBSAN: array-index-out-of-bounds in /build/linux-0Pa0xK/linux-5.15.0/net/openvswitch/flow.c:662:26
index -1 is out of range for type '__be32 [3]'
CPU: 34 PID: 0 Comm: swapper/34 Kdump: loaded Tainted: G           OE   5.15.0-121-generic #131-Ubuntu
Hardware name: Dell Inc. PowerEdge C6420/0JP9TF, BIOS 2.12.2 07/14/2021
Call Trace:
 <IRQ>
 show_stack+0x52/0x5c
 dump_stack_lvl+0x4a/0x63
 dump_stack+0x10/0x16
 ubsan_epilogue+0x9/0x36
 __ubsan_handle_out_of_bounds.cold+0x44/0x49
 key_extract_l3l4+0x82a/0x840 [openvswitch]
 ? kfree_skbmem+0x52/0xa0
 key_extract+0x9c/0x2b0 [openvswitch]
 ovs_flow_key_extract+0x124/0x350 [openvswitch]
 ovs_vport_receive+0x61/0xd0 [openvswitch]
 ? kernel_init_free_pages.part.0+0x4a/0x70
 ? get_page_from_freelist+0x353/0x540
 netdev_port_receive+0xc4/0x180 [openvswitch]
 ? netdev_port_receive+0x180/0x180 [openvswitch]
 netdev_frame_hook+0x1f/0x40 [openvswitch]
 __netif_receive_skb_core.constprop.0+0x23a/0xf00
 __netif_receive_skb_list_core+0xfa/0x240
 netif_receive_skb_list_internal+0x18e/0x2a0
 napi_complete_done+0x7a/0x1c0
 bnxt_poll+0x155/0x1c0 [bnxt_en]
 __napi_poll+0x30/0x180
 net_rx_action+0x126/0x280
 ? bnxt_msix+0x67/0x80 [bnxt_en]
 handle_softirqs+0xda/0x2d0
 irq_exit_rcu+0x96/0xc0
 common_interrupt+0x8e/0xa0
 </IRQ>

Fixes: fbdcdd78da7c ("Change in Openvswitch to support MPLS label depth of 3 in ingress direction")
Signed-off-by: Faicker Mo <faicker.mo@zenlayer.com>
Acked-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/259D3404-575D-4A6D-B263-1DF59A67CF89@zenlayer.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/flow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 8a848ce72e291..b80bd3a907739 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -788,7 +788,7 @@ static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
 			memset(&key->ipv4, 0, sizeof(key->ipv4));
 		}
 	} else if (eth_p_mpls(key->eth.type)) {
-		u8 label_count = 1;
+		size_t label_count = 1;
 
 		memset(&key->mpls, 0, sizeof(key->mpls));
 		skb_set_inner_network_header(skb, skb->mac_len);
-- 
2.39.5



