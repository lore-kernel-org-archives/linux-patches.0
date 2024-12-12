Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BD420E034;
	Thu, 12 Dec 2024 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015957; cv=none; b=L/8gefUY2I2IcTmC4mcv9o6pvMBQQG0nk7jmexKfLNyL6eGiM1tNyzHRMzY6V3OuhdiYRMLJ2MQfobnvb2uVuQSa9H9EjZ+mQu/YRXBfl1amlv4LwHbfGHtVC1xhcvRWoKJ9M9DI59n4878V4GYBRvmPZEUqnVOCfnbvOan4M+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015957; c=relaxed/simple;
	bh=oZhRoRwTk26dyRFRS4q5AFwa8BJQVOvypeJC5IZ2KYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=or6aJ+2+MtYMpNWiTE144H7zlDEa9I5h130Gur8SU9pS/oOjr6YdfNIbM3nUatb77xgB1N3VbW03lJIPObL5MXAMDMtTy41RPmO7FBx+BFMvGgCDyEfC6xDupHavq2wzKFii0eNHvI8PtD+X0p+6x9ykN1hOarVIL66afTltnKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogG1AmBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogG1AmBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8DEC4CED0;
	Thu, 12 Dec 2024 15:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015956;
	bh=oZhRoRwTk26dyRFRS4q5AFwa8BJQVOvypeJC5IZ2KYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogG1AmBqei11d3qjwtAT63hbfYl9lgyqOyencyIaCdHXvo/dbxt7tTaZRpFYYWklc
	 9G+fPcM41NlB0MPli8uHPdU+cD9KlQUZOVcj/uEpIHqKLrW2Nfkr0DEd0ZoDXPjoPN
	 K3XM+83w5CLC1NRv7fp8DcQSJRwM5rHqIHGUTv14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonard Crestez <cdleonard@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/466] ALSA: usb-audio: Notify xrun for low-latency mode
Date: Thu, 12 Dec 2024 15:54:19 +0100
Message-ID: <20241212144310.371738992@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 568099467dbbc..a29f28eb7d0c6 100644
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



