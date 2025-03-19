Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CF11CEADB;
	Wed, 19 Mar 2025 14:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395020; cv=none; b=K3aEcaH3z7qhNMLOFWARFo2em35JIPtsFa832F6Rl7iRJZ2eDeLxPfNztIGIG0xJ4s/h/DuoHLlavPwVPrHnjgRI+7CZ4h/f3TOYelgUD0ZApHzy+49w0hZtsLnWoiKa8p3x8j+U7jiCnyfu3KsJI2Bi+G0dFMjCFw9rNkpw8QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395020; c=relaxed/simple;
	bh=vpsklKy+5aHxjgdS/FGoASdjnH76MEtXZ7V6ZYRIZME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZJnACkiHPfw6GjeLJ1nSLmVTqXHFa7ot1c/r9UWsHEsLu8+1LJMYLF/MFbGIjJYCl2yw0QWUZrZJISKnsXtr7Zp6RjGDhVKHkE8iiljAsj1px2vXcp9bRHr4GlUbLxJnVvGNo+mQYfLHss6x2Kbq5q8bfKQehh/3JQw18PfAwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VflQYL3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VflQYL3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB27C4CEE4;
	Wed, 19 Mar 2025 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395020;
	bh=vpsklKy+5aHxjgdS/FGoASdjnH76MEtXZ7V6ZYRIZME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VflQYL3qPCX/vTS/bvs/Sw6QkWBtPt4oQ+jdb4Zsdx8oup7Oj5ZgcR8D6CRobV1un
	 t3UebmgKh1N3u70NDkPdeL/bPlBWqGKKK/bHALyzRPBrTJ7csxXziya5L+BtbRS0L+
	 yPS3jve+e0Hfzt8acranD3CZWRO9PN5eW8KUL/Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/231] eth: bnxt: do not update checksum in bnxt_xdp_build_skb()
Date: Wed, 19 Mar 2025 07:28:46 -0700
Message-ID: <20250319143027.630838424@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit c03e7d05aa0e2f7e9a9ce5ad8a12471a53f941dc ]

The bnxt_rx_pkt() updates ip_summed value at the end if checksum offload
is enabled.
When the XDP-MB program is attached and it returns XDP_PASS, the
bnxt_xdp_build_skb() is called to update skb_shared_info.
The main purpose of bnxt_xdp_build_skb() is to update skb_shared_info,
but it updates ip_summed value too if checksum offload is enabled.
This is actually duplicate work.

When the bnxt_rx_pkt() updates ip_summed value, it checks if ip_summed
is CHECKSUM_NONE or not.
It means that ip_summed should be CHECKSUM_NONE at this moment.
But ip_summed may already be updated to CHECKSUM_UNNECESSARY in the
XDP-MB-PASS path.
So the by skb_checksum_none_assert() WARNS about it.

This is duplicate work and updating ip_summed in the
bnxt_xdp_build_skb() is not needed.

