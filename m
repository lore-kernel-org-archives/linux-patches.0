Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECAE4AD4D1;
	Mon, 31 Aug 2026 13:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184081; cv=none; b=CqmFqtZzDRQsbcebHFD1xKcskqJD0oDKfZcaTnN1vZjHcmPZOJ2ai6JJQSYqedtryIueLkmUtYXui1e2eX0i+s6vhddpRSkH4jv1lGvvlpxaiYmpY2BGa74eo0hdIuMIq7XwmhWRVIIEAlKzJeqQJ+0K5Kd3H7VSAmUewY2dnGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184081; c=relaxed/simple;
	bh=O5kRaeR9f0r0e6us0fxDnJ6kG8eWsZtt15zJFb0ROsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fmuWxv+A2S8Y+Uu3hnOmcyjPUlRV6U0ugPAlYIVk1S53Kctmpw6rdgXje0D7S3bo/8VP9aIVrLcRDVlf65G5Xg200cqTabpYVFtLAoLjojfWd1+OtGmJSLd0W4uYsU//ESPmZArM+2qwifNaLoCA2gBsEQ21LpvscPz+633ABWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNhSbb0f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNhSbb0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0181F00ADE;
	Mon, 31 Aug 2026 13:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184079;
	bh=xFBZjdugEu8CzvBss5uPEr5e3VPZag3QiccvE5K6ZvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNhSbb0fprmMFZT3j3n1VigVKR83kSU6/a5L0fOZByTx62DPidtoqj3p3BkH1Kqfj
	 bmFe6AwHdKgTWz+We3j8GbHipfl17zztUE0sBR+RL8rM97sjzVG0tbu61vOGe7gsZe
	 oWJD1d/rY0frkhAd/nTV29Y8HmSbQHuZIKRuEeE2GtjsqZMeipnXtzelqYfnzSWZ2O
	 Jmvzy6l0nHMG/bZDvtQAxR7s4bbhkF/jpwKd8LzZ0ZaCkD7mXbGi0FdX42BMdaza6u
	 1POgWbw5HmiAS8qJlkHmKvrKgwO7NqL8PEGcq8sitApNx+rZslEDCiDsbkSW7OAGkx
	 zhvWby72Xz8cA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Timur Tabi <ttabi@nvidia.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/nouveau/bios: skip the IFR header if present
Date: Mon, 31 Aug 2026 09:28:26 -0400
Message-ID: <20260831133314.4125787-478-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit 4beeac5d2015df1017732ce4c57d634f557dd304 ]

The GPU's ROM may begin with an Init-from-ROM (IFR) header that precedes
the PCI Expansion ROM images (VBIOS).  When present, the PROM shadow
method must parse this header to determine the offset where the PCI ROM
images actually begin, and adjust all subsequent reads accordingly.

On most GPUs this is not needed because either the PRAMIN shadow method
(which reads from VRAM via the display engine) succeeds first, or the IFR
microcode has already applied the ROM offset so that PROM reads
transparently skip the header.  However, on GA100 neither of these
applies: GA100 has no display engine (so PRAMIN is unavailable), and the
IFR offset is not applied to PROM reads on this GPU.

Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260430223838.2530778-9-ttabi@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/nouveau/bios: skip the IFR header if
present`

**Local tree:** `v6.18.44` (kernel 6.18.44)
**Upstream commit:** `4beeac5d2015df1017732ce4c57d634f557dd304` (not
merged into this tree; `git merge-base --is-ancestor` returns exit 1)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/nouveau/bios]` `[skip]` — When a GPU ROM starts with
an Init-from-ROM (IFR) header, PROM shadow reads must skip it to reach
the PCI Expansion ROM (VBIOS).

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Timur Tabi `<ttabi@nvidia.com>` (author)
- **Reviewed-by:** Lyude Paul `<lyude@redhat.com>` (nouveau maintainer)
- **Link:**
  https://patch.msgid.link/20260430223838.2530778-9-ttabi@nvidia.com
