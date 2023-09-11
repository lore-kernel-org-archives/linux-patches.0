Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BD11170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BE1C433C8;
	Mon, 11 Sep 2023 14:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441337;
	bh=kP5gGFho2MR1qqgHRjEk0+QdsuY0cvuQdr3G400AyJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uukeYsyFqbWfkCUzDMruSG1caIPnGu99SJTBYqIfx0h1xV7e0SXQKAsBkb7lSZPiV
	 Qp1JVx3taOf897t8L50SJxihKaAFljD5HPOisMBZ2YhMuD/O/salAzLhYFB94G2j7q
	 H84fjNrXt1y5an6IB3U3P8S+8UDoDu3n/XfMsQLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 370/739] ALSA: usb-audio: Attach legacy rawmidi after probing all UMP EPs
Date: Mon, 11 Sep 2023 15:42:49 +0200
Message-ID: <20230911134701.494833706@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5f11dd938fe7657899ca79b2ffc4d708e43f4737 ]

The legacy rawmidi devices are the shadows of the main UMP devices,
hence it's better to initialize them after all UMP Endpoints are
parsed.  Then, at the moment the legacy rawmidi is created, we already
know the static flag or the proper EP name string, and we can fill
those information at UMP core side instead of fiddling the attributes
at a later point.

Fixes: ec362b63c4b5 ("ALSA: usb-audio: Enable the legacy raw MIDI support")
Link: https://lore.kernel.org/r/20230824075108.29958-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c  |  2 ++
 sound/usb/midi2.c | 15 ++++++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 246348766ec16..2cffd36863390 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1150,6 +1150,8 @@ int snd_ump_attach_legacy_rawmidi(struct snd_ump_endpoint *ump,
 	if (output)
 		snd_rawmidi_set_ops(rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT,
 				    &snd_ump_legacy_output_ops);
+	snprintf(rmidi->name, sizeof(rmidi->name), "%s (MIDI 1.0)",
+		 ump->info.name);
 	rmidi->info_flags = ump->core.info_flags & ~SNDRV_RAWMIDI_INFO_UMP;
 	rmidi->ops = &snd_ump_legacy_ops;
 	rmidi->private_data = ump;
diff --git a/sound/usb/midi2.c b/sound/usb/midi2.c
index ee28357414795..a27e244650c8a 100644
--- a/sound/usb/midi2.c
+++ b/sound/usb/midi2.c
@@ -990,7 +990,7 @@ static int parse_midi_2_0(struct snd_usb_midi2_interface *umidi)
 		}
 	}
 
-	return attach_legacy_rawmidi(umidi);
+	return 0;
 }
 
 /* is the given interface for MIDI 2.0? */
@@ -1059,12 +1059,6 @@ static void set_fallback_rawmidi_names(struct snd_usb_midi2_interface *umidi)
 			usb_string(dev, dev->descriptor.iSerialNumber,
 				   ump->info.product_id,
 				   sizeof(ump->info.product_id));
-#if IS_ENABLED(CONFIG_SND_UMP_LEGACY_RAWMIDI)
-		if (ump->legacy_rmidi && !*ump->legacy_rmidi->name)
-			snprintf(ump->legacy_rmidi->name,
-				 sizeof(ump->legacy_rmidi->name),
-				 "%s (MIDI 1.0)", ump->info.name);
-#endif
 	}
 }
 
@@ -1157,6 +1151,13 @@ int snd_usb_midi_v2_create(struct snd_usb_audio *chip,
 	}
 
 	set_fallback_rawmidi_names(umidi);
+
+	err = attach_legacy_rawmidi(umidi);
+	if (err < 0) {
+		usb_audio_err(chip, "Failed to create legacy rawmidi\n");
+		goto error;
+	}
+
 	return 0;
 
  error:
-- 
2.40.1



