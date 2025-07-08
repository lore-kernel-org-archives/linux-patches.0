Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2292E5414;
	Tue,  8 Jul 2025 16:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992501; cv=none; b=KzRflDkEXyFPz+dWisqu9jgN7N7Q99pLC2C3PFE/h0GI82Caz8D6lsj3jEbTCpiOUQlkNc1jP+Ia6PzrVJF6/z4XQrGfrF1zCospGJ966/Mu2kp50Hv+wQM/UdT/tRkzOjxVWXHzp8gAKtRhme6xQQQbS8IsvDVV0BlDI9h7Pko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992501; c=relaxed/simple;
	bh=3dJXnvF3Guskg6dcRN9k0TX8ZnmjkNWZAk4SxkugNzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFQVTQXBgkOJUOI7BjGTl8r9A0fnrYIbsC7JNnT6RqEhR5yTr6lIxgmpYBYfTe1UOciyFVUgXL9IYUUpLi0uTEX2zuI8CpFV03yFv8gdLeF2EVj1BYWr1Lf+jMvJ8OH9HjLL4Qv+TFTXq4SCm8gChZ7s/B42r9DMofy7d1okEhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5Jh9EdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5Jh9EdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5187CC4CEF0;
	Tue,  8 Jul 2025 16:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992500;
	bh=3dJXnvF3Guskg6dcRN9k0TX8ZnmjkNWZAk4SxkugNzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5Jh9EdE45Oj1Cxi9VYL+JkC8nPhV/qChy90eTVuTsPOxJ7TOs5T58O4oWjrOt1YE
	 /9aknqbyr6gwHRZiQHDCXZw//1bhzNLo7DqUicM0/5F8je7gFcvV0VzQbk12ToMoxL
	 fLeIQP6g9MXbQO7JQFIR46zMUv6nE4E59kqIy+84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/132] drm/msm: Fix a fence leak in submit error path
Date: Tue,  8 Jul 2025 18:23:13 +0200
Message-ID: <20250708162233.033924043@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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
index 018b39546fc1d..27366304f5d59 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -85,6 +85,15 @@ void __msm_gem_submit_destroy(struct kref *kref)
 			container_of(kref, struct msm_gem_submit, ref);
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
 		spin_lock(&submit->queue->idr_lock);
 		idr_remove(&submit->queue->fence_idr, submit->fence_id);
-- 
2.39.5



