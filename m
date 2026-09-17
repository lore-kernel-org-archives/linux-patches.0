Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF994519930;
	Thu, 17 Sep 2026 15:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659709; cv=none; b=j2tfEA60/Kp5M9DCOCTHW75/zNccMdRl7Z2H5ue0W7H3wqiZ731O9MuKMgyCuN7QZ8Ed7iHHw6nG37gC/bwJLoHsrmgKOXiltgxP4BT/hJ91b6xYLSWwskpE7wDlRSTuO3zsYCc5r5NCub/3YigFAeXywyY2Vu5qEsSwDYTt6Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659709; c=relaxed/simple;
	bh=w0kmaHuHVYCXwJPp+pfE/0OK1CL3HEy9vpX/atbvfPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erV+FeyuvmqDYio0+WRzFy3r9ya55iUQgHRZm2UxBtRCXXw3qD+4umriyKNvAVsGmLGzc8l+3gVq6IaH7Lds0bqVsJkiKvL3OE6YYeQgfTLNY83YH3sEr0tf5Gl6e+FpWagx1Hc+6Iy+ROlANMPsiH2ESJ3H3qqqMpCKIiEwTvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdayvpuT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdayvpuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5111F00893;
	Thu, 17 Sep 2026 15:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659696;
	bh=qcNU+UgivGt3FyszzUvYJcGophi+R2lZtbHrjOzVMpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sdayvpuTt/+VjKS74zRZjtZOk6NrCK7blsjtL4DOcSX6KwN75td+WIIsh7HDlSTOm
	 j7ZV/52T3O8IXUtj3FlogJLWc3UM1apZUAxteV4CCND1qOYzkaRwdvIrY38YyttJof
	 JqnWoPjunONizsiMpnHxy7iCIRJKd+kurhPytxxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 344/733] vhost/vdpa: reject VRING_NUM larger than device max
Date: Thu, 17 Sep 2026 16:10:52 +0100
Message-ID: <20260917151400.130685285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index c3d913bd7cac7..4eb1eb5e5c79d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -58,6 +58,7 @@ struct vhost_vdpa {
 	struct cdev cdev;
 	atomic_t opened;
 	u32 nvqs;
+	u16 vq_num_max;
 	int virtio_id;
 	int minor;
 	struct eventfd_ctx *config_ctx;
@@ -236,7 +237,9 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
 static int _compat_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
 	u32 flags = 0;
+	int ret;
 
 	v->suspended = false;
 
@@ -246,7 +249,14 @@ static int _compat_vdpa_reset(struct vhost_vdpa *v)
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
@@ -648,9 +658,15 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
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
@@ -659,6 +675,23 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
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
@@ -772,9 +805,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		ops->set_vq_cb(vdpa, idx, &cb);
 		break;
 
-	case VHOST_SET_VRING_NUM:
-		ops->set_vq_num(vdpa, idx, vq->num);
-		break;
 	}
 
 	return r;
-- 
2.53.0



