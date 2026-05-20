Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF293F0AA3;
	Wed, 20 May 2026 11:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276042; cv=none; b=rbA9yNZp+WJm0PvNyvISBVXHki5uoKlEdmmqNcEKW6ooh2awfJ4M7C8P4m7StY8oPEiMCp5qDtV6lABd5RtO++juvxirIDx23kDkFZ+qg+nEbVUNlpbnk2K9uCRQCpXTg4wAlMxJ+cLH7AkXncdY5kJGDPgiznflBDiVcWJh5jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276042; c=relaxed/simple;
	bh=FdxaTCru6hrfGquTDBaLS5mWfPunr3FQyhpxgFvekzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dmQbMfmnXBj5hA0zXvuOLHiHH0+CdIU5Ar/JZ/XmGDlz2WnaY8vJaj2ShAxfxoNg8urdBPK9NlYlYCQ+Co1ziyh0Dxwv+27N7CWfFo8aMhXFok1UczSmGH0TS7CzENpQfRrP5YTnaIiwMl7zDZ/FGTpyIcBRJXQqJABbYjboLRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEkUYSAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEkUYSAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B942C1F00896;
	Wed, 20 May 2026 11:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276040;
	bh=cInCMzdvIkClR5l3HNMTXvE1JYiwOvHOF8R1wdwpNGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WEkUYSAyboltHIWK5JyWcQmx4iOj8wBbPt5thNAVeZ3kaA1aDuhmo9rXUnf2pwBSH
	 tHJ8P9NkQw0x6wFmB7mUp+noywhelkaR1ufh5A61jvBhv1vdX0mqrj39AD1ycYIdas
	 M/JHMCOYweyOJuF5tv1a8AcpDMwP+IvcOdgm1fO2fBbjcX5jzjdfQO3Mt8KJhWrXpj
	 QKWJXMIPTX1aA7d2PmoTGpEIC++hw/hw8ETznubRIGq2caePMzTUtC3orCQZOKPAYG
	 TIWod7oqut/Gzcmr2A6kelOCRMw1/eEpuqA7VZQ9a24TeSVZNSQxmzIZaB+d5owFWN
	 3HI4CZjUve1kQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Anton Swart <anton.swart.jhb@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] ALSA: usb-audio: Add quirk flags for AlphaTheta EUPHONIA
Date: Wed, 20 May 2026 07:19:11 -0400
Message-ID: <20260520111944.3424570-39-sashal@kernel.org>
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

From: Anton Swart <anton.swart.jhb@gmail.com>

[ Upstream commit f80785888f7c0980a49545b87a80e3817c9ed7c6 ]

The AlphaTheta EUPHONIA (VID 0x2b73, PID 0x0047) is a USB Audio
Class 2 DJ mixer that requires implicit feedback for full-duplex
operation. The capture endpoint (0x83 IN, interface 2) acts as the
implicit feedback source for the playback endpoint (0x03 OUT,
interface 1), and the device firmware does not send isochronous
data on the capture endpoint unless the host is simultaneously
sending data on the playback endpoint, i.e. playback must be
started first.

Without QUIRK_FLAG_PLAYBACK_FIRST the kernel waits for capture URBs
before submitting playback URBs, creating a deadlock: the device
waits for playback data and the host waits for capture data.
Without QUIRK_FLAG_GENERIC_IMPLICIT_FB the kernel does not detect
the implicit feedback relationship between the two interfaces.

The same flag combination is already used for the Behringer UMC202HD,
UMC204HD and UMC404HD (0x1397:0x0507/0x0508/0x0509), which exhibit
the identical implicit-feedback topology.

Tested on Raspberry Pi 5 with kernel 6.12.75; continuous full-duplex
streaming at 96 kHz / 24-bit, zero XRUNs.

Signed-off-by: Anton Swart <anton.swart.jhb@gmail.com>
Link: https://patch.msgid.link/20260503211517.14332-1-anton.swart.jhb@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject
Record: Subsystem: `ALSA: usb-audio`. Action verb: `Add`. Claimed
intent: add device-specific quirk flags for AlphaTheta EUPHONIA.

### Step 1.2: Tags
Record:
- `Signed-off-by: Anton Swart <anton.swart.jhb@gmail.com>`: author
  signoff.
