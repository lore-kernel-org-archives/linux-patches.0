Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757AF4C7B2B;
	Mon, 19 Oct 2026 14:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418479; cv=none; b=o1miuxC2BO68x2LMJ+EcDS1BOwVRSHdcMf2fFZd6W13P8h+/4oabhX8XO8LnX6CygcnjA1kSvIHB6I/1fIUQchPOpLc4vdY7ChWjK8fDD1gedw7gQdzg7SXzCBKG3U+e/UMvSvBCqL2ypW/bk9fuNFgNcbwHYxAJvYPmtGqVivQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418479; c=relaxed/simple;
	bh=y19LUGr+JeffvcKDFmlOmdu8xFQuQYqw+9nWGjlKoEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fIuazZiftgY8ryjT7FCdxxzaA6MKY2Ivpv2TPgJ/SmrlOIUlr+LIuawtCyca38Bsn8y6BmwfVJSoLtx7r3vTHxhyHzM6PHP1XAxVyDOL+YfDXECUmlzK/8DiiUC0BigFF37JE/2UurfQ2lgmC+iimqsgoMeJMDvEgSC2/qzz4d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ef3uNpXF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ef3uNpXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270A11F000C7;
	Mon, 19 Oct 2026 14:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418477;
	bh=hA8suylLM7JDukhpE4JXYMIspGye87RnTv0rkAgekpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ef3uNpXF8qZpWK3rJH6c9Ugbas23wWmawVcnCcJqOjjt+nVR2NWD68yv5ByZ1fZkG
	 LllREKpbRGdpb9rlK6TVcd0IXKyKBUx8fe7Np+lFVYFIK21FgFqTYiHpowKhU83v11
	 u//sm8LmtGDWL0U0S67KAAvBtJOcAy1yMs58xe3XPSCnAYjtz7GECh7aM7qT/bwa1M
	 QlQYX3Q2usKDB+dyqbY0tF219jlndOWeX609bzsJhkooJNs3b1wqSyeiqCm6pItdV3
	 6ACsTPvLT+Z/rsd7g+X8OGlES0SH4GauNvxTlryudbfZsmaGG1n1ndCPbxrtfBQC8W
	 /doTRvBABTJ3w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	robin.clark@oss.qualcomm.com,
	lumag@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/msm: detach the ARM DMA mapping before attaching our own domain
Date: Mon, 19 Oct 2026 09:49:27 -0400
Message-ID: <20261019135441.1420968-276-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 140b13475302601368c0cf4e193e66126a49feb3 ]

On ARM32 with CONFIG_ARM_DMA_USE_IOMMU, arch_setup_dma_ops() creates a
dma_iommu_mapping for every IOMMU-backed device and attaches its domain
to the device's IOMMU group. That domain is neither the group's default
nor its blocking domain, so when msm_iommu_new() later attaches the
domain the driver manages itself, __iommu_attach_group() refuses it:

	if (group->domain && group->domain != group->default_domain &&
	    group->domain != group->blocking_domain)
		return -EBUSY;

Both the GPU and the display controller are hit by this on apq8064
(IFC6410), leaving the board with no GPU and no display:

  adreno 4300000.gpu: failed to load adreno gpu
  adreno 4300000.gpu: probe with driver adreno failed with error -16
  mdp4 5100000.display-controller: [drm:msm_drm_kms_init] *ERROR* failed to load kms
  mdp4 5100000.display-controller: adev bind failed: -16

Other ARM32 DRM drivers that manage their own domains (tegra, rockchip,
exynos) drop the arch mapping first. Do the same in msm_iommu_new(),
which both the display and the GPU paths go through.

With this the GPU and the KMS device both initialise:

  [drm] Initialized msm 1.13.0 for 4300000.gpu on minor 0
  [drm] Initialized msm-kms 1.13.0 for 5100000.display-controller on minor 1

Assisted-by: Claude:claude-opus-5
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/743333/
Link: https://lore.kernel.org/r/20260730-fix-qcom-smmu-v2-3-18e0daf2d836@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the 6.1.188 picture: the -EBUSY attach path is present,
`qcom_defconfig` hits it, and the companion series crashes are not
reachable here. Writing up the full analysis.

## Phase 1: Commit message forensics

**Step 1.1:** Record: `[drm/msm] [detach] Drop the ARM32 DMA IOMMU
mapping so msm can attach its own domain`

**Step 1.2:** Record: Tags present:
- `Assisted-by: Claude:claude-opus-5`
- `Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>`
- `Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>`
  (author; ignore pipeline SOBs)
