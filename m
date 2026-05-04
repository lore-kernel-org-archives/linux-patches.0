Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A081315785;
	Mon,  4 May 2026 14:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904535; cv=none; b=DVHoZEMyofWtc8cr9gl06RBRbf9hD82S1Z+N1ptGaW9tWnS7AoOd2jKfYuqZOrLo3UZ8rh60F83gBI0M/neniI5m+mR4UMQIjzxb2Z/nprsBvXr4tpq/tZorqK3Eh72A5JjgNSow1m8gTmlL0UlX+XJO/0QVJdRdXJk24mpZBfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904535; c=relaxed/simple;
	bh=PRNjAjUe//lAUKZJBstQPbos4JQt0vngPZ+hznGd0aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GwhcJ24x8iP9UZslmmoTBMu0rsDqLoCB5Ej0NZJD9x7+4lizfCLwVe4ZqwpONHDMIj55cdOTNoB4Iqy0xMwH5KhnzUwenDhWL7YeCDWqaQj1HZDouVyU4kXx7oviLkSCMzMLoD55xa3VxclzHb/KUo7A9X4VkckZ2OSXYrhLCA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFp4/aT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFp4/aT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E7CC2BCB8;
	Mon,  4 May 2026 14:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904535;
	bh=PRNjAjUe//lAUKZJBstQPbos4JQt0vngPZ+hznGd0aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFp4/aT+VmTGSO3JDP7eyqBhtRSI8CzDZaUZRSO3KiwFpUfanJuU5JlUE5hohW/Lr
	 gcE2dE4D2he7r3PYJhwMscXNiSQFfulObt8IMrG0RfOFzf4dbpAVkujRaJZbGZJvyv
	 8Wk6Lyt+eWyBCOymLBb0qUYLaPaK1GCwUantfo9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 077/215] ALSA: 6fire: Fix input volume change detection
Date: Mon,  4 May 2026 15:51:36 +0200
Message-ID: <20260504135132.978464418@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit dc88eef8f55e85e92d016cdf7e291f5560efd79b upstream.

usb6fire_control_input_vol_put() stores the analog capture volume
as a signed offset in rt->input_vol[] (-15..+15), but it compares
the cached value against the user-visible mixer value (0..30)
before subtracting 15.

This mixes two domains in the change detection path. Since the
runtime is zero-initialized, the visible default is 15; writing 0
right after probe is ignored, while writing 15 is reported as a
change even though the cached value remains 0.

Normalize the user value before comparing it with the cached offset.

Fixes: 06bb4e743501 ("ALSA: snd-usb-6fire: add analog input volume control")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260416-alsa-6fire-input-volume-change-detection-v1-1-ec78299168df@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/6fire/control.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/sound/usb/6fire/control.c
+++ b/sound/usb/6fire/control.c
@@ -290,15 +290,17 @@ static int usb6fire_control_input_vol_pu
 		struct snd_ctl_elem_value *ucontrol)
 {
 	struct control_runtime *rt = snd_kcontrol_chip(kcontrol);
+	int vol0 = ucontrol->value.integer.value[0] - 15;
+	int vol1 = ucontrol->value.integer.value[1] - 15;
 	int changed = 0;
 
-	if (rt->input_vol[0] != ucontrol->value.integer.value[0]) {
-		rt->input_vol[0] = ucontrol->value.integer.value[0] - 15;
+	if (rt->input_vol[0] != vol0) {
+		rt->input_vol[0] = vol0;
 		rt->ivol_updated &= ~(1 << 0);
 		changed = 1;
 	}
-	if (rt->input_vol[1] != ucontrol->value.integer.value[1]) {
-		rt->input_vol[1] = ucontrol->value.integer.value[1] - 15;
+	if (rt->input_vol[1] != vol1) {
+		rt->input_vol[1] = vol1;
 		rt->ivol_updated &= ~(1 << 1);
 		changed = 1;
 	}


