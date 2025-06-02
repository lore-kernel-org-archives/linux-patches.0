Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFFF221299;
	Mon,  2 Jun 2025 13:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872774; cv=none; b=m7kp6ETedCPMK29xUoSQL7Mti3jjrE4zhzf1hvIVVzH8k89HHzU62aJnnt6nd+WHisSrrka7iXngFuIvazVburZL4D6w2C+nnr7ljrhiGWcF88LixhyLSDo4KhSg0WUGxqXd5iL6OE14G1ru6rqsJldf2r5urc78GqiGYqzXPIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872774; c=relaxed/simple;
	bh=Qij0sLwc0a5PhgBVfnoj1p/TuA2kkhpdNVLZXG5ZLMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CADHEOxCNw5OXmT7tUFgZ2Hl2bghuI49C8zM2zQ9ncXN9E4PQ8/M2Vgeka55/GC7KyMamvgELCtH8Sn+r3lRXznrlgfA2zsCuKv49dJzZq2rocweKu6cwcqw8y+C+AnQKYbjofDbUp41PCu2gYqK05nQVAlTJV9V6Ooa9aW7Y+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGguoDVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGguoDVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050FCC4CEEB;
	Mon,  2 Jun 2025 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872774;
	bh=Qij0sLwc0a5PhgBVfnoj1p/TuA2kkhpdNVLZXG5ZLMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGguoDVBGQ1Q1IT8oVHNt2aM3kkhI+DEu2Lp4+h8hQ9Qtyld3Fcs7gRM2Bxy2J8aK
	 nfFIYLXLc/Mcyih923/9DXZB3XHfpdX3mWtxLsUNuwuk6iQY2THknaE2b/fi65CfvC
	 SiWuqlTUxiFLAhdkdsQMVIXWpF412tTfGZIcHdqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Adamson <alan.adamson@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 63/73] nvme: all namespaces in a subsystem must adhere to a common atomic write size
Date: Mon,  2 Jun 2025 15:47:49 +0200
Message-ID: <20250602134244.173387200@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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



