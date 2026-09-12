Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE4F357CFC;
	Sat, 12 Sep 2026 13:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219939; cv=none; b=Y54ZiLS6SfyK2rMQnMOwunqm3HEhsXLLR7MT30K41XcmDgmsd/rzGrfoNplW5y2QlC09zf2pVAN+UmPIOOfy1/OazEqysNwnCzrKLGQsbgO6Ilm+opxm1oOVp0H9ROwp/jbGsf7b15ueIjdK/JXsyOnADwydRoOzqAefT708jLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219939; c=relaxed/simple;
	bh=vVS3Mp5bMio/Qss1tNpEr9sJQyJ/7a5n0J1pAsZ3MwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvoDo69Qfgx75E2qu9mrHd5YQzPfqk5TVjJHaxrV2TixZ2h//L3OXRQI6UWCB4KYfS5+mqzWrceYIawoJOw5eln9zACkVGsKGImrSpltpgPVD3lXyMjlRPSOc8zC2ebzI3df0B+hQrLE+YpoZAS+NIOg1LSvfjwUq11q4+r137U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfiIrtXe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfiIrtXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38811F000FF;
	Sat, 12 Sep 2026 13:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219938;
	bh=ijPH36HyatFhFL1opFiAR8wK6UNYlN/Vb0f659cZcgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfiIrtXelTpblCRcM00homf0LcyVf8dTIEx/4raF85CCCI1XkCPChoEfOLrwsodrF
	 a6PIqmQKp7/reQdNbTnio8YYXDGT3mccXqcsNrPt1QWOHbiimeOh1+WKxnijhVvILZ
	 nQNJduuqYOzs/mGtJfG8CmNg6Z0l1fRGzlx3UTNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 6.6 0032/1424] usb: gadget: u_audio: Fix use-after-free on sound card disconnect
Date: Sat, 12 Sep 2026 08:41:04 +0200
Message-ID: <20260912065608.024861243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1258,6 +1272,8 @@ int g_audio_setup(struct g_audio *g_audi
 		goto fail;
 
 	uac->card = card;
+	card->private_data = uac;
+	card->private_free = u_audio_card_free;
 
 	/*
 	 * Create first PCM device
@@ -1425,6 +1441,8 @@ int g_audio_setup(struct g_audio *g_audi
 
 snd_fail:
 	snd_card_free(card);
+	return err;
+
 fail:
 	kfree(uac->p_prm.reqs);
 	kfree(uac->c_prm.reqs);
@@ -1450,12 +1468,6 @@ void g_audio_cleanup(struct g_audio *g_a
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
 


