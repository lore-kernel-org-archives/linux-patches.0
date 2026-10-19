Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F30260C107;
	Mon, 19 Oct 2026 14:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418613; cv=none; b=X6xAOdoCSpZfcniutZrD/c4hQP/rLwrfgA5+vXDXbSkzE06u4PiiHXb031yPK6ytHvciRS5WnUdGME3kZoG9i2VdH31M9lJcJRqlipxiY7g8bApuDM5RHKVXWUAnyk3o2FZZWhqn+xiPvxwDdtMZ5ZI50K81br182TYwGgVpL5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418613; c=relaxed/simple;
	bh=36HdIlOFHdL/vVYmiZs7Q2F+j2DiREH0OCTVOMHKEsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LaGhtc0xkw/O1zJs0WXJjQB12ER8S3QiBoQVQ/aWKQS95cpwXmOSDFdRpskkbkUM6KhA2JXPTG+D4LOgJ6XISTpoJ/7rWWbrVY8kH/BK+SvT7ppF1mJC/22xGW0INmz67wgrO3y10vkvn1DajHXa0IghmWZE6NDOdn7pO08oJg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D5FfhMgv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5FfhMgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755C31F000C8;
	Mon, 19 Oct 2026 14:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418610;
	bh=4udapwcgqT1eSwUZFlUCJ5E9O4cf3E3CyLCU8wLYjFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5FfhMgvavQ8vJ53GE0NKIjPzio7zAyrdlbk8M691ofc2CW6u+opHiSffy6C4o8r3
	 6aIe32Wallkjc6NKnFUc0UyPCJXgblvFYe1j81NKAx4DSUgI+J7ELIeQpTgZad8FKV
	 Ro5Rb1QTFNAR2M8Tqv7D1XhxxsvHMvDNP53wKWxZqFs9g8xUHkIKOjaTAJ78A9i8P9
	 Uh7rhCmydfU9ig8ubNTRlg77bd54l3aTK/wHKxlo9FlgYFPFFzbdyZ4N/OEkg2koWb
	 TUrKpbbKVY+WlGGDAYLcLcc9Ji+FkPlNJnK+54uMRB6FFbMIUSZIJaLnGYR760b5lV
	 7/9MsBmLb78vg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	peterhuewe@gmx.de,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] tpm: atmel: depend on X86
Date: Mon, 19 Oct 2026 09:51:02 -0400
Message-ID: <20261019135441.1420968-371-sashal@kernel.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 4bfacee94f309346bef0b598ea091088b9150af9 ]

tpm_atmel probes for the chip at fixed x86 Super-I/O ports (0x4e) with
inb()/outb(), so it only works on x86. TCG_ATMEL nevertheless depends
only on HAS_IOPORT_MAP/HAS_IOPORT, which arm and arm64 also satisfy.
There the probe is useless, and on platforms whose unbacked I/O access
faults it oopses in init_atmel() at boot (e.g. arm/versatile):

  Unable to handle kernel paging request at virtual address fee0004e
  PC is at init_atmel+0x34/0x244