Splat looks like:
WARNING: CPU: 3 PID: 5782 at ./include/linux/skbuff.h:5155 bnxt_rx_pkt+0x479b/0x7610 [bnxt_en]
Modules linked in: bnxt_re bnxt_en rdma_ucm rdma_cm iw_cm ib_cm ib_uverbs veth xt_nat xt_tcpudp xt_conntrack nft_chain_nat xt_MASQUERADE nf_]
CPU: 3 UID: 0 PID: 5782 Comm: socat Tainted: G        W          6.14.0-rc4+ #27
Tainted: [W]=WARN
Hardware name: ASUS System Product Name/PRIME Z690-P D4, BIOS 0603 11/01/2021
RIP: 0010:bnxt_rx_pkt+0x479b/0x7610 [bnxt_en]
Code: 54 24 0c 4c 89 f1 4c 89 ff c1 ea 1f ff d3 0f 1f 00 49 89 c6 48 85 c0 0f 84 4c e5 ff ff 48 89 c7 e8 ca 3d a0 c8 e9 8f f4 ff ff <0f> 0b f
RSP: 0018:ffff88881ba09928 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 00000000c7590303 RCX: 0000000000000000
RDX: 1ffff1104e7d1610 RSI: 0000000000000001 RDI: ffff8881c91300b8
RBP: ffff88881ba09b28 R08: ffff888273e8b0d0 R09: ffff888273e8b070
R10: ffff888273e8b010 R11: ffff888278b0f000 R12: ffff888273e8b080
R13: ffff8881c9130e00 R14: ffff8881505d3800 R15: ffff888273e8b000
FS:  00007f5a2e7be080(0000) GS:ffff88881ba00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff2e708ff8 CR3: 000000013e3b0000 CR4: 00000000007506f0
PKRU: 55555554
Call Trace:
 <IRQ>
 ? __warn+0xcd/0x2f0
 ? bnxt_rx_pkt+0x479b/0x7610
 ? report_bug+0x326/0x3c0
 ? handle_bug+0x53/0xa0
 ? exc_invalid_op+0x14/0x50
 ? asm_exc_invalid_op+0x16/0x20
 ? bnxt_rx_pkt+0x479b/0x7610
 ? bnxt_rx_pkt+0x3e41/0x7610
 ? __pfx_bnxt_rx_pkt+0x10/0x10
 ? napi_complete_done+0x2cf/0x7d0
 __bnxt_poll_work+0x4e8/0x1220
 ? __pfx___bnxt_poll_work+0x10/0x10
 ? __pfx_mark_lock.part.0+0x10/0x10
 bnxt_poll_p5+0x36a/0xfa0
 ? __pfx_bnxt_poll_p5+0x10/0x10
 __napi_poll.constprop.0+0xa0/0x440
 net_rx_action+0x899/0xd00
...

Following ping.py patch adds xdp-mb-pass case. so ping.py is going
to be able to reproduce this issue.

Fixes: 1dc4c557bfed ("bnxt: adding bnxt_xdp_build_skb to build skb from multibuffer xdp_buff")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Link: https://patch.msgid.link/20250309134219.91670-5-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 11 ++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |  3 +--
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 442c85b3ea3f3..7293d7732d6ce 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2205,7 +2205,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 			if (!skb)
 				goto oom_next_rx;
 		} else {
-			skb = bnxt_xdp_build_skb(bp, skb, agg_bufs, rxr->page_pool, &xdp, rxcmp1);
+			skb = bnxt_xdp_build_skb(bp, skb, agg_bufs,
+						 rxr->page_pool, &xdp);
 			if (!skb) {
 				/* we should be able to free the old skb here */
 				bnxt_xdp_buff_frags_free(rxr, &xdp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index f9e7e71b89485..8726657f5cb9e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -456,20 +456,13 @@ int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 
 struct sk_buff *
 bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb, u8 num_frags,
-		   struct page_pool *pool, struct xdp_buff *xdp,
-		   struct rx_cmp_ext *rxcmp1)
+		   struct page_pool *pool, struct xdp_buff *xdp)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 
 	if (!skb)
 		return NULL;
-	skb_checksum_none_assert(skb);
-	if (RX_CMP_L4_CS_OK(rxcmp1)) {
-		if (bp->dev->features & NETIF_F_RXCSUM) {
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
-			skb->csum_level = RX_CMP_ENCAP(rxcmp1);
-		}
-	}
+
 	xdp_update_skb_shared_info(skb, num_frags,
 				   sinfo->xdp_frags_size,
 				   BNXT_RX_PAGE_SIZE * num_frags,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 0122782400b8a..220285e190fcd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -33,6 +33,5 @@ void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
 			      struct xdp_buff *xdp);
 struct sk_buff *bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb,
 				   u8 num_frags, struct page_pool *pool,
-				   struct xdp_buff *xdp,
-				   struct rx_cmp_ext *rxcmp1);
+				   struct xdp_buff *xdp);
 #endif
-- 
2.39.5



