Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1282243964;
	Tue, 29 Apr 2025 18:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949802; cv=none; b=qPI72izv4pKpGn1pVjj8OJa3slkUKG7AUifnCU5AHnw7i8pdYNw56zeEdFYlNtQH1qUD7nqCsqsJEfdhcc6/IOWbsCp1AUCdym9wfnKyjaCjvuBVEwR4s0kI7J5MDqvo2E1dZzvnw4TiKWEie/+gkfatvwpSqdI7pnL0S+3TVdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949802; c=relaxed/simple;
	bh=OiC9x6u+kQ66iRJ1S8VBoJqUyF+QhTCnVsXf3l2nSK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxUBxIRC6gy1D0vuuWeOvJPahaa52Mxbl0pBl06RrPjc/a2a1j60Al842p+qANhnP3qoKqFjZ1pQAVuFtfDy8+85TXePEF7AUyiOMwORcs3csHXlEcrma/ORgupjEyGO0zb0O/07mDrgrChVO3OzziHHq0/S0M1fgmOxYIa4c/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQwSt23F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQwSt23F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D170C4CEE3;
	Tue, 29 Apr 2025 18:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949802;
	bh=OiC9x6u+kQ66iRJ1S8VBoJqUyF+QhTCnVsXf3l2nSK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQwSt23F6PT3t5spd76EI75ZphvRSXU7uShgsAKxQPbOaFIah9UhgdlUI0TcIz8Lx
	 hw/YYDus3LeT6U+HhHCaKqvvsaE7tbRJjUeVIQgoARuz+IA3Dn/Hkf8W7Kplir1LUx
	 fsLZw9TjzGqSHD1M00Gd42PlcbZAa+kMUT7/7/VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nico Boehr <nrb@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/167] s390/virtio: sort out physical vs virtual pointers usage
Date: Tue, 29 Apr 2025 18:42:20 +0200
Message-ID: <20250429161053.053723137@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 5fc5b94a273655128159186c87662105db8afeb5 ]

This does not fix a real bug, since virtual addresses
are currently indentical to physical ones.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Stable-dep-of: 2ccd42b959aa ("s390/virtio_ccw: Don't allocate/assign airqs for non-existing queues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/virtio/virtio_ccw.c | 46 +++++++++++++++++---------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index a10dbe632ef9b..954fc31b4bc74 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -363,7 +363,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 		thinint_area->isc = VIRTIO_AIRQ_ISC;
 		ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
 		ccw->count = sizeof(*thinint_area);
-		ccw->cda = (__u32)(unsigned long) thinint_area;
+		ccw->cda = (__u32)virt_to_phys(thinint_area);
 	} else {
 		/* payload is the address of the indicators */
 		indicatorp = ccw_device_dma_zalloc(vcdev->cdev,
@@ -373,7 +373,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 		*indicatorp = 0;
 		ccw->cmd_code = CCW_CMD_SET_IND;
 		ccw->count = sizeof(indicators(vcdev));
-		ccw->cda = (__u32)(unsigned long) indicatorp;
+		ccw->cda = (__u32)virt_to_phys(indicatorp);
 	}
 	/* Deregister indicators from host. */
 	*indicators(vcdev) = 0;
@@ -417,7 +417,7 @@ static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
 	ccw->cmd_code = CCW_CMD_READ_VQ_CONF;
 	ccw->flags = 0;
 	ccw->count = sizeof(struct vq_config_block);
-	ccw->cda = (__u32)(unsigned long)(&vcdev->dma_area->config_block);
+	ccw->cda = (__u32)virt_to_phys(&vcdev->dma_area->config_block);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_VQ_CONF);
 	if (ret)
 		return ret;
@@ -454,7 +454,7 @@ static void virtio_ccw_del_vq(struct virtqueue *vq, struct ccw1 *ccw)
 	}
 	ccw->cmd_code = CCW_CMD_SET_VQ;
 	ccw->flags = 0;
-	ccw->cda = (__u32)(unsigned long)(info->info_block);
+	ccw->cda = (__u32)virt_to_phys(info->info_block);
 	ret = ccw_io_helper(vcdev, ccw,
 			    VIRTIO_CCW_DOING_SET_VQ | index);
 	/*
@@ -556,7 +556,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	}
 	ccw->cmd_code = CCW_CMD_SET_VQ;
 	ccw->flags = 0;
-	ccw->cda = (__u32)(unsigned long)(info->info_block);
+	ccw->cda = (__u32)virt_to_phys(info->info_block);
 	err = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_VQ | i);
 	if (err) {
 		dev_warn(&vcdev->cdev->dev, "SET_VQ failed\n");
@@ -590,6 +590,7 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
 {
 	int ret;
 	struct virtio_thinint_area *thinint_area = NULL;
+	unsigned long indicator_addr;
 	struct airq_info *info;
 
 	thinint_area = ccw_device_dma_zalloc(vcdev->cdev,
@@ -599,21 +600,22 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
 		goto out;
 	}
 	/* Try to get an indicator. */
