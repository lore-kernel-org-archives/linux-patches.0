Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337693859DC;
	Tue, 10 Mar 2026 11:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140799; cv=none; b=ps3NR1x6YOHkQTci1hp3zCmSu2Z0ekQovWQtiGYaeMiEUNp7MTMVxNi5ZiUhQ24qz/tGrhIff8rascM5TSTvxMcab0ZGlDfx/vlTuODCdW/CG9NXOCjVr1+p7QW5vZlhGHXI4vDKvm/PzyQrpImbYiNcPBGFCIybF4ThS9gpzOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140799; c=relaxed/simple;
	bh=a9QWAAALZY7x3Udjj6t3TmtW++LrTK12M+j5Agm7YH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPfn40KjiiV9cwuq/I9lZp8nJHqzVanYXze8v29RE4/kdw1AIADzstkDppioeJS7ZLD7KDcSvyDTnm2kbByqCfo+tYbmTuOhiOjgKwayrSEh/JBBjweBeqQuMpqm75uCw3aqBOq9DtxBUukf46ZpBat79KTN7omR17LsCDNo488=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGRnDVbh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGRnDVbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8021BC19423;
	Tue, 10 Mar 2026 11:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140799;
	bh=a9QWAAALZY7x3Udjj6t3TmtW++LrTK12M+j5Agm7YH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGRnDVbhVYNXxQHRGOS3HV4S6BhnXYbtMdVJub7w91MIh8qyFZpn7VAqKoef0N07W
	 TzVtg98Y4WEmT+Vukc0tM0zXKCoiNFSGntrtRzNtph1JI05Jy4pNyQnPPwvevf/jVd
	 O74bvb4B8m2rhIOUtDgmgaUSqwsdrJOa6e2e19RKjQ5VskbYu9sWRU9lk2Sau7eLX7
	 3KnFmAtPO6gWqpqOTDdoiIgYOopibT34dO9n/fnOrk1Ptl0DNjMvqXWv/f8F2acyws
	 Bi0jpMOi3k0N8/rTybJpKGzkulbnPOOK73qEB1VJcMDQsB6bAMMnVJ8Zq6/fVHIPNA
	 qYFRx3obzdz6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Hou <lizhi.hou@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 036/311] accel/amdxdna: Fix dead lock for suspend and resume
Date: Tue, 10 Mar 2026 07:01:23 -0400
Message-ID: <0a8539724b3887ee9c8195b49336ad49287862e3.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 1aa82181a3c285c7351523d587f7981ae4c015c8 ]

When an application issues a query IOCTL while auto suspend is running,
a deadlock can occur. The query path holds dev_lock and then calls
pm_runtime_resume_and_get(), which waits for the ongoing suspend to
complete. Meanwhile, the suspend callback attempts to acquire dev_lock
and blocks, resulting in a deadlock.

Fix this by releasing dev_lock before calling pm_runtime_resume_and_get()
and reacquiring it after the call completes. Also acquire dev_lock in the
resume callback to keep the locking consistent.

Fixes: 063db451832b ("accel/amdxdna: Enhance runtime power management")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260211204644.722758-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c    |  4 ++--
 drivers/accel/amdxdna/aie2_pci.c    |  7 +++----
 drivers/accel/amdxdna/aie2_pm.c     |  2 +-
 drivers/accel/amdxdna/amdxdna_ctx.c | 19 +++++++------------
 drivers/accel/amdxdna/amdxdna_pm.c  |  2 ++
 drivers/accel/amdxdna/amdxdna_pm.h  | 11 +++++++++++
 6 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index a3bb37543f73d..1dcf6e862656d 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -629,7 +629,7 @@ int aie2_hwctx_init(struct amdxdna_hwctx *hwctx)
 		goto free_entity;
 	}
 
-	ret = amdxdna_pm_resume_get(xdna);
+	ret = amdxdna_pm_resume_get_locked(xdna);
 	if (ret)
 		goto free_col_list;
 
