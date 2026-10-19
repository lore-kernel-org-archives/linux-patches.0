Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B939555E45C;
	Mon, 19 Oct 2026 13:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418243; cv=none; b=C+EprV2881Fs2XsNBqxJq8LKhNUh+9p5NdM3jdufnmgTyo2HbgVwnTwYicue6RUDYooMlMwdIq6+SO6iwctp0u+5r1YMCi7iGNIs8pYCEmJlqC2rPjYSteVggQ4qyaMVromvMFjNWENRfkt5Qxt9UU2EiWkELadPxW7ixzxf36s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418243; c=relaxed/simple;
	bh=LGNognZZSPk5KxXtYXwvKz/Sv6yIv8jF7CMptWLrPHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MNbbp5oXxf9TGnz2Q2Lc8lphl9nYO/oWLISYeHseRtrCCBmAIMK7sQpMr8hMKbSXsyv+Vf5Nft5/MbpIdhmsF+AGyUDCU9xVaGmKWMtxIWPZhD6yNmjhupMUl0Zo9BZSHSO2x6Qn521PPEq7tJ0m+tyCqaOT1cgDfHseYb8Abx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F3ULxGUZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F3ULxGUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2531F000C7;
	Mon, 19 Oct 2026 13:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418240;
	bh=xQwHrwplptV7+b5NgWL9BkfxeUoS4UgcnIR4cVBDzdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3ULxGUZD7Tok/Ty8AujFedYtqZn9aO/FKQSw/gHBRaaU2Ga2FiaE36szDy0G3TM9
	 PWtw4/9Si85KoYTdRfJ14VWwfnkLTU3MvJuFHw524MyRwSceg2WbxfdxskSfO3PJ1H
	 wnf8GkD8KpzhjTUlA83KBnF8UDNtJ9CpfGSG41TLBbfI9tH1N2xLRW7n25niXzoe6p
	 5zpI6Z3FZERNK2LYgX55QKzvyvNuM1rMBt7nlzTeVnu9TO2pfgMeOeVKiO3lpr79Pj
	 zgSE+VcxyRVm/7m/4A5BBC56ClFL+9VgjuTeUws5UO0itAItoc4iiqxTXlJchJQk3v
	 MF4/q8kZk5DJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>,
	syzbot+9db6c624635564ad813c@syzkaller.appspotmail.com,
	Petko Manolov <petkan@nucleusys.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: usb: rtl8150: handle link status read failures
Date: Mon, 19 Oct 2026 09:46:43 -0400
Message-ID: <20261019135441.1420968-112-sashal@kernel.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 8c9c5b9a689612dcb92a04a4218c975cd19f19d8 ]

set_carrier() ignores the result of the USB control transfer and tests
the stack variable supplied as its receive buffer. If the device rejects
or aborts the request, that variable remains uninitialized and the driver
chooses an arbitrary carrier state.

Leave the existing carrier state unchanged when the link status cannot be
read. A transient USB error should not be treated as link loss.

Reported-by: syzbot+9db6c624635564ad813c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9db6c624635564ad813c
Suggested-by: Petko Manolov <petkan@nucleusys.com>
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260630101216.10365-1-alhouseenyousef@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[net: usb: rtl8150] [handle] ignore USB register-read errors in
set_carrier() so an uninitialized stack value is not used as link
status`

**Step 1.2 — Tags**
Record:
- `Reported-by: syzbot+9db6c624635564ad813c@syzkaller.appspotmail.com`
  (KMSAN, reproducible)
- `Closes: https://syzkaller.appspot.com/bug?extid=9db6c624635564ad813c`
- `Suggested-by: Petko Manolov <petkan@nucleusys.com>` (original rtl8150
  author)
- `Reviewed-by: Andrew Lunn <andrew@lunn.ch>`
- `Link: https://patch.msgid.link/20260630101216.10365-1-
  alhouseenyousef@gmail.com`
- `Signed-off-by: Yousef Alhouseen` (author), `Paolo Abeni` (netdev)
- No `Fixes:` on the committed form (dropped in v4 at reviewer request;
  v1/v2 had `Fixes: 1da177e4c3f4` and `Cc: stable`)
