Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2A724633C;
	Tue, 29 Apr 2025 18:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950342; cv=none; b=VqsuCDolVBwABl9JBNCanAJ2UzxZ2h9hxN5hBkeRX3daNR7Y9SP5XBNXZcAhuuPYOh4NO0UhWbI4eDdIiZLywKpZ5IxgHyuBMEfl55+bFuL6cNC1lLPZ4aPUqtycHoMs/3g6v+y/pHUjvzy4Y4Y9nCmy0KpdS/aY4WX0sPEDmsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950342; c=relaxed/simple;
	bh=5N7jTA7K+V08WKXUzWX2zxlxq07hfK0+47cJmFrYDWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjC9LH/3TOOfwFvuu952fl168qHMy2eUfLmBxYi2ANVmvgl4mLbGs5Z7dUvhg+WazGv1sLYYrJs0tGBXeqejLt0TN+xYXebl4hKNEh7e9HThoQKKPpLyKxTjXTR2E9eSCfyfVLKElko2zo4xmru6QQG7MRoobgNtO6a6Xg8r4Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlrGVn6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlrGVn6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4D5C4CEE3;
	Tue, 29 Apr 2025 18:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950342;
	bh=5N7jTA7K+V08WKXUzWX2zxlxq07hfK0+47cJmFrYDWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlrGVn6uYlJsXUh4SgaBSq1lvKhd1/RxwElY+t5IsAGOSdPfY2YKXRC2A/nb79Rxw
	 Q/xOQ/wgV79szW5O7U7AL+Dkz8+9apcwND8/0TAUkEJUjSzPxQ8ZrEMVANhX04Ii7I
	 PBxfmrj4qvRkwTrpRWFSrou6/4FqOau2yjG4O4BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/204] s390/virtio_ccw: fix virtual vs physical address confusion
Date: Tue, 29 Apr 2025 18:42:04 +0200
Message-ID: <20250429161100.888821575@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit d5cc41686990fa522ce573e5c6c7a619f10c3fd1 ]

Fix virtual vs physical address confusion and use new dma types and helper
functions to allow for type checking. This does not fix a bug since virtual
and physical address spaces are currently the same.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 2ccd42b959aa ("s390/virtio_ccw: Don't allocate/assign airqs for non-existing queues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/virtio/virtio_ccw.c | 78 ++++++++++++++++----------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index ac67576301bf5..ac77951c30c46 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -85,19 +85,19 @@ static inline unsigned long *indicators2(struct virtio_ccw_device *vcdev)
 }
 
 struct vq_info_block_legacy {
-	__u64 queue;
+	dma64_t queue;
 	__u32 align;
 	__u16 index;
 	__u16 num;
 } __packed;
 
 struct vq_info_block {
-	__u64 desc;
+	dma64_t desc;
 	__u32 res0;
 	__u16 index;
 	__u16 num;
-	__u64 avail;
-	__u64 used;
+	dma64_t avail;
+	dma64_t used;
 } __packed;
 
 struct virtio_feature_desc {
@@ -106,8 +106,8 @@ struct virtio_feature_desc {
 } __packed;
 
 struct virtio_thinint_area {
-	unsigned long summary_indicator;
-	unsigned long indicator;
+	dma64_t summary_indicator;
+	dma64_t indicator;
 	u64 bit_nr;
 	u8 isc;
 } __packed;
@@ -260,12 +260,12 @@ static struct airq_info *new_airq_info(int index)
 	return info;
 }
 
