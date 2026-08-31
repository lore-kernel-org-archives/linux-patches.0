Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035E04756DC;
	Mon, 31 Aug 2026 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184319; cv=none; b=GlhYZau2ZkpavhWG9kuyjvxrhiicTuNgq/jhEb7hh/jlkQC5huVTpu6YlqvmxF9pmr2K11EWVKLO7CyeLuVPSi8n25vgKH589VqCwm8f9aQTnhesO75LFJR/MeXV28rsvz/29AG02ggZr0Njxik2Pxyq7DTsJzcJloqaJalGk2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184319; c=relaxed/simple;
	bh=pZRzXChp8OOaZEjPdl4pIwtBmsUUAugWNU87jubaTwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=id+bSyLTX2swgmACY2BwQsX9wAp5Y2dYCu2JJtQd7SHrNLr4v8215fNeYBDMTs8ojoF21ify2HVRkct9xnWKiDHALzzclr9XHkwuvWh2zVBRJgga0RmWibZS+I3D7J5nJmP90yzuxrigKqnGYOdEKvyGN7PncwA5oRJFkiBRXRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HcQ6Sc8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HcQ6Sc8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB311F000E9;
	Mon, 31 Aug 2026 13:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184316;
	bh=tV0zB8yxnLlFcu9A53GyoITbVctrpoYGrqFc6gY/Rko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcQ6Sc8tq9SM4lCCs1qYbbGU4rAARBewfacjuJVm6pSLyWRNfyYZOlbf/jSl5hJme
	 GUuaEs0hYfmlq8o1rhU46uLr0nC2MQYFxoKqXM1O1Q2Yg2aekhEcrl8yfR2mUXSkZb
	 GBGQhNpNaRkzJX18t7yN9s1XbLzWc7Iblm8LTmU6znq1CPdzSETZgGYBnwLdozEm2+
	 SCWNrXD723NviwZnTlZLu6f1M2HzEWL7V8rjVKDmA7m9o0IE9fLZiUHdgyukX0Si9K
	 LbosoKs1R4PKBNWHD+b/rgg+gaFB/6aPDDiKCeYorRSgQGQW4EoEs9SjK4E8froy9Z
	 GbEyoRqgLGXBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dave Penkler <dpenkler@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-staging@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] gpib: Suppress setting END on error from NI_USB dongle
Date: Mon, 31 Aug 2026 09:30:48 -0400
Message-ID: <20260831133314.4125787-620-sashal@kernel.org>
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

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 7c19b47f5a1839817e5ddc5ba589224fcfb6255d ]

The NI USB adapter sets the END bit in the status word when an error
occurs such as a read being interrupted by the setting of ATN. This
happens for example when a device clear is received from the
controller in charge during a read.

The common driver changes the error return to 0 whenever the END bit
is set in order to avoid errors such as timeout or interrupt to be
reported after the full message has actually been read. The behaviour
of the NI USB adapter in setting the END bit on errors was causing
actual errors (-EINTR, -ETIMEDOUT) not to be reported.

We avoid setting the END bit in the ni_usb_gpib driver when an error
is reported in error_code of the status from the adaptor.

Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://patch.msgid.link/20260422074807.3194-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `gpib: Suppress setting END on error from
NI_USB dongle`

**Local tree:** Linux **6.18.44** (`v6.18.44`, `HEAD` detached at
`stable/linux-6.18.y`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[gpib] [suppress] [prevent incorrect END flag on NI USB
adapter errors]`

Subsystem: `gpib` (National Instruments USB GPIB driver). Action:
suppress (prevent) setting the END flag when the adapter reports an
error.

### Step 1.2: Commit Message Tags
**Record:**
- **Signed-off-by:** Dave Penkler `<dpenkler@gmail.com>` (author)
- **Link:**
  https://patch.msgid.link/20260422074807.3194-1-dpenkler@gmail.com
