Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3243A545E;
	Mon, 20 Apr 2026 13:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691032; cv=none; b=AYUysie1PAfuVnPVgfcgCNKKcBe+9RKZdqiGzTneMnEd45AtruHOAmbRds2jYhz63oOJsnE0SD55BtyLxNzybv4eR5NAp+iUyBtaibbyoe2CLSyhHxhEZ3WWbC6N8KGrFJu3fjYs3MslNG+BaizefaUKVxoUK+rUF4uxXMdngyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691032; c=relaxed/simple;
	bh=Kmw1rpUeW2WlRAoPrreiJSopgyjbzwdEJvI1xGkoz6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=izHaDuIpIYjXUFDIsCH06QdvxkkK5V+upxtuqd1ebrh7PyY5XLus7ChcvWj30O0IxP/qosxdLyjRJhwByaAa74rPFHHTfjC2YZOuN9kZrW8k5arfLuH7nWYLX+JhWlRhyvT3+oUviUMCIfBLlD4ET4k8gZHXcXBNqO7Cy3+AplE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JoKRiekS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JoKRiekS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0532EC2BCB6;
	Mon, 20 Apr 2026 13:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691032;
	bh=Kmw1rpUeW2WlRAoPrreiJSopgyjbzwdEJvI1xGkoz6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoKRiekSbJHJK415wold0Wy82XMAR6V/ICrjXzI2bzdYiGBJ1JhErR1cPuDwbsuEU
	 tcju6DgalzRS3rXr2VhHQ29qH2/+AXGMzBcOGdW0KIIEcElobHA5pqu52ARVlW/gIr
	 n6TyjQ8+VR7BSl+GCT+iMn8MlNHGuAxXK8L9pA3jzegHDCA3Ch8sM9f3xRFCtFcqZW
	 wmheMPdm6jFew+ls8j9F88WKrV3W6K6spqcFcHahpwWN/J+XHcrrDqcUYB/ygTH1Ss
	 6oaGgBikALR7ZuNp37asUjSFhgLgi0zM29KPxHANRU+lFCECo5ykMLwmwhkKrafkTv
	 DTH/ztAVFfx2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Li Chen <me@linux.beauty>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	lyude@redhat.com,
	dakr@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] nouveau: pci: quiesce GPU on shutdown
Date: Mon, 20 Apr 2026 09:08:40 -0400
Message-ID: <20260420131539.986432-54-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Chen <me@linux.beauty>

[ Upstream commit 310326bb7df4bba094a3fc60364c641c547fd923 ]

Kexec reboot does not reset PCI devices.
Invoking the full DRM/TTM teardown from ->shutdown can trigger WARNs when
userspace still holds DRM file descriptors.

Quiesce the GPU through the suspend path and then power down the PCI
function so the next kernel can re-initialize the device from a consistent
state.

WARNING: drivers/gpu/drm/drm_mode_config.c:578 at drm_mode_config_cleanup+0x2e7/0x300, CPU#2: kexec/1300
Call Trace:
 <TASK>
 ? srso_return_thunk+0x5/0x5f
 ? enable_work+0x3a/0x100
 nouveau_display_destroy+0x39/0x70 [nouveau c19e0da7fd83583a023f855c510d9a3903808734]
 nouveau_drm_device_fini+0x7b/0x1f0 [nouveau c19e0da7fd83583a023f855c510d9a3903808734]
 nouveau_drm_shutdown+0x52/0xc0 [nouveau c19e0da7fd83583a023f855c510d9a3903808734]
 pci_device_shutdown+0x35/0x60
 device_shutdown+0x11c/0x1b0
 kernel_kexec+0x13a/0x160
 __do_sys_reboot+0x209/0x240
 do_syscall_64+0x81/0x610
 ? srso_return_thunk+0x5/0x5f
 ? __rtnl_unlock+0x37/0x70
 ? srso_return_thunk+0x5/0x5f
 ? netdev_run_todo+0x63/0x570
 ? netif_change_flags+0x54/0x70
 ? srso_return_thunk+0x5/0x5f
 ? devinet_ioctl+0x1e5/0x790
 ? srso_return_thunk+0x5/0x5f
 ? inet_ioctl+0x1e9/0x200
 ? srso_return_thunk+0x5/0x5f
 ? srso_return_thunk+0x5/0x5f
 ? sock_do_ioctl+0x7d/0x130
 ? srso_return_thunk+0x5/0x5f
 ? __x64_sys_ioctl+0x97/0xe0
 ? srso_return_thunk+0x5/0x5f
 ? srso_return_thunk+0x5/0x5f
 ? do_syscall_64+0x23b/0x610
 ? srso_return_thunk+0x5/0x5f
 ? put_user_ifreq+0x7a/0x90
 ? srso_return_thunk+0x5/0x5f
 ? sock_do_ioctl+0x107/0x130
 ? srso_return_thunk+0x5/0x5f
 ? __x64_sys_ioctl+0x97/0xe0
 ? srso_return_thunk+0x5/0x5f
 ? do_syscall_64+0x81/0x610
 ? srso_return_thunk+0x5/0x5f
 ? exc_page_fault+0x7e/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

