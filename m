Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2205143E4B4;
	Mon, 20 Apr 2026 13:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691806; cv=none; b=PPMEG/spVizGab411GW3lNZe6mQTkAFPYw65o9x5Nd0C0TSlNDTC6BbbIu/KInOBG1QRVrmO6bDLvgu+FcOboJeStvlnPjdJYpSsDl4k0zWmaKMyXfe8vf9El690nAxfc+bmOEjEpfnXBMSHrISDAdfixpF4nsq5cuAvFc/9NAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691806; c=relaxed/simple;
	bh=CTJ2k7pUpzbbGT2CqJywyJFX4N+DAteg/+3X+hDceO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GV5iPyJRUbXBUS8wx9pua1vVEQvNOz5QKqLRuhQApNOZgMXEaX6nLrjshrp9UWzB5Ya4zzetPt3DmiG+P4+ofeyoGlIcaHiYnztwNTS4dmW4p8Lfl+U36LZanRkP4+RHL6eL4udXVVHUu+aAh2Qe1pTg7HiIiP4xCnn9r5rNpms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H22CuPbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H22CuPbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F906C2BCB4;
	Mon, 20 Apr 2026 13:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691805;
	bh=CTJ2k7pUpzbbGT2CqJywyJFX4N+DAteg/+3X+hDceO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H22CuPbtvmAwM5JJljDkVn/gXlT1mbxyd9c4Yfrwn8owrJgsZkBdQlDXerB6xO+PF
	 x3LgPQwaqDd5OAyt/cd2DKBHTz1Bj8HMttnoWJgDSL6sVkxqRfUJdWVuIteMZwWl+n
	 glwpEY3HdKOSq27eyHx7/OG1D+JDN3Y1XJnoxn8VwB+QrW3soknrPbiBKVCMdUhLQB
	 WbrU+GwbIRcO7tqjCGYOWlNfA0a+SkcT9GHrZU09yrg4mnp1Wjl9JuWHB4DjQSCfTw
	 lh1ozY2zzDXpw2ieF0Uk73tZkG1x12inQBE9SlXbLmXCDYL/hvxr4jyz2FvbnS55gO
	 7yuEfnjpcL13A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen-Yu Tsai <wenst@chromium.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/prime: Limit scatter list size with dedicated DMA device
Date: Mon, 20 Apr 2026 09:19:58 -0400
Message-ID: <20260420132314.1023554-204-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 864279920b2b2c1dd491eba0d0c64764c0c03d9f ]

If a dedicated DMA device is specified for the DRM device, then the
scatter list size limit should pertain to the DMA device.

