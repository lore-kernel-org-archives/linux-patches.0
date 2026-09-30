Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A573D8900;
	Wed, 30 Sep 2026 19:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795101; cv=none; b=eXh54uv7kKqNyRmOF1wbsUM04IqAPMjrO55aat6TH+VphX702BlbwFkFEz6+8UxxQ6Ruw0fSUJQw05YDtYZjx9Wj9jTUhaH06ag16YSp2A1aRXUOvYaP+yNnGH7K8Oq2jFBe4zTQ79BUtrzoVUdMGnvUfgCwLG2IL6HIFHPVQeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795101; c=relaxed/simple;
	bh=p+qPuZ56g5JOcGuar++O8QF3OZIo5bRpONHDFFV5xTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4qNsX23fuHEBUAp51m3loUh6UxQmUxyoESyMdbBg0lbpBBmhao8WWJeA+AJHO1ifbdnKvlTFyPD2hPDpLa41AZlQf50rOP/uh36TkcuW6U4e80BUgSkLnXSV4P41ne1I7Z3okYfAdKYbvXkZdLJHwOsWck0GwEal7ceRMIEwmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+BIwpD8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+BIwpD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306D21F000FF;
	Wed, 30 Sep 2026 19:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795099;
	bh=fH1WLIjOYpMtDLiLmpS13BEauF2baOG3FkTmcNiO7jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+BIwpD8iH3Pcx9SDpiRxAnuR0HfHFDWhuuO1XCrriDkP+kNzDQRat3ozPgwlPXE7
	 5YK3ycNgTrer+pEk0rt1TvG4CGOeJA0YxcVVY8cZ/3wWyNz/CdnQ0caOaosHc56svs
	 dkavcdF60Kld37q4Z7vv5xte7VocGHSIOnlnIIpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0443/1193] ALSA: rawmidi: Expose the tied device number in info ioctl
Date: Wed, 30 Sep 2026 17:18:47 +0200
Message-ID: <20260930152444.024654023@linuxfoundation.org>
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

[ Upstream commit bdf46443f350dd5d226fd528a5a5954ff762f591 ]

The UMP legacy rawmidi is derived from the UMP rawmidi, but currently
there is no way to know which device is involved in other side.

This patch extends the rawmidi info ioctl to show the tied device
number.  As default it stores -1, indicating that no tied device.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250110155943.31578-2-tiwai@suse.de
Stable-dep-of: adeee7187694 ("ALSA: ump: do not touch legacy_rmidi before it exists")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/sound/designs/midi-2.0.rst | 5 +++++
 include/sound/rawmidi.h                  | 1 +
 include/uapi/sound/asound.h              | 5 ++++-
 sound/core/rawmidi.c                     | 2 ++
 sound/core/ump.c                         | 3 +++
 5 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/sound/designs/midi-2.0.rst b/Documentation/sound/designs/midi-2.0.rst
index 086487ca7ab11..d525bc2805f72 100644
--- a/Documentation/sound/designs/midi-2.0.rst
+++ b/Documentation/sound/designs/midi-2.0.rst
@@ -293,6 +293,11 @@ Rawmidi API Extensions
   status 0x05).  When UMP core receives such a message, it updates the
   UMP EP info and the corresponding sequencer clients as well.
 
+* The legacy rawmidi device number is found in the new `tied_device`
+  field of the rawmidi info.
+  On the other hand, the UMP rawmidi device number is found in
+  `tied_device` field of the legacy rawmidi info, too.
+
 
 Control API Extensions
 ======================
diff --git a/include/sound/rawmidi.h b/include/sound/rawmidi.h
index f31cabf0158c9..7f1fec786b72f 100644
--- a/include/sound/rawmidi.h
+++ b/include/sound/rawmidi.h
@@ -118,6 +118,7 @@ struct snd_rawmidi {
 	struct list_head list;
 	unsigned int device;		/* device number */
 	unsigned int info_flags;	/* SNDRV_RAWMIDI_INFO_XXXX */
+	unsigned int tied_device;
 	char id[64];
 	char name[80];
 
diff --git a/include/uapi/sound/asound.h b/include/uapi/sound/asound.h
index 10966a9250cd9..16f6837ddc985 100644
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -725,6 +725,8 @@ enum {
 #define SNDRV_RAWMIDI_INFO_DUPLEX		0x00000004
 #define SNDRV_RAWMIDI_INFO_UMP			0x00000008
 
+#define SNDRV_RAWMIDI_DEVICE_UNKNOWN		-1
+
 struct snd_rawmidi_info {
 	unsigned int device;		/* RO/WR (control): device number */
 	unsigned int subdevice;		/* RO/WR (control): subdevice number */
@@ -736,7 +738,8 @@ struct snd_rawmidi_info {
 	unsigned char subname[32];	/* name of active or selected subdevice */
 	unsigned int subdevices_count;
 	unsigned int subdevices_avail;
-	unsigned char reserved[64];	/* reserved for future use */
+	int tied_device;		/* R: tied rawmidi device (UMP/legacy) */
+	unsigned char reserved[60];	/* reserved for future use */
 };
 
 #define SNDRV_RAWMIDI_MODE_FRAMING_MASK		(7<<0)
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 1431cb997808d..78cf0823ef258 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -651,6 +651,7 @@ static int snd_rawmidi_info(struct snd_rawmidi_substream *substream,
 	info->subdevices_count = substream->pstr->substream_count;
 	info->subdevices_avail = (substream->pstr->substream_count -
 				  substream->pstr->substream_opened);
+	info->tied_device = rmidi->tied_device;
 	return 0;
 }
 
@@ -1897,6 +1898,7 @@ int snd_rawmidi_init(struct snd_rawmidi *rmidi,
 	INIT_LIST_HEAD(&rmidi->streams[SNDRV_RAWMIDI_STREAM_INPUT].substreams);
 	INIT_LIST_HEAD(&rmidi->streams[SNDRV_RAWMIDI_STREAM_OUTPUT].substreams);
 	rmidi->info_flags = info_flags;
+	rmidi->tied_device = SNDRV_RAWMIDI_DEVICE_UNKNOWN;
 
 	if (id != NULL)
 		strscpy(rmidi->id, id, sizeof(rmidi->id));
diff --git a/sound/core/ump.c b/sound/core/ump.c
index 650cbe7b3a977..ff8869e3626a7 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1304,6 +1304,9 @@ int snd_ump_attach_legacy_rawmidi(struct snd_ump_endpoint *ump,
 	ump->legacy_rmidi = rmidi;
 	update_legacy_names(ump);
 
+	rmidi->tied_device = ump->core.device;
+	ump->core.tied_device = rmidi->device;
+
 	ump_dbg(ump, "Created a legacy rawmidi #%d (%s)\n", device, id);
 	return 0;
 }
-- 
2.53.0



