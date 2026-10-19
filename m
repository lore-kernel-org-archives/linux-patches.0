Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA000529F0F;
	Mon, 19 Oct 2026 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418159; cv=none; b=WcSJoWd26vP+PJlG3YkwSHNmn/JmooqqRwyFAmNu8l7ooL9o3Lde9iu4psJyiy+avAw1CZPjoi5WWov0Ju1H4fau7O66WCJln23SojkH0jmUAPccpIrd0Fp8xBH4RT1jBIDo7dTZlkcLKDLulHC7cHyo6mpVe3gQeBkbnWlgHs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418159; c=relaxed/simple;
	bh=+bRUtHvZLok4/qDcNOGWIevCDtz3J6G9jKBpah6S5cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r7N7RtsMvVrntBG1fHRK0vq94kz7IEBJ9REHptHta2/BPtpLR7YWZqUq7g8jp//3XDpXhEu77s2iV1MrFt1R1fMorrIOwEo3Swl1unldl4qbtifmzE0B4Fzxx9JByZV4xVgcceEHMWn8+wNDMf0WfRQohe0GZasMB5jl75N36e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GcR2yH+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcR2yH+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD671F000C6;
	Mon, 19 Oct 2026 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418156;
	bh=iJrArmgB5PQMc+ZEOh7FqKRAt7Hp6nhNZLZ4xibGT7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcR2yH+nkp0My9NbgoQtfGFYTuEG2zvDHdUCqsZ1VXkOYyV1fGTFL3kV2lx+eRv5D
	 LK0aAPrjd4swCoiDaRNVzbfc8TAGmYySYxbDl/erN3cThbWKYaLMkWdBsbn1Y7xx9X
	 CQa3BJeDVOWQceg49LljZ1vfdvot8FPMV396I1VcOj5z32I6uOp3wFVdZ3fzyB8dXc
	 0E1H+jqnQ97yNX1tCmOCm+qacKbqv6WUxwBbcsteMLwS6CBc2+cGKW7jas2qKWbB9r
	 aeHnBgQpaLZfMy/EZ2hDoEWp0k9kXMlsdDvfSQIaWrJgjhBPN463s9omDIoUBSGyfr
	 SdwJfVxXhI1Yw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Laxman Acharya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] Bluetooth: hci_event: fix out-of-bounds read in LE PA report reassembly
Date: Mon, 19 Oct 2026 09:45:43 -0400
Message-ID: <20261019135441.1420968-52-sashal@kernel.org>
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

From: Laxman Acharya <acharyalaxman8848@gmail.com>

[ Upstream commit e3643fbddb257c928c075cab05bbd929106b56ee ]

hci_le_per_adv_report_evt() is dispatched with a minimum length of
sizeof(struct hci_ev_le_per_adv_report), which only covers the fixed
part of the event and not the trailing data[] array:

	struct hci_ev_le_per_adv_report {
		__le16   sync_handle;
		__u8     tx_power;
		__u8     rssi;
		__u8     cte_type;
		__u8     data_status;
		__u8     length;
		__u8     data[];
	} __packed;

The handler notifies the ISO layer via hci_proto_connect_ind(), which
reaches iso_connect_ind(). That function retrieves the stored event with
hci_recv_event_data() and, while reassembling the periodic advertising
data, does:

	memcpy(hcon->le_per_adv_data + hcon->le_per_adv_data_offset,
	       ev->data, ev->length);

ev->length is taken directly from the event and is never validated
against the amount of data the event actually carries.  A controller
that reports a length larger than the received event therefore causes
the memcpy() to read past the end of the event buffer.  The leaked bytes
are stored in hcon->le_per_adv_data and can subsequently be read back
from user space via getsockopt(BT_ISO_BASE).

Validate that the event contains ev->length data bytes before it is
consumed, mirroring the check already performed by
hci_le_ext_adv_report_evt() and hci_le_adv_report_evt().