- Sasha Levin SOB ignored as pipeline noise

**Step 1.3 — Body**
Record: `set_carrier()` ignores `get_registers()` and then tests stack
`tmp`. On USB reject/abort, `tmp` is uninitialized, so carrier is chosen
from garbage. Failure mode: arbitrary `netif_carrier_on/off`. Fix: keep
the current carrier if the CSCR read fails. No version range given.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. This is an explicit uninitialized-use / ignored-
error fix, confirmed by KMSAN.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record: one file, `drivers/net/usb/rtl8150.c`; `set_carrier()` only; +3
/ −1; surgical single-function change.

**Step 2.2 — Flow**
Record: Before: always `get_registers(dev, CSCR, 2, &tmp)` then `tmp &
CSCR_LINK_STATUS` → carrier on/off. After: non-zero return from
`get_registers()` returns immediately; carrier is unchanged. Path:
`rtl8150_open()` (interface up).

**Step 2.3 — Bug mechanism**
Record: **uninitialized data** (KMSAN). `usb_control_msg_recv()` only
`memcpy`s into the caller buffer on a full successful transfer
(`drivers/usb/core/message.c`); on error it returns negative and leaves
`tmp` untouched. `short tmp` is uninitialized, then used as a bit test.

**Step 2.4 — Fix quality**
Record: Obviously correct. Three lines. No API/lock/refcount change.
Regression risk is low: a failed CSCR read no longer flips carrier. That
matches the original author’s review (transient USB errors should not
look like link loss).

## Phase 3: Git history

**Step 3.1 — Blame**
Record: Unchecked `get_registers()` + `tmp & CSCR_LINK_STATUS` dates to
`1da177e4c3f4` (Linux 2.6.12-rc2, 2005). The uninit became hard after
`b2a0f274e3f7e` (“Use the new usb control message API”, in `v5.10-rc1`):
`usb_control_msg_recv()` does not fill the buffer on failure.

**Step 3.2 — Fixes tag**
Record: Committed patch has no `Fixes:`. v1/v2 used `Fixes:
1da177e4c3f4`. That SHA is in this tree. The USB API switch
`b2a0f274e3f7e` is also in this tree (`v5.10-rc1`).

**Step 3.3 — Related file history**
Record: Same driver already has `fba383985354e` (“fix unintiatilzed
variables in rtl8150_get_link_ksettings”), a sibling KMSAN
ignored-`get_registers()` fix, present in `v6.18.53`. Other recent
rtl8150 work is UAF/leak/padding, not a substitute for this carrier
check. Standalone, not patch X/Y.

**Step 3.4 — Author**
Record: Yousef Alhouseen; this is their only rtl8150 commit here.
Suggested-by Petko Manolov (driver author). Reviewed-by Andrew Lunn.

**Step 3.5 — Dependencies**
Record: None. Uses existing `get_registers()` return value. `git diff
v6.18.53 6a6d945b860b3^ -- drivers/net/usb/rtl8150.c` is empty —
preimage matches 6.18.y.

## Phase 4: Mailing list / external

**Step 4.1 — Discussion**
Record: `b4 dig` → https://patch.msgid.link/20260628165033.17842-1-
alhouseenyousef@gmail.com
Revisions: v1 (carrier-off on error) → v2 (return on error) → net-next
v4 (applied).
Petko: do not force carrier off; USB messages can be lost while the
device still works.
Andrew Lunn (v2): pointed at stable-kernel-rules, asked “Does this issue
bother people?”, asked for net-next, Suggested-by, and no version
threading.
v4 changelog: “Target net-next and drop the Fixes tag as requested.”
Andrew Reviewed-by v4. Applied to netdev/net-next as `8c9c5b9a6896`. No
NAK of the code.

**Step 4.2 — Recipients**
Record: Petko, Lunn, davem, Dumazet, Kicinski, Abeni, linux-usb, netdev,
syzbot. Right lists and maintainers.

