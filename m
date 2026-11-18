Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027381;
	b=LbiT1jBpFTKluGQzOvSwKq4U2ztHEjx6aPs63J976U8Jwvmui+o9l/b5Mfx9jc0zvucZ
	 sC7TckbiDhwkIGFHRP6EeNK53QYUfVS5y7yvjPXWSxLHzXkl8rC3xDcOMgZ3MXiqNJ+VQ
	 d2HIwu7UG8voj6gEmKHJggHI3YedsCx+Co3Ye3TfCYYsSOOV7mqUy3rOgYlit27XK1o5Q
	 ysM3x4HZHqLSUf/k8MJbM82pAXup96MB7DdxwdyOxDLwtTQTe7Bigdyha2CiNS2iwbzla
	 Xm7EizbE+QPoMAO0O4Wef3cqtRtbXH9CUAzFcVIZX/R5Ubcjnv1l+EKjPTVrAeiu2Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Yh8AIvxXbSMpOsvlGBjaIcy0wxGuK1n2COOTTHfKzo=;
	b=wXjyHchid/WIRzZwoTaaKKvAq14o7G5tNKVC8GAk5Hlz50xtsSK9zuq3RkwaZ5FqrNsu
	 apA4iu+xponQXoD/ra/58XBG2A+KNGnv8QwDkOZQAeD904eRpyQTWIgpPmGo5bSm7hxTI
	 5XWBU+qeTSEi7mxi+bj0NDLghdS/vxGuGRbwfc+VD4/5CkU4iD182me2c9Wxm87Y7i+QX
	 09LDgwcfv+p2zYini5hCFZW14NviTVwaqUyUF7cHpzdWINyuaeL2ngof6z7OD5DOsMQRz
	 ozhyXRZdifYxHYB9rU1f8UQktTpzZ8uDQjoRJUvMDbyVgFdbelIRGEbDdjD05OEHUlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9uZ0M9F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC400606A332;
	Wed, 18 Nov 2026 18:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9uZ0M9F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467321F000C4;
	Wed, 18 Nov 2026 18:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027380;
	bh=6Yh8AIvxXbSMpOsvlGBjaIcy0wxGuK1n2COOTTHfKzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9uZ0M9FOYZclvjkVv87JSSEJsuJivWlnGRNoj/eEEavXG9uSPef8s3PVU3VobLLU
	 FhIWPm+91NXnxs4Ery6rZhSkym9V7BuXK1FhF/Te1V78uQ8mKU+E5pY99oJSjpPJZM
	 7ntCbjGpSkiymmlLcreJdQYQMMGu4/qR+QEgIL3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Cen Zhang <zzzccc427@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1768/2151] ALSA: oss: Keep emulation modules loaded until object teardown
Date: Wed, 18 Nov 2026 15:58:23 +0100
Message-ID: <20261118150226.238127321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit f0780cfa6acf72576464dc3b40431db389f46ee8 ]

OSS proc entries and notifier callbacks can remain in use without an
open OSS device file. Normal snd-pcm-oss removal can therefore delete
an existing PCM's OSS proc entry while late HDA codec binding repeats
snd_card_register() on the same live card:

  OSS PCM module unload                 Card registration
  ---------------------                 -----------------
  snd_info_free_entry(entry)
    proc_remove(entry->p)
    clear entry->p
                                        snd_info_card_register()
                                          republish linked entry
    unlink and free entry

The new proc node retains a pointer to freed storage. Mixer OSS removal
can likewise release an adapter while a card notification still uses it.

Hold a snd-pcm-oss module reference for each PCM registered with its
notifier and a snd-mixer-oss reference for each card adapter. Release
them at final unregister or FREE, after proc and adapter cleanup. Normal
module unload can no longer initiate removal while these objects exist.

Track PCM OSS registration with a separate bool registered. Unlike
oss.reg, this state also covers unmapped PCMs and remains set across
DISCONNECT until final unregister. BUILD-state and creation-error cleanup
must not drop a reference when registration never acquired one. The PCM
notifier's register_mutex serialization keeps the final put ahead of
notifier removal and module teardown until dispatch has finished.

For mixer OSS, serialize callback publication, dispatch and withdrawal
in the core so module exit waits for callbacks, including one dropping
the last reference, to return. Keep card enumeration in the OSS module,
with card references released after dispatch drops the mutex. Ignore
duplicate REGISTER notifications so a delayed registration cannot
replace an adapter retained across DISCONNECT and leak its module pin.

Partial HDA codec teardown can still remove an individual PCM while the
card remains registered; its object-lifetime handling is separate.

