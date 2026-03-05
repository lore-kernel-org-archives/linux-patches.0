Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF073CA48F;
	Thu,  5 Mar 2026 15:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725037; cv=none; b=X8idQfWzrXzDyx9uw4uborLcIN5bM/tCrY6nwGRTKLAeRSzS1juM1R/LUYR1zamiAX6JvjKymjARYNXYxCEzoJpoN15KjXCvz4JSafdiqSIWaKa2YxkSbjjOp1BKRVq25Q3MIOI8Cu0LczTIXqH8q+C5v02+R0nzeJwaeh3lUik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725037; c=relaxed/simple;
	bh=FHmnBZ6LO5fcizUa6QpAAItmvNQ2Huv8oWPcHLLbW3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+4gQhheOxxmZcoERRMLIG2GZPPl5JlLBTCylgW/dD1oZZra8BxeZkokWd8VNg0xB7DPW8ZqTmI2P7mpqRiT5xhOLPVf+NG7PIlqiWBN+jgld6XC4i1I4tOQACUy6uas+opHY9766dKyreXluu3aZ1r4gw+wN/i0WWCBFSrHX/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cq1Y/z8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cq1Y/z8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8D8C2BCAF;
	Thu,  5 Mar 2026 15:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772725037;
	bh=FHmnBZ6LO5fcizUa6QpAAItmvNQ2Huv8oWPcHLLbW3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cq1Y/z8dgpIBm1Z5+OtEr3x+VjzNtwoLRQmR+503OlegKXEvDjstTELy5f39nWQhM
	 bivF021Cy9o6jC87+sCEl8a8v00WZgMLDztzcMwCPXscj7l8fyJh8809lgeCd5e5mu
	 NP2CGGTzNA6MZsbO6hefEw67Wtceav0I/P7Etwon88/B82DqzDcVB4dAalS8WjgH77
	 uYV9mEZV5+We9kXzUabJuEjc5xLYJmZnoX0OHs3/5r9YwiQTfZda9k80f4iVvelTrv
	 M3kLOuigguaOXmcpruf/JED0/WLL9ciS1yKzgZdwAgIVcDOGOzoio4R0rIRzg6KpMl
	 xVBVW6yI5/R0Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] ALSA: usb-audio: Avoid implicit feedback mode on DIYINHK USB Audio 2.0
Date: Thu,  5 Mar 2026 10:36:51 -0500
Message-ID: <20260305153704.106918-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260305153704.106918-1-sashal@kernel.org>
References: <20260305153704.106918-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c5bf24c8aba1ff711226ee0f039ff01a5754692b ]

Although DIYINHK USB Audio 2.0 (ID 20b1:2009) shows the implicit
feedback source for the capture stream, this would cause several
problems for the playback.  Namely, the device can get wMaxPackSize
1024 for 24/32 bit format with 6 channels, and when a high sample rate
like 352.8kHz or 384kHz is played, the packet size overflows the max
limit.  Also, the device has another two playback altsets, and those
aren't properly handled with the implicit feedback.

Since the device has been working well even before introducing the
implicit feedback, we can assume that it works fine in the async mode.
This patch adds the explicit skip of the implicit fb detection to make
the playback running in the async mode.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221076
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260225085233.316306-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Problem Description
This commit adds a USB audio device quirk for the DIYINHK USB Audio 2.0
device (VID 0x20b1, PID 0x2009) to skip implicit feedback mode. The
bugzilla report (#221076) documents a **kernel crash/oops** when playing
6-channel audio at high sample rates (352.8kHz/384kHz). The root cause
is that implicit feedback mode leads to packet sizes exceeding the
device's wMaxPacketSize of 1024 bytes, causing buffer overruns, URB
submission failures, and ultimately kernel panics.

### Stable Kernel Criteria Assessment

1. **Fixes a real bug**: YES - kernel crash/hard hang with specific
   hardware at high sample rates. The bugzilla report documents kernel
   oops with page faults in memset during URB preparation.

2. **Obviously correct and tested**: YES - it's a 2-line quirk flag
   addition by the ALSA maintainer (Takashi Iwai). The fix was confirmed
   working per the bugzilla discussion.

3. **Small and contained**: YES - adds exactly 2 lines to the quirk
   flags table. Zero risk to any other device.

4. **No new features**: Correct - this is a hardware workaround, not a
   feature.

5. **Category**: This falls squarely into the **hardware quirk**
   exception category, which is explicitly listed as always appropriate
   for stable backporting.

### Risk Assessment

- **Risk**: Essentially zero. The change only affects one specific USB
  device (0x20b1:0x2009). The `QUIRK_FLAG_SKIP_IMPLICIT_FB` flag is
  well-established (since 2022) and simply bypasses implicit feedback
  detection. The `QUIRK_FLAG_DSD_RAW` flag enables DSD format support,
  also well-established (since 2021).
- **Benefit**: Prevents kernel crashes/hangs for users of this specific
  USB audio device at high sample rates.

### Dependencies

The prerequisite infrastructure (`QUIRK_FLAG_SKIP_IMPLICIT_FB`
introduced in commit `0f1f7a6661394` from April 2022, and
`QUIRK_FLAG_DSD_RAW` from `68e851ee4cfd2` in July 2021) should be
present in all currently maintained stable trees (6.1+, 6.6+, etc.). The
patch is a simple table entry addition that should apply cleanly.

### Verification

- **Bugzilla link**
  (https://bugzilla.kernel.org/show_bug.cgi?id=221076): Confirmed real
  user-reported crash with kernel oops, page fault, and hard hangs at
  high sample rates on DIYINHK D2 device.
- **QUIRK_FLAG_SKIP_IMPLICIT_FB** defined in `sound/usb/usbaudio.h` and
  used in `sound/usb/implicit.c:390-391` to return early from implicit
  feedback setup - verified via agent exploration.
- **QUIRK_FLAG_DSD_RAW** defined in `sound/usb/usbaudio.h` and used in
  `sound/usb/quirks.c:2078-2079` - verified via agent exploration.
- **Both flags have existed since 2021-2022** (commits `68e851ee4cfd2`
  and `0f1f7a6661394`) - verified via git log, confirming they exist in
  stable trees.
- **Author is Takashi Iwai**, the ALSA subsystem maintainer - verified
  from commit authorship.
- **The change is a 2-line addition** to an existing quirk flags table
  with no logic changes - verified from the diff.

### Conclusion

This is a textbook stable backport candidate: a small, zero-risk
hardware quirk that fixes a real kernel crash reported by users,
authored by the subsystem maintainer, with well-established
infrastructure already present in stable trees.

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 86c329632e396..57c036ee9ba96 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2363,6 +2363,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x2040, 0x7281, /* Hauppauge HVR-950Q-MXL */
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
+	DEVICE_FLG(0x20b1, 0x2009, /* XMOS Ltd DIYINHK USB Audio 2.0 */
+		   QUIRK_FLAG_SKIP_IMPLICIT_FB | QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x2040, 0x8200, /* Hauppauge Woodbury */
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x21b4, 0x0081, /* AudioQuest DragonFly */
-- 
2.51.0

