Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A444B0482;
	Fri,  7 Aug 2026 14:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114324; cv=none; b=OdfMPhFQrOf2nzy4rHP/aU6G/+wh6KNY2ppxUMeo8HqkDnLylZyVaL9Drrn0WPMIr2+hnPZ56FKEcxwmZ5jIBERt5S3ZulhUR9cUH/9QD1hd/6lgkDdx3K+th/6++gF9j57CUTbhdaEo4rZFQjErmJ5dnE6efbAkOuSDpVMLbsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114324; c=relaxed/simple;
	bh=FGDxtOr8VEIMu3DwaieM09pLeCE3mXrNhl5jZar6iPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrX1pooYwFpkDnktWweYCLB8nGRfcXEZcsT8ZHSaw2sCWqdvUGc0ziC3QppPKbuIYtmSbr6gaTNGHPNbFpjl4Gly8CqhASjGoe9M+HC5+8UT/wBu+983JzmS/U5kZziUXjG5Gl2zl7SAh9EtRnjZqWoN3n18hy/nMgzQjtazfQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HavbJeXi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HavbJeXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F9A1F00A3A;
	Fri,  7 Aug 2026 14:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114322;
	bh=ggZ/ZNX2Z842gIc5WTLqas+9IGEYyKr+qBVswIxUcs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HavbJeXiQjVqTjsblZI9uSzCH0uBTJnewQDiwql5Rs5V+wKN9IM81x3O+XKpW31Ok
	 QK2dwczHwNxVQ9qV0HF4otlT9kwaVUzIi3TODxGQLqTjI1VyPJKUHAXozk/93Br/Ja
	 FBgymvX3iEorw8hGyF4mFmbiZFzxTvks/AycYVyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 169/337] ALSA: usb-audio: Clamp frame size in implicit-feedback mode
Date: Fri,  7 Aug 2026 16:36:12 +0200
Message-ID: <20260807143422.221966750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1837,11 +1837,13 @@ static void snd_usb_handle_sync_urb(stru
 
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