Signed-off-by: Laxman Acharya <acharyalaxman8848@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a 6.12.111 tree (`pending-6.12`). The PA-report handler is
present and still copies `ev->length` without checking the event buffer,
so the OOB read and `BT_ISO_BASE` leak exist here.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[Bluetooth/hci_event] [fix] [out-of-bounds read while
reassembling LE periodic advertising reports]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Laxman Acharya <acharyalaxman8848@gmail.com>` (author)
- `Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>`
  (Bluetooth maintainer applied it)
- No `Fixes:` tag (expected for this review)
- No `Cc: stable@vger.kernel.org` (expected)
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Link:`
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  ...]` markers

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `hci_le_per_adv_report_evt()` is dispatched with `min_len ==
  sizeof(struct hci_ev_le_per_adv_report)` (fixed header only).
  `iso_connect_ind()` later does `memcpy(..., ev->data, ev->length)`
  using the controller-supplied length with no check against remaining
  event bytes.
- Symptom: slab/skb out-of-bounds read; copied bytes land in
  `hcon->le_per_adv_data` and can be read from userspace via
  `getsockopt(BT_ISO_BASE)`.
- Failure mode: kernel info leak (and KASAN OOB read / possible oops).
- Root cause: HCI LE Periodic Advertising Report `length` is trusted;
  sibling handlers (`hci_le_adv_report_evt`,
  `hci_le_ext_adv_report_evt`) already validate trailing data with
  `hci_le_ev_skb_pull()`.
- Version info: none in the message. Local history puts the memcpy in
  v6.9-rc1 (`168d9bf9c7f01`), present in this 6.12 tree.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. Subject and body describe a real OOB
read plus userspace-visible leak. Explicit `fix`.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `net/bluetooth/hci_event.c` — about +7 / -0 (comment + 2
  executable lines)
- Function: `hci_le_per_adv_report_evt()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before: after the debug print, the handler takes `hci_dev_lock`
and calls `hci_proto_connect_ind()` → `iso_connect_ind()`, which copies
`ev->length` bytes from the stored event. After:
`hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_PER_ADV_REPORT, ev->length)`
must succeed first; on failure the event is dropped and logged as a
malformed LE event. Normal well-formed reports are unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: memory safety — buffer overflow / out-of-bounds **read**,
  with kernel heap contents later exposed to userspace.
- Mechanism: `ev->length` (`u8`) is not compared to remaining skb bytes.
  Destination is capped at `HCI_MAX_PER_AD_TOT_LEN` (1650) in `iso.c`,
  so this is a **source** OOB, not a dest write overflow. The pull is
  the same pattern as LE adv / ext-adv report handlers.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. `skb_pull_data()` returns NULL when `skb->len
< len`. The check runs before the lock and before
`hci_proto_connect_ind()`, so a short event never reaches the memcpy.
Regression risk is very low: only malformed events are dropped. No
API/data-structure change. `hci_le_ev_skb_pull` is used only for
validation here; `iso_connect_ind()` still reads `hdev->recv_event` (a
clone taken before parsing pulls).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Handler added in `9c0826310bfb7` (“Bluetooth: ISO: Add support for
  periodic adv reports processing”, 2023-08-24) — contained in v6.6-rc1,
  ancestor of HEAD.
- Unsafe memcpy added in `168d9bf9c7f01` (“Bluetooth: ISO: Reassemble PA
  data for bcast sink”, 2024-03-06) — contained in **v6.9-rc1**,
  ancestor of this 6.12 tree.