- **Signed-off-by:** Greg Kroah-Hartman (maintainer merge)
- **No** `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Cc: stable@vger.kernel.org`
- Notable: absence of stable tag is expected per review pipeline; not a
  negative signal.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** NI USB adapter sets the END bit in `status.ibsta` even when
  `error_code` indicates an error (e.g., read interrupted by ATN during
  device clear, or timeout).
- **Symptom:** Real errors (`-EINTR`, `-ETIMEDOUT`) from `ni_usb_read()`
  are not propagated to userspace.
- **Root cause:** Common driver (`read_ioctl()` in `gpib_os.c`)
  intentionally suppresses read errors when `end_flag` is set (to handle
  race where a transfer completed just before device clear). NI USB
  incorrectly sets END on error paths, triggering that suppression.
- **Fix:** Only set `*end = 1` when `(status.ibsta & END) &&
  (status.error_code == NIUSB_NO_ERROR)`.

### Step 1.4: Hidden Bug Fix Detection
**Record:** This is an explicit bug fix, not disguised cleanup. It
corrects incorrect error propagation to userspace applications using NI
USB GPIB adapters.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **Files:** 1 file (`ni_usb_gpib.c`; upstream path `drivers/gpib/`,
  local path `drivers/staging/gpib/ni_usb/`)
- **Lines:** ~1 line changed (condition expanded)
- **Function:** `ni_usb_read()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** Any read where hardware sets END in `ibsta` sets `*end =
  1`, regardless of `error_code`.
- **After:** END is only propagated to `*end` when `error_code ==
  NIUSB_NO_ERROR`.
- **Affected path:** `ni_usb_read()` return path after USB status
  parsing, before return to `ibrd()` → `read_ioctl()`.

### Step 2.3: Bug Mechanism
**Record:** **Logic/correctness bug** interacting with intentional
common-driver error suppression.

Verified chain in this tree:

```934:941:drivers/staging/gpib/common/gpib_os.c
        /*
  - suppress errors (for example due to timeout or interruption by
    device clear)
  - if all bytes got sent.  This prevents races that can occur in the
    various drivers
  - if a device receives a device clear immediately after a transfer
    completes and
  - the driver code wasn't careful enough to handle that case.
         */
        if (remain == 0 || end_flag)
                read_ret = 0;
```

When NI USB sets END on an error read:
1. `ni_usb_read()` returns `-EINTR` (device clear, commit
   `aaf2af1ed147e`) or `-ETIMEDOUT`
2. `*end = 1` (buggy code at line 723)
3. `read_ioctl()` converts `read_ret` to `0` because `end_flag` is set
4. Userspace receives success instead of the real error

### Step 2.4: Fix Quality
**Record:** Fix is obviously correct and minimal. Only sets END when the
adapter reports no error. Very low regression risk; aligns NI USB
behavior with the intent of the common-driver suppression logic.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy END handling introduced in `4e127de14fa78b` ("staging:
gpib: Add National Instruments USB GPIB driver", 2024-09-18). Present
since NI USB driver was added to this tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related File History
**Record:** Related commits already in 6.18.44:
- `aaf2af1ed147e` — "staging: gpib: Return -EINTR on device clear"
  (**Cc: stable**, already backported here)
- `cae26eff1b56d` — UAF fix in IO ioctl handlers
- `fdee9f207a48c` — double decrement fix in command_ioctl
- `d72ece584c448` — ioctl error code fix

This fix completes the device-clear path started by `aaf2af1ed147e`.

### Step 3.4: Author Context
**Record:** Dave Penkler is the GPIB subsystem author/maintainer of
these NI USB fixes. Multiple gpib fixes from this author are already in
6.18.y stable.

### Step 3.5: Dependencies
**Record:** Standalone one-line fix. Prerequisite `aaf2af1ed147e`
(-EINTR on device clear) is already in this tree. No other dependencies.
Backport needs path adjustment:
`drivers/staging/gpib/ni_usb/ni_usb_gpib.c` (not `drivers/gpib/` as on
mainline where gpib left staging).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
**Record:** `b4 am` found thread at
https://patch.msgid.link/20260422074807.3194-1-dpenkler@gmail.com. Mbox
contains only the initial patch (1 message); no review replies or stable
nominations in thread. Related commit `aaf2af1ed147e` was explicitly
`Cc: stable`.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` not run (commit not in local tree). Patch merged
by Greg Kroah-Hartman (staging maintainer). No additional reviewers in
thread.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Bug described by
author with concrete scenario (device clear during read).

