Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC20D15E8B;
	Mon, 30 Dec 2024 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574266; cv=none; b=EWfYeHD/lg79EoMe+/FhcckBECTe7Z9dLxkacZgQgLWEe1Nzmll1b+CVuGLEaigwm1zvqTRnYjrDXyC9+1ESL0nYV3izqLZ6+1+wVw521UEk9w0zeYkjWE7sEUGtQAkTnVNDyT+0wRYg0ZzioBCwt8SIdeJc86ZtgVgi2L3e8Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574266; c=relaxed/simple;
	bh=D7fSD2X/jxZ3c17vAGRLsQwJwEdUDMk52dQJLEZ//dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6tYOj9cXX0JKbW8FcLP2YHyBzrosubr5GwA8Cm3+uwSIfFObxxwHPQevnzlm+sa89uFiN/DSE28JyJLw7hB6Asf5t5RdghJWzt2YZLC6iane+yAiE36raalGl1m3zmDdUKr2pZyxOUNX92jCoFKqZjQVrW4aVIm60EVFxZ0WeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfLyTBaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfLyTBaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A99CC4CED0;
	Mon, 30 Dec 2024 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574266;
	bh=D7fSD2X/jxZ3c17vAGRLsQwJwEdUDMk52dQJLEZ//dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfLyTBaJJC2NPwvWio3sEu9X3cH4Kh/LIbUAgSEZ8J0ppsD+eL6WEyE56R0aFSRnF
	 qPU08PK11Y570FogzlRAEQFJU2ZU59pmV4paZD744inYCbypKlrCcCpQX1EQ4gBpM0
	 szF00r83QBEIy0OHlpLYuS9T14JrMPxvEclHCdQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/114] ALSA: ump: Update legacy substream names upon FB info update
Date: Mon, 30 Dec 2024 16:42:53 +0100
Message-ID: <20241230154220.233596973@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit edad3f9519fcacb926d0e3f3217aecaf628a593f ]

The legacy rawmidi substreams should be updated when UMP FB Info or
UMP FB Name are received, too.

Link: https://patch.msgid.link/20241129094546.32119-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 55d5d8af5e44..24f7d65ce49c 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -37,6 +37,7 @@ static int process_legacy_output(struct snd_ump_endpoint *ump,
 				 u32 *buffer, int count);
 static void process_legacy_input(struct snd_ump_endpoint *ump, const u32 *src,
 				 int words);
+static void update_legacy_names(struct snd_ump_endpoint *ump);
 #else
 static inline int process_legacy_output(struct snd_ump_endpoint *ump,
 					u32 *buffer, int count)
@@ -47,6 +48,9 @@ static inline void process_legacy_input(struct snd_ump_endpoint *ump,
 					const u32 *src, int words)
 {
 }
+static inline void update_legacy_names(struct snd_ump_endpoint *ump)
+{
+}
 #endif
 
 static const struct snd_rawmidi_global_ops snd_ump_rawmidi_ops = {
@@ -861,6 +865,7 @@ static int ump_handle_fb_info_msg(struct snd_ump_endpoint *ump,
 		fill_fb_info(ump, &fb->info, buf);
 		if (ump->parsed) {
 			snd_ump_update_group_attrs(ump);
+			update_legacy_names(ump);
 			seq_notify_fb_change(ump, fb);
 		}
 	}
@@ -893,6 +898,7 @@ static int ump_handle_fb_name_msg(struct snd_ump_endpoint *ump,
 	/* notify the FB name update to sequencer, too */
 	if (ret > 0 && ump->parsed) {
 		snd_ump_update_group_attrs(ump);
+		update_legacy_names(ump);
 		seq_notify_fb_change(ump, fb);
 	}
 	return ret;
@@ -1262,6 +1268,14 @@ static void fill_substream_names(struct snd_ump_endpoint *ump,
 	}
 }
 
+static void update_legacy_names(struct snd_ump_endpoint *ump)
+{
+	struct snd_rawmidi *rmidi = ump->legacy_rmidi;
+
+	fill_substream_names(ump, rmidi, SNDRV_RAWMIDI_STREAM_INPUT);
+	fill_substream_names(ump, rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT);
+}
+
 int snd_ump_attach_legacy_rawmidi(struct snd_ump_endpoint *ump,
 				  char *id, int device)
 {
@@ -1298,10 +1312,7 @@ int snd_ump_attach_legacy_rawmidi(struct snd_ump_endpoint *ump,
 	rmidi->ops = &snd_ump_legacy_ops;
 	rmidi->private_data = ump;
 	ump->legacy_rmidi = rmidi;
-	if (input)
-		fill_substream_names(ump, rmidi, SNDRV_RAWMIDI_STREAM_INPUT);
-	if (output)
-		fill_substream_names(ump, rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT);
+	update_legacy_names(ump);
 
 	ump_dbg(ump, "Created a legacy rawmidi #%d (%s)\n", device, id);
 	return 0;
-- 
2.39.5



