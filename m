Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E256B18EFD0;
	Tue, 10 Sep 2024 09:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961488; cv=none; b=HAk7X+QHl8k8VyrMTieILJct+azPiM2xPnWJnz6GrgeGhRmoLhNQ3+1CyC39BhfbLsV+2Vg8cXDlE/4LW2qH3g7g4o5q0cckthJso8mmPIND8ucgK7iqC2NT06wC8gNEZFB+k/53d0erf121Jezmp5IUF98zEu3icYHCbnhkvSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961488; c=relaxed/simple;
	bh=tATs/HsfxgIgk7Q2H3WNtpY5890URn2hyVIGkFJXfgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERO2bMKhd2UlXPqs7KE4w8HcajtTGjqFnNvU68VLQ2GscejbtXnzq33XidDO6naYW4fmzd8dIZdRpzKGrF3Q7L+D9vBt4u/ti+Qom10cEgWcUzeDykqEXmxzlkUI9fMFr9GjfX038RDZ1+QWptLI1N/3d98Tb5CESHIqoQm71kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQTTqjRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQTTqjRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD96C4CEC6;
	Tue, 10 Sep 2024 09:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961487;
	bh=tATs/HsfxgIgk7Q2H3WNtpY5890URn2hyVIGkFJXfgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQTTqjRHRJKLZHGZSuw5H85ILh/hQQlaZBp7lumzRE98+EA2dTX6PqpyiZmjBN0Kb
	 TRT1bS1eSdNhjsjlm8OZKdnPbvkBOIeIbAbFyudw2bswHkqVuw86UieAf7BrU4vvM6
	 AX64G06FKsDXrHs3stqsOInlmUv1TZpdybuTyM78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mary Guillemard <mary.guillemard@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 6.10 087/375] drm/panthor: Restrict high priorities on group_create
Date: Tue, 10 Sep 2024 11:28:04 +0200
Message-ID: <20240910092625.158870965@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mary Guillemard <mary.guillemard@collabora.com>

commit 5f7762042f8a5377bd8a32844db353c0311a7369 upstream.

We were allowing any users to create a high priority group without any
permission checks. As a result, this was allowing possible denial of
service.

We now only allow the DRM master or users with the CAP_SYS_NICE
capability to set higher priorities than PANTHOR_GROUP_PRIORITY_MEDIUM.

As the sole user of that uAPI lives in Mesa and hardcode a value of
MEDIUM [1], this should be safe to do.

Additionally, as those checks are performed at the ioctl level,
panthor_group_create now only check for priority level validity.

[1]https://gitlab.freedesktop.org/mesa/mesa/-/blob/f390835074bdf162a63deb0311d1a6de527f9f89/src/gallium/drivers/panfrost/pan_csf.c#L1038

Signed-off-by: Mary Guillemard <mary.guillemard@collabora.com>
Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Cc: stable@vger.kernel.org
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240903144955.144278-2-mary.guillemard@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_drv.c   | 23 +++++++++++++++++++++++
 drivers/gpu/drm/panthor/panthor_sched.c |  2 +-
 include/uapi/drm/panthor_drm.h          |  6 +++++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/panthor/panthor_drv.c
index b5e7b919f241..34182f67136c 100644
--- a/drivers/gpu/drm/panthor/panthor_drv.c
+++ b/drivers/gpu/drm/panthor/panthor_drv.c
@@ -10,6 +10,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 
+#include <drm/drm_auth.h>
 #include <drm/drm_debugfs.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_exec.h>
@@ -996,6 +997,24 @@ static int panthor_ioctl_group_destroy(struct drm_device *ddev, void *data,
 	return panthor_group_destroy(pfile, args->group_handle);
 }
 
+static int group_priority_permit(struct drm_file *file,
+				 u8 priority)
+{
+	/* Ensure that priority is valid */
+	if (priority > PANTHOR_GROUP_PRIORITY_HIGH)
+		return -EINVAL;
+
+	/* Medium priority and below are always allowed */
+	if (priority <= PANTHOR_GROUP_PRIORITY_MEDIUM)
+		return 0;
+
+	/* Higher priorities require CAP_SYS_NICE or DRM_MASTER */
+	if (capable(CAP_SYS_NICE) || drm_is_current_master(file))
+		return 0;
+
+	return -EACCES;
+}
+
 static int panthor_ioctl_group_create(struct drm_device *ddev, void *data,
 				      struct drm_file *file)
 {
@@ -1011,6 +1030,10 @@ static int panthor_ioctl_group_create(struct drm_device *ddev, void *data,
 	if (ret)
 		return ret;
 
+	ret = group_priority_permit(file, args->priority);
+	if (ret)
+		return ret;
+
 	ret = panthor_group_create(pfile, args, queue_args);
 	if (ret >= 0) {
 		args->group_handle = ret;
diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 463bcd3cf00f..12b272a912f8 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3092,7 +3092,7 @@ int panthor_group_create(struct panthor_file *pfile,
 	if (group_args->pad)
 		return -EINVAL;
 
-	if (group_args->priority > PANTHOR_CSG_PRIORITY_HIGH)
+	if (group_args->priority >= PANTHOR_CSG_PRIORITY_COUNT)
 		return -EINVAL;
 
 	if ((group_args->compute_core_mask & ~ptdev->gpu_info.shader_present) ||
diff --git a/include/uapi/drm/panthor_drm.h b/include/uapi/drm/panthor_drm.h
index 926b1deb1116..e23a7f9b0eac 100644
--- a/include/uapi/drm/panthor_drm.h
+++ b/include/uapi/drm/panthor_drm.h
@@ -692,7 +692,11 @@ enum drm_panthor_group_priority {
 	/** @PANTHOR_GROUP_PRIORITY_MEDIUM: Medium priority group. */
 	PANTHOR_GROUP_PRIORITY_MEDIUM,
 
-	/** @PANTHOR_GROUP_PRIORITY_HIGH: High priority group. */
+	/**
+	 * @PANTHOR_GROUP_PRIORITY_HIGH: High priority group.
+	 *
+	 * Requires CAP_SYS_NICE or DRM_MASTER.
+	 */
 	PANTHOR_GROUP_PRIORITY_HIGH,
 };
 
-- 
2.46.0



