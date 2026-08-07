Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2284377A93;
	Fri,  7 Aug 2026 15:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115276; cv=none; b=hr8Dhr1iEpewqjkR8AKWrbkfIUNFI1b8QcaKF956wULTL2yTmtYyisHV45eyBC04tjTaEECDomyc9/kRTPAWNRcajz4VRJq0wJhvAcrr1k4bAtF8p2sgSURwT476rFbCR1DGwcrSM4kwJzm/M8jPBpf8k2aI7XWph9XluZ8r/k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115276; c=relaxed/simple;
	bh=YB58tm99kubvJSiSAyVQE6/kkYakKeBhUsFL5suoMmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZMAO0ifFdx1rG1uUrRr3updHA8VX6p84adphbMXRQiWsCVFxT6lSF0G6wcpWdqK8dSOg4Qqh/7LeXtpU+WJZlfqWdypMhlkZdnK6Ez8bq7Pz+HKt2XPJlb8i29sxq6enYLSZhg6WSN7CuufniNEFmsVBZtSqKDfRxqAGiVvXPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5T9LtKa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5T9LtKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AD21F000E9;
	Fri,  7 Aug 2026 15:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115274;
	bh=7Roinm35eQrz5vg1l1ZM1BNWZdQxYXdoetutMPsn9+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5T9LtKauiEr5/eA8dTbX+nXLjs5EsbR24+eptLBImo23ZH9JLON91XNjKae5jEqf
	 beNm+nBB0sxQZKsgBOBN+QdR47ai8A8WMIeqHVRV/ox1kOzUDob/4BtM9pbfpfB2GY
	 VTonNT/pANLPe984nt5dboCTFmNSxbcV5+qQ6VVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 218/396] ALSA: usb-audio: Clamp frame size in implicit-feedback mode
Date: Fri,  7 Aug 2026 16:36:18 +0200
Message-ID: <20260807143428.969397274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1806,11 +1806,13 @@ static void snd_usb_handle_sync_urb(stru
 
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


