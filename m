Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D4782495;
	Wed, 19 Jun 2024 13:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803273; cv=none; b=ihiaszqTVPrpbD9doLdN+vvtU7oBD831W2Y+/j7I3qcxdg/TZk2Pj14o9SDy8LG31N5qvuAuFe3KQFya3vnW++ocdMxsjWAth/togOvPv6G0u+nOYFl3FfJqWQl1AM5OUVOTV1u8Lr4dQjnXlJnrDSjU05g+eRd1XgTsj7qIPuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803273; c=relaxed/simple;
	bh=lKjwkPn+hVF2wJ7Nmtiwm2ncB8g3OTxwn9NNdENRBR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QyVgmMoSqEfNDcuNHuFZjZXjLQzUFNPv8Oxxb82fHqBkguuG+HN0SpEXYCTrR2q3u/YcRjVAxZx722iFfOIUS+h8P4IjTPG+Kd+wiP7BQQevyt9cH77crTJBmROYgslctwEwGbtS1pgOC1KnXofnPi0zM8vvicQwXZuQ9GggwI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtAkbC3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtAkbC3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437D4C4AF49;
	Wed, 19 Jun 2024 13:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803272;
	bh=lKjwkPn+hVF2wJ7Nmtiwm2ncB8g3OTxwn9NNdENRBR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtAkbC3u3wTmJv+PfUqgwAzFjRhSqeR7/zZxREOfr6YVhx+XdRlWCrHqj1hwVdCBg
	 VeVLZdu0qU9ZfPBtZ/5wXGKKEo7H2gwJDbyn4zC30Z4YXy9MPpbxqsi/yGk/ndmE0u
	 0zArsxaliTbjqpB0i/nCItHHD+8pK+SUxZiCS9t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 180/281] drm/xe: flush engine buffers before signalling user fence on all engines
Date: Wed, 19 Jun 2024 14:55:39 +0200
Message-ID: <20240619125616.761773282@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Hajda <andrzej.hajda@intel.com>

[ Upstream commit b5e3a9b83f352a737b77a01734a6661d1130ed49 ]

Tests show that user fence signalling requires kind of write barrier,
otherwise not all writes performed by the workload will be available
to userspace. It is already done for render and compute, we need it
also for the rest: video, gsc, copy.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240605-fix_user_fence_posted-v3-2-06e7932f784a@intel.com
(cherry picked from commit 3ad7d18c5dad75ed38098c7cc3bc9594b4701399)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_ring_ops.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_ring_ops.c b/drivers/gpu/drm/xe/xe_ring_ops.c
index 5b2b37b598130..820c8d73c464f 100644
--- a/drivers/gpu/drm/xe/xe_ring_ops.c
+++ b/drivers/gpu/drm/xe/xe_ring_ops.c
@@ -79,6 +79,16 @@ static int emit_store_imm_ggtt(u32 addr, u32 value, u32 *dw, int i)
 	return i;
 }
 
+static int emit_flush_dw(u32 *dw, int i)
+{
+	dw[i++] = MI_FLUSH_DW | MI_FLUSH_IMM_DW;
+	dw[i++] = 0;
+	dw[i++] = 0;
+	dw[i++] = 0;
+
+	return i;
+}
+
 static int emit_flush_imm_ggtt(u32 addr, u32 value, bool invalidate_tlb,
 			       u32 *dw, int i)
 {
@@ -233,10 +243,12 @@ static void __emit_job_gen12_simple(struct xe_sched_job *job, struct xe_lrc *lrc
 
 	i = emit_bb_start(batch_addr, ppgtt_flag, dw, i);
 
-	if (job->user_fence.used)
+	if (job->user_fence.used) {
+		i = emit_flush_dw(dw, i);
 		i = emit_store_imm_ppgtt_posted(job->user_fence.addr,
 						job->user_fence.value,
 						dw, i);
+	}
 
 	i = emit_flush_imm_ggtt(xe_lrc_seqno_ggtt_addr(lrc), seqno, false, dw, i);
 
@@ -292,10 +304,12 @@ static void __emit_job_gen12_video(struct xe_sched_job *job, struct xe_lrc *lrc,
 
 	i = emit_bb_start(batch_addr, ppgtt_flag, dw, i);
 
-	if (job->user_fence.used)
+	if (job->user_fence.used) {
+		i = emit_flush_dw(dw, i);
 		i = emit_store_imm_ppgtt_posted(job->user_fence.addr,
 						job->user_fence.value,
 						dw, i);
+	}
 
 	i = emit_flush_imm_ggtt(xe_lrc_seqno_ggtt_addr(lrc), seqno, false, dw, i);
 
-- 
2.43.0



