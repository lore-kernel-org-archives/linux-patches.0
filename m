Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C427B101DE;
	Thu,  3 Jul 2025 15:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555149; cv=none; b=uFWcusDzmGnHViYBhvmSBiSOp19ugkngYt1n++FAZSgE7WDydFExKLZNhl2T/+/9wrT91ox2FBak/puwtOGodm3i/iMTjSojwJA7eB8JMLegmHQqQC7e9qmLNL2I3GrOyZeFI236xcFmnvHxI+sSRa3nsypL2G/k36+MBgDyh+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555149; c=relaxed/simple;
	bh=/PLPHf3yLU8ly2EOwu86uHRs9xkeXSg+GU15seiPgnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e03NLsWL46AsYl25rlH5vyA0kZWvZgxivi67trfOKpCEc6EQQRsK8Xg/Vmu/wFq7Z8+wBgncBYQzD4MqrjkLDSwimwm3qiDiLpEAYKSRDxgOT7quZvnmb958h8vLUUnDHaN0/YAqQyLx7ycp4FjiRItCQRHRe7Zfqo+lSGK17Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XteK5rLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XteK5rLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB19DC4CEE3;
	Thu,  3 Jul 2025 15:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555149;
	bh=/PLPHf3yLU8ly2EOwu86uHRs9xkeXSg+GU15seiPgnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XteK5rLX8US8XeLRMHPjmluR/B1LPnI+7TPx5dycN1Kf/TkP5miyfRmXzOpLrffd8
	 pc9pMd3SGBHA39nwupMAh6kA6tVzGdOdumEuBllk8VP7XzHRaX/so1/M+D5exvNHAd
	 DJ423riD/dERvWE8fKphjZmZWcNsU6yE9GJMeSs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 161/263] nvme: fix atomic write size validation
Date: Thu,  3 Jul 2025 16:41:21 +0200
Message-ID: <20250703144010.816387114@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit f46d273449ba65afd53f3dd8fe0182c9df877e08 ]

Don't mix the namespace and controller values, and validate the
per-controller limit when probing the controller.  This avoid spurious
failures for controllers with namespaces that have different namespaces
with different logical block sizes, or report the per-namespace values
only for some namespaces.

It also fixes a missing queue_limits_cancel_update in an error path by
removing that error path.

Fixes: 8695f060a029 ("nvme: all namespaces in a subsystem must adhere to a common atomic write size")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 33 +++++++++++----------------------
 drivers/nvme/host/nvme.h |  3 +--
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 1c853c5b8169b..d253b82901110 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2022,17 +2022,7 @@ static u32 nvme_configure_atomic_write(struct nvme_ns *ns,
 		 * no clear language in the specification prohibiting different
 		 * values for different controllers in the subsystem.
 		 */
-		atomic_bs = (1 + ns->ctrl->awupf) * bs;
-	}
-
-	if (!ns->ctrl->subsys->atomic_bs) {
-		ns->ctrl->subsys->atomic_bs = atomic_bs;
-	} else if (ns->ctrl->subsys->atomic_bs != atomic_bs) {
-		dev_err_ratelimited(ns->ctrl->device,
-			"%s: Inconsistent Atomic Write Size, Namespace will not be added: Subsystem=%d bytes, Controller/Namespace=%d bytes\n",
-			ns->disk ? ns->disk->disk_name : "?",
-			ns->ctrl->subsys->atomic_bs,
-			atomic_bs);
+		atomic_bs = (1 + ns->ctrl->subsys->awupf) * bs;
 	}
 
 	lim->atomic_write_hw_max = atomic_bs;
@@ -2219,16 +2209,6 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
 	if (!nvme_update_disk_info(ns, id, &lim))
 		capacity = 0;
 
-	/*
-	 * Validate the max atomic write size fits within the subsystem's
-	 * atomic write capabilities.
-	 */
-	if (lim.atomic_write_hw_max > ns->ctrl->subsys->atomic_bs) {
-		blk_mq_unfreeze_queue(ns->disk->queue, memflags);
-		ret = -ENXIO;
-		goto out;
-	}
-
 	nvme_config_discard(ns, &lim);
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
 	    ns->head->ids.csi == NVME_CSI_ZNS)
@@ -3044,6 +3024,7 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 	memcpy(subsys->model, id->mn, sizeof(subsys->model));
 	subsys->vendor_id = le16_to_cpu(id->vid);
 	subsys->cmic = id->cmic;
+	subsys->awupf = le16_to_cpu(id->awupf);
 
 	/* Versions prior to 1.4 don't necessarily report a valid type */
 	if (id->cntrltype == NVME_CTRL_DISC ||
@@ -3373,6 +3354,15 @@ static int nvme_init_identify(struct nvme_ctrl *ctrl)
 		if (ret)
 			goto out_free;
 	}
+
+	if (le16_to_cpu(id->awupf) != ctrl->subsys->awupf) {
+		dev_err_ratelimited(ctrl->device,
+			"inconsistent AWUPF, controller not added (%u/%u).\n",
+			le16_to_cpu(id->awupf), ctrl->subsys->awupf);
+		ret = -EINVAL;
+		goto out_free;
+	}
+
 	memcpy(ctrl->subsys->firmware_rev, id->fr,
 	       sizeof(ctrl->subsys->firmware_rev));
 
@@ -3468,7 +3458,6 @@ static int nvme_init_identify(struct nvme_ctrl *ctrl)
 		dev_pm_qos_expose_latency_tolerance(ctrl->device);
 	else if (!ctrl->apst_enabled && prev_apst_enabled)
 		dev_pm_qos_hide_latency_tolerance(ctrl->device);
-	ctrl->awupf = le16_to_cpu(id->awupf);
 out_free:
 	kfree(id);
 	return ret;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 8fc4683418a3a..d8c4e545f732c 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -410,7 +410,6 @@ struct nvme_ctrl {
 
 	enum nvme_ctrl_type cntrltype;
 	enum nvme_dctype dctype;
-	u16 awupf; /* 0's based value. */
 };
 
 static inline enum nvme_ctrl_state nvme_ctrl_state(struct nvme_ctrl *ctrl)
@@ -443,11 +442,11 @@ struct nvme_subsystem {
 	u8			cmic;
 	enum nvme_subsys_type	subtype;
 	u16			vendor_id;
+	u16			awupf; /* 0's based value. */
 	struct ida		ns_ida;
 #ifdef CONFIG_NVME_MULTIPATH
 	enum nvme_iopolicy	iopolicy;
 #endif
-	u32			atomic_bs;
 };
 
 /*
-- 
2.39.5



