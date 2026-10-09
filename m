Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F173431F8;
	Fri,  9 Oct 2026 14:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556012; cv=none; b=n7UnlpTs4AzXT1sV7tbBDFUWyY7UcTgXWYRfFtssU0/uJyEfyO99E6f8hVzA1LcAGSo3BSL1ekZAilpNaZWLDzQdQDBL8krS1TOpYHtVn0+SeVVUgq0sn/xEQhtBOyKPNzA++GiQGc9jT9DMl+06zoXYdNVVdRpOVyZpO0w4gZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556012; c=relaxed/simple;
	bh=3R8D1EK8BjtOIpQunAOkKWpymHhOTT1v2Cch2aI3xFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2ofa6I3oAA3hJpSFrkCrQnwyBQ8wObYd1Kh+Y1aXptvLRVZ1GWMFi47q3Z/63EY1rn0es5tE/kMpwcsX/h8wN5n1INWSv0nY9ZPOPh1j61tNhBQpNkxN4cIUoTAW8IOh11mvg6Qt/qpJLTHWDP0lOwPCF/vv/4CG7nZqE5qcxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izsSR7+a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izsSR7+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FE21F000FF;
	Fri,  9 Oct 2026 14:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556011;
	bh=Jl60YLXazvhIkLQce1bJAU4TcTPqmUFJSIpHovUNT7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izsSR7+adiHQJrMTtU6LpwHTrPOLNPttDMAYxFb+2UdZbvOBMXdtPm6JAEuXwYz/6
	 8gMdlkVSWZ/6X1MHKXhaWrKY8dKURIh0lNB5EZkL+gQdkM5fGTn7wJ/RwDYPYeOoCX
	 X6vGJYEqVWmDvT2BYGfHyvAPCDLg7V05NadVrYYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yao Sang <sangyao@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 107/428] nvme: fix command effects log lifetime for multipath heads
Date: Fri,  9 Oct 2026 16:07:24 +0200
Message-ID: <20261009140948.558977353@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Yao Sang <sangyao@kylinos.cn>

[ Upstream commit 72ece656abd4de8645a421fb482d7a11e6533a45 ]

KASAN reported a use-after-free when an I/O passthrough command was sent
through a multipath namespace head after the controller path that first
created the head had been removed:

  BUG: KASAN: slab-use-after-free in nvme_command_effects+0x192/0x200 [nvme_core]
  Read of size 4 at addr ffff888141b14400 by task nvme/19811
  nvme_command_effects+0x192/0x200 [nvme_core]
  nvme_cmd_allowed+0x7e/0x1b0 [nvme_core]
  nvme_user_cmd.constprop.0+0x1b5/0x450 [nvme_core]
  nvme_ns_head_chr_ioctl+0xf4/0x2a0 [nvme_core]

Move the log cache to the subsystem, with one entry per command set. Both
controllers and namespace heads hold subsystem references, keeping their
log pointers valid until subsystem release.

