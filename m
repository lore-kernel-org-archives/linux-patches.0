Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB056413256;
	Tue, 20 Jan 2026 19:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768937699; cv=none; b=ijMMbyLQKDoOqNozkfR0vO2+0Qks57SIWC+UQNOewvm1t+a7NlQx5GJuWMiI8KLUebcQ40i+M+945uDKfUbbY4SmA79HYoofQUxi+FtGRH0y0OkKFWNrZ1aBMAtURGiub/vPQi06oosZYouG/IeSERuqMN3A24n+u/JMdL+8nuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768937699; c=relaxed/simple;
	bh=+FN4NLJz2Xi8BFI9u8FMKXPFYtA0LfaOjTVZbIKOaHU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=K4MLl1Nz2g+UKnQQOSoy0DKdvrB5OJ0ZMRToCOpfR0uXLkZsSk7e7tndZ2xczf2/MWHDp76G7bQiFAyv+uLeVyuaiocY+VvlksALcJm1ONER5VnGKOnTiuTc3xUWR0HxYq/fs9LkR8ds8IwLcGQ/ssQrQz7nNQ2Mn3fhixUzRXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pzmS9ShC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pzmS9ShC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B42C16AAE;
	Tue, 20 Jan 2026 19:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768937699;
	bh=+FN4NLJz2Xi8BFI9u8FMKXPFYtA0LfaOjTVZbIKOaHU=;
	h=From:To:Cc:Subject:Date:From;
	b=pzmS9ShCNogwlDL+mPc/kuH6E4kexlcZZ1YGmYfGJAE2VxErxBVpMfiM/tCtGBCqF
	 DiT4DqFqJ6uRiK6cgSZZKfL2xONseUlU0Vj33tGV8YkvGLojKvsEx0rcMSfkjiGu7g
	 5qMJ2yM3U1WQtOweO6SL2CNKMhmLNcgEfTTQnqjtMxfi0HFgnojzTRLYB1oEzKWEzd
	 +TRK6fhr9fP56VQx4qMDKMAOzT5PWhwLK8xwYsXsb1KrGLIP4P61T1/htRgt4Wb9RO
	 Bf7KR1tuSJnkY0mEIgtC5Wxa3dGfTHAZ3D5TjWf8sKvpb4cTGQcMMuof1oLR2H2QLb
	 MVdBenKhagjrg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Edward Adam Davis <eadavis@qq.com>,
	syzbot+6db0415d6d5c635f72cb@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	quic_wcheng@quicinc.com,
	broonie@kernel.org,
	pierre-louis.bossart@linux.dev,
	gregkh@linuxfoundation.org,
	sean.anderson@linux.dev
Subject: [PATCH AUTOSEL 6.18] ALSA: usb-audio: Prevent excessive number of frames
Date: Tue, 20 Jan 2026 14:34:44 -0500
Message-ID: <20260120193456.865383-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit ef5749ef8b307bf8717945701b1b79d036af0a15 ]

In this case, the user constructed the parameters with maxpacksize 40
for rate 22050 / pps 1000, and packsize[0] 22 packsize[1] 23. The buffer
size for each data URB is maxpacksize * packets, which in this example
is 40 * 6 = 240; When the user performs a write operation to send audio
data into the ALSA PCM playback stream, the calculated number of frames
is packsize[0] * packets = 264, which exceeds the allocated URB buffer
size, triggering the out-of-bounds (OOB) issue reported by syzbot [1].

Added a check for the number of single data URB frames when calculating
the number of frames to prevent [1].

[1]
BUG: KASAN: slab-out-of-bounds in copy_to_urb+0x261/0x460 sound/usb/pcm.c:1487
Write of size 264 at addr ffff88804337e800 by task syz.0.17/5506
Call Trace:
 copy_to_urb+0x261/0x460 sound/usb/pcm.c:1487
 prepare_playback_urb+0x953/0x13d0 sound/usb/pcm.c:1611
 prepare_outbound_urb+0x377/0xc50 sound/usb/endpoint.c:333

Reported-by: syzbot+6db0415d6d5c635f72cb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6db0415d6d5c635f72cb
Tested-by: syzbot+6db0415d6d5c635f72cb@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://patch.msgid.link/tencent_9AECE6CD2C7A826D902D696C289724E8120A@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. `max_urb_frames` has been in the kernel since 2013. Now let me
understand the vulnerability better and confirm the fix is appropriate:

