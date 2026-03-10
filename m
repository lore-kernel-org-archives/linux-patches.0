Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00348387574;
	Tue, 10 Mar 2026 11:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141222; cv=none; b=Q62oNjbH3jiW9azoAAdoS03ur7Hi3X+g1wOo3e9yweGKWr2AvbNT22N3kzfYHl8EwgF5dP3+sIrfF01/WOqhMAFJXIlB7d+mmGmZobkqjH9MC/3Z0zfEEaLV6gM+Bh6OVp176nkfhvciy2wa+BYczsQBRa8uBZODoADhU3O1/Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141222; c=relaxed/simple;
	bh=Tf22qBkKJoTq/TeZPQKyQCvLz7qMteisc3ArU8vYgnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTF3oCttzT1nKAsqGloQrH88bVYmwo22QufexHKfoPL34YVqrIja6wfQArrs5TR74AMYalj9qSqXO2DvH3/4C/4WJXvLEoxhLdIEustT/I65u9D9MOKhhacEVoHjQHW82KvvokjoqsmDP0gkxiuDnZFrf8yM+LkgSJzCj+N3KCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nf+aJC9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nf+aJC9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F5EC2BC9E;
	Tue, 10 Mar 2026 11:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141221;
	bh=Tf22qBkKJoTq/TeZPQKyQCvLz7qMteisc3ArU8vYgnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nf+aJC9Fp81/+ACCv+jJlt6Pa1PdpGhmSuaUb1+yp6Tj0y1otq5zdDu2tLqrkiR1v
	 Cm4squ7WjFkcVm75HCCiVXH3thv+Tt0wRHgWagK3f30dAEgviyuQjasHN99EL7NZFs
	 UZOvHUPGtS0c1nWPSaqFtf/XCAK12o2DJNsiJ3MF8Fjd8DZ7fZyEZAngCA/W3/RFxI
	 xCEWvplQjnR7SpM30lA1Q15RK8Vg9sRmPZnSvZTkkYkSSz+y/K11wrnKCFz0vocoPP
	 OFccObwwXLevMMR7D0MP5vj58WiIIT9j3WLlYeUbUeCWtJXNKmbX7Ok7sxkD+40lLx
	 Rdlm+OK5z2U+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Brost <matthew.brost@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Carlos Santa <carlos.santa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 223/311] drm/xe: Do not preempt fence signaling CS instructions
Date: Tue, 10 Mar 2026 07:04:30 -0400
Message-ID: <c183f66bcd7f850529f29750619c295733e21c21.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit cdc8a1e11f4d5b480ec750e28010c357185b95a6 ]

If a batch buffer is complete, it makes little sense to preempt the
fence signaling instructions in the ring, as the largest portion of the
work (the batch buffer) is already done and fence signaling consists of
only a few instructions. If these instructions are preempted, the GuC
would need to perform a context switch just to signal the fence, which
is costly and delays fence signaling. Avoid this scenario by disabling
preemption immediately after the BB start instruction and re-enabling it
after executing the fence signaling instructions.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Carlos Santa <carlos.santa@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patch.msgid.link/20260115004546.58060-1-matthew.brost@intel.com
(cherry picked from commit 2bcbf2dcde0c839a73af664a3c77d4e77d58a3eb)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_ring_ops.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_ring_ops.c b/drivers/gpu/drm/xe/xe_ring_ops.c
index ac0c6dcffe156..803c652f5af91 100644
--- a/drivers/gpu/drm/xe/xe_ring_ops.c
+++ b/drivers/gpu/drm/xe/xe_ring_ops.c
@@ -267,6 +267,9 @@ static void __emit_job_gen12_simple(struct xe_sched_job *job, struct xe_lrc *lrc
 
 	i = emit_bb_start(batch_addr, ppgtt_flag, dw, i);
 
+	/* Don't preempt fence signaling */
+	dw[i++] = MI_ARB_ON_OFF | MI_ARB_DISABLE;
+
 	if (job->user_fence.used) {
 		i = emit_flush_dw(dw, i);
 		i = emit_store_imm_ppgtt_posted(job->user_fence.addr,
@@ -332,6 +335,9 @@ static void __emit_job_gen12_video(struct xe_sched_job *job, struct xe_lrc *lrc,
 
 	i = emit_bb_start(batch_addr, ppgtt_flag, dw, i);
 
+	/* Don't preempt fence signaling */
+	dw[i++] = MI_ARB_ON_OFF | MI_ARB_DISABLE;
+
 	if (job->user_fence.used) {
 		i = emit_flush_dw(dw, i);
 		i = emit_store_imm_ppgtt_posted(job->user_fence.addr,
@@ -384,6 +390,9 @@ static void __emit_job_gen12_render_compute(struct xe_sched_job *job,
 
 	i = emit_bb_start(batch_addr, ppgtt_flag, dw, i);
 
+	/* Don't preempt fence signaling */
+	dw[i++] = MI_ARB_ON_OFF | MI_ARB_DISABLE;
+
 	i = emit_render_cache_flush(job, dw, i);
 
 	if (job->user_fence.used)
-- 
2.51.0

