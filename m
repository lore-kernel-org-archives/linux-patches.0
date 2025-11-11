Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C662F12C1;
	Tue, 11 Nov 2025 01:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823238; cv=none; b=Wm1TkM5L1SvA9YxcQ7EmjGqqn4i5uLEmGwFEuyaPGtWJf69A6RIeBqD9l2km5GuHn6s1dWML+yW3UbPqTfQ8T1EdiNB0ARcUEl05QcJlUKOW6NL8YzTRC7+R7C89y9hFSocBN4PFzhhgm99B5EbTkWveI3YKJ5ss6LxmeZ2aRGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823238; c=relaxed/simple;
	bh=vCTebt0CpLbgTKIG1sE8umx6Gt15vXnxhHAWm4fWnyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAlXdzLbr80cWCQ8N2X9hArEt6xJmZ4d0/zPyfFQAQuShTlaG88oCmXo0sccNspqu4CGL+miiBk0YZlXtNVSymZtwL1qx5Lrw2X8FOrSqpeJlC1S4qVON1vRD1o0lW8ST5ZFssDFdrCh0kV7bY9eJ8VMbPyb6ZlPlKbuda8WdhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bIWMp/xQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bIWMp/xQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424A1C16AAE;
	Tue, 11 Nov 2025 01:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823238;
	bh=vCTebt0CpLbgTKIG1sE8umx6Gt15vXnxhHAWm4fWnyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIWMp/xQNYeqYYVubsZCixWQsG/iqnTAPRhCunBmau3MqLiycH+nMNQUB97pdnOGH
	 vj5QwJZ6C3JRGTHO6ba6KMs1c66y5lnPXyYagLWFrEfn3jjUdUqzKUwZNRLknNdVLx
	 23gkFzypx4+cxg8OS5Xw5IDtceu2c6PhBRFy+i1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 259/849] accel/amdxdna: Unify pm and rpm suspend and resume callbacks
Date: Tue, 11 Nov 2025 09:37:09 +0900
Message-ID: <20251111004542.693365960@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit d2b48f2b30f25997a1ae1ad0cefac68c25f8c330 ]

The suspend and resume callbacks for pm and runtime pm should be same.
During suspending, it needs to stop all hardware contexts first. And
the hardware contexts will be restarted after the device is resumed.

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://lore.kernel.org/r/20250803191450.1568851-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c        | 59 ++++++++++----------
 drivers/accel/amdxdna/aie2_pci.c        | 37 +++++++++++--
 drivers/accel/amdxdna/aie2_pci.h        |  5 +-
 drivers/accel/amdxdna/amdxdna_ctx.c     | 26 ---------
 drivers/accel/amdxdna/amdxdna_ctx.h     |  2 -
 drivers/accel/amdxdna/amdxdna_pci_drv.c | 74 +++----------------------
 drivers/accel/amdxdna/amdxdna_pci_drv.h |  4 +-
 7 files changed, 73 insertions(+), 134 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index cda964ba33cd7..6f77d1794e483 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -46,6 +46,17 @@ static void aie2_job_put(struct amdxdna_sched_job *job)
 	kref_put(&job->refcnt, aie2_job_release);
 }
 
+static void aie2_hwctx_status_shift_stop(struct amdxdna_hwctx *hwctx)
+{
+	 hwctx->old_status = hwctx->status;
+	 hwctx->status = HWCTX_STAT_STOP;
+}
+
+static void aie2_hwctx_status_restore(struct amdxdna_hwctx *hwctx)
+{
+	hwctx->status = hwctx->old_status;
+}
+
 /* The bad_job is used in aie2_sched_job_timedout, otherwise, set it to NULL */
 static void aie2_hwctx_stop(struct amdxdna_dev *xdna, struct amdxdna_hwctx *hwctx,
 			    struct drm_sched_job *bad_job)
@@ -89,25 +100,6 @@ static int aie2_hwctx_restart(struct amdxdna_dev *xdna, struct amdxdna_hwctx *hw
 	return ret;
 }
 
