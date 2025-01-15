Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35752248BA6;
	Wed, 15 Jan 2025 10:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938093; cv=none; b=YNhRo38wLCa6hN5wlit0ThA4erW1mRsoHNwwj3eNUp8kFE3pFgem0FCgJjQ6m/xtRHduNmGf5Khg9ADmXLL6vdA5HU9Y4W2ytJrsCJkDEvekRL/L+Uc7dJi8SoZmasPUkO4v1n0RbzHyyQxGcLzz8avSelf778+++vJKIxnUdS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938093; c=relaxed/simple;
	bh=tEa5JTE0H/Dh+ebN+kc7Htwbe8Wpfd6m8XYoZe3Bqoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TEKA/rH1vlLG1zTarR8L9xv07LTD9LGIrId1VPu6KYin6+QQAUx19Ysa+r07dtlw0dokH5qUa0AoJxMmV5xESW1vmaiFgdFYJGzIKcBHJwxS+Koo0qS4/5TZZ9gi6irn2jrHa6MDWIsP78TN2tM+lyeaHEzWCG/boGrNkosF3oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3+uCJ6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3+uCJ6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BFCC4CEDF;
	Wed, 15 Jan 2025 10:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938093;
	bh=tEa5JTE0H/Dh+ebN+kc7Htwbe8Wpfd6m8XYoZe3Bqoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3+uCJ6fJ49MLX8RlALg22XTGUBd8fNlES+JWcsxINV3b8/99QjPOv3h471G3v9Dt
	 QR4zhay3jjcXeJtMgh/OGEyjZ/50IJqqfripgRbqHH6/Vr2fPDnWULBoum2aNeXgds
	 VP2N1hES0k6KDyti00n/L0rUWj6UeGLSRIVpQ+KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/189] drm/xe: Fix tlb invalidation when wedging
Date: Wed, 15 Jan 2025 11:36:16 +0100
Message-ID: <20250115103609.541152094@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 9ab4981552930a9c45682d62424ba610edc3992d ]

If GuC fails to load, the driver wedges, but in the process it tries to
do stuff that may not be initialized yet. This moves the
xe_gt_tlb_invalidation_init() to be done earlier: as its own doc says,
it's a software-only initialization and should had been named with the
_early() suffix.

Move it to be called by xe_gt_init_early(), so the locks and seqno are
initialized, avoiding a NULL ptr deref when wedging:

	xe 0000:03:00.0: [drm] *ERROR* GT0: load failed: status: Reset = 0, BootROM = 0x50, UKernel = 0x00, MIA = 0x00, Auth = 0x01
	xe 0000:03:00.0: [drm] *ERROR* GT0: firmware signature verification failed
	xe 0000:03:00.0: [drm] *ERROR* CRITICAL: Xe has declared device 0000:03:00.0 as wedged.
	...
	BUG: kernel NULL pointer dereference, address: 0000000000000000
	#PF: supervisor read access in kernel mode
	#PF: error_code(0x0000) - not-present page
	PGD 0 P4D 0
	Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
	CPU: 9 UID: 0 PID: 3908 Comm: modprobe Tainted: G     U  W          6.13.0-rc4-xe+ #3
	Tainted: [U]=USER, [W]=WARN
	Hardware name: Intel Corporation Alder Lake Client Platform/AlderLake-S ADP-S DDR5 UDIMM CRB, BIOS ADLSFWI1.R00.3275.A00.2207010640 07/01/2022
	RIP: 0010:xe_gt_tlb_invalidation_reset+0x75/0x110 [xe]

This can be easily triggered by poking the GuC binary to force a
signature failure. There will still be an extra message,

	xe 0000:03:00.0: [drm] *ERROR* GT0: GuC mmio request 0x4100: no reply 0x4100

but that's better than a NULL ptr deref.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/3956
Fixes: c9474b726b93 ("drm/xe: Wedge the entire device")
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250103001111.331684-2-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 5001ef3af8f2c972d6fd9c5221a8457556f8bea6)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c                  | 8 ++++----
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c | 4 ++--
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h | 3 ++-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index d5fd6a089b7c..b940688c3613 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -386,6 +386,10 @@ int xe_gt_init_early(struct xe_gt *gt)
 	xe_force_wake_init_gt(gt, gt_to_fw(gt));
 	spin_lock_init(&gt->global_invl_lock);
 
+	err = xe_gt_tlb_invalidation_init_early(gt);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -585,10 +589,6 @@ int xe_gt_init(struct xe_gt *gt)
 		xe_hw_fence_irq_init(&gt->fence_irq[i]);
 	}
 
-	err = xe_gt_tlb_invalidation_init(gt);
-	if (err)
-		return err;
-
 	err = xe_gt_pagefault_init(gt);
 	if (err)
 		return err;
diff --git a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
index 7e385940df08..ace1fe831a7b 100644
--- a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
+++ b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
@@ -106,7 +106,7 @@ static void xe_gt_tlb_fence_timeout(struct work_struct *work)
 }
 
 /**
- * xe_gt_tlb_invalidation_init - Initialize GT TLB invalidation state
+ * xe_gt_tlb_invalidation_init_early - Initialize GT TLB invalidation state
  * @gt: graphics tile
  *
  * Initialize GT TLB invalidation state, purely software initialization, should
@@ -114,7 +114,7 @@ static void xe_gt_tlb_fence_timeout(struct work_struct *work)
  *
  * Return: 0 on success, negative error code on error.
  */
-int xe_gt_tlb_invalidation_init(struct xe_gt *gt)
+int xe_gt_tlb_invalidation_init_early(struct xe_gt *gt)
 {
 	gt->tlb_invalidation.seqno = 1;
 	INIT_LIST_HEAD(&gt->tlb_invalidation.pending_fences);
diff --git a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
index 00b1c6c01e8d..672acfcdf0d7 100644
--- a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
+++ b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
@@ -14,7 +14,8 @@ struct xe_gt;
 struct xe_guc;
 struct xe_vma;
 
-int xe_gt_tlb_invalidation_init(struct xe_gt *gt);
+int xe_gt_tlb_invalidation_init_early(struct xe_gt *gt);
+
 void xe_gt_tlb_invalidation_reset(struct xe_gt *gt);
 int xe_gt_tlb_invalidation_ggtt(struct xe_gt *gt);
 int xe_gt_tlb_invalidation_vma(struct xe_gt *gt,
-- 
2.39.5



