Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11601D9A43;
	Tue,  8 Oct 2024 12:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389677; cv=none; b=RamI7nSQqWov7blS/T1hjAq7pqJyPNXJkbARnUC23XHlBj8EI3s7rnoXBd3IbfXUvsbbDxfTPuirhOodx5/h+BZknpYmzhmwlgO2qjr+xigJXrGDEYPSm43A6jNDa4EDFpqLtxA8unZVEhIVVCcK56k3aexRWwkYp38a6ERhU8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389677; c=relaxed/simple;
	bh=L4Exbxr50PvfZqzOKW+cV6wP6OzNwLkiaWfLtNqMCN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8rmpuOELlrm5PZJZ3CRVq6XKsg4BLP6D5kve7wZ44BKwTIQasapBWiNiw2G5DLb5Kbv4UCdv9eXfzjHbzI4ALVADiCGNM1AUQ0HD2j+MXOu+C/K0qpB4bM1fon/RrZM9Tv3IbjTIX2SIc4ZnzXL3L3PIdy+Qdjjeu+j6RRlKmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNQA2I3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNQA2I3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9BAC4CECC;
	Tue,  8 Oct 2024 12:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389677;
	bh=L4Exbxr50PvfZqzOKW+cV6wP6OzNwLkiaWfLtNqMCN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNQA2I3EmvdGXoqxjA+7UCYHFM6PlADhpZ2VwbQd/HG6ggldvxDY1zNm7iKv5H0p5
	 F1lDa7RHelqQl3Jb1Qa039SIpVSfxRQe0I0zoa08WIKAz3WztUsuNLttcmRWl0O+FA
	 Du7fdnOfw+r1HYdCYTR+Et49w/5jnd8rnO7c5dTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 064/482] drm/xe: Resume TDR after GT reset
Date: Tue,  8 Oct 2024 14:02:07 +0200
Message-ID: <20241008115650.827057614@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 1b30f87e088b499eb74298db256da5c98e8276e2 ]

Not starting the TDR after GT reset on exec queue which have been
restarted can lead to jobs being able to be run forever. Fix this by
restarting the TDR.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240724235919.1917216-1-matthew.brost@intel.com
(cherry picked from commit 8ec5a4e5ce97d6ee9f5eb5b4ce4cfc831976fdec)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gpu_scheduler.c | 5 +++++
 drivers/gpu/drm/xe/xe_gpu_scheduler.h | 2 ++
 drivers/gpu/drm/xe/xe_guc_submit.c    | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gpu_scheduler.c b/drivers/gpu/drm/xe/xe_gpu_scheduler.c
index e4ad1d6ce1d5f..7f24e58cc992f 100644
--- a/drivers/gpu/drm/xe/xe_gpu_scheduler.c
+++ b/drivers/gpu/drm/xe/xe_gpu_scheduler.c
@@ -90,6 +90,11 @@ void xe_sched_submission_stop(struct xe_gpu_scheduler *sched)
 	cancel_work_sync(&sched->work_process_msg);
 }
 
+void xe_sched_submission_resume_tdr(struct xe_gpu_scheduler *sched)
+{
+	drm_sched_resume_timeout(&sched->base, sched->base.timeout);
+}
+
 void xe_sched_add_msg(struct xe_gpu_scheduler *sched,
 		      struct xe_sched_msg *msg)
 {
diff --git a/drivers/gpu/drm/xe/xe_gpu_scheduler.h b/drivers/gpu/drm/xe/xe_gpu_scheduler.h
index 10c6bb9c93868..6aac7fe686735 100644
--- a/drivers/gpu/drm/xe/xe_gpu_scheduler.h
+++ b/drivers/gpu/drm/xe/xe_gpu_scheduler.h
@@ -22,6 +22,8 @@ void xe_sched_fini(struct xe_gpu_scheduler *sched);
 void xe_sched_submission_start(struct xe_gpu_scheduler *sched);
 void xe_sched_submission_stop(struct xe_gpu_scheduler *sched);
 
+void xe_sched_submission_resume_tdr(struct xe_gpu_scheduler *sched);
+
 void xe_sched_add_msg(struct xe_gpu_scheduler *sched,
 		      struct xe_sched_msg *msg);
 
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 0a496612c810f..958dde8422d7e 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1500,6 +1500,7 @@ static void guc_exec_queue_start(struct xe_exec_queue *q)
 	}
 
 	xe_sched_submission_start(sched);
+	xe_sched_submission_resume_tdr(sched);
 }
 
 int xe_guc_submit_start(struct xe_guc *guc)
-- 
2.43.0



