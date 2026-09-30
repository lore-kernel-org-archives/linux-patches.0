Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462893C76AD;
	Wed, 30 Sep 2026 19:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795112; cv=none; b=dPp0YQUqlerCKX25niJDAyybVoRasAkyAwGF6Tz4H+kihvqGLSS4zQvZd4kDqQzlw6tr9Nu5BwRDNiHFvP09T/4PFakh5ocq6LSufnPaGZ2dI8bfbILBPsld99iGhuwDAZ5mCrnOP05AXzs4DQMMqYuin73sTlLfbyTLhJf7Tf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795112; c=relaxed/simple;
	bh=bieEqBcINC1zHMIFnh2AKinVIaZrrdHMVBN0qaDTOMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYO49uiZ4YfEfGCQzcCdAaOeBaAOiJT9wo4gWqRBmyTL/Ei0CHe5MBX7icXcQXt+iC08C02C26nd9sCCuhiIeN9HvOVp5o1TtGZhhghNTKgT9u5j8JAz0GqKoo9tP+Tq7a0ldCURfsBRRd97gGTEnuYIpjb4SyL62PTWctub4Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tg56UKsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tg56UKsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6321F000FF;
	Wed, 30 Sep 2026 19:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795111;
	bh=OS8fIY1PA3Lbhbq/ZA8gzU+rGsc0l06NoPE9poWMnlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tg56UKsPVN7jED34EhGfx61CmelrxT2milXRCt5CScKBgxINLawjSvnfZJWYQZdLC
	 o10+AoyAe6ii2u7mchGL3/GCv7sDEzU9AceNdmG81+UPN4Xpa6wr2dBp3/Kpf1zhaA
	 ygNCSghdE/5TS6AaU3e3FbVE0GLFLTz+AeWHAXV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0447/1193] ALSA: ump: Update rawmidi name per EP name update
Date: Wed, 30 Sep 2026 17:18:51 +0200
Message-ID: <20260930152444.111435352@linuxfoundation.org>
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
index e258000d2d8e6..2b6c16d3afa4f 100644
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
@@ -740,8 +744,16 @@ static void ump_set_rawmidi_name(struct snd_ump_endpoint *ump)
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
@@ -1297,6 +1309,14 @@ static void update_legacy_names(struct snd_ump_endpoint *ump)
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
@@ -1328,12 +1348,11 @@ int snd_ump_attach_legacy_rawmidi(struct snd_ump_endpoint *ump,
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