### Step 4.4: Related Patches
**Record:** Direct follow-up to `aaf2af1ed147e` device-clear EINTR work.
Without this fix, that prior stable backport is effectively nullified
for NI USB users.

### Step 4.5: Stable List History
**Record:** Not searched separately; related EINTR fix was author-
nominated for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `ni_usb_read()` (modified), `read_ioctl()` (affected caller
path), `ibrd()` (intermediate).

### Step 5.2: Callers
**Record:** `ni_usb_read` registered as `board->interface->read` (line
2390). Called via `ibrd()` from `read_ioctl()` — userspace ioctl read
path for GPIB applications.

### Step 5.3: Callees
**Record:** USB bulk transfer, status parsing,
`ni_usb_soft_update_status()`. Error classification via
`status.error_code` switch.

### Step 5.4: Reachability
**Record:** Reachable from userspace via GPIB read ioctl. Any NI USB
GPIB user performing reads can hit this on device clear or timeout.

### Step 5.5: Similar Patterns
**Record:** `ibsta & END` check exists only once in NI USB driver (line
723). Write path does not set an END flag. No sibling instances need the
same fix.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** Buggy code at line 723 of
`drivers/staging/gpib/ni_usb/ni_usb_gpib.c`:

```723:726:drivers/staging/gpib/ni_usb/ni_usb_gpib.c
        if (status.ibsta & END)
                *end = 1;
        else
                *end = 0;
```

Fix is **not** yet applied in 6.18.44.

### Step 6.2: Backport Complications
**Record:** Trivial path adjustment needed (`drivers/staging/gpib/` vs
upstream `drivers/gpib/`). Code context around the hunk is identical.
Clean apply expected with path change.

### Step 6.3: Related Fixes Already Present?
**Record:** `aaf2af1ed147e` (EINTR on device clear) is present. This fix
is not duplicated elsewhere. No conflicting fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **PERIPHERAL** — staging GPIB driver, specifically
`CONFIG_GPIB_NI_USB` (National Instruments USB dongles). Not core
kernel, but actively maintained in stable.

### Step 7.2: Subsystem Activity
**Record:** Active — 10+ gpib fixes already in 6.18.y including UAF,
memory leaks, ioctl fixes, and the related EINTR fix.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users with `CONFIG_GPIB_NI_USB` enabled using National
Instruments USB GPIB adapters (GPIB-USB-B, GPIB-USB-HS, GPIB-USB-HS+).

### Step 8.2: Trigger Conditions
**Record:**
- Device clear received during an active read (ATN asserted, DCAS set) —
  moderately common in GPIB bus management
- Read timeout with END bit set by hardware
- Unprivileged users can trigger via GPIB ioctl if they have device
  access

### Step 8.3: Failure Mode Severity
**Record:** **MEDIUM** — incorrect error reporting (success returned
instead of `-EINTR`/`-ETIMEDOUT`). No kernel crash, UAF, or data
corruption, but applications may hang, retry incorrectly, or miss bus
events. Undermines a prior stable backport.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM-HIGH for affected NI USB users; restores correct
  error semantics
- **Risk:** VERY LOW — one-line, logically obvious change
- **Ratio:** Favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verified bug with clear mechanism in code
- Incorrect userspace error reporting on common GPIB operations
- Completes prior stable backport (`aaf2af1ed147e` EINTR on device
  clear)
- Minimal, obviously correct one-line fix
- Strong precedent: multiple gpib fixes already in 6.18.y stable
- Bug present since NI USB driver introduction (2024)
- Low regression risk

