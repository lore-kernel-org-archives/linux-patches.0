Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616A84A33ED;
	Mon, 31 Aug 2026 13:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183534; cv=none; b=P68E/SQsn+2HFdKf59hucVK1fVCAmnspagc9W5KgF8V8Q2+WHP21sUWQcl1jnB9vyueSIUIx7pB9Q3LRK+hSXTe9rG0LvSoXBiwJ3tFWxdPOtMJcbfyH1YYHc5uIIBLzER47pk2sGfR2JvgGnIVxv9Qoe31+XFrmvSGmtVgNlw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183534; c=relaxed/simple;
	bh=rhCm0geAEcF9Tc1PkDh0hEw8dNE+axynZR4UwU+wN44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uuomDr49jlo0RHYOAxAq6fNsqaZdyueOzXRWUmSU6R2zVr/KBKT3fmUfWPfiHA+nFHMR6JbMevrPAIoUU47TpcbmkMUhXug2pQT4qdLQwjwlaXXgz7A+xR8rCoI2XZeiaTJfhx6ch1Ll7qJsRL5+OwTg7xX7l9Zvnz5LfwtAvzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BOmNNTTS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOmNNTTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E651F00A3D;
	Mon, 31 Aug 2026 13:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183529;
	bh=GTJoiATLXiVe4pp58dNbtYx4Hn8uoVn3LxZcZyWNLCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BOmNNTTSjjCCuSfmyoaf0qle6/YjxFJNDuXvIB2/fwTjJw7tk2yfzTfw+mQyWlaLv
	 e8vLDEuRooziplxOpPQM6WaYPoMnpsDzSVH0dOCdQRwJzjyZRqIq3qjA58yTY9dc4A
	 tl8abjZQbMlu9bvICbC/Sz7JjOHiHtzQGrACO2aEvIfb6x8jXO5Bz36vkEAv2PsYK2
	 NxTbVxjtV+o9CWBk0GfSvlLzMbw4j9ABGwvNmCBR62uiU2nHA3dH+0ese/E4g2sYCD
	 kshT/tuIRCF4457nvigcbVhTOWimP7MsXQBNlFLaNbzHxNw4VWjYeZ9BbfrQXLq1WK
	 ex7MQOaRfmpvQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Han Gao <gaohan@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] riscv: kexec_file: Constrain segment placement to direct map
Date: Mon, 31 Aug 2026 09:22:59 -0400
Message-ID: <20260831133314.4125787-151-sashal@kernel.org>
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

From: Han Gao <gaohan@iscas.ac.cn>

[ Upstream commit b67a1ee0db0094c6cc158b087be6c334ad881a41 ]

When kexec_file_load places segments with buf_max=ULONG_MAX and
top_down=true, they land at the highest available physical addresses.
On RISC-V the size of the linear mapping is determined by the active
VM mode: SV39 caps the direct map at roughly 128GB, while SV48/SV57
extend the range substantially further. When the installed physical
memory exceeds the direct map size of the active mode, top-down
placement puts DTB/initrd at physical addresses outside the linearly
mapped region. The kexec'd kernel cannot reach them during early
boot, triggering a page fault at memcmp in start_kernel.

Fix by constraining buf_max to PFN_PHYS(max_low_pfn), which reflects
the runtime direct map boundary for the active VM mode (SV39/SV48/
SV57). This keeps all kexec segments within the linearly mapped
region while preserving the upstream top_down allocation strategy.

Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
Link: https://patch.msgid.link/20260519170641.123517-1-gaohan@iscas.ac.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[riscv: kexec_file]` `[Constrain]` — Constrain kexec_file
segment placement to stay within the RISC-V direct (linear) map.

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Han Gao <gaohan@iscas.ac.cn>` (author)
- `Link:
  https://patch.msgid.link/20260519170641.123517-1-gaohan@iscas.ac.cn`
