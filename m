Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD5A192594;
	Tue,  8 Oct 2024 12:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391406; cv=none; b=HPtmLVGl5Kusk31THn/4jAZMulB4tNtdhBxvKOeBQ/tCn72nq65bMrFbZAePNUQ9WfOsklB7QM1IpP5493ZxhnGgYct3NA1g6D4rcpsgseN0FK9USSk0uk/RTWIRpMuVFojkJvkygyWRbajQHl0FlyW6PpsuHeuZi42N9tFNRbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391406; c=relaxed/simple;
	bh=9ly+A4zfotFi7bn8FODYQi/NmGnXbN4a1aaKvqmoI0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpV/RZ5tz3X5/vHc3qM9GxC7Sp1kM8Ecq2xFOfqvkwylCf/WqM0AkXTNVMJhBj0ZHVXIF1iqkDmVD3iGPxBGwJQoudXRtVukBgfDyxqXabk6P/+GUBBIY8CPpKfrDoJuk9k+F6qvSySXwVI0RrkIJDX4HSRJ18TZe8PChuNPJpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ortLPX0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ortLPX0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEDEC4CEC7;
	Tue,  8 Oct 2024 12:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391406;
	bh=9ly+A4zfotFi7bn8FODYQi/NmGnXbN4a1aaKvqmoI0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ortLPX0qe52fgB1uAZDgImOQhJ5gZXA6jOYfwKHnRgcEHRJPbs0cR4EXheG6fK6H9
	 dvsjsTtrkDMMKAtVDvcDt/VIt6KJijIZV3ADNMc6iet7781pytLzuOhpBWs2NIXLR7
	 bDChN1bxyncp2xtjy8PuAPUCVqMrwWSy5Xm1R5R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 072/558] drm/xe: Resume TDR after GT reset
Date: Tue,  8 Oct 2024 14:01:42 +0200
Message-ID: <20241008115705.052255106@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 3d91734980110..64b3a7848f4ab 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1740,6 +1740,7 @@ static void guc_exec_queue_start(struct xe_exec_queue *q)
 	}
 
 	xe_sched_submission_start(sched);
+	xe_sched_submission_resume_tdr(sched);
 }
 
 int xe_guc_submit_start(struct xe_guc *guc)
-- 
2.43.0



