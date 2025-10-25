Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3B7307ACA;
	Sat, 25 Oct 2025 16:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409196; cv=none; b=N0Sen4tXTJ9XJgsFvT/zVv88RXNtBP3TBbLCkqLXauQ5/I1CHYmnP83oyyQhOmZkRMK2tKyCUCCcU/xpQwq/rE1tw54zi/YCsvF/9q6ECRFqwUTqIx1hDHyn632WpFSChBIRYSs7ELion0lXCEV+p/tlnM4rkLJC8D2XWs11yUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409196; c=relaxed/simple;
	bh=801gx182FAvGt5ByVBL+5SMT1XgfvkwP9xzhTqQFJcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GtNwRqGJOO8tTZ9XdMq71yp05SUKAtw8rtDjvzxxSlNq6YXCxK8qUdiknXbC6KBW7dUSh+inHZTOUhpp5ukSYpEEx2HZbkXz5eQt/hfZwWJ5QOoaENUKvYYJwXrqCs6uIzqSID/gZc4DrzCO7KMjYxA5+wRMrcAuo6DM0nsMSms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QOseBbtq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QOseBbtq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FE0C4CEFB;
	Sat, 25 Oct 2025 16:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409196;
	bh=801gx182FAvGt5ByVBL+5SMT1XgfvkwP9xzhTqQFJcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOseBbtqOypEpqS8XVS2chuBKlNZIr6aR1/DqMeHWGULtshYYolu9A3rYqWUpvaS9
	 ZaHTrEuntvQZ6DRcQIwx0mREEmXel7WXJjqe0QLVwQXHmksSoZ339YE3bJddIhPYVl
	 BZuTa2caOQc7iSWqYNgtPe2bwIUVhYF4PjhIlWRJ3dE+JDP+g4ymuJEbnyW+nhpRnp
	 0eSwwu0gm8onUf5/gsI5XvLp+t3NrOSGvCanJRICMwgEp/6M95SOs0ytOwwINdvXzT
	 KKZm2fg0L+8lkDLKQwj63WfwKCLzbGMCt0g4m/sxzPu62oUTa8Eqsi1uLUGjUmnc9z
	 v9PnTLvL+o3yg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/xe/pf: Program LMTT directory pointer on all GTs within a tile
Date: Sat, 25 Oct 2025 11:57:50 -0400
Message-ID: <20251025160905.3857885-239-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Piotr Piórkowski <piotr.piorkowski@intel.com>

[ Upstream commit ad69d62588cd6bf8cddaff5e3e2eb1b8dd876d35 ]

Previously, the LMTT directory pointer was only programmed for primary GT
within a tile. However, to ensure correct Local Memory access by VFs,
the LMTT configuration must be programmed on all GTs within the tile.
Lets program the LMTT directory pointer on every GT of the tile
to guarantee proper LMEM access across all GTs on VFs.

HSD: 18042797646
Bspec: 67468
Signed-off-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://lore.kernel.org/r/20250805091850.1508240-1-piotr.piorkowski@intel.com
Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The current code only programs the LMTT directory pointer for the
    primary GT of a tile, leaving any additional GTs (e.g., media GT)
    unconfigured. In this tree, that single write is at
    drivers/gpu/drm/xe/xe_lmtt.c:202 where it calls
    xe_mmio_write32(tile->primary_gt, ...).
  - Since LMTT governs LMEM access for VFs, failing to program
    LMEM_CFG/LMTT_DIR_PTR for all GTs can break VF access to LMEM on
    non-primary GTs. The commit message aligns with this: “to ensure
    correct Local Memory access by VFs, the LMTT configuration must be
    programmed on all GTs within the tile.”

- Why the current behavior is insufficient
  - LMTT_DIR_PTR and LMEM_EN are defined in GT register space
    (drivers/gpu/drm/xe/regs/xe_gt_regs.h:429–431), and the comment in
    that header explains the GSI range is replicated for the media GT.
    Writing the LMEM_CFG pointer for only the primary GT does not
    automatically configure the same register instance for the media GT.
  - xe_lmtt_init_hw() is only invoked from the primary (non-media) GT
    init path (drivers/gpu/drm/xe/xe_gt.c:531). With the current single
    write in lmtt_setup_dir_ptr(), the media GT’s instance of LMEM_CFG
    remains unprogrammed.

