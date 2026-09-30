Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40013BED0C;
	Wed, 30 Sep 2026 19:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795412; cv=none; b=QAJo8aeLifu7n7I/xtCeiY3cD8EwiYC+nQy9ASZwEVon8INZag9Zig9sgVJ5MpdN1s0RIwL7MFMgupFFtouOHvmuqa/567KzIbyD4lvrbPljNMY42A734WPOnETMynGJ4/wm5v50KhFOQuoGOH9ASKKa9kBV2gRuVU1TZiZhT5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795412; c=relaxed/simple;
	bh=d82UJJM4hC5NU8ueE8cSw3lKcMcTWNWk6NkOmptKkig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKyRfsooknSSeMW1vq5XcvCkXxYDZgkfp62j1WzYJq2ek8vIg8ewbp4ivELOHDBTemZ/YLf8CbPnQZDEC2N3Ol+lfy+FczHzc7lEu8rT0OjDXjI1xg5E/S3KOfOH2o46yqkqA8JDHLmR6fOffYXkacjDOHCryijZtFhrO36YNyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1NvX79B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1NvX79B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD761F000FF;
	Wed, 30 Sep 2026 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795410;
	bh=h63B5Q1FordlxLB51ZFr1yjO8QB7AiaOF43UdnG5KtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1NvX79BiFNTdC7BY9hp+P2WIaPt5eAmOCWNtkRkf+O97SGPop9Kle/+pJQkQN0XX
	 D+7qez6I2xf9F2jVuA9+W2cFfYcIThH6GHi03YZDTm48vHCspIFnHvGMrj47JkQaNN
	 ahgT3NCKpE/6QcMiBFeFou10vK4EPqt6/i95aM7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0551/1193] ALSA: hda/common: Use cleanup macros for PM controls
Date: Wed, 30 Sep 2026 17:20:35 +0200
Message-ID: <20260930152446.478768232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8dad6b3dac2794c52d63b2336138392eddc17936 ]

The new macro CLASS(snd_hda_power_pm) can replace the manual
snd_hda_power_up_pm() and _down() calls gracefully.

A part of the code in codec_exec_verb() is factored out to a function,
so that the auto-cleanup can be well scoped.

Merely cleanups and no functional changes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250827072916.31933-6-tiwai@suse.de
Stable-dep-of: 728478874312 ("ALSA: hda: Report a change when only the channel status bytes move")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 30 +++++++++++++++++++-----------
 sound/pci/hda/hda_proc.c  |  4 +---
 sound/pci/hda/hda_sysfs.c | 11 ++++-------
 3 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 80c3084189b03..8a2b3c2a16685 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -31,6 +31,23 @@
 #define codec_has_clkstop(codec) \
 	((codec)->core.power_caps & AC_PWRST_CLKSTOP)
 
+static int call_exec_verb(struct hda_bus *bus, struct hda_codec *codec,
+			  unsigned int cmd, unsigned int flags,
+			  unsigned int *res)
+{
+	int err;
+
+	CLASS(snd_hda_power_pm, pm)(codec);
+	mutex_lock(&bus->core.cmd_mutex);
+	if (flags & HDA_RW_NO_RESPONSE_FALLBACK)
+		bus->no_response_fallback = 1;
+	err = snd_hdac_bus_exec_verb_unlocked(&bus->core, codec->core.addr,
+					      cmd, res);
+	bus->no_response_fallback = 0;
+	mutex_unlock(&bus->core.cmd_mutex);
+	return err;
+}
+
 /*
  * Send and receive a verb - passed to exec_verb override for hdac_device
  */
@@ -45,15 +62,7 @@ static int codec_exec_verb(struct hdac_device *dev, unsigned int cmd,
 		return -1;
 
  again:
-	snd_hda_power_up_pm(codec);
-	mutex_lock(&bus->core.cmd_mutex);
-	if (flags & HDA_RW_NO_RESPONSE_FALLBACK)
-		bus->no_response_fallback = 1;
-	err = snd_hdac_bus_exec_verb_unlocked(&bus->core, codec->core.addr,
-					      cmd, res);
-	bus->no_response_fallback = 0;
-	mutex_unlock(&bus->core.cmd_mutex);
-	snd_hda_power_down_pm(codec);
+	err = call_exec_verb(bus, codec, cmd, flags, res);
 	if (!codec_in_pm(codec) && res && err == -EAGAIN) {
 		if (bus->response_reset) {
 			codec_dbg(codec,
@@ -645,12 +654,11 @@ static void hda_jackpoll_work(struct work_struct *work)
 		return;
 
 	/* the power-up/down sequence triggers the runtime resume */
-	snd_hda_power_up(codec);
+	CLASS(snd_hda_power, pm)(codec);
 	/* update jacks manually if polling is required, too */
 	snd_hda_jack_set_dirty_all(codec);
 	snd_hda_jack_poll_all(codec);
 	schedule_delayed_work(&codec->jackpoll_work, codec->jackpoll_interval);
-	snd_hda_power_down(codec);
 }
 
 /* release all pincfg lists */
diff --git a/sound/pci/hda/hda_proc.c b/sound/pci/hda/hda_proc.c
index e8a4cf3c84d82..f7ad5a18c8797 100644
--- a/sound/pci/hda/hda_proc.c
+++ b/sound/pci/hda/hda_proc.c
@@ -782,7 +782,7 @@ static void print_codec_info(struct snd_info_entry *entry,
 	fg = codec->core.afg;
 	if (!fg)
 		return;
-	snd_hda_power_up(codec);
+	CLASS(snd_hda_power, pm)(codec);
 	snd_iprintf(buffer, "Default PCM:\n");
 	print_pcm_caps(buffer, codec, fg);
 	snd_iprintf(buffer, "Default Amp-In caps: ");
@@ -795,7 +795,6 @@ static void print_codec_info(struct snd_info_entry *entry,
 	nodes = snd_hda_get_sub_nodes(codec, fg, &nid);
 	if (! nid || nodes < 0) {
 		snd_iprintf(buffer, "Invalid AFG subtree\n");
-		snd_hda_power_down(codec);
 		return;
 	}
 
@@ -932,7 +931,6 @@ static void print_codec_info(struct snd_info_entry *entry,
 
 		kfree(conn);
 	}
-	snd_hda_power_down(codec);
 }
 
 /*
diff --git a/sound/pci/hda/hda_sysfs.c b/sound/pci/hda/hda_sysfs.c
index 69ebc37a4d6f3..80359e518ee55 100644
--- a/sound/pci/hda/hda_sysfs.c
+++ b/sound/pci/hda/hda_sysfs.c
@@ -131,21 +131,18 @@ static int reconfig_codec(struct hda_codec *codec)
 {
 	int err;
 
-	snd_hda_power_up(codec);
+	CLASS(snd_hda_power, pm)(codec);
 	codec_info(codec, "hda-codec: reconfiguring\n");
 	err = snd_hda_codec_reset(codec);
 	if (err < 0) {
 		codec_err(codec,
 			   "The codec is being used, can't reconfigure.\n");
-		goto error;
+		return err;
 	}
 	err = device_reprobe(hda_codec_dev(codec));
 	if (err < 0)
-		goto error;
-	err = snd_card_register(codec->card);
- error:
-	snd_hda_power_down(codec);
-	return err;
+		return err;
+	return snd_card_register(codec->card);
 }
 
 /*
-- 
2.53.0



