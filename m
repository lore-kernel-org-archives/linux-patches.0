Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23E43E5ECF;
	Wed, 20 May 2026 17:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299385; cv=none; b=fG88+hqBESDf1YBBLuJHgpfKzbk2962IN3y3LtGXc1NSs6+hJ6dz/z5fKYtt7KcyhGbG8s8EOlYD0MX9n9Saoi/z9L7K71wK9RM3tXJDdELSrJdGG4aqIZ05KI/pnk0N2CxpGjp8KTsl5mFU5ZjVxBh+jNEZPyskldKnEYiJz2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299385; c=relaxed/simple;
	bh=orBYPG24Iqh4JN3hKwA5YPl4DJ0i0zHQEXRX1QZI5yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSZsUhAAi8R7NVGWw3tWduGv+1lFiUGCtfI8WWQwEMsSv59FsPExCnRu8+IKal9Fu+0m7QJSKu7g5OCB3fEfP9ZI0dQOc/DNvuzPkBU1BE7BZgA0COwYcwipTVJdFbxz6OS0l05j8UH4P1zd8TZ3WJ46n3spdqYXmJYNj+sO7AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbSUZmoS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbSUZmoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4320D1F000E9;
	Wed, 20 May 2026 17:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299384;
	bh=BripImwmRU3xIvlG1cgTPie46pdB0q+Thu6LQCywMTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbSUZmoSUyvvfPkA7zblSS9c9jFGU1h3HtV0aRnOWg8wVQL1ca1M1QfO+ZeLGKn7A
	 ptSrvd/fBw5U8Mc/RsF221bGOQvB71wK2CM4d3aH9VO7EDo8Ckil6X9j2JdyVzQwI8
	 H1W7K6Qt13IierIzxBxiYH/VuYTaSh8F1QF4QEf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 710/957] vsock/virtio: fix MSG_ZEROCOPY pinned-pages accounting
Date: Wed, 20 May 2026 18:19:53 +0200
Message-ID: <20260520162149.942272646@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 41be06c4bd7ff..495c93cddcdc0 100644
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



