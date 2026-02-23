Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F01365A1E;
	Mon, 23 Feb 2026 12:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850267; cv=none; b=JglqvgzFluiABUkcOCf+jTJI6qiEMEjeuCztjQeA0SNw5g2pYhZEsFls5avgE6Odyrptf97UEvFsa4Jg2gKaB1JwK5hthuVo8QhSHF+X1OsynAB5Pw7AcmJAvT0IjC2edYdwZXgGSfIUvV9NE9EjV2Sd4+0KvONMNOB+LDVcD7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850267; c=relaxed/simple;
	bh=8FmYs+QrdSDFMbKC7QBfwAXPK2pJJB0FmB/uWUvKPnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eIgLWyAuti+9De6574pUBDdlXZ31i+0LapzS/akSIQ+tPNohLqlKrVPxvL+796p0OtOamf/8Fgl/fiXdxLJ7X1FbwR/PlCxwlGwaJ+rcssEPQyDV97TwpsPGt56kmc1h4wKFXFpI2qVjX2CG69F9rwjv8MWXmuECrLS/7vp3wdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WOJ84LIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WOJ84LIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0998CC2BC9E;
	Mon, 23 Feb 2026 12:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850266;
	bh=8FmYs+QrdSDFMbKC7QBfwAXPK2pJJB0FmB/uWUvKPnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOJ84LIBNwGlaD8YoCJIe2RS1r4Xg7VHNPOF2YM9Ki84Q25tEIHa0mlvFcwq7cUXN
	 PptNKboPgj9OCh2r77JO57Ra38b1lSoiofOoEo0UHTPPFYO33w5w5+yw6g6G6N02EB
	 oCP0YrSgntGEttNrX7YB58tnX23aXDRFnNcwnZSOgCnSVQ9zU2KRn9ZvBJxokX/y4Y
	 b9LuAfNjsrgcRNPerc3uvCPK8zQ0uOgPq1ory/kDZN+YhleuJllZxWFGgH4vZJ0voF
	 N+kZ5dga6fQvNqWn75Fnl3NEFSWCRrX1zPoysPNXOSF0aFElnb0ZX337FsIBD7aldf
	 YL8W08SHB2oNg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] ALSA: usb-audio: Add sanity check for OOB writes at silencing
Date: Mon, 23 Feb 2026 07:37:10 -0500
Message-ID: <20260223123738.1532940-5-sashal@kernel.org>
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

[ Upstream commit fba2105a157fffcf19825e4eea498346738c9948 ]

At silencing the playback URB packets in the implicit fb mode before
the actual playback, we blindly assume that the received packets fit
with the buffer size.  But when the setup in the capture stream
differs from the playback stream (e.g. due to the USB core limitation
of max packet size), such an inconsistency may lead to OOB writes to
the buffer, resulting in a crash.

For addressing it, add a sanity check of the transfer buffer size at
prepare_silent_urb(), and stop the data copy if the received data
overflows.  Also, report back the transfer error properly from there,
too.

Note that this doesn't fix the root cause of the playback error
itself, but this merely covers the kernel Oops.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221076
Link: https://patch.msgid.link/20260216141209.1849200-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit fixes

This commit adds bounds checking to `prepare_silent_urb()` in the USB
audio driver to prevent **out-of-bounds memory writes** that cause a
**kernel panic/oops**. The bug occurs during implicit feedback mode when
silencing playback URB packets before actual playback begins. When the
capture stream has different (larger) packet sizes than the playback
stream (e.g., due to USB core max packet size limitations), the code
writes beyond the allocated transfer buffer, corrupting memory and
crashing the kernel.

### Bug severity

