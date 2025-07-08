Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351497263B;
	Tue,  8 Jul 2025 17:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994104; cv=none; b=q7B7Z3YrXWXwxs+GpzUIyTrsN6Y1cKTZjQ7qXWbkqinQyaQFCZNC7YWTpUVWJF0wfO1WdIHlP1PtBXfrbdROCIk6EHwny0ualRBtHMx2C/uCTKaOGBVFGQnifH5Jge3bpfIh87yp1byaTgG23hKQJ7RTzBThSdjaYHDnpqkp2CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994104; c=relaxed/simple;
	bh=vvyi3tLR3ihBsbFTY0ow0LDcGZAQtKytrFFW28AXG6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEOX4J+7egRPGmHu05PO9t8yQHKwqlFQJhY/Ee3m2amiQ4Obt7E/5r29vxirs71oaWVJLbG+yDErRshveu7ypxq3N/5S+mJfuAkGBhG8xJhD7NVHymn9J3FUBTTLq6F3PNPpvqB8njDsi5uVVY8b5Gzv0W3/xKGwvtxXhMtZtZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDL5rfWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDL5rfWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36A5C4CEF5;
	Tue,  8 Jul 2025 17:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994104;
	bh=vvyi3tLR3ihBsbFTY0ow0LDcGZAQtKytrFFW28AXG6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDL5rfWMHC+dlVyRnsylkjLZrlefmbgVJpUxgevfEQeSjQ7x8hcC7w0J3x4SUWdRU
	 rKWdPm1mGJTpRLeTQJzgD9aYLrvzII7QVFsX0cOrqWmwnyGnLu0Xuw10SxXSoZBGc9
	 FnHRtwFsoNxe0Cog9HSJeFeVrh+441o/yyrqfdqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/160] drm/msm: Fix a fence leak in submit error path
Date: Tue,  8 Jul 2025 18:22:43 +0200
Message-ID: <20250708162234.912744957@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 5d319f75ccf7f0927425a7545aa1a22b3eedc189 ]

In error paths, we could unref the submit without calling
drm_sched_entity_push_job(), so msm_job_free() will never get
called.  Since drm_sched_job_cleanup() will NULL out the
s_fence, we can use that to detect this case.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/653584/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index fc2fb1019ea1c..2ffb2ca88ffe1 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -76,6 +76,15 @@ void __msm_gem_submit_destroy(struct kref *kref)
 	struct dma_fence *fence;
 	unsigned i;
 
+	/*
+	 * In error paths, we could unref the submit without calling
+	 * drm_sched_entity_push_job(), so msm_job_free() will never
+	 * get called.  Since drm_sched_job_cleanup() will NULL out
+	 * s_fence, we can use that to detect this case.
+	 */
+	if (submit->base.s_fence)
+		drm_sched_job_cleanup(&submit->base);
+
 	if (submit->fence_id) {
 		mutex_lock(&submit->queue->lock);
 		idr_remove(&submit->queue->fence_idr, submit->fence_id);
-- 
2.39.5



