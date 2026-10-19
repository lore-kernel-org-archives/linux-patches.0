Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6835262E9;
	Mon, 19 Oct 2026 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418561; cv=none; b=Y8Q+gz1B1gxL7J8c2ulcgs68b0M6F4BjNBr+X0GIOpTrIfhNovmkApysPD12AU0VwNX/1/osodq8GrYhQ4al/FWxC62TOkgWfe2rlKnwzvu+2SqJJmS8U0r10LnsSM1qmvjIMviM6biyrUGmdxcQUQkxtXa9iP9lwi5ZeqsmKlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418561; c=relaxed/simple;
	bh=0D66UXv4UTor3rPU3ZWN1Uq4Igt0YJ+WNUVz0SePj3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rdDzEjeaxWBMrBGhD9istu0dxTt+/MThttB9f+Jlrq6crxnenivHTv37o67xKBtmBLS7zYrEUGsO5pJ6PwGpGjLJOBBT5B3ibUCCHHs6Ix9w2J1rT/YPw8QDmP61pQgbF60tm0sviYLeqxAKKcsWBhc8JHn/snYnAE6QX6y+M6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TPt0zEyP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TPt0zEyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C62D1F000C9;
	Mon, 19 Oct 2026 14:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418559;
	bh=Qx8ke/cX4j48s6qk9h51uWr5K7JchXPVSq0E6LqeBF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPt0zEyPl3IDE8IFZTsZ/T15/kGEbSWqS2xLXIHvpOmN66vav3NoeWpJAGxui2ruH
	 lqPTgXIXJCqYs8FH8pewN/1PBZImyWnUkzH6vAZEzwUPxkOTln41njA1c1prPLW05+
	 +tdERJp4QuZSfXD58gswDFGS/Vp/0agSmNrq2zw53GBtqM8az9jD3Ttm+NmRpiBz1w
	 aII/cGQGR4m6AXDOG4Jm88gUgtzJiJdSuUdfD3ufD5W8rXeAG3y1PSXK5GVEtaSQPM
	 2lyc3ORxP+IQynUUS4HanVgSQ6csvRLzg2iiiEXjwq+rMJoFv/feY57bL8fAB216gy
	 QAoFWbNZn0FSg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Muhammad Saheed <muhammad.saheed.iam@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] Bluetooth: hci_sync: Disable legacy instance's ext adv before setup snapshot
Date: Mon, 19 Oct 2026 09:50:25 -0400
Message-ID: <20261019135441.1420968-334-sashal@kernel.org>
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

From: Muhammad Saheed <muhammad.saheed.iam@gmail.com>

[ Upstream commit 75722cde87ee24029e93e4e32d85309989f55991 ]

hci_setup_ext_adv_instance_sync(...) only disabled
HCI_OP_LE_SET_EXT_ADV_ENABLE before setup snapshot in case of non-legacy
instances (instance > 0) and never disabled the same for legacy instance
(instance == 0). This would lead to failure in setting ext adv params
with HCI_ERROR_COMMAND_DISALLOWED (0x0c) error like below, when toggling
the discoverable/connectable property of a controller with advertising
enabled.
```
$ btmgmt advertising off
hci0 Set Advertising complete, settings: powered ssp br/edr le
  secure-conn wide-band-speech cis-central cis-peripheral
$ btmgmt connectable on
hci0 Set Connectable complete, settings: powered connectable ssp br/edr
  le secure-conn wide-band-speech cis-central cis-peripheral
$ btmgmt connectable off
hci0 Set Connectable complete, settings: powered ssp br/edr le
  secure-conn wide-band-speech cis-central cis-peripheral

$ btmgmt advertising on
hci0 Set Advertising complete, settings: powered connectable ssp br/edr
  le advertising secure-conn wide-band-speech cis-central cis-peripheral
$ btmgmt connectable on
Set Connectable for hci0 failed with status 0x0a (Busy)
$ btmgmt connectable off
Set Connectable for hci0 failed with status 0x0a (Busy)

$ dmesg
...
[   21.970527] hci0: Opcode 0x2036
[   21.970529] hci0: opcode 0x2036 plen 25
[   21.970537] hci0: skb len 28
[   21.970539] hci0: length 1
[   21.976099] hci0: result 0x0c
[   21.976105] hci0: end: err -16
[   21.976114] Bluetooth: hci0: Opcode 0x2036 failed: -16
```

