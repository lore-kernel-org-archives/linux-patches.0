Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291F71662E7;
	Mon, 24 Feb 2025 14:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408077; cv=none; b=ZYH8eYnC+5EBt4ZEAC4spOyggyzE/i3SFpgHd/Y3MugwWX82F56m1Rk/RUu8809z+VP+0Zg5yX2oueBm3qJ3Dt7RTpubkvrQib3+ibg476hIa3QT2xzwbdmWEd31yzSIo/q391Z3j8Yc5P1I/5QqbUoie/a42jf0A0w6e89/jbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408077; c=relaxed/simple;
	bh=NSTks1HQtub93u07fdi+auVX+yLYKIDmG8o67Axj6EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYWOlu+ZbMvmjx4WvBDg8lL5k/9X5tHNHCbGSS/s9wN+rOo9s5dQQc+JpfhgrbfJQUPGKYRMyoFmYktpfJh5jK6Rv2ulvf2l1I7USnZKmbzdROQiNZPSms2vpG52Au9UGx0/yDb8yI3zSirBKpYGUMVk2+zrEGawJyJNim4IcPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IN1nb15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IN1nb15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83497C4CED6;
	Mon, 24 Feb 2025 14:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408077;
	bh=NSTks1HQtub93u07fdi+auVX+yLYKIDmG8o67Axj6EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IN1nb15otXyj0g3/usBI+wTKHB30W0fxsbp8SLTAZLcq/CSpjb1VqryWmD49Cfaw
	 FVlEiN+6qjOfSAJdD/tPfSaQ9I9kj4ZMlxoaAZRoJRxUaG4+2U/as+UyslaIIiGGkW
	 Xw4+jTLtj7drlKD9fdPBnwFED9GG9150LDEYDo+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/140] drm/msm/gem: Demote userspace errors to DRM_UT_DRIVER
Date: Mon, 24 Feb 2025 15:34:51 +0100
Message-ID: <20250224142606.629336616@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit b2acb89af1a400be721bcb14f137aa22b509caba ]

