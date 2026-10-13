Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F894F054D;
	Tue, 13 Oct 2026 12:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894274; cv=none; b=YtRlltyU/zazh5rj9oCzahdEj6JbeRmkhPjRbTGsuYwZ7o1+/jjGKTjUQDGCxAoUY43SXjxO4UJlGcUqOgCrUTXV0sF2ZlNxPieWjp/isSPWLIQJhGacEZwfI99sAg8bWTxsBpL1n1bewoT9nNtajigO54XKD67SCO0sGTeCILg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894274; c=relaxed/simple;
	bh=dPmw6fpqB/yekyol6bGdRwvx93wv31pLqpDFyy18J6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEOR3DFkx7tdgajD3mC2dvnbI88636RLaTjnuA1oNKo6aVNydsGHSkKsfzaunFddGHCH3fwjd1tZKenIh56a218aevNJNGdAYv0xip8aPSUmrKDSKuIk4LyP68WI5WCO1HVnejl9896UzCZGkvgrBfE/H16vI8ta5lE7EU1eLiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/cX1m8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/cX1m8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EC71F000FF;
	Tue, 13 Oct 2026 12:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894273;
	bh=rxuM3LrErFDcQdr6FxUqwXioLTHFKEDB+A/VHk9w4yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/cX1m8eB0Ydmihy26tFZGnKxJil8CNUnlR0YOXDhtd7ZzYJbw80bn7tMy0Gi4Etq
	 cH+2e2xPzxEnhxETSOf/kJha1JidT9siD0JYcVXg3wx2wlU8dqGDDakLmRtW8JDNeR
	 Z6BTAUoD0wR+eC8ZRn9wV2fDGFQWxKkpy6xnIlEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jia Jia <physicalmtea@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 505/621] vhost: invalidate vring access on IOTLB transitions
Date: Tue, 13 Oct 2026 13:38:20 +0200
Message-ID: <20261013112932.811223488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit e4f4761879a230aa59e569102a6ab9851847d833 ]

When VIRTIO_F_ACCESS_PLATFORM changes, cached vring pointers and IOTLB
metadata are interpreted in a different address space. Keeping them
across the transition can leave stale ring mappings in use.

Clearing d->iotlb before taking the VQ locks also lets a worker observe
a transient NULL d->iotlb and fall back to d->umem while translating a
descriptor.

Add a common vhost_clear_device_iotlb() helper for vhost-net and
vhost-vsock. Take all VQ mutexes in index order before dropping the
device-wide IOTLB, invalidate each VQ's cached ring access and metadata,
clear pending IOTLB messages, and free the old table after the handoff.
This serializes the transition with workers and prevents mixed address
space mappings.

On the first direct-to-IOTLB transition, invalidate the cached vring
addresses. When an existing device IOTLB is replaced, preserve the
GIOVA ring addresses and reset only the metadata cache. After clearing
ACCESS_PLATFORM, userspace must configure the vring addresses for the
new address mode.

vhost_vq_invalidate_access() clears desc, avail, and used together.
Treat the VQ as invalidated only when all three are NULL, since a single
GIOVA address may legitimately be zero.

Fixes: 6b1e6cc7855b ("vhost: new device IOTLB API")
Fixes: e13a6915a03f ("vhost/vsock: add IOTLB API support")
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260828085721.57816-1-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/net.c   |  2 ++
 drivers/vhost/vhost.c | 57 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h |  1 +
 drivers/vhost/vsock.c |  2 ++
 4 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 72bd44f2f1428..19929e9b8b0a7 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1698,6 +1698,8 @@ static int vhost_net_set_features(struct vhost_net *n, const u64 *features)
 	if (virtio_features_test_bit(features, VIRTIO_F_ACCESS_PLATFORM)) {
 		if (vhost_init_device_iotlb(&n->dev))
 			goto out_unlock;
+	} else {
+		vhost_clear_device_iotlb(&n->dev);
 	}
 
 	for (i = 0; i < VHOST_NET_VQ_MAX; ++i) {
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index bad8a30eb979f..ebdbf1cf9143a 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -344,6 +344,17 @@ static void __vhost_vq_meta_reset(struct vhost_virtqueue *vq)
 		vq->meta_iotlb[j] = NULL;
 }
 