-void aie2_restart_ctx(struct amdxdna_client *client)
-{
-	struct amdxdna_dev *xdna = client->xdna;
-	struct amdxdna_hwctx *hwctx;
-	unsigned long hwctx_id;
-
-	drm_WARN_ON(&xdna->ddev, !mutex_is_locked(&xdna->dev_lock));
-	mutex_lock(&client->hwctx_lock);
-	amdxdna_for_each_hwctx(client, hwctx_id, hwctx) {
-		if (hwctx->status != HWCTX_STAT_STOP)
-			continue;
-
-		hwctx->status = hwctx->old_status;
-		XDNA_DBG(xdna, "Resetting %s", hwctx->name);
-		aie2_hwctx_restart(xdna, hwctx);
-	}
-	mutex_unlock(&client->hwctx_lock);
-}
-
 static struct dma_fence *aie2_cmd_get_out_fence(struct amdxdna_hwctx *hwctx, u64 seq)
 {
 	struct dma_fence *fence, *out_fence = NULL;
@@ -141,9 +133,11 @@ static void aie2_hwctx_wait_for_idle(struct amdxdna_hwctx *hwctx)
 	dma_fence_put(fence);
 }
 
-void aie2_hwctx_suspend(struct amdxdna_hwctx *hwctx)
+void aie2_hwctx_suspend(struct amdxdna_client *client)
 {
-	struct amdxdna_dev *xdna = hwctx->client->xdna;
+	struct amdxdna_dev *xdna = client->xdna;
+	struct amdxdna_hwctx *hwctx;
+	unsigned long hwctx_id;
 
 	/*
 	 * Command timeout is unlikely. But if it happens, it doesn't
@@ -151,15 +145,19 @@ void aie2_hwctx_suspend(struct amdxdna_hwctx *hwctx)
 	 * and abort all commands.
 	 */
 	drm_WARN_ON(&xdna->ddev, !mutex_is_locked(&xdna->dev_lock));
-	aie2_hwctx_wait_for_idle(hwctx);
-	aie2_hwctx_stop(xdna, hwctx, NULL);
-	hwctx->old_status = hwctx->status;
-	hwctx->status = HWCTX_STAT_STOP;
+	guard(mutex)(&client->hwctx_lock);
+	amdxdna_for_each_hwctx(client, hwctx_id, hwctx) {
+		aie2_hwctx_wait_for_idle(hwctx);
+		aie2_hwctx_stop(xdna, hwctx, NULL);
+		aie2_hwctx_status_shift_stop(hwctx);
+	}
 }
 
-void aie2_hwctx_resume(struct amdxdna_hwctx *hwctx)
+void aie2_hwctx_resume(struct amdxdna_client *client)
 {
-	struct amdxdna_dev *xdna = hwctx->client->xdna;
+	struct amdxdna_dev *xdna = client->xdna;
+	struct amdxdna_hwctx *hwctx;
+	unsigned long hwctx_id;
 
 	/*
 	 * The resume path cannot guarantee that mailbox channel can be
@@ -167,8 +165,11 @@ void aie2_hwctx_resume(struct amdxdna_hwctx *hwctx)
 	 * mailbox channel, error will return.
 	 */
 	drm_WARN_ON(&xdna->ddev, !mutex_is_locked(&xdna->dev_lock));
-	hwctx->status = hwctx->old_status;
-	aie2_hwctx_restart(xdna, hwctx);
+	guard(mutex)(&client->hwctx_lock);
+	amdxdna_for_each_hwctx(client, hwctx_id, hwctx) {
+		aie2_hwctx_status_restore(hwctx);
+		aie2_hwctx_restart(xdna, hwctx);
+	}
 }
 
 static void
