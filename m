Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF113D9531;
	Wed, 30 Sep 2026 19:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795346; cv=none; b=bLGhiZ2KBy6TO3blg5OHHHlhTRd64Y74+Fx/XS0/BWSbd2N+AaR8qj55J2OYC9XgMU8twTEwi6IjWtaLuJ6IM+69XrEhpxW945bG3iNsPTIHWnwj/bsC6avc2iJL46hwTjnasOZxZI4PTPxisbSRMfJu4IoirSZ6mMxTZ3RsDAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795346; c=relaxed/simple;
	bh=1Sf9UWrhcCMe4N4NTx3lyDIQ+DF7qct5jWc8FAaFwCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erbWXd66F5z7+F875M90Aav+JrR55Rbqcm5o/C6ddafnH6lBwS93GZm1mOy++ZFiizjGfhxloyYX7YCjbWhMvV6++YRQ7N9MFJ9I1MpWvhtow5mhLvN3P75U0WVUjaW7B8cEDQDMQ0GAfXHDX29gdzyYeaRPHVU4f+aOuqlzo5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLPevY6T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLPevY6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197A31F000FF;
	Wed, 30 Sep 2026 19:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795344;
	bh=davvcgcip31UI0GTtkzAiYzb8TbnzGlbNZQwv4bn1ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLPevY6TtYhLeHtV5shqoKPP+eL1+NuC6lnG1DtIxMS3LxQlF3EEa5m+gNBgJipPU
	 5P5ujeKPqXTTHKHMqy1Soj/eHrZf2DfvqXMXZucYKL//CJBi9jfKHS1dDmdZ8q8vHM
	 Uy8bYhuE/j11L7RZ0QcAa8lOn2+0iWL+10AKBJ2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0530/1193] vhost/vdpa: reject VRING_NUM larger than device max
Date: Wed, 30 Sep 2026 17:20:14 +0200
Message-ID: <20260930152445.977295810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 61ba04a6b707c..a85e79ddf082c 100644
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
@@ -211,7 +212,9 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
 static int _compat_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
 	u32 flags = 0;
+	int ret;
 
 	if (v->vdev.vqs) {
 		flags |= !vhost_backend_has_feature(v->vdev.vqs[0],
@@ -219,7 +222,14 @@ static int _compat_vdpa_reset(struct vhost_vdpa *v)
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
@@ -605,9 +615,15 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
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
@@ -616,6 +632,23 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
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
@@ -705,9 +738,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		ops->set_vq_cb(vdpa, idx, &cb);
 		break;
 
-	case VHOST_SET_VRING_NUM:
-		ops->set_vq_num(vdpa, idx, vq->num);
-		break;
 	}
 
 	return r;
-- 
2.53.0



