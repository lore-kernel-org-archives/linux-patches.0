Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9982F194098;
	Sat, 14 Feb 2026 01:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031115; cv=none; b=AG6mdjrHj7GHuyNokXbOSVaai9OsG/Nn3sym2Pb6QH6+8abZiecWH0zb80x0tCb86D17HlBKmQTcftewYBeqTYDvfQvpv3af9tR4dC1yzeiyXfZ7vzt4HgnAupXnhNjWEfkLBSEjurndb/fbyZxiz7bfWyF2oMm/dnek1vnabsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031115; c=relaxed/simple;
	bh=mZ9Y2BSV2Mx7Qd+OzAKLZ7Xevch/oReqaOSvD0g+A5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JVXqzcs9UWUAkZcxw8S24b4kiwnIr8X7CAbvr9F4IF06KpiyrWwnkV0TEsp44sN2jdZCjsx3Lx9ARhjK9iJLa/5bHhkVljzvq+wpCYiNPN2kXge9GBBTbbAcTyaTVxLG7iHe9kmJdpq4xZvnA9sFKxsHRMO0GAztGiGSikUfbok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o79SjLpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o79SjLpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A22C16AAE;
	Sat, 14 Feb 2026 01:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031115;
	bh=mZ9Y2BSV2Mx7Qd+OzAKLZ7Xevch/oReqaOSvD0g+A5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o79SjLpV942IYXLtnIs8w/xEefnOP8Oq2W7DC7P7602gAGu0oUAB4dqTq2+fS/mDo
	 qmi2bBMphgCxZOI8X01W3MUYjgAwUz/QLee78SnkVhJg9Yu9BdI7Mm5hm+gtkPQyjI
	 pruAMFFHWz1UqEZLpAPlFd5jI/iYGaPIRdO4UTONF2zrlSeDffIp2+6bPNIfuqL01o
	 K4z+QbEnhbuX96p/BSOMYH4ithxphn2uIITDUyfdHXQUXxQXU+Q+K7duRjiNwyYZGD
	 TIEUyB79Sa++KXj/tMkRloS8dccC/gmjj7h0yfGc2qJmkPDQYOivllOCcPztQR6ev2
	 setIEpU92JuHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	dan.carpenter@linaro.org,
	yelangyan@huaqin.corp-partner.google.com,
	thorsten.blum@linux.dev
Subject: [PATCH AUTOSEL 6.19-6.12] ALSA: mixer: oss: Add card disconnect checkpoints
Date: Fri, 13 Feb 2026 19:59:07 -0500
Message-ID: <20260214010245.3671907-67-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 084d5d44418148662365eced3e126ad1a81ee3e2 ]

ALSA OSS mixer layer calls the kcontrol ops rather individually, and
pending calls might be not always caught at disconnecting the device.

For avoiding the potential UAF scenarios, add sanity checks of the
card disconnection at each entry point of OSS mixer accesses.  The
rwsem is taken just before that check, hence the rest context should
be covered by that properly.

Link: https://patch.msgid.link/20260209121212.171430-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of ALSA: mixer: oss: Add card disconnect checkpoints

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and explicit about the problem:
- **Problem**: ALSA OSS mixer layer calls kcontrol ops individually, and
  pending calls might not be caught during device disconnection.
- **Impact**: "potential UAF scenarios" — Use-After-Free is explicitly
  mentioned.
- **Fix**: Add `card->shutdown` checks at each entry point of OSS mixer
  accesses, right after the rwsem is taken.
- **Author**: Takashi Iwai (tiwai@suse.de) — the ALSA subsystem
  maintainer, one of the most prolific and trusted kernel developers.

### 2. CODE CHANGE ANALYSIS

The patch adds **exactly the same pattern** in 8 different locations
within `sound/core/oss/mixer_oss.c`:

```c
guard(rwsem_read)(&card->controls_rwsem);
+if (card->shutdown)
+    return;  // or return -ENODEV;
```

Each check is placed **immediately after** the read semaphore
(`controls_rwsem`) is acquired and **before** any kcontrol operations
(`snd_ctl_find_numid`, `kctl->info`, `kctl->get`, `kctl->put`).

**Functions modified:**
1. `snd_mixer_oss_get_volume1_vol()` — returns void
2. `snd_mixer_oss_get_volume1_sw()` — returns void
3. `snd_mixer_oss_put_volume1_vol()` — returns void
4. `snd_mixer_oss_put_volume1_sw()` — returns void
5. `snd_mixer_oss_get_recsrc2()` — returns -ENODEV
6. `snd_mixer_oss_put_recsrc2()` — returns -ENODEV
7. `snd_mixer_oss_build_test()` — returns -ENODEV
8. `snd_mixer_oss_build_input()` — returns -ENODEV

**Bug mechanism**: When a sound card is being disconnected (hot-unplug,
e.g., USB audio device removal), the card's resources are being torn
down. If an OSS mixer operation is in progress or initiated
concurrently, it may access kcontrol objects that have been freed,
resulting in a use-after-free. The `card->shutdown` flag is set during
disconnection, and checking it under the rwsem provides a safe
synchronization point.

### 3. CLASSIFICATION

- **Bug fix**: YES — prevents UAF on device disconnect
- **Security relevance**: UAF bugs can be exploitable, especially from
  userspace-accessible paths like OSS mixer ioctls
