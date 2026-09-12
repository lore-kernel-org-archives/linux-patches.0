Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB092D0C94;
	Sat, 12 Sep 2026 19:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241717; cv=none; b=UetBIZhei42TgPdy2g+AxtMm4Fihm5t8OyXGws/b6ntkUpCBRHQmUZTs2xVuSbFyL3zUyV53XCcDUN/iteHXBsosPiCtf3/MQcQT3Fn3igxU3N7h+VeWPAQmFjA1LFMfw3I9Hx4svxFOMbG6R8fp/AkkL28FZCNS1gWys5aMcLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241717; c=relaxed/simple;
	bh=/69LN+y7tIRUvv+UxHOePhoYgHscpepqG1Qk8zuDyM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsC2h7B2BCWZexkdzx8x2ClzbENoEvQRG7r8M/V+SmuzqQuHA2Y4dErnNftZSzyg9MKiRqvnlq8k1bcSsshesSwxn5vLrYH2u7S6fL4XINVWToWwAEG7SOGiuOAxE1Pi8Q5jrhMpoOr2pZnrT3qoDMpfAW3Nkc31YcN/Mdn6vlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMkd2cgD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMkd2cgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F651F000FF;
	Sat, 12 Sep 2026 19:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241716;
	bh=R/5hPZ3iqkzOgEb0wsxJBycvbGIm9GjAScXZxHmt+Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMkd2cgDKSekaxmnEuAobTujkgkinSae+8Pjqe2Wcu2XvXatCHOAYvVrHm7SAdWzY
	 cpSbV8peijWdOjwezE4XIQqVL7lAfft9aYjvkJ6zKEZRa4m/jkXzH3Dvax3ta3KRCm
	 YOKCJUl77IN4OXWSo2OzAV8NNvQl6I+m5A1nsodk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/798] usb: gadget: u_audio: Fix use-after-free on sound card disconnect
Date: Sat, 12 Sep 2026 08:56:59 +0200
Message-ID: <20260912065521.434289865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[sonalipradhan: resolved ureq field naming and placement conflicts for 5.10-stable]
Signed-off-by: Sonali Pradhan <sonalipradhan@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_audio.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index a387ff2c8b730..2d190d6f628c3 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -486,6 +486,20 @@ void u_audio_stop_playback(struct g_audio *audio_dev)
 }
 EXPORT_SYMBOL_GPL(u_audio_stop_playback);
 
+static void u_audio_card_free(struct snd_card *card)
+{
+	struct snd_uac_chip *uac = card->private_data;
+
+	if (!uac)
+		return;
+
+	kfree(uac->p_prm.ureq);
+	kfree(uac->c_prm.ureq);
+	kfree(uac->p_prm.rbuf);
+	kfree(uac->c_prm.rbuf);
+	kfree(uac);
+}
+
 int g_audio_setup(struct g_audio *g_audio, const char *pcm_name,
 					const char *card_name)
 {
@@ -560,6 +574,8 @@ int g_audio_setup(struct g_audio *g_audio, const char *pcm_name,
 		goto fail;
 
 	uac->card = card;
+	card->private_data = uac;
+	card->private_free = u_audio_card_free;
 
 	/*
 	 * Create first PCM device
@@ -591,6 +607,8 @@ int g_audio_setup(struct g_audio *g_audio, const char *pcm_name,
 
 snd_fail:
 	snd_card_free(card);
+	return err;
+
 fail:
 	kfree(uac->p_prm.ureq);
 	kfree(uac->c_prm.ureq);
@@ -616,12 +634,6 @@ void g_audio_cleanup(struct g_audio *g_audio)
 	card = uac->card;
 	if (card)
 		snd_card_free_when_closed(card);
-
-	kfree(uac->p_prm.ureq);
-	kfree(uac->c_prm.ureq);
-	kfree(uac->p_prm.rbuf);
-	kfree(uac->c_prm.rbuf);
-	kfree(uac);
 }
 EXPORT_SYMBOL_GPL(g_audio_cleanup);
 
-- 
2.53.0