Signed-off-by: Muhammad Saheed <muhammad.saheed.iam@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
I have the local-tree picture: 6.12.111 still has the `instance > 0`
hole, the prerequisites are already present, and the patch applies. The
rest of this is the full nine-phase write-up.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[Bluetooth / hci_sync] [Disable] legacy instance 0 extended
  advertising must be turned off before setup snapshot, matching the
  existing non-legacy path`

**Step 1.2: Tags**
- Record: No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`,
  `Acked-by:`, `Link:`, or `Cc: stable`. Signed-off-by: Muhammad Saheed
  (author), Luiz Augusto von Dentz (Bluetooth maintainer). Absence of
  `Fixes`/`Cc: stable` is expected for this review pipeline and is not a
  negative signal.

**Step 1.3: Body**
- Record: [Bug] `hci_setup_ext_adv_instance_sync()` only calls
  `HCI_OP_LE_SET_EXT_ADV_ENABLE` disable for `instance > 0`. Legacy
  instance 0 stays enabled, so `HCI_OP_LE_SET_EXT_ADV_PARAMS` (opcode
  0x2036) is rejected with `HCI_ERROR_COMMAND_DISALLOWED` (0x0c).
- [Symptom] `btmgmt connectable on/off` while advertising is enabled
  fails with MGMT Busy (0x0a). dmesg: `Opcode 0x2036 failed: -16`.
- [Version] none stated.
- [Root cause] the disable-before-snapshot comment already describes the
  HCI rule; instance 0 was left out because
  `hci_disable_ext_adv_instance_sync(hdev, 0)` means “disable all sets”
  (`num_of_sets = !!instance`).

**Step 1.4: Hidden bug fix?**
- Record: Not disguised. This is an explicit correctness fix for a
  documented HCI restriction.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record: One file, `net/bluetooth/hci_sync.c`, +30/−0. New helper
  `hci_disable_ext_adv_legacy_instance_sync()`. Call added in
  `hci_setup_ext_adv_instance_sync()` `instance == 0` branch.
  Classification: single-file surgical fix.

**Step 2.2: Code flow**
- Before: `instance > 0` disables that set, then snapshots under lock.
  `instance == 0` only sets `adv = NULL` and proceeds to
  `hci_set_ext_adv_params_sync()`.
- After: instance 0 first sends `LE_SET_EXT_ADV_ENABLE` disable for
  handle 0x00 if `HCI_LE_ADV_0` is set; otherwise no-op. Then the
  existing param-update path runs.
- Path: normal MGMT connectable/discoverable/advertising
  reconfiguration, not an error-only path.

**Step 2.3: Bug mechanism**
- Record: [Logic / HCI command-order] Spec forbids updating parameters
  of an active extended advertising set. Non-legacy sets were already
  disabled. Legacy set 0 was not. Cannot reuse
  `hci_disable_ext_adv_instance_sync(hdev, 0)` because that function
  treats 0 as “all sets” (`cp->num_of_sets = !!instance`). New helper
  sends `num_of_sets=1`, `enable=0`, `handle=0x00`, gated on
  `HCI_LE_ADV_0`.

**Step 2.4: Fix quality**
- Record: Obviously correct: mirrors the instance>0 path and the
  existing enable command layout. Minimal. Regression risk is low:
  disable is skipped unless instance 0 is actually enabled;
  `hci_start_ext_adv_sync()` re-enables after setup. Same “if
  disable/setup fails, advertising may stay off” behavior as the non-
  legacy path. No public API change.

## Phase 3: Git history

**Step 3.1: Blame**
- Record: Disable-before-snapshot intent is from `cba6b758711c`
  (“Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 2”,
  2021-10). Current `if (instance > 0)` / `else { adv = NULL; }` shape
  is from `95cdcd8c82a50` (“Bluetooth: hci_sync: Fix advertising data
  UAFs”, Chengfeng Ye, already in this tree). `HCI_LE_ADV_0` is from
  `3a9dfe641913b` (stable backport of `0d92808024b4e`, 2025-10-01), also
  in this tree.

**Step 3.2: Fixes tag**
- Record: None. Bug is the incomplete original disable logic from
  `cba6b758711c`, which is in this tree. The correct instance-0 disable
  needs `HCI_LE_ADV_0`, which is also here.

