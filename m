Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093013EFD07;
	Wed, 20 May 2026 11:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276038; cv=none; b=o7laEUBFry3DY4OHwLsqz7XAMZhGkxf75nOGJAzWDFhO3QkDs1dy8LdQVAsa4MHa9XgsVPaACIlpDihBKb8akL8kEhUDN+OjvJ1wcbJGstHb2LoJsVB9EQF083HzHrEgQfZxvVMQlx71SoOTcGIu+qg21zGNYTSEt0DumzAD8+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276038; c=relaxed/simple;
	bh=9tCgCsqZ2HSZ/TsOoNVOU6D2wmSey9I88Ha5w3FI9Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GFN+DOAegk5+z7Wgy45jwUAqMuHhsVezsiZIJzPiQOsx41k6dP4Kx7lHGiUs/aiLVORf+jh/2W6VlneWQug53F5e7yCkP4qFOdXgjwxZzsaGDRAWgnbEd1CCv26OKhSwfbmvskBCqzUpkFjJjPZot6cKMdOqxeEcjaCUgxQPysY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=greBzWZ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="greBzWZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F6D1F000E9;
	Wed, 20 May 2026 11:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276036;
	bh=D9MhGhpq4EiWeszcm+ApO54D6CdIlZl+1Bz4xmUp/NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=greBzWZ0Jqp5qxNgvX+AOqp8X+ij8cWFT9Kg8BIqdblXAYJqKsLCh7JWpwtJio7yI
	 YoxQ9UL2Jt8NVN1g6hRoaEKgw34BnHvtuVyLpIkSAQP035W8U926B0ZYXmZ2WmU2kJ
	 bokuXKcZq0tVeAF3J+vuJbPoXceKtsKl3roNaBAW2ESS7KtJHT4MGm5tnAEiGmxUq1
	 FOHJEMo+38/LPmggaVzXzAMbrEwV+nAilo0MBDKEJJ121dTeDGQrrUt6WBHtyUoAEl
	 htjGky2eWdcYGJZXPpiVdFRi/3frAV6WxntHQEg57IWoz6A3W+kBc1yKWgN42cLaYV
	 OPZinxkWyf/5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aurelien DESBRIERES <aurelien@hackers.camp>,
	syzbot+ff30eeab8e07b37d524e@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] Bluetooth: hci_uart: Fix NULL deref in recv callbacks when priv is uninitialized
Date: Wed, 20 May 2026 07:19:08 -0400
Message-ID: <20260520111944.3424570-36-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aurelien DESBRIERES <aurelien@hackers.camp>

[ Upstream commit 902fe40bce7059722f7ffa1c378e577675cf1918 ]

When a fault is injected during hci_uart line discipline setup, the
proto open() callback may fail leaving hu->priv as NULL. A subsequent
TIOCSTI ioctl can trigger the recv() callback before priv is
initialized, causing a NULL pointer dereference.

Fix all four affected HCI UART protocol drivers by adding a NULL check
on hu->priv at the start of their recv() callbacks: h4, h5, ath and
bcsp.

Reported-by: syzbot+ff30eeab8e07b37d524e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ff30eeab8e07b37d524e
Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem `Bluetooth: hci_uart`; action verb `Fix`;
intent is to prevent NULL dereference in HCI UART protocol `recv()`
callbacks when `hu->priv` is not initialized.

Step 1.2 Record: Tags found: `Reported-by:
syzbot+ff30eeab8e07b37d524e@syzkaller.appspotmail.com`; `Closes:
https://syzkaller.appspot.com/bug?extid=ff30eeab8e07b37d524e`; `Signed-
off-by: Aurelien DESBRIERES`; `Assisted-by: Claude:claude-sonnet-4-6`;
`Signed-off-by: Luiz Augusto von Dentz`. No `Fixes:` tag. Notable
pattern: syzbot report with reproducer and KASAN NULL-deref crash.

Step 1.3 Record: The commit describes a `hu->priv == NULL` path during
HCI UART setup followed by received data via `TIOCSTI`, causing a NULL
pointer dereference. The syzkaller report verifies a KASAN NULL-
deref/general protection fault in `h4_recv`, with call chain `tty_ioctl
-> tiocsti -> hci_uart_tty_receive -> h4_recv`.