nouveau 0000:26:00.0: [drm] drm_WARN_ON(!list_empty(&fb->filp_head))
WARNING: drivers/gpu/drm/drm_framebuffer.c:833 at drm_framebuffer_free+0x73/0xa0, CPU#2: kexec/1300
Call Trace:
 <TASK>
 drm_mode_config_cleanup+0x248/0x300
 ? __pfx___drm_printfn_dbg+0x10/0x10
 ? drm_mode_config_cleanup+0x1dc/0x300
 nouveau_display_destroy+0x39/0x70 [nouveau c19e0da7fd83583a023f855c510d9a3903808734]
 nouveau_drm_device_fini+0x7b/0x1f0 [nouveau c19e0da7fd83583a023f855c510d9a3903808734]
 nouveau_drm_shutdown+0x52/0xc0 [nouveau c19e0da7fd83583a023f855c510d9a3903808734]
 pci_device_shutdown+0x35/0x60
 device_shutdown+0x11c/0x1b0
 kernel_kexec+0x13a/0x160
 __do_sys_reboot+0x209/0x240
 do_syscall_64+0x81/0x610
 ? srso_return_thunk+0x5/0x5f
 ? __rtnl_unlock+0x37/0x70
 ? srso_return_thunk+0x5/0x5f
 ? netdev_run_todo+0x63/0x570
 ? netif_change_flags+0x54/0x70
 ? srso_return_thunk+0x5/0x5f
 ? devinet_ioctl+0x1e5/0x790
 ? srso_return_thunk+0x5/0x5f
 ? inet_ioctl+0x1e9/0x200
 ? srso_return_thunk+0x5/0x5f
 ? srso_return_thunk+0x5/0x5f
 ? sock_do_ioctl+0x7d/0x130
 ? srso_return_thunk+0x5/0x5f
 ? __x64_sys_ioctl+0x97/0xe0
 ? srso_return_thunk+0x5/0x5f
 ? srso_return_thunk+0x5/0x5f
 ? do_syscall_64+0x23b/0x610
 ? srso_return_thunk+0x5/0x5f
 ? put_user_ifreq+0x7a/0x90
 ? srso_return_thunk+0x5/0x5f
 ? sock_do_ioctl+0x107/0x130
 ? srso_return_thunk+0x5/0x5f
 ? __x64_sys_ioctl+0x97/0xe0
 ? srso_return_thunk+0x5/0x5f
 ? do_syscall_64+0x81/0x610
 ? srso_return_thunk+0x5/0x5f
 ? exc_page_fault+0x7e/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

