Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FCB4B7A35;
	Thu, 17 Sep 2026 18:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670369; cv=none; b=brfMuyiw3bHgTVAjfhwMvgQjF7safxy2h0IOPYZ6l6TQQENQmnYeyS3mMZI8d838JUgOK7u/yncbRmeLEglpVvz4U8iNOPnmHXSfomY4Z5qnupfJ1InzCsgR3PcSIUy5WfiqThHSlObwXW0Tvm9rpC8U/pcyKIjzeeS0m9SLSVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670369; c=relaxed/simple;
	bh=v2awPieaGbZoGgTBxxXkQwI6vnPQjOlgz8GUG3V1knk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CY9vcON0bEeNgEAwBIs8F0Ka/79vxrEDbfce8Fn9xdbmHrz/gr7xQZ1NyeJDa+L7CLbr8MOpJ6e79mxlUVSiRMJe5HraflkmY4CVMBy8fTtypZnMzvnnUJvhT0jZYFecc3x2zZjSpL+ZVNB+N6w/AAY3hzHts/ZtII63rxijh6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mhJIKGQ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhJIKGQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CE31F000FF;
	Thu, 17 Sep 2026 18:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670367;
	bh=DyFHKyDBvsZYiNbaUOSUBg6P2s96Tj+5b5sa+/Vetz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhJIKGQ1EO3iN1JAiaETBo42MLq+3uFr7M+FGCd8IeapBtFkRJDmex4d+5SF6BJ9T
	 yHUBKbx+ALwlDlww66X13ia90TIwh5z+zwDf7RcpZKxlaOjX1Bk2AMpDnMC50wIQbG
	 loeFI5HwgcJUhetkmKvxejwVF7raQK8LJEzHUrZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0603/1102] ALSA: ump: Update rawmidi name per EP name update
Date: Thu, 17 Sep 2026 16:09:06 +0100
Message-ID: <20260917151555.149644363@linuxfoundation.org>
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

[ Upstream commit aca565359596c5998cab1cc72f61aa83b3ccd152 ]

The rawmidi name string should be updated dynamically when the device
receives the UMP EP name update, too.  Both the core and legacy
rawmidi names are updated.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250110155943.31578-7-tiwai@suse.de
Stable-dep-of: adeee7187694 ("ALSA: ump: do not touch legacy_rmidi before it exists")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index ec939f332beff..820a86d4e159d 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -37,6 +37,7 @@ static int process_legacy_output(struct snd_ump_endpoint *ump,
 				 u32 *buffer, int count);
 static void process_legacy_input(struct snd_ump_endpoint *ump, const u32 *src,
 				 int words);
+static void ump_legacy_set_rawmidi_name(struct snd_ump_endpoint *ump);
 static void update_legacy_names(struct snd_ump_endpoint *ump);
 #else
 static inline int process_legacy_output(struct snd_ump_endpoint *ump,
@@ -48,6 +49,9 @@ static inline void process_legacy_input(struct snd_ump_endpoint *ump,
 					const u32 *src, int words)
 {
 }
+static inline void ump_legacy_set_rawmidi_name(struct snd_ump_endpoint *ump)
+{
+}
 static inline void update_legacy_names(struct snd_ump_endpoint *ump)
 {
 }
@@ -751,8 +755,16 @@ static void ump_set_rawmidi_name(struct snd_ump_endpoint *ump)
 static int ump_handle_ep_name_msg(struct snd_ump_endpoint *ump,
 				  const union snd_ump_stream_msg *buf)
 {
-	return ump_append_string(ump, ump->info.name, sizeof(ump->info.name),
-				 buf->raw, 2);
+	int ret;
+
+	ret = ump_append_string(ump, ump->info.name, sizeof(ump->info.name),
+				buf->raw, 2);
+	if (ret && ump->parsed) {
+		ump_set_rawmidi_name(ump);
+		ump_legacy_set_rawmidi_name(ump);
+	}
+
+	return ret;
 }
 
 /* handle EP product id stream message; update the UMP product_id string */
@@ -1308,6 +1320,14 @@ static void update_legacy_names(struct snd_ump_endpoint *ump)
 	update_legacy_substreams(ump, rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT);
 }
 
+static void ump_legacy_set_rawmidi_name(struct snd_ump_endpoint *ump)
+{
+	struct snd_rawmidi *rmidi = ump->legacy_rmidi;
+
+	snprintf(rmidi->name, sizeof(rmidi->name), "%.68s (MIDI 1.0)",
+		 ump->core.name);
+}
+
 int snd_ump_attach_legacy_rawmidi(struct snd_ump_endpoint *ump,
 				  char *id, int device)
 {
@@ -1339,12 +1359,11 @@ int snd_ump_attach_legacy_rawmidi(struct snd_ump_endpoint *ump,
 	if (output)
 		snd_rawmidi_set_ops(rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT,
 				    &snd_ump_legacy_output_ops);
-	snprintf(rmidi->name, sizeof(rmidi->name), "%.68s (MIDI 1.0)",
-		 ump->core.name);
 	rmidi->info_flags = ump->core.info_flags & ~SNDRV_RAWMIDI_INFO_UMP;
 	rmidi->ops = &snd_ump_legacy_ops;
 	rmidi->private_data = ump;
 	ump->legacy_rmidi = rmidi;
+	ump_legacy_set_rawmidi_name(ump);
 	update_legacy_names(ump);
 
 	rmidi->tied_device = ump->core.device;
-- 
2.53.0



