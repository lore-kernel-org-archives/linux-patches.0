Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BBD646965;
	Mon, 19 Oct 2026 14:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418791; cv=none; b=Z9uL6WNHiTrM7/lFWU73F5YrgLBBonf8TRwtNGXS83EaOIBXrfUvFLm+SDKWyOzqgniWYy+8LmMh5LEx+tr5HRs5JfKJz9Uh3ujQXTdoNrMFxwiZ+3F1zHDdVZdb35voBYPWj58mLWh1eAu2DE4SwBQfO/0XJ9O1ZrKs+SFaoWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418791; c=relaxed/simple;
	bh=euN3SEMyyg+sbFE8FHpIlIdtBKzuSzD2XccaWxbQyCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aPUhPaKy0mubH8pGYlqSw4pKZCFjC9VbkwTs+Zi+D+893d16hEb/DlyMc6toGDDKmFverkPU1m6P9P39kN6egWz7t8DWo/8qP96OIK6Udh+26T+1sV3s9grK2+qnWnldjowgh2gS+GsVT7lLvMSur//ASDn83Zpc/XCIBtdhmfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2Ut2Q70; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2Ut2Q70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB15E1F000C7;
	Mon, 19 Oct 2026 14:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418788;
	bh=0Kg+HFU/rpXqGM/k/hRWOvUWvYMJ+ZkyIGW9s0GKUQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2Ut2Q70IGWmBjZogWMXKX4V+GAk5KwOPmPJCBAes2OXt1ly6xg4z9vlyyAOT/5J0
	 PaE3KoQSW40sm2YECzgzSE39LYFcxOzRTxsmQspxACiJtHKs9/8uqmA7V4KwALfzzd
	 KZyEiIQC4DlQ27disEWunP5nMYgv1zfc4PXzZxgi1G0g5TZAOdewrZinrnQYdGt2+g
	 0YDDOpnjMSZ524Osas9+7mCIFfnuh86WIPCRmh12siuoG+LkL4e65bidWNjpNUylag
	 mCPK6cpu/+yvQOrMp7MWMWgBAUgMYEXYG0UD8RJXtXWKSmZI894Gixh8ehbpb2v3jq
	 kRcPI/OnAV4LQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: usb-audio: Release components on probe errors
Date: Mon, 19 Oct 2026 09:53:08 -0400
Message-ID: <20261019135441.1420968-497-sashal@kernel.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 3213bf9885e3356fff12ac18b12d4c2fb4687734 ]

usb_audio_probe() can create USB-audio component resources before the
first interface is recorded in chip->num_interfaces.  If a later probe
step fails, the error path drops chip->active and frees the card directly
when no interfaces have been registered.

Normal disconnect first releases USB-audio components in a fixed order
before the card is freed.  The first-interface probe error path skipped
that sequence, so partially initialized PCM, endpoint, MIDI, media, or
mixer resources could be left for the card private_free path without their
disconnect handling having run.

Move the existing normal-disconnect component release sequence into a
helper and call it from the zero-interface probe error path before
snd_card_free().  Keep the normal disconnect ordering unchanged: PCM
streams, endpoint resources, MIDI 1.0 resources, MIDI 2.0 resources, media
device cleanup, then mixer resources.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/20260618170026.192212-1-zzzccc427@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The first-interface probe error path in this 6.18 tree still skips
disconnect teardown, so live mixer/MIDI URBs can outlive card devices.
That is a real UAF window, not just cleanup.

## Phase 1: Commit message forensics

**Step 1.1:** Record: `[ALSA/usb-audio] [Release] [On first-interface
probe failure, run the normal USB-audio component disconnect sequence
before snd_card_free()]`

**Step 1.2:** Record: tags present:
- `Assisted-by: Codex:gpt-5.5`
- `Signed-off-by: Cen Zhang <zzzccc427@gmail.com>` (author)
- `Link:
  https://patch.msgid.link/20260618170026.192212-1-zzzccc427@gmail.com`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer applied
  it)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable` (absence
  expected for this review)
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`

**Step 1.3:** Record: `[Bug] first-interface probe can create
PCM/endpoint/MIDI/media/mixer state before chip->num_interfaces is
incremented; a later failure goes to __error_no_register and calls
snd_card_free() when num_interfaces==0. [Symptom] those objects skip the
disconnect sequence used on unplug (URB kill, endpoint release,
MIDI/media/mixer disconnect) and are left to card private_free.
[Versions] none given; code is longstanding. [Root cause] probe error
path is not equivalent to __usb_audio_disconnect().`

