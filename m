Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4C5369980;
	Mon, 23 Feb 2026 12:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850296; cv=none; b=Nnvc05DVsEdAmk2BoYh/CH989q3jlv9KnZltvARwSLF0fGylTMETBy4p0cQteRHmbmHQApXi4sH0Dz7t9lE8qN0ChzK3OdZp/TwZRND8g2dcXq2T+XGdThZKkjJpkTc4J+aYG/O9EMspQe4SF8+s3SO1+G+Cv3+1lTCG5RhjNP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850296; c=relaxed/simple;
	bh=S/5Sg1QaN/ZPsrUGbMZye4NSw0Cx7AOMez0I6MYtngI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NeW9A+7xLXvusII0DtHCS9I8CE4z9AHkEbFQD+5EEKDeODa4aqAWbW52FrIzJi5hgfjNYUFhZyyu+z/V7HzyGzyBq9FckFPTddKLmJQmtJ1N8ZG5zgzKKwBjzf8lwLZUJCAh+KsmBI2MBuWFLomV2gCd1XILLsY1f6pB2L2bnDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ts7NayFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ts7NayFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3024C116C6;
	Mon, 23 Feb 2026 12:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850295;
	bh=S/5Sg1QaN/ZPsrUGbMZye4NSw0Cx7AOMez0I6MYtngI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ts7NayFCwkI4cJIRh0Zx37Ngg2FmrMs5B3+9PnFbg1AROXb1le/lpTZDNrtVPzDwz
	 hTPQP3oV4O1poKKR2HxxAhcT1qQKXhlNiP/jO7f4MvG2vKUedEgCYKr3fNjEvXdl0o
	 56NJYv5IH6Jo8ifzmptYmUXwxxO7SOABYksYo88/fvVUgrWpW/kKYm2vhmAGXepeJ6
	 KMePvNIefBXtH0piPhoV1muCP0a3MCPy9aMRx065Hm3Ira1kqXhFLSC2Bb88AzJFmz
	 /UefxhYLQAKpeUyzZkZo68PZo9TtWS3BF1ZboVCw04bQxzZbU0qfuXz6fRFf8ewReV
	 BI2SlzhfgSE6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] ALSA: usb-audio: Update the number of packets properly at receiving
Date: Mon, 23 Feb 2026 07:37:29 -0500
Message-ID: <20260223123738.1532940-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223123738.1532940-1-sashal@kernel.org>
References: <20260223123738.1532940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit cf044e44190234a41a788de1cdbb6c21f4a52e1e ]

At receiving the packets from the implicit feedback source, we didn't
update ctx->packets field but only the ctx->packet_size[] data.
In exceptional cases, this might lead to unexpectedly superfluous data
transfer (although this won't happen usually due to the nature of USB
isochronous transfer).  Fix it to update the field properly.

Link: https://patch.msgid.link/20260216141209.1849200-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

## Analysis

### What the commit fixes

The commit adds a single line: `ctx->packets = packet->packets;` before
the loop that copies `packet->packet_size[i]` values. Without this fix,
when implicit feedback mode is active, the `ctx->packet_size[]` array
gets updated from the feedback source, but `ctx->packets` retains its
original value set during initialization in
`snd_usb_endpoint_set_params()`.

### Bug mechanism

In implicit feedback mode, the capture endpoint tells the playback
endpoint exactly how many packets to send and what size each should be.
The feedback info is stored in `struct snd_usb_packet_info` with both a
`packets` count and `packet_size[]` array. When
`snd_usb_queue_pending_output_urbs()` processes this info, it copies the
packet sizes but **fails to update the packet count**.

Downstream, `ctx->packets` is used in:
- `prepare_playback_urb()` (pcm.c:1554) - loop bound for setting up ISO
  frame descriptors
- `prepare_silent_urb()` (endpoint.c:291) - loop bound +
  `urb->number_of_packets`

If `ctx->packets` (stale, from initialization) is **larger** than
`packet->packets` (actual feedback), the code iterates beyond the valid
packet sizes into uninitialized/stale `packet_size[]` entries, leading
to superfluous data transfer. If it's **smaller**, some feedback-
supplied packet sizes are ignored.

### Severity assessment

The commit author (Takashi Iwai, ALSA maintainer) notes this "won't
happen usually due to the nature of USB isochronous transfer" - meaning
the packet count in practice rarely differs between what was initialized
and what arrives via feedback. However, in exceptional cases it can
cause incorrect data transfer behavior.

### Stable kernel criteria evaluation

1. **Fixes a real bug**: Yes - mismatch between packet count and packet
   size array in implicit feedback mode
2. **Obviously correct**: Yes - single line addition that ensures
   `ctx->packets` matches the feedback data, exactly parallel to what's
   already done for `ctx->packet_size[]`
3. **Small and contained**: Yes - literally 1 line added
4. **No new features**: Correct - pure bug fix
5. **Risk**: Extremely low - it's adding the obvious missing assignment
   that pairs with the existing `packet_size[]` copy loop
6. **Author**: Takashi Iwai is the ALSA maintainer and subsystem expert
7. **Independence**: The followup commit (36adb51ac0b19) is a pure
   optimization (loop to memcpy) and is NOT needed for this fix to work

### Risk vs benefit

- **Risk**: Negligible. One line that brings `ctx->packets` in sync with
  the data it should have always tracked.
- **Benefit**: Prevents potential audio glitches or incorrect USB
  isochronous transfers in implicit feedback mode, which is used by many
  USB audio interfaces (especially pro audio equipment).

### Verification

- Read the full `snd_usb_queue_pending_output_urbs()` function
  (endpoint.c:457-525) confirming `ctx->packets` was not updated before
  the fix
- Verified `ctx->packets` is used downstream in `prepare_silent_urb()`
  (line 291, 311, 312) and `prepare_playback_urb()` (pcm.c:1554, 1581)
  as the loop bound for ISO frame descriptor setup
- Confirmed the mainline commit is cf044e4419023 by Takashi Iwai
- Verified the followup commit 36adb51ac0b19 is a pure optimization
  (loop→memcpy) with no functional changes, confirming this fix is self-
  contained
- Confirmed `struct snd_urb_ctx` has `packets` field (card.h:58) used
  for `urb->number_of_packets`
- Could NOT independently verify a user report triggering this bug
  (author says "exceptional cases" and "won't happen usually")

**YES**

 sound/usb/endpoint.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 8f9313857ee9d..27ade2aa16f5a 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -481,6 +481,7 @@ int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 
 		/* copy over the length information */
 		if (implicit_fb) {
+			ctx->packets = packet->packets;
 			for (i = 0; i < packet->packets; i++)
 				ctx->packet_size[i] = packet->packet_size[i];
 		}
-- 
2.51.0