WARNING: include/drm/ttm/ttm_resource.h:406 at nouveau_ttm_fini+0x257/0x270 [nouveau], CPU#2: kexec/1300
Call Trace:
 <TASK>
 nouveau_drm_device_fini+0x93/0x1f0 [nouveau c19e0da7fd83583a023f855c510d9a3903808734]
 nouveau_drm_shutdown+0x52/0xc0 [nouveau c19e0da7fd83583a023f855c510d9a3903808734]
 pci_device_shutdown+0x35/0x60
 device_shutdown+0x11c/0x1b0
 kernel_kexec+0x13a/0x160
 __do_sys_reboot+0x209/0x240
 do_syscall_64+0x81/0x610
 ? srso_return_thunk+0x5/0x5f
 ? __rtnl_unlock+0x37/0x70
 ? srso_return_thunk+0x5/0x5f
 ? netdev_run_todo+0x63/0x570
 ? netif_change_flags+0x54/0x70
 ? srso_return_thunk+0x5/0x5f
 ? devinet_ioctl+0x1e5/0x790
 ? srso_return_thunk+0x5/0x5f
 ? inet_ioctl+0x1e9/0x200
 ? srso_return_thunk+0x5/0x5f
 ? srso_return_thunk+0x5/0x5f
 ? sock_do_ioctl+0x7d/0x130
 ? srso_return_thunk+0x5/0x5f
 ? __x64_sys_ioctl+0x97/0xe0
 ? srso_return_thunk+0x5/0x5f
 ? srso_return_thunk+0x5/0x5f
 ? do_syscall_64+0x23b/0x610
 ? srso_return_thunk+0x5/0x5f
 ? put_user_ifreq+0x7a/0x90
 ? srso_return_thunk+0x5/0x5f
 ? sock_do_ioctl+0x107/0x130
 ? srso_return_thunk+0x5/0x5f
 ? __x64_sys_ioctl+0x97/0xe0
 ? srso_return_thunk+0x5/0x5f
 ? do_syscall_64+0x81/0x610
 ? srso_return_thunk+0x5/0x5f
 ? exc_page_fault+0x7e/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Signed-off-by: Li Chen <me@linux.beauty>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260121113646.111561-1-me@linux.beauty
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
- **Subsystem**: `nouveau: pci:` (Nouveau GPU driver, PCI subsystem)
- **Action verb**: "quiesce" - implies bringing hardware to a
  quiet/consistent state, a hardware management fix
- **Summary**: Quiesce the NVIDIA GPU on PCI shutdown to handle kexec
  reboot properly

Record: [nouveau: pci] [quiesce] [Add proper GPU shutdown handler for
kexec reboot]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by: Li Chen <me@linux.beauty>** - the author
- **Reviewed-by: Dave Airlie <airlied@redhat.com>** - DRM maintainer
  reviewed it
- **Signed-off-by: Dave Airlie <airlied@redhat.com>** - DRM maintainer
  also signed off (committed it)
- **Link:**
  https://patch.msgid.link/20260121113646.111561-1-me@linux.beauty - the
  v2 submission

No Fixes: tag, no Cc: stable tag, no Reported-by. The absence of these
is expected.

Record: Reviewed-by and Signed-off-by from Dave Airlie (DRM maintainer)
is a strong quality signal.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit describes two problems:
1. **Problem 1**: Kexec reboot does not reset PCI devices, so without a
   shutdown handler, the GPU hardware remains in an unknown state after
   kexec.
2. **Problem 2**: Doing a full DRM/TTM teardown from `->shutdown`
   triggers WARNs when userspace still holds DRM file descriptors.

Three stack traces are provided showing WARNING triggers at:
- `drm_mode_config_cleanup+0x2e7/0x300` (drm_mode_config.c:578)
- `drm_framebuffer_free+0x73/0xa0` (drm_framebuffer.c:833) -
  `drm_WARN_ON(!list_empty(&fb->filp_head))`
- `nouveau_ttm_fini+0x257/0x270` (ttm_resource.h:406)

All triggered through the path: `kernel_kexec -> device_shutdown ->
pci_device_shutdown -> nouveau_drm_shutdown -> nouveau_drm_device_fini`

**Solution**: Use the suspend path (which properly handles open
userspace FDs) instead of full teardown, then power down the PCI
function to D3hot.

Record: [Bug: GPU not properly quiesced during kexec reboot, causing
WARNs and potential GPU init failures in next kernel] [Symptom: multiple
kernel WARNINGs during kexec shutdown] [Root cause: Missing .shutdown
callback, and naive full-teardown approach triggers WARNs with open FDs]

### Step 1.4: DETECT HIDDEN BUG FIXES
This is an overt bug fix. The commit directly addresses kernel WARNINGs
and ensures proper GPU quiescing during kexec. It's a hardware
workaround for the fact that kexec doesn't reset PCI devices.

Record: Not a hidden bug fix - this is an explicit fix for kernel
WARNINGs and kexec reliability.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **Files changed**: `drivers/gpu/drm/nouveau/nouveau_drm.c` (1 file)
- **Lines added**: ~32 lines (new function + 1 line to hook it up)
- **Lines removed**: 0
- **Functions modified**: None modified; one new function
  `nouveau_drm_shutdown()` added
- **Scope**: Single-file, purely additive change

