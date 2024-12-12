Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F3321C166;
	Thu, 12 Dec 2024 15:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018661; cv=none; b=XYk0NC+y+wUzfxAWOiopmlA5iBwxY5MNB7KZz4wxdyr2op/4xWUQR9EXgiAKKwskOWjpMMcOp6KSDiOJSTCw2GMv5Cy9s//93ZP1a8RU/0ZsfVoIcNaCm2OShBb/Mcr6paRzqfqey6RcOtaojreebsbM8QpZuebE2W9OwylWBeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018661; c=relaxed/simple;
	bh=mrgGo+PJzadVvgVymd9gO6WWa8mQYkxEmAdCY9ytMyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuR7BiSroKCsUijDs4tlCa9oIbqxmD+Py40N8brV7z1O++FcvgfIraighN2gT89yNc1iItQFV03ItfDgo1V0AYwJdHvNTzQHEzoWPqouiZKKpsfguls+ajXsxQSvKy/KmbzLbVOVEqoZIr6a7Ow1ev3nNB48kBhxS1wKP2+u4s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVOp8aZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVOp8aZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2ACC4CECE;
	Thu, 12 Dec 2024 15:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018661;
	bh=mrgGo+PJzadVvgVymd9gO6WWa8mQYkxEmAdCY9ytMyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVOp8aZAtrvvCcGzgCprHxdEueSnsPRg38FJduGoZk4fUbXs6mVjdWea3SRiAMPPW
	 QrvNVM/vGaIpVt3bHhRL3RF0HnjG1w1OzX4DetM00ZOkZs/12JyTxwQ/OKVjcBQ70P
	 ze1NVBogT1kUGrx7WF8d0Q/WLSUzwCyd6kHEhtIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 352/356] ALSA: usb-audio: Update UMP group attributes for GTB blocks, too
Date: Thu, 12 Dec 2024 16:01:11 +0100
Message-ID: <20241212144258.481130541@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ebaa86c0bddd2c47c516bf2096b17c0bed71d914 upstream.

When a FB is created from a GTB instead of UMP FB Info inquiry, we
missed the update of the corresponding UMP Group attributes.
Export the call of updater and let it be called from the USB driver.

Fixes: 0642a3c5cacc ("ALSA: ump: Update substream name from assigned FB names")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20240807092303.1935-5-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/ump.h |    1 +
 sound/core/ump.c    |    9 +++++----
 sound/usb/midi2.c   |    2 ++
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/sound/ump.h
+++ b/include/sound/ump.h
@@ -122,6 +122,7 @@ static inline int snd_ump_attach_legacy_
 
 int snd_ump_receive_ump_val(struct snd_ump_endpoint *ump, u32 val);
 int snd_ump_switch_protocol(struct snd_ump_endpoint *ump, unsigned int protocol);
+void snd_ump_update_group_attrs(struct snd_ump_endpoint *ump);
 
 /*
  * Some definitions for UMP
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -525,7 +525,7 @@ static void snd_ump_proc_read(struct snd
 }
 
 /* update dir_bits and active flag for all groups in the client */
-static void update_group_attrs(struct snd_ump_endpoint *ump)
+void snd_ump_update_group_attrs(struct snd_ump_endpoint *ump)
 {
 	struct snd_ump_block *fb;
 	struct snd_ump_group *group;
@@ -575,6 +575,7 @@ static void update_group_attrs(struct sn
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(snd_ump_update_group_attrs);
 
 /*
  * UMP endpoint and function block handling
@@ -848,7 +849,7 @@ static int ump_handle_fb_info_msg(struct
 	if (fb) {
 		fill_fb_info(ump, &fb->info, buf);
 		if (ump->parsed) {
-			update_group_attrs(ump);
+			snd_ump_update_group_attrs(ump);
 			seq_notify_fb_change(ump, fb);
 		}
 	}
@@ -880,7 +881,7 @@ static int ump_handle_fb_name_msg(struct
 				buf->raw, 3);
 	/* notify the FB name update to sequencer, too */
 	if (ret > 0 && ump->parsed) {
-		update_group_attrs(ump);
+		snd_ump_update_group_attrs(ump);
 		seq_notify_fb_change(ump, fb);
 	}
 	return ret;
@@ -1055,7 +1056,7 @@ int snd_ump_parse_endpoint(struct snd_um
 	}
 
 	/* initialize group attributions */
-	update_group_attrs(ump);
+	snd_ump_update_group_attrs(ump);
 
  error:
 	ump->parsed = true;
--- a/sound/usb/midi2.c
+++ b/sound/usb/midi2.c
@@ -873,6 +873,8 @@ static int create_gtb_block(struct snd_u
 		fb->info.flags |= SNDRV_UMP_BLOCK_IS_MIDI1 |
 			SNDRV_UMP_BLOCK_IS_LOWSPEED;
 
+	snd_ump_update_group_attrs(rmidi->ump);
+
 	usb_audio_dbg(umidi->chip,
 		      "Created a UMP block %d from GTB, name=%s\n",
 		      blk, fb->info.name);


