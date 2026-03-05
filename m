Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6973C6A53;
	Thu,  5 Mar 2026 15:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725033; cv=none; b=nKCeB205b6K2SreasACwz8NAJwAVZ9awkBNXty6LM/mBZblQqibKNmiHB5XF4Kk8sXprJLznjFi9qgL0BDoCjUyexRSv+I1JsMXCor4df949TRWY3p8jx+gRj8FSRPUmy6KdGQ8U14IXR72af4UTKvSucJ0WhBal+NZLp9WwJng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725033; c=relaxed/simple;
	bh=jkmKY9PNpEA8XYmeUaB2srzOcNVtTnu3eYd725GFAW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YRIC3CMnmqO3NSxwsEtg2Q7mJzqaWeANVTYy49sDMpgMAGUvveGRcAkHf0SvMjEWXgpN+atPkGwJBmL8UzweHDqMAGVY7dnus/HMM/yxENjJClrZ5hYg3fn7+7+RNUGd65bL2LjNfs0zTNEPsA3ftQ9VLhpkjX/Vg3oYFTEtihE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dYIZhM6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dYIZhM6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE1BC116C6;
	Thu,  5 Mar 2026 15:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772725033;
	bh=jkmKY9PNpEA8XYmeUaB2srzOcNVtTnu3eYd725GFAW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYIZhM6gqZCYrg7aA7NzYtEiRsGDm1aK/alxaoETOxqcMNGXgMfm4say2ZQlC/D+z
	 BFm5y+EoNYaumb5EzF47v6844ySx71vmlk0LgOlZxARsqFVSyB0JGUrjPd2W3BBwNh
	 8dAnLBVL89qfRE2xp6MWX0zWYLLZOLCs50+AJOc7xfsC/PWavWrm8rbYIikeH6iUBR
	 terrPEzV0x6y93VzQb3PsNAiLQuIwB0iwgiwjNE9ayQky9/JJxFppMzG3MB7KdcQ+u
	 TmWzC8ECxWqXsu3h5hYy0tGVhIgT6+WZjTUs+Zgi417O28nAwVctZ3VsoIU/m9uEMc
	 T761vZlo+QL4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] ALSA: usb-audio: Check max frame size for implicit feedback mode, too
Date: Thu,  5 Mar 2026 10:36:48 -0500
Message-ID: <20260305153704.106918-5-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7cb2a5422f5bbdf1cf32eae0eda41000485b9346 ]

When the packet sizes are taken from the capture stream in the
implicit feedback mode, the sizes might be larger than the upper
boundary defined by the descriptor.  As already done for other
transfer modes, we have to cap the sizes accordingly at sending,
otherwise this would lead to an error in USB core at submission of
URBs.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221076
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260225085233.316306-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me write the analysis.

## Analysis

### What the commit fixes

This is a one-line fix that caps the packet size returned from the
implicit feedback path to `ep->maxframesize`. When USB audio uses
implicit feedback mode, packet sizes are derived from the **actual
captured URB lengths** from a companion capture endpoint, rather than
being pre-calculated. These actual lengths can exceed the maximum frame
size defined by the USB descriptor/bus constraints.

Without this cap, oversized packets get submitted to the USB core, which
rejects them with errors, causing audio failures or crashes.

### Bug mechanism

In `snd_usb_endpoint_next_packet_size()`, when `ctx->packet_size[idx]`
is non-zero (implicit feedback path), the raw value from the capture
stream was returned without any bounds check against `maxframesize`. The
other two code paths already have this protection:
- `slave_next_packet_size()` caps via `min(phase >> 16,
  ep->maxframesize)` at line 174
- `next_packet_size()` uses pre-calculated `packsize[]` values, which
  are now capped by the companion commit `7fe8dec3f628`

This was a gap in the implicit feedback path specifically.

### Real-world impact

The linked bugzilla (221076) documents a real user hitting this with a
DIYINHK USB Audio 2.0 device at high sample rates (352.8kHz/384kHz with
6 channels at 32-bit). The device firmware reports an incorrect max
packet size that USB core corrects downward, but the ALSA driver's
implicit feedback path didn't respect this corrected limit.

### Stable criteria assessment

1. **Obviously correct**: Adding `min(packet, ep->maxframesize)` mirrors
   exactly what the other code paths already do. It's a one-line, self-
   evident fix.
2. **Fixes a real bug**: URB submission errors with real hardware
   (bugzilla 221076).
3. **Small and contained**: Single line addition in one file.
4. **No new features**: Pure bug fix.
5. **Low risk**: The cap was already applied in all other paths; this
   just closes a gap for the implicit feedback path.

### Dependency check

This commit depends on the companion commit `7fe8dec3f628` ("ALSA: usb-
audio: Cap the packet size pre-calculations") which fixes the same class
of bug for the pre-calculated path. Both should be backported together
as they address the same bugzilla issue, but this commit is
**independently valuable** — the implicit feedback path fix stands on
its own since `maxframesize` has been available since long before.

The `Fixes:` tag on the companion commit points to `f0bd62b64016`
("ALSA: usb-audio: Improve frames size computation") from 2020, meaning
the underlying code is present in all active stable trees.

### Verification

- Read `sound/usb/endpoint.c` lines 157-233: confirmed
  `slave_next_packet_size()` caps at line 174 with `min(phase >> 16,
  ep->maxframesize)`, `next_packet_size()` uses `ep->packsize[]` (now
  capped by companion commit), but the `ctx->packet_size[idx]` path at
  line 222-226 had no cap before this fix.
- Confirmed `maxframesize` is set in `snd_usb_endpoint_set_params()` at
  line ~1400 from `maxpacksize / cur_frame_bytes`.
- Confirmed companion commit `7fe8dec3f628` exists and caps
  `packsize[0]` and `packsize[1]` — it has an explicit `Fixes:` tag
  pointing to `f0bd62b64016` (2020), confirming the buggy code exists in
  stable trees.
- Confirmed the bugzilla link 221076 is referenced in the commit
  message, documenting a real user-reported issue.
- The implicit feedback packet sizes come from actual URB lengths (set
  in `retire_inbound_urb` path), which can exceed descriptor limits —
  verified by reading the packet_size assignment code.

This is a textbook stable backport candidate: a one-line fix for a real
user-reported bug, closing a gap where bounds checking was missing for
one specific code path while already present in all others.

**YES**

 sound/usb/endpoint.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 1eaf52d1ae9c7..46eff040a1511 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -221,6 +221,7 @@ int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
 
 	packet = ctx->packet_size[idx];
 	if (packet) {
+		packet = min(packet, ep->maxframesize);
 		if (avail && packet >= avail)
 			return -EAGAIN;
 		return packet;
-- 
2.51.0

