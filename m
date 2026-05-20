Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A25B3FA5EB;
	Wed, 20 May 2026 17:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296590; cv=none; b=p+qkFrouG7Gw0O7DG6/7hs7zzexAVxHDBvrGo3o1gWcoECobQu2dxkPRgUqWK4S6aZzb4k+NvmAoR5MRLpojlSraIewMg0sDsQzLEdySPIyh0zef8q5zm3BAprWzqn0GgMcR9Acw8cjM84sJZEaiDA2Q7HUv7npCIELDpZX2bFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296590; c=relaxed/simple;
	bh=Sq6W8QWipW24n7UGr9c1zmuw9A4lOIaHzDf0f+yGcyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7u4VSi718fzFgUORhmZS7ZX+dIoc9y2zmdbBySaBfI++MD/j6U0vimtjspFpTWlZXfe+QudlDRCYWWFHvTIGVeeZ1w8Virja5Rce8jExW9QgPm4zFl0gETii7YRbXXdCDyv/HKfvPKgMjgzB/mffdXti3FWHJNwAleHM+d5H3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IDJdjLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IDJdjLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813761F00893;
	Wed, 20 May 2026 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296588;
	bh=342yWYi5vqXvyjuO/MU/Y1xVJ3x/lCF2P4B54vaAWcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0IDJdjLS5Yav6gdqi0K9QCbBbPKvEOL8SCBlr/c1rJTFi1kqANRwc3r05hmwgm5SN
	 0FrkVzgyRvRtwhwafMNSYuL1VqiC6ihvrqcnXJwttLU3/jCMgnzak+q5bf9Y8bEo7I
	 NYMiAAypF2xEWtmZob+cyj9OW32rqEriQA/sGhvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0855/1146] vsock/virtio: fix MSG_ZEROCOPY pinned-pages accounting
Date: Wed, 20 May 2026 18:18:25 +0200
Message-ID: <20260520162207.588804505@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 1cb36e252211506f51095fe7ced8286cc77b4c80 ]

virtio_transport_init_zcopy_skb() uses iter->count as the size argument
for msg_zerocopy_realloc(), which in turn passes it to
mm_account_pinned_pages() for RLIMIT_MEMLOCK accounting. However, this
function is called after virtio_transport_fill_skb() has already consumed
the iterator via __zerocopy_sg_from_iter(), so on the last skb, iter->count
will be 0, skipping the RLIMIT_MEMLOCK enforcement.

Pass pkt_len (the total bytes being sent) as an explicit parameter to
virtio_transport_init_zcopy_skb() instead of reading the already-consumed
iter->count.

This matches TCP and UDP, which both call msg_zerocopy_realloc() with
the original message size.

Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Link: https://patch.msgid.link/20260420132051.217589-1-sgarzare@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 6547e199ea5b1..0d0265f770ada 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -75,6 +75,7 @@ static bool virtio_transport_can_zcopy(const struct virtio_transport *t_ops,
 static int virtio_transport_init_zcopy_skb(struct vsock_sock *vsk,
 					   struct sk_buff *skb,
 					   struct msghdr *msg,
+					   size_t pkt_len,
 					   bool zerocopy)
 {
 	struct ubuf_info *uarg;
@@ -83,12 +84,10 @@ static int virtio_transport_init_zcopy_skb(struct vsock_sock *vsk,
 		uarg = msg->msg_ubuf;
 		net_zcopy_get(uarg);
 	} else {
-		struct iov_iter *iter = &msg->msg_iter;
 		struct ubuf_info_msgzc *uarg_zc;
 
 		uarg = msg_zerocopy_realloc(sk_vsock(vsk),
-					    iter->count,
-					    NULL, false);
+					    pkt_len, NULL, false);
 		if (!uarg)
 			return -1;
 
@@ -385,11 +384,17 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 		 * each iteration. If this is last skb for this buffer
 		 * and MSG_ZEROCOPY mode is in use - we must allocate
 		 * completion for the current syscall.
+		 *
+		 * Pass pkt_len because msg iter is already consumed
+		 * by virtio_transport_fill_skb(), so iter->count
+		 * can not be used for RLIMIT_MEMLOCK pinned-pages
+		 * accounting done by msg_zerocopy_realloc().
 		 */
 		if (info->msg && info->msg->msg_flags & MSG_ZEROCOPY &&
 		    skb_len == rest_len && info->op == VIRTIO_VSOCK_OP_RW) {
 			if (virtio_transport_init_zcopy_skb(vsk, skb,
 							    info->msg,
+							    pkt_len,
 							    can_zcopy)) {
 				kfree_skb(skb);
 				ret = -ENOMEM;
-- 
2.53.0



