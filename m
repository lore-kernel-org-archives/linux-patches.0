Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30854432
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46241C433C9;
	Mon, 11 Sep 2023 14:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441399;
	bh=2Fhwrp6C5cAyXATr6CY5FVsbqlyxKJ+pzeWLTbe62BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=to9SPHYn/p1enS5U7WZla0fLAQAXG3iQs6zG6sGdi2Gaz2CLGhj76AQimx1ZstKhQ
	 XpR/2R72GrNEV4frIQEILqIcgysh4J0qou6kq19cGSA/PAdGQxDiTul+1IgIEqc/TZ
	 0Ik0GtNv8V7qoj2wRRVcyem/ysw/Rr7rpjYtIJnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 373/739] ALSA: ump: Fix -Wformat-truncation warnings
Date: Mon, 11 Sep 2023 15:42:52 +0200
Message-ID: <20230911134701.582160476@linuxfoundation.org>
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

[ Upstream commit 4aa69d64e43edb51a4ecff7d301e9f881eb2d3f5 ]

Filling the rawmidi name and substream name can be truncated, and this
leads to spurious compiler warnings due to -Wformat-truncation.
Although the truncation is the expected behavior, it'd be better to
truncate the string within "(...)"

This patch puts the precision specifies to each %s for fitting the
words within the size-limited strings.

Fixes: 5f11dd938fe7 ("ALSA: usb-audio: Attach legacy rawmidi after probing all UMP EPs")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308251844.1FuQYsql-lkp@intel.com/
Link: https://lore.kernel.org/r/20230826072151.23408-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 9d6e3e748f7e7..1e4e1e428b205 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1157,7 +1157,7 @@ static void fill_substream_names(struct snd_ump_endpoint *ump,
 	struct snd_rawmidi_substream *s;
 
 	list_for_each_entry(s, &rmidi->streams[dir].substreams, list)
-		snprintf(s->name, sizeof(s->name), "Group %d (%s)",
+		snprintf(s->name, sizeof(s->name), "Group %d (%.16s)",
 			 ump->legacy_mapping[s->number] + 1, ump->info.name);
 }
 
@@ -1191,7 +1191,7 @@ int snd_ump_attach_legacy_rawmidi(struct snd_ump_endpoint *ump,
 	if (output)
 		snd_rawmidi_set_ops(rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT,
 				    &snd_ump_legacy_output_ops);
-	snprintf(rmidi->name, sizeof(rmidi->name), "%s (MIDI 1.0)",
+	snprintf(rmidi->name, sizeof(rmidi->name), "%.68s (MIDI 1.0)",
 		 ump->info.name);
 	rmidi->info_flags = ump->core.info_flags & ~SNDRV_RAWMIDI_INFO_UMP;
 	rmidi->ops = &snd_ump_legacy_ops;
-- 
2.40.1



