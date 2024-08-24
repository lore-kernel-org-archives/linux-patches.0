Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB31E3214;
	Sat, 24 Aug 2024 03:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724471239; cv=none; b=iH+uT7i9V6HZbgeS8TFon54OnOpB7ccaqdpvsrMHJnrXYfvRZYzx9g2oIjriqBlXkbiaIJ5seU8iFZ57Rnsin4WYNBeyNLRxKmCwr0IL+A36m1g1rX9nMyoSBqRxZOio0SNQqCN7BoGMRPR6xwr0o0Syjg1iBsLdN5OvX4KozXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724471239; c=relaxed/simple;
	bh=9hvQeS0ngXVdosBqKG7tf+RduULcEVupa0NszXQJR7E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Var9g3bYHURGI+T4QRsb9ngBqzA3xJa3SZ7+axwtTPWqoiCr128ax6iNp/fQXcPrsfQqx0fNp4UqZL9BweXBvxnUg6RJGf7ZyLn1TIIk9yLiM7OY7fJYI88zKsYmpvFs4eOfryljTm7PvwTplI2Zh/70V7nwnKiScdF+TCexoAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=adOncbTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="adOncbTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A377EC32781;
	Sat, 24 Aug 2024 03:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724471239;
	bh=9hvQeS0ngXVdosBqKG7tf+RduULcEVupa0NszXQJR7E=;
	h=From:Date:Subject:To:Cc:From;
	b=adOncbTwURvRgjY1LZgDiwhlMCAZV/hWtxyHUuLYbmNudJXeTYti7ELfIIj3rgNSG
	 TrUdh43mvCLZQnroaA4BDSaymfdi4fFiWBnc6Sx+X1vloMhe2/tyChICI2ZVrWnckx
	 QZP077mGelqsOESHNt1l/iYRjVuNAZ8JyOTiSwH+DjdXiAq0CejZFomv9e9eBhUZo6
	 gcY8uOcGR9qCDbywgqxuwa5EfT4H2mWX6hus81z7p4wyV5ycKIx0uoTyr+owsCtL5r
	 3Gj94NHyqCJzUeV/0M+qX7KsqrSV7JSrId+LnIPfWqiCD2NPqFuZl/7+zWShmgH2Jh
	 bXPnXsona51mw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 23 Aug 2024 20:47:13 -0700
Subject: [PATCH] drm/xe: Fix total initialization in xe_ggtt_print_holes()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240823-drm-xe-fix-total-in-xe_ggtt_print_holes-v1-1-12b02d079327@kernel.org>
X-B4-Tracking: v=1; b=H4sIAMBXyWYC/x3NQQqDMBCF4avIrDuQji60VyklhDjGAZvIJIgg3
 r1Dl9/if++Cyipc4dVdoHxIlZINz0cHcQ05McpsBnI0uJF6nPWLJ+MiJ7bSwoaSzT6l1vyukpt
 fy8YVXVwo9tMUAgWwtV3Zmv/T+3PfP+WWHHh5AAAA
To: Lucas De Marchi <lucas.demarchi@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Jonathan Cavitt <jonathan.cavitt@intel.com>, 
 intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2190; i=nathan@kernel.org;
 h=from:subject:message-id; bh=9hvQeS0ngXVdosBqKG7tf+RduULcEVupa0NszXQJR7E=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGknw49prXzD4iFidfWUy5+3BzlrvVifzfv6oUksQHgLJ
 6fxxB+hHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiZ10Z/hk/3OlUfbvLSSLE
 uf7jLLbpa7f9lng6b92knNd7Pui5S61j+Cs3ZdNeSa/vJz5IZTa7bT0/3e7pWZPP0/lX3+/cbnB
 rPg8/AA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_DRM_WERROR or CONFIG_WERROR):

  drivers/gpu/drm/xe/xe_ggtt.c:810:3: error: variable 'total' is uninitialized when used here [-Werror,-Wuninitialized]
    810 |                 total += hole_size;
        |                 ^~~~~
  drivers/gpu/drm/xe/xe_ggtt.c:798:11: note: initialize the variable 'total' to silence this warning
    798 |         u64 total;
        |                  ^
        |                   = 0
  1 error generated.

Move the zero initialization of total from
xe_gt_sriov_pf_config_print_available_ggtt() to xe_ggtt_print_holes() to
resolve the warning.

Fixes: 136367290ea5 ("drm/xe: Introduce xe_ggtt_print_holes")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/xe/xe_ggtt.c               | 2 +-
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_ggtt.c b/drivers/gpu/drm/xe/xe_ggtt.c
index a3ce91decdce..86fc6afa43bd 100644
--- a/drivers/gpu/drm/xe/xe_ggtt.c
+++ b/drivers/gpu/drm/xe/xe_ggtt.c
@@ -795,7 +795,7 @@ u64 xe_ggtt_print_holes(struct xe_ggtt *ggtt, u64 alignment, struct drm_printer
 	const struct drm_mm_node *entry;
 	u64 hole_min_start = xe_wopcm_size(tile_to_xe(ggtt->tile));
 	u64 hole_start, hole_end, hole_size;
-	u64 total;
+	u64 total = 0;
 	char buf[10];
 
 	mutex_lock(&ggtt->lock);
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
index c8835d9eead6..41ed07b153b5 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
@@ -2110,7 +2110,7 @@ int xe_gt_sriov_pf_config_print_available_ggtt(struct xe_gt *gt, struct drm_prin
 {
 	struct xe_ggtt *ggtt = gt_to_tile(gt)->mem.ggtt;
 	u64 alignment = pf_get_ggtt_alignment(gt);
-	u64 spare, avail, total = 0;
+	u64 spare, avail, total;
 	char buf[10];
 
 	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));

---
base-commit: 66a0f6b9f5fc205272035b6ffa4830be51e3f787
change-id: 20240823-drm-xe-fix-total-in-xe_ggtt_print_holes-0cf2c399aa2a

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