Fixes: be93e87e7802 ("nvme: support for multiple Command Sets Supported and Effects log pages")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yao Sang <sangyao@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c |   41 +++++++++++++++++++----------------------
 drivers/nvme/host/nvme.h |    3 ++-
 2 files changed, 21 insertions(+), 23 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3179,9 +3179,16 @@ static void nvme_release_subsystem(struc
 {
 	struct nvme_subsystem *subsys =
 		container_of(dev, struct nvme_subsystem, dev);
+	struct nvme_effects_log *cel;
+	unsigned long i;
 
 	if (subsys->instance >= 0)
 		ida_free(&nvme_instance_ida, subsys->instance);
+	xa_for_each(&subsys->cels, i, cel) {
+		xa_erase(&subsys->cels, i);
+		kfree(cel);
+	}
+	xa_destroy(&subsys->cels);
 	kfree(subsys);
 }
 
@@ -3293,6 +3300,7 @@ static int nvme_init_subsystem(struct nv
 	kref_init(&subsys->ref);
 	INIT_LIST_HEAD(&subsys->ctrls);
 	INIT_LIST_HEAD(&subsys->nsheads);
+	xa_init(&subsys->cels);
 	nvme_init_subnqn(subsys, ctrl, id);
 	memcpy(subsys->serial, id->sn, sizeof(subsys->serial));
 	memcpy(subsys->model, id->mn, sizeof(subsys->model));
@@ -3395,7 +3403,7 @@ int nvme_get_log(struct nvme_ctrl *ctrl,
 static int nvme_get_effects_log(struct nvme_ctrl *ctrl, u8 csi,
 				struct nvme_effects_log **log)
 {
-	struct nvme_effects_log *old, *cel = xa_load(&ctrl->cels, csi);
+	struct nvme_effects_log *old, *cel = xa_load(&ctrl->subsys->cels, csi);
 	int ret;
 
 	if (cel)
@@ -3412,7 +3420,7 @@ static int nvme_get_effects_log(struct n
 		return ret;
 	}
 
-	old = xa_store(&ctrl->cels, csi, cel, GFP_KERNEL);
+	old = xa_store(&ctrl->subsys->cels, csi, cel, GFP_KERNEL);
 	if (xa_is_err(old)) {
 		kfree(cel);
 		return xa_err(old);
@@ -3487,7 +3495,7 @@ static int nvme_init_effects_log(struct
 	if (!effects)
 		return -ENOMEM;
 
-	old = xa_store(&ctrl->cels, csi, effects, GFP_KERNEL);
+	old = xa_store(&ctrl->subsys->cels, csi, effects, GFP_KERNEL);
 	if (xa_is_err(old)) {
 		kfree(effects);
 		return xa_err(old);
@@ -3533,23 +3541,27 @@ static int nvme_init_effects(struct nvme
 {
 	int ret = 0;
 
+	mutex_lock(&ctrl->subsys->lock);
+	ctrl->effects = xa_load(&ctrl->subsys->cels, NVME_CSI_NVM);
 	if (ctrl->effects)
-		return 0;
+		goto out_unlock;
 
 	if (id->lpa & NVME_CTRL_LPA_CMD_EFFECTS_LOG) {
 		ret = nvme_get_effects_log(ctrl, NVME_CSI_NVM, &ctrl->effects);
 		if (ret < 0)
-			return ret;
+			goto out_unlock;
 	}
 
 	if (!ctrl->effects) {
 		ret = nvme_init_effects_log(ctrl, NVME_CSI_NVM, &ctrl->effects);
 		if (ret < 0)
-			return ret;
+			goto out_unlock;
 	}
 
 	nvme_init_known_nvm_effects(ctrl);
-	return 0;
+out_unlock:
+	mutex_unlock(&ctrl->subsys->lock);
+	return ret;
 }
 
 static int nvme_check_ctrl_fabric_info(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
@@ -5134,19 +5146,6 @@ void nvme_uninit_ctrl(struct nvme_ctrl *
 }
 EXPORT_SYMBOL_GPL(nvme_uninit_ctrl);
 
-static void nvme_free_cels(struct nvme_ctrl *ctrl)
-{
-	struct nvme_effects_log	*cel;
-	unsigned long i;
-
-	xa_for_each(&ctrl->cels, i, cel) {
-		xa_erase(&ctrl->cels, i);
-		kfree(cel);
-	}
-
-	xa_destroy(&ctrl->cels);
-}
-
 static void nvme_free_ctrl(struct device *dev)
 {
 	struct nvme_ctrl *ctrl =
@@ -5159,7 +5158,6 @@ static void nvme_free_ctrl(struct device
 		blk_put_queue(ctrl->fabrics_q);
 	if (!subsys || ctrl->instance != subsys->instance)
 		ida_free(&nvme_instance_ida, ctrl->instance);
-	nvme_free_cels(ctrl);
 	nvme_mpath_uninit(ctrl);
 	cleanup_srcu_struct(&ctrl->srcu);
 	nvme_auth_stop(ctrl);
@@ -5205,7 +5203,6 @@ int nvme_init_ctrl(struct nvme_ctrl *ctr
 
 	mutex_init(&ctrl->scan_lock);
 	INIT_LIST_HEAD(&ctrl->namespaces);
-	xa_init(&ctrl->cels);
 	ctrl->dev = dev;
 	ctrl->ops = ops;
 	ctrl->quirks = quirks;
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -413,7 +413,6 @@ struct nvme_ctrl {
 	unsigned long quirks;
 	struct nvme_id_power_state psd[32];
 	struct nvme_effects_log *effects;
-	struct xarray cels;
 	struct work_struct scan_work;
 	struct work_struct async_event_work;
 	struct delayed_work ka_work;
@@ -505,6 +504,8 @@ struct nvme_subsystem {
 	struct list_head	ctrls;
 	struct list_head	nsheads
 		__guarded_by(&lock);
+	/* Command effects logs, indexed by CSI and protected by lock. */
+	struct xarray		cels;
 	char			subnqn[NVMF_NQN_SIZE];
 	char			serial[20];
 	char			model[40];


