Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49402E9EB1;
	Tue, 11 Nov 2025 01:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823823; cv=none; b=O1D2A9lT4d24GnjLHi4u5hwIdIsroyXUPmz1iIZCjyo+1hMLlAcPP5MpIfbjqVfnxdqtmeNacFP/GUX6fSa9jJJPA0i1UVxVB90NAJSRIJdiGvVx/9viQXpF+uQNNt2qba/yzEb2gPSnpnWKl+Df/EDbHDXufk24DWLacdv+SOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823823; c=relaxed/simple;
	bh=GgJcYL//oSEcrBbxg43O8gsHS579786yilEng3sKe9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1O8BvxLqQY4+7AafXyZaAuNgkXBbo1dk5RLjTzoIAD3XwHSlY9V6fh07Pj0D5ZNnRE4dOSVMoaOiEcr7+YXvOtwXzAnJa05yWuH4k0xIVP93D4OSxqDDvfxzrJE7AJpOaMJo2ZEQqTJn9DAAM2VUQNud510qdmdTTSWLLz+gr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGa3bXUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGa3bXUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096BCC16AAE;
	Tue, 11 Nov 2025 01:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823823;
	bh=GgJcYL//oSEcrBbxg43O8gsHS579786yilEng3sKe9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGa3bXUzxt/dQz7MTMosujnHt4G1nr233KSVt3phCoSEp7RlpiX9CR4VtjmXcRANU
	 +mgDR5kLsRKm4CBFmIJg1xt4c9oTq/m4rwerBilmuRzCdZg37wOOehWxo+7jMSX2/d
	 GJzVK/65GIsZtKfMCbO2xxaPr2rIRZsMF6+GBO/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Summers <stuart.summers@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 379/849] drm/xe: Cancel pending TLB inval workers on teardown
Date: Tue, 11 Nov 2025 09:39:09 +0900
Message-ID: <20251111004545.593599495@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Summers <stuart.summers@intel.com>

[ Upstream commit 76186a253a4b9eb41c5a83224c14efdf30960a71 ]

Add a new _fini() routine on the GT TLB invalidation
side to handle this worker cleanup on driver teardown.

v2: Move the TLB teardown to the gt fini() routine called during
    gt_init rather than in gt_alloc. This way the GT structure stays
    alive for while we reset the TLB state.

Signed-off-by: Stuart Summers <stuart.summers@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250826182911.392550-3-stuart.summers@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c                  |  2 ++
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c | 12 ++++++++++++
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h |  1 +
 3 files changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index 4d74a4983fd07..2f4c52716e75b 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -605,6 +605,8 @@ static void xe_gt_fini(void *arg)
 	struct xe_gt *gt = arg;
 	int i;
 
+	xe_gt_tlb_invalidation_fini(gt);
+
 	for (i = 0; i < XE_ENGINE_CLASS_MAX; ++i)
 		xe_hw_fence_irq_finish(&gt->fence_irq[i]);
 
diff --git a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
index 086c12ee3d9de..64cd6cf0ab8df 100644
--- a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
+++ b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
@@ -173,6 +173,18 @@ void xe_gt_tlb_invalidation_reset(struct xe_gt *gt)
 	mutex_unlock(&gt->uc.guc.ct.lock);
 }
 
+/**
+ *
+ * xe_gt_tlb_invalidation_fini - Clean up GT TLB invalidation state
+ *
+ * Cancel pending fence workers and clean up any additional
+ * GT TLB invalidation state.
+ */
+void xe_gt_tlb_invalidation_fini(struct xe_gt *gt)
+{
+	xe_gt_tlb_invalidation_reset(gt);
+}
+
 static bool tlb_invalidation_seqno_past(struct xe_gt *gt, int seqno)
 {
 	int seqno_recv = READ_ONCE(gt->tlb_invalidation.seqno_recv);
diff --git a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
index f7f0f2eaf4b59..3e4cff3922d6f 100644
--- a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
+++ b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
@@ -16,6 +16,7 @@ struct xe_vm;
 struct xe_vma;
 
 int xe_gt_tlb_invalidation_init_early(struct xe_gt *gt);
+void xe_gt_tlb_invalidation_fini(struct xe_gt *gt);
 
 void xe_gt_tlb_invalidation_reset(struct xe_gt *gt);
 int xe_gt_tlb_invalidation_ggtt(struct xe_gt *gt);
-- 
2.51.0