diff --git a/drivers/accel/amdxdna/aie2_pci.c b/drivers/accel/amdxdna/aie2_pci.c
index c6cf7068d23c0..272c919d6d4fd 100644
--- a/drivers/accel/amdxdna/aie2_pci.c
+++ b/drivers/accel/amdxdna/aie2_pci.c
@@ -440,6 +440,37 @@ static int aie2_hw_start(struct amdxdna_dev *xdna)
 	return ret;
 }
 
+static int aie2_hw_suspend(struct amdxdna_dev *xdna)
+{
+	struct amdxdna_client *client;
+
+	guard(mutex)(&xdna->dev_lock);
+	list_for_each_entry(client, &xdna->client_list, node)
+		aie2_hwctx_suspend(client);
+
+	aie2_hw_stop(xdna);
+
+	return 0;
+}
+
+static int aie2_hw_resume(struct amdxdna_dev *xdna)
+{
+	struct amdxdna_client *client;
+	int ret;
+
+	guard(mutex)(&xdna->dev_lock);
+	ret = aie2_hw_start(xdna);
+	if (ret) {
+		XDNA_ERR(xdna, "Start hardware failed, %d", ret);
+		return ret;
+	}
+
+	list_for_each_entry(client, &xdna->client_list, node)
+		aie2_hwctx_resume(client);
+
+	return ret;
+}
+
 static int aie2_init(struct amdxdna_dev *xdna)
 {
 	struct pci_dev *pdev = to_pci_dev(xdna->ddev.dev);
@@ -905,8 +936,8 @@ static int aie2_set_state(struct amdxdna_client *client,
 const struct amdxdna_dev_ops aie2_ops = {
 	.init           = aie2_init,
 	.fini           = aie2_fini,
-	.resume         = aie2_hw_start,
-	.suspend        = aie2_hw_stop,
+	.resume         = aie2_hw_resume,
+	.suspend        = aie2_hw_suspend,
 	.get_aie_info   = aie2_get_info,
 	.set_aie_state	= aie2_set_state,
 	.hwctx_init     = aie2_hwctx_init,
@@ -914,6 +945,4 @@ const struct amdxdna_dev_ops aie2_ops = {
 	.hwctx_config   = aie2_hwctx_config,
 	.cmd_submit     = aie2_cmd_submit,
 	.hmm_invalidate = aie2_hmm_invalidate,
-	.hwctx_suspend  = aie2_hwctx_suspend,
-	.hwctx_resume   = aie2_hwctx_resume,
 };
diff --git a/drivers/accel/amdxdna/aie2_pci.h b/drivers/accel/amdxdna/aie2_pci.h
index 385914840eaa6..488d8ee568eb1 100644
--- a/drivers/accel/amdxdna/aie2_pci.h
+++ b/drivers/accel/amdxdna/aie2_pci.h
@@ -288,10 +288,9 @@ int aie2_sync_bo(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job,
 int aie2_hwctx_init(struct amdxdna_hwctx *hwctx);
 void aie2_hwctx_fini(struct amdxdna_hwctx *hwctx);
 int aie2_hwctx_config(struct amdxdna_hwctx *hwctx, u32 type, u64 value, void *buf, u32 size);
-void aie2_hwctx_suspend(struct amdxdna_hwctx *hwctx);
-void aie2_hwctx_resume(struct amdxdna_hwctx *hwctx);
+void aie2_hwctx_suspend(struct amdxdna_client *client);
+void aie2_hwctx_resume(struct amdxdna_client *client);
 int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job, u64 *seq);
 void aie2_hmm_invalidate(struct amdxdna_gem_obj *abo, unsigned long cur_seq);
-void aie2_restart_ctx(struct amdxdna_client *client);
 
 #endif /* _AIE2_PCI_H_ */
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index be073224bd693..b47a7f8e90170 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -60,32 +60,6 @@ static struct dma_fence *amdxdna_fence_create(struct amdxdna_hwctx *hwctx)
 	return &fence->base;
 }
 
-void amdxdna_hwctx_suspend(struct amdxdna_client *client)
-{
-	struct amdxdna_dev *xdna = client->xdna;
-	struct amdxdna_hwctx *hwctx;
-	unsigned long hwctx_id;
-
-	drm_WARN_ON(&xdna->ddev, !mutex_is_locked(&xdna->dev_lock));
-	mutex_lock(&client->hwctx_lock);
-	amdxdna_for_each_hwctx(client, hwctx_id, hwctx)
-		xdna->dev_info->ops->hwctx_suspend(hwctx);
-	mutex_unlock(&client->hwctx_lock);
-}
-
-void amdxdna_hwctx_resume(struct amdxdna_client *client)
-{
-	struct amdxdna_dev *xdna = client->xdna;
-	struct amdxdna_hwctx *hwctx;
-	unsigned long hwctx_id;
-
-	drm_WARN_ON(&xdna->ddev, !mutex_is_locked(&xdna->dev_lock));
-	mutex_lock(&client->hwctx_lock);
-	amdxdna_for_each_hwctx(client, hwctx_id, hwctx)
-		xdna->dev_info->ops->hwctx_resume(hwctx);
-	mutex_unlock(&client->hwctx_lock);
-}
-
 static void amdxdna_hwctx_destroy_rcu(struct amdxdna_hwctx *hwctx,
 				      struct srcu_struct *ss)
 {
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.h b/drivers/accel/amdxdna/amdxdna_ctx.h
index f0a4a8586d858..c652229547a3c 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.h
+++ b/drivers/accel/amdxdna/amdxdna_ctx.h
@@ -147,8 +147,6 @@ static inline u32 amdxdna_hwctx_col_map(struct amdxdna_hwctx *hwctx)
 
 void amdxdna_sched_job_cleanup(struct amdxdna_sched_job *job);
 void amdxdna_hwctx_remove_all(struct amdxdna_client *client);
-void amdxdna_hwctx_suspend(struct amdxdna_client *client);
-void amdxdna_hwctx_resume(struct amdxdna_client *client);
 
 int amdxdna_cmd_submit(struct amdxdna_client *client,
 		       u32 cmd_bo_hdls, u32 *arg_bo_hdls, u32 arg_bo_cnt,
diff --git a/drivers/accel/amdxdna/amdxdna_pci_drv.c b/drivers/accel/amdxdna/amdxdna_pci_drv.c
index f2bf1d374cc70..fbca94183f963 100644
--- a/drivers/accel/amdxdna/amdxdna_pci_drv.c
+++ b/drivers/accel/amdxdna/amdxdna_pci_drv.c
@@ -343,89 +343,29 @@ static void amdxdna_remove(struct pci_dev *pdev)
 	mutex_unlock(&xdna->dev_lock);
 }
 
-static int amdxdna_dev_suspend_nolock(struct amdxdna_dev *xdna)
-{
-	if (xdna->dev_info->ops->suspend)
-		xdna->dev_info->ops->suspend(xdna);
-
-	return 0;
-}
-
-static int amdxdna_dev_resume_nolock(struct amdxdna_dev *xdna)
-{
-	if (xdna->dev_info->ops->resume)
-		return xdna->dev_info->ops->resume(xdna);
-
-	return 0;
-}
-
 static int amdxdna_pmops_suspend(struct device *dev)
 {
 	struct amdxdna_dev *xdna = pci_get_drvdata(to_pci_dev(dev));
-	struct amdxdna_client *client;
-
-	mutex_lock(&xdna->dev_lock);
-	list_for_each_entry(client, &xdna->client_list, node)
-		amdxdna_hwctx_suspend(client);
 
-	amdxdna_dev_suspend_nolock(xdna);
-	mutex_unlock(&xdna->dev_lock);
+	if (!xdna->dev_info->ops->suspend)
+		return -EOPNOTSUPP;
 
-	return 0;
+	return xdna->dev_info->ops->suspend(xdna);
 }
 
 static int amdxdna_pmops_resume(struct device *dev)
 {
 	struct amdxdna_dev *xdna = pci_get_drvdata(to_pci_dev(dev));
-	struct amdxdna_client *client;
-	int ret;
-
-	XDNA_INFO(xdna, "firmware resuming...");
-	mutex_lock(&xdna->dev_lock);
-	ret = amdxdna_dev_resume_nolock(xdna);
-	if (ret) {
-		XDNA_ERR(xdna, "resume NPU firmware failed");
-		mutex_unlock(&xdna->dev_lock);
-		return ret;
-	}
 
-	XDNA_INFO(xdna, "hardware context resuming...");
-	list_for_each_entry(client, &xdna->client_list, node)
-		amdxdna_hwctx_resume(client);
-	mutex_unlock(&xdna->dev_lock);
-
-	return 0;
-}
-
-static int amdxdna_rpmops_suspend(struct device *dev)
-{
-	struct amdxdna_dev *xdna = pci_get_drvdata(to_pci_dev(dev));
-	int ret;
-
-	mutex_lock(&xdna->dev_lock);
-	ret = amdxdna_dev_suspend_nolock(xdna);
-	mutex_unlock(&xdna->dev_lock);
-
-	XDNA_DBG(xdna, "Runtime suspend done ret: %d", ret);
-	return ret;
-}
-
-static int amdxdna_rpmops_resume(struct device *dev)
-{
-	struct amdxdna_dev *xdna = pci_get_drvdata(to_pci_dev(dev));
-	int ret;
-
-	mutex_lock(&xdna->dev_lock);
-	ret = amdxdna_dev_resume_nolock(xdna);
-	mutex_unlock(&xdna->dev_lock);
+	if (!xdna->dev_info->ops->resume)
+		return -EOPNOTSUPP;
 
-	XDNA_DBG(xdna, "Runtime resume done ret: %d", ret);
-	return ret;
+	return xdna->dev_info->ops->resume(xdna);
 }
 
 static const struct dev_pm_ops amdxdna_pm_ops = {
 	SYSTEM_SLEEP_PM_OPS(amdxdna_pmops_suspend, amdxdna_pmops_resume)
-	RUNTIME_PM_OPS(amdxdna_rpmops_suspend, amdxdna_rpmops_resume, NULL)
+	RUNTIME_PM_OPS(amdxdna_pmops_suspend, amdxdna_pmops_resume, NULL)
 };
 
 static struct pci_driver amdxdna_pci_driver = {
diff --git a/drivers/accel/amdxdna/amdxdna_pci_drv.h b/drivers/accel/amdxdna/amdxdna_pci_drv.h
index ab79600911aaa..40bbb3c063203 100644
--- a/drivers/accel/amdxdna/amdxdna_pci_drv.h
+++ b/drivers/accel/amdxdna/amdxdna_pci_drv.h
@@ -50,13 +50,11 @@ struct amdxdna_dev_ops {
 	int (*init)(struct amdxdna_dev *xdna);
 	void (*fini)(struct amdxdna_dev *xdna);
 	int (*resume)(struct amdxdna_dev *xdna);
-	void (*suspend)(struct amdxdna_dev *xdna);
+	int (*suspend)(struct amdxdna_dev *xdna);
 	int (*hwctx_init)(struct amdxdna_hwctx *hwctx);
 	void (*hwctx_fini)(struct amdxdna_hwctx *hwctx);
 	int (*hwctx_config)(struct amdxdna_hwctx *hwctx, u32 type, u64 value, void *buf, u32 size);
 	void (*hmm_invalidate)(struct amdxdna_gem_obj *abo, unsigned long cur_seq);
-	void (*hwctx_suspend)(struct amdxdna_hwctx *hwctx);
-	void (*hwctx_resume)(struct amdxdna_hwctx *hwctx);
 	int (*cmd_submit)(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job, u64 *seq);
 	int (*get_aie_info)(struct amdxdna_client *client, struct amdxdna_drm_get_info *args);
 	int (*set_aie_state)(struct amdxdna_client *client, struct amdxdna_drm_set_state *args);
-- 
2.51.0