- What the change does
  - The patch replaces the single write with a loop to program
    LMEM_CFG/LMTT_DIR_PTR for every GT on the tile, ensuring both
    primary and media GTs are configured. In older codebases (as in your
    tree), this maps to performing the same write for `tile->primary_gt`
    and, if present, also for `tile->media_gt`. In newer codebases it
    shows up as for_each_gt_on_tile(...) followed by
    xe_mmio_write32(&gt->mmio, ...).

- Containment and risk
  - Scope is a single helper: lmtt_setup_dir_ptr(). No ABI/UAPI changes,
    no architectural refactoring.
  - The write is guarded by sanity checks (VRAM BO, 64K alignment) and
    performed during PF GT initialization after reset
    (xe_lmtt_init_hw()), i.e., early and in a controlled sequence.
  - Side effects are limited to programming the same register on
    additional GTs. On single-GT tiles, the loop degenerates to one
    write.
  - The register selection already handles platform differences
    (GRAPHICS_VER(xe) >= 20 ? XE2_LMEM_CFG : LMEM_CFG) within the same
    helper (drivers/gpu/drm/xe/xe_lmtt.c:203–204), so no new platform-
    specific branches are introduced.

- User impact and severity
  - Misprogramming LMTT on multi-GT tiles can break LMEM access for VFs
    using media engines, resulting in functional failures or GPU faults
    in SR-IOV scenarios. This is a practical, user-visible bug in
    virtualization setups, not a feature change.

- Backport considerations
  - Applicable stable series: Only those that include the Xe driver and
    SR-IOV PF LMTT support (e.g., v6.8.y and v6.9.y). The XE driver (and
    xe_lmtt.c) is not present in v6.6.y or older, so those are out of
    scope.
  - Minimal adaptation: Older trees (like v6.8/v6.9) do not have
    for_each_gt_on_tile(). The equivalent stable backport is to perform
    the existing write for `tile->primary_gt` and additionally, if non-
    NULL, for `tile->media_gt`. The existing code already uses
    xe_mmio_write32(gt, ...), so the change is straightforward and
    localized.
  - Invocation context: xe_lmtt_init_hw() is called from the primary GT
    init only (drivers/gpu/drm/xe/xe_gt.c:531), so programming all GTs
    inside lmtt_setup_dir_ptr() is the correct place to ensure media GT
    gets configured too.

- Stable rules fit
  - Important bugfix affecting real users (SR-IOV VFs on multi-GT
    tiles).
  - Small and contained patch touching only the Xe PF LMTT
    initialization routine.
  - No new features, no ABI changes, and minimal regression risk.
  - Clear intent and references in the commit message (HSD: 18042797646,
    Bspec: 67468), plus Reviewed-by and lore link.

Conclusion: This is a solid, low-risk bugfix that should be backported
to stable kernels that have the Xe driver and SR-IOV PF LMTT code (e.g.,
6.8.y and 6.9.y).

 drivers/gpu/drm/xe/xe_lmtt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_lmtt.c b/drivers/gpu/drm/xe/xe_lmtt.c
index a2000307d5bf9..a78c9d474a6ef 100644
--- a/drivers/gpu/drm/xe/xe_lmtt.c
+++ b/drivers/gpu/drm/xe/xe_lmtt.c
@@ -195,14 +195,17 @@ static void lmtt_setup_dir_ptr(struct xe_lmtt *lmtt)
 	struct xe_tile *tile = lmtt_to_tile(lmtt);
 	struct xe_device *xe = tile_to_xe(tile);
 	dma_addr_t offset = xe_bo_main_addr(lmtt->pd->bo, XE_PAGE_SIZE);
+	struct xe_gt *gt;
+	u8 id;
 
 	lmtt_debug(lmtt, "DIR offset %pad\n", &offset);
 	lmtt_assert(lmtt, xe_bo_is_vram(lmtt->pd->bo));
 	lmtt_assert(lmtt, IS_ALIGNED(offset, SZ_64K));
 
-	xe_mmio_write32(&tile->mmio,
-			GRAPHICS_VER(xe) >= 20 ? XE2_LMEM_CFG : LMEM_CFG,
-			LMEM_EN | REG_FIELD_PREP(LMTT_DIR_PTR, offset / SZ_64K));
+	for_each_gt_on_tile(gt, tile, id)
+		xe_mmio_write32(&gt->mmio,
+				GRAPHICS_VER(xe) >= 20 ? XE2_LMEM_CFG : LMEM_CFG,
+				LMEM_EN | REG_FIELD_PREP(LMTT_DIR_PTR, offset / SZ_64K));
 }
 
 /**
-- 
2.51.0

