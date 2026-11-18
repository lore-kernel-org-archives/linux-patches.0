Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046134;
	b=p8/a0JAy3Kp+O0suaqM80fIQmp8zJge03W6T4oK8a2DNeD547dEEqkBBWeI7iX9GfIwV
	 sFofkgIJHPeK3tOLNk58B2+HEtHVO7rnCVr+dyPda3QLTi8qtFJkE4GuBjdTDq3Z9Q7lg
	 kNIG6F4hOfr9uEvYvohV9ggu/9Qf0GQEU0Y3EtK64hex3leSdSHhKMQyN0sEeQKhVQy3I
	 hkhWaSeIM9qwRYSAzkZTUSaLGjwM1OqusZ5kPBRRMHsUati96SwgVb7nYyByctUV1AcsR
	 j7pgsBNLLfmTmwXEeh/jhzTgajMcpED8Jryvk8POGS30HCupmniB7xZPhZTnSUBfTWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aw35HJYXkJ5s0oxYN7DMV2/9ZRyvpxMkjH/MRGLy38I=;
	b=IZL3cd1qGU29mq5nXfoU/+VLBjy2uOeIuZBMe/nbZ38QDfguUU+8M9TZSmN3twpNWEM/
	 AIsePIvFmL4OKIJMXPLIqObqhvF6Wn3wyWz4IykdthjyqbTzXyhoeFIIRNLzXe6+D7iq1
	 eRvI3yP6ZYRacaFzuH+T3F0GA1X2pgUS1ECqD1/b6v61QN2JAGkEa1SzYw83p36D+/VbG
	 GtvM0rqIpdrNvzVutloAaD2AVunRUfmbyf6h+pTEBTRRh5dcSpy2iMkpfdVAixGLSP5NN
	 HTaqd4Vu3Ysxjs0hrkPE5Xo8CZcwA1cWAuwacuNoCOLNv49M+IQkI1W5yT1oxl6rznw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMv1kbT1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EDC606A33B;
	Wed, 18 Nov 2026 23:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMv1kbT1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438521F000C4;
	Wed, 18 Nov 2026 23:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046133;
	bh=aw35HJYXkJ5s0oxYN7DMV2/9ZRyvpxMkjH/MRGLy38I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMv1kbT1nrRFh1fWz4XmtwCKV6ArSlcHJVs2zoXu0IeJ+olJksp7qmJybfvtZnosk
	 W8l1ue2TzLKSj3Z4QFGL5K+cb/pIUKSjW1fdXrp6azQFfQ/OE+9pSfGaddtWKJh22M
	 7JV3xKEpnizDgjdqoS3G9RTPU2zuhvRcKIzYzvo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1173/2857] ALSA: usb-audio: Dont try to submit URBs after disconnection
Date: Wed, 18 Nov 2026 15:36:47 +0100
Message-ID: <20261118150243.831676781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ab574d1629552b6831cd91b926b38092c15d6142 upstream.

USB-audio driver can still submit URBs while the device is being
disconnected, and it may result in spurious error messages like:
  usb 1-2: cannot submit urb (err = -19)
  usb 1-2: Unable to submit urb #0: -19 at snd_usb_queue_pending_output_urbs
  usb 1-2: cannot submit urb 0, error -19: no device
Although those are harmless, they are just ugly.

This patch tries to avoid spewing such error messages when the device
is already at the disconnected state.  It also skips the superfluous
xfer notification, too.

Link: https://lore.kernel.org/r/20230828101924.27107-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index dd81c94cbb520..167eefc14d82d 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -520,13 +520,18 @@ int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 			return -EPIPE;
 		}
 
-		err = usb_submit_urb(ctx->urb, GFP_ATOMIC);
+		if (!atomic_read(&ep->chip->shutdown))
+			err = usb_submit_urb(ctx->urb, GFP_ATOMIC);
+		else
+			err = -ENODEV;
 		if (err < 0) {
-			usb_audio_err(ep->chip,
-				      "Unable to submit urb #%d: %d at %s\n",
-				      ctx->index, err, __func__);
-			if (!in_stream_lock)
-				notify_xrun(ep);
+			if (!atomic_read(&ep->chip->shutdown)) {
+				usb_audio_err(ep->chip,
+					      "Unable to submit urb #%d: %d at %s\n",
+					      ctx->index, err, __func__);
+				if (!in_stream_lock)
+					notify_xrun(ep);
+			}
 			return -EPIPE;
 		}
 
@@ -593,12 +598,17 @@ static void snd_complete_urb(struct urb *urb)
 		prepare_inbound_urb(ep, ctx);
 	}
 
-	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!atomic_read(&ep->chip->shutdown))
+		err = usb_submit_urb(urb, GFP_ATOMIC);
+	else
+		err = -ENODEV;
 	if (err == 0)
 		return;
 
-	usb_audio_err(ep->chip, "cannot submit urb (err = %d)\n", err);
-	notify_xrun(ep);
+	if (!atomic_read(&ep->chip->shutdown)) {
+		usb_audio_err(ep->chip, "cannot submit urb (err = %d)\n", err);
+		notify_xrun(ep);
+	}
 
 exit_clear:
 	clear_bit(ctx->index, &ep->active_mask);
@@ -1646,11 +1656,15 @@ int snd_usb_endpoint_start(struct snd_usb_endpoint *ep)
 			goto __error;
 		}
 
-		err = usb_submit_urb(urb, GFP_ATOMIC);
+		if (!atomic_read(&ep->chip->shutdown))
+			err = usb_submit_urb(urb, GFP_ATOMIC);
+		else
+			err = -ENODEV;
 		if (err < 0) {
-			usb_audio_err(ep->chip,
-				"cannot submit urb %d, error %d: %s\n",
-				i, err, usb_error_string(err));
+			if (!atomic_read(&ep->chip->shutdown))
+				usb_audio_err(ep->chip,
+					      "cannot submit urb %d, error %d: %s\n",
+					      i, err, usb_error_string(err));
 			goto __error;
 		}
 		set_bit(i, &ep->active_mask);
-- 
2.53.0



