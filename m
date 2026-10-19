Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C8F639AAB;
	Mon, 19 Oct 2026 14:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418756; cv=none; b=VExgKVKpJzfGRAvs1q4TCW3yZygjRxj5l9LZsrbxNj1NLDW/VE6OuVAGPjroZPxUsrTvU3z1YbEJj7Zf5eBePwTeytPUT1Qonxx0tlY0g1+C1TKg74Unai4I/Vt2SycMGhNJ4IGr7xF+6ibDZriACZxivvMrQpEZk1+OLc6xaT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418756; c=relaxed/simple;
	bh=qVj1hlIzv0Y7Cin3VmfBLoNYR+gBjZgmloAz1AxvKEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KcvCzm2rAz7stMIfT+Hqr8mb27v3AqxiJ6DG5VSBBTpWq7prfTDjkRB/tJQwgN5T85bnel9bpdeaWYMf7q3cANWJV3nczal4nz8U4aQ5jzhFBXDu9XiCiohE90y1FPsYX4HLrSnJJDcC2ZLVGymtD2PGWXmTU5vn//ZDLcNrPmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUr1sDZp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUr1sDZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB8A1F000C5;
	Mon, 19 Oct 2026 14:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418752;
	bh=KL3D0vdQrNQmZyqnFmU6/oHDPqOB/+N8eeKRdzDLW1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUr1sDZpovtcrLbHwYYNSbJTQ46dUXbC7URPwdUKNMOFTqHodltL/B2cYPZKvE0Lz
	 Rv1WMJjtwZ0NNX+JacuY5IArUMf9ISYyThE1L0qsFxMBn4wZY6uhKk4Tti656pmRVz
	 lvva7C4hPjCPiBnTwZADjPzfxvMcTKqFJIa9eOounQv9BWBzfneyzW3JZYef48BoTi
	 rSFMI0SvIFfj7lzd9FchZ+Hn4OfBl4MQTsTBHdku5Ert236l9kmM6hLrUquE4IZk/n
	 GcQ0/hML7p/ztr58mUupzofihtd6OSGyTBhaG/buN0a2+8c0xf7nyzR8a7fA+qNzSy
	 HxOBq2n/yRexg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Armin Wolf <W_Armin@gmx.de>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	Dell.Client.Kernel@dell.com,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] platform/x86: dell-smbios-wmi: Fix chardev resource management
Date: Mon, 19 Oct 2026 09:52:42 -0400
Message-ID: <20261019135441.1420968-471-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 41427211f663c6eb36986ca2ea68d7e87aac52e9 ]

When unbinding the WMI driver while a userspace application has
an open file descriptor for the character device, a UAF occurs:

KASAN: slab-use-after-free in _copy_to_user from platform/x86/dell-smbios-wmi

The reason for this is that even after calling misc_deregister(),
userspace appications can still call read() and/or ioctl() on open
file descriptors associated with the already unregistered character
device. This causes a UAF by attempting to access the already freed
state container of the WMI driver.

Fix this by no longer storing the state container inside
filp->private_data. Instead retrieve the state container using
get_first_smbios_priv() and return -ENODEV if the state container
does not exist anymore.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/178144969601.60470.13396800403157907003@gmail.com/
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260720131921.368000-2-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real KASAN use-after-free in `dell-smbios-wmi` on this
v7.3-rc4 tree. The buggy `filp->private_data` path exists in the pre-fix
code, the fix is small and self-contained, and it should be backported
here.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[platform/x86 / dell-smbios-wmi] [fix] [chardev UAF after
unbind while fd still open]**

- Subsystem: `platform/x86: dell-smbios-wmi`
- Action verb: **Fix**
- Intent: stop a use-after-free in the misc chardev after the WMI driver
  is unbound

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Reported-by:** Shuangpeng Bai `<shuangpeng.kernel@gmail.com>` — real
  user/tester report
- **Closes:** https://lore.kernel.org/platform-
  driver-x86/178144969601.60470.13396800403157907003@gmail.com/
- **Link:**
  https://patch.msgid.link/20260720131921.368000-2-W_Armin@gmx.de (v2
  series, patch 1/3)
- **Reviewed-by:** Ilpo Järvinen (pdx86 maintainer)
- **Signed-off-by:** Armin Wolf (author; ACPI WMI maintainer), Ilpo
  Järvinen
- **Fixes:** absent in the committed message (expected). **v1** on the
  list had `Fixes: 93885e85a77f ("platform/x86: dell-smbios-wmi: Stop
  using WMI chardev")` — verified
