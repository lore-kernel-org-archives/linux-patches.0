Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF2E2222BF;
	Mon, 19 May 2025 21:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689718; cv=none; b=BmEWg0Oas0uwXZiHNKdQBv47ugVsoOoB1wNptNbOzcEbeVRNySDDXsJ3ZxZ0oJ+IMZJxR5KNa469n/l/GFuTNIUpCp8qU5bjsUae+ihK1tQ6wANXhMHfsRG7odC8FrkCM1HxfzpWV4DMigbrb2lHLa06zmxHtY6S2wc4PRdfrrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689718; c=relaxed/simple;
	bh=KEpvB4iyQsDjokKmIPleY+Z2v/skfnDdUMnievVfv/c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JCjE06vpqbtbm5VN9jP85UV9EL7L+RNfF9F1gvmEXu4/fc/NcpytldLbS0S9Tv9VJknrba49QxktYirNN+4/pdhig/Ap5uYZgPqqTbasyVr1Fq1tx2hONVVAh6N4+w/xmVMA1h9RucvecZweqyW/rNtLu+i5GNEsbAAfIkubhX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rcGKUsfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rcGKUsfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F5BC4CEE9;
	Mon, 19 May 2025 21:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689718;
	bh=KEpvB4iyQsDjokKmIPleY+Z2v/skfnDdUMnievVfv/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcGKUsfcpYb97XFCu8vn2xIngaYQxMqkxKBIVAgI00r1ZB8U7Yk6P1FdTCZjt3+Xz
	 m2sef/GpstjzcfdAHvge+tRtHwbZnUcPBPr1gTDZsH7IivVuH5GVi9SR7DlHNJUIto
	 sENAg+ANVSiqk0yGx53wYpSVKb8blxl8XsRBD1xuvHGwLA+A54MPleZ68a3kz0qOF4
	 RiKB2PqriPVNUlZzzAIUgvtE9yjyyijIUQcLYZJ8GcqycD5zhZyyjJFmZsd/YsEju0
	 jjqeBA38uh5QFivE+mycnrKP73O9zGH6OglSRfFvKaXQK4Hatxhsck94tRva5VwL4P
	 WFpuJpsosfVFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alan Adamson <alan.adamson@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	kbusch@kernel.org,
	axboe@fb.com,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 17/23] nvme: all namespaces in a subsystem must adhere to a common atomic write size
Date: Mon, 19 May 2025 17:21:24 -0400
Message-Id: <20250519212131.1985647-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212131.1985647-1-sashal@kernel.org>
References: <20250519212131.1985647-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.7
Content-Transfer-Encoding: 8bit

From: Alan Adamson <alan.adamson@oracle.com>

[ Upstream commit 8695f060a02953b33ac6240895dcb9c7ce16c91c ]

The first namespace configured in a subsystem sets the subsystem's
atomic write size based on its AWUPF or NAWUPF. Subsequent namespaces
must have an atomic write size (per their AWUPF or NAWUPF) less than or
equal to the subsystem's atomic write size, or their probing will be
rejected.

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
[hch: fold in review comments from John Garry]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 30 +++++++++++++++++++++++++++---
 drivers/nvme/host/nvme.h |  3 ++-
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a27149e37a988..8863c9fcb4aab 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2059,7 +2059,21 @@ static bool nvme_update_disk_info(struct nvme_ns *ns, struct nvme_id_ns *id,
 		if (id->nsfeat & NVME_NS_FEAT_ATOMICS && id->nawupf)
 			atomic_bs = (1 + le16_to_cpu(id->nawupf)) * bs;
 		else
-			atomic_bs = (1 + ns->ctrl->subsys->awupf) * bs;
+			atomic_bs = (1 + ns->ctrl->awupf) * bs;
+
+		/*
+		 * Set subsystem atomic bs.
+		 */
+		if (ns->ctrl->subsys->atomic_bs) {
+			if (atomic_bs != ns->ctrl->subsys->atomic_bs) {
+				dev_err_ratelimited(ns->ctrl->device,
+					"%s: Inconsistent Atomic Write Size, Namespace will not be added: Subsystem=%d bytes, Controller/Namespace=%d bytes\n",
+					ns->disk ? ns->disk->disk_name : "?",
+					ns->ctrl->subsys->atomic_bs,
+					atomic_bs);
+			}
+		} else
+			ns->ctrl->subsys->atomic_bs = atomic_bs;
 
 		nvme_update_atomic_write_disk_info(ns, id, lim, bs, atomic_bs);
 	}
@@ -2201,6 +2215,17 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
 	nvme_set_chunk_sectors(ns, id, &lim);
 	if (!nvme_update_disk_info(ns, id, &lim))
 		capacity = 0;
+
+	/*
+	 * Validate the max atomic write size fits within the subsystem's
+	 * atomic write capabilities.
+	 */
+	if (lim.atomic_write_hw_max > ns->ctrl->subsys->atomic_bs) {
+		blk_mq_unfreeze_queue(ns->disk->queue, memflags);
+		ret = -ENXIO;
+		goto out;
+	}
+
 	nvme_config_discard(ns, &lim);
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
 	    ns->head->ids.csi == NVME_CSI_ZNS)
@@ -3031,7 +3056,6 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 		kfree(subsys);
 		return -EINVAL;
 	}
-	subsys->awupf = le16_to_cpu(id->awupf);
 	nvme_mpath_default_iopolicy(subsys);
 
 	subsys->dev.class = &nvme_subsys_class;
@@ -3441,7 +3465,7 @@ static int nvme_init_identify(struct nvme_ctrl *ctrl)
 		dev_pm_qos_expose_latency_tolerance(ctrl->device);
 	else if (!ctrl->apst_enabled && prev_apst_enabled)
 		dev_pm_qos_hide_latency_tolerance(ctrl->device);
-
+	ctrl->awupf = le16_to_cpu(id->awupf);
 out_free:
 	kfree(id);
 	return ret;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 7be92d07430e9..3804f91b19420 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -410,6 +410,7 @@ struct nvme_ctrl {
 
 	enum nvme_ctrl_type cntrltype;
 	enum nvme_dctype dctype;
+	u16 awupf; /* 0's based value. */
 };
 
 static inline enum nvme_ctrl_state nvme_ctrl_state(struct nvme_ctrl *ctrl)
@@ -442,11 +443,11 @@ struct nvme_subsystem {
 	u8			cmic;
 	enum nvme_subsys_type	subtype;
 	u16			vendor_id;
-	u16			awupf;	/* 0's based awupf value. */
 	struct ida		ns_ida;
 #ifdef CONFIG_NVME_MULTIPATH
 	enum nvme_iopolicy	iopolicy;
 #endif
+	u32			atomic_bs;
 };
 
 /*
-- 
2.39.5

