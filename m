Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95C34766AA;
	Fri,  7 Aug 2026 15:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117300; cv=none; b=NyNC6UJW+Ot1a9rHu+uS0AQWJcnfpWWCavJ6P6tRUSeHBB10T7RsjRLvohNti3e4v9C4kE9pKJ07Dyzic2nS9XBN8GHiepp328GbmKsv9xwm5XE7uk2erCDQVQmomXbW0tX/ipmR23thnC0tsp2lKjWZlCjSflr50OHiVuPZDGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117300; c=relaxed/simple;
	bh=Elf4VFvTmlR20J3Ubv9L1+b5Ei0RLP/k/kRcXOTD92w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3Uiq4T6y7/k/7I0bTuwgi4HbThTC+CFWlhdOvp8APs9NGWRF/eQpRHwe2p6fLISr6P8fSKzMnsXpIpugAEQ9Yrgj9R/4t9NGQKLriysR3DlJNX8mMvWBza1reG6F5sJOX0TLGAvLEaLg3uTUNrj17qoe8bGNNyqntf7W8MuZXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mz0sMJRT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mz0sMJRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498031F000E9;
	Fri,  7 Aug 2026 15:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117298;
	bh=owKnn5ltHK4Jm2fmbc6zHtYzaxUsYcd7FTkzsI9Vzxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mz0sMJRTpactnfHibXc4mDLT6S4618HeB00mZnAgwJ5NBhkpV7gQ9F3gfJgkeVfFm
	 unmVhnraiVg0gDaEIEyRhqE9tKmg9Ix9pk9tNX2XE+csSxoH/aUzp/MrfppbZtm65w
	 iEpxwnFNheEeIuHHRDkqsixsmFKkuWfojhhfK1NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 271/438] ALSA: usb-audio: Clamp frame size in implicit-feedback mode
Date: Fri,  7 Aug 2026 16:37:47 +0200
Message-ID: <20260807143433.763558383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1819,11 +1819,13 @@ static void snd_usb_handle_sync_urb(stru
 
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


