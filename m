Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032562;
	b=UVeklF6/BGrHYfamWUD/+xpvWlL+mqkC9ekA+3OpA/+hTwXSy0j0VsWN8cAJUa5ydD+F
	 1rRCbaFJwSDaETEeoRXhqhD+xRS1s7asakczYwvcR0Vvh3XvwvNHI4e3z1vYMqy612WlN
	 P7YwenxZZQQcIgQw7LVDi7T14ItmdXeE12eH5LkPylV+anjszE48TAnQ1L+7lGNwieAcI
	 87/4H2qf5u4kQCFwUGJuoqh/XPzcJPU9ooZoULmi+uyF3jwX5EhCab5rhO+h0BtFJ65aU
	 irMAYQXSpQqgDechCEsvFnSMfiHkSdQK83A1RqlCw2wdT2EMZvKvtjsZlQXq+PZgD0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GdvSnAXdPRBd2wpMm8GavW1ozwjQEZWVRWh1qNCt0jM=;
	b=EdmSnwi2NhIOZHhbFN76dmzsb93sYFyyOR4uUtbflGt315vKMR/Dk8/7/fx+hkbzUypV
	 n6YMFaIAN71yZb4IUZDIDvx/ODMLOI/hsdk0BMcWyeNJCxh5ls1ZiBfet5CldtUjWfEt5
	 DRSY2IyJdbYuIfnAva8B32rZ3sUS4Pl3sLSi31Jpeb0y5q9d0PiZr9et+TEh2LzGdrkJe
	 N6pmxoI4/HtJcYaEjPfYb0auZO5Cd8ahOJvu2GukxIiVMANBpn/RZfxLKZsxL5V9XL6Vu
	 T7nTnjaG0t1M9p6/nTz+LBhUFp1Sqb4qnVhb6TgEfrTk2eoV30e2FJ09dMHU86ih3Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=seyFW3ds;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BCA606A32F;
	Wed, 18 Nov 2026 20:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=seyFW3ds
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AC51F000C5;
	Wed, 18 Nov 2026 20:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032562;
	bh=GdvSnAXdPRBd2wpMm8GavW1ozwjQEZWVRWh1qNCt0jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seyFW3dsbhYT/1EY3NyxMZEG5NYTdR37nGxw6q70hAfx3RU1ptpmqfvpFhylNbRtE
	 z+AdsgEOZAcudHyzIfrk9ozQlvU3djKSmBz7nGSEyMkyQn21sKIORUeCzskjGTsg4c
	 bO28p6kqWnIhXTfw03B7gsft19EIhGrz7Guw+JGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1418/1756] ALSA: aloop: Keep the timer source alive until card release
Date: Wed, 18 Nov 2026 15:59:05 +0100
Message-ID: <20261118150105.630369438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 762ef425cf0ac9c4b9e9e61e0da0950e16e6fbea ]

The timer_source string must remain valid while PCM opens can select
and parse it. loopback_set_timer_source() allocates the string with
parent-device devres, which can release it while the card is still
registered.

A successful nonempty proc replacement after snd_card_register() adds
the string allocation after trigger_card_free. Unbinding the platform
device while snd_aloop remains loaded releases devres in reverse order.
An open for an unused cable can run after the string is freed and before
the card-free action disconnects the card:

  Device unbind                      PCM open
  devres_release_all()
    free replacement string
                                     snd_pcm_open()
                                       snd_card_file_add()
                                       loopback_open()
                                         loopback_snd_timer_open()
                                           loopback_parse_timer_id()
    trigger_card_free()
      snd_card_free()
        snd_card_disconnect()

The parser can then read freed memory. KASAN has reported a one-byte
use-after-free read in strchr() from loopback_snd_timer_open(). The
cable_lock mutex serializes explicit replacements with opens, but
implicit devres release does not take it. The card and module references
held by PCM open do not retain this separate devres allocation.

Use kstrdup() and release the current string from card->private_free.
PCM admission already retains the card until each file is removed, and
card disconnect drains proc callbacks before final card release. This
keeps the string alive across admitted PCM opens and preserves the
cable_lock serialization of replacements. Install the callback before
the initial allocation so probe failures also release the string.

Fixes: b072e65aadd6 ("ALSA: aloop: Allocate resources with device-managed APIs")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM
Link: https://patch.msgid.link/pm-pmb-71a33a26d68356e3ade7-v1-108d86919c5c92fe1ea8@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 94ea73b3869c9..d7857659a7313 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -1784,13 +1784,10 @@ static int loopback_cable_proc_new(struct loopback *loopback, int cidx)
 static void loopback_set_timer_source(struct loopback *loopback,
 				      const char *value)
 {
-	if (loopback->timer_source) {
-		devm_kfree(loopback->card->dev, loopback->timer_source);
-		loopback->timer_source = NULL;
-	}
+	kfree(loopback->timer_source);
+	loopback->timer_source = NULL;
 	if (value && *value)
-		loopback->timer_source = devm_kstrdup(loopback->card->dev,
-						      value, GFP_KERNEL);
+		loopback->timer_source = kstrdup(value, GFP_KERNEL);
 }
 
 static void print_timer_source_info(struct snd_info_entry *entry,
@@ -1821,6 +1818,13 @@ static int loopback_timer_source_proc_new(struct loopback *loopback)
 				    change_timer_source_info);
 }
 
+static void loopback_private_free(struct snd_card *card)
+{
+	struct loopback *loopback = card->private_data;
+
+	kfree(loopback->timer_source);
+}
+
 static int loopback_probe(struct platform_device *devptr)
 {
 	struct snd_card *card;
@@ -1846,6 +1850,7 @@ static int loopback_probe(struct platform_device *devptr)
 		pcm_substreams[dev] = MAX_PCM_SUBSTREAMS;
 	
 	loopback->card = card;
+	card->private_free = loopback_private_free;
 	loopback_set_timer_source(loopback, timer_source[dev]);
 
 	mutex_init(&loopback->cable_lock);
-- 
2.53.0



