Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438FE3B774B;
	Mon, 17 Aug 2026 15:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980058; cv=none; b=B/6HA+jbc8I7Qldm/NorALG/UmvimXDMOT0EqfIDVfEekqNa0IbMWHvJt+wH0Exvgp/eH9nZeGsz9IRjdidWkZyLVVV0Qj2TGd06wld69hzVchUPa7wFG2WSzQVjeHvn4Euh8mPdalaWMosgS2a3mHfYEm5nFd0FlRqJ4o69KnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980058; c=relaxed/simple;
	bh=m7j52z/vQumAysscdHCnyckRAOBIGG4jrknBwP8cLn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAHYz1e57zkJwD7aldSPZ4qrRAXeczNU2oVCXGzs4rbp0eg/TE+LM6SxziVQY9xve2D2LUw83gfTqgkJLuHRg6mz8jeSpP+VdsPbGtfG9XY5a8NXt3p08LtJgMhp2w59sjKYy7tgeAm+FYSO/LFdIikuNZ9Dcoou50jvaHpCnOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LagBx+eX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LagBx+eX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5957C1F000E9;
	Mon, 17 Aug 2026 15:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980056;
	bh=kM7VEgZgjJ1WqBpCfUp+/62ma9GdC1TNAeUawbYHcVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LagBx+eXflMY8xGTBzLGht9xfpFcmC4vy06MHiDJLJwgHd4sb/SX7pWW4vTXijsj4
	 /sLRvJRCdHbepQFG+mf4ilUZrMo3F61guq8dN9oPX9R018q3V4m6RwL09q1YizEr1m
	 SrJDTi5LZBfPz6J2mqKWHjnONnrMvcTDNIYGqy9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 404/609] ALSA: usb-audio: Clamp frame size in implicit-feedback mode
Date: Mon, 17 Aug 2026 15:31:40 +0200
Message-ID: <20260817132557.704618239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonali Pradhan <sonalipradhan@google.com>

commit 8d7a30c50c2e58a6839634ed0acde14466d1dc61 upstream.

snd_usb_handle_sync_urb() scales received sync packet sizes by the sender's
stride and stores the result directly in out_packet->packet_size[i]. If a
connected USB device sends an oversized sync packet, this frame count can
exceed ep->maxframesize.

The un-clamped frame count then propagates to the playback endpoint queue,
potentially driving packet transfers beyond the endpoint's hardware frame
limits.

Cap the calculated frame count against ep->maxframesize in
snd_usb_handle_sync_urb() to prevent oversized packets from entering the
playback queue.

Fixes: 28acb12014fb ("ALSA: usb-audio: use sender stride for implicit feedback")
Cc: stable@vger.kernel.org
Assisted-by: Jetski:Gemini-3.6-Flash
Signed-off-by: Sonali Pradhan <sonalipradhan@google.com>
Link: https://patch.msgid.link/20260728202432.2354994-1-sonalipradhan@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1826,11 +1826,13 @@ static void snd_usb_handle_sync_urb(stru
 
 		out_packet->packets = in_ctx->packets;
 		for (i = 0; i < in_ctx->packets; i++) {
-			if (urb->iso_frame_desc[i].status == 0)
-				out_packet->packet_size[i] =
+			if (urb->iso_frame_desc[i].status == 0) {
+				unsigned int frames =
 					urb->iso_frame_desc[i].actual_length / sender->stride;
-			else
+				out_packet->packet_size[i] = min(frames, ep->maxframesize);
+			} else {
 				out_packet->packet_size[i] = 0;
+			}
 		}
 
 		spin_unlock_irqrestore(&ep->lock, flags);