**Step 1.4:** Record: `[Not a disguised cleanup.] The message describes
a real teardown skip. Extracting a helper is only so the existing
disconnect sequence can be reused on that error path.`

## Phase 2: Diff analysis

**Step 2.1:** Record: `[sound/usb/card.c, ~+38/-32] [new
usb_audio_disconnect_components(); usb_audio_probe() error path;
__usb_audio_disconnect()] [single-file surgical refactor of existing
teardown + one extra call site]`

**Step 2.2:** Record:
- Hunk 1: identical PCM → endpoint → MIDI 1.0 → MIDI 2.0 → media → mixer
  release moved from `__usb_audio_disconnect()` into
  `usb_audio_disconnect_components()`.
- Hunk 2: `__error_no_register` with `!chip->num_interfaces` used to
  call only `snd_card_free()`; it now calls the helper first.
- Hunk 3: normal disconnect still does shutdown wait +
  `snd_card_disconnect()`, then the helper. Ordering of component
  release is unchanged.

**Step 2.3:** Record: `[Error-path resource teardown / UAF] Probe
creates live USB resources before claiming an interface.
snd_usb_create_streams() can start MIDI 2.0 input URBs;
snd_usb_create_mixer() submits mixer interrupt URBs. Those stay live
until disconnect. On first-interface failure, snd_card_free() runs
snd_device_free_all() (UMP/rawmidi, mixer, PCM) and only then
card->private_free (snd_usb_audio_free → snd_usb_midi_v2_free_all /
endpoint kfree). Completions can still run against objects already
freed. The helper kills/disconnects them first, matching unplug.`

**Step 2.4:** Record: `[Quality: high]` The helper is the existing,
battle-tested disconnect body. Disconnect callbacks are already
idempotent (`disconnected` flags; `snd_media_stream_delete()` NULL-
guards). `[Regression risk: low]` Probe holds `register_mutex` already;
usage_count should be zero because the card is not registered. Mainline
uses `snd_refcount_sync()`; this 6.18 tree still uses
`wait_event(chip->shutdown_wait, ...)`, and the candidate as applied
here keeps that. No API change.

## Phase 3: Git history

**Step 3.1:** Record: `[Buggy error path] 61a6a108d15213 (Thomas Pfaff,
2011) — if (!chip->num_interfaces) snd_card_free(). [Disconnect
sequence] e5779998bf8b70 (2010) plus later MIDI2/media additions
(ff49d1df79aef 2023, 66354f18fe5fbb 2019). Present for the entire 6.18
lifetime.`

**Step 3.2:** Record: `[No Fixes: tag.] The skip is old, not a recent
regression.`

**Step 3.3:** Record: related commits on this tree:
- `4c16176fc11a6` “Kill MIDI 2.0 URBs before freeing endpoints” (same
  author, same day) — already in this tree. Fixes MIDI2 **create-
  internal** error (`snd_usb_midi_v2_free()`). It does **not** kill URBs
  before `snd_card_free()` when create succeeded and a later probe step
  failed.
- `5f8cf71258261` (2018) UAF on this same `num_interfaces==0` path (use-
  after-free of chip->active) — shows this error path has been a real
  UAF site before.
- `6d3e202670b81` resume cleanup — unrelated.

Standalone besides sharing the MIDI2 theme with 4c16176fc11a6; not patch
N/M.

**Step 3.4:** Record: `[Author] Cen Zhang, recent ALSA usb-audio/seq
contributor; not the maintainer. [Maintainer] Takashi Iwai applied it.
Sibling MIDI2 UAF fix from the same author already went to this stable
tree.`

**Step 3.5:** Record: `[Dependencies] All callees exist at v6.18:
snd_usb_stream_disconnect, snd_usb_endpoint_release,
snd_usbmidi_disconnect, snd_usb_midi_v2_disconnect_all,
snd_media_device_delete, snd_usb_mixer_disconnect. No snd_refcount_sync
requirement in this tree. Can apply standalone.`

## Phase 4: Mailing list / external

**Step 4.1:** Record: `[Lore]
https://patch.msgid.link/20260618170026.192212-1-zzzccc427@gmail.com`
via `b4 dig -c 3213bf9885e3356fff12ac18b12d4c2fb4687734`. `[Revisions]
v1 only. [Review] Takashi Iwai 2026-06-29: “Applied to for-next branch
now. Thanks.” No NAK, no requested changes, no stable nomination in-
thread.`