**Step 4.3 — Bug report**
Record: syzbot “KMSAN: uninit-value in rtl8150_open (2)”, prio:high.
Stack: `set_carrier` ← `rtl8150_open` ← `__dev_open` ← ioctl (dhcpcd).
Local `tmp`. Console: `usb 2-1: device reset failed`. First crash ~186d
before the report page, last ~113d. Security workflow: PeripheralTrigger
yes; DoS/exploitable/unprivileged no. Five KMSAN crashes on dummy USB.

**Step 4.4 — Series**
Record: Single patch. Not part of a multi-patch series.

**Step 4.5 — Stable list**
Record: lore.kernel.org HTTP 403; no extra stable-list thread retrieved.
v1/v2 were Cc: stable; Andrew redirected to net-next. That is process,
not a technical NAK.

## Phase 5: Semantics / call graph

**Step 5.1**
Record: `set_carrier()` only.

**Step 5.2**
Record: Only caller is `rtl8150_open()` (`drivers/net/usb/rtl8150.c`).
Link is also updated later from `intr_callback()` via `MSR_LINK`
(independent path, 100 ms interrupt URB).

**Step 5.3**
Record: `get_registers()` → `usb_control_msg_recv()`; then
`netif_carrier_on` / `netif_carrier_off`.

**Step 5.4**
Record: Reachable from userspace bringing the iface up (`SIOCSIFFLAGS` /
`dev_change_flags` / `__dev_open`). Needs the USB device (or a gadget).
Typically `CAP_NET_ADMIN`. Syzbot hit it via dhcpcd on a dummy device.

**Step 5.5**
Record: Same ignored-return pattern exists elsewhere in this file
(`read_mii_word`, `rtl8150_reset`, `enable_net_traffic`,
`get_link_ksettings`). `get_link_ksettings` was already hardened by
initializing locals (`fba383985354e`). This commit only fixes
`set_carrier()`.

## Phase 6: This tree (6.18.y)

**Step 6.1**
Record: Local tree is **6.18.53** (`git describe HEAD` →
`v6.18.53-5049-g0f0bdc2b0dffb`, `VERSION=6 PATCHLEVEL=18 SUBLEVEL=53`).
`v6.18.53:drivers/net/usb/rtl8150.c` still has the unchecked
`get_registers(dev, CSCR, 2, &tmp)`. Bug is present. Introduced in
practice with `usb_control_msg_recv` in v5.10; the ignore-return pattern
is ancient.

**Step 6.2**
Record: Clean apply. Parent of the candidate matches `v6.18.53` for this
file (0-line diff).

**Step 6.3**
Record: No other commit in 6.18.y checks `set_carrier()`’s CSCR read.
`fba383985354e` is related but only ethtool ksettings.

## Phase 7: Subsystem

**Step 7.1**
Record: USB net driver `CONFIG_USB_RTL8150`. Criticality: **PERIPHERAL**
(legacy Realtek USB 10/100 dongle; not core mm/net). Still a supported
in-tree driver, not staging.

**Step mar 7.2**
Record: Low-churn mature driver. Occasional syzbot fixes. Stable-
relevant bugs do still land here.

## Phase 8: Impact / risk

**Step 8.1**
Record: Users of `CONFIG_USB_RTL8150` only, plus KMSAN/syzbot coverage.

**Step 8.2**
Record: Trigger: CSCR USB control read fails during `rtl8150_open()`
(device reset failure, disconnect, bus noise). Uncommon on working
hardware; easy with a dummy/failing USB device. Not a general
unprivileged attack path.

**Step 8.3**
Record: Production: wrong carrier (link up/down from stack garbage). Not
a panic/UAF. Under KMSAN: `BUG: KMSAN: uninit-value`. Interrupt path can
correct carrier within ~100 ms if the device still works. Severity:
**HIGH** as uninitialized memory (KMSAN); **MEDIUM** as user-visible
wrong link state on USB error.

**Step 8.4**
Record: Benefit: stops UB and random carrier on open failure; matches a
prior stable fix in the same file. Risk: very low (3 lines, error path
only, no locking). Ratio favors backport.

## Phase 9: Synthesis