**Step 3.3: File history**
- Record: Recent `hci_sync.c` work is UAF/locking (`95cdcd8c82a50`),
  advertising instance free on failure, accept-list UAF. No conflicting
  rewrite of this setup snapshot. Standalone patch, not `X/Y`.

**Step 3.4: Author**
- Record: Muhammad Saheed has this one Bluetooth commit on
  origin/master. Applied by subsystem maintainer Luiz Augusto von Dentz.

**Step 3.5: Prerequisites**
- Record: Needs `HCI_LE_ADV_0` (present: `3a9dfe641913b`) and the post-
  UAF `if (instance > 0) ... else { adv = NULL; }` shape (present:
  `95cdcd8c82a50`). `git apply --check` of `75722cde87ee2` succeeded
  (hunks at +21 lines). No later origin/master commit touches
  `hci_disable_ext_adv_legacy_instance_sync`. Standalone.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record: `b4 dig -c 75722cde87ee2` → https://patch.msgid.link/202608042
  01051.484885-1-muhammad.saheed.iam@gmail.com. Single v1, no later
  revision. Thread (gnuweeb lore, lore.kernel.org 403): submission,
  BlueZ CI bot, patchwork “applied to bluetooth-next by Luiz”. No NAK,
  no reviewer-requested changes.

**Step 4.2: Recipients (`b4 dig -w`)**
- Record: linux-bluetooth@vger.kernel.org, Luiz von Dentz, Marcel
  Holtmann. Right maintainers/list.

**Step 4.3: Bug report**
- Record: No external bugzilla/syzbot. Author included a concrete
  `btmgmt` repro and dmesg. Opcode 0x2036 is
  `HCI_OP_LE_SET_EXT_ADV_PARAMS` in this tree. HCI 0x0c maps to `EBUSY`
  in `bt_to_errno()`; mgmt maps `-EBUSY` to `MGMT_STATUS_BUSY` (0x0a).
  Matches the reported userspace error.

**Step 4.4: Series**
- Record: Standalone v1. Not part of a multi-patch series.

**Step 4.5: Stable list**
- Record: gnuweeb `/stable/` search for this subject returned no
  dedicated discussion (only unrelated release noise). No recorded
  reason to exclude it.

**CI note:** BlueZ bot: CheckPatch/build PASS. `mgmt-tester` 494/501 (LL
Privacy unpair timeouts, Read Exp Feature); mesh send-cancel timeouts.
Failures are not advertising/connectable cases. Maintainer still applied
the patch (`2d4711f5ad1b` in bluetooth-next; `75722cde87ee2` on
origin/master).

## Phase 5: Semantic / impact surface

**Step 5.1: Functions**
- Record: Added `hci_disable_ext_adv_legacy_instance_sync()`. Modified
  `hci_setup_ext_adv_instance_sync()`.

**Step 5.2: Callers of setup**
- Record (verified in this tree):
  - `hci_start_ext_adv_sync()` → connectable update, set advertising,
    discoverable+limited privacy, re-enable adv, periodic adv start
  - `hci_powered_update_adv_sync()` with instance 0x00
  - `set_le_sync()` in `mgmt.c` with 0x00
  - `add_ext_adv_params_sync()` uses `cp->instance` (MGMT rejects
    instance < 1, so not the legacy path)

**Step 5.3: Callees**
- Record: `__hci_cmd_sync_status(HCI_OP_LE_SET_EXT_ADV_ENABLE, ...)`.
  Same command the existing disable helper uses.

**Step 5.4: Reachability**
- Record: Userspace MGMT (`btmgmt`/`bluetoothctl` Set Connectable / Set
  Discoverable / Set Advertising). `hci_update_connectable_sync()` calls
  `hci_start_ext_adv_sync(hdev, hdev->cur_adv_instance)` when
  `HCI_ADVERTISING` is set; `set_adv_sync()` sets `cur_adv_instance =
  0x00`. Repro path is real and unprivileged for a local Bluetooth admin
  (typically root/netdev).

**Step 5.5: Similar patterns**
- Record: Instance > 0 already disabled before snapshot.
  `hci_disable_ext_adv_instance_sync()` cannot target only handle 0.
  `HCI_LE_ADV_0` was added specifically because instance 0 is not in
  `adv_instances`. This commit fills that remaining hole.

## Phase 6: Local tree (6.12.111, branch `pending-6.12`)