- Call already uses `PA_LINK` (`a8444cca514ed` is in this tree).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The memcpy that needs the check is
`168d9bf9c7f01`, present here (`git merge-base --is-ancestor`
succeeded).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same file already has length pulls for adv/ext-adv, BIG complete
(`22559ad7654f6`), etc. This is a standalone one-hunk fix, not patch
X/Y. No later local commit implements this check (`git grep
hci_le_ev_skb_pull.*PER_ADV` empty).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Laxman Acharya is a regular Bluetooth bounds-checking
contributor, not the maintainer. Same-tree examples: `a34df5c4a439c`
(CIG params response length) and `930be1f6ae581` (vendor codec count).
Maintainer Luiz applied this patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `hci_le_ev_skb_pull`, `HCI_EV_LE_PER_ADV_REPORT`,
`hci_le_per_adv_report_evt`, `iso_connect_ind` memcpy, and `PA_LINK`.
All exist in this checkout. Standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Message-ID: `20260805173701.6649-1-acharyalaxman8848@gmail.com`
- `b4 dig -c` not usable: candidate SHA is not in this checkout.
- `b4 mbox` on that msgid: 3-message thread, **v1 only**.
- Recipients: Luiz von Dentz, Marcel Holtmann, linux-bluetooth, linux-
  kernel.
- Applied to bluetooth-next as `96995a7d94f3` by Luiz (2026-08-07).
  Listed in Luiz’s netdev pull `for-net-next-2026-08-07`.
- No NAK, no reviewer risk comments, no extra revisions.
- BlueZ CI: CheckPatch/build/sparse PASS; **iso-tester PASS**; GitLint
  FAIL only for tabs in the quoted struct; mgmt/mesh failures are
  unrelated timeouts.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Sent To Bluetooth maintainers; Luiz applied it (Ack-by-apply).
No extra Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla `Reported-by`. Description matches the code
in this tree (`iso.c:2250-2251` memcpy; `iso_sock_getsockopt`
`BT_ISO_BASE`).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone `[PATCH]`, not a series. Same author also sent CIG
validation (already in this tree). No extra companion hunk required.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable returned 403. gnuweeb linux-bluetooth
index shows this patch (2 messages) with no stable-specific NAK. No
evidence it was rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

semcode MCP tools were not available; used `git grep` and file reads.

**Step 5.1: KEY FUNCTIONS**
Record: `hci_le_per_adv_report_evt` (modified); uses
`hci_le_ev_skb_pull`; downstream `hci_proto_connect_ind` →
`iso_connect_ind`.

**Step 5.2: TRACE CALLERS**
Record: Only the LE subevent table (`HCI_EV_LE_PER_ADV_REPORT` /
`HCI_LE_EV_VL`). Path: `hci_event_packet` → `hci_event_func` →
`hci_le_meta_evt` (pulls `min_len` = 7-byte header) → handler. HCI
events come from the controller (USB/UART/virtio) or a user-channel HCI
socket (`CAP_NET_ADMIN` / `CAP_NET_RAW` in `hci_sock.c`).

**Step 5.3: TRACE CALLEES**
Record: `hci_le_ev_skb_pull` → `skb_pull_data` (NULL if short). Then
lock, `hci_proto_connect_ind` → `iso_connect_ind` →
`hci_recv_event_data` (clone at `hci_event_packet`) → memcpy of
`ev3->data`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable on CONFIG_BT + CONFIG_BT_LE (iso.o, default y) when a
broadcast-sink ISO socket matches `sync_handle`. `iso_sock_create()` has
no extra cap check. The memcpy runs only if `iso_get_sock` finds that
listener. Userspace can then read `le_per_adv_data` via
`getsockopt(BT_ISO_BASE)` when connected with `dst == BDADDR_ANY`.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Trailing-data pulls already in `hci_le_adv_report_evt`,
`hci_le_ext_adv_report_evt`, `hci_le_create_big_complete_evt`. This
handler was the missing analog for PA reports.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `net/bluetooth/hci_event.c:6460-6497` has the handler
**without** the pull. `iso.c:2246-2251` has dest-size check only, then
memcpy of `ev3->length`. Struct FAM is in `include/net/bluetooth/hci.h`.
Introduced v6.9, present in 6.12.111.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: `git apply --check` of the candidate hunk **succeeded**.
Insertion site matches (after `bt_dev_dbg`, before `hci_dev_lock`).
Expected difficulty: **clean apply**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No. `git log --grep="out-of-bounds read in LE PA"` empty; no
`hci_le_ev_skb_pull(..., HCI_EV_LE_PER_ADV_REPORT, ev->length)`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: `net/bluetooth` HCI event parsing + ISO (LE Audio / periodic
advertising / broadcast sink). **IMPORTANT** — not mm/core, but default-
on `CONFIG_BT_LE` on phones, laptops, IoT.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Active; many recent HCI/ISO memory-safety fixes in this tree.
Pattern of trusting HCI length fields is a known class.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: Bluetooth LE users with ISO broadcast sink / PA sync (LE Audio /
Auracast-style). Config: `CONFIG_BT` + `CONFIG_BT_LE`. Driver- and
config-specific, not universal.

