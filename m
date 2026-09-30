Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874B3535FD8;
	Wed, 30 Sep 2026 17:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790037; cv=none; b=Scj/+Z5vgynMk8n/sj4ID7nm1CNRxrl8crkzrqYoJw6XwIZY/hKbSDp/HAQj5bm10p51BWfG4rp/xSfmPS2cJZe0YCKQMGbOMJ0fnrTUm9Mb3pDJlCtmTKzaHO5UKxfr7xA4BaYNs4Yd+l3MM1E8YNhDuHihsLY6la0nk4YKcg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790037; c=relaxed/simple;
	bh=GX885yHcMV44ayLJFLgaWqHtR7uxm3/6fj0LPzRUEIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnKBU3v+4q/o0I+bgl8f9veGZjgPWHDhTf5OMpdmcnoS4dQf3secsX9XzQh+rrV+FwAhLAQssqQu1VUon/RdbPEouGQBqFECoMIZHF6UjXG6zi/nz3KtpX9LPz7mF2NkvjlwlUv3pBeEQhuUiP+bbNo/McV/L6dFOOASH5UtNYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCx/67mK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCx/67mK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA681F000FF;
	Wed, 30 Sep 2026 17:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790036;
	bh=e9AmK2E/LkLrMeUxPNp8O38ng0nkE7CMlHmYU7EmOB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCx/67mKoSCTAy0jbFrH4xjv2NLDpK4MVKkuWNiWFdvQRAozQuzcVN47ZSITmhcZ8
	 3LB9WT7fw8hNRTAj0HY60Kx5+4CJ1abybyxwcpAr+XbKMnh3gW0E7jHnOUuDyMMpH7
	 TcAshArUZRkG7CXd9tQ3hH88AEm4N4Mxy2KtYvIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 643/877] nvme: refactor the atomic write unit detection
Date: Wed, 30 Sep 2026 17:25:54 +0200
Message-ID: <20260930152428.531915322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit b2e607fecac15e07f50269c080e2e71b5049dfa2 ]

Move all the code out of nvme_update_disk_info into the helper, and
rename the helper to have a somewhat less clumsy name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>

Stable adaptation for 6.12:
- Keep the existing atomic write helper refactor, but omit
  BLK_FEAT_ATOMIC_WRITES: this tree enables atomic writes through the
  hardware limits and does not define that feature flag.
- Call the existing discard setup helper from nvme_update_disk_info()
  after setting logical_block_size. Save the disk-info validity result
  and defer clearing capacity until after atomic-size validation. This
  preserves the result while leaving the zoned update insertion point
  clear for 3838e80fcfb32e62baffb63c6dc0a60153665a4d.
- Adapt the preceding dependency's atomic-size error path to the
  single-argument blk_mq_unfreeze_queue() API and cancel the pending
  limits update before unfreezing, releasing limits_lock on rejection.

No additional functions are introduced.

Stable-dep-of: 3838e80fcfb3 ("nvme: skip the zoned limits update if the zone info query failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |   84 +++++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 38 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1993,20 +1993,50 @@ static void nvme_configure_metadata(stru
 }
 
 
