Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C6F3043D4;
	Sat, 25 Oct 2025 16:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408951; cv=none; b=oWKf7TQQc7F+EJFYWnCRubeAADpN6jvBCavClL2Sg3YYAlZPu++7CREg039maHYlB0kJr5M8p99SaINHrl8YcFrs2V9vn1QrD6eXGnTgHGFy+rst6BwpmuIzZb87+pQApKZ9JW6VOdWFiHzstGQoGLIeskNRVbWoQ19fuoyXGo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408951; c=relaxed/simple;
	bh=yLH21nXkh1y4o3R5/b47gV+bd7YewWXUICb4cZZM5x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jotKIy2modcsVP+fNHccxX73N7w1DyGEv1Lw+yyxlE01oFyxnkYwUUoab9h45Zaznaa5ujY1Hy97YbLWSISJ894i2aSNSQRe89DepJ9tTwTvHuzZtk9pCCv2d9VZhxxLnGl5tzX701TR29lVgGTnqHu1+UdqZlAsd1cX5qo4srI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XvywC38T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XvywC38T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6B4C4CEFB;
	Sat, 25 Oct 2025 16:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408951;
	bh=yLH21nXkh1y4o3R5/b47gV+bd7YewWXUICb4cZZM5x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvywC38TtDUFmoCNqFWVTPZ6RvAZsjmwBsBq6j4BCKbMex8j9/OYNfRCLmFV/XfLt
	 KN2ryBn1hVGrcXCEFlzx4LGRPRwCAkARfu8NTnBhzey+bEShoVTKq/yE2zzAAlVjj9
	 HZtMGUDsHJYBAF8lBaAv7Xk+bb4xactdpkKArOxcBpzG/FR6sPjpFzzdhcBxsdJ8ak
	 ATX0teYrdk5Ro18gP/N5sB+uylA5m4NrPKFz8Em8tdzQMiEz7ujAk4N1B9lUBgs5yk
	 JQtERP9dE765onAKLPFhgq2MEBd5XKyD6Qx5lZ+e/ch+lLvODASRcD6Enk+6CSyhkz
	 5MSdHApI1l88g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stuart Summers <stuart.summers@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/xe: Cancel pending TLB inval workers on teardown
Date: Sat, 25 Oct 2025 11:56:18 -0400
Message-ID: <20251025160905.3857885-147-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Prevents use-after-free/hangs on driver teardown by cancelling
    pending TLB-invalidation workers/fences before GT resources are
    dismantled. The reset path already handles this during GT resets;
    this commit ensures the same cleanup occurs on teardown.

- Key changes and why they matter
  - drivers/gpu/drm/xe/xe_gt.c: `xe_gt_fini()` now calls
    `xe_gt_tlb_invalidation_fini(gt)` first. This ensures TLB
    invalidation workers/fences are cancelled while the GT is still
    alive, avoiding races/UAF during teardown.
  - drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c: Adds
    `xe_gt_tlb_invalidation_fini(struct xe_gt *gt)` which simply calls
    `xe_gt_tlb_invalidation_reset(gt)`. The reset routine:
    - Computes a “pending” seqno and updates `seqno_recv` so waiters see
      all prior invalidations as complete.
    - Iterates `pending_fences` and signals them, waking any kworkers
      waiting for TLB flush completion.
    - This mirrors the existing reset behavior (cancel delayed work,
      advance seqno, signal fences) used during GT resets to guarantee
      no waiter is left behind.
  - drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h: Adds the prototype for
    the new fini, keeping the API consistent.

- Concrete evidence in the code changes
  - The commit places `xe_gt_tlb_invalidation_fini(gt)` at the start of
    GT teardown (xe_gt.c: in `xe_gt_fini()`), so TLB/worker cleanup runs
    before `xe_hw_fence_irq_finish()` and
    `xe_gt_disable_host_l2_vram()`. This ordering minimizes races with
    IRQ/fence infrastructure and other GT resources during teardown.
  - The finish routine calls into the reset path which explicitly:
    - Sets `seqno_recv` to a value covering all outstanding requests.
    - Signals all pending invalidation fences via
      `list_for_each_entry_safe(... pending_fences ...)`, ensuring
      waiters are released.
    - This matches the comment in the reset path about kworkers not
      tracked by explicit TLB fences and the need to wake them assuming
      a full GT reset.

- Mapping to current tree (for context/impact assessment)
  - In this tree, the corresponding logic lives under the “tlb_inval”
    names:
    - The reset path is implemented in
      `drivers/gpu/drm/xe/xe_tlb_inval.c:156` (`xe_tlb_inval_reset()`),
      which cancels the delayed timeout work, updates `seqno_recv`, and
      signals all `pending_fences`.
    - This path is already invoked during GT reset flows (e.g.,
      `drivers/gpu/drm/xe/xe_gt.c:853, 1067, 1139`), proving the
      approach is safe and battle-tested during runtime resets.
    - A drmm-managed teardown hook exists
      (`drivers/gpu/drm/xe/xe_tlb_inval.c:114`), but that operates at
      DRM device teardown. If GT devm teardown runs earlier, there is a
      window where TLB invalidation workers could outlive GT, risking
      UAF. Moving the cleanup into `xe_gt_fini()` (devm action, see
      `drivers/gpu/drm/xe/xe_gt.c:624`) closes that gap, which is
      exactly what this commit does in its codebase.

- Stable backport criteria
  - Important bugfix: avoids teardown-time UAF/hangs/leaks by cancelling
    and signalling all pending TLB invalidation work.
  - Small and contained: touches only the xe GT/TLB invalidation
    teardown path; adds one call-site and a thin wrapper.
  - No feature or architectural change: purely lifecycle/cleanup
    ordering.
  - Low regression risk: uses the same reset logic already exercised in
    GT reset paths.
  - Driver subsystem only (DRM xe), not core kernel.

- Conclusion
  - This is a clear, low-risk correctness fix for teardown-time resource
    and worker cleanup in the xe driver. It should be backported to
    stable trees where the xe driver and TLB invalidation workers exist,
    adapting symbol/file names as needed (e.g., calling
    `xe_tlb_inval_reset(&gt->tlb_inval)` from `xe_gt_fini()` in trees
    with the older naming).

 drivers/gpu/drm/xe/xe_gt.c                  |  2 ++
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c | 12 ++++++++++++
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h |  1 +
 3 files changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index 17634195cdc26..6f63c658c341f 100644
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