Error messages resulting from incorrect usage of the kernel uabi should
not spam dmesg by default.  But it is useful to enable them to debug
userspace.  So demote to DRM_UT_DRIVER.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/564189/
Stable-dep-of: 3a47f4b439be ("drm/msm/gem: prevent integer overflow in msm_ioctl_gem_submit()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.c        |  6 ++---
 drivers/gpu/drm/msm/msm_gem_submit.c | 36 ++++++++++++++++------------
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index db1e748daa753..1113e6b2ec8ec 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -226,9 +226,9 @@ static struct page **msm_gem_pin_pages_locked(struct drm_gem_object *obj,
 
 	msm_gem_assert_locked(obj);
 
-	if (GEM_WARN_ON(msm_obj->madv > madv)) {
-		DRM_DEV_ERROR(obj->dev->dev, "Invalid madv state: %u vs %u\n",
-			msm_obj->madv, madv);
+	if (msm_obj->madv > madv) {
+		DRM_DEV_DEBUG_DRIVER(obj->dev->dev, "Invalid madv state: %u vs %u\n",
+				     msm_obj->madv, madv);
 		return ERR_PTR(-EBUSY);
 	}
 
diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 99744de6c05a1..207b6ba1565d8 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -17,6 +17,12 @@
 #include "msm_gem.h"
 #include "msm_gpu_trace.h"
 
+/* For userspace errors, use DRM_UT_DRIVER.. so that userspace can enable
+ * error msgs for debugging, but we don't spam dmesg by default
+ */
+#define SUBMIT_ERROR(submit, fmt, ...) \
+	DRM_DEV_DEBUG_DRIVER((submit)->dev->dev, fmt, ##__VA_ARGS__)
+
 /*
  * Cmdstream submission:
  */
@@ -136,7 +142,7 @@ static int submit_lookup_objects(struct msm_gem_submit *submit,
 
 		if ((submit_bo.flags & ~MSM_SUBMIT_BO_FLAGS) ||
 			!(submit_bo.flags & MANDATORY_FLAGS)) {
-			DRM_ERROR("invalid flags: %x\n", submit_bo.flags);
+			SUBMIT_ERROR(submit, "invalid flags: %x\n", submit_bo.flags);
 			ret = -EINVAL;
 			i = 0;
 			goto out;
@@ -158,7 +164,7 @@ static int submit_lookup_objects(struct msm_gem_submit *submit,
 		 */
 		obj = idr_find(&file->object_idr, submit->bos[i].handle);
 		if (!obj) {
-			DRM_ERROR("invalid handle %u at index %u\n", submit->bos[i].handle, i);
+			SUBMIT_ERROR(submit, "invalid handle %u at index %u\n", submit->bos[i].handle, i);
 			ret = -EINVAL;
 			goto out_unlock;
 		}
@@ -202,13 +208,13 @@ static int submit_lookup_cmds(struct msm_gem_submit *submit,
 		case MSM_SUBMIT_CMD_CTX_RESTORE_BUF:
 			break;
 		default:
-			DRM_ERROR("invalid type: %08x\n", submit_cmd.type);
+			SUBMIT_ERROR(submit, "invalid type: %08x\n", submit_cmd.type);
 			return -EINVAL;
 		}
 
 		if (submit_cmd.size % 4) {
-			DRM_ERROR("non-aligned cmdstream buffer size: %u\n",
-					submit_cmd.size);
+			SUBMIT_ERROR(submit, "non-aligned cmdstream buffer size: %u\n",
+				     submit_cmd.size);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -306,8 +312,8 @@ static int submit_lock_objects(struct msm_gem_submit *submit)
 
 fail:
 	if (ret == -EALREADY) {
-		DRM_ERROR("handle %u at index %u already on submit list\n",
-				submit->bos[i].handle, i);
+		SUBMIT_ERROR(submit, "handle %u at index %u already on submit list\n",
+			     submit->bos[i].handle, i);
 		ret = -EINVAL;
 	}
 
@@ -448,8 +454,8 @@ static int submit_bo(struct msm_gem_submit *submit, uint32_t idx,
 		struct drm_gem_object **obj, uint64_t *iova, bool *valid)
 {
 	if (idx >= submit->nr_bos) {
-		DRM_ERROR("invalid buffer index: %u (out of %u)\n",
-				idx, submit->nr_bos);
+		SUBMIT_ERROR(submit, "invalid buffer index: %u (out of %u)\n",
+			     idx, submit->nr_bos);
 		return -EINVAL;
 	}
 
@@ -475,7 +481,7 @@ static int submit_reloc(struct msm_gem_submit *submit, struct drm_gem_object *ob
 		return 0;
 
 	if (offset % 4) {
-		DRM_ERROR("non-aligned cmdstream buffer: %u\n", offset);
+		SUBMIT_ERROR(submit, "non-aligned cmdstream buffer: %u\n", offset);
 		return -EINVAL;
 	}
 
@@ -497,8 +503,8 @@ static int submit_reloc(struct msm_gem_submit *submit, struct drm_gem_object *ob
 		bool valid;
 
 		if (submit_reloc.submit_offset % 4) {
-			DRM_ERROR("non-aligned reloc offset: %u\n",
-					submit_reloc.submit_offset);
+			SUBMIT_ERROR(submit, "non-aligned reloc offset: %u\n",
+				     submit_reloc.submit_offset);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -508,7 +514,7 @@ static int submit_reloc(struct msm_gem_submit *submit, struct drm_gem_object *ob
 
 		if ((off >= (obj->size / 4)) ||
 				(off < last_offset)) {
-			DRM_ERROR("invalid offset %u at reloc %u\n", off, i);
+			SUBMIT_ERROR(submit, "invalid offset %u at reloc %u\n", off, i);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -881,7 +887,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 		if (!submit->cmd[i].size ||
 			((submit->cmd[i].size + submit->cmd[i].offset) >
 				obj->size / 4)) {
-			DRM_ERROR("invalid cmdstream size: %u\n", submit->cmd[i].size * 4);
+			SUBMIT_ERROR(submit, "invalid cmdstream size: %u\n", submit->cmd[i].size * 4);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -893,7 +899,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 
 		if (!gpu->allow_relocs) {
 			if (submit->cmd[i].nr_relocs) {
-				DRM_ERROR("relocs not allowed\n");
+				SUBMIT_ERROR(submit, "relocs not allowed\n");
 				ret = -EINVAL;
 				goto out;
 			}
-- 
2.39.5



