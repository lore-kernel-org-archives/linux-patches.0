Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648802210E8;
	Thu, 12 Dec 2024 15:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017822; cv=none; b=tZZTzboPzdOm/wVZtTVkjOt1upjCn4GmdLpjTc0VKTXLrCbkgDHq3rFDIRoIcjeebRj2CCbQA4lQ+qlMyZsjQ/Czy/wVPxBs/LbsAxPB7PSQDHVUwmqLquHYqMyAf8IP/+ZEezf6nFSPKD5qUuZXPuBigjLIIdQ8vNpKkB1OHwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017822; c=relaxed/simple;
	bh=IV5zwrYZTemGMlbY5FlUxoRRKE/5fNk3bfagiNxEnQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyhCO5iRVLzltignuyARQairgY/WQzMgLTFwfXZgo0U+5I+Cjtre0mbCsj3UEOCutanhbABR7rB/1MeFcdeo+HEEzGmBHKb5npMzQ4k7InVpSigyw7wDV7HYfcTP72lXnZ/FL49pVXyP8sY/FNypuzNilL4KqwYe66vmKfXivnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXg/BFzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXg/BFzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708F9C4CECE;
	Thu, 12 Dec 2024 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017821;
	bh=IV5zwrYZTemGMlbY5FlUxoRRKE/5fNk3bfagiNxEnQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXg/BFzpgiGdxfzEeU3W0k3ijyCchsX4pbSzy4Ey+Q/0Z0p+tPou+Rqw2jBn9YfPG
	 nus7lJ2cgYk4Wbj7ZxLTh8TtuyCwMtrkbJA9hoNZBEVqFHLSpwm9zV/OujlrzlF3Nq
	 JY9IDZbkQlOiA9h9hH7LGu/+CXTJEW9Vw4hFe0kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonard Crestez <cdleonard@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/356] ALSA: usb-audio: Notify xrun for low-latency mode
Date: Thu, 12 Dec 2024 15:57:19 +0100
Message-ID: <20241212144249.394141545@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4f9d674377d090e38d93360bd4df21b67534d622 ]

The low-latency mode of USB-audio driver uses a similar approach like
the implicit feedback mode but it has an explicit queuing at the
trigger start time.  The difference is, however, that no packet will
be handled any longer after all queued packets are handled but no
enough data is fed.  In the case of implicit feedback mode, the
capture-side packet handling triggers the re-queuing, and this checks
the XRUN.  OTOH, in the low-latency mode, it just stops without XRUN
notification unless any new action is taken from user-space via ack
callback.  For example, when you stop the stream in aplay, no XRUN is
reported.

This patch adds the XRUN check at the packet complete callback in the
case all pending URBs are exhausted.  Strictly speaking, this state
doesn't match really with XRUN; in theory the application may queue
immediately after this happens.  But such behavior is only for
1-period configuration, which the USB-audio driver doesn't support.
So we may conclude that this situation leads certainly to XRUN.

A caveat is that the XRUN should be triggered only for the PCM RUNNING
state, and not during DRAINING.  This additional state check is put in
notify_xrun(), too.

Fixes: d5f871f89e21 ("ALSA: usb-audio: Improved lowlatency playback support")
Reported-by: Leonard Crestez <cdleonard@gmail.com>
Link: https://lore.kernel.org/25d5b0d8-4efd-4630-9d33-7a9e3fa9dc2b@gmail.com
Link: https://patch.msgid.link/20241128080446.1181-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 8f65349a06d36..68aa174be12d7 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -403,10 +403,15 @@ static int prepare_inbound_urb(struct snd_usb_endpoint *ep,
 static void notify_xrun(struct snd_usb_endpoint *ep)
 {
 	struct snd_usb_substream *data_subs;
+	struct snd_pcm_substream *psubs;
 
 	data_subs = READ_ONCE(ep->data_subs);
-	if (data_subs && data_subs->pcm_substream)
-		snd_pcm_stop_xrun(data_subs->pcm_substream);
+	if (!data_subs)
+		return;
+	psubs = data_subs->pcm_substream;
+	if (psubs && psubs->runtime &&
+	    psubs->runtime->state == SNDRV_PCM_STATE_RUNNING)
+		snd_pcm_stop_xrun(psubs);
 }
 
 static struct snd_usb_packet_info *
@@ -562,7 +567,10 @@ static void snd_complete_urb(struct urb *urb)
 			push_back_to_ready_list(ep, ctx);
 			clear_bit(ctx->index, &ep->active_mask);
 			snd_usb_queue_pending_output_urbs(ep, false);
-			atomic_dec(&ep->submitted_urbs); /* decrement at last */
+			/* decrement at last, and check xrun */
+			if (atomic_dec_and_test(&ep->submitted_urbs) &&
+			    !snd_usb_endpoint_implicit_feedback_sink(ep))
+				notify_xrun(ep);
 			return;
 		}
 
-- 
2.43.0



