Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973E746B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAC9C433D2;
	Mon, 16 Jan 2023 16:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886435;
	bh=yL4H6Ljv4PDUsYFox5/DrSbySQDKl8rPhplqb010Sf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJm7AhDToOGKs9+mmzwMwPasmMNn8dDf1mH1qvi482NwD3AKufutnltPYprGeKVul
	 nxowOJB1fTGl6+DfD+mytx68Kfof+B+tIiIWY1vaS6uzA6FtdmmOCOX8QjlUOw3rjA
	 x4DplBvosHANoNFipGnL1kvPDNpXK/9xCATLbT70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 430/658] ALSA/ASoC: hda: move/rename snd_hdac_ext_stop_streams to hdac_stream.c
Date: Mon, 16 Jan 2023 16:48:38 +0100
Message-Id: <20230116154929.219904336@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 12054f0ce8be7d2003ec068ab27c9eb608397b98 ]

snd_hdac_ext_stop_streams() has really nothing to do with the
extension, it just loops over the bus streams.

Move it to the hdac_stream layer and rename to remove the 'ext'
prefix and add the precision that the chip will also be stopped.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20211216231128.344321-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 171107237246 ("ASoC: Intel: Skylake: Fix driver hang during shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hdaudio.h         |  1 +
 include/sound/hdaudio_ext.h     |  1 -
 sound/hda/ext/hdac_ext_stream.c | 17 -----------------
 sound/hda/hdac_stream.c         | 16 ++++++++++++++++
 sound/soc/intel/skylake/skl.c   |  4 ++--
 5 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/include/sound/hdaudio.h b/include/sound/hdaudio.h
index 44e57bcc4a57..53e081bcd8ec 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -555,6 +555,7 @@ int snd_hdac_stream_set_params(struct hdac_stream *azx_dev,
 void snd_hdac_stream_start(struct hdac_stream *azx_dev, bool fresh_start);
 void snd_hdac_stream_clear(struct hdac_stream *azx_dev);
 void snd_hdac_stream_stop(struct hdac_stream *azx_dev);
+void snd_hdac_stop_streams_and_chip(struct hdac_bus *bus);
 void snd_hdac_stream_reset(struct hdac_stream *azx_dev);
 void snd_hdac_stream_sync_trigger(struct hdac_stream *azx_dev, bool set,
 				  unsigned int streams, unsigned int reg);
diff --git a/include/sound/hdaudio_ext.h b/include/sound/hdaudio_ext.h
index 23dc8deac344..91440476319a 100644
--- a/include/sound/hdaudio_ext.h
+++ b/include/sound/hdaudio_ext.h
@@ -92,7 +92,6 @@ void snd_hdac_ext_stream_decouple_locked(struct hdac_bus *bus,
 				  struct hdac_ext_stream *azx_dev, bool decouple);
 void snd_hdac_ext_stream_decouple(struct hdac_bus *bus,
 				struct hdac_ext_stream *azx_dev, bool decouple);
-void snd_hdac_ext_stop_streams(struct hdac_bus *bus);
 
 int snd_hdac_ext_stream_set_spib(struct hdac_bus *bus,
 				 struct hdac_ext_stream *stream, u32 value);
diff --git a/sound/hda/ext/hdac_ext_stream.c b/sound/hda/ext/hdac_ext_stream.c
index 04f4070fbf36..17b34bb9fecd 100644
--- a/sound/hda/ext/hdac_ext_stream.c
+++ b/sound/hda/ext/hdac_ext_stream.c
@@ -475,23 +475,6 @@ int snd_hdac_ext_stream_get_spbmaxfifo(struct hdac_bus *bus,
 }
 EXPORT_SYMBOL_GPL(snd_hdac_ext_stream_get_spbmaxfifo);
 
-
-/**
- * snd_hdac_ext_stop_streams - stop all stream if running
- * @bus: HD-audio core bus
- */
-void snd_hdac_ext_stop_streams(struct hdac_bus *bus)
-{
-	struct hdac_stream *stream;
-
-	if (bus->chip_init) {
-		list_for_each_entry(stream, &bus->stream_list, list)
-			snd_hdac_stream_stop(stream);
-		snd_hdac_bus_stop_chip(bus);
-	}
-}
-EXPORT_SYMBOL_GPL(snd_hdac_ext_stop_streams);
-
 /**
  * snd_hdac_ext_stream_drsm_enable - enable DMA resume for a stream
  * @bus: HD-audio core bus
diff --git a/sound/hda/hdac_stream.c b/sound/hda/hdac_stream.c
index b299b8b7f871..78d2674c7285 100644
--- a/sound/hda/hdac_stream.c
+++ b/sound/hda/hdac_stream.c
@@ -142,6 +142,22 @@ void snd_hdac_stream_stop(struct hdac_stream *azx_dev)
 }
 EXPORT_SYMBOL_GPL(snd_hdac_stream_stop);
 
+/**
+ * snd_hdac_stop_streams_and_chip - stop all streams and chip if running
+ * @bus: HD-audio core bus
+ */
+void snd_hdac_stop_streams_and_chip(struct hdac_bus *bus)
+{
+	struct hdac_stream *stream;
+
+	if (bus->chip_init) {
+		list_for_each_entry(stream, &bus->stream_list, list)
+			snd_hdac_stream_stop(stream);
+		snd_hdac_bus_stop_chip(bus);
+	}
+}
+EXPORT_SYMBOL_GPL(snd_hdac_stop_streams_and_chip);
+
 /**
  * snd_hdac_stream_reset - reset a stream
  * @azx_dev: HD-audio core stream to reset
diff --git a/sound/soc/intel/skylake/skl.c b/sound/soc/intel/skylake/skl.c
index 2e5fbd220923..dc6937a59443 100644
--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -438,7 +438,7 @@ static int skl_free(struct hdac_bus *bus)
 
 	skl->init_done = 0; /* to be sure */
 
-	snd_hdac_ext_stop_streams(bus);
+	snd_hdac_stop_streams_and_chip(bus);
 
 	if (bus->irq >= 0)
 		free_irq(bus->irq, (void *)bus);
@@ -1116,7 +1116,7 @@ static void skl_shutdown(struct pci_dev *pci)
 	if (!skl->init_done)
 		return;
 
-	snd_hdac_ext_stop_streams(bus);
+	snd_hdac_stop_streams_and_chip(bus);
 	list_for_each_entry(s, &bus->stream_list, list) {
 		stream = stream_to_hdac_ext_stream(s);
 		snd_hdac_ext_stream_decouple(bus, stream, false);
-- 
2.35.1



