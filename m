Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B813D8900;
	Wed, 30 Sep 2026 19:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795103; cv=none; b=tt+g5FVHyH5aQR2KuzjkdDGcB80wKt18e1ZvoWkF9qSkWSCXzwC1OLpGDYgmUZpt8zYosKU9H5myhy+H3Sp3w4eb1vjORaUy+g1ueg9aEkumG90rHcv8Aq9oyuOWm9mkMQn66iBEOqpqaRVUugPTsJWUrY4V7dj5S33C158ioJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795103; c=relaxed/simple;
	bh=YFKMzrdFqS7xea9dIb+rNulZEoaw8nQ0monIj2V4a1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwl11sYizVPGgdRKNpd6MKaJ096BLnncIpXUdPM1zN8droYGkZuk93Xd0/72+ZFWsssVYHFCY+iwgeZTPPJCY2Msbn1ix00zSq7GJvs7CGzlQZ/yCuCxOypR6R9cNHwHtwOOFAdUyJv2K3er8ZgGxlIz/7MRMmQtp5Po/OHx2u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QI6fje1O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QI6fje1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F20A1F000FF;
	Wed, 30 Sep 2026 19:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795102;
	bh=z9AYAjMxGNyIUEZb+nDIMtA4JbnRoH/iJ3VFOYy2xj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QI6fje1OYKw6wWRTBKKP2quKlaOVjhLyhiHv4jD08JlhzRdJLPz/iZ7Yq7kFCheym
	 7kGvu3Wpm29ZhzBV452UBErbPBp+etNy6OUQeRZ5j/lmuc7RDrMFPdzRMATm95OKh6
	 iDtm7nGGMPdLwPCeGx0Sas8pOhOAq1ql0f3tVWVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0444/1193] ALSA: rawmidi: Show substream activity in info ioctl
Date: Wed, 30 Sep 2026 17:18:48 +0200
Message-ID: <20260930152444.046873244@linuxfoundation.org>
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

[ Upstream commit b8fefed73a952a33521ad416fb39683abd87454b ]

The UMP legacy rawmidi may turn on/off the substream dynamically
depending on the UMP Function Block information.  So far, there was no
direct way to know whether the substream is disabled (inactive) or
not; at most one can take a look at the substream name string or try
to open and get -ENODEV.

This patch extends the rawmidi info ioctl to show the current inactive
state of the given substream.  When the selected substream is
inactive, info flags field contains the new bit flag
SNDRV_RAWMIDI_INFO_STREAM_INACTIVE.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250110155943.31578-3-tiwai@suse.de
Stable-dep-of: adeee7187694 ("ALSA: ump: do not touch legacy_rmidi before it exists")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/sound/designs/midi-2.0.rst | 6 ++++++
 include/sound/rawmidi.h                  | 1 +
 include/uapi/sound/asound.h              | 1 +
 sound/core/rawmidi.c                     | 2 ++
 sound/core/ump.c                         | 9 +++++----
 5 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/Documentation/sound/designs/midi-2.0.rst b/Documentation/sound/designs/midi-2.0.rst
index d525bc2805f72..d6c17a47c8320 100644
--- a/Documentation/sound/designs/midi-2.0.rst
+++ b/Documentation/sound/designs/midi-2.0.rst
@@ -298,6 +298,12 @@ Rawmidi API Extensions
   On the other hand, the UMP rawmidi device number is found in
   `tied_device` field of the legacy rawmidi info, too.
 
+* Each substream of the legacy rawmidi may be enabled / disabled
+  dynamically depending on the UMP FB state.
+  When the selected substream is inactive, it's indicated by the bit
+  0x10 (`SNDRV_RAWMIDI_INFO_STREAM_INACTIVE`) in the `flags` field of
+  the legacy rawmidi info.
+
 
 Control API Extensions
 ======================
diff --git a/include/sound/rawmidi.h b/include/sound/rawmidi.h
index 7f1fec786b72f..6f2e95298fc76 100644
--- a/include/sound/rawmidi.h
+++ b/include/sound/rawmidi.h
@@ -89,6 +89,7 @@ struct snd_rawmidi_substream {
 	unsigned int framing;		/* whether to frame input data */
 	unsigned int clock_type;	/* clock source to use for input framing */
 	int use_count;			/* use counter (for output) */
+	bool inactive;			/* inactive substream (for UMP legacy) */
 	size_t bytes;
 	spinlock_t lock;
 	struct snd_rawmidi *rmidi;
diff --git a/include/uapi/sound/asound.h b/include/uapi/sound/asound.h
index 16f6837ddc985..36aec82c7c133 100644
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -724,6 +724,7 @@ enum {
 #define SNDRV_RAWMIDI_INFO_INPUT		0x00000002
 #define SNDRV_RAWMIDI_INFO_DUPLEX		0x00000004
 #define SNDRV_RAWMIDI_INFO_UMP			0x00000008
+#define SNDRV_RAWMIDI_INFO_STREAM_INACTIVE	0x00000010
 
 #define SNDRV_RAWMIDI_DEVICE_UNKNOWN		-1
 
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 78cf0823ef258..84a60526c1c99 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -645,6 +645,8 @@ static int snd_rawmidi_info(struct snd_rawmidi_substream *substream,
 	info->subdevice = substream->number;
 	info->stream = substream->stream;
 	info->flags = rmidi->info_flags;
+	if (substream->inactive)
+		info->flags |= SNDRV_RAWMIDI_INFO_STREAM_INACTIVE;
 	strcpy(info->id, rmidi->id);
 	strcpy(info->name, rmidi->name);
 	strcpy(info->subname, substream->name);
diff --git a/sound/core/ump.c b/sound/core/ump.c
index ff8869e3626a7..0bf919fc31935 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1239,8 +1239,8 @@ static int fill_legacy_mapping(struct snd_ump_endpoint *ump)
 	return num;
 }
 
-static void fill_substream_names(struct snd_ump_endpoint *ump,
-				 struct snd_rawmidi *rmidi, int dir)
+static void update_legacy_substreams(struct snd_ump_endpoint *ump,
+				     struct snd_rawmidi *rmidi, int dir)
 {
 	struct snd_rawmidi_substream *s;
 	const char *name;
@@ -1254,6 +1254,7 @@ static void fill_substream_names(struct snd_ump_endpoint *ump,
 		scnprintf(s->name, sizeof(s->name), "Group %d (%.16s)%s",
 			  idx + 1, name,
 			  ump->groups[idx].active ? "" : " [Inactive]");
+		s->inactive = !ump->groups[idx].active;
 	}
 }
 
@@ -1261,8 +1262,8 @@ static void update_legacy_names(struct snd_ump_endpoint *ump)
 {
 	struct snd_rawmidi *rmidi = ump->legacy_rmidi;
 
-	fill_substream_names(ump, rmidi, SNDRV_RAWMIDI_STREAM_INPUT);
-	fill_substream_names(ump, rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT);
+	update_legacy_substreams(ump, rmidi, SNDRV_RAWMIDI_STREAM_INPUT);
+	update_legacy_substreams(ump, rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT);
 }
 
 int snd_ump_attach_legacy_rawmidi(struct snd_ump_endpoint *ump,
-- 
2.53.0