Step 1.4 Record: This is not hidden cleanup; it is an explicit memory-
safety crash fix. The added checks prevent dereferencing protocol-
private state when setup/error handling leaves it absent.

## Phase 2: Diff Analysis
Step 2.1 Record: Four files changed, all in `drivers/bluetooth`:
`hci_ath.c` `+3/-0`, `hci_bcsp.c` `+3/-0`, `hci_h4.c` `+3/-0`,
`hci_h5.c` `+3/-0`; total `12` insertions. Modified functions:
`ath_recv`, `bcsp_recv`, `h4_recv`, `h5_recv`. Scope: small multi-file
surgical driver fix.

Step 2.2 Record: Each hunk previously assigned `hu->priv` to a protocol-
private pointer and then dereferenced it. After the patch, each callback
returns `-ENODEV` if that pointer is NULL. The affected path is receive
handling through the HCI UART line discipline, including data injected
by `TIOCSTI`.

Step 2.3 Record: Bug category is NULL pointer dereference / memory
safety. Specific mechanism: `hci_uart_tty_receive()` calls
`hu->proto->recv()`, and these callbacks dereference `hu->priv`; if
setup/error handling leaves `hu->priv` NULL, the callback crashes. The
fix adds direct NULL guards before first dereference.

Step 2.4 Record: Fix quality is high: simple, local, obviously correct,
no API/data structure changes. Regression risk is very low; it only
changes an invalid crash path to `-ENODEV`.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` on the vulnerable lines showed the current
callback bodies come from long-standing Bluetooth UART code, with recent
edits such as `b489556a856d` for `h4_recv_buf()` usage and
`ca94b2b036c2` adding the BCSP registered guard. The vulnerable pattern
exists in `v6.19.14` and `v7.0.5`.

Step 3.2 Record: No `Fixes:` tag, so no tagged introducing commit to
follow.

Step 3.3 Record: Related recent commits include `0ffac654e95c` / stable
backport `981b4fd2baf3` removing the `HCI_UART_REGISTERED` guard from
`h4_recv`, and `0c3cd7a0b862` fixing a related HCI UART NULL deref in
write work. Another related upstream commit, `68d39ea5e0ad`, clears
`HCI_UART_PROTO_INIT` on register error but is present in `v7.1-rc*`,
not in checked `v6.19.14`/`v7.0.5`.

Step 3.4 Record: No prior Bluetooth commits by Aurelien DESBRIERES were
found in this checkout. The patch was committed/applied by Bluetooth
maintainer Luiz Augusto von Dentz.

Step 3.5 Record: No functional prerequisite is required for this patch
in affected trees; it applies cleanly to current `v7.0.5`. It is most
relevant to trees with the `HCI_UART_PROTO_INIT` receive path and the
recent H4 initialization-race changes, such as checked `v6.19.y` and
`v7.0.y`.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 902fe40bce70` found the original thread:
`https://patch.msgid.link/20260421135331.15425-1-aurelien@hackers.camp`.
`b4 dig -a` found only v1; the committed patch matches the submitted
revision.

Step 4.2 Record: `b4 dig -w` showed recipients included `linux-
bluetooth`, Marcel Holtmann, Johan Hedberg, Luiz Dentz, `linux-kernel`,
and syzbot. The patchwork bot reported it was applied to
`bluetooth/bluetooth-next.git` by Luiz Augusto von Dentz.

Step 4.3 Record: Syzkaller bug page verifies: “general protection fault
in h4_recv”, KASAN NULL-ptr-deref, C and syz reproducers, and fix commit
`902fe40bce70`.

Step 4.4 Record: No multi-patch series was found; only v1 of this one-
patch submission.

Step 4.5 Record: Direct lore stable fetch was blocked by Anubis; web
search found no stable-specific discussion. This does not affect the
decision because the syzbot crash and code path are verified elsewhere.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: Modified functions: `ath_recv`, `bcsp_recv`, `h4_recv`,
`h5_recv`.