Fixes: 2471b6c80a70 ("ALSA: info: Register proc entries recursively, too")
Suggested-by: Takashi Iwai <tiwai@suse.de>
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/pm-pmb-26d66390a25fec9fad6c-v6-5be251a3ac8832955a31-2@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/core.h       |  3 ++-
 include/sound/pcm_oss.h    |  1 +
 sound/core/init.c          | 29 +++++++++++++++++++++--------
 sound/core/oss/mixer_oss.c | 36 ++++++++++++++++++++----------------
 sound/core/oss/pcm_oss.c   | 12 ++++++++++++
 5 files changed, 56 insertions(+), 25 deletions(-)

diff --git a/include/sound/core.h b/include/sound/core.h
index 25dc738345d18..34111373f629a 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -298,7 +298,8 @@ int snd_card_locked(int card);
 #define SND_MIXER_OSS_NOTIFY_REGISTER	0
 #define SND_MIXER_OSS_NOTIFY_DISCONNECT	1
 #define SND_MIXER_OSS_NOTIFY_FREE	2
-extern int (*snd_mixer_oss_notify_callback)(struct snd_card *card, int cmd);
+void snd_mixer_oss_set_notify(int (*callback)(struct snd_card *card, int cmd));
+void snd_mixer_oss_notify(struct snd_card *card, int cmd);
 #endif
 
 int snd_card_new(struct device *parent, int idx, const char *xid,
diff --git a/include/sound/pcm_oss.h b/include/sound/pcm_oss.h
index c96f23c7755b1..43f7653000314 100644
--- a/include/sound/pcm_oss.h
+++ b/include/sound/pcm_oss.h
@@ -70,6 +70,7 @@ struct snd_pcm_oss_stream {
 struct snd_pcm_oss {
 	int reg;
 	unsigned int reg_mask;
+	bool registered;
 };
 
 #endif /* __SOUND_PCM_OSS_H */
diff --git a/sound/core/init.c b/sound/core/init.c
index 5e1be44b8036b..c7036c968f8a7 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -82,8 +82,24 @@ static int module_slot_match(struct module *module, int idx)
 }
 
 #if IS_ENABLED(CONFIG_SND_MIXER_OSS)
-int (*snd_mixer_oss_notify_callback)(struct snd_card *card, int free_flag);
-EXPORT_SYMBOL(snd_mixer_oss_notify_callback);
+static DEFINE_MUTEX(mixer_oss_notify_mutex);
+static int (*mixer_oss_notify_callback)(struct snd_card *card, int cmd);
+
+void snd_mixer_oss_notify(struct snd_card *card, int cmd)
+{
+	guard(mutex)(&mixer_oss_notify_mutex);
+	if (mixer_oss_notify_callback)
+		mixer_oss_notify_callback(card, cmd);
+}
+EXPORT_SYMBOL(snd_mixer_oss_notify);
+
+void snd_mixer_oss_set_notify(int (*callback)(struct snd_card *, int))
+{
+	/* Wait for callbacks, including a final module_put(), to return. */
+	guard(mutex)(&mixer_oss_notify_mutex);
+	mixer_oss_notify_callback = callback;
+}
+EXPORT_SYMBOL(snd_mixer_oss_set_notify);
 #endif
 
 static int check_empty_slot(struct module *module, int slot)
@@ -525,8 +541,7 @@ void snd_card_disconnect(struct snd_card *card)
 	/* at this point, they cannot respond to any calls except release() */
 
 #if IS_ENABLED(CONFIG_SND_MIXER_OSS)
-	if (snd_mixer_oss_notify_callback)
-		snd_mixer_oss_notify_callback(card, SND_MIXER_OSS_NOTIFY_DISCONNECT);
+	snd_mixer_oss_notify(card, SND_MIXER_OSS_NOTIFY_DISCONNECT);
 #endif
 
 	/* notify all devices that we are disconnected */
@@ -584,8 +599,7 @@ static int snd_card_do_free(struct snd_card *card)
 
 	card->releasing = true;
 #if IS_ENABLED(CONFIG_SND_MIXER_OSS)
-	if (snd_mixer_oss_notify_callback)
-		snd_mixer_oss_notify_callback(card, SND_MIXER_OSS_NOTIFY_FREE);
+	snd_mixer_oss_notify(card, SND_MIXER_OSS_NOTIFY_FREE);
 #endif
 	snd_device_free_all(card);
 	if (card->private_free)
@@ -923,8 +937,7 @@ int snd_card_register(struct snd_card *card)
 		return err;
 
 #if IS_ENABLED(CONFIG_SND_MIXER_OSS)
-	if (snd_mixer_oss_notify_callback)
-		snd_mixer_oss_notify_callback(card, SND_MIXER_OSS_NOTIFY_REGISTER);
+	snd_mixer_oss_notify(card, SND_MIXER_OSS_NOTIFY_REGISTER);
 #endif
 	return 0;
 }
diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index a7d66ea7c795d..f685ab3a0b58d 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -1306,13 +1306,22 @@ static int snd_mixer_oss_free1(void *private)
 static int snd_mixer_oss_notify_handler(struct snd_card *card, int cmd)
 {
 	struct snd_mixer_oss *mixer;
+	int err;
 
 	if (cmd == SND_MIXER_OSS_NOTIFY_REGISTER) {
-		int idx, err;
+		int idx;
+
+		/* Module loading and card registration can both notify us. */
+		if (card->mixer_oss)
+			return 0;
 
 		mixer = kcalloc(2, sizeof(*mixer), GFP_KERNEL);
 		if (mixer == NULL)
 			return -ENOMEM;
+		if (!try_module_get(THIS_MODULE)) {
+			kfree(mixer);
+			return -ENODEV;
+		}
 		mutex_init(&mixer->reg_mutex);
 		err = snd_register_oss_device(SNDRV_OSS_DEVICE_TYPE_MIXER,
 					      card, 0,
@@ -1322,6 +1331,7 @@ static int snd_mixer_oss_notify_handler(struct snd_card *card, int cmd)
 				"unable to register OSS mixer device %i:%i\n",
 				card->number, 0);
 			kfree(mixer);
+			module_put(THIS_MODULE);
 			return err;
 		}
 		mixer->oss_dev_alloc = 1;
@@ -1355,7 +1365,10 @@ static int snd_mixer_oss_notify_handler(struct snd_card *card, int cmd)
 		if (cmd == SND_MIXER_OSS_NOTIFY_DISCONNECT)
 			return 0;
 		snd_mixer_oss_proc_done(mixer);
-		return snd_mixer_oss_free1(mixer);
+		err = snd_mixer_oss_free1(mixer);
+		if (!err)
+			module_put(THIS_MODULE);
+		return err;
 	}
 	return 0;
 }
@@ -1364,12 +1377,12 @@ static int __init alsa_mixer_oss_init(void)
 {
 	struct snd_card *card;
 	int idx;
-	
-	snd_mixer_oss_notify_callback = snd_mixer_oss_notify_handler;
+
+	snd_mixer_oss_set_notify(snd_mixer_oss_notify_handler);
 	for (idx = 0; idx < SNDRV_CARDS; idx++) {
 		card = snd_card_ref(idx);
 		if (card) {
-			snd_mixer_oss_notify_handler(card, SND_MIXER_OSS_NOTIFY_REGISTER);
+			snd_mixer_oss_notify(card, SND_MIXER_OSS_NOTIFY_REGISTER);
 			snd_card_unref(card);
 		}
 	}
@@ -1378,17 +1391,8 @@ static int __init alsa_mixer_oss_init(void)
 
 static void __exit alsa_mixer_oss_exit(void)
 {
-	struct snd_card *card;
-	int idx;
-
-	snd_mixer_oss_notify_callback = NULL;
-	for (idx = 0; idx < SNDRV_CARDS; idx++) {
-		card = snd_card_ref(idx);
-		if (card) {
-			snd_mixer_oss_notify_handler(card, SND_MIXER_OSS_NOTIFY_FREE);
-			snd_card_unref(card);
-		}
-	}
+	/* Live adapters hold module references and prevent normal unload. */
+	snd_mixer_oss_set_notify(NULL);
 }
 
 module_init(alsa_mixer_oss_init)
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index 6d49451b730cd..6872375f96467 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -3144,6 +3144,12 @@ static void register_oss_dsp(struct snd_pcm *pcm, int index)
 
 static int snd_pcm_oss_register_minor(struct snd_pcm *pcm)
 {
+	if (pcm->oss.registered)
+		return 0;
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+	pcm->oss.registered = true;
+
 	pcm->oss.reg = 0;
 	if (dsp_map[pcm->card->number] == (int)pcm->device) {
 		char name[128];
@@ -3198,8 +3204,14 @@ static int snd_pcm_oss_disconnect_minor(struct snd_pcm *pcm)
 
 static int snd_pcm_oss_unregister_minor(struct snd_pcm *pcm)
 {
+	/* BUILD-state and creation-error cleanup need not have registered us. */
+	if (!pcm->oss.registered)
+		return 0;
+
 	snd_pcm_oss_disconnect_minor(pcm);
 	snd_pcm_oss_proc_done(pcm);
+	pcm->oss.registered = false;
+	module_put(THIS_MODULE);
 	return 0;
 }
 
-- 
2.53.0



