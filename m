Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2D3416124;
	Sat, 12 Sep 2026 09:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204706; cv=none; b=DWbyOiVhYbpOtdBm542MPgzFrWjs3wDSRb/n2M6a0TsbSNrd1O7Ihh1xIhjZlt+gdyaLTuDLq18HmQafKoVOBEy0krWgcRI+5kyEQ92/wfJ243wr0vQ2EbmhmeLUbKMR1e0zAzWmS5qiaD9Y+qGbRxGGHBNa7ldf4CIjvn3bd9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204706; c=relaxed/simple;
	bh=AOAv9pRmCEXogAjp45Yy8L+d0tgZVDtPLLKoydLgYKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZkYNCUp4Qwrqn7GJZ4gREGOHVguOTD2e7oqc4sxXOJZRDRF7zvGtJ46hd5uRZTTkBuIdd4DUMmW/ZYBtqVuUeKFZY9hfskBPfTUHIjJd/f9sTPuWprN64Yvbrnz8JjtYMVFqeXfbZ1gzZrQcAzm5oJmlrIse/2ZnbDt9y+oCOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVFa6OAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVFa6OAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4591F000FF;
	Sat, 12 Sep 2026 09:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204702;
	bh=es0/SsPO7BPPybBRyl0WukQoghLNSzqDSGfAWAwkk6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVFa6OAguGB3QEO6CcXa89h5dxm0JgIQyDrBFwTmyh8SmrqZQzmAfkb9lU0FYqCSm
	 g6UorP8+OJUCcLsuJO826hUS+7+N4r3GjdQkOaXzjx2+/tYio2xOuEmlnC7XSeAg7g
	 NG5fpfx8oux5zyPUWqQuLTUzADB299sL/VqnXl5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1667/1815] xsk: fix NULL pointer dereference in __xsk_rcv()
Date: Sat, 12 Sep 2026 08:56:57 +0200
Message-ID: <20260912065728.125299563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

[ Upstream commit e37b2abca80473e106176e41712a369fd2f72117 ]

In the __xsk_rcv() multi-buffer path, xsk_buff_alloc() is called in a
loop without checking its return value. xsk_buff_can_alloc() only
counts fill queue entries without validating their addresses, so it
can succeed while xsk_buff_alloc() rejects all remaining entries and
returns NULL.

  Oops: general protection fault, probably for non-canonical address
   0xdffffc0000000000
  KASAN: null-ptr-deref in range
   [0x0000000000000000-0x0000000000000007]
  RIP: 0010:__xsk_rcv+0x426/0xc20 (net/xdp/xsk.c:350)
  Call Trace:
   xsk_generic_rcv+0x26d/0x5f0
   xdp_do_generic_redirect+0x3c5/0xcf0
   do_xdp_generic+0x92f/0xe70
   __netif_receive_skb_core.constprop.0+0xf7e/0x2b30

Fix this with a two-stage transaction. First allocate and stage all
buffers required for the packet, recycling all staged buffers with
xsk_buff_free() if any allocation fails. Only after this stage
succeeds, copy the data, reserve the RX descriptors, and release the
buffers in an error-free loop.

Fixes: 804627751b42 ("xsk: add support for AF_XDP multi-buffer on Rx path")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20260813215328.99311-1-blbllhy@gmail.com
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 7855ee09c4b64..33475b180ea6f 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -298,9 +298,11 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 	u32 frame_size = __xsk_pool_get_rx_frame_size(xs->pool);
 	void *copy_from = xsk_copy_xdp_start(xdp), *copy_to;
 	u32 from_len, meta_len, rem, num_desc;
-	struct xdp_buff_xsk *xskb;
+	struct xdp_buff_xsk *xskb, *tmp;
 	struct xdp_buff *xsk_xdp;
+	LIST_HEAD(xsk_buffs);
 	skb_frag_t *frag;
+	u32 i;
 
 	from_len = xdp->data_end - copy_from;
 	meta_len = xdp->data - copy_from;
@@ -343,23 +345,45 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 		frag =  &sinfo->frags[0];
 	}
 
+	for (i = 0; i < num_desc; i++) {
+		xsk_xdp = xsk_buff_alloc(xs->pool);
+		if (!xsk_xdp)
+			goto err_alloc;
+
+		xskb = container_of(xsk_xdp, struct xdp_buff_xsk, xdp);
+		if (unlikely(!list_empty(&xskb->list_node)))
+			goto err_alloc;
+
+		list_add_tail(&xskb->list_node, &xsk_buffs);
+	}
+
 	do {
 		u32 to_len = frame_size + meta_len;
 		u32 copied;
 
-		xsk_xdp = xsk_buff_alloc(xs->pool);
+		xskb = list_first_entry(&xsk_buffs, struct xdp_buff_xsk,
+					list_node);
+		list_del_init(&xskb->list_node);
+		xsk_xdp = &xskb->xdp;
 		copy_to = xsk_xdp->data - meta_len;
 
 		copied = xsk_copy_xdp(copy_to, &copy_from, to_len, &from_len, &frag, rem);
 		rem -= copied;
 
-		xskb = container_of(xsk_xdp, struct xdp_buff_xsk, xdp);
 		__xsk_rcv_zc_safe(xs, xskb, copied - meta_len,
 				  rem ? XDP_PKT_CONTD : 0);
 		meta_len = 0;
 	} while (rem);
 
 	return 0;
+
+err_alloc:
+	list_for_each_entry_safe(xskb, tmp, &xsk_buffs, list_node) {
+		list_del_init(&xskb->list_node);
+		xsk_buff_free(&xskb->xdp);
+	}
+	xs->rx_dropped++;
+	return -ENOMEM;
 }
 
 static bool xsk_tx_writeable(struct xdp_sock *xs)
-- 
2.53.0