Use the dedicated DMA device, if given, to limit the scatter list size.
This only applies to drivers that have called drm_dev_set_dma_dev() and
are using drm_prime_pages_to_sg() either directly or through the SHMEM
helpers. At the time of this writing, the former case only includes the
Rockchip DRM driver, while the latter case includes the gud, udl, and
the tiny appletbdrm and gm12u320 drivers.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260311094929.3393338-2-wenst@chromium.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile everything.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/prime`
- Action verb: "Limit" (correctness-oriented; ensuring proper constraint
  application)
- Summary: Ensure scatter list size limit uses the dedicated DMA
  device's constraints, not the parent device's.
- Record: [drm/prime] [Limit] [Use correct DMA device for scatter list
  size constraint]

**Step 1.2: Tags**
- Reviewed-by: Thomas Zimmermann (DRM core developer at SUSE) - strong
  quality signal
- Reviewed-by: AngeloGioacchino Del Regno (Collabora, MediaTek
  maintainer) - additional review
- Link: patch.msgid.link/20260311094929.3393338-2-wenst@chromium.org
- Signed-off-by: Chen-Yu Tsai (Chromium, also kernel.org contributor
  under `wens@kernel.org`)
- No Fixes: tag, no Cc: stable, no Reported-by
- Record: Two Reviewed-by from recognized DRM developers. No explicit
  bug report or stable nomination.

**Step 1.3: Commit Body**
- Describes the issue: when a dedicated DMA device is set, scatter list
  size limit should use the DMA device, not the parent device
- Identifies affected drivers: Rockchip (direct caller), and USB-based
  drivers (gud, udl, appletbdrm, gm12u320) via SHMEM helpers
- No stack traces, no crash descriptions, no user reports
- Record: Bug is that wrong device is queried for DMA constraints. No
  specific symptom reported by users.

**Step 1.4: Hidden Bug Fix Detection**
- This IS a correctness fix: commit 143ec8d3f9396 introduced
  `drm_dev_dma_dev()` and updated `drm_gem_prime_import()` but missed
  `drm_prime_pages_to_sg()`. The cover letter explicitly says "I believe
  this was missing from the original change."
- Record: Yes, this is a missed fix from the original dedicated DMA
  device support.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Changes Inventory**
- Single file: `drivers/gpu/drm/drm_prime.c`
- 1 line changed: `-` / `+` (net 0 lines)
- Function modified: `drm_prime_pages_to_sg()`
- Record: [1 file, 1 line changed] [drm_prime_pages_to_sg()] [Single-
  line surgical fix]

**Step 2.2: Code Flow Change**
- Before: `dma_max_mapping_size(dev->dev)` - queries the parent device
  for max DMA mapping size
- After: `dma_max_mapping_size(drm_dev_dma_dev(dev))` - queries the
  dedicated DMA device (if set), otherwise falls back to parent device
- `drm_dev_dma_dev()` returns `dev->dma_dev` if set, otherwise
  `dev->dev`, so this is a no-op for drivers that don't use
  `drm_dev_set_dma_dev()`
- Record: [Changes which device is queried for DMA constraint; no
  behavior change for drivers not using dedicated DMA device]

**Step 2.3: Bug Mechanism**
- Category: Logic/correctness fix
- For drivers that set a dedicated DMA device (USB DRM drivers,
  Rockchip), querying the parent device returns wrong constraints:
  - For a device without DMA ops, `dma_go_direct()` returns true
    (because `ops` is NULL)
  - Then `dma_direct_max_mapping_size()` returns SIZE_MAX (unless
    SWIOTLB is involved)
  - The actual DMA controller may have stricter limits (e.g., SWIOTLB
    bounce buffer limit, IOMMU segment limits)
  - Consequence: scatter list segments could exceed the actual DMA
    controller's max mapping size
- Record: [Logic/correctness] [Wrong device queried for DMA max mapping
  size; scatter list segments may exceed actual DMA controller limits]

**Step 2.4: Fix Quality**
- Obviously correct: `drm_dev_dma_dev()` is the canonical way to get the
  DMA device, already used in `drm_gem_prime_import()`
- Minimal/surgical: one-line change
- Regression risk: essentially zero - for drivers without dedicated DMA
  device, `drm_dev_dma_dev()` returns `dev->dev` (identical behavior)
- Record: [Obviously correct, zero regression risk]

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- Line 862: `dma_max_mapping_size(dev->dev)` was introduced by commit
  707d561f77b5e (Gerd Hoffmann, 2020-09-07) "drm: allow limiting the
  scatter list size"
- This code has been in the tree since 2020, but the bug was introduced
  by commit 143ec8d3f9396 (2025-03-07) which added the dedicated DMA
  device concept without updating this call site
- Record: [Original line from 707d561f77b5e (v5.10 era), bug context
  created by 143ec8d3f9396 (v6.16)]

**Step 3.2: Fixes tag**
- No Fixes: tag. The implicit fix target is 143ec8d3f9396 ("drm/prime:
  Support dedicated DMA device for dma-buf imports"), which exists in
  v6.16+.

**Step 3.3: Related Changes**
- Part of a 4-patch series. Patches 2-4 add GEM DMA helper support and
  convert MediaTek/sun4i drivers.
- Patch 1 (this commit) is completely standalone; it has no dependency
  on patches 2-4.
- Record: [Patch 1/4, but fully standalone]

**Step 3.4: Author**
- Chen-Yu Tsai (wenst@chromium.org / wens@kernel.org) is a known kernel
  contributor for MediaTek/ARM platforms.
- Record: [Active ARM/DRM contributor]

**Step 3.5: Dependencies**
- Depends on `drm_dev_dma_dev()` from commit 143ec8d3f9396 (v6.16+)
- For the fix to matter, drivers must call `drm_dev_set_dma_dev()`:
  - USB drivers: since v6.16 (part of same series as 143ec8d3f9396)
  - Rockchip: since commit 7d7bb790aced3 in v6.19
- Record: [Requires 143ec8d3f9396 (v6.16+). Only useful in trees v6.16+
  where drm_dev_dma_dev exists.]

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Discussion**
- Found on lore.gitlab.freedesktop.org. Series is "drm/gem-dma: Support
  dedicated DMA device for allocation".
- v1: 2026-03-10, v2: 2026-03-11. Minor revision; patch 1 was unchanged
  between versions.
- Thomas Zimmermann gave Reviewed-by on both v1 and v2.
- AngeloGioacchino Del Regno also reviewed v2.
- No NAKs or concerns raised.
- Record: [Two favorable reviews, no objections]

**Step 4.2: Reviewers**
- Thomas Zimmermann: DRM core developer who authored the original
  `drm_dev_dma_dev()` infrastructure
- AngeloGioacchino Del Regno: MediaTek platform maintainer
- Record: [Reviewed by the author of the original DMA device
  infrastructure]

**Step 4.3-4.5: Bug reports and stable history**
- No specific bug reports linked
- The cover letter mentions this was "missing from the original change"
- No explicit stable discussions found
- Record: [No bug reports, no stable discussion]

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Function analysis**
- `drm_prime_pages_to_sg()` is called from 15+ locations across many DRM
  drivers
- For drivers using dedicated DMA device and calling this function:
  - Rockchip: `rockchip_gem_get_pages()` and
    `rockchip_gem_prime_get_sg_table()`
  - USB drivers via SHMEM: `drm_gem_shmem_get_sg_table()` ->
    `drm_gem_shmem_get_pages_sgt_locked()`
- These are common code paths (buffer allocation, dma-buf export)
- Record: [Widely-used function, affected through normal buffer
  allocation paths]

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy code existence**
- `drm_dev_dma_dev()` only exists in v6.16+
- USB drivers only call `drm_dev_set_dma_dev()` in v6.16+
- Rockchip only calls it in v6.19+
- For stable trees < v6.16, the bug doesn't exist (no dedicated DMA
  device concept)
- Record: [Bug exists in v6.16+ only. For 7.0.y stable, the fix is
  relevant.]

**Step 6.2: Backport complications**
- The fix would apply cleanly to any tree containing 143ec8d3f9396
  (v6.16+)
- Record: [Clean apply expected for 7.0.y]

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1**: Subsystem: DRM/GPU drivers (IMPORTANT criticality for
affected devices)
**Step 7.2**: Active subsystem with recent changes

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is affected**
- Users of USB DRM devices (gud, udl, appletbdrm, gm12u320) and Rockchip
  DRM
- Record: [Driver-specific: USB display devices and Rockchip SoCs]

**Step 8.2: Trigger conditions**
- Triggered during buffer allocation and dma-buf operations on affected
  hardware
- Common operations: creating display buffers, PRIME buffer sharing
- Record: [Common display operations on affected hardware]

**Step 8.3: Failure mode**
- Without the fix, `dma_max_mapping_size()` may return an incorrect
  (typically too large) value
- This could cause DMA mapping failures when segments exceed the actual
  controller's limit
- The Rockchip "swiotlb buffer is full" warning (from commit
  7d7bb790aced3) is related to this class of issue
- Severity: MEDIUM - potential DMA failures on affected hardware
- Record: [DMA mapping failures possible; MEDIUM severity]

**Step 8.4: Risk-Benefit**
- Benefit: Ensures correct DMA constraints for scatter list creation on
  USB/Rockchip DRM devices
- Risk: Essentially zero - `drm_dev_dma_dev()` returns `dev->dev` when
  no dedicated device is set, so behavior is unchanged for unaffected
  drivers
- Record: [Low-medium benefit, near-zero risk]

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Fixes a missed call site from the original dedicated DMA device
  support (143ec8d3f9396)
- One-line change, obviously correct
- Zero regression risk (no-op for drivers not using dedicated DMA
  device)
- Reviewed by Thomas Zimmermann (author of the original DMA device
  infrastructure)
- Affects real hardware (USB DRM devices, Rockchip SoCs)
- Could cause DMA mapping failures with incorrect max segment sizes

**Evidence AGAINST backporting:**
- No specific user-reported failures
- Part of a 4-patch series (though this patch is standalone)
- Only applicable to stable trees v6.16+ (limited scope)
- The actual failure depends on platform-specific DMA controller
  constraints

**Stable rules checklist:**
1. Obviously correct and tested? YES (reviewed by infrastructure author)
2. Fixes a real bug? YES (wrong DMA device queried, potentially wrong
   constraints)
3. Important issue? MEDIUM (potential DMA failures on specific hardware)
4. Small and contained? YES (1 line, 1 file)
5. No new features? YES (pure correctness fix)
6. Can apply to stable? YES for v6.16+ trees

## Verification

- [Phase 1] Parsed tags: Reviewed-by from Thomas Zimmermann and
  AngeloGioacchino Del Regno. No Fixes: tag, no Reported-by.
- [Phase 2] Diff: single line changed in `drm_prime_pages_to_sg()`,
  `dev->dev` -> `drm_dev_dma_dev(dev)`
- [Phase 3] git blame: line 862 from commit 707d561f77b5e (2020). Bug
  context from 143ec8d3f9396 (v6.16).
- [Phase 3] git show 143ec8d3f9396: confirmed it updated
  `drm_gem_prime_import()` but missed `drm_prime_pages_to_sg()`
- [Phase 3] git tag --contains: 143ec8d3f9396 in v6.16+, 7d7bb790aced3
  (Rockchip DMA dev) in v6.19+
- [Phase 4] Found original patch on lore.gitlab.freedesktop.org - v1 and
  v2, Reviewed-by from Zimmermann
- [Phase 4] Cover letter confirms: "this was missing from the original
  change"
- [Phase 5] grep for callers: 15+ call sites across DRM drivers,
  includes Rockchip direct + USB via SHMEM helper
- [Phase 5] `drm_dev_dma_dev()` verified: returns `dev->dma_dev` if set,
  else `dev->dev` (safe fallback)
- [Phase 6] Code exists in v6.16+ trees; 7.0 tree has all prerequisites
- [Phase 6] `dma_max_mapping_size()` code path verified: for device
  without DMA ops, returns SIZE_MAX via `dma_direct_max_mapping_size()`,
  which may not reflect actual DMA controller limits
- [Phase 8] Rockchip commit 7d7bb790aced3 explicitly mentions "swiotlb
  buffer is full" warnings from GEM prime paths - same class of issue
- UNVERIFIED: Whether USB DRM devices have actually hit DMA failures
  from this specific path (no user reports found)

This is a minimal, obviously correct one-line fix that addresses a
missed update in the dedicated DMA device infrastructure. While no
specific user failure has been reported for this exact path, the fix is
low-risk and addresses a real correctness issue that could manifest as
DMA mapping failures on Rockchip and USB display hardware. The fix is
standalone, reviewed by the infrastructure author, and has zero
regression risk.

**YES**

 drivers/gpu/drm/drm_prime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 51fdb06d3e9f2..9b44c78cd77fc 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -859,7 +859,7 @@ struct sg_table *drm_prime_pages_to_sg(struct drm_device *dev,
 		return ERR_PTR(-ENOMEM);
 
 	if (dev)
-		max_segment = dma_max_mapping_size(dev->dev);
+		max_segment = dma_max_mapping_size(drm_dev_dma_dev(dev));
 	if (max_segment == 0)
 		max_segment = UINT_MAX;
 	err = sg_alloc_table_from_pages_segment(sg, pages, nr_pages, 0,
-- 
2.53.0

