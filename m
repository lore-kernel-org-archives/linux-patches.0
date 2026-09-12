Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E11926AC5;
	Sat, 12 Sep 2026 13:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218938; cv=none; b=Jm0Qf6AuFuVCxEPz7AniUVT5fysf6I75wsYeqcEWUtVtEAlZcJrZZBgMMYn+lWkDABzxLQHOpdNd+orw3mSR1CdgCEKNfDqVJz9eKLhl4Q0stmtXabChxYIEKfwuyeKip2jxVefDiLzpc/GVXQoS9JCnSFsepZi4M0yws1r2704=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218938; c=relaxed/simple;
	bh=lzv0xzgHnGghG5cMv0PZLBo1FuRes4L/dePYR1EhiuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoYJ7ddSwghbnzLnxZp1Z1VJf87Kta42ctaEiJptKbwyQqSO4EYcrJ32utj+fv2ryRrvsR2kBTEhwNW/QB1Jj5/Cla3UcwJrs6yfKiSdbsOmcIqAZqTnBtnO2Fi/RMP4XMdCuEuerlURI5B0wQuYN/lxFFtZ5nA+bpoCdXutNHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5jo7FwK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5jo7FwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6656B1F000FF;
	Sat, 12 Sep 2026 13:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218937;
	bh=Bjk9WQH8nlz9tIRkdnJi6RXTk35eau1Ducippq99qkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C5jo7FwKWinP0xbzAGiqu591cG0Q/BYD/jjKyM0Zib7JkvDK8MqfOnOetjpfXD046
	 15YNg6t154SCOEyMUXzv9mfgC/7wQk7D3FJxYtWD1aFeZipMEpkfq18mircmdcaTYw
	 pMgUNKiJF4tR/OPJm5KWqvknJ8CcwVn1Zw1AV8lc=
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
Subject: [PATCH 6.12 1246/1376] xsk: fix NULL pointer dereference in __xsk_rcv()
Date: Sat, 12 Sep 2026 09:01:12 +0200
Message-ID: <20260912065635.314680864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6cc270ce455ce..36170e10deda4 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -245,9 +245,11 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
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
@@ -290,23 +292,45 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
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



