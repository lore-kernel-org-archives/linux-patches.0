Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021010;
	b=3tc4TPvJfR+0DYPg/p7+84fAHmT5KPbHl7prkzDdA8D1jS2DDjAhl+jgqNPexdwqPCAd
	 pUq8sNZit72bjPU5oU75VCpANZvrkK2nMcSzAm+bKGRJHx0LewRkPHb326nH4YC5n0FDX
	 BZmw0ne50wa0fFpIn6bE+73AGXHVrILGfsJK5lbrtgH5m3fbQuZWq08bxVramHreG8qkO
	 CyAjd5VOP4cGkuoikc2eM+KxnUDrGT7KaQ28jGuGyJ1macnpI+Ik0FV47+kef9Aj3Bfm+
	 V0U8cau/E4/tTTAouQjV6vZpJxOtxmdfJI+jxyuzzVPjZtYgOIM5dGl/A6zYTqDaWCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sovT6K4fbS9lz6zCYYKuG3ou4IM7Wl0W10eC70Xlmxo=;
	b=bWlc/WUWp+R47aHpF6h/n66TTz0Ns3pS9AAxd5L8gIENnpIKA2VdGRxO0ujrJ2AdSg43
	 38WpMSU4Vela7v7EpMeAxBx3RTOioPyRq1t0v16311RzPaNJg1eb5cJTqacGiUh2I/KpB
	 RIGDDpZaBCa1R8Ay7iQyhkzbdqr7gLnZF095uPfgi2fhjSvL3B6Ff2gGV20YruFQ/uCUn
	 px26lOJOvTDxg8FPF6NNRvPDjANSdynZAOee/vbD+OwyvLh4wjWkzDQZxz9uJWUxW+yXI
	 cuRFldKe0ydKq9ci5a7hNICPJe/PvI0mMLoyBKottLcNMUg9t5q8IPlelUri46RuXfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fH/BPtWl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA1A606A31C;
	Wed, 18 Nov 2026 16:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fH/BPtWl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CD41F000C4;
	Wed, 18 Nov 2026 16:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021009;
	bh=sovT6K4fbS9lz6zCYYKuG3ou4IM7Wl0W10eC70Xlmxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fH/BPtWlKLMNQZl1+rE3YjIhK9X11rFItxCuXwT+Hzb22SeIXcypVugJXvh0rSY38
	 cQ7Lkgd2YsMllm7ao6Ff91v5vKERIbV3L8UXd/PlefsUsEza66ju26fLHslnHhovHp
	 CE+Nmx8xIoEk1VPdfpcbSam7vVXIHkyPn9UPavyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Cen Zhang <zzzccc427@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2156/2651] ALSA: oss: Keep emulation modules loaded until object teardown
Date: Wed, 18 Nov 2026 15:56:36 +0100
Message-ID: <20261118150403.438501805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bea596f36f58e..043e2f957e7f1 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -301,7 +301,8 @@ int snd_card_locked(int card);
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
index b77f99d088e71..972db4a8cea67 100644
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
@@ -530,8 +546,7 @@ void snd_card_disconnect(struct snd_card *card)
 	/* at this point, they cannot respond to any calls except release() */
 
 #if IS_ENABLED(CONFIG_SND_MIXER_OSS)
-	if (snd_mixer_oss_notify_callback)
-		snd_mixer_oss_notify_callback(card, SND_MIXER_OSS_NOTIFY_DISCONNECT);
+	snd_mixer_oss_notify(card, SND_MIXER_OSS_NOTIFY_DISCONNECT);
 #endif
 
 	/* notify all devices that we are disconnected */
@@ -589,8 +604,7 @@ static int snd_card_do_free(struct snd_card *card)
 
 	card->releasing = true;
 #if IS_ENABLED(CONFIG_SND_MIXER_OSS)
-	if (snd_mixer_oss_notify_callback)
-		snd_mixer_oss_notify_callback(card, SND_MIXER_OSS_NOTIFY_FREE);
+	snd_mixer_oss_notify(card, SND_MIXER_OSS_NOTIFY_FREE);
 #endif
 	snd_device_free_all(card);
 	kfree(card->components);
@@ -934,8 +948,7 @@ int snd_card_register(struct snd_card *card)
 		return err;
 
 #if IS_ENABLED(CONFIG_SND_MIXER_OSS)
-	if (snd_mixer_oss_notify_callback)
-		snd_mixer_oss_notify_callback(card, SND_MIXER_OSS_NOTIFY_REGISTER);
+	snd_mixer_oss_notify(card, SND_MIXER_OSS_NOTIFY_REGISTER);
 #endif
 	return 0;
 }
diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index c533d767c29ac..c3f53eb64f92d 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -1308,13 +1308,22 @@ static int snd_mixer_oss_free1(void *private)
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
 
 		mixer = kzalloc_objs(*mixer, 2);
 		if (mixer == NULL)
 			return -ENOMEM;
+		if (!try_module_get(THIS_MODULE)) {
+			kfree(mixer);
+			return -ENODEV;
+		}
 		mutex_init(&mixer->reg_mutex);
 		err = snd_register_oss_device(SNDRV_OSS_DEVICE_TYPE_MIXER,
 					      card, 0,
@@ -1324,6 +1333,7 @@ static int snd_mixer_oss_notify_handler(struct snd_card *card, int cmd)
 				"unable to register OSS mixer device %i:%i\n",
 				card->number, 0);
 			kfree(mixer);
+			module_put(THIS_MODULE);
 			return err;
 		}
 		mixer->oss_dev_alloc = 1;
@@ -1357,7 +1367,10 @@ static int snd_mixer_oss_notify_handler(struct snd_card *card, int cmd)
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
@@ -1366,12 +1379,12 @@ static int __init alsa_mixer_oss_init(void)
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
@@ -1380,17 +1393,8 @@ static int __init alsa_mixer_oss_init(void)
 
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
index bd19328dca9e3..e8df27d09b971 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -3151,6 +3151,12 @@ static void register_oss_dsp(struct snd_pcm *pcm, int index)
 
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
@@ -3205,8 +3211,14 @@ static int snd_pcm_oss_disconnect_minor(struct snd_pcm *pcm)
 
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



