Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621989;
	b=a5UjaZqON3yjk0NSGd0W3We07msLTL5gqoKHgLEu7mfGVifsvOxNalBOoHyFieALmNAc
	 WJr9Uzb4eEtjPmLmBUu6XgiIpoO5q3gKHpCMwWwYV/RC8BivnpjDoiIicySLTjW3EdUKl
	 pmqP8LnIk7YZkmXThXDQVc53fiFIbZCPPLzxbxMWtv690FjrSHifd5TKwFrcbRhpQpGPq
	 O01xTY2RhTdelzAhYdANz5mWTrxXKXklp0QMatzIWCyPdFs433dEOILsKHkkBS86iPPiw
	 A0tKhKtGie0Y/Ug8G2oQEB/dReUjgtZeWBWw/ezzLmAS5aseaxGc+0P0J+k8+RUTLWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Dde32C7OZGW9n8v9xBCR/BjRXsWnvd6qAjk25lrHztQ=;
	b=mnLG/vkyyUVdqqtn7sx/mF1+Tlgb31QUcFxXuywj9iEEyI2HUdA03Hlk4rLuF+Du/Quh
	 tFENqQPWRBLqFCpLmEnvv0HN28vu18BgBh0Gyl6opa8WyzX/yk0RD1hcbTwi5awbOugqX
	 kXRMe/+qFAMlH+8ywM5jASqqYtmBgvky/H0EoeIW6uaL6FiBG5WqmxHoRVfndd9xv+VNW
	 ulAjpns2ugIb6YbZ9dIq01/gdzY5AlpbK231PB9qFXiqbURUtdKLgmvNeCscDQiigYhNi
	 1vhg72KxMuxKspEN5nQTwh+O5/CSh4KTVlKr3+JNIx2iKBmc7J9hmSV/XQe2UedEe3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVUvw1Rr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17321606A321;
	Wed, 25 Nov 2026 15:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVUvw1Rr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3DA1F000C4;
	Wed, 25 Nov 2026 15:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621988;
	bh=Dde32C7OZGW9n8v9xBCR/BjRXsWnvd6qAjk25lrHztQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVUvw1RrIHtCQ0WOeviji/v+6Tg2A6fnC+xjZ0oQCvDygY5NEQAC3w91qT5QtfbGt
	 2AaE8M+6tnSMrrOJpU3DR86YsyXQCShy1Y8yeSbX55TbOKhPb3HWDItRjXiGkD75n5
	 qe9xJWraf/+4GgnJtfJVXzstKEFiqkrX/2KewAPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nagato Shiratana <zuomao338@gmail.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 393/990] xsk: fix list corruption in xsk_buff_add_frag()
Date: Wed, 25 Nov 2026 15:29:20 +0100
Message-ID: <20261125143831.303176217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 94ae1259175f566ed5a33f37b09b6f32a1b2d8af ]

In aligned mode, a fill ring address maps straight to its pool->heads[]
entry. If user space posts the same address twice, a driver can pass
xsk_buff_add_frag() a buffer that is the head of the frame or is
already on pool->xskb_list or pool->free_list.

Re-adding a linked node corrupts the list. With buffers A, B, C, B,
xsk_rcv_zc() emits two descriptors instead of four and leaves the list
head pointing at a self-linked B. When the Rx ring later has no room
for a frame, the xsk_buff_free() cleanup follows B into pool->free_list
and passes the list head to xp_free():

  BUG: kernel NULL pointer dereference, address: 00000000000000c0
  RIP: 0010:xp_free+0x1a/0x50
  Call Trace:
   xsk_rcv_zc+0xca/0x200

The head is not on any list and needs a separate check. Adding it as
its own frag lets bpf_xdp_adjust_tail() free the in-use head and wrap
sinfo->nr_frags to 255.

Reject such buffers before adding them to the frags array, as commit
e37b2abca804 ("xsk: fix NULL pointer dereference in __xsk_rcv()") does
in the copy path. Callers already drop the frame on failure.

Unaligned mode is not affected, as each fill ring entry gets its own
xskb from pool->free_heads[].

Reproduced with a KUnit test feeding synthetic buffers to xsk_rcv_zc(),
by Nagato Shiratana.

Fixes: 24ea50127ecf ("xsk: support mbuf on ZC RX")
Reported-by: Nagato Shiratana <zuomao338@gmail.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://patch.msgid.link/20261102124950.958345-2-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock_drv.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 21c3b757bb883..e87d081e8e053 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -156,15 +156,18 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 static inline bool xsk_buff_add_frag(struct xdp_buff *head,
 				     struct xdp_buff *xdp)
 {
+	struct xdp_buff_xsk *frag = container_of(xdp, struct xdp_buff_xsk, xdp);
 	const void *data = xdp->data;
-	struct xdp_buff_xsk *frag;
+
+	/* Duplicate fill ring entries map to the same xskb in aligned mode */
+	if (unlikely(xdp == head || !list_empty(&frag->list_node)))
+		return false;
 
 	if (!__xdp_buff_add_frag(head, virt_to_netmem(data),
 				 offset_in_page(data), xdp->data_end - data,
 				 xdp->frame_sz, false))
 		return false;
 
-	frag = container_of(xdp, struct xdp_buff_xsk, xdp);
 	list_add_tail(&frag->list_node, &frag->pool->xskb_list);
 
 	return true;
-- 
2.53.0



