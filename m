Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53622DE1E7;
	Tue, 17 Jun 2025 12:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750162947; cv=none; b=d8vDMQRRCndnBfhTIR5ErEgKjBWM9K6Alm6N4KX0sjEfIXSjkc5zErP4jPP1MqmJT1vb3M43F8m1XgyyRmrPY9wtrEPjaWVwYh3RdwwsfClkmICE7i3pttshAxKfsFw6v8fdJIipn1xLbhqsxo++8QAqbgr8nj4tNQH/srvkTV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750162947; c=relaxed/simple;
	bh=/Sxb9tbEBR9oK11SSHWoCqhfech9mjueso2ZqqCrIYs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d1Q1LiEPW5mDgSI0VG09DqtJ36aiVwlUwAaIEq2CXItB1HpKsbyxCRXHRccwa8/GSn+vXwcuIAvaYTHWVV8A0Mx68IpmOv6r0fFLU+xLPj5ez6qEJ5Jq4fpaW9YNwBkpLTLC9R2TGsvjIQi2fVDwrfXd5dBd6t0Nh/BdOP5g/L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UMUv41dD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMUv41dD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8442EC4CEE3;
	Tue, 17 Jun 2025 12:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750162947;
	bh=/Sxb9tbEBR9oK11SSHWoCqhfech9mjueso2ZqqCrIYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMUv41dD70AvVxXb5G5E9O9ORZ3jlHSEr1qrdaZtBuVCK0Z6hU3cuVtfS19IjSwWH
	 7/GOl43dtF5pQx3KRkMY1T/08bASooYdCPX2FQRK8lEWQ2Fu7AsZU4SR+lH0vq5Hq/
	 momtUtDTTPht98ad9rA4XfUdPMLkTcEH/r3+bAaob8MHBIM/E4aNPzDsKKd4gztG50
	 w9h/syGATS9fkjeFqf3fYw5i0sQRy3bHu07BZHtIZpMtzwpYDurSF597k6nWRGd2qZ
	 40NWFd9Apg3jUzQqCr+P3jvcod/EgavgbX6Sbtsq38TRcLywQJInajv6LRr11Ahrg/
	 6P3az9+XUooTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org
Subject: [PATCH AUTOSEL 6.12 02/12] ALSA: hda: Ignore unsol events for cards being shut down
Date: Tue, 17 Jun 2025 08:22:11 -0400
Message-Id: <20250617122222.1968832-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250617122222.1968832-1-sashal@kernel.org>
References: <20250617122222.1968832-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.33
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
index b7ca2a83fbb08..95786bdadfe6a 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -44,7 +44,7 @@ static void hda_codec_unsol_event(struct hdac_device *dev, unsigned int ev)
 	struct hda_codec *codec = container_of(dev, struct hda_codec, core);
 
 	/* ignore unsol events during shutdown */
-	if (codec->bus->shutdown)
+	if (codec->card->shutdown || codec->bus->shutdown)
 		return;
 
 	/* ignore unsol events during system suspend/resume */
-- 
2.39.5