-static unsigned long get_airq_indicator(struct virtqueue *vqs[], int nvqs,
-					u64 *first, void **airq_info)
+static unsigned long *get_airq_indicator(struct virtqueue *vqs[], int nvqs,
+					 u64 *first, void **airq_info)
 {
 	int i, j;
 	struct airq_info *info;
-	unsigned long indicator_addr = 0;
+	unsigned long *indicator_addr = NULL;
 	unsigned long bit, flags;
 
 	for (i = 0; i < MAX_AIRQ_AREAS && !indicator_addr; i++) {
@@ -275,7 +275,7 @@ static unsigned long get_airq_indicator(struct virtqueue *vqs[], int nvqs,
 		info = airq_areas[i];
 		mutex_unlock(&airq_areas_lock);
 		if (!info)
-			return 0;
+			return NULL;
 		write_lock_irqsave(&info->lock, flags);
 		bit = airq_iv_alloc(info->aiv, nvqs);
 		if (bit == -1UL) {
@@ -285,7 +285,7 @@ static unsigned long get_airq_indicator(struct virtqueue *vqs[], int nvqs,
 		}
 		*first = bit;
 		*airq_info = info;
-		indicator_addr = (unsigned long)info->aiv->vector;
+		indicator_addr = info->aiv->vector;
 		for (j = 0; j < nvqs; j++) {
 			airq_iv_set_ptr(info->aiv, bit + j,
 					(unsigned long)vqs[j]);
@@ -358,11 +358,11 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 		if (!thinint_area)
 			return;
 		thinint_area->summary_indicator =
-			(unsigned long) get_summary_indicator(airq_info);
+			virt_to_dma64(get_summary_indicator(airq_info));
 		thinint_area->isc = VIRTIO_AIRQ_ISC;
 		ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
 		ccw->count = sizeof(*thinint_area);
-		ccw->cda = (__u32)virt_to_phys(thinint_area);
+		ccw->cda = virt_to_dma32(thinint_area);
 	} else {
 		/* payload is the address of the indicators */
 		indicatorp = ccw_device_dma_zalloc(vcdev->cdev,
@@ -372,7 +372,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 		*indicatorp = 0;
 		ccw->cmd_code = CCW_CMD_SET_IND;
 		ccw->count = sizeof(indicators(vcdev));
-		ccw->cda = (__u32)virt_to_phys(indicatorp);
+		ccw->cda = virt_to_dma32(indicatorp);
 	}
 	/* Deregister indicators from host. */
 	*indicators(vcdev) = 0;
@@ -426,7 +426,7 @@ static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
 	ccw->cmd_code = CCW_CMD_READ_VQ_CONF;
 	ccw->flags = 0;
 	ccw->count = sizeof(struct vq_config_block);
-	ccw->cda = (__u32)virt_to_phys(&vcdev->dma_area->config_block);
+	ccw->cda = virt_to_dma32(&vcdev->dma_area->config_block);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_VQ_CONF);
 	if (ret)
 		return ret;
@@ -463,7 +463,7 @@ static void virtio_ccw_del_vq(struct virtqueue *vq, struct ccw1 *ccw)
 	}
 	ccw->cmd_code = CCW_CMD_SET_VQ;
 	ccw->flags = 0;
-	ccw->cda = (__u32)virt_to_phys(info->info_block);
+	ccw->cda = virt_to_dma32(info->info_block);
 	ret = ccw_io_helper(vcdev, ccw,
 			    VIRTIO_CCW_DOING_SET_VQ | index);
 	/*
@@ -556,22 +556,22 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	/* Register it with the host. */
 	queue = virtqueue_get_desc_addr(vq);
 	if (vcdev->revision == 0) {
-		info->info_block->l.queue = queue;
+		info->info_block->l.queue = u64_to_dma64(queue);
 		info->info_block->l.align = KVM_VIRTIO_CCW_RING_ALIGN;
 		info->info_block->l.index = i;
 		info->info_block->l.num = info->num;
 		ccw->count = sizeof(info->info_block->l);
 	} else {
-		info->info_block->s.desc = queue;
+		info->info_block->s.desc = u64_to_dma64(queue);
 		info->info_block->s.index = i;
 		info->info_block->s.num = info->num;
-		info->info_block->s.avail = (__u64)virtqueue_get_avail_addr(vq);
-		info->info_block->s.used = (__u64)virtqueue_get_used_addr(vq);
+		info->info_block->s.avail = u64_to_dma64(virtqueue_get_avail_addr(vq));
+		info->info_block->s.used = u64_to_dma64(virtqueue_get_used_addr(vq));
 		ccw->count = sizeof(info->info_block->s);
 	}
 	ccw->cmd_code = CCW_CMD_SET_VQ;
 	ccw->flags = 0;
-	ccw->cda = (__u32)virt_to_phys(info->info_block);
+	ccw->cda = virt_to_dma32(info->info_block);
 	err = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_VQ | i);
 	if (err) {
 		dev_warn(&vcdev->cdev->dev, "SET_VQ failed\n");
@@ -605,7 +605,7 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
 {
 	int ret;
 	struct virtio_thinint_area *thinint_area = NULL;
-	unsigned long indicator_addr;
+	unsigned long *indicator_addr;
 	struct airq_info *info;
 
 	thinint_area = ccw_device_dma_zalloc(vcdev->cdev,
@@ -622,15 +622,15 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
 		ret = -ENOSPC;
 		goto out;
 	}
-	thinint_area->indicator = virt_to_phys((void *)indicator_addr);
+	thinint_area->indicator = virt_to_dma64(indicator_addr);
 	info = vcdev->airq_info;
 	thinint_area->summary_indicator =
-		virt_to_phys(get_summary_indicator(info));
+		virt_to_dma64(get_summary_indicator(info));
 	thinint_area->isc = VIRTIO_AIRQ_ISC;
 	ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
 	ccw->flags = CCW_FLAG_SLI;
 	ccw->count = sizeof(*thinint_area);
-	ccw->cda = (__u32)virt_to_phys(thinint_area);
+	ccw->cda = virt_to_dma32(thinint_area);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_IND_ADAPTER);
 	if (ret) {
 		if (ret == -EOPNOTSUPP) {
@@ -658,7 +658,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			       struct irq_affinity *desc)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
-	unsigned long *indicatorp = NULL;
+	dma64_t *indicatorp = NULL;
 	int ret, i, queue_idx = 0;
 	struct ccw1 *ccw;
 
@@ -690,7 +690,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 					   sizeof(indicators(vcdev)));
 	if (!indicatorp)
 		goto out;
-	*indicatorp = (unsigned long) indicators(vcdev);
+	*indicatorp = virt_to_dma64(indicators(vcdev));
 	if (vcdev->is_thinint) {
 		ret = virtio_ccw_register_adapter_ind(vcdev, vqs, nvqs, ccw);
 		if (ret)
@@ -703,18 +703,18 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		ccw->cmd_code = CCW_CMD_SET_IND;
 		ccw->flags = 0;
 		ccw->count = sizeof(indicators(vcdev));
-		ccw->cda = (__u32)virt_to_phys(indicatorp);
+		ccw->cda = virt_to_dma32(indicatorp);
 		ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_IND);
 		if (ret)
 			goto out;
 	}
 	/* Register indicators2 with host for config changes */
-	*indicatorp = (unsigned long) indicators2(vcdev);
+	*indicatorp = virt_to_dma64(indicators2(vcdev));
 	*indicators2(vcdev) = 0;
 	ccw->cmd_code = CCW_CMD_SET_CONF_IND;
 	ccw->flags = 0;
 	ccw->count = sizeof(indicators2(vcdev));
-	ccw->cda = (__u32)virt_to_phys(indicatorp);
+	ccw->cda = virt_to_dma32(indicatorp);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_CONF_IND);
 	if (ret)
 		goto out;
@@ -776,7 +776,7 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_READ_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)virt_to_phys(features);
+	ccw->cda = virt_to_dma32(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_FEAT);
 	if (ret) {
 		rc = 0;
@@ -793,7 +793,7 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_READ_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)virt_to_phys(features);
+	ccw->cda = virt_to_dma32(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_FEAT);
 	if (ret == 0)
 		rc |= (u64)le32_to_cpu(features->features) << 32;
