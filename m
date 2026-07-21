Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E2B1F3D56;
	Tue, 21 Jul 2026 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653818; cv=none; b=BxR7e+JmUTEiL5G2CDCS3ObrVC9ZYOHkQKy0Ii4w65GAGOtvHukPEcMEV7+JzfgqOBvKwJ3hnZx2CrDjNy19j4hZw9lugIsL1ptIdpTujy5QZSAahb6Q2UbC73gvUDvG4VkbbtcjOrlhUDifT+sSbpgBACCj5w5o/hwQUVRQpB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653818; c=relaxed/simple;
	bh=oLFlwiEwY44OoS8kZK71LpVKBdCawkPazrxzYndfw9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Whm06N28HZ+LoszXGhL8TVJzhyV5hIWKYCbEYgQqfumNloWZ0Hs6KtsCocATwI1tvXxSlh1P6CDbrs33U7ZGoNf6e5pQ5diwtr2L+VU0VABp0MJUHadlitvcQhw9k6SlfoHn7Db/gNaCkIeSrIOgltjkIA9x56p2ePICplHC5aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmyLVSVO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmyLVSVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306361F000E9;
	Tue, 21 Jul 2026 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653816;
	bh=VNTpzKlsxkRfXsiwHlVL5hL/33WSTp7SZ7mIhGPPUPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmyLVSVOHjXyQ3urXGm6YnH6Ez95+KzAReqRTZcE4gwCJb3CYSJWKtDLok3UCNRSV
	 xfvPw/hrubHPK3tEJz85+zG4uxKU0zeKMQIZIKorVEnwA8G2Xk3Fcc0Ean0dxQc1gT
	 FDo6la9yoKMwrJqyTqVrY/ZZjoKZS7VWdR6MajWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1468/2077] accel/amdxdna: Prevent PM resume deadlock in hwctx_sync_debug_bo()
Date: Tue, 21 Jul 2026 17:19:01 +0200
Message-ID: <20260721152627.420367440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit e35c9cf5512814fb04f369f2eada64f0a7164609 ]

amdxdna_hwctx_sync_debug_bo() invokes the hardware hwctx_sync_debug_bo()
callback while holding xdna->dev_lock.

The callback may call amdxdna_cmd_submit(), which in turn calls
amdxdna_pm_resume_get(). If the device is suspended,
amdxdna_pm_resume_get() may synchronously execute amdxdna_pm_resume(),
which also acquires xdna->dev_lock, resulting in a deadlock.

Avoid the deadlock by calling amdxdna_pm_resume_get() before holding
xdna->dev_lock in both amdxdna_hwctx_sync_debug_bo() and
amdxdna_drm_config_hwctx_ioctl()

Fixes: 7ea046838021 ("accel/amdxdna: Support firmware debug buffer")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260616212429.3620645-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c    |  2 +-
 drivers/accel/amdxdna/amdxdna_ctx.c | 26 ++++++++++++++++++++++----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 93535806e72a1b..f5d247d65cb065 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -815,7 +815,7 @@ static int aie2_hwctx_cu_config(struct amdxdna_hwctx *hwctx, void *buf, u32 size
 	if (!hwctx->cus)
 		return -ENOMEM;
 
-	ret = amdxdna_pm_resume_get_locked(xdna);
+	ret = amdxdna_pm_resume_get(xdna);
 	if (ret)
 		goto free_cus;
 
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index ff6c3e8e5a15b8..2ab4443e709462 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -356,16 +356,25 @@ int amdxdna_drm_config_hwctx_ioctl(struct drm_device *dev, void *data, struct dr
 		return -EINVAL;
 	}
 
-	guard(mutex)(&xdna->dev_lock);
+	ret = amdxdna_pm_resume_get(xdna);
+	if (ret) {
+		XDNA_ERR(xdna, "Resume failed, ret %d", ret);
+		goto free_buf;
+	}
+
+	mutex_lock(&xdna->dev_lock);
 	hwctx = xa_load(&client->hwctx_xa, args->handle);
 	if (!hwctx) {
 		XDNA_DBG(xdna, "PID %d failed to get hwctx %d", client->pid, args->handle);
 		ret = -EINVAL;
-		goto free_buf;
+		goto unlock;
 	}
 
 	ret = xdna->dev_info->ops->hwctx_config(hwctx, args->param_type, val, buf, buf_size);
 
+unlock:
+	mutex_unlock(&xdna->dev_lock);
+	amdxdna_pm_suspend_put(xdna);
 free_buf:
 	kfree(buf);
 	return ret;
@@ -386,16 +395,25 @@ int amdxdna_hwctx_sync_debug_bo(struct amdxdna_client *client, u32 debug_bo_hdl)
 	if (!gobj)
 		return -EINVAL;
 
+	ret = amdxdna_pm_resume_get(xdna);
+	if (ret) {
+		XDNA_ERR(xdna, "Resume failed, ret %d", ret);
+		goto put_obj;
+	}
+
 	abo = to_xdna_obj(gobj);
-	guard(mutex)(&xdna->dev_lock);
+	mutex_lock(&xdna->dev_lock);
 	hwctx = xa_load(&client->hwctx_xa, abo->assigned_hwctx);
 	if (!hwctx) {
 		ret = -EINVAL;
-		goto put_obj;
+		goto unlock;
 	}
 
 	ret = xdna->dev_info->ops->hwctx_sync_debug_bo(hwctx, debug_bo_hdl);
 
+unlock:
+	mutex_unlock(&xdna->dev_lock);
+	amdxdna_pm_suspend_put(xdna);
 put_obj:
 	drm_gem_object_put(gobj);
 	return ret;
-- 
2.53.0



