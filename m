Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25C83D3331;
	Wed, 20 May 2026 11:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276020; cv=none; b=oIgjRDkY/wZP+LkoRKE3aFM9KA8CQjSa2EETrgC00lq0xk72d7EkQTAUK+wlixXDCWAj5yqVw02KS16KGJ4gNBZY5plFYhG+EgFF8Lcs8EMH955ih3MtSJ2id7WslIdKFn1ojU8XGu6wC49A71Z+QoEkF5e7ptIEAIwCo+B0CcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276020; c=relaxed/simple;
	bh=StSi6BZ9tPFZYFVEtKopTaOMa3/qwblWeYX5FI6jpAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B02b0uVehA1YN5UgBC3h7IQ0kgQQamCSzJx2TFc8B/HeJPyKyQorBD2eswxosV3sQZqoLnChoP9olI25RluODQTMo9vdDQIXkkIinZtkh8/Am1wNezL39gIrKzCIzbAWWmb1RyoQozwAQ+V1J7LPArMdvb8Qi/0BN14jTIwyRbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iMjATvW/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMjATvW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC271F00899;
	Wed, 20 May 2026 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276012;
	bh=6VykRIHdxdqHJvKeS5smWojHHGioyEj9mP+MkRt6f/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMjATvW/ud/EWOQrd9BVditiPKV/X9FsC/O43TSo5JgAshdN2b584a4KUbLXe1ea/
	 6+iJcRu906TtKXiah/4m3mb4pQBmuKWeL0QzD/hEwvcWOIO2qIioza4lawMQArQx/l
	 tPlDe5Z+ZjpKXMRa/YQBkP0pFOyhctH+uJBrvIHZDH6rFufprWSj6E7xB1VjEdzQ5h
	 rS8wfe5OS0BejrkB2c3GKk99hpgmDKMyOARhZb2TIaKZjM7tuCAcNozSgsCqWliDYP
	 DP5hv3rQjfWbwknccHzzd2FGu8LOWR2rKong9Mr05LdIsKcET/4RjIoIb8vq0M4GXn
	 oL28G1YwQINrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Cheema <alex@exolabs.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oliver@neukum.org,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] net: usb: cdc_ncm: add Apple Mac USB-C direct networking quirk
Date: Wed, 20 May 2026 07:18:51 -0400
Message-ID: <20260520111944.3424570-19-sashal@kernel.org>
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

From: Alex Cheema <alex@exolabs.net>

[ Upstream commit a5148bc2fa27092862ac4b9e7b5c8340d60cff34 ]