- `Patchwork: https://patchwork.freedesktop.org/patch/743333/`
- `Link: https://lore.kernel.org/r/20260730-fix-qcom-
  smmu-v2-3-18e0daf2d836@oss.qualcomm.com`
- No `Fixes:`, no `Cc: stable` (expected for this review)
- No `Reported-by` / `Tested-by` / syzbot

**Step 1.3:** Record: On ARM32 with `CONFIG_ARM_DMA_USE_IOMMU`,
`arch_setup_dma_ops()` attaches a `dma_iommu_mapping` domain that is
neither the group default nor blocking domain. `msm_iommu_new()` then
`iommu_attach_device()`s the driver-owned domain and
`__iommu_attach_group()` returns `-EBUSY`. Symptom on apq8064/IFC6410:
GPU probe fails with `-16`, MDP4 KMS fails with `-16`, no GPU and no
display. Author reports both devices initialise after the change.

**Step 1.4:** Record: Not a disguised cleanup. Explicit probe-failure
fix, matching tegra/rockchip/exynos.

## Phase 2: Diff analysis

**Step 2.1:** Record: One file, `drivers/gpu/drm/msm/msm_iommu.c`, +22
lines. Functions: file-scope includes; `msm_iommu_new()`. Surgical,
single-file.

**Step 2.2:** Record: Before: `msm_iommu_new()` attaches its domain
immediately. After: if `CONFIG_ARM_DMA_USE_IOMMU` and a mapping exists,
`arm_iommu_detach_device()` + `arm_iommu_release_mapping()`, then
attach. Probe/init path only; no-ops when the config is off.

**Step 2.3:** Record: `[Hardware workaround / logic] ARM DMA domain
occupies the group → EBUSY. Same detach-before-attach used by
rockchip/exynos in this tree.`

**Step 2.4:** Record: Obviously correct; copies an in-tree pattern.
Gated so ARM64/non-IOMMU is unchanged. Regression risk is low if the
companion iommu/msm crash is not reachable here (verified below).
`msm_iommu_new()` signature differs in 6.1, so the backport is a small
contextual insert, not a clean cherry-pick.

## Phase 3: Git history

**Step 3.1:** Record: `iommu_attach_device()` in `msm_iommu_new()` is
from `52da6d513183cf` (Jordan Crouse, 2020). Function exists since
`871d812aa43e6` (2013). EBUSY check in this tree is `0286300e604555`
(Jason Gunthorpe, 2022-05-09), in 6.1. Rockchip equivalent:
`8490cad4dc4e2`, also in this tree.

**Step 3.2:** Record: No `Fixes:` tag. Bug is the interaction of ARM DMA
attach + msm attaching its own domain + the 6.1 EBUSY check.

**Step 3.3:** Record: Recent `msm_iommu.c` churn in this tree is
unrelated (sgtable WARN, tlb ops). No prior msm ARM-DMA detach. Patch is
`3/3` of “Fix GPU and display on ARM32 platforms using the MSM IOMMU”:
1. `iommu/msm: track a context master per device and IOMMU`
2. `iommu/msm: use the IOMMU device for page table allocation`
3. this commit

Cover letter: all three needed on **mainline**; patches are independent
for different maintainers.

**Step 3.4:** Record: Dmitry Baryshkov is a Qualcomm/msm DRM maintainer;
many msm commits in this tree. Konrad reviewed this patch.

**Step 3.5:** Record: Applies standalone to 6.1’s attach site. Patch 1’s
fatal NULL deref is blamed on `da33e87bd2bf` (“iommu: Handle yet another
race around registration”) — **not** in this tree (`git merge-base --is-
ancestor` → no). Patch 2’s crash stack uses `msm_iommu_identity_attach`,
which **does not exist** in 6.1 `drivers/iommu/msm_iommu.c`. Those two
are not prerequisites for this -EBUSY fix here.

## Phase 4: Mailing list

**Step 4.1:** Record: `b4 dig -c 140b134753026` →
https://patch.msgid.link/20260730-fix-qcom-
smmu-v2-3-18e0daf2d836@oss.qualcomm.com
v1 and v2 same day. v2: dropped a `dev_warn` tweak (Konrad); rewrote
patch 2 (Robin Murphy). Applied version is v2 3/3. Lore HTTP 403/503;
thread recovered via `b4 dig -m`. No NAKs in the saved mbox. No reviewer
`Cc: stable`.

**Step 4.2:** Record: To/Cc included Rob Clark, Will Deacon, Joerg
Roedel, Robin Murphy, dri-devel, iommu, linux-arm-msm, freedreno. Konrad
Reviewed-by on this patch.