**Step 8.2: TRIGGER CONDITIONS**
Record: Malformed `HCI_EV_LE_PER_ADV_REPORT` (`length` larger than
remaining bytes) while a matching ISO listener exists. Sources:
buggy/malicious controller (including USB dongle), or privileged HCI
injection. Not every boot; realistic for HCI parsers. Unprivileged user
can hold the ISO socket; injecting the event usually needs
controller/firmware or `CAP_NET_ADMIN`/`CAP_NET_RAW`.

**Step 8.3: FAILURE MODE SEVERITY**
Record: Kernel OOB read of skb/slab tail; bytes stored and returned by
`getsockopt(BT_ISO_BASE)` → **info leak**. KASAN/hardened kernels can
oops. Severity: **HIGH** (memory safety + userspace-visible leak). Not a
guaranteed panic on every box, but not cosmetic.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- Benefit: high for BT LE Audio/ISO users — stops OOB read and leak.
- Risk: very low — 2 code lines, established helper, drops only invalid
  events.
- Ratio: strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB read of HCI event buffer; leak via `BT_ISO_BASE`.
- Buggy memcpy present in this 6.12 tree since v6.9.
- Small, obviously correct; same pull used by sibling handlers.
- Applies cleanly; all helpers/types present.
- Maintainer applied v1; iso-tester passed.
- No new feature/API.

AGAINST:
- Needs ISO broadcast-sink + PA report (not every Bluetooth device).
- No syzbot/`Fixes:`/`Cc: stable` (absence is expected).
- CI GitLint/mgmt/mesh noise is unrelated/cosmetic.

UNRESOLVED (do not drive the verdict):
- lore.kernel.org and git.kernel.org fetches blocked (403 / Anubis).
- `b4 dig -c` unused (SHA not in this repo); thread recovered via msgid.
- Mainline SHA after net-next merge not confirmed locally (bluetooth-
  next `96995a7d94f3` and the 2026-08-07 pull are enough).
- No stable@ thread found (search blocked).

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — pull-before-consume;
   maintainer applied; iso-tester PASS.
2. Real bug affecting users? **PASS** — OOB read + `getsockopt` leak on
   ISO PA reassembly.
3. Important (crash/security/corruption/deadlock)? **PASS** — HIGH
   memory-safety / info leak.
4. Small and contained? **PASS** — ~7 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to this tree? **PASS** — `git apply --check` clean; bug
   present.

**Step 9.3: EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary
security/correctness fix.

**Step 9.4: DECISION**
Backport. The bug is in this tree, the fix is surgical, and the user-
visible effect is a kernel info leak from a trusted-length HCI field.

---

### What this solves for 6.12 users

On 6.12.111, `hci_le_per_adv_report_evt()` still accepts a 7-byte header
and `iso_connect_ind()` copies `ev->length` bytes from the stored event.
A short HCI packet with a large `length` reads past the skb into
`hcon->le_per_adv_data`, which `getsockopt(BT_ISO_BASE)` can return. The
patch drops that event unless the skb actually contains `ev->length`
data bytes.

### Stable rules / risk vs benefit