-	thinint_area->indicator = get_airq_indicator(vqs, nvqs,
-						     &thinint_area->bit_nr,
-						     &vcdev->airq_info);
-	if (!thinint_area->indicator) {
+	indicator_addr = get_airq_indicator(vqs, nvqs,
+					    &thinint_area->bit_nr,
+					    &vcdev->airq_info);
+	if (!indicator_addr) {
 		ret = -ENOSPC;
 		goto out;
 	}
+	thinint_area->indicator = virt_to_phys((void *)indicator_addr);
 	info = vcdev->airq_info;
 	thinint_area->summary_indicator =
-		(unsigned long) get_summary_indicator(info);
+		virt_to_phys(get_summary_indicator(info));
 	thinint_area->isc = VIRTIO_AIRQ_ISC;
 	ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
 	ccw->flags = CCW_FLAG_SLI;
 	ccw->count = sizeof(*thinint_area);
-	ccw->cda = (__u32)(unsigned long)thinint_area;
+	ccw->cda = (__u32)virt_to_phys(thinint_area);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_IND_ADAPTER);
 	if (ret) {
 		if (ret == -EOPNOTSUPP) {
@@ -686,7 +688,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		ccw->cmd_code = CCW_CMD_SET_IND;
 		ccw->flags = 0;
 		ccw->count = sizeof(indicators(vcdev));
-		ccw->cda = (__u32)(unsigned long) indicatorp;
+		ccw->cda = (__u32)virt_to_phys(indicatorp);
 		ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_IND);
 		if (ret)
 			goto out;
@@ -697,7 +699,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	ccw->cmd_code = CCW_CMD_SET_CONF_IND;
 	ccw->flags = 0;
 	ccw->count = sizeof(indicators2(vcdev));
-	ccw->cda = (__u32)(unsigned long) indicatorp;
+	ccw->cda = (__u32)virt_to_phys(indicatorp);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_CONF_IND);
 	if (ret)
 		goto out;
@@ -759,7 +761,7 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_READ_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)(unsigned long)features;
+	ccw->cda = (__u32)virt_to_phys(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_FEAT);
 	if (ret) {
 		rc = 0;
@@ -776,7 +778,7 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_READ_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)(unsigned long)features;
+	ccw->cda = (__u32)virt_to_phys(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_FEAT);
 	if (ret == 0)
 		rc |= (u64)le32_to_cpu(features->features) << 32;
@@ -829,7 +831,7 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)(unsigned long)features;
+	ccw->cda = (__u32)virt_to_phys(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
 	if (ret)
 		goto out_free;
@@ -843,7 +845,7 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)(unsigned long)features;
+	ccw->cda = (__u32)virt_to_phys(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
 
 out_free:
@@ -875,7 +877,7 @@ static void virtio_ccw_get_config(struct virtio_device *vdev,
 	ccw->cmd_code = CCW_CMD_READ_CONF;
 	ccw->flags = 0;
 	ccw->count = offset + len;
-	ccw->cda = (__u32)(unsigned long)config_area;
+	ccw->cda = (__u32)virt_to_phys(config_area);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_CONFIG);
 	if (ret)
 		goto out_free;
@@ -922,7 +924,7 @@ static void virtio_ccw_set_config(struct virtio_device *vdev,
 	ccw->cmd_code = CCW_CMD_WRITE_CONF;
 	ccw->flags = 0;
 	ccw->count = offset + len;
-	ccw->cda = (__u32)(unsigned long)config_area;
+	ccw->cda = (__u32)virt_to_phys(config_area);
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_CONFIG);
 
 out_free:
@@ -946,7 +948,7 @@ static u8 virtio_ccw_get_status(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_READ_STATUS;
 	ccw->flags = 0;
 	ccw->count = sizeof(vcdev->dma_area->status);
-	ccw->cda = (__u32)(unsigned long)&vcdev->dma_area->status;
+	ccw->cda = (__u32)virt_to_phys(&vcdev->dma_area->status);
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_STATUS);
 /*
  * If the channel program failed (should only happen if the device
@@ -975,7 +977,7 @@ static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
 	ccw->cmd_code = CCW_CMD_WRITE_STATUS;
 	ccw->flags = 0;
 	ccw->count = sizeof(status);
-	ccw->cda = (__u32)(unsigned long)&vcdev->dma_area->status;
+	ccw->cda = (__u32)virt_to_phys(&vcdev->dma_area->status);
 	/* We use ssch for setting the status which is a serializing
 	 * instruction that guarantees the memory writes have
 	 * completed before ssch.
@@ -1274,7 +1276,7 @@ static int virtio_ccw_set_transport_rev(struct virtio_ccw_device *vcdev)
 	ccw->cmd_code = CCW_CMD_SET_VIRTIO_REV;
 	ccw->flags = 0;
 	ccw->count = sizeof(*rev);
-	ccw->cda = (__u32)(unsigned long)rev;
+	ccw->cda = (__u32)virt_to_phys(rev);
 
 	vcdev->revision = VIRTIO_CCW_REV_MAX;
 	do {
-- 
2.39.5