**Step 4.2:** Record: `[Recipients from b4 dig -w] Cen Zhang, Jaroslav
Kysela, Takashi Iwai, linux-sound, linux-kernel, baijiaju1990@gmail.com.
Subsystem maintainers were on the original To/Cc.`

**Step 4.3:** Record: `[No Reported-by / syzbot / bugzilla on this
commit.] The same-day sibling MIDI2 commit documented KASAN slab-UAF in
input_urb_complete() on a probe error path; that is the same class of
bug, different call site.`

**Step 4.4:** Record: `[Related] MIDI2 URB-kill patch (msgid
20260618170010.191433-1), submitted ~16s earlier, already in this tree.
This patch is still needed for the successful-create-then-later-probe-
fail path.`

**Step 4.5:** Record: `[stable list] Not searched successfully via
WebFetch (lore 403). b4 thread has no stable discussion. UNVERIFIED: no
evidence this was NAK’d for stable.`

## Phase 5: Code semantic analysis

**Step 5.1:** Record: `[usb_audio_disconnect_components (new),
usb_audio_probe, __usb_audio_disconnect]`

**Step 5.2:** Record: `usb_audio_probe` is `usb_audio_driver.probe` —
USB enumeration / hub_event. `__usb_audio_disconnect` is the unplug
path. The new helper is also used from that path. High-frequency driver;
CONFIG_SND_USB_AUDIO is common.

**Step 5.3:** Record: helper calls `snd_usb_stream_disconnect` (NULL
endpoint pointers), `snd_usb_endpoint_release` → `release_urbs()`,
`snd_usbmidi_disconnect` (kill MIDI1 URBs),
`snd_usb_midi_v2_disconnect_all` (set disconnected, kill/drain MIDI2
URBs), `snd_media_device_delete`, `snd_usb_mixer_disconnect`
(`usb_kill_urb` on mixer/rc URBs).

**Step 5.4:** Record: `[Reachable] Plug a USB audio/MIDI device whose
first interface creates streams/mixer/MIDI, then a later probe step
fails (bad descriptor, mixer fail, snd_card_register fail, device
yanked). No extra ioctl required. MIDI2 `start_input_streams()` runs
inside `snd_usb_midi_v2_create()` from `snd_usb_create_stream()` before
mixer/register. Mixer `usb_submit_urb(mixer->urb)` runs in mixer create
before register.`

**Step 5.5:** Record: Same-day MIDI2 free-path UAF fix; historical UAF
on this exact `num_interfaces==0` free path; other USB sound probe-error
URB leaks (caiaq, line6). Pattern is systematic: probe error must stop
URBs before freeing the card.

## Phase 6: Local tree (6.18.y)

**Step 6.1:** Record: `[Local tree] v6.18.53 (`git describe HEAD` =
v6.18.53-5049-g0f0bdc2b0dffb). `[Buggy code at v6.18] sound/usb/card.c
__error_no_register: atomic_dec(&chip->active); if
(!chip->num_interfaces) snd_card_free(chip->card);` with no component
disconnect. MIDI2 create/start-input and mixer URB submit exist at
v6.18.`

**Step 6.2:** Record: `[Backport difficulty: clean / already matching
this tree.] The only mainline delta vs 6.18 is `snd_refcount_sync()` vs
`wait_event(...)` in the disconnect wait, which this tree correctly
keeps. Helper callees and list fields (`pcm_list`, `ep_list`,
`midi_list`, `mixer_list`) are present.`

**Step 6.3:** Record: `[4c16176fc11a6 is already here]` and does not
replace this fix. No other equivalent probe-error disconnect helper.

## Phase 7: Subsystem context

**Step 7.1:** Record: `[sound/usb-audio] [IMPORTANT]` — default USB
sound driver on desktops, laptops, docks, headsets; not staging.

**Step 7.2:** Record: `[Mature driver, still active.] USB MIDI 2.0
(2023) increased the cost of skipping disconnect, because input URBs now
start at create, not at open.`

## Phase 8: Impact and risk

**Step 8.1:** Record: `[driver-specific, but a very widely used driver]`
CONFIG_SND_USB_AUDIO users; worse on MIDI 2.0 devices.

**Step 8.2:** Record: `[Trigger] first-interface usb_audio_probe()
failure after streams/mixer/MIDI construction. [Likelihood] not every
boot, but ordinary for flaky/unplug-during-enum/bad-descriptor devices.
[Unprivileged] plugging USB audio is enough; no extra privilege needed
for the URB/completion race.`