- **Feature addition**: NO — purely defensive checks

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: ~16 lines of actual code additions (8 identical
  2-line blocks)
- **Files touched**: 1 file (`sound/core/oss/mixer_oss.c`)
- **Pattern**: Extremely simple and repetitive — same 2-line check in
  each function
- **Risk**: Extremely low. The check simply returns early (void
  functions) or returns -ENODEV (error code functions) when the card is
  shutting down. This cannot break normal operation since
  `card->shutdown` is only set during disconnection.
- **Regression potential**: Near zero. The early return during shutdown
  is the correct behavior — there's nothing useful to do with a
  disconnecting card.

### 5. USER IMPACT

- **Who is affected**: Users of USB audio devices (or any hot-pluggable
  sound devices) using the OSS compatibility layer
- **Trigger**: Unplugging a USB audio device while OSS mixer operations
  are in progress
- **Severity**: UAF can cause kernel crashes, memory corruption, or
  potential security exploitation
- **Real-world scenario**: Very realistic — USB audio devices are
  commonly hot-plugged, and the OSS mixer layer is used by legacy
  applications

### 6. STABILITY INDICATORS

- **Author**: Takashi Iwai is the ALSA maintainer — he knows this code
  intimately
- **Pattern**: This `card->shutdown` check pattern is already used
  extensively in other ALSA paths. This commit simply extends the
  protection to the OSS mixer layer that was missing it.
- **Simplicity**: The change is mechanical and obviously correct

### 7. DEPENDENCY CHECK

- The `card->shutdown` flag and the `controls_rwsem` already exist in
  all stable kernel versions
- The `guard(rwsem_read)` and `scoped_guard` cleanup macros are
  relatively modern (6.5+), so older stable trees may need minor
  backport adjustments to use explicit `down_read`/`up_read` instead
- No other commit dependencies — this is self-contained

### Summary

This is a textbook stable backport candidate:
- Fixes a real UAF bug that can be triggered by common user actions
  (hot-unplugging USB audio)
- Written by the subsystem maintainer
- Extremely small, surgical, and repetitive change (same 2-line pattern
  × 8)
- Uses an established defensive pattern already present in other ALSA
  code paths
- Near-zero regression risk
- Single file, single concern

**YES**

 sound/core/oss/mixer_oss.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index e839a4bb93f81..aa98caaaea3c5 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -525,6 +525,8 @@ static void snd_mixer_oss_get_volume1_vol(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	guard(rwsem_read)(&card->controls_rwsem);
+	if (card->shutdown)
+		return;
 	kctl = snd_ctl_find_numid(card, numid);
 	if (!kctl)
 		return;
@@ -558,6 +560,8 @@ static void snd_mixer_oss_get_volume1_sw(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	guard(rwsem_read)(&card->controls_rwsem);
+	if (card->shutdown)
+		return;
 	kctl = snd_ctl_find_numid(card, numid);
 	if (!kctl)
 		return;
@@ -618,6 +622,8 @@ static void snd_mixer_oss_put_volume1_vol(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	guard(rwsem_read)(&card->controls_rwsem);
+	if (card->shutdown)
+		return;
 	kctl = snd_ctl_find_numid(card, numid);
 	if (!kctl)
 		return;
@@ -655,6 +661,8 @@ static void snd_mixer_oss_put_volume1_sw(struct snd_mixer_oss_file *fmixer,
 	if (numid == ID_UNKNOWN)
 		return;
 	guard(rwsem_read)(&card->controls_rwsem);
+	if (card->shutdown)
+		return;
 	kctl = snd_ctl_find_numid(card, numid);
 	if (!kctl)
 		return;
@@ -792,6 +800,8 @@ static int snd_mixer_oss_get_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 	if (uinfo == NULL || uctl == NULL)
 		return -ENOMEM;
 	guard(rwsem_read)(&card->controls_rwsem);
+	if (card->shutdown)
+		return -ENODEV;
 	kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
 	if (!kctl)
 		return -ENOENT;
@@ -835,6 +845,8 @@ static int snd_mixer_oss_put_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 	if (uinfo == NULL || uctl == NULL)
 		return -ENOMEM;
 	guard(rwsem_read)(&card->controls_rwsem);
+	if (card->shutdown)
+		return -ENODEV;
 	kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
 	if (!kctl)
 		return -ENOENT;
@@ -878,6 +890,8 @@ static int snd_mixer_oss_build_test(struct snd_mixer_oss *mixer, struct slot *sl
 	int err;
 
 	scoped_guard(rwsem_read, &card->controls_rwsem) {
+		if (card->shutdown)
+			return -ENODEV;
 		kcontrol = snd_mixer_oss_test_id(mixer, name, index);
 		if (kcontrol == NULL)
 			return 0;
@@ -1002,6 +1016,8 @@ static int snd_mixer_oss_build_input(struct snd_mixer_oss *mixer,
 	if (snd_mixer_oss_build_test_all(mixer, ptr, &slot))
 		return 0;
 	guard(rwsem_read)(&mixer->card->controls_rwsem);
+	if (mixer->card->shutdown)
+		return -ENODEV;
 	kctl = NULL;
 	if (!ptr->index)
 		kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
-- 
2.51.0

