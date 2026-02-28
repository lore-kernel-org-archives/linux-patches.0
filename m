Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC3F32AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301211; cv=none; b=gVMK6p33xB0XUUHbr09sKHfqclVatvKuIYuBtgbTJ0a0K4Z4/kCrmDIhIPpckZtfC1TA/Kay0GKF+0HXjZEZr85AoqxhDsyBXIKSemgKSnLWXiAU2Ei7LFOUw5DcYOa6pfK8ovFXyM1xRWo6Fa9f56VWUp7uUdlMe0fCHJlwH3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301211; c=relaxed/simple;
	bh=cRP6nfSEgCNDFP1uQAvhjRQXyp/jBPutZy3HPUHP/lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6ZpbZ3SH4Ja7PDPehPHEMBJhe1pX2Wj49wT3IGrJxvNG0jbAbGXzVcyyAiaNzb36PrTtB0oF8I3rmvB0DjSEoC2W7ahJHVEOFrJhvasc2Slg99k1HBG9MpcuhwJtns2teJwXFSTjhkeFwv1yyacgTrID/IsKDe1wbgB/LkEsyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UUw9OOGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UUw9OOGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AF0C19424;
	Sat, 28 Feb 2026 17:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301211;
	bh=cRP6nfSEgCNDFP1uQAvhjRQXyp/jBPutZy3HPUHP/lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUw9OOGGCYIvwS2/hdQA4YP1pQx8n4MUcc+GsXt3hSO9vI9eojpZ+/dHoBBoHmdfH
	 6YKfavpShr7B1rF70Mmx9XcLXqXpACzYD1N5SGst8JAecQDSJSgsgV0BdGF2noyAQq
	 x3nMcO9xtwCJx8ClFObXBFaHdMfaag0V9vjxXw8cWjPwwWWgHFITNFSGtAONJWihY8
	 irQBGxW2Gbft73JrYmaLlVOjHWLxzCubhIF1Q+PKqo+Nsp/pxN4EpYaNgRB/rx3Pol
	 TSsiA3hoMKIn1XGhY6cZECWfXMKd3UC8tVC9NJxwUrNB0EbKNfsgx0V/nF+UmUVxvx
	 9a5plEub1b1GQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 386/752] ALSA: usb-audio: Add sanity check for OOB writes at silencing
Date: Sat, 28 Feb 2026 12:41:37 -0500
Message-ID: <20260228174750.1542406-386-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 sound/usb/endpoint.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 6741ce368dd1c..3ac1fbec6327e 100644
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

