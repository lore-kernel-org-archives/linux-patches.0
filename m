Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8308E3AEF28;
	Thu, 17 Sep 2026 18:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670602; cv=none; b=N3wREAgc124vmM06KzfHRfHjXsg69TQTbfo/hAJzPC7cRzXRZo3F18JbLDLUJVGyW2tXjw8b833rnh39mUR5uk2rSFFUir7aQVwnrPEwh1yQ/jBmjkejlWqUscAoF3KI/zkVd3+BAxdYzm2z+yKDTRfXtb/NdDJ8MD2sy5Kcihs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670602; c=relaxed/simple;
	bh=Q0ToCUXcPbw0KQ1dgm4D/tJDvDplxfRKvLDzHnDvuW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnL0WlRw6aNlFm25pmKiW3FwwLS9zaqM8daZHfiMaV7ucVyu3O00DhCqaAYeHZqB5jxsRG+bY5klSEM9zsbX4uF+Onq00VlYYxXB23qhD/dEfhpURZX7Zu6EsTkj7Pf0iRJLzO+sePnrN+V90rY+PdxMB/sd8coRW4w7AlMHtsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvGFWKLK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvGFWKLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F321F000FF;
	Thu, 17 Sep 2026 18:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670601;
	bh=LEPSSzZEDv2fMQRzEXd8LDZP56GRXbdI60tSfNFH+ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tvGFWKLKRejir90dv2dDa3VmdEkHiLAafPFNPRZTDRLHzNhz34dRIjKR6rLFWcUe4
	 hqvjjrCy81qcvrTSTJzwCSXol9u5HaAbv7joYB7Wdbx9SEzpLwTca+dfsib72BiGHh
	 9E31LW6g2m7+6CRDRcOpBIWaH6NlNb5R+jUG3h5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0713/1102] vhost/vdpa: reject VRING_NUM larger than device max
Date: Thu, 17 Sep 2026 16:10:56 +0100
Message-ID: <20260917151558.232276542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit ccb1dc7c527f8c925925cf92afc76ae590dac311 ]

vhost_vring_set_num() accepts any non-zero power-of-two queue size that
fits in 16 bits. vhost-vdpa then passes that value to set_vq_num()
without comparing it with get_vq_num_max().

A process with access to /dev/vhost-vdpa-* can therefore configure a
queue larger than the device advertises. With vdpa_sim, the worker can
walk descriptors beyond the mapped descriptor ring. KASAN reports a
16-byte out-of-bounds read, corresponding to one vring_desc, in the
vringh IOTLB path:

  BUG: KASAN: out-of-bounds in _copy_from_iter
  Read of size 16
  copy_from_iotlb
  copydesc_iotlb
  vringh_getdesc_iotlb
  vdpasim_net_work

Cache get_vq_num_max() immediately after reset. Some backends derive
it from writable queue-size state, so querying it after SET_NUM may
return the current size instead of the device capability. Invalidate
the cached value before reset so a failed reset leaves SET_NUM
disabled.

For VHOST_SET_VRING_NUM, copy the complete vring state once and use
the same index and size for validation, vq->num, and set_vq_num().
This ensures that validation and use operate on the same copied values.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260810010300.132959-1-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index a47fdcb61bf36..6c084dd770a7f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -53,6 +53,7 @@ struct vhost_vdpa {
 	struct cdev cdev;
 	atomic_t opened;
 	u32 nvqs;
+	u16 vq_num_max;
 	int virtio_id;
 	int minor;
 	struct eventfd_ctx *config_ctx;
@@ -229,7 +230,9 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
 static int _compat_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
 	u32 flags = 0;
+	int ret;
 
 	v->suspended = false;
 
@@ -239,7 +242,14 @@ static int _compat_vdpa_reset(struct vhost_vdpa *v)
 			 VDPA_RESET_F_CLEAN_MAP : 0;
 	}
 
-	return vdpa_reset(vdpa, flags);
+	v->vq_num_max = 0;
+	ret = vdpa_reset(vdpa, flags);
+	if (!ret) {
+		/* Some backends derive the max from mutable queue state. */
+		v->vq_num_max = ops->get_vq_num_max(vdpa);
+	}
+
+	return ret;
 }
 
 static int vhost_vdpa_reset(struct vhost_vdpa *v)
@@ -641,9 +651,15 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	u32 idx;
 	long r;
 
-	r = get_user(idx, (u32 __user *)argp);
-	if (r < 0)
-		return r;
+	if (cmd == VHOST_SET_VRING_NUM) {
+		if (copy_from_user(&s, argp, sizeof(s)))
+			return -EFAULT;
+		idx = s.index;
+	} else {
+		r = get_user(idx, (u32 __user *)argp);
+		if (r < 0)
+			return r;
+	}
 
 	if (idx >= v->nvqs)
 		return -ENOBUFS;
@@ -652,6 +668,23 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	vq = &v->vqs[idx];
 
 	switch (cmd) {
+	case VHOST_SET_VRING_NUM:
+		mutex_lock(&vq->mutex);
+		if (vq->private_data) {
+			r = -EBUSY;
+		} else if (!s.num || s.num > 0xffff ||
+			   s.num > v->vq_num_max ||
+			   (s.num & (s.num - 1))) {
+			r = -EINVAL;
+		} else {
+			vq->num = s.num;
+			r = 0;
+		}
+		mutex_unlock(&vq->mutex);
+		if (r)
+			return r;
+		ops->set_vq_num(vdpa, idx, s.num);
+		return 0;
 	case VHOST_VDPA_SET_VRING_ENABLE:
 		if (copy_from_user(&s, argp, sizeof(s)))
 			return -EFAULT;
@@ -765,9 +798,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		ops->set_vq_cb(vdpa, idx, &cb);
 		break;
 
-	case VHOST_SET_VRING_NUM:
-		ops->set_vq_num(vdpa, idx, vq->num);
-		break;
 	}
 
 	return r;
-- 
2.53.0



