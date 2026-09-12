Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163F43AC0ED;
	Sat, 12 Sep 2026 17:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232473; cv=none; b=doD+YJOSudIY+Di/6Sua0j0wz/VGjndcdmxyKRLcnjQ0xlcaDJBIAlxy5uzzGB8W6CKXrGngRy5wpQMxLfaojp/hL+Kq6fA7Ipt68wt6tG4Y37a3Ai8E0iZNyHlMurH/V4NUdQBLs99Frrsh3ChKKyNJnCdJhBLTIxxh2ehqiRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232473; c=relaxed/simple;
	bh=JVrLKf5ZMbkLKGpU9fbIkdu+vPyKicdF0EBK+26ftLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYVeY0G4C2431q1IwaWcsX/rNZDo9N0yhQs9W9Elj5nfaliGQ4WVxXhIiosWeiqW0h5P8rN48MwzeGWO5T1cCJY/bWP5XSh9YRnMN947OUcUTRd+ORkjRdD279cP+kAqXaxr2fl5MXQy7xHruqgKJpuxD09DhnJbDfCvr7K8Z+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2CXtn4V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2CXtn4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1C81F000FF;
	Sat, 12 Sep 2026 17:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232472;
	bh=EUM/I1UtQe58POlW/8lyFn6jWSWEyWuJtC3PtTM1GTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2CXtn4V2FsuMpiive5oNmuUSGlKodnuKDxMx6YQ1Y/ccuyXPp0S1/mBo/JMYLfxA
	 OIactB7XN0P9aAQaSvfE9UiZHrqil9weRh7yZ1rZDzUsFt41c4feqz46pVqZAULs0j
	 eTXobC3zSTivvuBmGwm3oZq0Xe0SbyjVRctPFi1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 5.15 018/935] usb: gadget: u_audio: Fix use-after-free on sound card disconnect
Date: Sat, 12 Sep 2026 08:50:48 +0200
Message-ID: <20260912065527.255633613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -967,6 +967,20 @@ static struct snd_kcontrol_new u_audio_c
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
@@ -1046,6 +1060,8 @@ int g_audio_setup(struct g_audio *g_audi
 		goto fail;
 
 	uac->card = card;
+	card->private_data = uac;
+	card->private_free = u_audio_card_free;
 
 	/*
 	 * Create first PCM device
@@ -1178,6 +1194,8 @@ int g_audio_setup(struct g_audio *g_audi
 
 snd_fail:
 	snd_card_free(card);
+	return err;
+
 fail:
 	kfree(uac->p_prm.reqs);
 	kfree(uac->c_prm.reqs);
@@ -1203,12 +1221,6 @@ void g_audio_cleanup(struct g_audio *g_a
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
 


