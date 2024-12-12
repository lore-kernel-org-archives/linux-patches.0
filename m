Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CAA22FDF9;
	Thu, 12 Dec 2024 16:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021007; cv=none; b=NWuuKyp8pZiw/87ADkvnvFp9/SZGLGbWSjxUMjuwbNLXvN4FZ9rNoEIRhQeqVRQ78QRmMJg0n35PO5B5zpnpeWSi9DjpJmVxHJt5+pEPzRO6A3dVyxuILEtmjIckA91JFdsMo44EQ2zlUE4Uu+Si/NCu0LwG5Z9lpvTh6q1npIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021007; c=relaxed/simple;
	bh=nPBAAsPmxzAeGNQybzalcL3zDaOZsw7LllXbi04kvzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoqtNeAcnj20/eMnwty0evj9nKTaXUbSMkQ28SQh6/fVQrKS+AztZS3c9J5xOJUHWseAaZdvvD0wlYDgf52d3JcsuyNuQIsSgcWs4Zr9kAWBGshAYvpvkLSerYTBp+F8y51GSzonktnBPH4ATb1heSEm1kkdTK/ROkqOQhzH0xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThDgrSnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThDgrSnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416F3C4CECE;
	Thu, 12 Dec 2024 16:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021006;
	bh=nPBAAsPmxzAeGNQybzalcL3zDaOZsw7LllXbi04kvzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThDgrSnBF6VPABNkotfu5UUjEkMywtTPPnGKpUtvevoluIOeD2Hh4cqSypj9KPLaq
	 NiVZawPzb1vd28FgB6WA/oX/4e6R7hjLYD9602Dns1/Az3iYlkjnzmuaOeUAIHotJO
	 aCjuu2W849K7sSZYXuvmXBqlY9vbSM1AFz2/z2HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonard Crestez <cdleonard@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 590/772] ALSA: usb-audio: Notify xrun for low-latency mode
Date: Thu, 12 Dec 2024 15:58:55 +0100
Message-ID: <20241212144414.316793479@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 647fa054d8b1d..e3684dfa5f1fa 100644
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
@@ -557,7 +562,10 @@ static void snd_complete_urb(struct urb *urb)
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