+/* Caller must hold the virtqueue mutex. */
+static void vhost_vq_invalidate_access(struct vhost_virtqueue *vq)
+{
+	vq->desc = NULL;
+	vq->avail = NULL;
+	vq->used = NULL;
+	vq->log_used = false;
+	vq->log_addr = -1ull;
+	__vhost_vq_meta_reset(vq);
+}
+
 static void vhost_vq_meta_reset(struct vhost_dev *d)
 {
 	int i;
@@ -1918,6 +1929,13 @@ int vq_meta_prefetch(struct vhost_virtqueue *vq)
 {
 	unsigned int num = vq->num;
 
+	/*
+	 * vhost_vq_invalidate_access() clears all three addresses together.
+	 * A single zero address may be a valid GIOVA in IOTLB mode.
+	 */
+	if (!vq->desc && !vq->avail && !vq->used)
+		return 0;
+
 	if (!vq->iotlb)
 		return 1;
 
@@ -2288,6 +2306,40 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 }
 EXPORT_SYMBOL_GPL(vhost_vring_ioctl);
 
+/* Caller must hold the device mutex. */
+void vhost_clear_device_iotlb(struct vhost_dev *d)
+{
+	struct vhost_iotlb *iotlb;
+	int i;
+
+	iotlb = d->iotlb;
+	if (!iotlb)
+		return;
+
+	vhost_dev_lock_vqs(d);
+
+	/*
+	 * vhost_dev_lock_vqs() takes all VQ mutexes in index order.  Drop the
+	 * device-wide view while they are held, then clear each per-VQ view
+	 * and its cached ring access before releasing the locks.  Workers
+	 * cannot observe a mixed address-space state during this handoff.
+	 */
+	d->iotlb = NULL;
+
+	for (i = 0; i < d->nvqs; ++i) {
+		struct vhost_virtqueue *vq = d->vqs[i];
+
+		vq->iotlb = NULL;
+		vhost_vq_invalidate_access(vq);
+	}
+
+	vhost_dev_unlock_vqs(d);
+	vhost_clear_msg(d);
+	vhost_iotlb_free(iotlb);
+	wake_up_interruptible_poll(&d->wait, EPOLLIN | EPOLLRDNORM);
+}
+EXPORT_SYMBOL_GPL(vhost_clear_device_iotlb);
+
 int vhost_init_device_iotlb(struct vhost_dev *d)
 {
 	struct vhost_iotlb *niotlb, *oiotlb;
@@ -2308,7 +2360,10 @@ int vhost_init_device_iotlb(struct vhost_dev *d)
 
 		mutex_lock(&vq->mutex);
 		vq->iotlb = niotlb;
-		__vhost_vq_meta_reset(vq);
+		if (oiotlb)
+			__vhost_vq_meta_reset(vq);
+		else
+			vhost_vq_invalidate_access(vq);
 		mutex_unlock(&vq->mutex);
 	}
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b49f08e4a1b4d..7ec10050a5087 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -276,6 +276,7 @@ ssize_t vhost_chr_read_iter(struct vhost_dev *dev, struct iov_iter *to,
 			    int noblock);
 ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 			     struct iov_iter *from);
+void vhost_clear_device_iotlb(struct vhost_dev *d);
 int vhost_init_device_iotlb(struct vhost_dev *d);
 
 void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 78cc66fbb3dd6..65297f245b272 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -819,6 +819,8 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
 	if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
 		if (vhost_init_device_iotlb(&vsock->dev))
 			goto err;
+	} else {
+		vhost_clear_device_iotlb(&vsock->dev);
 	}
 
 	vsock->seqpacket_allow = features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET);
-- 
2.53.0