- **Cc: stable:** absent (expected; not a negative)
- Ignore pipeline SOBs (none of Sasha Levin’s in the real commit)

Notable: Greg KH and Arnd Bergmann were on the original To/Cc. Not
syzbot; a human KASAN report with a gist reproducer.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** After `misc_deregister()`, open fds can still
  `read()`/`ioctl()`. Those ops used `filp->private_data` pointing at
  `wmi_smbios_priv`, which `devm` already freed.
- **Symptom:** `KASAN: slab-use-after-free in _copy_to_user` from this
  driver
- **Root cause:** chardev state stored in `filp->private_data`; unbind
  frees that object without waiting for in-flight fops
- **Fix:** stop caching priv in `private_data`; look it up under an
  rwsem via `get_first_smbios_priv()`; return `-ENODEV` if gone
- **Version info in message:** none. Introducing commit is 93885e85a77f2
  (2023-12, ~v6.8). Report was on `e8c2f9fdadee` (2026-05-25)

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not hidden.** Subject and body are an explicit UAF fix. Not
cleanup-as-fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/platform/x86/dell/dell-smbios-wmi.c` — **+34 / -33**
- Functions: `dell_smbios_wmi_call`, `dell_smbios_wmi_open` (removed),
  `dell_smbios_wmi_read`, `dell_smbios_wmi_ioctl`,
  `dell_smbios_wmi_probe`, `dell_smbios_wmi_remove`;
  `dell_smbios_wmi_fops`
- Scope: **single-file surgical locking/lifetime fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
1. **Includes / locks:** drop global `call_mutex`/`list_mutex`; add
   `cleanup.h`, `rwsem.h`, per-priv `call_lock`,
   `DECLARE_RWSEM(list_lock)`
2. **`dell_smbios_wmi_call`:** `guard(rwsem_read)(&list_lock)` then
   lookup; `guard(mutex)(&priv->call_lock)` around the SMBIOS buffer
3. **open:** removed. Previously `container_of(filp->private_data, ...,
   char_dev)` then stored priv in `private_data` for the fd lifetime
4. **read/ioctl:** lookup under `list_lock`; `-ENODEV` if list empty;
   ioctl also takes `priv->call_lock`
5. **probe:** `devm_mutex_init` for `call_lock`; list add under write
   rwsem
6. **remove:** unregister SMBIOS backend, then `list_del` under write
   rwsem (so in-flight readers finish before priv can be freed)

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[UAF / lifetime / race]**
`misc_deregister()` does not drain existing fds. `open()` pinned a
pointer to a `devm_kzalloc` object. Unbind (`unbind_store` →
`devres_release_all` → `kfree`) freed it. Later `read()` used that
pointer in `simple_read_from_buffer` → `_copy_to_user`. Confirmed by
KASAN: free stack is `unbind_store`, use stack is `vfs_read`.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Obviously correct:** lookup-under-lock is the standard pattern when
  chardev outlives driver unbind
- **Minimal:** one file, no API change
- **Regression risk: low.** Lock order is consistent (`list_lock` then
  `call_lock`). Write side waits for readers, then `list_del`, then
  `devm` frees priv
- **Not a public API change.** Userspace sees `-ENODEV` after unbind
  instead of UAF
- Follow-up patches 2/3 in the same series are cleanup only; author said
  patch 1 alone stops the UAF

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: Buggy `filp->private_data` path introduced in **93885e85a77f2**
(`platform/x86: dell-smbios-wmi: Stop using WMI chardev`, 2023-12-11,
~**v6.8**). Present in this tree (`git merge-base --is-ancestor
93885e85a77f2 HEAD` succeeded). Long-lived, not last-month code.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: Committed message has no Fixes tag. v1 did: **93885e85a77f2**.
That commit is an ancestor of HEAD. No later “this patch was wrong” fix;
08d31d42b054e and b844001890c5b are the rest of the same series
(callback signature + list→single pointer).

**Step 3.3: CHECK FILE HISTORY**

Record: Nearby file commits: `6f918e3d95c9b` (new WMI buffer API,
already in this tree), then this fix, then series 2/3. Not “patch 2/3 of
a required functional series” for the UAF — this **is** 1/3 and is
standalone.

**Step 3.4: CHECK THE AUTHOR**

Record: **Armin Wolf** is listed as maintainer for ACPI WMI / related
Dell WMI drivers. He diagnosed the report and tested on a Dell Inspiron
3505. Related commits in this file are his WMI API conversions; this is
not a drive-by.

**Step 3.5: DEPENDENT/PREREQUISITE COMMITS**

Record: Needs `guard()`, `linux/cleanup.h`, `devm_mutex_init`,
`get_first_smbios_priv()`, `wmi_list`. All present in this 7.3 tree.
Applies on the pre-fix file (parent of 41427211f663c). **Standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig:**
  https://patch.msgid.link/20260720131921.368000-2-W_Armin@gmx.de
- **v1:** 2026-07-16
  https://patch.msgid.link/20260716053337.112533-2-W_Armin@gmx.de
- **v2:** 2026-07-20 — applied version
- v2 change vs v1: move rwsem next to `wmi_list` and add a comment
  (Ilpo’s request). No change to the UAF logic
- Cover letter: UAF reported by a user; **first patch fixes it**;
  remaining two clean up; **tested on Dell Inspiron 3505**; author
  **verified the UAF no longer reproduces** after patch 1
- **No NAKs.** Ilpo applied it to pdx86 for-next (Linus policy: not a
  current-cycle regression, so not -rc; that is merge-window routing,
  not a stable NAK)

**Step 4.2: CHECK WHO REVIEWED**

Record (**b4 dig -w**): Armin Wolf, Ilpo Järvinen, Hans de Goede,
Dell.Client.Kernel, Shuangpeng Bai, platform-driver-x86, LKML,
**gregkh@linuxfoundation.org**, Arnd Bergmann. Maintainer reviewed
(`Reviewed-by: Ilpo Järvinen`).

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: https://lkml.iu.edu/2606.1/13509.html
Shuangpeng Bai, 2026-06-14, KASAN slab-UAF in `_copy_to_user`, task
`dell_smbios_wmi`.
Use: `simple_read_from_buffer` ← `vfs_read`.
Free: `kfree` ← `devres_release_all` ← `unbind_store`.
Reproducer + config:
https://gist.github.com/shuangpengbai/f5b15c099e80897486b4238ddb91df79
Armin confirmed: open fd → unbind frees `devm_kzalloc` priv → read UAF.
WMI core unbind as well as sysfs unbind.

Greg KH: unbind is typically root and “best effort.” That does **not**
make the UAF fictional; stable still takes driver-unbind UAFs. WMI core
can unbind without a user poking sysfs.

**Step 4.4: RELATED PATCHES AND SERIES**

Record: 3-patch series. Patches 2–3 (pass device to callbacks; replace
list with `chardev_priv`) are **not required** for the UAF. Author
stated patch 1 is sufficient; he retested after it.

**Step 4.5: STABLE MAILING LIST HISTORY**

Record: No stable@ thread found. Greg was on the bug thread (char/misc
maintainer), not a stable rejection. **UNVERIFIED:**
lore.kernel.org/stable HTML returned 403; searched via b4 +
openwall/lkml.iu.edu instead.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `dell_smbios_wmi_read`, `dell_smbios_wmi_ioctl`,
`dell_smbios_wmi_call`, `dell_smbios_wmi_probe`,
`dell_smbios_wmi_remove`; removed `dell_smbios_wmi_open`.

**Step 5.2: TRACE CALLERS**

Record:
- **read/ioctl:** VFS on `/dev/wmi/dell-smbios` (miscdevice, mode
  `0444`)
- **Example userspace:** `tools/wmi/dell-smbios-example.c` opens that
  node and issues `DELL_WMI_SMBIOS_CMD`
- **`dell_smbios_wmi_call`:** registered via
  `dell_smbios_register_device()`; in-kernel SMBIOS backend for Dell
  platform code
- Reachable from syscalls: **yes** (`read`, `ioctl`)

**Step 5.3: TRACE CALLEES**

Record: `get_first_smbios_priv`, `simple_read_from_buffer`,
`dell_smbios_wmi_do_ioctl` → `run_smbios_call` → `wmidev_invoke_method`,
`copy_from_user`/`copy_to_user`. Ioctl talks to firmware.

**Step 5.4: CALL CHAIN / REACHABILITY**

Record: `open("/dev/wmi/dell-smbios")` → `read`/`ioctl` while another
task writes the WMI device `unbind` sysfs (or WMI core unbinds).
Reproducer exists. Unprivileged users can **open/read** (0444); unbind
is privileged. Still a real kernel UAF on Dell machines with this driver
(Kconfig: `DELL_SMBIOS` default `m`, `DELL_SMBIOS_WMI` default `y` for
Dell >2007).

**Step 5.5: SIMILAR PATTERNS**

Record: Classic miscdevice vs `devm` lifetime bug. Follow-up in-tree
(`b844001890c5b`) tightens to a single `chardev_priv` +
`dell_smbios_wmi_clear_chardev`; that is cleanup on top of this fix, not
a replacement that this patch needs.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** Local tree is **v7.3-rc4** (`7.3.0-rc4`). Parent of the
candidate still has:

```c
priv = container_of(filp->private_data, struct wmi_smbios_priv,
char_dev);
filp->private_data = priv;
...
struct wmi_smbios_priv *priv = filp->private_data;
```

Bug since ~v6.8 (`93885e85a77f2`), not after this tree branched.

**Step 6.2: BACKPORT COMPLICATIONS**

Record: **Clean apply** onto this tree’s pre-fix `dell-smbios-wmi.c`.
`guard(rwsem_read/write)`, `guard(mutex)`, `devm_mutex_init` all exist
(`include/linux/rwsem.h`, `include/linux/cleanup.h`,
`include/linux/mutex.h`). No missing helpers.

**Step 6.3: RELATED FIXES ALREADY HERE**

Record: This is the first UAF fix for this path. Later series patches
refactor further; they are not a substitute if this patch is the one
under review. No earlier alternate UAF fix for this chardev.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **platform/x86 Dell WMI SMBIOS** — **IMPORTANT** for Dell
laptops (firmware/SMBIOS userspace), not core mm/net. Default-on for
Dell hardware.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: Active in 7.3 (WMI buffer API, this series). Driver itself dates
to 2017; the chardev UAF is in the 2023 misc reimplementation.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: **Driver-specific / Dell x86** with `CONFIG_DELL_SMBIOS_WMI`.
Large laptop population, not universal.

**Step 8.2: TRIGGER CONDITIONS**

Record: Open `/dev/wmi/dell-smbios`, then unbind the WMI device (sysfs
or WMI core) and `read`/`ioctl`. Timing race with a published
reproducer. Open is unprivileged; unbind is typically root/core.
**Verified** via KASAN free/use stacks.

**Step 8.3: FAILURE MODE SEVERITY**

Record: **KASAN slab-use-after-free → kernel oops / potential memory
corruption.** Severity **HIGH** (UAF). Not a WARN-only issue.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit: high** — stops a confirmed UAF on a default Dell driver,
  with a reproducer and hardware test
- **Risk: low** — ~67-line churn in one file, scoped locking, returns
  `-ENODEV` after removal
- **Ratio: strongly favors backport**

Greg’s “root unbind is best effort” lowers *exploitability from
unprivileged userspace*, not the fact of a crashable UAF. Stable
routinely takes this class of driver-lifetime bugs.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

**For:**
- Confirmed KASAN UAF, reproducer, call traces
- User report + maintainer confirmation and hardware test
- Small, single-file, obviously correct lifetime fix
- Bug in this tree since ~v6.8
- Helpers present; applies to this tree’s pre-fix code
- Reviewed by pdx86 maintainer; author is WMI maintainer
- Standalone as patch 1/3

**Against:**
- Trigger usually needs privileged unbind (Greg: “best effort”)
- Dell-specific, not core kernel
- Series has two follow-up cleanups (not required for the UAF)

**Unresolved:**
- lore.kernel.org HTML 403; discussion recovered via b4 + lkml.iu.edu /
  openwall
- Did not download the gist reproducer source (stacks + maintainer
  write-up are enough)

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — lookup-under-rwsem; tested
   on Inspiron 3505; UAF gone after this patch
2. Real bug affecting users? **PASS** — KASAN UAF + gist reproducer
3. Important (crash/security/corruption)? **PASS** — UAF / oops, HIGH
4. Small and contained? **PASS** — +34/-33, one file
5. No new features/APIs? **PASS**
6. Can apply to this local tree? **PASS** — buggy code and prerequisites
   present

**Step 9.3: EXCEPTION CATEGORIES**

Record: None (not a device ID/quirk/DT/build/doc exception). Qualifies
as a normal UAF bugfix.

**Step 9.4: DECISION**

This is a textbook stable candidate: KASAN UAF, small locking/lifetime
change, present in this 7.3 tree, no missing deps.

---

### What the commit solves for this tree

On v7.3-rc4, `dell-smbios-wmi` still has (in the pre-fix file) a misc
chardev that stores `wmi_smbios_priv *` in `filp->private_data`.
Unbinding the WMI device frees that `devm` object while userspace can
still `read()` `/dev/wmi/dell-smbios`. That is a real oops/UAF for Dell
systems (driver default-enabled).

It meets stable rules: real bug, important failure mode, ~one-file
surgical change, no new API, applies here.

Risk vs benefit: low risk vs stopping a confirmed UAF. Follow-up series
patches are cleanup and are not required.

Concerns: unbind is usually privileged; Greg called it best-effort. That
is not a reason to leave a KASAN UAF in a default Dell driver. v1’s
`Fixes: 93885e85a77f2` is already in this tree.

### Verification

- **[Phase 1]** Tags: Reported-by Shuangpeng Bai; Closes lore; Reviewed-
  by Ilpo; v1 had Fixes: 93885e85a77f2
- **[Phase 2]** Diff: +34/-33 in `dell-smbios-wmi.c`; drop
  `private_data`; rwsem + per-priv mutex
- **[Phase 3]** `git log -- drivers/platform/x86/dell/dell-smbios-
  wmi.c`: bug from 93885e85a77f2 (2023-12); ancestor of HEAD
- **[Phase 3]** Parent of 41427211f663c still has `filp->private_data` /
  `dell_smbios_wmi_open`
- **[Phase 4]** `b4 dig -c 41427211f663c`: v2 1/3 at
  patch.msgid.link/20260720131921.368000-2
- **[Phase 4]** `b4 dig -a`: v1 2026-07-16, v2 2026-07-20 (comment
  placement only)
- **[Phase 4]** `b4 dig -w`: Ilpo, Hans, Greg, Arnd, Dell, pdx86 on Cc
- **[Phase 4]** Bug report (lkml.iu.edu): KASAN UAF; free via
  `unbind_store`/`devres_release_all`; use via `simple_read_from_buffer`
- **[Phase 4]** Cover letter: patch 1 fixes UAF; tested on Inspiron 3505
- **[Phase 4]** Ilpo v1 review: comment + place rwsem next to list
  (addressed in v2); no NAK
- **[Phase 5]** Callers: VFS read/ioctl on `/dev/wmi/dell-smbios`;
  example in `tools/wmi/dell-smbios-example.c`
- **[Phase 6]** `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- **[Phase 6]** `guard(rwsem_*)` in `include/linux/rwsem.h`;
  `devm_mutex_init` in `include/linux/mutex.h`
