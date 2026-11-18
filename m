Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026093;
	b=RBc3pzCkYkDq5K5Z6AbD9IUokbnDvoEbMuT8Rdwng50rsXwHKcXzR/KNjviqxl0Nmjzx
	 p2clElVfQy9TngsOQSpXKk+sPRTR+Hpwc1Wh6N3IqoC0N4UcoS2zcCrG4vm42YeCq56+k
	 2GSEQ50xrZLeQhA4bgq499QzZ5q+jQleMp6+Ca8fIpQllOsLJ9DcvQ+13VHI4pYAcr0O3
	 usEBKFeJZSTiO43A1H2D6hniWq2Zgs/Fi16q/8dA7Jg5yPZDb/8kb1FOZIqpN2n7CC7AI
	 CH7/4xIXy87ufuq4HetwfnkamtGj0POozON7Rlmni7JcSG8tni394A/2uuuDymDbsew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZePGRpV3XCctyEA/h6w5aVmORc4M6jFVB/QHN1V0EdI=;
	b=01buYAaXWXXFc4m7qI0sbvnN97ahJTj+YQaXqgSvZYjKiaEGTPl38Om1I/n0JYuDRInj
	 HMx0CgunZ3AiPNhyvUdT+RWIhXwt5q+Ltjl2pExMpbS8NG7ArdDTZvXvLfFtK7te+NvCT
	 +G4aodhNuQJoVYIWa8o4x6kOd7M/h0drrRGiwcu7CVwwhrsoVqzPyfKlbqhxaWDlCogyk
	 NMHbAjceOt5oJezOyHryq5q32ZbLCZjz6AYOUe8Vf8ZTYL3R5uGRNw34MTkTmSIqLc2ru
	 ztnCyR7+IjOQU8XiqB5stzsI48GxtWtH4Y5TpM/nAxMCsSRuyMXKrtR9uL02QOAMR9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KOvLIchk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEDE606A31C;
	Wed, 18 Nov 2026 18:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KOvLIchk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8A41F000C4;
	Wed, 18 Nov 2026 18:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026093;
	bh=ZePGRpV3XCctyEA/h6w5aVmORc4M6jFVB/QHN1V0EdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KOvLIchkHKjdSpMdJ1L6QJENgUz7rckUkruKIMFfKm6uzQo0LuLBGreUBe1qckLTf
	 NQLZ9v/MHQDNQ3xt/J4UGSYISSrax1UKRKDoO3zoWG9jUx24E46Q6DoqsqXcjH0wq0
	 2qqd2Y6Bs8ML1/xsc4EC9wPyZtV7qeBswasZMXrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1312/2151] ALSA: hda: Stop unsol events and jack polling before codec unbind
Date: Wed, 18 Nov 2026 15:50:47 +0100
Message-ID: <20261118150209.894321089@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f3607b6952ca9a5638eeef4f301daa7933ce24b1 ]

At unbinding a codec driver, hda_codec_driver_remove() calls the
codec's remove callback that releases the driver resources, followed
by snd_hda_codec_cleanup_for_unbind().  Meanwhile, the unsolicited
events are processed asynchronously in bus->unsol_work, and
snd_hdac_bus_process_unsol_events() checks only codec->registered flag
before calling the driver's unsol_event callback without the lock.
Since codec->registered is cleared only in
snd_hda_codec_cleanup_for_unbind(), and there is no flush of the unsol
work at unbinding, the unsol event handler may run concurrently during
the running remove callback, which may lead to a UAF.  The same
problem applies to the jack polling work, which is canceled only after
the remove callback.