Apple Silicon Macs expose two CDC NCM "private" data interfaces over
USB-C with VID:PID 0x05ac:0x1905 and product string "Mac". This is the
same protocol Apple already ships on iPhone (0x05ac:0x12a8) and iPad
(0x05ac:0x12ab) for RemoteXPC since iOS 17 -- both data interfaces lack
an interrupt status endpoint, so they rely on the FLAG_LINK_INTR-
conditional bind path introduced in commit 3ec8d7572a69 ("CDC-NCM: add
support for Apple's private interface").

The id_table currently has entries for iPhone and iPad but not for the
Mac. Without a match, cdc_ncm falls through to the generic CDC NCM
class-match entry, which uses the FLAG_LINK_INTR-having cdc_ncm_info
struct, so bind_common() fails on the missing status endpoint and no
netdev appears.

Add id_table entries for both interface numbers (0 and 2) of the Mac,
bound to the existing apple_private_interface_info driver_info.

Verified empirically on a Mac Studio M3 Ultra running macOS 26.5: when
a Mac is connected via USB-C, ioreg shows VID 0x05ac, PID 0x1905,
product string "Mac", with two NCM data interfaces at numbers 0 and 2.
The same PID is presented by all current Apple Silicon Mac models
(MacBook Pro/Air, Mac mini, Mac Studio across the M-series), mirroring
Apple's single-PID-per-family pattern from iPhone/iPad.

After this patch, plugging a Mac into a Linux host running the patched
kernel produces two enx... interfaces (one per data interface),
"ip -br link" lists them as UP, and standard userspace networking
(DHCP, NetworkManager shared mode, etc.) works without any modprobe
overrides or out-of-tree modules.

Signed-off-by: Alex Cheema <alex@exolabs.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260429175739.34426-1-alex@exolabs.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough

### Phase 1: Commit Message Forensics
Record: Subsystem is `net: usb: cdc_ncm`; action verb is `add`; intent
is to add an Apple Mac USB-C direct networking quirk/device match.

Record: Tags verified from `git show a5148bc2fa27` and `b4`:
`Signed-off-by: Alex Cheema <alex@exolabs.net>`, `Reviewed-by: Simon
Horman <horms@kernel.org>`, `Link:
https://patch.msgid.link/20260429175739.34426-1-alex@exolabs.net`,
`Signed-off-by: Jakub Kicinski <kuba@kernel.org>`. No `Fixes:`,
`Reported-by:`, `Tested-by:`, or `Cc: stable@vger.kernel.org`.

Record: The body describes a real functional failure: Apple Silicon Macs
with VID:PID `05ac:1905` expose private CDC NCM interfaces without
interrupt status endpoints. Without specific IDs, they match the generic
CDC NCM entry, use `cdc_ncm_info` with `FLAG_LINK_INTR`, fail endpoint
collection in `cdc_ncm_bind_common()`, and no netdev appears. The author
reports empirical testing on Mac Studio M3 Ultra.

Record: This is not a hidden memory-safety bug; it is an explicit
hardware ID/quirk fix for already-supported Apple private CDC NCM
handling.

### Phase 2: Diff Analysis
Record: One file changed: `drivers/net/usb/cdc_ncm.c`, 8 insertions, 0
deletions. No functions modified; only `cdc_devs[]` gets two entries.
Scope is single-file, surgical, device-ID style.

Record: Before: Mac interfaces could fall through to the generic CDC NCM
class entry using `cdc_ncm_info`. After: interface numbers `0` and `2`
for `05ac:1905` bind to existing `apple_private_interface_info`.

Record: Bug category is hardware quirk/device ID addition. The local
code verifies `apple_private_interface_info` omits `FLAG_LINK_INTR`,
while `cdc_ncm_info` includes it, and `cdc_ncm_bind_common()` rejects
devices with no status endpoint when `FLAG_LINK_INTR` is set.

Record: Fix quality is high: two exact USB interface-number matches,
reused existing driver_info, no new code path beyond selecting an
existing quirk. Regression risk is very low and limited to Apple VID:PID
`05ac:1905` interfaces `0` and `2`.

### Phase 3: Git History
Record: `git blame` shows `apple_private_interface_info` and the
iPhone/iPad Apple table entries were introduced by `3ec8d7572a69` in
2024.

Record: No `Fixes:` tag is present, but the commit body references
`3ec8d7572a69`; `git show` confirms that commit introduced Apple private
support and the conditional missing-status-endpoint handling.

Record: Recent `cdc_ncm.c` history shows unrelated
bounds/filtering/refactor changes; no prerequisite besides the
referenced Apple private support was found.

Record: `git log --author="Alex Cheema" -10 -- drivers/net/usb` found no
prior local subsystem commits by the author. The patch was reviewed by
Simon Horman and committed by Jakub Kicinski.

Record: Dependency found: stable trees must already contain
`3ec8d7572a69` or an equivalent `apple_private_interface_info`; older
trees without that support will not take this patch standalone.

### Phase 4: Mailing List And External Research
Record: `b4 dig -c a5148bc2fa27` found the original submission at the
patch.msgid.link URL.

Record: `b4 dig -c a5148bc2fa27 -a` found only v1; no later revision.

Record: `b4 dig -c a5148bc2fa27 -w` showed the right net/USB maintainers
and lists were included, including Oliver Neukum, Bjørn Mork, Jakub
Kicinski, netdev, and linux-usb.

Record: Full thread via `b4 mbox` had three messages: the patch, Simon
Horman’s `Reviewed-by`, and patchwork-bot saying Jakub applied it to
`netdev/net.git` as `a5148bc2fa27`. No NAKs or concerns observed.

Record: WebFetch of lore/stable was blocked by Anubis, so stable-
specific web discussion could not be independently checked. No stable
nomination appeared in the fetched thread.

### Phase 5: Code Semantic Analysis
Record: Modified object is `cdc_devs[]`; no function body changed.

Record: Call/reachability path verified: `cdc_ncm_driver.id_table =
cdc_devs`, `.probe = usbnet_probe`; `usbnet_probe()` reads
`prod->driver_info`, sets `dev->driver_info`, then calls `info->bind`,
which is `cdc_ncm_bind()`, which calls `cdc_ncm_bind_common()`.

Record: Key callees are endpoint discovery and bind setup in
`cdc_ncm_bind_common()`, especially the verified endpoint check
requiring status only when `FLAG_LINK_INTR` is set.

Record: User reachability is USB device enumeration/probe when an
affected Mac is connected to a Linux host. This is not syscall-triggered
by an unprivileged local user; it is hardware-triggered.

Record: Similar pattern found: existing iPhone/iPad Apple entries
already bind private interfaces to `apple_private_interface_info`.

### Phase 6: Stable Tree Analysis
Record: `git merge-base --is-ancestor 3ec8d7572a69 <tag>` verified
`3ec8d7572a69` is absent from `v5.15`, `v6.1`, `v6.6`, `v6.9`, and
`v6.10`, but present in `v6.11`, `v6.12`, and `v7.0`.

Record: `git show <tag>:drivers/net/usb/cdc_ncm.c | rg ...` verified
`v6.11+` have `apple_private_interface_info` and iPhone/iPad Apple
entries, but not the Mac `0x1905` entries.

Record: `git apply --check` succeeded against the current `7.0.5` tree.
Backport should be clean for trees with the same Apple-private support;
older trees need the prerequisite and are not standalone targets.

Record: No alternate related stable fix was found locally.

### Phase 7: Subsystem Context
Record: Subsystem is USB networking driver code, under
`drivers/net/usb`. Criticality is important for users of this hardware,
not core/universal.

Record: `scripts/get_maintainer.pl -f drivers/net/usb/cdc_ncm.c`
confirmed the patch was sent to the relevant USB CDC Ethernet and
networking maintainers/lists. Recent `drivers/net/usb` history shows
active maintenance.

### Phase 8: Impact And Risk
Record: Affected users are Linux hosts connecting to Apple Silicon Macs
via USB-C direct CDC NCM networking.

Record: Trigger is plugging in the matching Mac USB device. The failure
is likely whenever the unsupported `05ac:1905` private interfaces are
exposed and lack the interrupt status endpoint, based on the commit body
and verified bind logic.

Record: Failure mode is functional loss: no netdev appears. Severity is
medium by generic bug severity, but it fits the stable exception for new
device IDs/hardware quirks.

Record: Benefit is high for affected hardware users: direct networking
works without overrides/out-of-tree modules. Risk is very low: two
exact-match USB ID entries selecting existing behavior.

### Phase 9: Final Synthesis
Evidence for backporting: it is a classic stable-acceptable hardware
quirk/device ID addition; it fixes a verified bind failure mechanism; it
is tiny and contained; it reuses existing Apple private CDC NCM support;
it was reviewed and applied by netdev maintainership; it applies cleanly
to the current stable-style tree.

Evidence against backporting: it is not a crash/security/data-corruption
fix, and it is not standalone for stable trees older than `v6.11` unless
`3ec8d7572a69` is also present.

Stable rules checklist:
1. Obviously correct and tested: yes; exact ID entries, author-tested,
   reviewer accepted.
2. Fixes a real bug: yes; no netdev appears for matching hardware.
3. Important issue: yes under hardware support/quirk exception, though
   not critical severity.
4. Small and contained: yes, 8 insertions in one table.
5. No new APIs/features: yes, no API or new driver; only IDs for
   existing behavior.
6. Applies to stable: yes for trees with Apple private support; older
   trees need prerequisite handling.

Exception category: new USB device ID / hardware quirk for an existing
driver path.

## Verification
- [Phase 1] Parsed `git show a5148bc2fa27`: confirmed subject, body,
  trailers, reviewed-by, link, and maintainer signoff.
- [Phase 2] Read `drivers/net/usb/cdc_ncm.c`: confirmed `cdc_ncm_info`
  has `FLAG_LINK_INTR`, `apple_private_interface_info` does not, and
  `cdc_ncm_bind_common()` fails missing status endpoints when
  `FLAG_LINK_INTR` is set.
- [Phase 3] `git blame` confirmed Apple private support and existing
  Apple IDs came from `3ec8d7572a69`.
- [Phase 3] `git show 3ec8d7572a69` confirmed it introduced Apple
  private CDC NCM support and the conditional endpoint check.
- [Phase 4] `b4 dig -c a5148bc2fa27`: found the original lore
  submission.
- [Phase 4] `b4 dig -a`: only v1 found.
- [Phase 4] `b4 dig -w`: confirmed relevant maintainers/lists were
  included.
- [Phase 4] `b4 mbox`: confirmed Simon Horman review and patchwork
  application by Jakub Kicinski.
- [Phase 5] `rg` and `ReadFile` traced `cdc_devs[]` to `usbnet_probe()`
  to `cdc_ncm_bind()` to `cdc_ncm_bind_common()`.
- [Phase 6] Tag ancestry checks confirmed prerequisite exists in
  `v6.11+` but not `v6.10` and older checked tags.
- [Phase 6] `git apply --check` confirmed clean apply to current tree.
- UNVERIFIED: Independent confirmation that all current Apple Silicon
  Macs use PID `0x1905`; this is author-stated in the patch, not
  independently verified here.
- UNVERIFIED: Stable mailing-list search via WebFetch was blocked by
  Anubis; no stable-specific discussion was visible in the fetched `b4`
  thread.

This should be backported to stable trees that already contain the Apple
private CDC NCM support, because it is a low-risk hardware ID/quirk fix
that restores networking for real hardware.

**YES**

 drivers/net/usb/cdc_ncm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index bb9929727eb93..0223a172851ec 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -2012,6 +2012,14 @@ static const struct usb_device_id cdc_devs[] = {
 		.driver_info = (unsigned long)&apple_private_interface_info,
 	},
 
+	/* Mac */
+	{ USB_DEVICE_INTERFACE_NUMBER(0x05ac, 0x1905, 0),
+		.driver_info = (unsigned long)&apple_private_interface_info,
+	},
+	{ USB_DEVICE_INTERFACE_NUMBER(0x05ac, 0x1905, 2),
+		.driver_info = (unsigned long)&apple_private_interface_info,
+	},
+
 	/* Ericsson MBM devices like F5521gw */
 	{ .match_flags = USB_DEVICE_ID_MATCH_INT_INFO
 		| USB_DEVICE_ID_MATCH_VENDOR,
-- 
2.53.0