**Step 8.3:** Record: `[Failure] use-after-free / use-during-teardown
from in-flight mixer or MIDI2 URBs while snd_card_free() runs
snd_device_free_all() (UMP/rawmidi private_free, mixer kctl, then chip
private_free). Confirmed mechanism: input_urb_complete() →
snd_ump_receive(ep->ump) while UMP is an snd_device freed before chip
private_free. [Severity: HIGH]` crash or memory corruption on probe
failure; same class as the already-backported MIDI2 KASAN UAF.

**Step 8.4:** Record: `[Benefit: high] closes a real probe-error UAF
window on a common driver. [Risk: low] ~one extra call of existing
disconnect code, idempotent vs later free. [Ratio: favorable]`

## Phase 9: Synthesis

**Step 9.1:**
- FOR: real bug; first-interface probe error skips disconnect; MIDI2
  URBs and mixer interrupt URBs are live then; snd_card_free frees ALSA
  devices before chip private_free; helper is existing disconnect code;
  small; maintainer applied v1; helpers exist in 6.18; sibling MIDI2 fix
  does not cover this ordering.
- AGAINST: no Fixes/Reported-by/syzbot on this exact commit; AI-
  assisted; some objects also self-disconnect in their destructors
  (mixer_free, snd_usbmidi_free), so not every component crashes every
  time.
- UNRESOLVED: lore.kernel.org HTTP 403 via WebFetch; no independent
  stable-list thread found.

**Step 9.2:** Stable rules:
1. Obviously correct and tested? **PASS** — move-existing-sequence +
   maintainer applied.
2. Real user-visible bug? **PASS** — probe-error UAF/teardown skip on
   USB audio.
3. Important (crash/UAF)? **PASS** — HIGH; in-flight URB vs card free.
4. Small/contained? **PASS** — one file, ~70-line net-neutral extract +
   2-line call.
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** — bug and callees present at v6.18;
   wait_event form already matches.

**Step 9.3:** Record: `[Not an exception category; it is a normal error-
path UAF/resource-teardown fix.]`

**Step 9.4:** Backport to this 6.18.y tree on technical merit.

### Why it matters here
`usb_audio_probe()` can build PCM, endpoints, MIDI (including MIDI 2.0
input URBs) and mixer status URBs before `chip->num_interfaces++`. If
that first probe fails, 6.18 only does `snd_card_free()`. ALSA then
frees rawmidi/UMP and mixer devices while USB completions can still run,
and only afterwards runs `snd_usb_audio_free()`. Unplug already stops
those components first; probe error did not.

### Risk vs benefit
Benefit is avoiding oops/UAF when USB audio probe fails. Risk is low:
the helper is the current disconnect body, and free paths already
tolerate a prior disconnect.

### Concerns
Mainline’s `snd_refcount_sync()` is not in 6.18; it must keep
`wait_event`. That is already how this tree’s disconnect path looks, so
no extra prerequisite. The earlier MIDI2 URB-kill backport is necessary
but not sufficient.

Verification:
- [Phase 1] Parsed subject/body/tags: no Fixes/Reported-by; maintainer
  SOB; Codex assisted
- [Phase 2] Diff: helper extracted from `__usb_audio_disconnect`, called
  from `!num_interfaces` probe error before `snd_card_free()`
- [Phase 2] Confirmed mixer URB submit at create
  (`usb_submit_urb(mixer->urb)` in mixer.c); MIDI2
  `start_input_streams()` during `snd_usb_midi_v2_create()`
- [Phase 2] Confirmed `snd_card` release: `snd_device_free_all()` then
  `card->private_free`; UMP is a rawmidi snd_device
- [Phase 2] Confirmed `input_urb_complete()` uses `ep->ump` unless
  `ep->disconnected`
- [Phase 3] `git blame` on pre-fix error path: 61a6a108d15213 (2011)
- [Phase 3] `git merge-base --is-ancestor 4c16176fc11a6 HEAD` — sibling
  MIDI2 UAF fix is in this tree and does not call disconnect before
  `snd_card_free()`
- [Phase 3] Historical UAF on same path: 5f8cf71258261
- [Phase 4] `b4 dig -c 3213bf9885e3356fff12ac18b12d4c2fb4687734` → msgid
  20260618170026.192212-1; v1 only; Iwai applied; To/Cc linux-sound +
  Iwai + Kysela
- [Phase 4] WebFetch lore/msgid.link returned 403; discussion recovered
  via `b4 dig -m`
- [Phase 5] `usb_audio_probe` is the usb_driver probe; MIDI created from
  `snd_usb_create_stream()`
