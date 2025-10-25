Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50755309F17;
	Sat, 25 Oct 2025 16:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409162; cv=none; b=ay6eibAp4kEquSxw7qudQtRkwSgBV00ArjCaMAkvSSUB1jQUz1D6N43CzgO/hki8ug8PrTOxg/JOdBKx17bvRQxm3OcMFzv2gLWhsa2cEQpKUMvQIvhO8enDtbBKyg0iPILHfJ5nlSKyEOKRKmLFHxjao5x/lHPHU0FAWZyVyC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409162; c=relaxed/simple;
	bh=sYzqJpSR0UKf+ZA4yygS6qyiCwwd5ncMbcASSPXfctc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bKjh71kgaV19XwiE7RE4ziE3fm91ildOAEGjdWE8LpMmm6UJ2gSDheLO1TPOm8GzKyCQDGIY/aSB7MyVC2Djpn0hoHfbN1jKRp1dTbEFpDpURO5UvS6w9Xh9cjCm8og9Yryk880/RfdY/h0jSdAXxbKI/taSnAcuqpSHG/Rf50g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BpzdtX/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BpzdtX/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E295C4CEF5;
	Sat, 25 Oct 2025 16:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409162;
	bh=sYzqJpSR0UKf+ZA4yygS6qyiCwwd5ncMbcASSPXfctc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpzdtX/1J2Q7eFVJysqeW2u4Fbu6Lt1DTEiOuU4qRjEPYLbqFo4kLaBETNkMiOhmm
	 9/++QGjwLvlZYtNpP+lApKHdn41NkIUcY9nTM1wZqL8NIQt23u74vWQGdudNzJzXbm
	 WcV0SvtLoThJcse6Gfb3wd1i/VaObqW72NuA9X30RvsUHNEBM4+mVVVyaF+GvRVSbx
	 TRU5gWTyjxkTUms7eFYQn77S7LUafXO/y9f4CfnibeEsmFGu7bTmN8YuK6mMbQaEuQ
	 eNWUMvAWqhL2YAgkPwSpMurlXHjfB5jb0VeoZmbUU4BUt9v4Bgz2u24SlM8QHt/yiB
	 OP1ILKqzYNiXg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Simon Richter <Simon.Richter@hogyros.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/xe: Make page size consistent in loop
Date: Sat, 25 Oct 2025 11:57:36 -0400
Message-ID: <20251025160905.3857885-225-sashal@kernel.org>
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

From: Simon Richter <Simon.Richter@hogyros.de>

[ Upstream commit b85bb2d677153d990924d31be9416166d22382eb ]

If PAGE_SIZE != XE_PAGE_SIZE (which is currently locked behind
CONFIG_BROKEN), this would generate the wrong number of PDEs.

Since these PDEs are consumed by the GPU, the GPU page size needs to be
used.

Signed-off-by: Simon Richter <Simon.Richter@hogyros.de>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250818064806.2835-1-Simon.Richter@hogyros.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The loop that writes PDEs uses the host `PAGE_SIZE` instead of the
    GPU page size `XE_PAGE_SIZE`, causing an incorrect PDE count when
    they differ. In 6.17.1, this is at
    drivers/gpu/drm/xe/xe_migrate.c:292:
    - Current: for (i = 0; i < map_ofs / PAGE_SIZE; i++) {
    - Intended: for (i = 0; i < map_ofs / XE_PAGE_SIZE; i++) {
  - The PDEs are consumed by the GPU and the offsets encoded for each
    entry already use `XE_PAGE_SIZE`
    (drivers/gpu/drm/xe/xe_migrate.c:293–297), so the loop bound must
    match that unit.

- Why it matters
  - When `PAGE_SIZE != XE_PAGE_SIZE` (e.g., 64K host pages vs 4K GPU
    pages), the loop iterates too few times (by a factor of `PAGE_SIZE /
    XE_PAGE_SIZE`), leaving a large portion of PDEs unwritten. That
    results in incomplete page table coverage and GPU faults/hangs when
    accessing those unmapped regions. The fix enforces GPU page
    granularity for the loop count, which is the only correct
    interpretation since the GPU page tables and the offsets (i *
    XE_PAGE_SIZE) are in GPU page units.
  - The rest of the function already treats `map_ofs` in GPU page units:
    - PDE setup for upper levels uses `XE_PAGE_SIZE`
      (drivers/gpu/drm/xe/xe_migrate.c:285–288).
    - The VM suballocator capacity is computed with `map_ofs /
      XE_PAGE_SIZE` (drivers/gpu/drm/xe/xe_migrate.c:356–357).
  - This change removes an inconsistency within the same function and
    aligns the loop with how `map_ofs` is used elsewhere.

- Scope and risk
  - One-line change, confined to xe migrate VM setup
    (`xe_migrate_prepare_vm()`), no API or architectural changes.
  - On the common 4K-host-page configurations, `PAGE_SIZE ==
    XE_PAGE_SIZE`, so behavior is identical. Risk of regression on
    mainstream builds is effectively zero.
  - On kernels where `PAGE_SIZE != XE_PAGE_SIZE`, it fixes real
    misprogramming of PDEs that can manifest as GPU page faults/hangs.

- Current gating and impact
  - `DRM_XE` Kconfig currently depends on `PAGE_SIZE_4KB || COMPILE_TEST
    || BROKEN` (drivers/gpu/drm/xe/Kconfig: depends on PAGE_SIZE_4KB ||
    COMPILE_TEST || BROKEN). The commit message notes this path is
    presently behind `CONFIG_BROKEN`. Even so, this is a correctness bug
    that becomes user-visible as soon as non-4K is enabled, and it is
    harmless on 4K systems.

- Stable criteria
  - Fixes a clear bug in page table programming that can affect users
    when the constraint is relaxed or under non-4K configurations.
  - Minimal, well-contained change with no feature additions, and no
    architectural rewrites.
  - No adverse side effects; only enforces correct unit semantics.
  - Reviewed by xe maintainers according to the commit tags.

Summary: Replace `map_ofs / PAGE_SIZE` with `map_ofs / XE_PAGE_SIZE` in
the PDE emission loop (drivers/gpu/drm/xe/xe_migrate.c:292) to make the
loop’s unit consistent with GPU page size and the rest of the function’s
logic. This is an obvious, low-risk bugfix suitable for stable backport.

 drivers/gpu/drm/xe/xe_migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index 9b1e3dce1aea3..2a627ed64b8f8 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -291,7 +291,7 @@ static int xe_migrate_prepare_vm(struct xe_tile *tile, struct xe_migrate *m,
 	}
 
 	/* Write PDE's that point to our BO. */
-	for (i = 0; i < map_ofs / PAGE_SIZE; i++) {
+	for (i = 0; i < map_ofs / XE_PAGE_SIZE; i++) {
 		entry = vm->pt_ops->pde_encode_bo(bo, (u64)i * XE_PAGE_SIZE);
 
 		xe_map_wr(xe, &bo->vmap, map_ofs + XE_PAGE_SIZE +
-- 
2.51.0

