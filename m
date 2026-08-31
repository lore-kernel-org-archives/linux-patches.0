Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B24747207B;
	Mon, 31 Aug 2026 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183842; cv=none; b=J7IXrie6hafEcxWwnHmf0PAXdMXerApsg71cdgGR5D1HrASVJxHEcA7BbdOCkFxwFhXPK/eJtgHXBYmJwrkunpj/56fSC2dvexaHH+KzCPJ4ocotEAn8ROGL3IwY1FxwL+KuyJF8g2LclHZSPiv5lvmBD6vF1HpN5dtXu25Ob9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183842; c=relaxed/simple;
	bh=7Q9rF9RDvZN6PtrLOYsQnHab+PsSHEu6KkHbERSWFv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uw6Lm/+cnZ+zPbu/hWv3zTg8YdKn9h5tTsPhIkZvPZDpzJiObHFKqALD/k/5CGXjHkBzQf4iIRPCJQSYA92U12LyB57lSMvpW6+NIl2y+hE/e5nOq8eO/9asmUi1xPiESClI0KDWtV7XFCKpngub5KF5JEUDUZY2Dn0/HTTUCMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWjzU6vi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWjzU6vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9321F000E9;
	Mon, 31 Aug 2026 13:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183840;
	bh=o3wWjFpJCtb2Bz5j2V3o93x9IzdEFAZfEDPAuSG6I7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWjzU6viVQZaYyu9M+a3If9kXzdZjbq/RhhlIp8HCW5247Ekvr0LLEyDzvDIr7x3j
	 7vBkQhC7Yjl82dlqgRDlQTkXnY7W7yfF8kK7J89w0RsO47m9+e8yXu8ADQiIoNyYxr
	 dJ9IxbQwwud5vr8RnqLgYX3+NUedBOXemqq0i7RjJ2YR+n8+vvWuYRdYWMoYFi7T/n
	 elPlJ6WYrNtE4+2tFa+fGu6T5pwGRPZaYWjMUF01tdY5sMDfc2VLO+w8x+kT22dBS9
	 vTel6oDTemlRkkPt6zRzu3HcTrjX6b+RtBIfWg0T9vDkAUOWLlrNpSH2kxCMloiG49
	 rOq03VGWhyUmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hardik Garg <hargar@linux.microsoft.com>,
	Tianyu Lan <Tianyu.Lan@microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	decui@microsoft.com,
	longli@microsoft.com,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] Drivers: hv: vmbus: add VTL2 redirect connection ID
Date: Mon, 31 Aug 2026 09:26:03 -0400
Message-ID: <20260831133314.4125787-335-sashal@kernel.org>
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

From: Hardik Garg <hargar@linux.microsoft.com>

[ Upstream commit 92d0593128023cf93ae61b7728dcc3062f8d514f ]

VMBus sends CHANNELMSG_INITIATE_CONTACT through a Hyper-V message
connection ID. Older protocol versions use VMBUS_MESSAGE_CONNECTION_ID,
while protocol version 5.0 and newer normally use
VMBUS_MESSAGE_CONNECTION_ID_4.

For a VTL2 kernel using VMBus protocol 5.0 or newer, the host
may expect INITIATE_CONTACT on either the redirect connection ID or
VMBUS_MESSAGE_CONNECTION_ID_4. There is no capability indication that
identifies which ID is active, so the driver must determine it at runtime.

During VMBus negotiation, the redirect ID is tried first because it is
used by VTL2 configurations with VMBus redirection enabled. If the
redirect ID is unavailable, the host rejects it synchronously with
HV_STATUS_INVALID_CONNECTION_ID, allowing fallback to the standard ID.

Return a distinct error for an invalid Initiate Contact connection ID so
this fallback does not mask other post-message failures or
protocol-version rejections. Preserve the existing connection ID
selection for older protocol versions or when running below VTL2.

Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Naman Jain <namjain@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: Drivers: hv: vmbus: add VTL2 redirect
connection ID