TCG_NSC and TCG_TIS already "depends on X86" (commit 2f592f2a7d74 ("TPM:
NSC and TIS drivers X86 dependency fix")); TCG_ATMEL was missed. Add the
same dependency.

Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260712183234.23125-1-kmehltretter@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[tpm / TCG_ATMEL]` `[depend]` Restrict the Atmel TPM driver to
x86 because it probes Super-I/O ports.

**Step 1.2 — Tags**
Record:
- `Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>` (TPM maintainer)
- `Link: https://lore.kernel.org/r/20260712183234.23125-1-
  kmehltretter@gmail.com`
- `Signed-off-by: Karl Mehltretter` (author)
- `Signed-off-by: Jarkko Sakkinen` (maintainer)
- No `Fixes:`, no `Reported-by:`, no `Cc: stable` (absence is expected
  for this review)
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  …]` markers

**Step 1.3 — Body**
Record:
- Bug: `tpm_atmel` probes Super-I/O at `0x4e` with `inb()`/`outb()`.
  Kconfig only required `HAS_IOPORT_MAP`/`HAS_IOPORT`, which ARM/arm64
  also satisfy.
- Symptom: boot oops, `Unable to handle kernel paging request at virtual
  address fee0004e`, `PC is at init_atmel+0x34/0x244` (example:
  arm/versatile).
- Root cause: unbacked PCI I/O window access on non-x86.
- Same class of fix as `2f592f2a7d74` (`TCG_NSC` / `TCG_TIS` `depends on
  X86`); `TCG_ATMEL` was missed.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. Explicit crash fix via Kconfig dependency. Not
cleanup or a new feature.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record: One file, `drivers/char/tpm/Kconfig`. `TCG_ATMEL`: replace
`depends on HAS_IOPORT_MAP` + `depends on HAS_IOPORT` with `depends on
X86`. Scope: single-file, two-line Kconfig change.

**Step 2.2 — Code flow**
Record: Before: any arch with I/O-port mapping can build/enable
`tpm_atmel`; `init_atmel()` always probes `0x4e`. After: the driver is
not built on non-x86. Affected path: module/builtin init, not a hot
path.

**Step 2.3 — Bug mechanism**
Record: Kconfig/hardware-scope bug that produces a NULL/unmapped I/O
dereference. On ARM, `inb(0x4e)` becomes a load at
`PCI_IO_VIRT_BASE+0x4e` (`0xfee0004e`). If that page is not mapped, the
kernel oopses.

**Step 2.4 — Fix quality**
Record: Obviously correct for the Super-I/O probe. Minimal. No runtime
locking/API change. Regression risk is only over-restricting platforms
that still have a working non-x86 path. That matters on **this** tree
(see Phase 6): PPC64 OF support is still present, so the backport must
be `depends on X86 || PPC64`, not bare `depends on X86`.

## Phase 3: Git history

**Step 3.1 — Blame**
Record: `TCG_ATMEL` dates to `1da177e4c3f41` (Linux 2.6.12-rc2). Local
depends lines:
- `depends on PPC64 || HAS_IOPORT_MAP` — `ce816fa88cca0` (2014; rename
  of `HAS_IOPORT` → `HAS_IOPORT_MAP`)
- `depends on HAS_IOPORT` — `6155153601183` (“char: tpm: handle
  HAS_IOPORT dependencies”, 2024; **in this tree**)

The Super-I/O probe in `tpm_atmel.h` (`#else` of `CONFIG_PPC64`) has
been there for the life of the driver.

**Step 3.2 — Fixes: tag**
Record: None. Related historical commit `2f592f2a7d74` (2011, **in this
tree**) added `depends on X86` for NSC/TIS after PPC oopses; Atmel was
not included.

**Step 3.3 — Related file history**
Record: `5578b4347bb5d` (“tpm: atmel: Drop PPC64 specific MMIO setup”,
2024-11-22) is **not** an ancestor of this checkout (`git merge-base
--is-ancestor` exit 1). It is an ancestor of the candidate. That commit
changed Kconfig to `depends on HAS_IOPORT_MAP` only; the candidate then
changed that to `depends on X86`.

**Step 3.4 — Author**
Record: Karl Mehltretter — this is the only Atmel TPM commit from that
author on `origin/master`. Jarkko Sakkinen (TPM maintainer) reviewed and
applied it.

**Step 3.5 — Prerequisites**
Record: The **verbatim** diff assumes PPC64 was already dropped. That
drop is not in 6.12. The **semantic** fix does not need that drop: this
tree can use `depends on X86 || PPC64` and keep the existing OF path.
Standalone with that one-line adaptation. Do not pull in `5578b4347bb5d`
(feature removal, ~140 lines).

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
Record: `b4 dig -c 4bfacee94f309` →
https://patch.msgid.link/20260712183234.23125-1-kmehltretter@gmail.com
`b4 dig -a`: single revision (v1 only).
Thread (mbox): author patch + Jarkko `Reviewed-by`. No NAK, no stable
debate, no risk flags.

**Step 4.2 — Recipients** (`b4 dig -w`)
Record: Jarkko Sakkinen, Peter Huewe, Jason Gunthorpe, `linux-
integrity`, `linux-kernel`. Right maintainers/list.

**Step 4.3 — Bug report**
Record: No syzbot/bugzilla. Concrete oops in the commit message; PC and
fault address match ARM `inb(0x4e)`.

**Step 4.4 — Series**
Record: Standalone, not patch x/y.

**Step 4.5 — Stable list**
Record: No stable-specific thread found. lore.kernel.org HTTP fetch
returned 403; discussion recovered via `b4 dig -m`. UNVERIFIED: whether
anyone later nominated it on `stable@`.

## Phase 5: Semantic / call surface

**Step 5.1 — Functions**
Record: No C functions changed. Runtime path gated: `init_atmel()` →
`atmel_get_base_addr()` → `atmel_verify_tpm11()` → `tpm_read_index()` →
`outb`/`inb` at `TPM_ADDR` (`0x4E` in `drivers/char/tpm/tpm.h`).

**Step 5.2 — Callers**
Record: `module_init(init_atmel)` — builtin boot or `modprobe
tpm_atmel`.

**Step 5.3 — Callees**
Record: Super-I/O index/data ports; no allocation/locking in the
faulting probe.

**Step 5.4 — Reachability**
Record: Yes, if `CONFIG_TCG_ATMEL=y/m`. Not a syscall. User/config must
enable an x86 Super-I/O TPM driver.
`arch/parisc/configs/generic-64bit_defconfig` sets `CONFIG_TCG_ATMEL=m`.
ARM `allyesconfig`/custom configs can set it `=y` and oops at boot.

**Step 5.5 — Similar patterns**
Record: `TCG_NSC` already `depends on X86` in this tree. `TCG_TIS` is
`depends on X86 || OF` here (OF added later; not Super-I/O).

## Phase 6: This checkout (6.12.y)

**Step 6.1 — Does the buggy code exist?**
Record: Yes.
- Tree: `git describe` → `p-6.12-3-gc504cf0baa3d8`, `make kernelversion`
  → **6.12.111**
- Candidate `4bfacee94f309` is **not** in HEAD
- Local Kconfig:

```164:171:drivers/char/tpm/Kconfig
config TCG_ATMEL
        tristate "Atmel TPM Interface"
        depends on PPC64 || HAS_IOPORT_MAP
        depends on HAS_IOPORT
```

- Non-PPC64 `tpm_atmel.h` still does Super-I/O `inb`/`outb` at
  `TPM_ADDR`.
- `arch/arm/Kconfig` `select HAS_IOPORT`. `HAS_IOPORT_MAP` defaults y
  unless `NO_IOPORT_MAP`. `ARCH_VERSATILE` does **not** select
  `NO_IOPORT_MAP`.
- ARM `PCI_IO_VIRT_BASE` is `0xfee00000`; `inb(0x4e)` → `0xfee0004e`,
  matching the oops.

**Step 6.2 — Backport difficulty**
Record: Exact hunk will not apply (this tree still has `PPC64 ||
HAS_IOPORT_MAP`). Trivial adaptation:

```
depends on X86 || PPC64
```

Do **not** apply bare `depends on X86`; that would disable the still-
present PPC64 OF path (`CONFIG_PPC64` in `tpm_atmel.h`).

**Step 6.3 — Related fixes already here?**
Record: No other Atmel X86-dependency fix. `2f592f2a7d74` only covered
NSC/TIS.

## Phase 7: Subsystem context

**Step 7.1**
Record: `drivers/char/tpm` — TPM. Criticality: **IMPORTANT** for TPM
users; Atmel Super-I/O is a legacy path. Still a driver that can be
built into generic/distro kernels.

**Step 7.2**
Record: TPM core is active (HMAC, new backends). `tpm_atmel` itself is
mature/legacy.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: Config-specific: `CONFIG_TCG_ATMEL` on non-x86 (ARM/arm64 with
PCI I/O, parisc defconfig, etc.). Not all 6.12 users.

**Step 8.2 — Trigger**
Record: Boot if builtin; module load if `=m`. Unprivileged users cannot
trigger unless the module is loaded. Commonness: low on production ARM,
high on `allyesconfig` / mistaken enablement. Author hit it on
versatile.

**Step 8.3 — Failure mode**
Record: Kernel paging-request oops in `init_atmel`. Severity:
**CRITICAL** when the driver is enabled (boot crash if `=y`).

**Step 8.4 — Risk/benefit**
Record:
- Benefit: stops a real oops; Kconfig-only.
- Risk: very low if PPC64 is preserved; **high if applied verbatim**
  (would hide `tpm_atmel` on PPC64 while the OF code remains).
- Ratio: favorable **with** `X86 || PPC64`.

## Phase 9: Synthesis

**Evidence FOR**
- Documented boot oops; fault address verified against ARM `inb()`.
- Same bug class already fixed for NSC/TIS in this tree.
- One-file Kconfig change; TPM maintainer Reviewed-by.
- Buggy probe is in this 6.12 tree.
- Fits “build/Kconfig dependency” stable exception; prevents a crash,
  adds no API.

**Evidence AGAINST**
- Verbatim patch does not apply; depends on PPC64-drop `5578b4347bb5d`
  which is **not** in 6.12.
- `TCG_ATMEL` is not in ARM defconfigs; impact is config-selected.
- Bare `depends on X86` would be a PPC64 regression on this tree.

**Unresolved**
- UNVERIFIED: whether any live PPC64 machine still uses AT97SC3201 via
  OF (Rob Herring later found no in-tree powerpc configs; that drop is
  still not in 6.12, so this backport should keep PPC64).
- UNVERIFIED: stable@ discussion (lore HTTP 403).

**Stable rules**
1. Obviously correct and tested? **PASS** (Kconfig restrict + maintainer
   review; oops matches code).
2. Real user-visible bug? **PASS** (boot oops).
3. Important (crash)? **PASS** when the option is enabled.
4. Small and contained? **PASS** (1–2 Kconfig lines).
5. No new features/APIs? **PASS**.
6. Apply to this tree? **PASS with backport** (`depends on X86 ||
   PPC64`); **FAIL** if taken verbatim.

**Exception category:** Kconfig/build dependency fix that prevents a
crash.

The 6.12 bug is real: `TCG_ATMEL` can still be enabled on
ARM/arm64/parisc, and `init_atmel()` will touch `0x4e` and oops on
unbacked I/O. Restricting the symbol is the right stable fix. Use
`depends on X86 || PPC64` so the still-present PowerPC OF path is not
dropped.

Verification:
- [Phase 1] Tags: Reviewed-by Jarkko; lore Link; no Fixes/Cc:stable
- [Phase 2] Diff: Kconfig only, `HAS_IOPORT*` → `X86`
- [Phase 3] `git describe` / `make kernelversion`: 6.12.111
- [Phase 3] `git merge-base --is-ancestor 4bfacee94f309 HEAD`: not in
  tree
- [Phase 3] `git merge-base --is-ancestor 5578b4347bb5d HEAD`: PPC64
  drop not in tree
- [Phase 3] `git merge-base --is-ancestor 2f592f2a7d74 HEAD`: NSC/TIS
  X86 dep is in tree
- [Phase 3] `git blame drivers/char/tpm/Kconfig`: HAS_IOPORT added by
  `6155153601183`
- [Phase 4] `b4 dig -c 4bfacee94f309`: v1 only; Jarkko Reviewed-by; no
  NAK
- [Phase 4] lore WebFetch: 403; thread read from `b4 dig -m`
- [Phase 5] `init_atmel` → `atmel_verify_tpm11` →
  `tpm_read_index(TPM_ADDR=0x4E)`
- [Phase 6] Local Kconfig still `PPC64 || HAS_IOPORT_MAP`; ARM
  `PCI_IO_VIRT_BASE=0xfee00000` matches oops
- [Phase 6] `ARCH_VERSATILE` does not select `NO_IOPORT_MAP`;
  `HAS_IOPORT` selected by ARM
- [Phase 8] parisc `generic-64bit_defconfig` has `CONFIG_TCG_ATMEL=m`
- UNVERIFIED: live PPC64 Atmel hardware; stable@ thread beyond b4 mbox

**YES**

 drivers/char/tpm/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 8a8f692b60880..5f672f2c01b04 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -163,8 +163,7 @@ config TCG_NSC
 
 config TCG_ATMEL
 	tristate "Atmel TPM Interface"
-	depends on HAS_IOPORT_MAP
-	depends on HAS_IOPORT
+	depends on X86
 	help
 	  If you have a TPM security chip from Atmel say Yes and it 
 	  will be accessible from within Linux.  To compile this driver 
-- 
2.53.0