- **[Phase 7]** `DELL_SMBIOS_WMI` default y; Dell >2007
- **[Phase 8]** Failure: slab-UAF → oops; severity HIGH
- **UNVERIFIED:** gist reproducer source not fetched; lore.kernel.org
  HTML 403 (mbox via b4 succeeded)

**YES**

 drivers/platform/x86/dell/dell-smbios-wmi.c | 67 +++++++++++----------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-smbios-wmi.c b/drivers/platform/x86/dell/dell-smbios-wmi.c
index a7dca8c59d602..0729c5a1945c7 100644
--- a/drivers/platform/x86/dell/dell-smbios-wmi.c
+++ b/drivers/platform/x86/dell/dell-smbios-wmi.c
@@ -6,6 +6,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/dmi.h>
 #include <linux/fs.h>
@@ -13,14 +14,13 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/uaccess.h>
 #include <linux/wmi.h>
 #include <uapi/linux/wmi.h>
 #include "dell-smbios.h"
 #include "dell-wmi-descriptor.h"
 
-static DEFINE_MUTEX(call_mutex);
-static DEFINE_MUTEX(list_mutex);
 static int wmi_supported;
 
 struct misc_bios_flags_structure {
@@ -32,6 +32,7 @@ struct misc_bios_flags_structure {
 #define DELL_WMI_SMBIOS_GUID "A80593CE-A997-11DA-B012-B622A1EF5492"
 
 struct wmi_smbios_priv {
+	struct mutex call_lock; /* Protects the content of the SMBIOS buffer */
 	struct dell_wmi_smbios_buffer *buf;
 	struct list_head list;
 	struct wmi_device *wdev;
@@ -39,6 +40,8 @@ struct wmi_smbios_priv {
 	u64 req_buf_size;
 	struct miscdevice char_dev;
 };
+
+static DECLARE_RWSEM(list_lock);	/* Protects access to wmi_list */
 static LIST_HEAD(wmi_list);
 
 static inline struct wmi_smbios_priv *get_first_smbios_priv(void)
@@ -93,40 +96,35 @@ static int dell_smbios_wmi_call(struct calling_interface_buffer *buffer)
 	size_t size;
 	int ret;
 
-	mutex_lock(&call_mutex);
+	guard(rwsem_read)(&list_lock);
+
 	priv = get_first_smbios_priv();
-	if (!priv) {
-		ret = -ENODEV;
-		goto out_wmi_call;
-	}
+	if (!priv)
+		return -ENODEV;
 
 	size = sizeof(struct calling_interface_buffer);
 	difference = priv->req_buf_size - sizeof(u64) - size;
 
+	guard(mutex)(&priv->call_lock);
+
 	memset(&priv->buf->ext, 0, difference);
 	memcpy(&priv->buf->std, buffer, size);
 	ret = run_smbios_call(priv->wdev);
 	memcpy(buffer, &priv->buf->std, size);
-out_wmi_call:
-	mutex_unlock(&call_mutex);
 
 	return ret;
 }
 
-static int dell_smbios_wmi_open(struct inode *inode, struct file *filp)
+static ssize_t dell_smbios_wmi_read(struct file *filp, char __user *buffer, size_t length,
+				    loff_t *offset)
 {
 	struct wmi_smbios_priv *priv;
 
-	priv = container_of(filp->private_data, struct wmi_smbios_priv, char_dev);
-	filp->private_data = priv;
+	guard(rwsem_read)(&list_lock);
 
-	return nonseekable_open(inode, filp);
-}
-
-static ssize_t dell_smbios_wmi_read(struct file *filp, char __user *buffer, size_t length,
-				    loff_t *offset)
-{
-	struct wmi_smbios_priv *priv = filp->private_data;
+	priv = get_first_smbios_priv();
+	if (!priv)
+		return -ENODEV;
 
 	return simple_read_from_buffer(buffer, length, offset, &priv->req_buf_size,
 				       sizeof(priv->req_buf_size));
@@ -173,22 +171,24 @@ static long dell_smbios_wmi_do_ioctl(struct wmi_smbios_priv *priv,
 static long dell_smbios_wmi_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct dell_wmi_smbios_buffer __user *input = (struct dell_wmi_smbios_buffer __user *)arg;
-	struct wmi_smbios_priv *priv = filp->private_data;
-	long ret;
+	struct wmi_smbios_priv *priv;
 
 	if (cmd != DELL_WMI_SMBIOS_CMD)
 		return -ENOIOCTLCMD;
 
-	mutex_lock(&call_mutex);
-	ret = dell_smbios_wmi_do_ioctl(priv, input);
-	mutex_unlock(&call_mutex);
+	guard(rwsem_read)(&list_lock);
 
-	return ret;
+	priv = get_first_smbios_priv();
+	if (!priv)
+		return -ENODEV;
+
+	guard(mutex)(&priv->call_lock);
+
+	return dell_smbios_wmi_do_ioctl(priv, input);
 }
 
 static const struct file_operations dell_smbios_wmi_fops = {
 	.owner		= THIS_MODULE,
-	.open		= dell_smbios_wmi_open,
 	.read		= dell_smbios_wmi_read,
 	.unlocked_ioctl	= dell_smbios_wmi_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
@@ -260,6 +260,10 @@ static int dell_smbios_wmi_probe(struct wmi_device *wdev, const void *context)
 	if (!priv->buf)
 		return -ENOMEM;
 
+	ret = devm_mutex_init(&wdev->dev, &priv->call_lock);
+	if (ret)
+		return ret;
+
 	ret = dell_smbios_wmi_register_chardev(priv);
 	if (ret)
 		return ret;
@@ -268,9 +272,8 @@ static int dell_smbios_wmi_probe(struct wmi_device *wdev, const void *context)
 	if (ret)
 		return ret;
 
-	mutex_lock(&list_mutex);
+	guard(rwsem_write)(&list_lock);
 	list_add_tail(&priv->list, &wmi_list);
-	mutex_unlock(&list_mutex);
 
 	return 0;
 }
@@ -279,12 +282,10 @@ static void dell_smbios_wmi_remove(struct wmi_device *wdev)
 {
 	struct wmi_smbios_priv *priv = dev_get_drvdata(&wdev->dev);
 
-	mutex_lock(&call_mutex);
-	mutex_lock(&list_mutex);
-	list_del(&priv->list);
-	mutex_unlock(&list_mutex);
 	dell_smbios_unregister_device(&wdev->dev);
-	mutex_unlock(&call_mutex);
+
+	guard(rwsem_write)(&list_lock);
+	list_del(&priv->list);
 }
 
 static const struct wmi_device_id dell_smbios_wmi_id_table[] = {
-- 
2.53.0