**For backporting**
- Real ignored-error / uninitialized-stack bug, not cleanup.
- Syzbot + KMSAN, reproducible from iface open.
- Same class as `fba383985354e`, already in this 6.18.y tree.
- Three-line, reviewed, Suggested-by the driver author.
- Buggy code is in `v6.18.53`; applies cleanly; no prerequisites.
- Wrong carrier on `ifup` is user-visible if the control read fails.

**Against**
- Andrew Lunn asked whether it “bothers people” and sent it to net-next,
  not `net`.
- Not a production oops, deadlock, or security hole (syzbot: not
  exploitable/DoS).
- Legacy USB adapter; trigger is a failed control transfer.
- Interrupt callback often repairs carrier shortly after.

**Unresolved**
- Could not fetch lore.kernel.org/stable (HTTP 403). Discussion is taken
  from `b4` mboxes instead.

**Stable-rules checklist**
1. Obviously correct and tested? **PASS** — 3 lines, Reviewed-by Lunn,
   Suggested-by Petko, syzbot-confirmed.
2. Real bug affecting users? **PASS** — uninit `tmp` used for carrier;
   KMSAN + ioctl path.
3. Important (crash/security/corruption/deadlock)? **PASS** — KMSAN
   uninitialized use is a real memory-safety bug; production symptom is
   incorrect carrier, not a panic. Bar is met for sanitizer-class fixes
   this pipeline treats as backport-worthy.
4. Small and contained? **PASS** — one function, +3/−1.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS** — 6.18.y has the bug and matching
   preimage.

**Exception category:** none (not an ID/quirk/DT/build/doc exception).
It is a normal small bugfix.

The net-next routing only dropped tags for netdev process. It does not
remove the bug from 6.18.y. The patch is self-contained, applies
cleanly, and is the same error-check this driver already needed in
ethtool.

Verification:
- [Phase 1] Tags: syzbot Reported-by, Closes syzkaller URL, Suggested-by
  Petko, Reviewed-by Andrew Lunn, Paolo Abeni SOB.
- [Phase 2] Diff: `set_carrier()` adds `if (get_registers(...))
  return;`.
- [Phase 2] `usb_control_msg_recv()` in `drivers/usb/core/message.c`
  only copies into the caller buffer when `ret == size`; errors skip
  that copy.
- [Phase 3] Blame: logic since `1da177e4c3f4`; `usb_control_msg_recv`
  since `b2a0f274e3f7e` (`v5.10-rc1`).
- [Phase 3] `git diff v6.18.53 6a6d945b860b3^ --
  drivers/net/usb/rtl8150.c` is empty.
- [Phase 3] Sibling KMSAN fix `fba383985354e` is in `v6.18.53`.
- [Phase 4] `b4 dig -c 8c9c5b9a6896`: v1–v4; Petko requested leave-
  carrier-unchanged; Lunn asked for net-next; v4 applied to net-next.
- [Phase 4] Syzkaller: KMSAN uninit-value in `rtl8150_open`, prio:high,
  dhcpcd ioctl, `device reset failed`.
- [Phase 5] Only caller: `rtl8150_open`; `intr_callback` updates carrier
  separately.
- [Phase 6] `git describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`; `make
  kernelversion` = 6.18.53; buggy code present at `v6.18.53`.
- [Phase 6] `git merge-base --is-ancestor 6a6d945b860b3 v6.18.53` → not
  in the release tag (candidate only).
- [Phase 8] Failure: uninitialized stack → arbitrary carrier; KMSAN BUG
  under sanitizer.
- UNVERIFIED: lore.kernel.org WebFetch 403; stable@ archive not searched
  via HTTP.

**YES**

 drivers/net/usb/rtl8150.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 647f28b367b99..8c739d898e57d 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -734,7 +734,9 @@ static void set_carrier(struct net_device *netdev)
 	rtl8150_t *dev = netdev_priv(netdev);
 	short tmp;
 
-	get_registers(dev, CSCR, 2, &tmp);
+	if (get_registers(dev, CSCR, 2, &tmp))
+		return;
+
 	if (tmp & CSCR_LINK_STATUS)
 		netif_carrier_on(netdev);
 	else
-- 
2.53.0

