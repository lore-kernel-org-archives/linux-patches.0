Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AF81DF98C;
	Wed,  6 Nov 2024 12:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896442; cv=none; b=T28tYfIm23ew+qAof8eWcnbCDV4RC0xoF/hG741DYIXKhE2uvuxzrkxwZG7xLaT6gJFUUNE70aiaD6bn4JQxp2O86gMdLJjV6wYzNBpTQtoahtDs2z/L13rnNMyPiPsVeTCntqa9yvJBhxQJ+U553CU5+uTLcEGcJqnEFV5VE5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896442; c=relaxed/simple;
	bh=6GI1qszzcv2hxGdh/yy2/5JTWwVBk0wAn9aoZGirvA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEt8AwHyZZ0VObI5yVLAy4o4PaWW5VfWyh8xHMkSb5ldXsLu3nq7huTMOEd5BCupJsW6tvb+OUpCS6POZzWA3lJuH605y4cvmQG8a8tBy8naLWgdcAwS+WUDYvnxUSRrFsQPsUieGQvJEClnfMyA1YzI6bu88SRHsuM4oCCtATM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5JYrMQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5JYrMQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99273C4CECD;
	Wed,  6 Nov 2024 12:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896442;
	bh=6GI1qszzcv2hxGdh/yy2/5JTWwVBk0wAn9aoZGirvA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5JYrMQoDHbMIBEI1A64KwGECdkhGkTKv72inPV+tPOs9fs41MV6DU8TmgUkalW10
	 X3gxPDdd4DxbR/ccPlN9Y/SV7MK0dFp1GHrUwCoZMpOwzyHzyvHYu2g+5ttZmwiJb7
	 srCG2QwanVoci/mMCwLNILX9TL2p0yoLzXO2gQpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Zanoni <paulo.r.zanoni@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 196/245] drm/xe: Dont short circuit TDR on jobs not started
Date: Wed,  6 Nov 2024 13:04:09 +0100
Message-ID: <20241106120324.068687075@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

[ Upstream commit fe05cee4d9533892210e1ee90147175d87e7c053 ]

Short circuiting TDR on jobs not started is an optimization which is not
required. On LNL we are facing an issue where jobs do not get scheduled
by the GuC if it misses a GGTT page update. When this occurs let the TDR
fire, toggle the scheduling which may get the job unstuck, and print a
warning message. If the TDR fires twice on job that hasn't started,
timeout the job.

v2:
 - Add warning message (Paulo)
 - Add fixes tag (Paulo)
 - Timeout job which hasn't started after TDR firing twice
v3:
 - Include local change
v4:
 - Short circuit check_timeout on job not started
 - use warn level rather than notice (Paulo)

Fixes: 7ddb9403dd74 ("drm/xe: Sample ctx timestamp to determine if jobs have timed out")
Cc: stable@vger.kernel.org
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241025214330.2010521-2-matthew.brost@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 35d25a4a0012e690ef0cc4c5440231176db595cc)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index dfd809e7bbd25..cbdd44567d107 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -989,12 +989,22 @@ static void xe_guc_exec_queue_lr_cleanup(struct work_struct *w)
 static bool check_timeout(struct xe_exec_queue *q, struct xe_sched_job *job)
 {
 	struct xe_gt *gt = guc_to_gt(exec_queue_to_guc(q));
-	u32 ctx_timestamp = xe_lrc_ctx_timestamp(q->lrc[0]);
-	u32 ctx_job_timestamp = xe_lrc_ctx_job_timestamp(q->lrc[0]);
+	u32 ctx_timestamp, ctx_job_timestamp;
 	u32 timeout_ms = q->sched_props.job_timeout_ms;
 	u32 diff;
 	u64 running_time_ms;
 
+	if (!xe_sched_job_started(job)) {
+		xe_gt_warn(gt, "Check job timeout: seqno=%u, lrc_seqno=%u, guc_id=%d, not started",
+			   xe_sched_job_seqno(job), xe_sched_job_lrc_seqno(job),
+			   q->guc->id);
+
+		return xe_sched_invalidate_job(job, 2);
+	}
+
+	ctx_timestamp = xe_lrc_ctx_timestamp(q->lrc[0]);
+	ctx_job_timestamp = xe_lrc_ctx_job_timestamp(q->lrc[0]);
+
 	/*
 	 * Counter wraps at ~223s at the usual 19.2MHz, be paranoid catch
 	 * possible overflows with a high timeout.
@@ -1120,10 +1130,6 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 		exec_queue_killed_or_banned_or_wedged(q) ||
 		exec_queue_destroyed(q);
 
-	/* Job hasn't started, can't be timed out */
-	if (!skip_timeout_check && !xe_sched_job_started(job))
-		goto rearm;
-
 	/*
 	 * XXX: Sampling timeout doesn't work in wedged mode as we have to
 	 * modify scheduling state to read timestamp. We could read the
-- 
2.43.0



