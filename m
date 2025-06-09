Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A8A224895;
	Mon,  9 Jun 2025 22:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749509630; cv=none; b=VMn+pxl82EmOudvBTZpgfdgWjogEdUQIM42roMtNbcuqux0L82xKqj0MYTiLw3QfTE2WxXknjb8gYvsDnM7vZCflVF/1oPesfM8ZCId/EgOMhs+0knJuv53UHlLn2gzbugdX8HhW5gZRr/BOtzSY/dBhRj4uNst1O9m1PkGecBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749509630; c=relaxed/simple;
	bh=cr6TrgRk74mSFSu2uf0C5QP1ppn5CofU/y2XShPxTEs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ZgQ7WfwxJQ2q0pjH72aSb449UxarkfaU7M83WO9MXyRavrK9PX8xg2ThYs3ZGCg6mTa1thxlRl97wOy9nzXGfB+rPyp8GCuI3T35jvTZYEWbhzE2jB52QzsSlf9tzhqrOvEza9Pp4OT2ghCJt+6VIOFbjIZz7R4KrB1rTQGEkFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6kAH2xx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6kAH2xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F322EC4CEEB;
	Mon,  9 Jun 2025 22:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749509629;
	bh=cr6TrgRk74mSFSu2uf0C5QP1ppn5CofU/y2XShPxTEs=;
	h=From:To:Cc:Subject:Date:From;
	b=W6kAH2xxuiIzNGVPpK6q51n1E1DyQ49nQ6+3MJXjVDx9CrLmCsZxFykKvUZ5kjZ5f
	 XQWRvkxvTw7gsWRxQq5VKlfqdhBZo3Bt3q2bV51l/uaf6iPHouBEdLegfTXL6vzI7N
	 OJKa5fsILlkpNZNnxetQHFhW6Xw+xNCXgWgTR68aHF6WVR8hRpiogxy9c5fGJ3BOQT
	 LsNd7d+WfVU++YJ/8AxriTU89bBfcn8Oh3XEKB/NasKLTw585Gex8rj3Igvyr4YPL3
	 s5j2f7S/6nt6OobF72Xj44g9v/rCKX7wkuVo/SGhPfi72ptpwJsiIRdmTH4a7npjDK
	 +RL0643uYkYjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org
Subject: [PATCH AUTOSEL 6.1 1/5] ALSA: hda: Ignore unsol events for cards being shut down
Date: Mon,  9 Jun 2025 18:53:42 -0400
Message-Id: <20250609225347.1444397-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.141
Content-Transfer-Encoding: 8bit

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 3f100f524e75586537e337b34d18c8d604b398e7 ]

For the classic snd_hda_intel driver, codec->card and bus->card point to
the exact same thing. When snd_card_diconnect() fires, bus->shutdown is
set thanks to azx_dev_disconnect(). card->shutdown is already set when
that happens but both provide basically the same functionality.

For the DSP snd_soc_avs driver where multiple codecs are located on
multiple cards, bus->shutdown 'shortcut' is not sufficient. One codec
card may be unregistered while other codecs are still operational.
Proper check in form of card->shutdown must be used to verify whether
the codec's card is being shut down.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530141309.2943404-1-cezary.rojewski@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Technical Analysis

### Core Problem Being Fixed

The commit addresses a **shutdown race condition** in multi-codec HDA
systems, specifically in DSP/AVS drivers where multiple HDA codecs exist
on the same sound card but with separate bus instances. The change
modifies line 47 in `sound/pci/hda/hda_bind.c`:

**Before:**
```c
if (codec->bus->shutdown)
    return;
```

**After:**
```c
if (codec->card->shutdown || codec->bus->shutdown)
    return;
```

### Why This is a Good Backport Candidate

**1. Bug Fix Nature - Small and Contained**
- This is a clear **bug fix** addressing a specific shutdown race
  condition
- The change is **minimal** (adding one condition check) and **well-
  contained**
- No architectural changes or new features introduced
- Low risk of introducing regressions

**2. Critical Subsystem Impact**
- Affects **HD-audio subsystem** which is critical for audio
  functionality
- Could prevent system crashes or hangs during shutdown in multi-codec
  scenarios
- Improves system stability during shutdown sequences

**3. Technical Correctness**
The fix addresses a **fundamental timing issue**:
- In multi-codec systems, `card->shutdown` is set at the ALSA core level
  during `snd_card_disconnect()`
- `bus->shutdown` is set later at the HDA controller level during
  individual codec shutdown
- **Gap exists** where unsol events could be processed after card
  shutdown but before bus shutdown
- This can cause codec operations on an already-disconnected sound card

**4. Follows Stable Tree Criteria**
- **Important bug fix**: Prevents potential system instability during
  shutdown
- **Minimal risk**: Only adds an additional safety check, doesn't change
  existing logic
- **Well-understood**: The change is straightforward and follows
  existing patterns seen in similar commits
- **Confined to subsystem**: Only affects HDA audio subsystem

**5. Consistency with Similar Backported Commits**
This follows the exact same pattern as the historical commits that were
successfully backported:

- **Similar Commit #1**: Added `bus->shutdown` check to prevent unsol
  events during shutdown - **Backported (YES)**
- **Similar Commit #2**: Added suspend/resume state check to unsol
  handler - **Backported (YES)**
- **Similar Commit #3**: Added jack disconnection during codec unbind -
  **Backported (YES)**
- **Similar Commit #4**: Added bus_probing flag to serialize codec
  registration - **Backported (YES)**

All these commits follow the same pattern: **small, targeted fixes to
prevent race conditions in HDA shutdown/initialization sequences**.

**6. Real-World Impact**
- Affects **DSP/AVS audio systems** which are increasingly common in
  modern hardware
- Without this fix, systems with multiple audio codecs could experience:
  - Kernel oops during shutdown
  - System hangs
  - Audio subsystem corruption
  - Unpredictable behavior during reboot sequences

### Risk Assessment

**Very Low Risk:**
- The change only **adds** a safety check, doesn't remove existing
  functionality
- `card->shutdown` check is used extensively throughout the ALSA
  subsystem already
- Maintains **backward compatibility** completely
- If `card->shutdown` is false, behavior is identical to before
- No changes to data structures, APIs, or functional logic

### Conclusion

This commit represents a **textbook stable backport candidate**: it's a
small, well-understood bug fix that addresses a real stability issue in
a critical subsystem with minimal risk of regression. The pattern
matches multiple previously successful backports in the same subsystem,
and the technical merit is clear.

 sound/pci/hda/hda_bind.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index 890c2f7c33fc2..4c7355a0814d1 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -45,7 +45,7 @@ static void hda_codec_unsol_event(struct hdac_device *dev, unsigned int ev)
 	struct hda_codec *codec = container_of(dev, struct hda_codec, core);
 
 	/* ignore unsol events during shutdown */
-	if (codec->bus->shutdown)
+	if (codec->card->shutdown || codec->bus->shutdown)
 		return;
 
 	/* ignore unsol events during system suspend/resume */
-- 
2.39.5