Meets all six criteria. Benefit is preventing an OOB read and leak on
Bluetooth ISO PA reassembly; risk is dropping already-invalid events. No
missing prerequisites in this checkout.

### Concerns

None that block backport. Path is ISO/PA-specific, not every HCI user;
still a real memory-safety bug in default `CONFIG_BT_LE` code. No series
dependency.

---

Verification:
- [Phase 1] Parsed tags: author + Luiz SOB only; no
  Fixes/Cc:stable/Reported-by
- [Phase 2] Diff: +7 lines in `hci_le_per_adv_report_evt`;
  `hci_le_ev_skb_pull(..., ev->length)` before consume
- [Phase 2] Confirmed dest check in `iso.c:2246-2248` vs missing source
  check at `iso.c:2250-2251`
- [Phase 2] `skb_pull_data` returns NULL if `skb->len < len`
  (`net/core/skbuff.c:2667-2676`)
- [Phase 3] `git describe HEAD` / Makefile: **6.12.111**, branch
  `pending-6.12`
- [Phase 3] blame: handler `9c0826310bfb7` (v6.6-rc1); memcpy
  `168d9bf9c7f01` (v6.9-rc1); both ancestors of HEAD
- [Phase 3] `git merge-base --is-ancestor 168d9bf9c7f01 HEAD` → yes
- [Phase 3] `git log --grep="out-of-bounds read in LE PA" --
  net/bluetooth/` → empty (fix not in tree)
- [Phase 3] `hci_le_ev_skb_pull` present at `hci_event.c:71-81`
- [Phase 4] `b4 mbox` msgid
  `20260805173701.6649-1-acharyalaxman8848@gmail.com`: v1, 3 msgs, no
  NAK; applied bluetooth-next `96995a7d94f3`
- [Phase 4] BlueZ CI: iso-tester PASS; GitLint tabs in commit-message
  sample; unrelated mgmt/mesh timeouts
- [Phase 4] netdev pull 2026-08-07 lists this commit under Laxman
  Acharya
- [Phase 4] UNVERIFIED: lore.kernel.org 403; git.kernel.org Anubis; `b4
  dig -c` skipped (SHA not local)
- [Phase 5] Call chain: event table → `hci_le_meta_evt` min_len pull →
  handler → `hci_proto_connect_ind` (`PA_LINK`) → `iso_connect_ind`
- [Phase 5] `hci_recv_event_data` uses `skb_clone` taken before pulls
  (`hci_event.c:7575-7576`)
- [Phase 5] `BT_ISO_BASE` getsockopt copies `le_per_adv_data`
  (`iso.c:1834-1848`)
- [Phase 5] `iso.o` built with `CONFIG_BT_LE`; `iso_sock_create` has no
  extra cap
- [Phase 6] Local handler at `hci_event.c:6460` lacks the pull; `git
  apply --check` of candidate hunk exit 0
- [Phase 8] Failure mode: OOB read + userspace info leak; severity HIGH
- UNVERIFIED: whether mgmt/mesh CI fails are pre-existing flakes (iso-
  tester passed; those tests are unrelated)

**YES**

 net/bluetooth/hci_event.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 23fe327a0fcd6..fd823baf64415 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6580,6 +6580,13 @@ static void hci_le_per_adv_report_evt(struct hci_dev *hdev, void *data,
 
 	bt_dev_dbg(hdev, "sync_handle 0x%4.4x", le16_to_cpu(ev->sync_handle));
 
+	/* The reassembly in iso_connect_ind() copies ev->length bytes from the
+	 * stored event, so make sure the event actually carries that many data
+	 * bytes before it is consumed.
+	 */
+	if (!hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_PER_ADV_REPORT, ev->length))
+		return;
+
 	hci_dev_lock(hdev);
 
 	mask |= hci_proto_connect_ind(hdev, BDADDR_ANY, PA_LINK, &flags);
-- 
2.53.0