Step 5.2 Record: Exact call path verified: protocol structs assign
`.recv = h4_recv/ath_recv/bcsp_recv/h5_recv`; `hci_uart_tty_receive()`
calls `hu->proto->recv(hu, data, count)`; `tiocsti()` calls the line
discipline `receive_buf`.

Step 5.3 Record: Key callees include `h4_recv_buf()`,
`hci_recv_frame()`, `h5_reset_rx()`, `bcsp_unslip_one_byte()`, and skb
cleanup helpers. The first unsafe operation in each changed function was
a dereference of the private pointer.

Step 5.4 Record: Reachability is verified from userspace ioctl in the
syzkaller trace and reproducer: `openat("/dev/ptmx")`, `TIOCSETD` to
`N_HCI`, `HCIUARTSETPROTO` with fault injection, then `TIOCSTI`.

Step 5.5 Record: Similar HCI UART receive callbacks exist; some, like
`qca_recv` and `ll_recv`, still have `HCI_UART_REGISTERED` guards before
dereferencing private data. The candidate focuses on the four callbacks
identified in the accepted patch.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: Checked `v6.19.14` and `v7.0.5`: the four callbacks
exist without the new NULL checks. These trees also have
`hci_uart_tty_receive()` accepting `HCI_UART_PROTO_INIT`. Checked
`v6.6`/`v6.12`: older receive gating differs, so the exact trigger is
less clearly present there.

Step 6.2 Record: `git apply --check` of the candidate diff succeeds on
the current `v7.0.5` checkout. Expected backport difficulty for similar
affected trees is clean or trivial.

Step 6.3 Record: No equivalent recv-callback NULL guard was found in
`v6.19.14` or `v7.0.5`. A related central cleanup exists upstream as
`68d39ea5e0ad`, but not in those checked stable tags.

## Phase 7: Subsystem Context
Step 7.1 Record: Subsystem is Bluetooth HCI UART, a driver subsystem
under `drivers/bluetooth`. Criticality: important for systems using
UART-attached Bluetooth controllers; not universal core kernel code.

Step 7.2 Record: Bluetooth UART code is actively changing in this range,
with recent initialization-race and NULL-deref fixes in the same area.

## Phase 8: Impact And Risk
Step 8.1 Record: Affected users are systems with `N_HCI` / HCI UART
Bluetooth line discipline enabled, especially with H4/H5/ATH/BCSP
protocol paths.

Step 8.2 Record: Trigger verified by syzkaller requires HCI UART line
discipline setup, fault/error during protocol setup, then received data
through `TIOCSTI`. The reproducer uses fault injection and ioctl access;
unprivileged exploitability was not established.

Step 8.3 Record: Failure mode is kernel oops/general protection fault
from KASAN NULL dereference in `h4_recv`; severity HIGH to CRITICAL
because it crashes the kernel.

Step 8.4 Record: Benefit is high for affected stable trees because it
prevents a reproducible kernel crash. Risk is very low: 12 added lines,
no new feature, no locking changes, no API changes.

## Phase 9: Final Synthesis
Step 9.1 Record: Evidence for backporting: syzbot report with
reproducer, KASAN NULL deref, syscall-triggered path, small surgical
patch, accepted by Bluetooth maintainer, applies cleanly to checked
stable tree. Evidence against: trigger appears tied to setup
failure/fault injection and may not affect older stable trees with
different HCI UART initialization flow. Unresolved: exact applicability
to every older LTS branch was not fully verified.

Step 9.2 Record: Stable rules checklist: obviously correct: yes; fixes
real bug: yes, syzbot crash; important issue: yes, kernel oops; small
and contained: yes, 12 insertions in four driver callbacks; no new
features/APIs: yes; applies to stable: yes for checked `v7.0.5`, likely
trivial for affected `v6.19.y`.

Step 9.3 Record: No exception category needed; this is a direct crash
fix, not a device ID/quirk/build/doc patch.

Step 9.4 Record: Decision is to backport to affected stable trees,
especially those containing the `HCI_UART_PROTO_INIT` receive path and
recent HCI UART initialization fixes. The benefit/risk ratio is strongly
favorable.