**Step 6.1: Buggy code present?**
- Record: Yes. `net/bluetooth/hci_sync.c`
  `hci_setup_ext_adv_instance_sync()` lines 1387–1400 still skip disable
  for instance 0. Helper name is absent (`grep` found no
  `hci_disable_ext_adv_legacy_instance_sync`). `git merge-base --is-
  ancestor 75722cde87ee2 HEAD` is false. Introduced conceptually in 2021
  (`cba6b758711c`); instance-0 tracking needed for a correct fix landed
  in this tree as `3a9dfe641913b`.

**Step 6.2: Backport difficulty**
- Record: Clean apply (`git apply --check` succeeded). Context matches
  after Chengfeng UAF backport.

**Step 6.3: Related fixes already here?**
- Record: `HCI_LE_ADV_0` tracking is here. Chengfeng UAF restructure is
  here. No substitute that disables legacy instance 0 before param
  snapshot.

## Phase 7: Subsystem context

**Step 7.1:** Record: `net/bluetooth` HCI command-sync / LE extended
advertising. Criticality: IMPORTANT (common controllers, BlueZ MGMT),
not core mm/fs.

**Step 7.2:** Record: Actively maintained; Luiz is the Bluetooth HCI
maintainer and applied this. Advertising instance 0 is the legacy “Set
Advertising” path used by typical desktop/embedded BlueZ setups.

## Phase 8: Impact and risk

**Step 8.1:** Record: Users of Bluetooth 5+ controllers
(`ext_adv_capable`) who enable LE advertising and then change
connectable/discoverable. Very common on modern hardware.

**Step 8.2:** Record: Trigger is ordinary `btmgmt connectable on/off`
(or equivalent bluetoothctl/DBus) while advertising is on. Not a rare
race. Local mgmt socket; not a remote unprivileged network attack.

**Step 8.3:** Record: Failure mode is HCI Command Disallowed → kernel
`-EBUSY` → MGMT Busy. Advertising parameters are not updated;
connectable/discoverable toggle fails. Not a panic/UAF. Severity: HIGH
for Bluetooth management (core LE advertising reconfiguration is
broken), MEDIUM overall versus crash/corruption.

**Step 8.4:** Record: Benefit high for 6.12 users with BT5 controllers.
Risk low: 30 lines, flag-gated, same command as existing helper, applies
cleanly, no API/data-structure change.

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Real, reproduced user-visible bug with matching opcode/status mapping
  in this tree
- Completes an already-documented disable-before-update rule that
  already exists for instance > 0
- Small, surgical, obviously correct
- Prerequisites (`HCI_LE_ADV_0`, setup-function shape) already in
  6.12.111
- Applies cleanly
- Maintainer-applied; v1 only; no NAK
- Common mgmt path, not staging/experimental

AGAINST:
- Not a crash, UAF, leak, or CVE
- Workaround: turn advertising off, change connectable, turn it back on
- First-time author (mitigated by maintainer SOB)
- BlueZ CI had unrelated tester timeouts

UNRESOLVED:
- lore.kernel.org HTTP 403; thread read via b4 + gnuweeb instead
- No dedicated stable-list thread

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — mirrors existing disable
   path; author repro; kernel + mgmt-tester build; maintainer applied
2. Real bug affecting users? **PASS** — connectable toggle fails while
   advertising
3. Important? **PASS** — breaks LE advertising reconfiguration on ext-
   adv hardware (Busy, not oops, but a serious functional failure of a
   common mgmt operation)
4. Small and contained? **PASS** — +30 lines, one file
5. No new features/APIs? **PASS** — HCI command already used; no new
   userspace API
6. Applies to this tree? **PASS** — verified `git apply --check`

**Step 9.3: Exceptions**
- Record: Not a device-ID/quirk/DT/build/docs exception. Qualifies as a
  contained functional HCI bug fix.

**Step 9.4: Decision**
This 6.12 tree still has the instance-0 hole. The helper it needs can
use `HCI_LE_ADV_0`, which is already backported. The patch is small,
applies, and restores a management operation that fails on typical
Bluetooth 5 controllers. That is enough for this tree.

---

### What the commit solves, and why it matters here

On 6.12.111, enabling LE advertising (legacy instance 0) and then
changing connectable/discoverable issues `LE Set Extended Advertising
Parameters` while that set is still enabled. Controllers reject it
(`0x0c` → `-EBUSY` → MGMT Busy). Non-legacy instances were already
disabled first; instance 0 was not, because the generic disable helper
treats 0 as “all sets.” This commit disables only handle 0x00 when
`HCI_LE_ADV_0` is set, then continues the existing snapshot/update/re-
enable flow.