@@ -760,7 +760,7 @@ static int aie2_hwctx_cu_config(struct amdxdna_hwctx *hwctx, void *buf, u32 size
 	if (!hwctx->cus)
 		return -ENOMEM;
 
-	ret = amdxdna_pm_resume_get(xdna);
+	ret = amdxdna_pm_resume_get_locked(xdna);
 	if (ret)
 		goto free_cus;
 
diff --git a/drivers/accel/amdxdna/aie2_pci.c b/drivers/accel/amdxdna/aie2_pci.c
index ec1c3ad57d490..20568d0f9a639 100644
--- a/drivers/accel/amdxdna/aie2_pci.c
+++ b/drivers/accel/amdxdna/aie2_pci.c
@@ -469,7 +469,6 @@ static int aie2_hw_suspend(struct amdxdna_dev *xdna)
 {
 	struct amdxdna_client *client;
 
-	guard(mutex)(&xdna->dev_lock);
 	list_for_each_entry(client, &xdna->client_list, node)
 		aie2_hwctx_suspend(client);
 
@@ -969,7 +968,7 @@ static int aie2_get_info(struct amdxdna_client *client, struct amdxdna_drm_get_i
 	if (!drm_dev_enter(&xdna->ddev, &idx))
 		return -ENODEV;
 
-	ret = amdxdna_pm_resume_get(xdna);
+	ret = amdxdna_pm_resume_get_locked(xdna);
 	if (ret)
 		goto dev_exit;
 
@@ -1062,7 +1061,7 @@ static int aie2_get_array(struct amdxdna_client *client,
 	if (!drm_dev_enter(&xdna->ddev, &idx))
 		return -ENODEV;
 
-	ret = amdxdna_pm_resume_get(xdna);
+	ret = amdxdna_pm_resume_get_locked(xdna);
 	if (ret)
 		goto dev_exit;
 
@@ -1152,7 +1151,7 @@ static int aie2_set_state(struct amdxdna_client *client,
 	if (!drm_dev_enter(&xdna->ddev, &idx))
 		return -ENODEV;
 
-	ret = amdxdna_pm_resume_get(xdna);
+	ret = amdxdna_pm_resume_get_locked(xdna);
 	if (ret)
 		goto dev_exit;
 
diff --git a/drivers/accel/amdxdna/aie2_pm.c b/drivers/accel/amdxdna/aie2_pm.c
index 579b8be13b180..29bd4403a94d4 100644
--- a/drivers/accel/amdxdna/aie2_pm.c
+++ b/drivers/accel/amdxdna/aie2_pm.c
@@ -31,7 +31,7 @@ int aie2_pm_set_dpm(struct amdxdna_dev_hdl *ndev, u32 dpm_level)
 {
 	int ret;
 
-	ret = amdxdna_pm_resume_get(ndev->xdna);
+	ret = amdxdna_pm_resume_get_locked(ndev->xdna);
 	if (ret)
 		return ret;
 
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index d17aef89a0add..db3aa26fb55f0 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -266,9 +266,9 @@ int amdxdna_drm_config_hwctx_ioctl(struct drm_device *dev, void *data, struct dr
 	struct amdxdna_drm_config_hwctx *args = data;
 	struct amdxdna_dev *xdna = to_xdna_dev(dev);
 	struct amdxdna_hwctx *hwctx;
-	int ret, idx;
 	u32 buf_size;
 	void *buf;
+	int ret;
 	u64 val;
 
 	if (XDNA_MBZ_DBG(xdna, &args->pad, sizeof(args->pad)))
@@ -310,20 +310,17 @@ int amdxdna_drm_config_hwctx_ioctl(struct drm_device *dev, void *data, struct dr
 		return -EINVAL;
 	}
 
-	mutex_lock(&xdna->dev_lock);
-	idx = srcu_read_lock(&client->hwctx_srcu);
+	guard(mutex)(&xdna->dev_lock);
 	hwctx = xa_load(&client->hwctx_xa, args->handle);
 	if (!hwctx) {
 		XDNA_DBG(xdna, "PID %d failed to get hwctx %d", client->pid, args->handle);
 		ret = -EINVAL;
-		goto unlock_srcu;
+		goto free_buf;
 	}
 
 	ret = xdna->dev_info->ops->hwctx_config(hwctx, args->param_type, val, buf, buf_size);
 
-unlock_srcu:
-	srcu_read_unlock(&client->hwctx_srcu, idx);
-	mutex_unlock(&xdna->dev_lock);
+free_buf:
 	kfree(buf);
 	return ret;
 }
@@ -334,7 +331,7 @@ int amdxdna_hwctx_sync_debug_bo(struct amdxdna_client *client, u32 debug_bo_hdl)
 	struct amdxdna_hwctx *hwctx;
 	struct amdxdna_gem_obj *abo;
 	struct drm_gem_object *gobj;
-	int ret, idx;
+	int ret;
 
 	if (!xdna->dev_info->ops->hwctx_sync_debug_bo)
 		return -EOPNOTSUPP;
@@ -345,17 +342,15 @@ int amdxdna_hwctx_sync_debug_bo(struct amdxdna_client *client, u32 debug_bo_hdl)
 
 	abo = to_xdna_obj(gobj);
 	guard(mutex)(&xdna->dev_lock);
-	idx = srcu_read_lock(&client->hwctx_srcu);
 	hwctx = xa_load(&client->hwctx_xa, abo->assigned_hwctx);
 	if (!hwctx) {
 		ret = -EINVAL;
-		goto unlock_srcu;
+		goto put_obj;
 	}
 
 	ret = xdna->dev_info->ops->hwctx_sync_debug_bo(hwctx, debug_bo_hdl);
 
-unlock_srcu:
-	srcu_read_unlock(&client->hwctx_srcu, idx);
+put_obj:
 	drm_gem_object_put(gobj);
 	return ret;
 }
diff --git a/drivers/accel/amdxdna/amdxdna_pm.c b/drivers/accel/amdxdna/amdxdna_pm.c
index d024d480521c4..b1fafddd7ad59 100644
--- a/drivers/accel/amdxdna/amdxdna_pm.c
+++ b/drivers/accel/amdxdna/amdxdna_pm.c
@@ -16,6 +16,7 @@ int amdxdna_pm_suspend(struct device *dev)
 	struct amdxdna_dev *xdna = to_xdna_dev(dev_get_drvdata(dev));
 	int ret = -EOPNOTSUPP;
 
+	guard(mutex)(&xdna->dev_lock);
 	if (xdna->dev_info->ops->suspend)
 		ret = xdna->dev_info->ops->suspend(xdna);
 
@@ -28,6 +29,7 @@ int amdxdna_pm_resume(struct device *dev)
 	struct amdxdna_dev *xdna = to_xdna_dev(dev_get_drvdata(dev));
 	int ret = -EOPNOTSUPP;
 
+	guard(mutex)(&xdna->dev_lock);
 	if (xdna->dev_info->ops->resume)
 		ret = xdna->dev_info->ops->resume(xdna);
 
diff --git a/drivers/accel/amdxdna/amdxdna_pm.h b/drivers/accel/amdxdna/amdxdna_pm.h
index 77b2d6e455700..3d26b973e0e36 100644
--- a/drivers/accel/amdxdna/amdxdna_pm.h
+++ b/drivers/accel/amdxdna/amdxdna_pm.h
@@ -15,4 +15,15 @@ void amdxdna_pm_suspend_put(struct amdxdna_dev *xdna);
 void amdxdna_pm_init(struct amdxdna_dev *xdna);
 void amdxdna_pm_fini(struct amdxdna_dev *xdna);
 
+static inline int amdxdna_pm_resume_get_locked(struct amdxdna_dev *xdna)
+{
+	int ret;
+
+	mutex_unlock(&xdna->dev_lock);
+	ret = amdxdna_pm_resume_get(xdna);
+	mutex_lock(&xdna->dev_lock);
+
+	return ret;
+}
+
 #endif /* _AMDXDNA_PM_H_ */
-- 
2.51.0