- [Phase 6] `git describe HEAD` = v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion` = 6.18.53
- [Phase 6] `git grep error_no_register v6.18 -- sound/usb/card.c` shows
  bare `snd_card_free` with no disconnect
- [Phase 6] v6.18 has `snd_usb_midi_v2_disconnect_all` and
  `snd_usb_endpoint_release`
- [Phase 8] Failure mode: UAF from live MIDI2/mixer URBs during
  `snd_card_free()`, severity HIGH
- UNVERIFIED: stable@ mailing list thread (lore HTTP 403)

**YES**

 sound/usb/card.c | 70 ++++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 85249606a6b18..d8e096f71412a 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -904,6 +904,40 @@ static int try_to_register_card(struct snd_usb_audio *chip, int ifnum)
 	return 0;
 }
 
+static void usb_audio_disconnect_components(struct snd_usb_audio *chip)
+{
+	struct snd_usb_stream *as;
+	struct snd_usb_endpoint *ep;
+	struct usb_mixer_interface *mixer;
+	struct list_head *p;
+
+	/* release the pcm resources */
+	list_for_each_entry(as, &chip->pcm_list, list) {
+		snd_usb_stream_disconnect(as);
+	}
+	/* release the endpoint resources */
+	list_for_each_entry(ep, &chip->ep_list, list) {
+		snd_usb_endpoint_release(ep);
+	}
+	/* release the midi resources */
+	list_for_each(p, &chip->midi_list) {
+		snd_usbmidi_disconnect(p);
+	}
+	snd_usb_midi_v2_disconnect_all(chip);
+	/*
+	 * Nice to check quirk && quirk->shares_media_device and
+	 * then call the snd_media_device_delete(). Don't have
+	 * access to the quirk here. snd_media_device_delete()
+	 * accesses mixer_list
+	 */
+	snd_media_device_delete(chip);
+
+	/* release mixer resources */
+	list_for_each_entry(mixer, &chip->mixer_list, list) {
+		snd_usb_mixer_disconnect(mixer);
+	}
+}
+
 /*
  * probe the active usb device
  *
@@ -1076,8 +1110,10 @@ static int usb_audio_probe(struct usb_interface *intf,
 		 * decrement before memory is possibly returned.
 		 */
 		atomic_dec(&chip->active);
-		if (!chip->num_interfaces)
+		if (!chip->num_interfaces) {
+			usb_audio_disconnect_components(chip);
 			snd_card_free(chip->card);
+		}
 	}
 	return err;
 }
@@ -1090,49 +1126,19 @@ static bool __usb_audio_disconnect(struct usb_interface *intf,
 				   struct snd_usb_audio *chip,
 				   struct snd_card *card)
 {
-	struct list_head *p;
-
 	guard(mutex)(&register_mutex);
 
 	if (platform_ops && platform_ops->disconnect_cb)
 		platform_ops->disconnect_cb(chip);
 
 	if (atomic_inc_return(&chip->shutdown) == 1) {
-		struct snd_usb_stream *as;
-		struct snd_usb_endpoint *ep;
-		struct usb_mixer_interface *mixer;
-
 		/* wait until all pending tasks done;
 		 * they are protected by snd_usb_lock_shutdown()
 		 */
 		wait_event(chip->shutdown_wait,
 			   !atomic_read(&chip->usage_count));
 		snd_card_disconnect(card);
-		/* release the pcm resources */
-		list_for_each_entry(as, &chip->pcm_list, list) {
-			snd_usb_stream_disconnect(as);
-		}
-		/* release the endpoint resources */
-		list_for_each_entry(ep, &chip->ep_list, list) {
-			snd_usb_endpoint_release(ep);
-		}
-		/* release the midi resources */
-		list_for_each(p, &chip->midi_list) {
-			snd_usbmidi_disconnect(p);
-		}
-		snd_usb_midi_v2_disconnect_all(chip);
-		/*
-		 * Nice to check quirk && quirk->shares_media_device and
-		 * then call the snd_media_device_delete(). Don't have
-		 * access to the quirk here. snd_media_device_delete()
-		 * accesses mixer_list
-		 */
-		snd_media_device_delete(chip);
-
-		/* release mixer resources */
-		list_for_each_entry(mixer, &chip->mixer_list, list) {
-			snd_usb_mixer_disconnect(mixer);
-		}
+		usb_audio_disconnect_components(chip);
 	}
 
 	if (chip->quirk_flags & QUIRK_FLAG_DISABLE_AUTOSUSPEND)
-- 
2.53.0