This is a **kernel crash/oops** triggered by real hardware. The bugzilla
report (bug #221076) documents:
- Hard system lockups / kernel panics on multiple platforms (Intel, AMD,
  Raspberry Pi 5)
- Reproducible with specific USB audio devices at high sample rates
  (352.8kHz/384kHz, 6-channel)
- The crash trace shows `memset_orig` called from `prepare_outbound_urb`
  → page fault on not-present page
- The regression was traced back to kernel 5.8.0, meaning it has
  affected users for years

### Code change analysis

The fix is small (22 insertions, 17 deletions, single file) and
surgical:

1. **Return type change**: `prepare_silent_urb()` changes from `void` to
   `int` to report errors
2. **Negative return check**: Checks if
   `snd_usb_endpoint_next_packet_size()` returns a negative error code
   before using the value
3. **Buffer bounds check**: `if (offs + length + extra >
   ctx->buffer_size) break;` — stops copying if data would overflow the
   buffer
4. **Error propagation**: Returns `-EPIPE` if nothing was written, `0`
   on success
5. **Caller updated**: `prepare_outbound_urb()` now returns the error
   from `prepare_silent_urb()` instead of ignoring it

### Stable kernel criteria assessment

- **Obviously correct**: Yes — adds bounds checking before memory
  writes, a straightforward safety measure
- **Fixes a real bug**: Yes — kernel oops/panic with real hardware,
  documented in bugzilla with crash traces
- **Small and contained**: Yes — 22 insertions/17 deletions in a single
  file, no API changes
- **No new features**: Correct — purely defensive checks
- **Risk**: Very low — the check only prevents writing beyond the
  buffer; normal operation is unchanged

### Dependencies

The commit modifies only `prepare_silent_urb()` and its caller in
`prepare_outbound_urb()`. The `ctx->buffer_size` field has been present
since the URB context structure was established. No prerequisite commits
appear needed.

### Verification

- Confirmed via the bugzilla report (bug #221076) that this is a real
  user-reported crash with kernel oops trace showing `memset_orig` page
  fault in `prepare_outbound_urb` call path
- The bug has been present since kernel 5.8.0 per user bisection,
  meaning all stable trees are affected
- Explored `snd_usb_endpoint_next_packet_size()` — confirmed it can
  return negative (`-EAGAIN`), which was not checked before this fix
- Confirmed `ctx->buffer_size` is set in `data_ep_set_params()` as
  `maxsize * packets`, and the transfer buffer is allocated to that size
  — so the bounds check is valid
- The commit is authored by Takashi Iwai (ALSA maintainer), providing
  high confidence in correctness
- The commit message explicitly states it covers a kernel Oops — a clear
  stable-worthy fix
- Commit touches only `sound/usb/endpoint.c` (1 file, small diff)

This is a textbook stable backport candidate: a small, surgical fix for
a kernel crash affecting real users, authored by the subsystem
maintainer, with low regression risk.

**YES**

 sound/usb/endpoint.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 27ade2aa16f5a..1eaf52d1ae9c7 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -275,8 +275,8 @@ static inline bool has_tx_length_quirk(struct snd_usb_audio *chip)
 	return chip->quirk_flags & QUIRK_FLAG_TX_LENGTH;
 }
 
-static void prepare_silent_urb(struct snd_usb_endpoint *ep,
-			       struct snd_urb_ctx *ctx)
+static int prepare_silent_urb(struct snd_usb_endpoint *ep,
+			      struct snd_urb_ctx *ctx)
 {
 	struct urb *urb = ctx->urb;
 	unsigned int offs = 0;
@@ -289,28 +289,34 @@ static void prepare_silent_urb(struct snd_usb_endpoint *ep,
 		extra = sizeof(packet_length);
 
 	for (i = 0; i < ctx->packets; ++i) {
-		unsigned int offset;
-		unsigned int length;
-		int counts;
-
-		counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, 0);
-		length = counts * ep->stride; /* number of silent bytes */
-		offset = offs * ep->stride + extra * i;
-		urb->iso_frame_desc[i].offset = offset;
+		int length;
+
+		length = snd_usb_endpoint_next_packet_size(ep, ctx, i, 0);
+		if (length < 0)
+			return length;
+		length *= ep->stride; /* number of silent bytes */
+		if (offs + length + extra > ctx->buffer_size)
+			break;
+		urb->iso_frame_desc[i].offset = offs;
 		urb->iso_frame_desc[i].length = length + extra;
 		if (extra) {
 			packet_length = cpu_to_le32(length);
-			memcpy(urb->transfer_buffer + offset,
+			memcpy(urb->transfer_buffer + offs,
 			       &packet_length, sizeof(packet_length));
+			offs += extra;
 		}
-		memset(urb->transfer_buffer + offset + extra,
+		memset(urb->transfer_buffer + offs,
 		       ep->silence_value, length);
-		offs += counts;
+		offs += length;
 	}
 
-	urb->number_of_packets = ctx->packets;
-	urb->transfer_buffer_length = offs * ep->stride + ctx->packets * extra;
+	if (!offs)
+		return -EPIPE;
+
+	urb->number_of_packets = i;
+	urb->transfer_buffer_length = offs;
 	ctx->queued = 0;
+	return 0;
 }
 
 /*
@@ -332,8 +338,7 @@ static int prepare_outbound_urb(struct snd_usb_endpoint *ep,
 		if (data_subs && ep->prepare_data_urb)
 			return ep->prepare_data_urb(data_subs, urb, in_stream_lock);
 		/* no data provider, so send silence */
-		prepare_silent_urb(ep, ctx);
-		break;
+		return prepare_silent_urb(ep, ctx);
 
 	case SND_USB_ENDPOINT_TYPE_SYNC:
 		if (snd_usb_get_speed(ep->chip->dev) >= USB_SPEED_HIGH) {
-- 
2.51.0

