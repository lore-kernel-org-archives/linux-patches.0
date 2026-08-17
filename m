Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359E443E06B;
	Mon, 17 Aug 2026 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976098; cv=none; b=jROYuHw/gXmFhQpUTsBYX9ciXy6QVWAY0RTiiVdfR68NLND58Dh/jLLrCzvPjBqVGmFMk03I3c8R/cV8AFVlt7X+M0kkb6pkdZ0g0SBKOvDrt+TmJ9vz/KGlbjpkBJfTWd5cTb15ofyJdQYTtPNcC904ZPLPhLHGgFqJh7jTnPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976098; c=relaxed/simple;
	bh=DG3Y7msv1M8+xa2ARYD+fkcE7i875AakGT9vQ5GE6zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcoLPqGp4bRi370TbVZxsiC0r3RfUNdJGk2dShpkIccGUwezcziF41DqVa4kZHKdOctQuoR+fNPXHjr1/DYbHKoH6rsIvOEITXsFVHHDTY4L9Y60BR1Z4ASUbL8FsPaYyHXyhEYefO8R9UGqA05PcnBWRm99xrkoHAPKWHLwit0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocoPUBIr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocoPUBIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9135D1F000E9;
	Mon, 17 Aug 2026 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976097;
	bh=XAcJqU7c4DNVEnrXPvXEB+xExyx2osfpL4zFSE9mLgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocoPUBIrHIZGaS3hJSia5O3i6p5Ppb6HPuYrEQk+z6nX554G41gz6GrufOkjLf4dD
	 prnP2i7KiVf+UGZaajlLm+YxojKJyA4/rOqB1NvSJ7CLcTxm5twH/pIkz4O2NNlL5B
	 cuVzHDG4N/oFcmxhUrXVKSDeF2zGSL2BR/gItG9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 256/389] ALSA: usb-audio: Clamp frame size in implicit-feedback mode
Date: Mon, 17 Aug 2026 15:31:35 +0200
Message-ID: <20260817132549.209091680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1352,11 +1352,13 @@ void snd_usb_handle_sync_urb(struct snd_
 
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
 
 		ep->next_packet_write_pos++;