- **Signed-off-by:** Danilo Krummrich `<dakr@kernel.org>` (DRM
  maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or syzbot
  tags
- Notable: maintainer review present; part of v2 08/10 in the “fix GA100
  issues” series

### Step 1.3: Body analysis
**Record:**
- **Bug:** GA100 ROMs can begin with an IFR header before the PCI ROM
  (`0xAA55`). PROM shadow reads from offset 0 without skipping IFR read
  invalid data.
- **Symptom:** VBIOS shadow fails → `nvbios_shadow()` returns `-EINVAL`
  (“unable to locate usable image”) → nouveau probe fails on GA100.
- **Root cause:** GA100 has no display engine (PRAMIN unavailable), and
  IFR offset is not applied to PROM reads on this GPU.
- **Versions:** GA100-specific; other GPUs use PRAMIN first or have IFR
  offset applied by hardware.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Subject says “skip” rather than “fix”, but this is a
hardware-specific correctness bug in VBIOS loading, not cleanup or
optimization.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowrom.c` (+101
  / -9)
- **Functions:** `nvbios_prom_read()`, `nvbios_prom_fini()`,
  `nvbios_prom_init()`
- **Scope:** Single-file, hardware-specific logic addition

### Step 2.2: Code flow changes
**Record:**
- **Hunk 1 (`nvbios_prom_read`):** Before: read `0x300000 + offset` with
  only 1MB window check. After: add `bios->size` bounds check; apply
  `pci_rom_offset` to all PROM reads.
- **Hunk 2 (`nvbios_prom_fini`):** Before: `device` pointer passed
  directly, no free. After: `priv` struct with `kfree(data)` after re-
  enabling ROM shadow.
- **Hunk 3 (`nvbios_prom_init`):** Before: disable ROM shadow, return
  `device`. After: allocate `priv`, detect IFR signature `0x4947564E`
  (“NVGI”), parse v1/v2/v3 headers, validate PCI ROM `0xAA55` at
  computed offset; fail cleanly on error.

### Step 2.3: Bug mechanism
**Record:** **Logic / hardware-layout bug.** PROM reads assumed PCI ROM
at offset 0. On GA100 with IFR header, VBIOS is at a higher offset.
Wrong data → invalid PCI ROM header/checksum → BIOS shadow scoring
fails.

### Step 2.4: Fix quality
**Record:** Fix is logically sound and defensive (signature checks,
offset bounds, `0xAA55` validation, proper cleanup on failure).
Regression risk is low: IFR parsing runs only when `0x300000` contains
“NVGI”; otherwise `pci_rom_offset` stays 0 and behavior is unchanged.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Core PROM logic dates to Ben Skeggs, 2014
(`ad4a362635353f`). GA100 recognition added 2021 (`3b050680c8415`,
`a34632482f1ea`). IFR handling was never implemented; gap present since
GA100 support landed.

### Step 3.2: Fixes tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- `340936ebf5aec` — “specify correct display fuse register for Ampere
  and Ada” **already backported to this 6.18.44 tree** (patch 7/10 in
  same series)
- GA100 initial BIOS support: `a34632482f1ea` (2021)
- No prior IFR parsing commits in this tree

### Step 3.4: Author context
**Record:** Timur Tabi (NVIDIA) authored the GA100 fix series. Lyude
Paul reviewed. Danilo Krummrich applied the full v2 series to drm-misc-
next (May 2026).

### Step 3.5: Dependencies
**Record:** Standalone in `shadowrom.c`. Uses `kzalloc_obj()` (present
in `include/linux/slab.h`). References
`Documentation/gpu/nova/core/vbios.rst` (IFR section not in this tree’s
doc, but code does not depend on it). Patch applies cleanly (`git apply
--check` passed). Sister patch 7/10 already in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260430223838.2530778-9-ttabi@nvidia.com
- **Series:** v1 (6 patches, Apr 7 2026) → v2 (10 patches, Apr 30 2026);
  committed version is latest v2
- **Cover letter:** GA100 has VBIOS but no display engine; must use
  PROM; VBIOS has IFR header that must be parsed
- No explicit stable nomination in thread; no NAKs found

### Step 4.2: Reviewers
**Record:** CC’d: Lyude Paul, Danilo Krummrich, David Airlie,
`nouveau@lists.freedesktop.org`. Reviewed-by: Lyude Paul.

### Step 4.3: Bug reports
**Record:** No external bug report or syzbot link. Issue identified
during GA100 enablement work by NVIDIA.

### Step 4.4: Series context
**Record:** Part of “drm/nouveau: fix GA100 issues” (10 patches). Other
patches (GSP-RM, FRTS, MMU_LOCK, etc.) are **not** in this 6.18.44 tree.
This patch is independently valuable for correct PROM/VBIOS reading even
if full GA100 boot needs additional series commits.

### Step 4.5: Stable list
**Record:** No stable-list discussion found. Precedent: patch 7/10 from
same series was cherry-picked into this stable tree as `340936ebf5aec`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `nvbios_prom_init()`, `nvbios_prom_read()`,
`nvbios_prom_fini()`

### Step 5.2: Callers
**Record:** `nvbios_shadow()` in `shadow.c` calls these via
`shadow_method()` → `shadow_image()`. `nvbios_shadow()` is called from
`nvkm_bios_new()` in `base.c` during device probe. BIOS loading is on
the critical probe path.

### Step 5.3: Callees
**Record:** `nvkm_rd32()`, `nvkm_pci_rom_shadow()`, `kzalloc_obj()`,
`kfree()`, `nvkm_error()`

### Step 5.4: Reachability
**Record:** Triggered at nouveau probe on any GPU where PROM shadow is
attempted. On GA100 without display, PRAMIN fails (especially after
`340936ebf5aec` fuse fix), making PROM the fallback. Userspace can load
the nouveau module and trigger probe on GA100 hardware.

### Step 5.5: Similar patterns
**Record:** `shadowramin.c` has GA100-specific handling; `shadowpci.c`
uses a similar `priv` + bounds-check pattern. No duplicate IFR parsing
elsewhere in nouveau.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `shadowrom.c` reads PROM from `0x300000 +
i` with no IFR handling. GA100 support (`nv170_chipset` in `base.c`,
`card_type >= GA100` in `shadowramin.c`) is present. Bug has existed
since GA100 support was added (~2021).

### Step 6.2: Backport complications
**Record:** **Clean apply** verified against upstream patch. No
structural conflicts. `kzalloc_obj` available. Doc reference is
informational only.

### Step 6.3: Related fixes already present?
**Record:** `340936ebf5aec` (display fuse register for GA100) is present
— it correctly makes PRAMIN fail on display-less GA100, increasing
reliance on PROM and making this fix more important. No duplicate IFR
fix found.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/gpu/drm/nouveau` — **IMPORTANT** (GPU driver;
affects nouveau users on specific hardware, not core kernel paths).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; GA100-related work ongoing in 2026.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of **NVIDIA GA100 (A100)** with nouveau enabled. Niche
but real datacenter/compute hardware already recognized in this tree.

### Step 8.2: Trigger conditions
**Record:** GA100 GPU + nouveau probe + PROM BIOS shadow path used
(typical when PRAMIN unavailable). Not userspace-exploitable;
hardware/config-specific.

### Step 8.3: Failure mode severity
**Record:** VBIOS load failure → driver probe failure (`-EINVAL`).
**Severity: HIGH** for affected GA100 users (GPU non-functional with
nouveau); **no impact** on other GPUs.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for GA100 nouveau users; enables correct VBIOS
  reading
- **Risk:** LOW — gated on IFR signature match; sister patch already in
  tree; maintainer-reviewed
- **Ratio:** Favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real probe failure on GA100 (supported hardware in this tree)
- Hardware-specific workaround (stable exception category)
- Reviewed by nouveau maintainer (Lyude Paul)
- Sister patch 7/10 from same series already in 6.18.44
- Applies cleanly; self-contained in one file
- Low regression risk on non-IFR GPUs

**AGAINST backport:**
- ~100 lines (borderline on “small” criterion)
- Full GA100 functionality still needs other series patches not in tree
- Niche hardware population
- No syzbot/user bug report

**Unresolved:** None blocking the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reviewed by maintainer;
   logic validated against IFR spec
2. Fixes real bug affecting users? **PASS** — VBIOS load failure on
   GA100
3. Important issue? **PASS** — driver probe failure on supported
   hardware
4. Small and contained? **PASS** (borderline) — one file, no refactor;
   ~100 lines but focused
5. No new features/APIs? **PASS** — hardware workaround, no userspace
   API change
6. Can apply to local tree? **PASS** — verified clean apply;
   prerequisites present

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — GA100-specific ROM layout
requiring IFR header parsing before PCI ROM access.

### Step 9.4: Decision rationale
This tree (6.18.44) already recognizes GA100 and has already backported
the companion display-fuse fix from the same series. Without IFR header
parsing, PROM-based VBIOS loading fails on GA100, blocking nouveau
probe. The fix is maintainer-reviewed, applies cleanly, and only changes
behavior when an IFR header is detected. The incomplete state of other
GA100 series patches does not diminish the standalone correctness and
value of this BIOS-reading fix.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Confirmed Reviewed-by: Lyude Paul; no syzbot/Fixes tags
- **[Phase 2]** Diff analysis: +101/-9 in `shadowrom.c`; IFR parsing +
  bounds checks
- **[Phase 3]** `git describe HEAD`: v6.18.44 / kernel 6.18.44
- **[Phase 3]** `git blame shadowrom.c`: core code from 2014; no IFR
  handling ever added
- **[Phase 3]** `git log shadowrom.c`: 6 commits, no IFR-related changes
- **[Phase 3]** `340936ebf5aec` in tree: sister patch 7/10 already
  backported
- **[Phase 3]** `git merge-base --is-ancestor 4beeac5d2015 HEAD`: exit 1
  (commit not in tree)
- **[Phase 4]** `b4 dig -c 4beeac5d2015`: found v2 08/10 at
  patch.msgid.link URL
- **[Phase 4]** `b4 dig -a`: v1 and v2 series identified; v2 is latest
- **[Phase 4]** `b4 dig -w`: Lyude Paul, Danilo Krummrich, David Airlie
  CC’d
- **[Phase 4]** `/tmp/ifr_thread.mbox`: cover letter describes GA100
  VBIOS/IFR issue; Danilo applied full series; no stable nomination; no
  NAKs
- **[Phase 5]** Read `shadow.c`: `nvbios_prom` tried after PRAMIN in
  `nvbios_shadow()`
- **[Phase 5]** Read `base.c`: `nvkm_bios_new()` calls `nvbios_shadow()`
  on probe
- **[Phase 5]** Read `shadowramin.c`: GA100 uses fuse register
  `0x820c04`; fails when display disabled
- **[Phase 5]** Read `base.c`: `nv170_chipset` GA100 defined with bios
  subdev
- **[Phase 6]** Read current `shadowrom.c`: buggy code confirmed present
  (no IFR handling)
- **[Phase 6]** `git apply --check` upstream patch: applies cleanly
- **[Phase 6]** `grep kzalloc_obj include/linux/slab.h`: macro exists
- **[Phase 8]** Failure mode traced: `nvbios_shadow()` → “unable to
  locate usable image” → probe `-EINVAL`

**YES**The background searches finished and match what the analysis
already used:

- **6.18.44 tree** — IFR header fix is **not** present; buggy
  `shadowrom.c` code is there
- **Upstream commit** — `4beeac5d2015` (“skip the IFR header if
  present”)
- **GA100 support** — in-tree since 2021; companion patch
  `340936ebf5aec` (display fuse) is already backported
- **Patch applies cleanly** to this tree

**Verdict for 6.18.44: YES** — backport this fix so GA100 can load VBIOS
via PROM when PRAMIN isn’t available.

 .../drm/nouveau/nvkm/subdev/bios/shadowrom.c  | 110 ++++++++++++++++--
 1 file changed, 101 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowrom.c b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowrom.c
index 39144ceb117b4..9e171b1bad732 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowrom.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadowrom.c
@@ -24,34 +24,126 @@
 
 #include <subdev/pci.h>
 
+#define NV_PBUS_IFR_FMT_FIXED0_SIGNATURE_VALUE 0x4947564E	/* "NVGI" */
+#define NV_ROM_DIRECTORY_IDENTIFIER 0x44524652			/* "RFRD" */
+
+struct priv {
+	struct nvkm_device *device;
+	u32 pci_rom_offset;
+};
+
 static u32
 nvbios_prom_read(void *data, u32 offset, u32 length, struct nvkm_bios *bios)
 {
-	struct nvkm_device *device = data;
+	struct priv *priv = data;
+	struct nvkm_device *device = priv->device;
 	u32 i;
-	if (offset + length <= 0x00100000) {
-		for (i = offset; i < offset + length; i += 4)
-			*(u32 *)&bios->data[i] = nvkm_rd32(device, 0x300000 + i);
-		return length;
-	}
-	return 0;
+
+	/* Make sure we don't try to read past the end of data[] */
+	if (offset + length > bios->size)
+		return 0;
+
+	/* Make sure the read falls within the 1MB PROM window */
+	if (offset + priv->pci_rom_offset + length > 0x00100000)
+		return 0;
+
+	for (i = offset; i < offset + length; i += 4)
+		*(u32 *)&bios->data[i] = nvkm_rd32(device, 0x300000 + priv->pci_rom_offset + i);
+	return length;
 }
 
 static void
 nvbios_prom_fini(void *data)
 {
-	struct nvkm_device *device = data;
+	struct priv *priv = data;
+	struct nvkm_device *device = priv->device;
+
 	nvkm_pci_rom_shadow(device->pci, true);
+
+	kfree(data);
 }
 
 static void *
 nvbios_prom_init(struct nvkm_bios *bios, const char *name)
 {
 	struct nvkm_device *device = bios->subdev.device;
+	struct priv *priv;
+	u32 fixed0;
+
+	/* There is no PROM on NV4x iGPUs */
 	if (device->card_type == NV_40 && device->chipset >= 0x4c)
 		return ERR_PTR(-ENODEV);
+
+	priv = kzalloc_obj(*priv);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+
+	/* Disable the PCI ROM shadow so that we can read PROM. */
 	nvkm_pci_rom_shadow(device->pci, false);
-	return device;
+
+	/*
+	 * Check for an IFR header. If present, parse it to find the actual PCI ROM header.
+	 *
+	 * The IFR header is documented in Documentation/gpu/nova/core/vbios.rst
+	 */
+	fixed0 = nvkm_rd32(device, 0x300000);
+	if (fixed0 == NV_PBUS_IFR_FMT_FIXED0_SIGNATURE_VALUE) {
+		u32 fixed1 = nvkm_rd32(device, 0x300004);
+		u8 version = (fixed1 >> 8) & 0xff;
+		u32 fixed2, data_size, offset, signature;
+
+		switch (version) {
+		case 1:
+		case 2:
+			data_size = (fixed1 >> 16) & 0x7fff;
+			priv->pci_rom_offset = nvkm_rd32(device, 0x300000 + data_size + 4);
+			break;
+		case 3:
+			fixed2 = nvkm_rd32(device, 0x300008);
+			data_size = fixed2 & 0x000fffff;
+
+			/* ROM directory offset */
+			offset = nvkm_rd32(device, 0x300000 + data_size) + 4096;
+
+			signature = nvkm_rd32(device, 0x300000 + offset);
+			if (signature != NV_ROM_DIRECTORY_IDENTIFIER) {
+				nvkm_error(&bios->subdev, "could not find IFR ROM directory\n");
+				goto fail;
+			}
+
+			priv->pci_rom_offset = nvkm_rd32(device, 0x300000 + offset + 8);
+
+			break;
+		default:
+			nvkm_error(&bios->subdev, "unsupported IFR header version %u\n",
+				   version);
+			goto fail;
+		}
+
+		/* Double-check that the offset is valid */
+		if (priv->pci_rom_offset >= 0x00100000) {
+			nvkm_error(&bios->subdev,
+				   "PCI ROM offset of 0x%x is too large\n", priv->pci_rom_offset);
+			goto fail;
+		}
+
+		/* If there is an IFR header, there must also be a PCI ROM header. */
+		signature = nvkm_rd32(device, 0x300000 + priv->pci_rom_offset) & 0xffff;
+		if (signature != 0xaa55) {
+			nvkm_error(&bios->subdev,
+				   "could not find PCI ROM signature at offset 0x%x\n",
+				   priv->pci_rom_offset);
+			goto fail;
+		}
+	}
+
+	priv->device = device;
+	return priv;
+
+fail:
+	nvkm_pci_rom_shadow(device->pci, true);
+	kfree(priv);
+	return ERR_PTR(-ENODEV);
 }
 
 const struct nvbios_source
-- 
2.53.0

