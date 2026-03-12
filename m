Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1CF26F288;
	Thu, 12 Mar 2026 20:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347190; cv=none; b=RN6Ce2GvIOWBgpWQ0s2yVlVio0tR3G1JjB9E+027puZzQfABdq9RZMaa9i8c2vjvFophMfJiG41iAP3YQ2sg/okSViEPMGosE52NKcjljbnN30Wd+wnI08yJWJ0IxTCB5mRzdrqY0QaG79i62TYN43DsqpD+ME+zb5hkqTbcM+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347190; c=relaxed/simple;
	bh=sWoYAtqEYeaPQ+It6VUmR+XCDKurJf7uRgCwxPnW6S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExbtqxtqdbHaAtKRMF5jb+rfEuqZ15j8UG1N8jcVC5D2TScH3v915GRgzaerrd4KsF+KW4fWy3oCA7w6v1Vo6GdnEP+Y4vrI9hoR47BzH94/0nc22YiaWHUCNQq+TZ+3fGGOCdkgfCQFy3tSAc9vBX+ZoevuhqUkHwCBIykIsZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caqh2fp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caqh2fp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48567C4CEF7;
	Thu, 12 Mar 2026 20:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347190;
	bh=sWoYAtqEYeaPQ+It6VUmR+XCDKurJf7uRgCwxPnW6S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caqh2fp7ONOwOjQXKTUGdQZKUqLDKUiNAvm6Aqxun+Ba9bIeNVEO/lHTznnhKVx1t
	 7SET1LeSVRKoNmHUjDC2P3RbwW0n3RylgssKZfa76z5gMkYCJFreDioxxxFGl2pghL
	 WOXzDX7mp+8s9utROtyVPmMJEdn7jIJ+e7HfAiDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Carlos Santa <carlos.santa@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/265] drm/xe: Do not preempt fence signaling CS instructions
Date: Thu, 12 Mar 2026 21:09:43 +0100
Message-ID: <20260312201025.396293449@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index fb31e09acb519..c9e8969f99fc7 100644
--- a/drivers/gpu/drm/xe/xe_ring_ops.c
+++ b/drivers/gpu/drm/xe/xe_ring_ops.c
@@ -259,6 +259,9 @@ static void __emit_job_gen12_simple(struct xe_sched_job *job, struct xe_lrc *lrc
 
 	i = emit_bb_start(batch_addr, ppgtt_flag, dw, i);
 
+	/* Don't preempt fence signaling */
+	dw[i++] = MI_ARB_ON_OFF | MI_ARB_DISABLE;
+
 	if (job->user_fence.used) {
 		i = emit_flush_dw(dw, i);
 		i = emit_store_imm_ppgtt_posted(job->user_fence.addr,
@@ -322,6 +325,9 @@ static void __emit_job_gen12_video(struct xe_sched_job *job, struct xe_lrc *lrc,
 
 	i = emit_bb_start(batch_addr, ppgtt_flag, dw, i);
 
+	/* Don't preempt fence signaling */
+	dw[i++] = MI_ARB_ON_OFF | MI_ARB_DISABLE;
+
 	if (job->user_fence.used) {
 		i = emit_flush_dw(dw, i);
 		i = emit_store_imm_ppgtt_posted(job->user_fence.addr,
@@ -371,6 +377,9 @@ static void __emit_job_gen12_render_compute(struct xe_sched_job *job,
 
 	i = emit_bb_start(batch_addr, ppgtt_flag, dw, i);
 
+	/* Don't preempt fence signaling */
+	dw[i++] = MI_ARB_ON_OFF | MI_ARB_DISABLE;
+
 	i = emit_render_cache_flush(job, dw, i);
 
 	if (job->user_fence.used)
-- 
2.51.0



