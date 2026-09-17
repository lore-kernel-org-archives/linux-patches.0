Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005844E73A1;
	Thu, 17 Sep 2026 18:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669110; cv=none; b=JkJ/UALVBQSX74ro66xArZrMVU0+9PiiNx6wdRJ/V+WorjeC3scrRDvWOyyaBH2MmvLHAYgSkeipRe47ZGKYrQdlmFRV8RPX/4VXiu44YPM2IGtdGAfj+LKArWVuPsaYR7QTuwbPkNBqcV+Ad7S3Dd69Sm1x5332+4ghD4iqwI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669110; c=relaxed/simple;
	bh=orOOuEcLV4tOa6dUui6I5RO44287fTrRTIoLw9L25cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O58bTVbk3U/T4i7408rlc+23yhWKAXgWFqaEdRLDxUUre+qbOlqVvkdbEC8GMexI6T5nH98y5UCMKZNEjFr1JHuVPzV+EYSykgZi2ultnamzhOFvOY4i6U6vLuE1Dmh6dnia9t1/poa99AeYhGWkjxaqkF17CoGvRsHwUewD8Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stbiPbXf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stbiPbXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568681F000FF;
	Thu, 17 Sep 2026 18:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789669108;
	bh=ifuke+HDbdGFgKr9Rr+270+Vs/WYB8YZV30hlWp3uEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stbiPbXf7ykO7fHchq5YTfGjgHRdRgovd1p1Mmtcl80FImOurXS5SEPZZeogB95Pt
	 iIv4y0hwjkI/iBdQpwrq8WSfo+0dU+gc7CIC8+jfGEMvF0Ts43H9Gp9gZHq+tn85p7
	 mokIuq2wjjvITPBBv6fKBD1NoOthoT0AEvo0JX5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0600/1102] ALSA: rawmidi: Show substream activity in info ioctl
Date: Thu, 17 Sep 2026 16:09:03 +0100
Message-ID: <20260917151555.063375010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fafc89efa1396..3ae6e9cbf3dde 100644
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -728,6 +728,7 @@ enum {
 #define SNDRV_RAWMIDI_INFO_INPUT		0x00000002
 #define SNDRV_RAWMIDI_INFO_DUPLEX		0x00000004
 #define SNDRV_RAWMIDI_INFO_UMP			0x00000008
+#define SNDRV_RAWMIDI_INFO_STREAM_INACTIVE	0x00000010
 
 #define SNDRV_RAWMIDI_DEVICE_UNKNOWN		-1
 
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index d765d1c2698e3..c7b39e07e7c39 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -629,6 +629,8 @@ static int snd_rawmidi_info(struct snd_rawmidi_substream *substream,
 	info->subdevice = substream->number;
 	info->stream = substream->stream;
 	info->flags = rmidi->info_flags;
+	if (substream->inactive)
+		info->flags |= SNDRV_RAWMIDI_INFO_STREAM_INACTIVE;
 	strcpy(info->id, rmidi->id);
 	strcpy(info->name, rmidi->name);
 	strcpy(info->subname, substream->name);
diff --git a/sound/core/ump.c b/sound/core/ump.c
index 069fb0d743df4..912e1e23b7e51 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1250,8 +1250,8 @@ static int fill_legacy_mapping(struct snd_ump_endpoint *ump)
 	return num;
 }
 
-static void fill_substream_names(struct snd_ump_endpoint *ump,
-				 struct snd_rawmidi *rmidi, int dir)
+static void update_legacy_substreams(struct snd_ump_endpoint *ump,
+				     struct snd_rawmidi *rmidi, int dir)
 {
 	struct snd_rawmidi_substream *s;
 	const char *name;
@@ -1265,6 +1265,7 @@ static void fill_substream_names(struct snd_ump_endpoint *ump,
 		scnprintf(s->name, sizeof(s->name), "Group %d (%.16s)%s",
 			  idx + 1, name,
 			  ump->groups[idx].active ? "" : " [Inactive]");
+		s->inactive = !ump->groups[idx].active;
 	}
 }
 
@@ -1272,8 +1273,8 @@ static void update_legacy_names(struct snd_ump_endpoint *ump)
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



