Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215595;
	b=GjNfAyZSJ+ucmyhiEuafg4SDPc2mNr6tbMN2F1cZx61sZqakgzsbr9YFruDj0z9BtPTQ
	 E6sS9UuJ8/TpEF+G+AmClkqlyMRwlj3Ocqh/JOuTlw6VtBj9WPQj7IuhGJm8Cf0jTryKr
	 JejhKrn1Ww4LGU+1s6zPUqenp7RxVCyJabb/ns7O42dbw9J9eubI+JD5QdOuzmQf2mwoT
	 /6693AdQp89YyTTofrfJh5bb7DPKqSJukQEWEu66tZvuviB0wL94z1zh9Rocll6yvD40B
	 KYxfIXSJttyNSPkWLug84yQEoqpf7SuLEEO2HBF6G3XeFCipoYxytXIy3W4OuIeYpKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vJb8Rp+s3C+Yp6qS16Q7lwMI64mprFdEWAQus/Ho/zY=;
	b=gAy8opg4HiISLJhJXxdaP4PHVhmYbCTjZPyx23A7JyqrqezOHxOWv7NUYNQKdMD3/bE8
	 sxZInmemvjMmypN+qkdnlLIqYeeMiYzz3h6NAjwvCiCUS5kqG4gDnUt0AGIMI+egYCOwm
	 1s0EK1eopS8SiSm0Im6h5bxfboRbwyzZJsh+XBxsWRFdp/LsFfPIFBuZwo+XdXW0SEfSz
	 5fRF8oLbxhHcW76921sGDaYjeMtx86ILv/HCnjz9VUfF0GsNLl+RBVFpG6VGfeGYgFGz4
	 OCXMZOVnc3WmNC9Witn23JKcwTrUZlABVOLOuflPIYjHqREfyWygWEHRGuNBr/oFyYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fwgqBSF0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185CB606A332;
	Wed, 28 Oct 2026 19:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fwgqBSF0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CE11F01828;
	Wed, 28 Oct 2026 19:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215595;
	bh=vJb8Rp+s3C+Yp6qS16Q7lwMI64mprFdEWAQus/Ho/zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fwgqBSF0nW9ySLdFUIWUt1/Adal06zsNY9J604tEsEYSV45YDQL9QAGBas04g4Kvz
	 pXBizpAduFxK+CUVNLtZcWElg5FugrlpqhIDeDmwbK8PSF4hCfnT0uOnOphRMMK4aW
	 MsLPMyTfWnfanF4kONSsCoYTbC51y30tjjrYQO+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gavin Shan <gshan@redhat.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1264/1887] vhost: move smp_rmb() into vhost_get_avail_idx()
Date: Wed, 28 Oct 2026 17:56:00 +0100
Message-ID: <20261028170528.188465832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 7ad4723976672b7d359403a555e0ce5c75529153 ]

All callers of vhost_get_avail_idx() use smp_rmb() to
order the available ring entry read and avail_idx read.

Make vhost_get_avail_idx() call smp_rmb() itself whenever the avail_idx
is accessed. This way, the callers don't need to worry about the memory
barrier. As a side benefit, we also validate the index on all paths now,
which will hopefully help prevent/catch earlier future bugs.

Note that current code is inconsistent in how the errors are handled.
They are treated as an empty ring in some places, but as non-empty
ring in other places. This patch doesn't attempt to change the existing
behaviour.

No functional change intended.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: Will Deacon <will@kernel.org>
Message-Id: <20240429232748.642356-1-gshan@redhat.com>
Stable-dep-of: 09861858a683 ("vhost: fix vhost_get_avail_idx for a non empty ring")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 105 +++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 63 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 30d5969d9f547..5958bca8e2720 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1008,10 +1008,36 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
 		mutex_unlock(&d->vqs[i]->mutex);
 }
 
