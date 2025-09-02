Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC9F30C340;
	Tue,  2 Sep 2025 13:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819517; cv=none; b=cnPE535E2b5SJn3MCtIhXwsoJmNfQxkK1RGSVAdZNDQS4N8dXWujhe17vV1spBhsmZru61RuOyYffUlFRGBixM6fkO5DXvoTd7ElQ71NWUuY3OaQw59XC8SGORABk/kffcbhfFDf64r/E1nrZVy33YXpBSLlDaRS2rz0SHF3jmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819517; c=relaxed/simple;
	bh=wXaJrauoNEKZ9FXa6JkqKlkKpEey+Vg/b4rsM2Pk5PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdh34QGw1Lwn5X3QngMXRzUakhWeHFH8Q36lqGwHpO2yde+GJteMJCcX8AimsOmKbnV4WuBHuzok3hWmCNwQmLd49QCRKzgpE03VSVA2y/7yUbGwomkgi/q9v563YurxdeG5ULQv+WZ5LdFezfiJ4DMBcuZSxb+PFCqWHAYc1ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xq0XXKLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xq0XXKLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEF5C4CEED;
	Tue,  2 Sep 2025 13:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819513;
	bh=wXaJrauoNEKZ9FXa6JkqKlkKpEey+Vg/b4rsM2Pk5PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xq0XXKLhXyvvZuLi/euvjyy6y3Mq8EEG0mtUpD9IJnBkqKhlGHveFw+cnWYpCcNFx
	 WFOh/7lci/5PJ27M+IvSNvDEQqYbf1MPr4l/DWPTwfuTzBuFkxDZDSbWnVBAd7wmTC
	 S38VauA+Cjfg1ejmPWRsGeq8Gwe2j+1dJnyesGEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 029/142] drm/msm: Defer fd_install in SUBMIT ioctl
Date: Tue,  2 Sep 2025 15:18:51 +0200
Message-ID: <20250902131949.260702128@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d4f71bb54e84c..081d59979e31d 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -869,12 +869,8 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 
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
 
 	if (ret)
@@ -902,10 +898,14 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
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