### Risk vs benefit

Benefit: restores a common BlueZ management operation on ext-adv
hardware. Risk: low; disable is conditional, command layout matches the
existing helper, and `hci_start_ext_adv_sync()` re-enables afterward. No
follow-up fix exists on origin/master.

### Concerns

None that block backport on this tree. Prerequisites are present. Apply
is clean. Not a crash, but the failure is user-visible and easy to hit.

### Verification
- [Phase 1] Parsed subject/body/tags from `git log -1 --format=fuller
  75722cde87ee2`; no Fixes/Cc/Reported-by
- [Phase 2] Diff: +30 in `hci_sync.c`; helper + 4-line call in
  instance==0 branch
- [Phase 2] Confirmed `hci_disable_ext_adv_instance_sync()` uses
  `cp->num_of_sets = !!instance` so instance 0 disables all sets
- [Phase 2] Confirmed opcode 0x2036 is `HCI_OP_LE_SET_EXT_ADV_PARAMS`;
  `bt_to_errno(0x0c)=EBUSY`; mgmt `-EBUSY` → Busy 0x0a
- [Phase 3] `git describe HEAD` / `make kernelversion`: pending-6.12,
  6.12.111
- [Phase 3] `git merge-base --is-ancestor 75722cde87ee2 HEAD`: not in
  tree
- [Phase 3] blame: disable comment from `cba6b758711c`; `if (instance >
  0)` from `95cdcd8c82a50`; `HCI_LE_ADV_0` from `3a9dfe641913b`
- [Phase 3] `git merge-base --is-ancestor 3a9dfe641913b HEAD`: yes;
  `95cdcd8c82a50` in HEAD: yes
- [Phase 3] `git apply --check` of 75722cde87ee2: success
- [Phase 3] `git log origin/master -S
  hci_disable_ext_adv_legacy_instance_sync -- net/bluetooth/hci_sync.c`:
  only this commit
- [Phase 4] `b4 dig -c 75722cde87ee2` / `-a` / `-w`: v1 only; Luiz +
  linux-bluetooth; lore msgid as above
- [Phase 4] gnuweeb thread: CI bot + patchwork applied; no NAK
- [Phase 4] lore.kernel.org WebFetch: 403 (used b4/gnuweeb)
- [Phase 5] Callers traced in `hci_sync.c` / `mgmt.c`; connectable path
  uses `cur_adv_instance` (0 after Set Advertising)
- [Phase 6] Local setup function still skips disable for instance 0
- [Phase 8] Failure: MGMT Busy, not oops; severity HIGH for BT mgmt,
  MEDIUM vs crash class
- UNVERIFIED: Could not fetch lore.kernel.org HTML directly (403)

**YES**

 net/bluetooth/hci_sync.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 70fce6811d0a9..8da58c61e9723 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1184,6 +1184,32 @@ int hci_update_random_address_sync(struct hci_dev *hdev, bool require_privacy,
 	return 0;
 }
 
+static int hci_disable_ext_adv_legacy_instance_sync(struct hci_dev *hdev)
+{
+	struct hci_cp_le_set_ext_adv_enable *cp;
+	struct hci_cp_ext_adv_set *set;
+	u8 data[sizeof(*cp) + sizeof(*set) * 1];
+	u8 size;
+
+	if (!hci_dev_test_flag(hdev, HCI_LE_ADV_0))
+		return 0;
+
+	memset(data, 0, sizeof(data));
+
+	cp = (void *)data;
+	set = (void *)cp->data;
+
+	cp->num_of_sets = 0x01;
+	cp->enable = 0x00;
+
+	set->handle = 0x00;
+
+	size = sizeof(*cp) + sizeof(*set) * cp->num_of_sets;
+
+	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_EXT_ADV_ENABLE,
+				     size, data, HCI_CMD_TIMEOUT);
+}
+
 static int hci_disable_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 {
 	struct hci_cp_le_set_ext_adv_enable *cp;
@@ -1409,6 +1435,10 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 			return -EINVAL;
 		}
 	} else {
+		err = hci_disable_ext_adv_legacy_instance_sync(hdev);
+		if (err)
+			return err;
+
 		adv = NULL;
 	}
 
-- 
2.53.0