## Summary of Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly describes:
- A **KASAN-detected slab-out-of-bounds write** in `copy_to_urb()` at
  sound/usb/pcm.c:1487
- The root cause: User-controllable parameters can create a scenario
  where `packsize[0] * packets = 264` exceeds the URB buffer size of
  `maxpacksize * packets = 240`
- The fix: Add a check to prevent `frames + counts` from exceeding
  `ep->max_urb_frames`
- It has **"Reported-by: syzbot"** and **"Tested-by: syzbot"** tags,
  confirming this is a real bug that's been reproduced and verified as
  fixed

### 2. CODE CHANGE ANALYSIS

**The bug mechanism:**
1. URB buffer is allocated as `maxsize * packets` (e.g., 40 * 6 = 240
   bytes)
2. The loop iterates through `ctx->packets` (e.g., 6 packets)
3. For each packet, `snd_usb_endpoint_next_packet_size()` returns a
   count (e.g., alternating 22 and 23 frames)
4. The accumulated `frames` variable sums up: 22 + 23 + 22 + 23 + ... =
   potentially 264 frames
5. This exceeds the 240-byte buffer, causing the OOB write in
   `copy_to_urb()`

**The fix:**
```c
- if (counts < 0)
+                       if (counts < 0 || frames + counts >=
ep->max_urb_frames)
                                break;
```

This adds a bounds check that stops the loop if adding the next packet's
frames would exceed `max_urb_frames`. This is a **defensive check** that
ensures the total frames never exceed what the allocated buffer can
hold.

### 3. CLASSIFICATION

- **Type:** Security fix - heap buffer overflow (OOB write)
- **Category:** Memory safety bug fix
- **Severity:** HIGH - This is a write-based memory corruption that
  could lead to privilege escalation or kernel crash

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 1 line (just adds an additional condition to an
  existing check)
- **Files touched:** 1 file (sound/usb/pcm.c)
- **Complexity:** Minimal - straightforward bounds check
- **Risk of regression:** Very low - this only adds a safety check to
  break out of a loop early; it doesn't change any other behavior
- **Subsystem:** USB audio (widely used for USB headsets, microphones,
  DACs)

### 5. USER IMPACT

- **Affected users:** Anyone using USB audio devices
- **Attack surface:** This can be triggered through the ALSA PCM
  interface, which is accessible to local users. The fuzzer found this
  through the OSS compatibility layer.
- **Severity if bug hits:** Kernel memory corruption, potential for code
  execution or denial of service

### 6. STABILITY INDICATORS

- **Reported-by: syzbot** - Found by continuous kernel fuzzing
- **Tested-by: syzbot** - Verified by the automated test infrastructure
- **Signed-off-by: Takashi Iwai** - The USB audio maintainer accepted
  and merged this

### 7. DEPENDENCY CHECK

The fix uses `ep->max_urb_frames`, which has existed since kernel 3.12
(2013). The code path being fixed (the lowlatency playback mode with
`snd_usb_endpoint_next_packet_size` taking 4 args including `avail`) was
introduced in v5.16. The fix should cleanly apply to any kernel with
this code path (5.16+).

## Conclusion

This commit is an **excellent candidate for stable backport**:

1. ✅ **Fixes a real, serious bug**: KASAN-detected heap buffer overflow
   (OOB write)
2. ✅ **Security relevant**: Memory corruption that could lead to
   privilege escalation
3. ✅ **Small and surgical**: Single line change with minimal risk
4. ✅ **Obviously correct**: Simple bounds check that prevents writing
   past allocated buffer
5. ✅ **Well tested**: Verified by syzbot, accepted by the USB audio
   maintainer
6. ✅ **No new features**: Pure bug fix
7. ✅ **Clear scope**: Only affects USB audio playback URB preparation

The fix prevents a heap buffer overflow that was found by syzkaller. The
change is minimal (adding one condition to an existing check), low-risk,
and obviously correct. It protects against a real security vulnerability
that could be exploited by local users.

**YES**

 sound/usb/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 54d01dfd820fa..263abb36bb2d1 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1553,7 +1553,7 @@ static int prepare_playback_urb(struct snd_usb_substream *subs,
 
 		for (i = 0; i < ctx->packets; i++) {
 			counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, avail);
-			if (counts < 0)
+			if (counts < 0 || frames + counts >= ep->max_urb_frames)
 				break;
 			/* set up descriptor */
 			urb->iso_frame_desc[i].offset = frames * stride;
-- 
2.51.0