-static void nvme_update_atomic_write_disk_info(struct nvme_ns *ns,
-			struct nvme_id_ns *id, struct queue_limits *lim,
-			u32 bs, u32 atomic_bs)
+static u32 nvme_configure_atomic_write(struct nvme_ns *ns,
+		struct nvme_id_ns *id, struct queue_limits *lim, u32 bs)
 {
-	unsigned int boundary = 0;
+	u32 atomic_bs, boundary = 0;
 
-	if (id->nsfeat & NVME_NS_FEAT_ATOMICS && id->nawupf) {
-		if (le16_to_cpu(id->nabspf))
+	/*
+	 * We do not support an offset for the atomic boundaries.
+	 */
+	if (id->nabo)
+		return bs;
+
+	if ((id->nsfeat & NVME_NS_FEAT_ATOMICS) && id->nawupf) {
+		/*
+		 * Use the per-namespace atomic write unit when available.
+		 */
+		atomic_bs = (1 + le16_to_cpu(id->nawupf)) * bs;
+		if (id->nabspf)
 			boundary = (le16_to_cpu(id->nabspf) + 1) * bs;
+	} else {
+		/*
+		 * Use the controller wide atomic write unit.  This sucks
+		 * because the limit is defined in terms of logical blocks while
+		 * namespaces can have different formats, and because there is
+		 * no clear language in the specification prohibiting different
+		 * values for different controllers in the subsystem.
+		 */
+		atomic_bs = (1 + ns->ctrl->awupf) * bs;
 	}
+
+	if (!ns->ctrl->subsys->atomic_bs) {
+		ns->ctrl->subsys->atomic_bs = atomic_bs;
+	} else if (ns->ctrl->subsys->atomic_bs != atomic_bs) {
+		dev_err_ratelimited(ns->ctrl->device,
+			"%s: Inconsistent Atomic Write Size, Namespace will not be added: Subsystem=%d bytes, Controller/Namespace=%d bytes\n",
+			ns->disk ? ns->disk->disk_name : "?",
+			ns->ctrl->subsys->atomic_bs,
+			atomic_bs);
+	}
+
 	lim->atomic_write_hw_max = atomic_bs;
 	lim->atomic_write_hw_boundary = boundary;
 	lim->atomic_write_hw_unit_min = bs;
 	lim->atomic_write_hw_unit_max = rounddown_pow_of_two(atomic_bs);
+	return atomic_bs;
 }
 
 static u32 nvme_max_drv_segments(struct nvme_ctrl *ctrl)
@@ -2044,34 +2074,8 @@ static bool nvme_update_disk_info(struct
 		valid = false;
 	}
 
-	atomic_bs = phys_bs = bs;
-	if (id->nabo == 0) {
-		/*
-		 * Bit 1 indicates whether NAWUPF is defined for this namespace
-		 * and whether it should be used instead of AWUPF. If NAWUPF ==
-		 * 0 then AWUPF must be used instead.
-		 */
-		if (id->nsfeat & NVME_NS_FEAT_ATOMICS && id->nawupf)
-			atomic_bs = (1 + le16_to_cpu(id->nawupf)) * bs;
-		else
-			atomic_bs = (1 + ns->ctrl->awupf) * bs;
-
-		/*
-		 * Set subsystem atomic bs.
-		 */
-		if (ns->ctrl->subsys->atomic_bs) {
-			if (atomic_bs != ns->ctrl->subsys->atomic_bs) {
-				dev_err_ratelimited(ns->ctrl->device,
-					"%s: Inconsistent Atomic Write Size, Namespace will not be added: Subsystem=%d bytes, Controller/Namespace=%d bytes\n",
-					ns->disk ? ns->disk->disk_name : "?",
-					ns->ctrl->subsys->atomic_bs,
-					atomic_bs);
-			}
-		} else
-			ns->ctrl->subsys->atomic_bs = atomic_bs;
-
-		nvme_update_atomic_write_disk_info(ns, id, lim, bs, atomic_bs);
-	}
+	phys_bs = bs;
+	atomic_bs = nvme_configure_atomic_write(ns, id, lim, bs);
 
 	if (id->nsfeat & NVME_NS_FEAT_IO_OPT) {
 		/* NPWG = Namespace Preferred Write Granularity */
@@ -2095,6 +2099,7 @@ static bool nvme_update_disk_info(struct
 		lim->max_write_zeroes_sectors = UINT_MAX;
 	else
 		lim->max_write_zeroes_sectors = ns->ctrl->max_zeroes_sectors;
+	nvme_config_discard(ns, lim);
 	return valid;
 }
 
@@ -2169,6 +2174,7 @@ static int nvme_update_ns_info_block(str
 	struct nvme_id_ns *id;
 	sector_t capacity;
 	unsigned lbaf;
+	bool valid;
 	int ret;
 
 	ret = nvme_identify_ns(ns->ctrl, info->nsid, &id);
@@ -2205,20 +2211,22 @@ static int nvme_update_ns_info_block(str
 	nvme_set_ctrl_limits(ns->ctrl, &lim);
 	nvme_configure_metadata(ns->ctrl, ns->head, id, nvm, info);
 	nvme_set_chunk_sectors(ns, id, &lim);
-	if (!nvme_update_disk_info(ns, id, &lim))
-		capacity = 0;
+	valid = nvme_update_disk_info(ns, id, &lim);
 
 	/*
 	 * Validate the max atomic write size fits within the subsystem's
 	 * atomic write capabilities.
 	 */
 	if (lim.atomic_write_hw_max > ns->ctrl->subsys->atomic_bs) {
-		blk_mq_unfreeze_queue(ns->disk->queue, memflags);
+		queue_limits_cancel_update(ns->disk->queue);
+		blk_mq_unfreeze_queue(ns->disk->queue);
 		ret = -ENXIO;
 		goto out;
 	}
 
-	nvme_config_discard(ns, &lim);
+	if (!valid)
+		capacity = 0;
+
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
 	    ns->head->ids.csi == NVME_CSI_ZNS)
 		nvme_update_zone_info(ns, &lim, &zi);