For addressing those races, introduce a new flag unsol_disabled to
hdac_device, to be checked it in the unsol event worker, while a new
helper snd_hdac_device_disable_unsol() sets this flag and flushes the
pending unsol work.  The helper is called at hda_codec_driver_remove()
together with the cancel of jackpoll_work to assure that no
asynchronous jack handling can run.  The flag is cleared again at
probing the codec driver, while the events are still blocked by the
registered flag until the codec gets registered.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: LLM
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007215650.159871-2-tiwai@suse.de
Stable-dep-of: 7a78c18bffc6 ("ALSA: hda: Disable unsol event handling at error and shutdown paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hdaudio.h |  2 ++
 sound/hda/common/bind.c |  7 +++++++
 sound/hda/core/bus.c    | 21 ++++++++++++++++++++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/sound/hdaudio.h b/include/sound/hdaudio.h
index 4e0c1d8af09f7..a27cd13735808 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -96,6 +96,7 @@ struct hdac_device {
 	bool caps_overwriting:1; /* caps overwrite being in process */
 	bool cache_coef:1;	/* cache COEF read/write too */
 	unsigned int registered:1; /* codec was registered */
+	bool unsol_disabled;	/* unsol events blocked; protected by bus->reg_lock */
 };
 
 /* device/driver type used for matching */
@@ -122,6 +123,7 @@ int snd_hdac_device_init(struct hdac_device *dev, struct hdac_bus *bus,
 			 const char *name, unsigned int addr);
 void snd_hdac_device_exit(struct hdac_device *dev);
 int snd_hdac_device_register(struct hdac_device *codec);
+void snd_hdac_device_disable_unsol(struct hdac_device *codec);
 void snd_hdac_device_unregister(struct hdac_device *codec);
 int snd_hdac_device_set_chip_name(struct hdac_device *codec, const char *name);
 int snd_hdac_codec_modalias(const struct hdac_device *hdac, char *buf, size_t size);
diff --git a/sound/hda/common/bind.c b/sound/hda/common/bind.c
index bb1090b656990..c264d7c3f5460 100644
--- a/sound/hda/common/bind.c
+++ b/sound/hda/common/bind.c
@@ -100,6 +100,9 @@ static int hda_codec_driver_probe(struct device *dev)
 	if (WARN_ON(!codec->preset))
 		return -EINVAL;
 
+	/* unsol events are still blocked until registered */
+	codec->core.unsol_disabled = false;
+
 	err = snd_hda_codec_set_name(codec, codec->preset->name);
 	if (err < 0)
 		goto error;
@@ -160,6 +163,10 @@ static int hda_codec_driver_remove(struct device *dev)
 		return codec->bus->core.ext_ops->hdev_detach(&codec->core);
 	}
 
+	/* stop asynchronous jack handling before freeing driver resources */
+	snd_hdac_device_disable_unsol(&codec->core);
+	cancel_delayed_work_sync(&codec->jackpoll_work);
+
 	snd_hda_codec_disconnect_pcms(codec);
 	snd_hda_jack_tbl_disconnect(codec);
 	if (!refcount_dec_and_test(&codec->pcm_ref))
diff --git a/sound/hda/core/bus.c b/sound/hda/core/bus.c
index 9b196c915f378..e9c3751a15395 100644
--- a/sound/hda/core/bus.c
+++ b/sound/hda/core/bus.c
@@ -179,7 +179,7 @@ static void snd_hdac_bus_process_unsol_events(struct work_struct *work)
 		if (!(caddr & (1 << 4))) /* no unsolicited event? */
 			continue;
 		codec = bus->caddr_tbl[caddr & 0x0f];
-		if (!codec || !codec->registered)
+		if (!codec || !codec->registered || codec->unsol_disabled)
 			continue;
 		spin_unlock_irq(&bus->reg_lock);
 		drv = drv_to_hdac_driver(codec->dev.driver);
@@ -190,6 +190,25 @@ static void snd_hdac_bus_process_unsol_events(struct work_struct *work)
 	spin_unlock_irq(&bus->reg_lock);
 }
 
+/**
+ * snd_hdac_device_disable_unsol - block and flush unsol events for the codec
+ * @codec: the HDA core device
+ *
+ * Stop dispatching the unsolicited events to the given codec, and wait for
+ * the pending unsol event handler to finish.  Called at unbinding the codec
+ * driver before releasing the driver resources.
+ */
+void snd_hdac_device_disable_unsol(struct hdac_device *codec)
+{
+	struct hdac_bus *bus = codec->bus;
+
+	spin_lock_irq(&bus->reg_lock);
+	codec->unsol_disabled = true;
+	spin_unlock_irq(&bus->reg_lock);
+	flush_work(&bus->unsol_work);
+}
+EXPORT_SYMBOL_GPL(snd_hdac_device_disable_unsol);
+
 /**
  * snd_hdac_bus_add_device - Add a codec to bus
  * @bus: HDA core bus
-- 
2.53.0