## Verification
- Phase 1: Parsed commit `902fe40bce7059722f7ffa1c378e577675cf1918` with
  `git show`; verified syzbot and Closes tags.
- Phase 2: Verified diff stat: four files, 12 insertions, only NULL
  guards in recv callbacks.
- Phase 3: Ran `git blame` on changed callback lines and inspected
  related commits `0ffac654e95c`, `981b4fd2baf3`, `0c3cd7a0b862`, and
  `68d39ea5e0ad`.
- Phase 4: Ran `b4 dig -c`, `-a`, and `-w`; fetched mirror thread and
  syzkaller bug/reproducer.
- Phase 5: Verified call path with source reads and exact searches:
  `tiocsti()` -> line discipline `receive_buf` ->
  `hci_uart_tty_receive()` -> protocol `.recv`.
- Phase 6: Checked `v6.19.14`, `v7.0.5`, `v6.12`, and `v6.6` snippets;
  verified patch applies to current `v7.0.5` with `git apply --check`.
- Phase 8: Verified failure mode from syzkaller crash log: KASAN NULL-
  ptr-deref/general protection fault in `h4_recv`.
- UNVERIFIED: Exact applicability to every active older stable/LTS
  branch; older branches with different HCI UART gating may not need
  this patch.

**YES**

 drivers/bluetooth/hci_ath.c  | 3 +++
 drivers/bluetooth/hci_bcsp.c | 3 +++
 drivers/bluetooth/hci_h4.c   | 3 +++
 drivers/bluetooth/hci_h5.c   | 3 +++
 4 files changed, 12 insertions(+)

diff --git a/drivers/bluetooth/hci_ath.c b/drivers/bluetooth/hci_ath.c
index fa679ad0acdfa..8201fa7f61e84 100644
--- a/drivers/bluetooth/hci_ath.c
+++ b/drivers/bluetooth/hci_ath.c
@@ -191,6 +191,9 @@ static int ath_recv(struct hci_uart *hu, const void *data, int count)
 {
 	struct ath_struct *ath = hu->priv;
 
+	if (!ath)
+		return -ENODEV;
+
 	ath->rx_skb = h4_recv_buf(hu, ath->rx_skb, data, count,
 				  ath_recv_pkts, ARRAY_SIZE(ath_recv_pkts));
 	if (IS_ERR(ath->rx_skb)) {
diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index b386f91d8b46d..db56eead27ceb 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -585,6 +585,9 @@ static int bcsp_recv(struct hci_uart *hu, const void *data, int count)
 	if (!test_bit(HCI_UART_REGISTERED, &hu->flags))
 		return -EUNATCH;
 
+	if (!bcsp)
+		return -ENODEV;
+
 	BT_DBG("hu %p count %d rx_state %d rx_count %ld",
 	       hu, count, bcsp->rx_state, bcsp->rx_count);
 
diff --git a/drivers/bluetooth/hci_h4.c b/drivers/bluetooth/hci_h4.c
index a889a66a326f7..7673727074985 100644
--- a/drivers/bluetooth/hci_h4.c
+++ b/drivers/bluetooth/hci_h4.c
@@ -109,6 +109,9 @@ static int h4_recv(struct hci_uart *hu, const void *data, int count)
 {
 	struct h4_struct *h4 = hu->priv;
 
+	if (!h4)
+		return -ENODEV;
+
 	h4->rx_skb = h4_recv_buf(hu, h4->rx_skb, data, count,
 				 h4_recv_pkts, ARRAY_SIZE(h4_recv_pkts));
 	if (IS_ERR(h4->rx_skb)) {
diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index cfdf75dc28475..d353837182125 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -587,6 +587,9 @@ static int h5_recv(struct hci_uart *hu, const void *data, int count)
 	struct h5 *h5 = hu->priv;
 	const unsigned char *ptr = data;
 
+	if (!h5)
+		return -ENODEV;
+
 	BT_DBG("%s pending %zu count %d", hu->hdev->name, h5->rx_pending,
 	       count);
 
-- 
2.53.0

