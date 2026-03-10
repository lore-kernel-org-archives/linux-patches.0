Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB652FFDF7;
	Tue, 10 Mar 2026 11:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142155; cv=none; b=VQgWeFuXmPUR6hctBZC1q36+g7JP2YCufNhq1v6+djdKfC3OkUWmcCh2PYnFBw9JIAan4yB++eIJPP1Wdn3hQiXz6Oc82uJdBrZZVKSTM+xl4V7UXSyQIT/gsPtuuqOi11Hy0s9RhI0SirDg9Tk/BjZPahADcPRkWLNTjDbe6P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142155; c=relaxed/simple;
	bh=vFCkomxdJaZSXeq6qagrIaS9wVggtX/V8K/7PT3j1Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUfnWtZKplvkUhl/kkrq5osWxC+QZU8KWMxSDHl5hSp9dfM0RQwUFQ2bhN6qOJNzWbiJxtcHnfYW8NlFMtiHtC8ha/czxgD32YGDSggIci+u0nfQWDYnfk/2Z9sLBRRdVTo32+d1sEThKen1DJ6flpk5xqvkGYUII3w/DS8/P9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QXFsZFlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXFsZFlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980C8C2BC86;
	Tue, 10 Mar 2026 11:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142155;
	bh=vFCkomxdJaZSXeq6qagrIaS9wVggtX/V8K/7PT3j1Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXFsZFlLg2HqhXYU2gMPaZrUaAIXKjSgXKGUlkj0ZhhgPQWxm3gQhBUhvbB9aSGlf
	 OzxxZITC8ZpWYVErSyRjzk7glOoPKXAiCnH2mhui5LSU6/odEoNsKJ62rdKXHyS2GE
	 4x2JF+zFVr424v1gmlkP8tp9/BnpzaIt8gZhdtNyqgwuf3DkdswY6ahkqt8NlZCwsz
	 OBE+fJW1SoKYOSooh7DE2qwtNOYz5O6l6OhIMrgFXFmBAIREfUQIb4wEcEgB8Q9Otf
	 Kw3PhWykGSvnYYft5ISrXdyLmhqf1VGYGr3B5GO5lE85uHMhhmg44QXTXCfsCIVvV+
	 fCCPdo/gmcqng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Brost <matthew.brost@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Carlos Santa <carlos.santa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 243/314] drm/xe: Do not preempt fence signaling CS instructions
Date: Tue, 10 Mar 2026 07:18:22 -0400
Message-ID: <d02a803174d3a027f7f82b5d8fbc9304f3b90d7c.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index d71837773d6c6..e0082b55e2162 100644
--- a/drivers/gpu/drm/xe/xe_ring_ops.c
+++ b/drivers/gpu/drm/xe/xe_ring_ops.c
@@ -265,6 +265,9 @@ static void __emit_job_gen12_simple(struct xe_sched_job *job, struct xe_lrc *lrc
 
 	i = emit_bb_start(batch_addr, ppgtt_flag, dw, i);
 
+	/* Don't preempt fence signaling */
+	dw[i++] = MI_ARB_ON_OFF | MI_ARB_DISABLE;
+
 	if (job->user_fence.used) {
 		i = emit_flush_dw(dw, i);
 		i = emit_store_imm_ppgtt_posted(job->user_fence.addr,
@@ -328,6 +331,9 @@ static void __emit_job_gen12_video(struct xe_sched_job *job, struct xe_lrc *lrc,
 
 	i = emit_bb_start(batch_addr, ppgtt_flag, dw, i);
 
+	/* Don't preempt fence signaling */
+	dw[i++] = MI_ARB_ON_OFF | MI_ARB_DISABLE;
+
 	if (job->user_fence.used) {
 		i = emit_flush_dw(dw, i);
 		i = emit_store_imm_ppgtt_posted(job->user_fence.addr,
@@ -377,6 +383,9 @@ static void __emit_job_gen12_render_compute(struct xe_sched_job *job,
 
 	i = emit_bb_start(batch_addr, ppgtt_flag, dw, i);
 
+	/* Don't preempt fence signaling */
+	dw[i++] = MI_ARB_ON_OFF | MI_ARB_DISABLE;
+
 	i = emit_render_cache_flush(job, dw, i);
 
 	if (job->user_fence.used)
-- 
2.51.0

