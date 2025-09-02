Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243372D9ECA;
	Tue,  2 Sep 2025 13:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820162; cv=none; b=PT6Iom5/6vSs9fkSTYFek9k+kRn6lf25NetGmBP/Udi4rygVdmxRunMQvYThOY3mpn6rA7bM3P5Ikltv2gtutMASADLxc/RTMZvmJx1GQCyvx0/Fjf+OsAENXuXYyA02jfXE6W99d0pwEgBL1Dz16HJ3lu0EyRHz9ane8js9biM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820162; c=relaxed/simple;
	bh=ZQuoZ3hcDlXNFq/bskgGNkr5OgjjUeKcI6LgVOM02Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiC8/fKLMQiUqIdZPV3jBLwz0OuCULC00NdQ5Mt3ufMCOMkmSknfnTTP63aUGU8dmPVywtZdvWyIabfYGhGu4AZQ6Y6RqV2+tlqXtK9TryvyJ7aP9HzEfFTUXcfLKxwNo28X73RChryFyPd6ckXZgrUiIedEuwmOdm9fQu7ltfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSlYn5MT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSlYn5MT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87655C4CEF5;
	Tue,  2 Sep 2025 13:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820162;
	bh=ZQuoZ3hcDlXNFq/bskgGNkr5OgjjUeKcI6LgVOM02Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSlYn5MT/sIPlIUPH+4U/ujiaXqcVijRtKhdUWLPsitfj0cIeiFGSB33XST+2z+Wh
	 A+6m0/zzGP0cPEDJij+QpeOqqDkPjSR/JswlBq9lghEEcq/0oUNmNNl1rOsa9zl+lw
	 N3GprR24RL1akXshabNyMMUn/C7ocVHvbUtgSUc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 18/75] drm/msm: Defer fd_install in SUBMIT ioctl
Date: Tue,  2 Sep 2025 15:20:30 +0200
Message-ID: <20250902131935.828698098@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit f22853435bbd1e9836d0dce7fd99c040b94c2bf1 ]

Avoid fd_install() until there are no more potential error paths, to
avoid put_unused_fd() after the fd is made visible to userspace.

Fixes: 68dc6c2d5eec ("drm/msm: Fix submit error-path leaks")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/665363/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index bbe4f1665b603..dc142f9e4f602 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -981,12 +981,8 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 
 	if (ret == 0 && args->flags & MSM_SUBMIT_FENCE_FD_OUT) {
 		sync_file = sync_file_create(submit->user_fence);
-		if (!sync_file) {
+		if (!sync_file)
 			ret = -ENOMEM;
-		} else {
-			fd_install(out_fence_fd, sync_file->file);
-			args->fence_fd = out_fence_fd;
-		}
 	}
 
 	submit_attach_object_fences(submit);
@@ -1013,10 +1009,14 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 out_unlock:
 	mutex_unlock(&queue->lock);
 out_post_unlock:
-	if (ret && (out_fence_fd >= 0)) {
-		put_unused_fd(out_fence_fd);
+	if (ret) {
+		if (out_fence_fd >= 0)
+			put_unused_fd(out_fence_fd);
 		if (sync_file)
 			fput(sync_file->file);
+	} else if (sync_file) {
+		fd_install(out_fence_fd, sync_file->file);
+		args->fence_fd = out_fence_fd;
 	}
 
 	if (!IS_ERR_OR_NULL(submit)) {
-- 
2.50.1



