Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA76E46EC77;
	Tue, 21 Jul 2026 19:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661316; cv=none; b=TwLOQPcle6azeo98l6+uvH0FrAoStaqiQ/0Dk/1+EKQCvGbeTaFZUS0tnfjYmplP7D/TwOZ4vFTYIzmRXswgwmxjCSkmKOjcG39JOLhTUyQNLoOQMTBpjHeRiRb3WX87ba+qKqjK4ha+2vHZ0zwn41x4++l6tO5MQH1Bgyflkgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661316; c=relaxed/simple;
	bh=VUJ+2ytorO4RNNGUT/jnYtLGaaFkBisxpoaZGULvH+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjiiasQX0OwQ47L6krDm/Fo+pgWfpmmd3zVj7oMp5BHKP3t+IDIE2L79abRoMXZIF/9e48AbQOdAJyrN6vBEkh6g3YoieR1pJfZiytKiO9oQBAJq04wFRBIVPFQCyakP/o3wztNgovVsCj9PsFCv+CW2t8//uxkDhnMxIkLbGQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dY6eu4MC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dY6eu4MC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF58E1F000E9;
	Tue, 21 Jul 2026 19:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661314;
	bh=DB7pEhHmnua5YlOA1ileA0rXoM/rqlYsVnlbsWpFdfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dY6eu4MCMeHrsusP4zokqGm5Ve4WiaKifbgKv5B5Bn6wSNUkGaRSN8SHM+qFXndvW
	 m5FJCKK5MrCGtOQns1bXK52ya8rJnJtnr+vOyzYFrX48EEi27O5hGFTXqm7OO0C5oJ
	 9+ZRqAhFXvbj1Mfi/qsuVT3jpsOVGxX7QxUuzjAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <malin89@huawei.com>,
	Rongzhen Cui <cuirongzhen@huawei.com>,
	Jingguo Tan <tanjingguo@huawei.com>,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0021/1276] vsock/virtio: bind uarg before filling zerocopy skb
Date: Tue, 21 Jul 2026 17:07:44 +0200
Message-ID: <20260721152446.555953253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Jingguo Tan <tanjingguo@huawei.com>

[ Upstream commit 1e584c304cfb94a759417130b1fc6d30b30c4cce ]

virtio_transport_send_pkt_info() allocates or reuses the zerocopy uarg
before entering the send loop, but virtio_transport_alloc_skb() still
fills the skb before it inherits that uarg. When fixed-buffer vectored
zerocopy hits MAX_SKB_FRAGS, io_sg_from_iter() may partially attach
managed frags and return -EMSGSIZE. The rollback path call kfree_skb()
to free an skb that carries SKBFL_MANAGED_FRAG_REFS but no uarg, so
skb_release_data() falls through to ordinary frag unref.

Pass the uarg into virtio_transport_alloc_skb() and bind it immediately
before virtio_transport_fill_skb(). This keeps control or no-payload skbs
untouched while ensuring success and rollback share one lifetime rule.

Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
Signed-off-by: Lin Ma <malin89@huawei.com>
Signed-off-by: Rongzhen Cui <cuirongzhen@huawei.com>
Signed-off-by: Jingguo Tan <tanjingguo@huawei.com>
Acked-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260527023301.1075581-1-malin89@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index c3547d783db23c..49bd5d12c30276 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -208,6 +208,7 @@ static u16 virtio_transport_get_type(struct sock *sk)
 static struct sk_buff *virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 						  size_t payload_len,
 						  bool zcopy,
+						  struct ubuf_info *uarg,
 						  u32 src_cid,
 						  u32 src_port,
 						  u32 dst_cid,
@@ -248,6 +249,12 @@ static struct sk_buff *virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *
 	if (info->msg && payload_len > 0) {
 		int err;
 
+		/* Bind the zerocopy lifetime before filling frags so error
+		 * rollback frees managed fixed-buffer pages through
+		 * the uarg-aware path.
+		 */
+		skb_zcopy_set(skb, uarg, NULL);
+
 		err = virtio_transport_fill_skb(skb, info, payload_len, zcopy);
 		if (err)
 			goto out;
@@ -367,6 +374,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 		skb_len = min(max_skb_len, rest_len);
 
 		skb = virtio_transport_alloc_skb(info, skb_len, can_zcopy,
+						 uarg,
 						 src_cid, src_port,
 						 dst_cid, dst_port);
 		if (!skb) {
@@ -374,8 +382,6 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 			break;
 		}
 
-		skb_zcopy_set(skb, uarg, NULL);
-
 		virtio_transport_inc_tx_pkt(vvs, skb);
 
 		ret = t_ops->send_pkt(skb);
@@ -1171,7 +1177,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 	if (!t)
 		return -ENOTCONN;
 
-	reply = virtio_transport_alloc_skb(&info, 0, false,
+	reply = virtio_transport_alloc_skb(&info, 0, false, NULL,
 					   le64_to_cpu(hdr->dst_cid),
 					   le32_to_cpu(hdr->dst_port),
 					   le64_to_cpu(hdr->src_cid),
-- 
2.53.0