**Step 4.3:** Record: Author is the reporter; tested on IFC6410.
Concrete dmesg for GPU and KMS probe `-16`.

**Step 4.4:** Record: Series of three; this patch is drm/msm-only. Cover
letter: “only fixing all of them makes the board usable” on mainline.
For 6.1, the other two fix post-6.1 IOMMU-core behavior.

**Step 4.5:** Record: No stable@ discussion found
(lore.kernel.org/stable search not usable here; mbox has no stable
nomination).

## Phase 5: Code semantics

**Step 5.1:** Record: `msm_iommu_new()`.

**Step 5.2:** Record: Callers in this tree:
- `adreno_iommu_create_address_space()` → GPU probe (`adreno_gpu.c`)
- `mdp4_kms` init (`mdp4_kms.c`) → display
- `msm_kms_init_aspace()` (`msm_drv.c`) → MDP/DPU
- `a6xx_gmu.c` (a6xx; not apq8064)

Probe-time, not IRQ/hot path.

**Step 5.3:** Record: After the new detach: `iommu_attach_device()`.
Detach uses `arm_iommu_detach_device` / `arm_iommu_release_mapping`
(exported in this tree).

**Step 5.4:** Record: Reachable from platform probe of adreno/mdp4 when
the device is IOMMU-mapped. Userspace is not needed; boot on apq8064
with `qcom_defconfig` is enough.

**Step 5.5:** Record: Same pattern in this tree:
`rockchip_drm_dma_attach_device()`, `exynos_drm_dma.c`.

## Phase 6: This checkout (6.1.188)

**Step 6.1:** Record: Tree is **6.1.188** (`pending-6.1`,
`p-6.1-11-gffee1c0de6cf2`). Candidate `140b134753026` is **not** an
ancestor of HEAD (`name-rev`: `tags/next-20260821~61^2`).

Buggy code is here:

```402:425:drivers/gpu/drm/msm/msm_iommu.c
struct msm_mmu *msm_iommu_new(struct device *dev, struct iommu_domain
*domain)
{
        ...
        ret = iommu_attach_device(iommu->domain, dev);
        if (ret) {
                kfree(iommu);
                return ERR_PTR(ret);
        }
        return &iommu->base;
}
```

Same EBUSY test in `drivers/iommu/iommu.c` `__iommu_attach_group()`.
`arch_setup_dma_ops()` → `arm_setup_iommu_dma_ops()` attaches the ARM
mapping. `arch/arm/configs/qcom_defconfig` has `CONFIG_MSM_IOMMU=y`,
`CONFIG_ARM_SMMU=y` (selects `ARM_DMA_USE_IOMMU`),
`CONFIG_ARCH_MSM8960=y`, `CONFIG_DRM_MSM=m`. DT: `qcom-
apq8064-ifc6410.dts`, GPU `adreno-3xx@4300000`, MDP `mdp@5100000`.

**Step 6.2:** Record: Minor backport. 6.1 `msm_iommu_new(dev, domain)`
vs later `msm_iommu_new(dev, quirks)` with `iommu_paging_domain_alloc` /
`kzalloc_obj`. Insert the detach block before the existing
`iommu_attach_device()` and add the same `#if CONFIG_ARM_DMA_USE_IOMMU`
stubs rockchip already uses.

**Step 6.3:** Record: No msm ARM-DMA detach in this tree.

## Phase 7: Subsystem

**Step 7.1:** Record: `[drm/msm IOMMU] [IMPORTANT]` — not core mm/net,
but GPU+display on Qualcomm ARM32. Official `qcom_defconfig`.

**Step 7.2:** Record: msm DRM is active; this ARM32 IOMMU attach path is
old and stable.

## Phase 8: Impact and risk

**Step 8.1:** Record: ARM32 Qualcomm with `CONFIG_ARM_DMA_USE_IOMMU` and
msm DRM+IOMMU — `qcom_defconfig`, apq8064 (IFC6410, Nexus 7 flo, etc.).

**Step 8.2:** Record: Every boot/probe of GPU and display. Not a race.
Unprivileged userspace not required.

**Step 8.3:** Record: Probe `-EBUSY` → no GPU, no display. Severity
**HIGH** for those boards (board graphics unusable). Not a generic
panic.

**Step 8.4:** Record: Benefit high for affected ARM32 qcom; risk low
(config-gated, copies in-tree pattern, ~15 lines in one function).
Companion mainline crashes are not the 6.1 detach path
(`msm_iommu_identity_attach` missing; 6.1 `arm_iommu_detach_device`
NULLs `dma_ops` after detach, and this patch’s extra `release_mapping`
runs with `dma_ops` already NULL).

