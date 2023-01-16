Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438D246B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C222CC433F0;
	Mon, 16 Jan 2023 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886438;
	bh=wDmleEyvph2GXtEySdw11tl0JYbJjArWIYg+rKev6TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDsVnuZClhbK4FqUhUD9jvxkVzeIZuOtG8okTA1QxdvcUGFDVF0oq+SJR3nyezJz1
	 Is1gmCiSfCMr4fILKU7uShxNCx/7lkS47qLjdSEXvY/wFpKRES5PvZhxzSuevXD6Bt
	 ZR+st37VIz74cSof4JO0R1yXHSuwYymSutvPOhUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 431/658] ALSA: hda: add snd_hdac_stop_streams() helper
Date: Mon, 16 Jan 2023 16:48:39 +0100
Message-Id: <20230116154929.269680985@linuxfoundation.org>
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

[ Upstream commit 24ad3835a6db4f8857975effa6bf47730371a5ff ]

Minor code reuse, no functionality change.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20220919121041.43463-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 171107237246 ("ASoC: Intel: Skylake: Fix driver hang during shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hdaudio.h        |  1 +
 sound/hda/hdac_stream.c        | 17 ++++++++++++++---
 sound/pci/hda/hda_controller.c |  4 +---
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/sound/hdaudio.h b/include/sound/hdaudio.h
index 53e081bcd8ec..749b1bce9fc6 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -555,6 +555,7 @@ int snd_hdac_stream_set_params(struct hdac_stream *azx_dev,
 void snd_hdac_stream_start(struct hdac_stream *azx_dev, bool fresh_start);
 void snd_hdac_stream_clear(struct hdac_stream *azx_dev);
 void snd_hdac_stream_stop(struct hdac_stream *azx_dev);
+void snd_hdac_stop_streams(struct hdac_bus *bus);
 void snd_hdac_stop_streams_and_chip(struct hdac_bus *bus);
 void snd_hdac_stream_reset(struct hdac_stream *azx_dev);
 void snd_hdac_stream_sync_trigger(struct hdac_stream *azx_dev, bool set,
diff --git a/sound/hda/hdac_stream.c b/sound/hda/hdac_stream.c
index 78d2674c7285..2beb94828729 100644
--- a/sound/hda/hdac_stream.c
+++ b/sound/hda/hdac_stream.c
@@ -142,17 +142,28 @@ void snd_hdac_stream_stop(struct hdac_stream *azx_dev)
 }
 EXPORT_SYMBOL_GPL(snd_hdac_stream_stop);
 
+/**
+ * snd_hdac_stop_streams - stop all streams
+ * @bus: HD-audio core bus
+ */
+void snd_hdac_stop_streams(struct hdac_bus *bus)
+{
+	struct hdac_stream *stream;
+
+	list_for_each_entry(stream, &bus->stream_list, list)
+		snd_hdac_stream_stop(stream);
+}
+EXPORT_SYMBOL_GPL(snd_hdac_stop_streams);
+
 /**
  * snd_hdac_stop_streams_and_chip - stop all streams and chip if running
  * @bus: HD-audio core bus
  */
 void snd_hdac_stop_streams_and_chip(struct hdac_bus *bus)
 {
-	struct hdac_stream *stream;
 
 	if (bus->chip_init) {
-		list_for_each_entry(stream, &bus->stream_list, list)
-			snd_hdac_stream_stop(stream);
+		snd_hdac_stop_streams(bus);
 		snd_hdac_bus_stop_chip(bus);
 	}
 }
diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index 6a159c6c2f54..6dff68691dff 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -1093,10 +1093,8 @@ EXPORT_SYMBOL_GPL(azx_init_chip);
 void azx_stop_all_streams(struct azx *chip)
 {
 	struct hdac_bus *bus = azx_bus(chip);
-	struct hdac_stream *s;
 
-	list_for_each_entry(s, &bus->stream_list, list)
-		snd_hdac_stream_stop(s);
+	snd_hdac_stop_streams(bus);
 }
 EXPORT_SYMBOL_GPL(azx_stop_all_streams);
 
-- 
2.35.1



