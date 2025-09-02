Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF99299AB5;
	Tue,  2 Sep 2025 13:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820391; cv=none; b=aFu82FvYphNfPiK9K8nzYGOQdOQj8eSItJYF/nk/6uUwjBM7TsiLpK5ap7WTXcWqA3szhJkth2kWyyequFOaEVyqoFJB8IRc51/ceUFRxtsu7LZj1xyYhjjPrfs9E71sQQvQQtJfPKx+PRlUVxXFv0jEgQuCaEsZHhwUlHhc6ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820391; c=relaxed/simple;
	bh=nXKqovRkPiLuaqi+mVHsPbRNOK42VprMGDrz2m8YzGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOm7RMECDpxmaSZhagkF9b7YFbS5YamCmKyU98dvqwjlnrqlwT6dly2Jp78StyHYq88D8Z/HBiprQsfQsLFV2MH3sXRQPxTMoWlrcLfhZQXKXPr6gcCOFG3vOliF9JtuwpdYWbKJugsLvo2hDLjIL2DkEja0QdILdQssWC3QGjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2el5vGrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2el5vGrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B438FC4CEED;
	Tue,  2 Sep 2025 13:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820391;
	bh=nXKqovRkPiLuaqi+mVHsPbRNOK42VprMGDrz2m8YzGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2el5vGrbL4dPWemoAMVmyygdSvF+2XVSRi1W519GwA549sfTo3Cg29BAsJtNqJGVg
	 wyvK55XHz8p6xSgMBfnv4+aTJQFX3t7esc3NjCqwXlwjGEylKJfLa85SGh5eTENrba
	 zRRGaphBsZ9+gcUrdsuFGMZXc+K2MqQMjP0zP7hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/50] drm/msm: Defer fd_install in SUBMIT ioctl
Date: Tue,  2 Sep 2025 15:21:05 +0200
Message-ID: <20250902131931.081836482@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 572dd662e8095..6a02f790624a9 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -929,12 +929,8 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 
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
@@ -959,10 +955,14 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
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