- `Signed-off-by: Paul Walmsley <pjw@kernel.org>` (RISC-V maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: maintainer ack; no syzbot or user bug report tags

**Step 1.3 — Body analysis**

Record:
- **Bug:** With `buf_max=ULONG_MAX` and `top_down=true`, kexec_file
  segments (DTB, initrd, purgatory, elfcorehdr) are placed at the
  highest physical addresses. On RISC-V, the linear map size depends on
  the active VM mode (SV39 ≈ 128 GB; SV48/SV57 larger). When installed
  RAM exceeds the direct-map limit, segments land outside the linearly
  mapped region.
- **Symptom:** The kexec'd kernel page-faults in `memcmp` during
  `start_kernel` because it cannot access initrd/DTB.
- **Root cause:** Top-down placement is unconstrained by the direct-map
  boundary.
- **Fix approach:** Set `buf_max = PFN_PHYS(max_low_pfn)` to cap
  placement at the runtime direct-map limit.

**Step 1.4 — Hidden bug fix?**

Record: No — this is an explicit bug fix, not disguised cleanup. It
prevents a deterministic boot crash on affected hardware.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **Files:** `arch/riscv/kernel/machine_kexec_file.c` (+2, −1)
- **Functions:** `load_extra_segments()`
- **Scope:** Single-file, surgical (3 lines net)

**Step 2.2 — Code flow change**

Record:
- **Before:** `kbuf.buf_max = ULONG_MAX` — top-down placement can use
  any system RAM address up to `ULONG_MAX`.
- **After:** `kbuf.buf_max = PFN_PHYS(max_low_pfn)` — top-down placement
  is capped at the end of the linearly mapped region.
- **Path affected:** `load_extra_segments()` → `kexec_add_buffer()` →
  `kexec_locate_mem_hole()` → `locate_mem_hole_top_down()`, which uses
  `temp_end = min(end, kbuf->buf_max)`.

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Logic/correctness — incorrect memory placement.
- **Mechanism:** `locate_mem_hole_top_down()` in `kernel/kexec_file.c`
  places buffers at the top of each RAM range, bounded only by
  `buf_max`. With `ULONG_MAX`, segments can be placed beyond the direct
  map. The kexec'd kernel's early boot uses `__va()`/linear mapping to
  access DTB/initrd, causing a page fault if those addresses are not
  linearly mapped.

**Step 2.4 — Fix quality**

Record:
- Fix is minimal and clearly correct: `max_low_pfn` is set after
  memblock capping in `arch/riscv/mm/init.c` when RAM exceeds
  `KERN_VIRT_SIZE`.
- `max_low_pfn` is already declared in `linux/memblock.h` (already
  included).
- Regression risk is very low; worst case is `-EADDRNOTAVAIL` if no hole
  exists within the constrained range (preferable to a boot crash).

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: `kbuf.buf_max = ULONG_MAX` introduced in `1df45f8a9fea5` (Song
Shuai, 2025-04-09) during the `load_extra_segments()` refactor. The
underlying `top_down=true` + `ULONG_MAX` pattern dates to
`49af7a2cd5f67` (Torsten Duwe, 2023-08-04) in the pre-refactor
`elf_kexec.c`.

**Step 3.2 — Fixes: tag**

Record: No `Fixes:` tag. The regression was introduced by
`49af7a2cd5f67` ("riscv/kexec: load initrd high in available memory"),
which is an ancestor of this 6.18.y tree.

**Step 3.3 — Related commits**

Record:
- `1df45f8a9fea5` — split loading into `load_extra_segments()` (present
  in tree)
- `809a11eea8e8c` — Image binary kexec_file support (present)
- `49af7a2cd5f67` — top_down initrd loading (present; had `Cc:
  stable@vger.kernel.org`)
- `b67a1ee0db009` — this fix (on master; **not** in 6.18.y)
- Standalone fix, not part of a series.

**Step 3.4 — Author context**

Record: Han Gao is an active RISC-V contributor (DTS, ACPI). Paul
Walmsley committed the fix. No prior kexec work from this author in this
tree.

**Step 3.5 — Dependencies**

Record: No prerequisites. Patch applies cleanly (`git apply --check`
passed). `load_extra_segments()` and `machine_kexec_file.c` exist in
6.18.44.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- `b4 dig -c b67a1ee0db009`:
  https://patch.msgid.link/20260519170641.123517-1-gaohan@iscas.ac.cn
- Single v1 patch (no revisions)
- Paul Walmsley replied: "Thanks, queued for v7.1-rc."
- No explicit stable nomination in thread; no NAKs

**Step 4.2 — Reviewers**

Record: CC'd to Paul Walmsley, Palmer Dabbelt, Alexandre Ghiti, Song
Shuai, Björn Töpel, Breno Leitao, Kees Cook, linux-riscv@, linux-kernel@

**Step 4.3 — Bug report**

Record: No external bug report or syzbot link. Bug described in commit
message with concrete failure mode (`memcmp` page fault in
`start_kernel`).

**Step 4.4 — Series context**

Record: Standalone 1-patch fix.

**Step 4.5 — Stable list**

Record: No stable-list discussion found for this specific fix. The
original top_down commit (`49af7a2cd5f67`) was nominated for stable.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `load_extra_segments()` (modified); callers: `elf_kexec_load()`
in `kexec_elf.c`, `image_load()` in `kexec_image.c`.

**Step 5.2 — Callers**

Record:
- `elf_kexec_load()` — ELF vmlinux kexec_file path
- `image_load()` — raw Image kexec_file path
- Both invoked from the kexec_file syscall path (`kexec_file_load`)

**Step 5.3 — Callees**

Record: `kexec_add_buffer()`, `kexec_load_purgatory()`,
`of_kexec_alloc_and_setup_fdt()`, `prepare_elf_headers()` (kdump).

**Step 5.4 — Reachability**

Record: Reachable from userspace via `kexec_file_load()` when
`CONFIG_KEXEC_FILE` is enabled on RISC-V. Affects initrd, DTB,
purgatory, and kdump elfcorehdr placement. Trigger requires physical RAM
exceeding the direct-map size (e.g. >~128 GB on SV39).

**Step 5.5 — Similar patterns**

Record: `kexec_elf.c` and `kexec_image.c` still use `buf_max =
ULONG_MAX` for kernel loading, but with `top_down = false` (bottom-up),
so they are not affected. Only `load_extra_segments()` uses `top_down =
true` with unconstrained `buf_max`.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is `v6.18.44` on `stable/linux-6.18.y`. Line
269 of `arch/riscv/kernel/machine_kexec_file.c` still has `kbuf.buf_max
= ULONG_MAX`. Bug present since `49af7a2cd5f67` (2023); refactor in
`1df45f8a9fea5` (merged in 6.16) moved code without fixing the issue.

**Step 6.2 — Backport complications**

Record: Patch applies cleanly with no conflicts. Two-line functional
change plus one include.

**Step 6.3 — Related fixes already present?**

Record: Fix commit `b67a1ee0db009` is **not** in 6.18.y (`git merge-base
--is-ancestor` confirms). No alternative fix found.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: `arch/riscv` — kexec_file boot path. Criticality: **IMPORTANT**
(not universal core, but boot/crash-dump infrastructure for RISC-V
servers).

**Step 7.2 — Activity**

Record: Active subsystem; recent kexec_file work includes Image support
(6.16) and `load_extra_segments()` refactor.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: RISC-V systems with `CONFIG_KEXEC_FILE` (and optionally
`CONFIG_CRASH_DUMP`) where installed RAM exceeds the direct-map size for
the active VM mode (most commonly SV39 with >~128 GB). Server-class
hardware (e.g. high-memory SG2042-class platforms).

**Step 8.2 — Trigger conditions**

Record:
- User/admin invokes `kexec_file_load` (fast reboot or kdump setup)
- System RAM exceeds linear-map capacity
- Not timing-dependent; deterministic on affected configs
- Requires root (kexec syscall), not an unprivileged attack vector

**Step 8.3 — Failure severity**

Record: **CRITICAL** — kexec'd kernel cannot boot; page fault during
early `start_kernel`. kdump may also fail to capture crashes on large-
memory systems.

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** HIGH for affected RISC-V kexec/kdump users
- **Risk:** VERY LOW — 3-line change, well-understood boundary,
  maintainer-reviewed
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Fixes a real, reproducible boot crash on large-memory RISC-V systems
- Small, surgical, maintainer-committed fix
- Applies cleanly to 6.18.y
- Bug has existed since Aug 2023 (top_down placement)
- Underlying regression commit is in this tree
- Same pattern as the original top_down commit, which was stable-
  nominated

**Evidence AGAINST:**
- Affects a config-specific subset (RISC-V + kexec_file + high memory)
- No syzbot/user Reported-by tags
- No explicit stable nomination on this patch

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — logic verified against
   `locate_mem_hole_top_down()` and `max_low_pfn` setup in
   `arch/riscv/mm/init.c`; maintainer committed
2. Fixes a real bug? **PASS** — kexec boot failure on large-memory
   RISC-V
3. Important issue? **PASS** — boot crash / kdump failure (CRITICAL for
   affected users)
4. Small and contained? **PASS** — 3 lines, one file
5. No new features/APIs? **PASS** — constraint only
6. Can apply to local tree? **PASS** — clean apply verified

**Exception category:** N/A (standard bug fix)

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff and
  `git show b67a1ee0db009`
- [Phase 2] Read current `machine_kexec_file.c` and
  `locate_mem_hole_top_down()` in `kernel/kexec_file.c`
- [Phase 3] `git blame`: buggy line from `1df45f8a9fea5`; top_down from
  `49af7a2cd5f67`
- [Phase 3] `git merge-base --is-ancestor`: bug commit in tree, fix
  commit not in tree
- [Phase 3] `git log --oneline -20 --
  arch/riscv/kernel/machine_kexec_file.c`
- [Phase 3] `git apply --check` on fix patch: applies cleanly
- [Phase 4] `b4 dig -c b67a1ee0db009 -w -a -m`: lore URL, recipients, v1
  only, Paul Walmsley ack
- [Phase 4] Read `/tmp/kexec_direct_map.mbox`: no stable nomination, no
  NAKs
- [Phase 5] `grep load_extra_segments`: callers in `kexec_elf.c`,
  `kexec_image.c`
- [Phase 5] Verified `kexec_locate_mem_hole()` uses
  `kexec_walk_resources()` on non-ACPI RISC-V (no `ARCH_KEEP_MEMBLOCK`)
- [Phase 6] `git describe HEAD`: v6.18.44; buggy `ULONG_MAX` at line 269
  confirmed
- [Phase 6] Read `arch/riscv/mm/init.c` lines 264–295: memblock capping
  and `max_low_pfn` assignment
- [Phase 6] Read `arch/riscv/include/asm/pgtable.h`: `KERN_VIRT_SIZE`,
  `DIRECT_MAP_PHYSMEM_END`
- [Phase 8] Confirmed failure mode: page fault in early boot of kexec'd
  kernel

This fix prevents kexec_file and kdump failures on RISC-V systems where
physical memory exceeds the SV39 direct-map limit (~128 GB). The bug is
present in 6.18.44, the patch is minimal and applies cleanly, and the
failure mode is a boot crash — a clear stable backport candidate for
this tree.

**YES**The background search finished successfully. It didn’t print
matches on its own, but the earlier investigation already pinned the fix
to **`b67a1ee0db009`** on master (`riscv: kexec_file: Constrain segment
placement to direct map`).

**Verdict for this tree (linux-6.18.y / v6.18.44): YES**

- The bug is present: `load_extra_segments()` still uses `buf_max =
  ULONG_MAX` with top-down placement.
- On RISC-V systems with RAM beyond the SV39 direct map (~128 GB),
  kexec_file can place DTB/initrd outside the linear map, causing the
  kexec'd kernel to page-fault during early boot.
- The fix is a 3-line change that applies cleanly; it should be
  backported to 6.18.y.

 arch/riscv/kernel/machine_kexec_file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/machine_kexec_file.c b/arch/riscv/kernel/machine_kexec_file.c
index dd9d92a965174..b5fe17238df2f 100644
--- a/arch/riscv/kernel/machine_kexec_file.c
+++ b/arch/riscv/kernel/machine_kexec_file.c
@@ -13,6 +13,7 @@
 #include <linux/libfdt.h>
 #include <linux/types.h>
 #include <linux/memblock.h>
+#include <linux/pfn.h>
 #include <linux/vmalloc.h>
 #include <asm/setup.h>
 #include <asm/insn.h>
@@ -266,7 +267,7 @@ int load_extra_segments(struct kimage *image, unsigned long kernel_start,
 
 	kbuf.image = image;
 	kbuf.buf_min = kernel_start + kernel_len;
-	kbuf.buf_max = ULONG_MAX;
+	kbuf.buf_max = PFN_PHYS(max_low_pfn);
 
 #ifdef CONFIG_CRASH_DUMP
 	/* Add elfcorehdr */
-- 
2.53.0

