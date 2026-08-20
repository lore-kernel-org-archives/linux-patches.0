Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6430D47D46A;
	Thu, 20 Aug 2026 16:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244575; cv=none; b=qNMJ3BHOM3+ILKf42xjSGui2D9q6S1darFbd99A1GL88O35l8Qd7g61MoRp8+bOOHNo3d5GT2Tkqvk3xJZPkH8idPIYMs1WWrIYLN0ju4ZYy7FtTJGHqTOuJogLuwNC+cNfzcWcqrw7w+z2QF53mQU+IPrLuOIAws2Ha+Srdx/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244575; c=relaxed/simple;
	bh=F8UsCnfTQOc2Cc/smBi+aW2c6amVJrndU79JHqnRGCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ke+yjJWZpsqgYP9LKt87AIBWEnNv2Y00s4unNtdEXGn19WuKhsz3yOS0U+y0AP9F6+sjWRBf5wLYcpZmF3w9IP+fYjD0b6apWNc6wv9VeTcP9WGQCGqOv6nzNpbwu14IzQm6ZUt/v8+l0J+gl4fWvgvvOIpwX7ZqjdxDXdQXZX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Lig52Xw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Lig52Xw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0161F000E9;
	Thu, 20 Aug 2026 16:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244574;
	bh=qY+BCJX+8lqYHmC9BQybVaOs0fw6WwLYcejomx9YVZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Lig52XwRZwGBZ6Hzbb73La7mt1Vj8czhcqxsIYEzS+PwIgAAYjHzqrRcs5yx4Ncd
	 GtvzkTXWxFdbiO+s2vzDUDq7R5RIzSyKBd4vlz2Xz2JKZ8ggSu6Xp+k+NN1MCniTpj
	 0u929bh48BlyaMAkHG8Yu+Nv/b2RMLDn+apxN7Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sukhdeep Singh <sukhdeeps@marvell.com>,
	Yangyu Chen <cyy@cyyself.name>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 215/235] net: atlantic: free stranded TX buffers on ring deinit
Date: Thu, 20 Aug 2026 16:57:31 +0200
Message-ID: <20260820145223.132187749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangyu Chen <cyy@cyyself.name>

commit 452636ea5410a96e02ebaaf80b21e3620b98e0dd upstream.

aq_vec_deinit() drains the TX rings with a single aq_ring_tx_clean()
call, which frees at most AQ_CFG_TX_CLEAN_BUDGET (256) descriptors and
stops at hw_head, which no longer moves once aq_vec_stop() has stopped
the hardware and NAPI. Completed descriptors beyond the budget and
everything still posted in [hw_head, sw_tail) keep their skb or
xdp_frame when the interface goes down: aq_vec_ring_free() then frees
the buffer ring and the references are lost for good.

Today this is a silent memory leak on every interface down under
TX/XDP_TX load. With the conversion of the RX path to page_pool posted
for net-next it becomes much more visible: XDP_TX frames carry fragment
references on the RX ring's page_pool, so a single stranded frame keeps
the pool's inflight count above zero forever. page_pool_destroy() then
never completes, the pool is leaked together with its pages, and
"page_pool_release_retry() stalled pool shutdown" is warned every 60
seconds from that point on, on every ifdown, XDP detach or ring resize
under XDP_TX load.

Bring back aq_ring_tx_deinit() as it was before the removal and use it
for teardown again, with one extension: TX rings can hold xdp_frames
nowadays, so release those too. They are returned with
xdp_return_frame() since this runs in process context.

Fixes: eb36bedf28be ("net: aquantia: remove function aq_ring_tx_deinit")
Cc: stable@vger.kernel.org # v4.11+
Reviewed-by: Sukhdeep Singh <sukhdeeps@marvell.com>
Signed-off-by: Yangyu Chen <cyy@cyyself.name>
Acked-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/tencent_EEDC35FAF2750A3A6A0B39BAE0E2C484860A@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Dropped the XDP frame arm from the new teardown loop since `buff->xdpf` and `xdp_return_frame()` don't exist in 5.15, and omitted the `aq_xdp_xmit()` context line in the header hunk. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c |   25 +++++++++++++++++++++++
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h |    1 
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c  |    2 -
 3 files changed, 27 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -314,6 +314,31 @@ bool aq_ring_tx_clean(struct aq_ring_s *
 	return !!budget;
 }
 
+void aq_ring_tx_deinit(struct aq_ring_s *self)
+{
+	if (!self)
+		return;
+
+	for (; self->sw_head != self->sw_tail;
+		self->sw_head = aq_ring_next_dx(self, self->sw_head)) {
+		struct aq_ring_buff_s *buff = &self->buff_ring[self->sw_head];
+		struct device *ndev = aq_nic_get_dev(self->aq_nic);
+
+		if (buff->is_mapped) {
+			if (buff->is_sop) {
+				dma_unmap_single(ndev, buff->pa, buff->len,
+						 DMA_TO_DEVICE);
+			} else {
+				dma_unmap_page(ndev, buff->pa, buff->len,
+					       DMA_TO_DEVICE);
+			}
+		}
+
+		if (buff->is_eop && buff->skb)
+			dev_kfree_skb_any(buff->skb);
+	}
+}
+
 static void aq_rx_checksum(struct aq_ring_s *self,
 			   struct aq_ring_buff_s *buff,
 			   struct sk_buff *skb)
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -182,6 +182,7 @@ void aq_ring_update_queue_state(struct a
 void aq_ring_queue_wake(struct aq_ring_s *ring);
 void aq_ring_queue_stop(struct aq_ring_s *ring);
 bool aq_ring_tx_clean(struct aq_ring_s *self);
+void aq_ring_tx_deinit(struct aq_ring_s *self);
 int aq_ring_rx_clean(struct aq_ring_s *self,
 		     struct napi_struct *napi,
 		     int *work_done,
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -270,7 +270,7 @@ void aq_vec_deinit(struct aq_vec_s *self
 
 	for (i = 0U; self->tx_rings > i; ++i) {
 		ring = self->ring[i];
-		aq_ring_tx_clean(&ring[AQ_VEC_TX_ID]);
+		aq_ring_tx_deinit(&ring[AQ_VEC_TX_ID]);
 		aq_ring_rx_deinit(&ring[AQ_VEC_RX_ID]);
 	}
 