@@ -846,7 +846,7 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)virt_to_phys(features);
+	ccw->cda = virt_to_dma32(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
 	if (ret)
 		goto out_free;
@@ -860,7 +860,7 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)virt_to_phys(features);
+	ccw->cda = virt_to_dma32(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
 
 out_free:
@@ -892,7 +892,7 @@ static void virtio_ccw_get_config(struct virtio_device *vdev,
 	ccw->cmd_code = CCW_CMD_READ_CONF;
 	ccw->flags = 0;
 	ccw->count = offset + len;
-	ccw->cda = (__u32)virt_to_phys(config_area);
+	ccw->cda = virt_to_dma32(config_area);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_CONFIG);
 	if (ret)
 		goto out_free;
@@ -939,7 +939,7 @@ static void virtio_ccw_set_config(struct virtio_device *vdev,
 	ccw->cmd_code = CCW_CMD_WRITE_CONF;
 	ccw->flags = 0;
 	ccw->count = offset + len;
-	ccw->cda = (__u32)virt_to_phys(config_area);
+	ccw->cda = virt_to_dma32(config_area);
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_CONFIG);
 
 out_free:
@@ -963,7 +963,7 @@ static u8 virtio_ccw_get_status(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_READ_STATUS;
 	ccw->flags = 0;
 	ccw->count = sizeof(vcdev->dma_area->status);
-	ccw->cda = (__u32)virt_to_phys(&vcdev->dma_area->status);
+	ccw->cda = virt_to_dma32(&vcdev->dma_area->status);
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_STATUS);
 /*
  * If the channel program failed (should only happen if the device
@@ -992,11 +992,11 @@ static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
 	ccw->cmd_code = CCW_CMD_WRITE_STATUS;
 	ccw->flags = 0;
 	ccw->count = sizeof(status);
-	ccw->cda = (__u32)virt_to_phys(&vcdev->dma_area->status);
 	/* We use ssch for setting the status which is a serializing
 	 * instruction that guarantees the memory writes have
 	 * completed before ssch.
 	 */
+	ccw->cda = virt_to_dma32(&vcdev->dma_area->status);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_STATUS);
 	/* Write failed? We assume status is unchanged. */
 	if (ret)
@@ -1291,7 +1291,7 @@ static int virtio_ccw_set_transport_rev(struct virtio_ccw_device *vcdev)
 	ccw->cmd_code = CCW_CMD_SET_VIRTIO_REV;
 	ccw->flags = 0;
 	ccw->count = sizeof(*rev);
-	ccw->cda = (__u32)virt_to_phys(rev);
+	ccw->cda = virt_to_dma32(rev);
 
 	vcdev->revision = VIRTIO_CCW_REV_MAX;
 	do {
-- 
2.39.5