-static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq,
-				      __virtio16 *idx)
+static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
 {
-	return vhost_get_avail(vq, *idx, &vq->avail->idx);
+	__virtio16 idx;
+	int r;
+
+	r = vhost_get_avail(vq, idx, &vq->avail->idx);
+	if (unlikely(r < 0)) {
+		vq_err(vq, "Failed to access available index at %p (%d)\n",
+		       &vq->avail->idx, r);
+		return r;
+	}
+
+	/* Check it isn't doing very strange thing with available indexes */
+	vq->avail_idx = vhost16_to_cpu(vq, idx);
+	if (unlikely((u16)(vq->avail_idx - vq->last_avail_idx) > vq->num)) {
+		vq_err(vq, "Invalid available index change from %u to %u",
+		       vq->last_avail_idx, vq->avail_idx);
+		return -EINVAL;
+	}
+
+	/* We're done if there is nothing new */
+	if (vq->avail_idx == vq->last_avail_idx)
+		return 0;
+
+	/*
+	 * We updated vq->avail_idx so we need a memory barrier between
+	 * the index read above and the caller reading avail ring entries.
+	 */
+	smp_rmb();
+	return 1;
 }
 
 static inline int vhost_get_avail_head(struct vhost_virtqueue *vq,
@@ -2230,38 +2256,17 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 {
 	struct vring_desc desc;
 	unsigned int i, head, found = 0;
-	u16 last_avail_idx;
-	__virtio16 avail_idx;
+	u16 last_avail_idx = vq->last_avail_idx;
 	__virtio16 ring_head;
 	int ret, access;
 
-	/* Check it isn't doing very strange things with descriptor numbers. */
-	last_avail_idx = vq->last_avail_idx;
-
 	if (vq->avail_idx == vq->last_avail_idx) {
-		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
-			vq_err(vq, "Failed to access avail idx at %p\n",
-				&vq->avail->idx);
-			return -EFAULT;
-		}
-		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
-
-		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
-			vq_err(vq, "Guest moved avail index from %u to %u",
-				last_avail_idx, vq->avail_idx);
-			return -EFAULT;
-		}
+		ret = vhost_get_avail_idx(vq);
+		if (unlikely(ret < 0))
+			return ret;
 
-		/* If there's nothing new since last we looked, return
-		 * invalid.
-		 */
-		if (vq->avail_idx == last_avail_idx)
+		if (!ret)
 			return vq->num;
-
-		/* Only get avail ring entries after they have been
-		 * exposed by guest.
-		 */
-		smp_rmb();
 	}
 
 	/* Grab the next descriptor number they're advertising, and increment
@@ -2525,35 +2530,21 @@ EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
 /* return true if we're sure that avaiable ring is empty */
 bool vhost_vq_avail_empty(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
-	__virtio16 avail_idx;
 	int r;
 
 	if (vq->avail_idx != vq->last_avail_idx)
 		return false;
 
-	r = vhost_get_avail_idx(vq, &avail_idx);
-	if (unlikely(r))
-		return false;
-
-	vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
-	if (vq->avail_idx != vq->last_avail_idx) {
-		/* Since we have updated avail_idx, the following
-		 * call to vhost_get_vq_desc() will read available
-		 * ring entries. Make sure that read happens after
-		 * the avail_idx read.
-		 */
-		smp_rmb();
-		return false;
-	}
+	r = vhost_get_avail_idx(vq);
 
-	return true;
+	/* Note: we treat error as non-empty here */
+	return r == 0;
 }
 EXPORT_SYMBOL_GPL(vhost_vq_avail_empty);
 
 /* OK, now we need to know about added descriptors. */
 bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
-	__virtio16 avail_idx;
 	int r;
 
 	if (!(vq->used_flags & VRING_USED_F_NO_NOTIFY))
@@ -2577,25 +2568,13 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 	/* They could have slipped one in as we were doing that: make
 	 * sure it's written, then check again. */
 	smp_mb();
-	r = vhost_get_avail_idx(vq, &avail_idx);
-	if (r) {
-		vq_err(vq, "Failed to check avail idx at %p: %d\n",
-		       &vq->avail->idx, r);
-		return false;
-	}
 
-	vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
-	if (vq->avail_idx != vq->last_avail_idx) {
-		/* Since we have updated avail_idx, the following
-		 * call to vhost_get_vq_desc() will read available
-		 * ring entries. Make sure that read happens after
-		 * the avail_idx read.
-		 */
-		smp_rmb();
-		return true;
-	}
+	r = vhost_get_avail_idx(vq);
+	/* Note: we treat error as empty here */
+	if (unlikely(r < 0))
+		return false;
 
-	return false;
+	return r;
 }
 EXPORT_SYMBOL_GPL(vhost_enable_notify);
 
-- 
2.53.0