- `Link: https://patch.msgid.link/20260503211517.14332-1-
  anton.swart.jhb@gmail.com`: original patch submission.
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>`: supplied commit message
  says ALSA maintainer applied/signed off.
- No `Fixes:` tag.
- No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or `Cc:
  stable@vger.kernel.org` tags.
- The patch body says it was tested on Raspberry Pi 5 with kernel
  `6.12.75`, but this is not a formal `Tested-by:` tag.

### Step 1.3: Commit Body
Record: The bug is a device-specific full-duplex startup deadlock for
AlphaTheta EUPHONIA USB Audio Class 2 mixer `VID:PID 0x2b73:0x0047`. The
capture endpoint is the implicit feedback source, but firmware does not
emit capture isochronous data until playback is already sending.
Symptom: full-duplex streaming cannot start because host waits for
capture feedback while device waits for playback data. Version info:
tested on `6.12.75`. Root cause: kernel does not both detect generic
implicit feedback and start playback first for this device.

### Step 1.4: Hidden Bug Fix
Record: Yes. Although phrased as “Add quirk flags”, this is a hardware
workaround fixing real device malfunction. It falls under the stable
hardware-quirk exception.

## Phase 2: Diff Analysis

### Step 2.1: Inventory
Record:
- File changed: `sound/usb/quirks.c`
- Scope: 2 lines added, 0 removed.
- Function/data object modified: `quirk_flags_table[]`.
- Classification: single-file, table-only, surgical hardware quirk.

### Step 2.2: Code Flow Change
Record:
- Before: device `0x2b73:0x0047` had no built-in quirk flag entry.
- After: matching USB audio devices get `QUIRK_FLAG_PLAYBACK_FIRST |
  QUIRK_FLAG_GENERIC_IMPLICIT_FB`.
- Affected path: USB audio device probe initializes `chip->quirk_flags`
  from `quirk_flags_table[]`; stream parsing and endpoint start then use
  those flags.
- Path type: initialization/probe plus later stream-start behavior.

### Step 2.3: Bug Mechanism
Record:
- Category: hardware workaround / USB audio implicit feedback startup
  ordering.
- `QUIRK_FLAG_GENERIC_IMPLICIT_FB` is verified in `sound/usb/implicit.c`
  to trigger `add_generic_implicit_fb()` when the generic implicit-
  feedback flag is set.
- `QUIRK_FLAG_PLAYBACK_FIRST` is verified in `sound/usb/endpoint.c` to
  skip the normal “do not submit playback URBs until feedback arrives”
  behavior for implicit-feedback sinks.
- Together they fix the described stream-start deadlock for this device.

### Step 2.4: Fix Quality
Record: The fix is obviously minimal and consistent with existing
entries. The same exact flag combination is already present for
Behringer UMC202HD/UMC204HD/UMC404HD in `sound/usb/quirks.c`. Regression
risk is very low because the new behavior is limited to exact USB ID
`0x2b73:0x0047`.

## Phase 3: Git History Investigation

### Step 3.1: Blame Changed Area
Record: `git blame` on the insertion area showed neighboring quirk
entries are longstanding table entries, including Fiero SC-01 entries
introduced by `668abe6dc7b619` (`ALSA: usb-audio: Sort quirk table
entries`). Local history is partly grafted, so I did not rely on graft-
boundary blame for introduction of the whole mechanism.

### Step 3.2: Fixes Tag
Record: Not applicable. There is no `Fixes:` tag.

### Step 3.3: File History
Record: Recent `sound/usb/quirks.c` history contains many similar
device-specific quirk additions/fixes. No prerequisite patch is
referenced by the commit message. This patch is standalone for trees
that already have `QUIRK_FLAG_GENERIC_IMPLICIT_FB` and
`QUIRK_FLAG_PLAYBACK_FIRST`.

### Step 3.4: Author History
Record: `git log --author='Anton Swart' -10 -- sound/usb` found no local
prior commits. `MAINTAINERS` verifies Takashi Iwai is a listed `SOUND`
maintainer, and the supplied commit message has his signoff.

### Step 3.5: Dependencies
Record: The patch depends on existing `QUIRK_FLAG_GENERIC_IMPLICIT_FB`
and `QUIRK_FLAG_PLAYBACK_FIRST` infrastructure. Verified present in
`v6.1`, `v6.6`, `v6.12`, and `v7.0.5`. Verified `v5.15` has
`PLAYBACK_FIRST` but not `GENERIC_IMPLICIT_FB`, so this exact patch is
not directly applicable to `5.15.y`.

## Phase 4: Mailing List And External Research

### Step 4.1: Original Discussion
Record: No upstream commit hash was available locally, so `b4 dig -c
<commit>` could not be used. I used the supplied message-id link with
`b4 am`. It found the patch at `https://lore.kernel.org/all/202605032115
17.14332-1-anton.swart.jhb@gmail.com/`, one patch, two messages in
thread, zero code-review messages analyzed, DKIM signed by Gmail.
`WebFetch` to lore was blocked by Anubis.

### Step 4.2: Reviewers / Recipients
Record: `b4 am --cc-trailers` showed recipients: `alsa-devel@alsa-
project.org`, Jaroslav Kysela, Takashi Iwai, and `linux-
kernel@vger.kernel.org`. These are appropriate ALSA/kernel recipients.
No reviewer trailers were found in the b4-processed thread.

### Step 4.3: Bug Report
Record: No separate bug report or `Reported-by:` tag found. The patch
itself gives a concrete device topology, failure mode, and test result.
Web search found AlphaTheta product/support pages but no separate kernel
bug report for this quirk.

### Step 4.4: Related Series
Record: `b4 am` found a single-patch submission, not a multi-patch
series. No series dependency found.

### Step 4.5: Stable Mailing List
Record: `WebFetch` searches for lore stable/all were blocked by Anubis.
Web search did not find stable-list discussion for this exact patch. No
evidence found of a stable-specific objection.

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions/Data
Record: Modified object: `quirk_flags_table[]`. Affected functions
verified:
- `snd_usb_init_quirk_flags_table()`
- `snd_usb_init_quirk_flags()`
- `snd_usb_audio_create()`
- `audioformat_playback_quirk()`
- `add_generic_implicit_fb()`
- `snd_usb_endpoint_start()`

### Step 5.2: Callers
Record: `usb_audio_probe()` calls `snd_usb_audio_create()`, which
initializes quirk flags. ALSA PCM ops call `snd_usb_pcm_prepare()` and
playback/capture trigger callbacks, which call `start_endpoints()`,
which calls `snd_usb_endpoint_start()`.

### Step 5.3: Callees
Record: `snd_usb_init_quirk_flags_table()` scans `quirk_flags_table[]`
and ORs flags into `chip->quirk_flags`. `audioformat_playback_quirk()`
calls `add_generic_implicit_fb()` when `QUIRK_FLAG_GENERIC_IMPLICIT_FB`
is set. `snd_usb_endpoint_start()` changes URB submission behavior based
on `QUIRK_FLAG_PLAYBACK_FIRST`.

### Step 5.4: Call Chain / Reachability
Record: Reachable when the matching USB audio device is probed and
userspace opens/starts ALSA PCM full-duplex streams. I did not verify
whether an unprivileged user can trigger it on a given distribution;
ALSA device permissions are policy-dependent.

### Step 5.5: Similar Patterns
Record: Verified existing exact flag combination for Behringer
`0x1397:0x0507`, `0x0508`, and `0x0509`. Verified
`QUIRK_FLAG_GENERIC_IMPLICIT_FB` appears in ten quirk-table entries in
current `7.0.y`.

## Phase 6: Stable Tree Analysis

### Step 6.1: Buggy Code Exists
Record:
- `v7.0.5`: quirk infrastructure exists; EUPHONIA entry absent.
- `v6.12.75`: quirk infrastructure exists; EUPHONIA entry absent.
- `v6.6`: quirk infrastructure exists; EUPHONIA entry absent.
- `v6.1`: quirk infrastructure exists; EUPHONIA entry absent.
- `v5.15`: `GENERIC_IMPLICIT_FB` flag absent, so this exact patch is not
  applicable.

### Step 6.2: Backport Difficulty
Record:
- `v7.0.5`: index-only `git apply --check` passes.
- `v6.12.75`: index-only `git apply --check` passes.
- `v6.6` and `v6.1`: exact patch does not apply because nearby context
  differs, but the same table and flags exist; expected minor context-
  only backport.
- `v5.15`: exact patch does not apply and lacks required generic flag
  infrastructure.

### Step 6.3: Related Fixes Already Stable
Record: No existing `0x2b73:0x0047` or `AlphaTheta EUPHONIA` entry found
in the local tree. No local history match for this device.

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
Record: Subsystem is ALSA USB audio, under `sound/usb`. Criticality:
important for users of affected USB audio hardware, but not
universal/core kernel.

### Step 7.2: Activity
Record: `sound/usb` is actively maintained; recent history shows
multiple ALSA USB fixes and quirk updates. Maintainer context verified
through `MAINTAINERS`.

## Phase 8: Impact And Risk

### Step 8.1: Affected Users
Record: Driver/hardware-specific: users of AlphaTheta EUPHONIA USB audio
mixer on kernels with this usb-audio quirk infrastructure.

### Step 8.2: Trigger Conditions
Record: Trigger is full-duplex streaming where capture endpoint acts as
implicit feedback and playback must start first. The commit message
reports testing continuous full-duplex 96 kHz / 24-bit on Raspberry Pi 5
with kernel `6.12.75`.

### Step 8.3: Failure Severity
Record: Failure mode is a device/stream-start deadlock: audio full-
duplex streaming does not start. Severity: medium-high for affected
hardware users. It is not verified as a system-wide kernel
deadlock/panic.

### Step 8.4: Risk / Benefit
Record: Benefit is high for affected hardware because it makes full-
duplex operation work. Risk is very low: exact USB-ID match, 2-line
table addition, no API or shared logic change.

## Phase 9: Final Synthesis

### Step 9.1: Evidence
Record: Evidence for backporting:
- Real hardware malfunction with concrete topology and failure mode.
- Hardware quirk category is explicitly stable-suitable.
- 2-line exact-device table addition.
- Existing identical flag combination for similar implicit-feedback
  devices.
- Tested on `6.12.75`.
- Appropriate ALSA maintainers/lists were CC’d; supplied commit has
  Takashi Iwai signoff.

Evidence against:
- No separate `Reported-by:` or formal `Tested-by:` tag.
- `v6.6`/`v6.1` need minor context backport.
- `v5.15` lacks `QUIRK_FLAG_GENERIC_IMPLICIT_FB`, so this exact patch
  should not be applied there without additional analysis/prerequisites.

Unresolved:
- Lore web UI could not be fetched due Anubis.
- No upstream commit hash was available locally, so `b4 dig -c` could
  not be performed.
- No independent bug report was found.

### Step 9.2: Stable Rules
Record:
1. Obviously correct and tested: yes, for applicable trees; 2-line
   exact-ID quirk and patch body reports testing.
2. Fixes a real bug: yes, full-duplex stream startup deadlock for
   specific hardware.
3. Important issue: yes for affected hardware; device full-duplex
   operation is broken without it.
4. Small and contained: yes, one file, two lines.
5. No new APIs/features: yes. This is a hardware quirk, not a new
   interface.
6. Applies to stable trees: cleanly to `v7.0.5` and `v6.12.75`; minor
   context backport for `v6.6`/`v6.1`; not directly to `v5.15`.

### Step 9.3: Exception Category
Record: Hardware quirk/workaround for a broken/nonstandard USB audio
device. This is one of the strong stable-appropriate exception
categories.

### Step 9.4: Decision
This should be backported to stable trees that already have the generic
implicit-feedback quirk flag infrastructure, especially `6.12.y`,
`6.6.y`, `6.1.y`, and `7.0.y` if applicable. For `5.15.y`, do not apply
this exact patch without separate prerequisite/backport work because the
required `QUIRK_FLAG_GENERIC_IMPLICIT_FB` flag is absent.

## Verification

- Phase 1: Parsed supplied subject, body, and tags; verified original
  patch body with `b4 am` mbox.
- Phase 2: Verified diff is 2 insertions in `sound/usb/quirks.c`.
- Phase 2/5: Read `sound/usb/quirks.c`, `sound/usb/usbaudio.h`,
  `sound/usb/implicit.c`, `sound/usb/endpoint.c`, `sound/usb/card.c`,
  `sound/usb/pcm.c`, and `sound/usb/stream.c`.
- Phase 3: Ran `git blame` around the insertion area and similar
  Behringer entries; noted grafted history limits.
- Phase 3: Ran file and author history searches without `--all`.
- Phase 4: Ran `b4 am` on the supplied patch link; found one patch and
  DKIM-signed submission.
- Phase 4: Ran `b4 am --cc-trailers`; verified ALSA maintainers/lists
  were CC’d.
- Phase 4: Tried `WebFetch` for lore and stable queries; blocked by
  Anubis.
- Phase 4: Ran web searches; found no separate stable discussion or
  independent bug report.
- Phase 5: Verified caller path from USB probe to quirk flag
  initialization and from ALSA PCM prepare/trigger to endpoint start.
- Phase 5: Verified same flag combination already exists for Behringer
  UMC202HD/UMC204HD/UMC404HD.
- Phase 6: Checked `v7.0.5`, `v6.12.75`, `v6.6`, `v6.1`, and `v5.15` for
  relevant flags/context.
- Phase 6: Ran index-only apply checks: applies to `v7.0.5` and
  `v6.12.75`; does not apply as-is to `v6.6`, `v6.1`, or `v5.15`.
- Phase 7: Verified `MAINTAINERS` lists Takashi Iwai as a `SOUND`
  maintainer.
- Phase 8: Failure mode and tested hardware/kernel are verified from the
  patch message; unprivileged triggerability is unverified.

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 148bf7e4e4d72..2ffc69b57ab49 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2401,6 +2401,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x2b73, 0x0047, /* AlphaTheta EUPHONIA */
+		   QUIRK_FLAG_PLAYBACK_FIRST | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2d95, 0x8011, /* VIVO USB-C HEADSET */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
-- 
2.53.0