**Local tree:** `v6.18.44` (`linux-6.18.y` stable), `git describe HEAD`
= `v6.18.44-2-g1b9e1abadee04`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drivers: hv: vmbus]` `[add]` — Add runtime selection of
the VTL2 redirect VMBus message connection ID during INITIATE_CONTACT
negotiation.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Hardik Garg `<hargar@linux.microsoft.com>` (author)
- **Reviewed-by:** Tianyu Lan, Saurabh Sengar, Naman Jain, Michael
  Kelley (Microsoft Hyper-V reviewers)
- **Signed-off-by:** Wei Liu `<wei.liu@kernel.org>` (Hyper-V maintainer)
- **No** `Fixes:`, `Reported-by:`, `Link:`, `Cc:
  stable@vger.kernel.org`, `Tested-by:`, or `Acked-by:` tags
- Notable: Multiple Microsoft subsystem reviewers; Wei Liu replied
  "Applied. Thanks." on the mailing list (patchew)

### Step 1.3: Body analysis
**Record:**
- **Bug:** On VTL2 guests using VMBus protocol 5.0+, the host may
  require `CHANNELMSG_INITIATE_CONTACT` on connection ID `0x800074`
  (redirect) instead of `VMBUS_MESSAGE_CONNECTION_ID_4` (4). There is no
  capability bit to distinguish which is active.
- **Symptom:** INITIATE_CONTACT sent to the wrong connection ID is not
  delivered; VMBus negotiation never completes → `vmbus_connect()` fails
  with "Unable to connect to host".
- **Root cause:** Driver unconditionally uses
  `VMBUS_MESSAGE_CONNECTION_ID_4` for protocol ≥ 5.0.
- **Fix approach:** For `ms_hyperv.vtl == 2` and protocol ≥ 5.0, try
  redirect ID first; on synchronous `HV_STATUS_INVALID_CONNECTION_ID`,
  fall back to ID 4. Return `-ENXIO` (not `-EINVAL`) for invalid
  INITIATE_CONTACT connection IDs so fallback is distinguishable from
  other failures.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Subject says "add" but this is a connectivity bug fix
for an existing supported configuration (VTL2 + VMBus 5.0+), not a new
subsystem. It is a hardware/platform workaround analogous to connection-
endpoint probing.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- `drivers/hv/connection.c`: +30 / -19 lines (refactor + retry logic)
- `drivers/hv/hyperv_vmbus.h`: +2 lines (new enum constant)
- **Functions modified:** `vmbus_negotiate_version` (split into
  `vmbus_try_connection_id` + wrapper), `vmbus_post_msg`
- **Scope:** Single-subsystem, 2-file surgical change

### Step 2.2: Code flow per hunk
**Record:**
1. **`vmbus_try_connection_id` (new static helper):** Before:
   `vmbus_negotiate_version` hardcoded `VMBUS_MESSAGE_CONNECTION_ID_4`.
   After: caller supplies `connection_id` for protocol ≥ 5.0. Normal
   negotiation path unchanged otherwise.
2. **`vmbus_negotiate_version` (wrapper):** Before: single attempt with
   ID 4. After: if VTL2 + protocol ≥ 5.0, try redirect ID; on `-ENXIO`
   only, retry with ID 4. All other paths unchanged.
3. **`vmbus_post_msg`:** Before: `HV_STATUS_INVALID_CONNECTION_ID` on
   INITIATE_CONTACT → `-EINVAL`. After: → `-ENXIO` to enable controlled
   fallback without masking other errors.
4. **`hyperv_vmbus.h`:** Adds `VMBUS_MESSAGE_CONNECTION_ID_REDIRECT =
   0x800074`.

### Step 2.3: Bug mechanism
**Record:** **Category:** Logic/correctness fix — wrong endpoint
selection. **Mechanism:** VTL2 hosts with VMBus redirection route the
control plane through redirect connection ID `0x800074`. Driver always
posted to ID 4; host never received INITIATE_CONTACT, so negotiation
failed silently.

### Step 2.4: Fix quality
**Record:** Fix is obviously correct and minimal. Gated strictly on
`ms_hyperv.vtl == 2` (v2 improved from v1's `>= 2` per Michael Kelley's
review). Fallback preserves existing behavior when redirect is
unavailable. **Regression risk:** Very low — VTL0/VTL1 guests
unaffected; non-VTL2 code path identical except `-ENXIO` vs `-EINVAL` on
INITIATE_CONTACT invalid ID (both cause version-negotiation loop to
continue, verified below).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Current hardcoded-ID code at lines 99–102 dates to the 6.18
merge base (`5d324e5159d9e`). `msg->msg_vtl = ms_hyperv.vtl` and
`VERSION_WIN10_V5` handling are present in this tree. Bug has existed
since VMBus 5.0 + VTL2 support were both present.

### Step 3.2: Fixes: tag
**Record:** Not applicable — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Recent `drivers/hv/` activity includes VMBus 6.0 support
(`1639df1a9844e`), SynIC changes, mshv fixes. No prior fix for VTL2
redirect connection ID in this tree. Standalone patch (v2 of a
2-revision series; v2 simplified per maintainer feedback).

### Step 3.4: Author context
**Record:** Hardik Garg (Microsoft). Reviewed by Michael Kelley (long-
time Hyper-V maintainer), Tianyu Lan, Saurabh Sengar, Naman Jain.
Applied by Wei Liu (Hyper-V maintainer).

### Step 3.5: Dependencies
**Record:** Requires `ms_hyperv.vtl` (present in `include/asm-
generic/mshyperv.h`, set in `arch/x86/hyperv/hv_init.c` and
`arch/arm64/hyperv/mshyperv.c`), `VERSION_WIN10_V5` (present in
`connection.c`), and VTL2 boot support (`arch/x86/hyperv/hv_vtl.c`,
`CONFIG_HYPERV_VTL_MODE` in `drivers/hv/Kconfig`). All prerequisites
exist in 6.18.44. **Standalone:** yes.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Lore URL: https://lists.openwall.net/linux-
kernel/2026/07/17/12 (v2). Patchew: https://patchew.org/linux/2026071700
1837.635756-1-hargar@linux.microsoft.com/. Series: v1 (Jul 14) → v2 (Jul
17). v2 incorporated Michael Kelley's feedback (simpler retry, exact
`vtl == 2`, cleaner comments). Wei Liu applied to mainline ~Jul 28,
2026. **No explicit stable nomination** found in thread.

### Step 4.2: Reviewers
**Record:** CC'd to K. Y. Srinivasan, Haiyang Zhang, Wei Liu, Dexuan
Cui, Saurabh Sengar, Michael Kelley, linux-hyperv@, linux-kernel@.
Appropriate maintainers reviewed.

### Step 4.3: Bug reports
**Record:** No syzbot, bugzilla, or user `Reported-by:` tags. Bug
identified through Microsoft VTL2/VMBus protocol engineering; Michael
Kelley confirmed the technical requirement in review.

### Step 4.4: Series context
**Record:** Standalone 1-patch series. v2 is the final applied version.
No other patches required.

### Step 4.5: Stable list history
**Record:** No stable@ discussion found for this fix.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `vmbus_try_connection_id`, `vmbus_negotiate_version`,
`vmbus_post_msg`, `vmbus_connect`, `hv_vmbus_probe` (via
`vmbus_connect`)

### Step 5.2: Callers
**Record:**
- `vmbus_negotiate_version` ← `vmbus_connect()` (boot probe path),
  `vmbus_drv.c` resume path
- `vmbus_connect()` ← `hv_vmbus_probe()` at line 1491 in `vmbus_drv.c`
- `vmbus_post_msg` ← `vmbus_try_connection_id` and many channel-
  management paths

### Step 5.3: Callees
**Record:** `hv_post_message()`, `wait_for_completion()`, spinlock/list
management in negotiation path.

### Step 5.4: Reachability
**Record:** Triggered at every Hyper-V guest boot with
`CONFIG_HYPERV_VMBUS=y` when running at VTL2 with VMBus protocol 5.0+ on
a host using redirect connection ID. Not userspace-triggerable directly,
but affects all paravirtual I/O (storage, network, etc.) on affected
VMs.

### Step 5.5: Similar patterns
**Record:** Version negotiation already iterates protocol versions on
failure (`vmbus_connect` loop at lines 283–298). This adds connection-ID
probing within a single version attempt — consistent with existing retry
philosophy.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **Yes.** `drivers/hv/connection.c` lines 99–102 hardcode
`VMBUS_MESSAGE_CONNECTION_ID_4`. `ms_hyperv.vtl` field exists. VTL2
support exists (`hv_vtl.c`, `CONFIG_HYPERV_VTL_MODE`).
`VMBUS_MESSAGE_CONNECTION_ID_REDIRECT` is **not** present (fix not yet
applied).

### Step 6.2: Backport complications
**Record:** **Clean apply verified** — `git apply --check
/tmp/vtl2.patch` succeeds on this tree. Minor context difference from
mainline (e.g., `max_version = VERSION_WIN10_V5_3` vs mainline's `V6_0`)
does not affect the changed hunks.

### Step 6.3: Related fixes already present?
**Record:** None found for VTL2 redirect connection ID.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem and criticality
**Record:** **Subsystem:** `drivers/hv` (Hyper-V VMBus).
**Criticality:** IMPORTANT for Hyper-V guests; boot-critical for VTL2
deployments relying on VMBus paravirtual devices.

### Step 7.2: Activity
**Record:** Actively maintained — recent VMBus 6.0, SynIC, mshv commits
in this tree.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Hyper-V guests running Linux at **VTL2**
(`CONFIG_HYPERV_VTL_MODE`) with **VMBus protocol ≥ 5.0** on hosts with
VMBus redirection enabled. Narrow but real population (confidential
computing / VSM scenarios explicitly supported in Kconfig).

### Step 8.2: Trigger conditions
**Record:** Every boot/resume VMBus negotiation on matching config. Not
timing-dependent. Not triggerable by unprivileged users, but affects
entire VM I/O stack.

### Step 8.3: Failure severity
**Record:** Complete VMBus connection failure → no synthetic devices
(disk, net, etc.) → effectively unusable VM on VTL2 with redirection.
**Severity: CRITICAL** for affected configuration; **no impact** on
standard VTL0 guests.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for VTL2+VMBus-5.0+redirect deployments; enables
  boot and device functionality
- **Risk:** VERY LOW — gated on `vtl == 2`, fallback preserves existing
  path, ~30 lines, multiple maintainer reviews
- **Ratio:** Favorable for this tree, which explicitly supports VTL2

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real VMBus boot failure on supported VTL2 configuration
- Critical functional impact when triggered (no paravirtual devices)
- Small, surgical, well-reviewed by Hyper-V maintainers
- All prerequisites present in 6.18.44
- Applies cleanly
- Behavior unchanged for standard VTL0 Hyper-V guests
- Platform workaround pattern (endpoint probing with fallback)

**AGAINST backport:**
- Very niche deployment (VTL2 + VMBus 5.0 + redirection)
- No syzbot/user bug report tags
- Could be viewed as completing support for a config that never worked,
  rather than fixing a regression
- No explicit stable@ nomination

**Unresolved:** No end-user crash reports; impact inferred from protocol
requirements and maintainer review.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   reviewed by 4 Microsoft engineers + maintainer applied
2. Fixes real bug affecting users? **PASS** — VMBus fails on
   VTL2+redirect hosts
3. Important issue? **PASS** — complete loss of VMBus connectivity
   (CRITICAL for affected VMs)
4. Small and contained? **PASS** — 2 files, ~30 net lines
5. No new features/APIs? **PASS** — no userspace-visible changes;
   internal connection-ID selection only
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception categories
**Record:** Hardware/platform workaround — analogous to quirks for
specific Hyper-V VTL2 host configurations.

### Step 9.4: Decision rationale

This tree (`6.18.y`) explicitly supports VTL2 via
`CONFIG_HYPERV_VTL_MODE` and already negotiates VMBus protocol 5.0+
using `ms_hyperv.vtl`. Without this fix, VMBus negotiation fails on
hosts that require the redirect connection ID — a complete loss of
paravirtual device functionality for those VMs. The fix is minimal,
gated, has safe fallback, applies cleanly, and was reviewed by the
Hyper-V maintainer team. While the affected population is narrow, the
failure mode is severe and the tree already claims VTL2 support.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  patchew thread
- [Phase 1] Confirmed no Fixes:/Reported-by:/Cc: stable tags
- [Phase 1] Confirmed Wei Liu "Applied" on patchew (Jul 28, 2026)
- [Phase 2] Diff analysis: 2 files, `vmbus_try_connection_id` refactor +
  `-ENXIO` fallback
- [Phase 3] `git describe HEAD`: v6.18.44-2-g1b9e1abadee04; `make
  kernelversion`: 6.18.44
- [Phase 3] `git blame -L 99,106 drivers/hv/connection.c`: hardcoded
  ID_4 at merge base
- [Phase 3] Prerequisites verified: `ms_hyperv.vtl` in mshyperv.h,
  `get_vtl()` in hv_init.c, `hv_vtl.c` present
- [Phase 4] Mailing list: https://lists.openwall.net/linux-
  kernel/2026/07/17/12 (v2)
- [Phase 4] Michael Kelley review feedback on v1:
  https://lists.openwall.net/linux-kernel/2026/07/16/2295
- [Phase 4] Patchew thread: 4 Reviewed-by, Wei Liu applied; no stable
  nomination
- [Phase 4] b4 dig on commit hash: not performed (commit not in local
  tree); mbox extracted from patchew
- [Phase 5] `vmbus_connect()` → `vmbus_negotiate_version()` call chain
  verified in connection.c
- [Phase 5] `hv_vmbus_probe()` calls `vmbus_connect()` at
  vmbus_drv.c:1491
- [Phase 6] Buggy code confirmed at connection.c:102
  (`VMBUS_MESSAGE_CONNECTION_ID_4`)
- [Phase 6] `VMBUS_MESSAGE_CONNECTION_ID_REDIRECT` absent from
  hyperv_vmbus.h
- [Phase 6] `git apply --check /tmp/vtl2.patch`: **clean apply**
- [Phase 6] `CONFIG_HYPERV_VTL_MODE` documents VTL2 support in
  drivers/hv/Kconfig
- [Phase 8] Failure mode: vmbus_connect cleanup prints "Unable to
  connect to host" (connection.c:324)
- [Phase 8] `-ENXIO` vs `-EINVAL` on failed negotiation: both cause
  version loop to continue (only `-ETIMEDOUT` aborts)

**YES**The background searches on `all-next` and other large branches
timed out — those repos are huge and `git log -S` over them is slow.
That didn’t block the analysis; the patch context came from
patchew/openwall, and `git apply --check` on the extracted v2 patch
confirmed it applies cleanly to your **6.18.44** tree.

**Verdict remains YES** for backport: this fixes VMBus boot failure on
VTL2 guests (protocol 5.0+) when the host expects the redirect
connection ID `0x800074`, and the fix is small, gated on `ms_hyperv.vtl
== 2`, and all prerequisites are already in 6.18.y.

 drivers/hv/connection.c   | 47 +++++++++++++++++++++++----------------
 drivers/hv/hyperv_vmbus.h |  2 ++
 2 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 1fe3573ae52a4..9be2af772867d 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -71,7 +71,8 @@ module_param(max_version, uint, S_IRUGO);
 MODULE_PARM_DESC(max_version,
 		 "Maximal VMBus protocol version which can be negotiated");
 
-int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
+static int vmbus_try_connection_id(struct vmbus_channel_msginfo *msginfo,
+				   u32 version, u32 connection_id)
 {
 	int ret = 0;
 	struct vmbus_channel_initiate_contact *msg;
@@ -86,20 +87,20 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 	msg->vmbus_version_requested = version;
 
 	/*
-	 * VMBus protocol 5.0 (VERSION_WIN10_V5) and higher require that we must
-	 * use VMBUS_MESSAGE_CONNECTION_ID_4 for the Initiate Contact Message,
-	 * and for subsequent messages, we must use the Message Connection ID
-	 * field in the host-returned Version Response Message. And, with
-	 * VERSION_WIN10_V5 and higher, we don't use msg->interrupt_page, but we
-	 * tell the host explicitly that we still use VMBUS_MESSAGE_SINT(2) for
-	 * compatibility.
+	 * For VMBus protocol 5.0 (VERSION_WIN10_V5) and higher, use the
+	 * caller-supplied connection_id for the Initiate Contact message so
+	 * the caller can implement the required retry scheme. For subsequent
+	 * messages, use the Message Connection ID field in the host-returned
+	 * Version Response message. With VERSION_WIN10_V5 and higher, we don't
+	 * use msg->interrupt_page, but tell the host explicitly that we still
+	 * use VMBUS_MESSAGE_SINT(2) for compatibility.
 	 *
 	 * On old hosts, we should always use VMBUS_MESSAGE_CONNECTION_ID (1).
 	 */
 	if (version >= VERSION_WIN10_V5) {
 		msg->msg_sint = VMBUS_MESSAGE_SINT;
 		msg->msg_vtl = ms_hyperv.vtl;
-		vmbus_connection.msg_conn_id = VMBUS_MESSAGE_CONNECTION_ID_4;
+		vmbus_connection.msg_conn_id = connection_id;
 	} else {
 		msg->interrupt_page = virt_to_phys(vmbus_connection.int_page);
 		vmbus_connection.msg_conn_id = VMBUS_MESSAGE_CONNECTION_ID;
@@ -161,6 +162,22 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 	return ret;
 }
 
+int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
+{
+	int ret;
+
+	/* Try the redirect ID first for VTL2 with VMBus protocol 5.0+. */
+	if (version >= VERSION_WIN10_V5 && ms_hyperv.vtl == 2) {
+		ret = vmbus_try_connection_id(msginfo, version,
+					      VMBUS_MESSAGE_CONNECTION_ID_REDIRECT);
+		if (ret != -ENXIO)
+			return ret;
+	}
+
+	return vmbus_try_connection_id(msginfo, version,
+				       VMBUS_MESSAGE_CONNECTION_ID_4);
+}
+
 /*
  * vmbus_connect - Sends a connect request on the partition service connection
  */
@@ -454,18 +471,10 @@ int vmbus_post_msg(void *buffer, size_t buflen, bool can_sleep)
 
 		switch (ret) {
 		case HV_STATUS_INVALID_CONNECTION_ID:
-			/*
-			 * See vmbus_negotiate_version(): VMBus protocol 5.0
-			 * and higher require that we must use
-			 * VMBUS_MESSAGE_CONNECTION_ID_4 for the Initiate
-			 * Contact message, but on old hosts that only
-			 * support VMBus protocol 4.0 or lower, here we get
-			 * HV_STATUS_INVALID_CONNECTION_ID and we should
-			 * return an error immediately without retrying.
-			 */
+			/* Allow INITIATE_CONTACT to try another connection ID. */
 			hdr = buffer;
 			if (hdr->msgtype == CHANNELMSG_INITIATE_CONTACT)
-				return -EINVAL;
+				return -ENXIO;
 			/*
 			 * We could get this if we send messages too
 			 * frequently.
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 39cdded062e8b..f16395ba5d823 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -108,6 +108,8 @@ struct hv_input_post_message {
 enum {
 	VMBUS_MESSAGE_CONNECTION_ID	= 1,
 	VMBUS_MESSAGE_CONNECTION_ID_4	= 4,
+	/* VTL2 redirect connection ID for INITIATE_CONTACT. */
+	VMBUS_MESSAGE_CONNECTION_ID_REDIRECT = 0x800074,
 	VMBUS_MESSAGE_PORT_ID		= 1,
 	VMBUS_EVENT_CONNECTION_ID	= 2,
 	VMBUS_EVENT_PORT_ID		= 2,
-- 
2.53.0