Record: [1 file, +32/-0 lines] [New function nouveau_drm_shutdown(),
struct pci_driver updated] [Scope: single-file surgical addition]

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Before**: `nouveau_drm_pci_driver` has no `.shutdown` callback. During
kexec, `pci_device_shutdown()` does nothing for nouveau, leaving the GPU
in an unknown hardware state.

**After**: `nouveau_drm_shutdown()` is called during PCI device
shutdown. It:
1. Checks if drm is NULL (safety check)
2. Checks if power is already off (switcheroo check, matching suspend
   pattern)
3. Calls `nouveau_do_suspend(drm, false)` to quiesce the GPU through the
   proven suspend path
4. Calls `pci_save_state`, `pci_disable_device`,
   `pci_set_power_state(PCI_D3hot)` to power down PCI
5. Calls `usleep_range(200, 400)` to allow PCI power transition to
   settle (mirrors `udelay(200)` in `nouveau_pmops_suspend`)

Record: [Before: no shutdown handler -> GPU left in unknown state during
kexec] [After: proper suspend-based quiescing + PCI power down]

### Step 2.3: IDENTIFY THE BUG MECHANISM
This is a **hardware workaround** fix. Category: **Missing shutdown
handler causing kernel WARNINGs and potential GPU initialization
failures**.

The fix closely mirrors `nouveau_pmops_suspend()`:

```1034:1053:drivers/gpu/drm/nouveau/nouveau_drm.c
nouveau_pmops_suspend(struct device *dev)
{
        struct pci_dev *pdev = to_pci_dev(dev);
        struct nouveau_drm *drm = pci_get_drvdata(pdev);
        // ... same pattern: do_suspend, pci_save_state,
pci_disable_device, pci_set_power_state, udelay
```

Record: [Category: Missing shutdown handler / hardware quiescing]
[Mechanism: PCI device not properly quiesced before kexec, leading to
inconsistent GPU state and WARNs if full teardown attempted]

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct**: Yes - it mirrors the well-tested suspend path
  exactly, using `nouveau_do_suspend()` which is the proven way to
  quiesce the GPU
- **Minimal/surgical**: Yes - purely additive, touches one file, doesn't
  modify existing code
- **Regression risk**: Very low - adds a new callback that reuses
  existing proven infrastructure
- **Red flags**: None. The function is self-contained and uses well-
  established APIs

Record: [Fix quality: Excellent. Reuses proven suspend path. Purely
additive.] [Regression risk: Very low - new callback, no modification to
existing paths]

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The PCI driver struct (`nouveau_drm_pci_driver`) was created in commit
`9458029940ffc6` by Ben Skeggs (2012-07-06). It has never had a
`.shutdown` handler. This means the bug has existed since the nouveau
driver was first created - the GPU has never been properly quiesced on
PCI shutdown.

