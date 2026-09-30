Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6F75372E4;
	Wed, 30 Sep 2026 17:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790035; cv=none; b=JwJIw15z2BTSFcIVwmP0KGmrTVBDFSHa1lpZATHbuVwZO2+wcZCE8LGv4fKQuAWumCSxsZLmbprb+NPyvaUYSAwvyzeFD3m9bzBZABSmgfOISJBSm3kY7j0or2ZH0bh4gr8muyyYkNiYUamSJZ94s+uywVvIqEaq7BBQgkGAB4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790035; c=relaxed/simple;
	bh=Mb0/CnLTYIy/wX9Q6v97gAFytZyIZkKGfROUjFLEZvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRoDe0YwaK8tcowcHbwiH9f+1d4Q0Thws43wuJ3UrthQwTN6HrpNZp2K45a/AZQVibfpW8Pxcmpjaf3kdA5Voss6l/brHeX76CKkoR8s5lqissb2s7pYc1uScbZfySEZPVU7Qa86fFUnSjCl3cvbCMKDVxSR/BmeGqqNF2zIeiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+Z2JKEZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+Z2JKEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13911F000FF;
	Wed, 30 Sep 2026 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790033;
	bh=2X5DmsR4E+HuhIFANzHjXR3Yb3YDGSTbzJdGSOfLRRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e+Z2JKEZSWGokNjAYVa26O1saxnHIZ3fmMG4KkT2WKdTQRfUP4zlEZL6bVTZ/hHGK
	 QfF2xxicFy+LIoLfQSksWSJLA0XmGTgBJhbQ8fOXudeLaGxYFsspVN/LYmQf2dX4Z+
	 QYg9urNoWBje7nS4D/m+R8IG94/tyonELohF0nUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Adamson <alan.adamson@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 642/877] nvme: all namespaces in a subsystem must adhere to a common atomic write size
Date: Wed, 30 Sep 2026 17:25:53 +0200
Message-ID: <20260930152428.510370453@linuxfoundation.org>
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
Stable-dep-of: 3838e80fcfb3 ("nvme: skip the zoned limits update if the zone info query failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |   30 +++++++++++++++++++++++++++---
 drivers/nvme/host/nvme.h |    3 ++-
 2 files changed, 29 insertions(+), 4 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2054,7 +2054,21 @@ static bool nvme_update_disk_info(struct
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
@@ -2193,6 +2207,17 @@ static int nvme_update_ns_info_block(str
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
@@ -3029,7 +3054,6 @@ static int nvme_init_subsystem(struct nv
 		kfree(subsys);
 		return -EINVAL;
 	}
-	subsys->awupf = le16_to_cpu(id->awupf);
 	nvme_mpath_default_iopolicy(subsys);
 
 	subsys->dev.class = &nvme_subsys_class;
@@ -3439,7 +3463,7 @@ static int nvme_init_identify(struct nvm
 		dev_pm_qos_expose_latency_tolerance(ctrl->device);
 	else if (!ctrl->apst_enabled && prev_apst_enabled)
 		dev_pm_qos_hide_latency_tolerance(ctrl->device);
-
+	ctrl->awupf = le16_to_cpu(id->awupf);
 out_free:
 	kfree(id);
 	return ret;
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


