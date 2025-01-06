Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81C0155C9E;
	Mon,  6 Jan 2025 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177305; cv=none; b=YOE0ca1qKCfGPWR9o7mMn9UnN0Lo3vBQ0XyW77KKqabnsnHOB605IzYp9VH+H2W7slJsFh2tAYrBRqOJjvgpXCiZA1ORyOq/Y+GcKmgklYV3rT/Oqj9v54a19aG7fWm4Lyv1fjsxoQHLl0PLKKniFBNnBT/U5BeL5iavk2/UKEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177305; c=relaxed/simple;
	bh=IdUNx+wF/xpgB8/cIj1HK2/I/7o9cjUxmvXSsB+wBGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwoWobqAqvHHiOfXbLhqLQK1VfCO2nDjz4hKTkwvU/LPaSJ1gLMdFnQthnFIcafDMmNyPZY1HnRfnkvqKb0DOpnadc4oho4h10yyWz8g8Z+9hcmeQvi3c068aTw/0xqB3APc9+t128bAk9z7aYpJkgTT7hzePc3LyQ8Jw+T9ZI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuEFcLlE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuEFcLlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46215C4CED2;
	Mon,  6 Jan 2025 15:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177305;
	bh=IdUNx+wF/xpgB8/cIj1HK2/I/7o9cjUxmvXSsB+wBGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wuEFcLlEIMQt9dPVMBtA80jPPBnQYVBCXerdBDaFegGEbLo1I8AYj+Dp7IJewM/Xn
	 0jj6WfeWoEODA2tg9wjB/JQ3VuZfafV42lQoaHc1EioIpzCFpnXzukjPlcuGvQzx9w
	 U4GLQSRQHdca+OsKiop1uwoNdvHC7WhGSJYNiIkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/222] ALSA: ump: Update legacy substream names upon FB info update
Date: Mon,  6 Jan 2025 16:14:56 +0100
Message-ID: <20250106151154.079002394@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bb94f119869a..4aec90dac07e 100644
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
@@ -850,6 +854,7 @@ static int ump_handle_fb_info_msg(struct snd_ump_endpoint *ump,
 		fill_fb_info(ump, &fb->info, buf);
 		if (ump->parsed) {
 			snd_ump_update_group_attrs(ump);
+			update_legacy_names(ump);
 			seq_notify_fb_change(ump, fb);
 		}
 	}
@@ -882,6 +887,7 @@ static int ump_handle_fb_name_msg(struct snd_ump_endpoint *ump,
 	/* notify the FB name update to sequencer, too */
 	if (ret > 0 && ump->parsed) {
 		snd_ump_update_group_attrs(ump);
+		update_legacy_names(ump);
 		seq_notify_fb_change(ump, fb);
 	}
 	return ret;
@@ -1251,6 +1257,14 @@ static void fill_substream_names(struct snd_ump_endpoint *ump,
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
@@ -1287,10 +1301,7 @@ int snd_ump_attach_legacy_rawmidi(struct snd_ump_endpoint *ump,
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



