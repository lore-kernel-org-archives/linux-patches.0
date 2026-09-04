Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDAE24A05D;
	Fri,  4 Sep 2026 05:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498577; cv=none; b=NEWJsJIsRh5mHTztddX6dUZGH9q0TXBZAE77PETjEWKpcFrqFgyKQaPJx1Pic54mV7/LkdhTrvso/yMmabCZwun4qsvP/EL6BEtJ5Fs+J7Am387QTere48iXS9+Hu2bxfDA4bLFcB1/x61ED1mjgMt4DNBua/ofUYVzrRpa40Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498577; c=relaxed/simple;
	bh=yBpYMkPTX+dOq7bMUNmwkpSJSo5zdhwM9ujdKfUskwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLuB0fCcu+/BrOPiMfR623f1B8W3BGVcVaFWfX5/5+d6qQ716krs0PHUMp3a9+1q4vfGdbP2UnlwXXyXi2uIYYd5SM4U5jpQXNlvDsCho+bYvd1vwY2kFfvpwW3Nfw1Lyr2ufW2BMU0W1XEOlsAkq+1zePYw4sIBZqBER9hletU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsb43EjC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsb43EjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F391F00A3E;
	Fri,  4 Sep 2026 05:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498576;
	bh=Oy6GGboKPVIy+zVSV+XndtzwJOx0ZIbv1bYy2XMdKTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bsb43EjC43qyULXZGSWbFqoX5VCqJTLY1q2TuYfTS3a1dDeLtmqd4XK/RNydpJEOe
	 ow8ilg3AvL+VtOW+a73MVzsW07JcdZ5kDB9pCtFvIrmWnjJQPa4c5vgxeEF6uMdzBt
	 NKmt/8uU7OcPn1Ct/OfvyNVxgAPH2AaLCt/1qOzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 7.2 111/713] usb: gadget: u_audio: Fix use-after-free on sound card disconnect
Date: Fri,  4 Sep 2026 06:51:19 +0200
Message-ID: <20260904045806.325270635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonali Pradhan <sonalipradhan@google.com>

commit 858965947081d10d41d9a1010a540d3d5eea958b upstream.

g_audio_cleanup() invokes snd_card_free_when_closed() to initiate sound
card teardown and immediately frees the underlying struct snd_uac_chip
context. However, snd_card_free_when_closed() returns asynchronously
while ALSA control elements (kctls) remain open in userspace.

When userspace control applications access or close these open file
descriptors, kctl callbacks attempt to dereference kctl->private_data
pointing to &uac->c_prm or &uac->p_prm within the freed uac structure,
resulting in a use-after-free (UAF) memory corruption.

Fix this issue by deferring the destruction of struct snd_uac_chip until
all references to the ALSA sound card are released. Register a custom
card->private_free callback (u_audio_card_free) during g_audio_setup()
that frees uac and its associated playback/capture request and ring
buffers only when the sound card reference count drops to zero.

Fixes: 6c67ed9ad9b8 ("usb: gadget: u_audio: don't let userspace block driver unbind")
Cc: stable@vger.kernel.org
Signed-off-by: Sonali Pradhan <sonalipradhan@google.com>
Link: https://patch.msgid.link/20260810071237.2207680-1-sonalipradhan@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_audio.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -1177,6 +1177,20 @@ static struct snd_kcontrol_new u_audio_c
 	},
 };
 
+static void u_audio_card_free(struct snd_card *card)
+{
+	struct snd_uac_chip *uac = card->private_data;
+
+	if (!uac)
+		return;
+
+	kfree(uac->p_prm.reqs);
+	kfree(uac->c_prm.reqs);
+	kfree(uac->p_prm.rbuf);
+	kfree(uac->c_prm.rbuf);
+	kfree(uac);
+}
+
 int g_audio_setup(struct g_audio *g_audio, const char *pcm_name,
 					const char *card_name)
 {
@@ -1256,6 +1270,8 @@ int g_audio_setup(struct g_audio *g_audi
 		goto fail;
 
 	uac->card = card;
+	card->private_data = uac;
+	card->private_free = u_audio_card_free;
 
 	/*
 	 * Create first PCM device
@@ -1424,6 +1440,8 @@ int g_audio_setup(struct g_audio *g_audi
 
 snd_fail:
 	snd_card_free(card);
+	return err;
+
 fail:
 	kfree(uac->p_prm.reqs);
 	kfree(uac->c_prm.reqs);
@@ -1449,12 +1467,6 @@ void g_audio_cleanup(struct g_audio *g_a
 	card = uac->card;
 	if (card)
 		snd_card_free_when_closed(card);
-
-	kfree(uac->p_prm.reqs);
-	kfree(uac->c_prm.reqs);
-	kfree(uac->p_prm.rbuf);
-	kfree(uac->c_prm.rbuf);
-	kfree(uac);
 }
 EXPORT_SYMBOL_GPL(g_audio_cleanup);
 