## Phase 9: Synthesis

**Evidence FOR:**
- Real, tested probe failure: GPU+KMS `-EBUSY` on IFC6410
- Mechanism present in 6.1 (attach + EBUSY check + ARM DMA mapping)
- Official `qcom_defconfig` enables the triggering config
- Small, matches rockchip/exynos already in this tree
- Reviewed by Konrad Dybcio; msm maintainer author
- Hardware-workaround class (existing driver, existing boards)

**Evidence AGAINST:**
- Cherry-pick does not apply cleanly (`msm_iommu_new` signature)
- Series 3/3; cover letter says all three needed on mainline
- ARM32 / older SoCs only
- Not a UAF/security/panic by itself

**Unresolved:** Whether incomplete multi-IOMMU stream-ID programming
(patch 1, “wrong for years”) still limits display/GPU quality after
attach succeeds. That did not block probe; this patch fixes the probe
blocker.

**Stable rules:**
1. Obviously correct and tested? **PASS** (in-tree pattern; IFC6410)
2. Real bug affecting users? **PASS** (`qcom_defconfig` apq8064)
3. Important? **PASS** (complete GPU+display failure; quirk/enablement
   exception)
4. Small? **PASS** (+22 lines, one file; small 6.1 adapt)
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** (minor context adapt)

**Exception:** Hardware workaround for ARM32 IOMMU vs driver-managed
domain, same class as existing DRM ARM DMA detach.

This tree is 6.1.188. The attach/`-EBUSY` bug is here, the devices and
defconfig are here, and the mainline series mates that crash on later
IOMMU core behavior are not required for this fix.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Konrad; lore/patchwork links; no
  Fixes/stable/syzbot
- [Phase 2] Diff: +22 in `msm_iommu_new()`, detach ARM mapping then
  `iommu_attach_device()`
- [Phase 3] Blame: attach from `52da6d513183cf` (2020); EBUSY
  `0286300e604555` in this tree; rockchip detach `8490cad4dc4e2` in this
  tree
- [Phase 3] `git merge-base --is-ancestor 140b134753026 HEAD` → no
  (commit is linux-next, not 6.1)
- [Phase 3] Companion Fixes `da33e87bd2bf` not in 6.1; no
  `identity_attach` in 6.1 msm IOMMU
- [Phase 4] `b4 dig -c 140b134753026` / `-a` / `-w` / `-m`: v2 3/3,
  cover letter, Konrad R-b, Robin feedback on patch 2
- [Phase 5] Callers: adreno, mdp4, `msm_kms_init_aspace` at probe
- [Phase 6] `git describe HEAD` / Makefile: 6.1.188 pending-6.1; buggy
  `msm_iommu_new()` at line 419
- [Phase 6] `qcom_defconfig`: MSM_IOMMU=y, ARM_SMMU=y, DRM_MSM=m,
  ARCH_MSM8960=y
- [Phase 8] Failure: GPU/KMS probe `-16`/`-EBUSY`, no display; HIGH for
  those boards
- UNVERIFIED: live IFC6410 boot on 6.1.188 (author tested mainline)

**YES**

 drivers/gpu/drm/msm/msm_iommu.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
index 82a172f21a3ec..41a4eaa1b8fd9 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -7,6 +7,15 @@
 #include <linux/adreno-smmu-priv.h>
 #include <linux/io-pgtable.h>
 #include <linux/kmemleak.h>
+
+#if defined(CONFIG_ARM_DMA_USE_IOMMU)
+#include <asm/dma-iommu.h>
+#else
+#define arm_iommu_detach_device(...)	({ })
+#define arm_iommu_release_mapping(...)	({ })
+#define to_dma_iommu_mapping(dev)	NULL
+#endif
+
 #include "msm_drv.h"
 #include "msm_gpu_trace.h"
 #include "msm_mmu.h"
@@ -746,6 +755,19 @@ struct msm_mmu *msm_iommu_new(struct device *dev, unsigned long quirks)
 
 	mutex_init(&iommu->init_lock);
 
+	/*
+	 * ARM32 attaches a DMA mapping domain to every IOMMU-backed device,
+	 * which would make attaching our own domain fail with -EBUSY.
+	 */
+	if (IS_ENABLED(CONFIG_ARM_DMA_USE_IOMMU)) {
+		struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
+
+		if (mapping) {
+			arm_iommu_detach_device(dev);
+			arm_iommu_release_mapping(mapping);
+		}
+	}
+
 	ret = iommu_attach_device(iommu->domain, dev);
 	if (ret) {
 		iommu_domain_free(domain);
-- 
2.53.0