Record: [PCI driver struct created 2012 (v3.6 era), never had .shutdown]
[Bug present since nouveau's inception]

### Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag present (expected for autosel candidates).

Record: [No Fixes: tag - expected]

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Recent commits to `nouveau_drm.c` include `8f8a4dce64013` ("nouveau: add
a third state to the fini handler") which changed `nvif_client_suspend`
to take a `bool runtime` parameter. However, this doesn't affect the new
`nouveau_drm_shutdown` function, which calls `nouveau_do_suspend(drm,
false)` - and `nouveau_do_suspend`'s external interface `(struct
nouveau_drm *, bool)` has been stable since at least 2014.

Record: [Related commit 8f8a4dce64013 changes internals of
nouveau_do_suspend but not its interface] [No prerequisites needed for
this patch]

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Li Chen has no other commits to the nouveau driver. However, the patch
was reviewed and signed off by Dave Airlie, who is the DRM maintainer
and a major contributor to nouveau.

Record: [Author: Li Chen (new contributor to nouveau)] [Reviewer: Dave
Airlie (DRM maintainer) - strong endorsement]

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
The patch is completely standalone:
- It adds a new function using only existing stable APIs
  (`nouveau_do_suspend`, PCI helpers, `usleep_range`)
- It adds a single struct field assignment (`.shutdown =
  nouveau_drm_shutdown`)
- No modifications to existing functions

Record: [No dependencies. Fully standalone. All APIs used are long-
standing.]

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Found the full discussion on dri-devel mailing list:
- **v1**: Jan 20, 2026 - Initial submission without comment on
  usleep_range
- **v2**: Jan 21, 2026 - Added comment explaining usleep_range, gained
  Reviewed-by from Dave Airlie
- **Applied**: Feb 9, 2026 - Dave Airlie applied to drm-misc-next
  targeting 7.1

Dave Airlie's v1 review asked "Why is this [usleep_range] needed? it at
least needs a comment." After Li Chen explained, Dave gave `Reviewed-by:
Dave Airlie <airlied@redhat.com>` on v1 with the comment addition, and
the v2 with the comment was applied.

Record: [v1 and v2 submitted] [Dave Airlie reviewed, requested comment
on usleep_range] [Applied to drm-misc-next targeting 7.1] [No NAKs or
concerns]

### Step 4.2: CHECK WHO REVIEWED THE PATCH
CC'd: Dave Airlie, Lyude Paul, Danilo Krummrich, Maarten Lankhorst,
Maxime Ripard, Thomas Zimmermann, Simona Vetter, dri-devel, nouveau,
linux-kernel. All appropriate maintainers were included.

Record: [All DRM/nouveau maintainers were CC'd] [Dave Airlie (DRM
maintainer) reviewed]

### Step 4.3: SEARCH FOR THE BUG REPORT
The commit itself contains the bug report in the form of stack traces.
The author hit this during kexec reboot with nouveau hardware. No
separate bug report found.

Record: [Author-reported bug with full stack traces in commit message]

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
This is a standalone single-patch submission (not part of a series).

Record: [Standalone single patch, no series]

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
No specific stable discussion found. Dave Airlie noted it targets 7.1,
but no explicit discussion about stable backporting.

Record: [No stable-specific discussion found]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
- `nouveau_drm_shutdown()` (new function)
- References: `nouveau_do_suspend()`, PCI helpers

### Step 5.2: TRACE CALLERS
`nouveau_drm_shutdown()` is called from `pci_device_shutdown()` (PCI
core) via the `.shutdown` function pointer. This is triggered during:
- `kernel_kexec()` -> `device_shutdown()` -> `pci_device_shutdown()`
- `kernel_restart()` -> `device_shutdown()` -> `pci_device_shutdown()`
- `kernel_power_off()` -> `device_shutdown()` -> `pci_device_shutdown()`

Record: [Called from PCI core during system shutdown/kexec/restart]
[Affects all nouveau users during kexec]

### Step 5.3: TRACE CALLEES
The function calls:
1. `pci_get_drvdata()` - get driver data
2. `nouveau_do_suspend(drm, false)` - the main GPU quiescing function,
   proven by years of suspend/resume usage
3. `pci_save_state()`, `pci_disable_device()`, `pci_set_power_state()` -
   standard PCI power management
4. `usleep_range()` - kernel delay function

Record: [All callees are well-established, well-tested functions]

### Step 5.4: FOLLOW THE CALL CHAIN
`kernel_kexec()` -> `device_shutdown()` -> `pci_device_shutdown()` ->
`nouveau_drm_shutdown()` -> `nouveau_do_suspend()` -> suspends display,
evicts VRAM, idles channels, suspends fences, suspends object tree

This is a critical path for kexec reliability. Without proper GPU
quiescing, the GPU may continue DMA operations after kexec, potentially
corrupting the new kernel's memory.

Record: [Reachable via kexec syscall - a real user operation] [Critical
for system reliability during kexec]

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
Both `amdgpu` and `xe` (Intel) drivers have `.shutdown` handlers. This
is a well-established pattern for GPU PCI drivers. Nouveau was the
notable omission.

Record: [amdgpu, xe, and many other DRM drivers have .shutdown handlers
- nouveau was missing one]

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
The `nouveau_drm_pci_driver` struct without `.shutdown` has existed
since kernel 3.6 (2012). This bug affects ALL stable trees. The nouveau
driver exists in all active stable trees.

Record: [Bug exists in ALL stable trees - nouveau has never had a
.shutdown handler]

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
The patch adds code between `nouveau_pmops_resume` and
`nouveau_pmops_freeze`, and adds `.shutdown` to the pci_driver struct.
Both areas have been stable for years (blame shows 2012 era). The patch
should apply cleanly to all stable trees.

One minor consideration: in stable trees without commit `8f8a4dce64013`,
`nouveau_do_suspend` internally calls
`nvif_client_suspend(&drm->_client)` (without the `bool` parameter).
However, this doesn't affect the new function at all - it only calls
`nouveau_do_suspend(drm, false)`, and the `nouveau_do_suspend` interface
has been stable since 2014.

Record: [Expected: clean apply to all stable trees] [No conflicts
anticipated]

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE
No related fix exists in any stable tree. Nouveau has never had a
`.shutdown` handler.

Record: [No related fixes in stable]

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
- **Subsystem**: `drivers/gpu/drm/nouveau/` - NVIDIA GPU driver
- **Criticality**: IMPORTANT - nouveau is the open-source driver for all
  NVIDIA GPUs, widely used in Linux distributions

Record: [Subsystem: nouveau/DRM GPU driver] [Criticality: IMPORTANT -
widely used GPU driver]

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
The nouveau driver is actively developed with recent commits for
GB10x/GB20x/GH100 support, GSP-RM support, etc.

Record: [Actively maintained subsystem]

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
All users with NVIDIA GPUs using the nouveau driver who perform kexec
reboots. This includes:
- Systems using kexec for fast reboots
- Systems using kdump for crash dump collection
- Systems using KHO/LUO (Kernel Handover)
- Enterprise and data center environments that rely on kexec

Record: [Affected: All nouveau users performing kexec/kdump] [Subsystem-
specific but affects a large user base]

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
- **Trigger**: Performing a kexec reboot on a system with a nouveau-
  driven NVIDIA GPU
- **How common**: Kexec is commonly used in server environments, kdump
  configurations, and development workflows
- **Unprivileged**: No - kexec requires root/CAP_SYS_BOOT

Record: [Triggered by kexec reboot with nouveau GPU] [Moderately common
trigger for server/dev environments]

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
When the bug triggers:
1. **Without any shutdown handler (current state)**: GPU hardware left
   in unknown state after kexec. The next kernel may fail to initialize
   the GPU, or the GPU may continue DMA into the new kernel's memory
   (potential memory corruption/crash). Severity: **HIGH**
2. **With naive full-teardown shutdown handler**: Multiple kernel
   WARNINGs triggered (`drm_mode_config_cleanup`,
   `drm_framebuffer_free`, `nouveau_ttm_fini`). Severity: **MEDIUM-
   HIGH** (WARNs, potential instability)

Record: [Failure mode: GPU init failure in kexec'd kernel + kernel
WARNINGs] [Severity: HIGH]

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
- **BENEFIT**: Prevents GPU initialization failures and kernel WARNINGs
  during kexec. Ensures GPU is in a consistent state for the next
  kernel. Enables proper kdump operation.
- **RISK**: Very low. ~32 lines of purely additive code. Uses proven
  suspend infrastructure. Reviewed by DRM maintainer. Cannot affect non-
  shutdown paths.

Record: [Benefit: HIGH - prevents kexec failures and WARNs] [Risk: VERY
LOW - additive, reuses proven code, DRM maintainer review] [Ratio:
Strongly favorable]

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**Evidence FOR backporting:**
- Fixes real kernel WARNINGs with concrete stack traces
- Prevents GPU initialization failures after kexec (potential for DMA
  corruption)
- Purely additive, small (~32 lines), single-file change
- Reuses proven `nouveau_do_suspend()` suspend path
- Follows the same pattern as `nouveau_pmops_suspend()` and other GPU
  drivers (amdgpu, xe)
- Reviewed and signed off by Dave Airlie (DRM maintainer)
- No dependencies on other patches
- Should apply cleanly to all stable trees
- Bug has existed since nouveau's creation (2012)
- Fills a gap - nouveau was one of the few major GPU drivers without
  `.shutdown`

**Evidence AGAINST backporting:**
- No explicit `Cc: stable@vger.kernel.org` tag
- No `Fixes:` tag
- Author applied it to drm-misc-next (targeting 7.1), not stable

**UNRESOLVED QUESTIONS:**
- None significant - all aspects verified

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES - mirrors proven suspend path,
   reviewed by DRM maintainer
2. **Fixes a real bug?** YES - kernel WARNINGs + GPU initialization
   failures during kexec
3. **Important issue?** YES - system warnings, potential GPU DMA
   corruption, kexec/kdump reliability
4. **Small and contained?** YES - 32 lines, 1 file, purely additive
5. **No new features or APIs?** CORRECT - no new features, just a
   missing shutdown handler
6. **Can apply to stable trees?** YES - standalone, uses stable APIs

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
This could be classified as a **hardware workaround** (ensuring GPU is
properly quiesced before kexec), which is an allowed exception category.

### Step 9.4: MAKE YOUR DECISION
The evidence strongly supports backporting. This is a small, well-
contained fix that prevents real kernel WARNINGs and potential GPU
initialization failures during kexec. It reuses proven suspend
infrastructure, was reviewed by the DRM maintainer, and has no
dependencies. The risk is very low and the benefit is significant for
anyone using kexec/kdump with NVIDIA hardware.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Dave Airlie (DRM maintainer), Link
  to patch.msgid.link
- [Phase 2] Diff analysis: 32 lines added in one file. New
  `nouveau_drm_shutdown()` function + `.shutdown` hook in pci_driver
  struct. Purely additive.
- [Phase 2] Code comparison: New function mirrors
  `nouveau_pmops_suspend()` (lines 1034-1053 of current tree) with
  matching pattern of do_suspend + PCI power management
- [Phase 3] git blame: `nouveau_drm_pci_driver` struct created 2012
  (commit 9458029940ffc6), never had `.shutdown` - bug present since
  inception
- [Phase 3] Related commit `8f8a4dce64013` changes `nouveau_do_suspend`
  internals but not its interface - no conflict with this patch
- [Phase 3] No prerequisites found - patch is standalone
- [Phase 4] Mailing list: v1 submitted Jan 20, v2 with comment on
  usleep_range submitted Jan 21, Dave Airlie reviewed and applied Feb 9
  to drm-misc-next targeting 7.1
- [Phase 4] Dave Airlie explicitly gave Reviewed-by after reviewing v1
  and requesting a comment addition
- [Phase 4] No NAKs or concerns raised by any reviewer
- [Phase 5] `nouveau_drm_shutdown()` called from `pci_device_shutdown()`
  during kexec/restart/poweroff - standard PCI driver shutdown path
- [Phase 5] Both amdgpu and xe (Intel) GPU drivers have `.shutdown`
  handlers - nouveau was the outlier
- [Phase 6] Bug exists in all stable trees - nouveau has never had a
  .shutdown handler
- [Phase 6] Patch expected to apply cleanly - `nouveau_do_suspend(struct
  nouveau_drm *, bool)` interface stable since 2014
- [Phase 8] Failure mode: kernel WARNINGs + potential GPU init failure
  after kexec. Severity: HIGH
- [Phase 8] Risk: Very low - purely additive, uses proven code paths

**YES**

 drivers/gpu/drm/nouveau/nouveau_drm.c | 32 +++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 915f73279302d..cb22237ac17d9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -1079,6 +1079,37 @@ nouveau_pmops_resume(struct device *dev)
 	return ret;
 }
 
+static void
+nouveau_drm_shutdown(struct pci_dev *pdev)
+{
+	struct nouveau_drm *drm = pci_get_drvdata(pdev);
+	int ret;
+
+	if (!drm)
+		return;
+
+	if (drm->dev->switch_power_state == DRM_SWITCH_POWER_OFF ||
+	    drm->dev->switch_power_state == DRM_SWITCH_POWER_DYNAMIC_OFF)
+		return;
+
+	ret = nouveau_do_suspend(drm, false);
+	if (ret)
+		NV_ERROR(drm, "shutdown suspend failed with: %d\n", ret);
+
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+	/*
+	 *  This is just to give the pci power transition time to settle
+	 *  before an immediate kexec jump. it’s mirroring the existing
+	 *  nouveau_pmops_suspend() behavior, which already does
+	 *  udelay(200) right after pci_set_power_state(..., pci_d3hot). In
+	 *  ->shutdown() we’re allowed to sleep, so I used usleep_range()
+	 *  instead of a busy-wait udelay().
+	 */
+	usleep_range(200, 400);
+}
+
 static int
 nouveau_pmops_freeze(struct device *dev)
 {
@@ -1408,6 +1439,7 @@ nouveau_drm_pci_driver = {
 	.id_table = nouveau_drm_pci_table,
 	.probe = nouveau_drm_probe,
 	.remove = nouveau_drm_remove,
+	.shutdown = nouveau_drm_shutdown,
 	.driver.pm = &nouveau_pm_ops,
 };
 
-- 
2.53.0