**AGAINST backport:**
- Staging driver (general guideline: usually not stable material)
- Limited user base (NI USB GPIB hardware only)
- No crash/corruption/security impact
- No syzbot or user bug reports

**Unresolved:** No review-thread stable nomination for this specific
patch (thread had no replies).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is self-evident;
   merged to mainline by maintainer
2. Fixes a real bug affecting users? **PASS** — wrong error codes to
   userspace on NI USB
3. Important issue? **PASS** — functional correctness bug; completes
   prior stable fix (MEDIUM severity)
4. Small and contained? **PASS** — 1 line, 1 function
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — with trivial path adjustment

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision Rationale

This fix should be backported to **6.18.y**. The buggy code exists, the
mechanism is verified end-to-end in `ni_usb_read()` → `read_ioctl()`,
and the fix directly restores error reporting that a prior stable
backport (`aaf2af1ed147e`) intended to provide. While GPIB remains in
staging and affects a niche hardware audience, this tree already carries
numerous gpib stable fixes including security-relevant ones (UAF),
establishing clear precedent. The change is minimal and low-risk.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
  and mbox file
- **[Phase 2]** Read `ni_usb_read()` at lines 689-728 and `read_ioctl()`
  at lines 916-941 in `drivers/staging/gpib/`
- **[Phase 2]** Confirmed error suppression: `if (remain == 0 ||
  end_flag) read_ret = 0;`
- **[Phase 3]** `git describe HEAD`: v6.18.44
- **[Phase 3]** `git blame -L 720,728`: buggy END handling from
  `4e127de14fa78b` (2024-09-18)
- **[Phase 3]** `git show aaf2af1ed147e`: EINTR on device clear with Cc:
  stable, already in tree
- **[Phase 3]** `git log --oneline -30 -- drivers/staging/gpib/`:
  multiple gpib stable fixes present
- **[Phase 4]** `b4 am` on msgid: found patch thread, 1 message, no
  replies
- **[Phase 4]** Read mbox: `20260422_dpenkler_gpib_suppress_setting_end_
  on_error_from_ni_usb_dongle.mbx`
- **[Phase 5]** `grep ibsta & END`: only occurrence in NI USB driver at
  line 723
- **[Phase 5]** Traced call chain: `read_ioctl` → `ibrd` → `ni_usb_read`
- **[Phase 6]** Confirmed `drivers/staging/gpib/ni_usb/ni_usb_gpib.c`
  exists; fix not applied
- **[Phase 6]** `grep "Suppress setting END"`: no match in tree (fix
  absent)
- **[Phase 7]** Read `drivers/staging/gpib/Kconfig`: CONFIG_GPIB_NI_USB
  documents supported hardware
- **[Phase 8]** Assessed impact on NI USB GPIB users only

**YES****Verdict: YES** — backport to this tree (Linux 6.18.44).

The NI USB GPIB driver sets the END flag even when the adapter reports
an error (`-EINTR` on device clear, `-ETIMEDOUT` on timeout). The common
`read_ioctl()` path then treats END as “transfer complete” and clears
the error, so userspace gets success instead of the real error code.

The buggy code is still present at
`drivers/staging/gpib/ni_usb/ni_usb_gpib.c:723`; the fix is a one-line
change and completes the earlier stable backport that added `-EINTR` on
device clear (`aaf2af1ed147e`). Apply with the staging path
(`drivers/staging/gpib/...` instead of upstream’s `drivers/gpib/...`).

 drivers/staging/gpib/ni_usb/ni_usb_gpib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
index b6fddb437f552..67cc3398e2831 100644
--- a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
+++ b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
@@ -720,7 +720,7 @@ static int ni_usb_read(struct gpib_board *board, u8 *buffer, size_t length,
 		break;
 	}
 	ni_usb_soft_update_status(board, status.ibsta, 0);
-	if (status.ibsta & END)
+	if ((status.ibsta & END) && (status.error_code == NIUSB_NO_ERROR))
 		*end = 1;
 	else
 		*end = 0;
-- 
2.53.0

