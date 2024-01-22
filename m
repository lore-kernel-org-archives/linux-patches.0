Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9E0154BE1;
	Tue, 23 Jan 2024 00:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969386; cv=none; b=IJZ+aLUcmaIYMlV/fyDJSkxste2KRVJEjO8njh8XotQSLKFJQsi8iN/gmJdB7icCyuUA2aX1RpK5tfJ+WPi72FMp1apI29idwU3GTA02L0qh681HJQfryDu484oMpr8c7ncfcrww6oG2m1XdEs+x17jTZ2uyiHthsxbt6bFRpMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969386; c=relaxed/simple;
	bh=ulcSw1SrjZqWscwgSKUzoRXGyYFicJJlbUR9DBlziyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZsDvFsI97TyDlxsOwByJBnSw/1+loiN8WeF36Uu/G2HZOtsjD/14qi106Bf8Frymhtx8rUPeRKgBZ+83WgwzXuXAtM/arfnSdisoJZb2nZhrH76D8IpeBeOsz96VtCGX7BWg/CwH0YDGMey7Y3IawbhPB51wOx4SQSxVblWISI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGAJoBl2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGAJoBl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF98C43399;
	Tue, 23 Jan 2024 00:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969385;
	bh=ulcSw1SrjZqWscwgSKUzoRXGyYFicJJlbUR9DBlziyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGAJoBl241wYoYJWbf8/yaK1bU3GaxJGkG+RMba2FAF32yszKNKAv8qJ1D2seCzx4
	 z+CnGdOIFKAi2Ww0yFTEGxe4VF7mzBLq8OIKjroL3xGbauqwlaw83Caak5AV81xk/R
	 bDRNy/OEYCX6bDH+IQetK7YOinJ8cAKDy3amZp2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 187/641] virtio/vsock: send credit update during setting SO_RCVLOWAT
Date: Mon, 22 Jan 2024 15:51:31 -0800
Message-ID: <20240122235823.829985444@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseniy Krasnov <avkrasnov@salutedevices.com>

[ Upstream commit 0fe1798968115488c0c02f4633032a015b1faf97 ]

Send credit update message when SO_RCVLOWAT is updated and it is bigger
than number of bytes in rx queue. It is needed, because 'poll()' will
wait until number of bytes in rx queue will be not smaller than
O_RCVLOWAT, so kick sender to send more data. Otherwise mutual hungup
for tx/rx is possible: sender waits for free space and receiver is
waiting data in 'poll()'.

Rename 'set_rcvlowat' callback to 'notify_set_rcvlowat' and set
'sk->sk_rcvlowat' only in one place (i.e. 'vsock_set_rcvlowat'), so the
transport doesn't need to do it.

Fixes: b89d882dc9fc ("vsock/virtio: reduce credit update messages")
Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c                   |  1 +
 include/linux/virtio_vsock.h            |  1 +
 include/net/af_vsock.h                  |  2 +-
 net/vmw_vsock/af_vsock.c                |  9 ++++++--
 net/vmw_vsock/hyperv_transport.c        |  4 ++--
 net/vmw_vsock/virtio_transport.c        |  1 +
 net/vmw_vsock/virtio_transport_common.c | 30 +++++++++++++++++++++++++
 net/vmw_vsock/vsock_loopback.c          |  1 +
 8 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f75731396b7e..ec20ecff85c7 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -449,6 +449,7 @@ static struct virtio_transport vhost_transport = {
 		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
+		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
 		.read_skb = virtio_transport_read_skb,
 	},
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index ebb3ce63d64d..c82089dee0c8 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -256,4 +256,5 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
 void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
 int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
 int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
+int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val);
 #endif /* _LINUX_VIRTIO_VSOCK_H */
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index e302c0e804d0..535701efc1e5 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -137,7 +137,6 @@ struct vsock_transport {
 	u64 (*stream_rcvhiwat)(struct vsock_sock *);
 	bool (*stream_is_active)(struct vsock_sock *);
 	bool (*stream_allow)(u32 cid, u32 port);
-	int (*set_rcvlowat)(struct vsock_sock *vsk, int val);
 
 	/* SEQ_PACKET. */
 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
@@ -168,6 +167,7 @@ struct vsock_transport {
 		struct vsock_transport_send_notify_data *);
 	/* sk_lock held by the caller */
 	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
+	int (*notify_set_rcvlowat)(struct vsock_sock *vsk, int val);
 
 	/* Shutdown. */
 	int (*shutdown)(struct vsock_sock *, int);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 816725af281f..54ba7316f808 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2264,8 +2264,13 @@ static int vsock_set_rcvlowat(struct sock *sk, int val)
 
 	transport = vsk->transport;
 
-	if (transport && transport->set_rcvlowat)
-		return transport->set_rcvlowat(vsk, val);
+	if (transport && transport->notify_set_rcvlowat) {
+		int err;
+
+		err = transport->notify_set_rcvlowat(vsk, val);
+		if (err)
+			return err;
+	}
 
 	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
 	return 0;
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 7cb1a9d2cdb4..e2157e387217 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -816,7 +816,7 @@ int hvs_notify_send_post_enqueue(struct vsock_sock *vsk, ssize_t written,
 }
 
 static
-int hvs_set_rcvlowat(struct vsock_sock *vsk, int val)
+int hvs_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
 {
 	return -EOPNOTSUPP;
 }
@@ -856,7 +856,7 @@ static struct vsock_transport hvs_transport = {
 	.notify_send_pre_enqueue  = hvs_notify_send_pre_enqueue,
 	.notify_send_post_enqueue = hvs_notify_send_post_enqueue,
 
-	.set_rcvlowat             = hvs_set_rcvlowat
+	.notify_set_rcvlowat      = hvs_notify_set_rcvlowat
 };
 
 static bool hvs_check_transport(struct vsock_sock *vsk)
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index af5bab1acee1..f495b9e5186b 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -537,6 +537,7 @@ static struct virtio_transport virtio_transport = {
 		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
+		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
 		.read_skb = virtio_transport_read_skb,
 	},
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index b35306dfcebe..16ff976a86e3 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1690,6 +1690,36 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
 }
 EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
 
+int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	bool send_update;
+
+	spin_lock_bh(&vvs->rx_lock);
+
+	/* If number of available bytes is less than new SO_RCVLOWAT value,
+	 * kick sender to send more data, because sender may sleep in its
+	 * 'send()' syscall waiting for enough space at our side. Also
+	 * don't send credit update when peer already knows actual value -
+	 * such transmission will be useless.
+	 */
+	send_update = (vvs->rx_bytes < val) &&
+		      (vvs->fwd_cnt != vvs->last_fwd_cnt);
+
+	spin_unlock_bh(&vvs->rx_lock);
+
+	if (send_update) {
+		int err;
+
+		err = virtio_transport_send_credit_update(vsk);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_notify_set_rcvlowat);
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Asias He");
 MODULE_DESCRIPTION("common code for virtio vsock");
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 048640167411..6dea6119f5b2 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -96,6 +96,7 @@ static struct virtio_transport loopback_transport = {
 		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
+		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
 		.read_skb = virtio_transport_read_skb,
 	},
-- 
2.43.0



