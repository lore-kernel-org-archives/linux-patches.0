Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E273CAE8F;
	Wed, 30 Sep 2026 19:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795109; cv=none; b=Hl8xlUwxlL8Wx3J7ja5RP39LlBbkvz+GWPm7MQIncFEjaz2vqDj47YUqkhJxQGrNXxZtYNsgOkP8/0yYxhLtDTXxM5If3l+9qLWXIsXAb2LXONPp85fXTpdWiw1khqcf4gr1dhebIi3jh5wfM4k+BfqtikoiJmyWV+tc5Nqm+Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795109; c=relaxed/simple;
	bh=XFvYBAYDmzywaqXuJvv68XYnWx6DnZs4c843PjEIFxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXekvxrBBw+pnpDM1gRc2hEtiC+pjRZZ1SyFh9+/G/sCSkWHGc3wHs6XGz5TJiHodSA+dqwdCGuwOUY9mjLpPbAtFJQecaEuTC2ndrJ5JrrbICH+iM2ZcOg2nUPOzMtwXv1X+YPv5eePKnWdQB1Lly2Bx4oTabxA64cR8fVgo7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taKXKvOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taKXKvOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A181F000FF;
	Wed, 30 Sep 2026 19:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795108;
	bh=AqGPBOie6XU9bLGuEhI97Vvj2mH/gCdfnrw9X/QZotk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=taKXKvOEWs13wGXxG/78RLKuGQhdd9flclDjReJF7+zE4LwRarsBT8hahK2xHfDbN
	 oXTNif7Kio+IgNJvhhvO7zFRw6yckmbCuQk1u5U/q55Kf21XSt+5Gu1d2DNYRG92yO
	 NLFTP1BsaqE7QcX+QlJn4Q7f8Pcf5DI7GlycYN9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0446/1193] ALSA: ump: Copy safe string name to rawmidi
Date: Wed, 30 Sep 2026 17:18:50 +0200
Message-ID: <20260930152444.088901910@linuxfoundation.org>
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

[ Upstream commit 85e8d66f30f967cda91b3ee6dfcb0a0c2391e612 ]

The UMP helper didn't set up the rawmidi name string by itself but
left it to the driver.  But since the only user (USB MIDI2 driver)
picks up the UMP info name string to the rawmidi name as default, it's
better to set up in the UMP core side.

Meanwhile, UMP receives the EP name string from the device, and it
might contain garbage letters.  We should purify the string to be
usable for the kernel as done previously for UMP Group names.

This implements the copy of the UMP info name string into the rawmidi
name at the creation of UMP EP object in a safe way to strip the
non-ASCII or non-printable characters.  Also, change the reference
from the legacy rawmidi and other places to rawmidi name field instead
of ump info; this assures the sane strings.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250110155943.31578-6-tiwai@suse.de
Stable-dep-of: adeee7187694 ("ALSA: ump: do not touch legacy_rmidi before it exists")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 1dd15fa47c61a..e258000d2d8e6 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -729,6 +729,13 @@ static int ump_handle_device_info_msg(struct snd_ump_endpoint *ump,
 	return 1; /* finished */
 }
 
+/* set up the core rawmidi name from UMP EP name string */
+static void ump_set_rawmidi_name(struct snd_ump_endpoint *ump)
+{
+	safe_copy_string(ump->core.name, sizeof(ump->core.name),
+			 ump->info.name, sizeof(ump->info.name));
+}
+
 /* handle EP name stream message; update the UMP name string */
 static int ump_handle_ep_name_msg(struct snd_ump_endpoint *ump,
 				  const union snd_ump_stream_msg *buf)
@@ -1056,6 +1063,8 @@ int snd_ump_parse_endpoint(struct snd_ump_endpoint *ump)
 	if (err < 0)
 		ump_dbg(ump, "Unable to get UMP EP name string\n");
 
+	ump_set_rawmidi_name(ump);
+
 	/* Request Endpoint Product ID */
 	err = ump_req_msg(ump, msg, UMP_STREAM_MSG_REQUEST_PRODUCT_ID,
 			  UMP_STREAM_MSG_STATUS_PRODUCT_ID);
@@ -1272,7 +1281,7 @@ static void update_legacy_substreams(struct snd_ump_endpoint *ump,
 		idx = ump->legacy_mapping[s->number];
 		name = ump->groups[idx].name;
 		if (!*name)
-			name = ump->info.name;
+			name = ump->core.name;
 		scnprintf(s->name, sizeof(s->name), "Group %d (%.16s)%s",
 			  idx + 1, name,
 			  ump->groups[idx].active ? "" : " [Inactive]");
@@ -1320,7 +1329,7 @@ int snd_ump_attach_legacy_rawmidi(struct snd_ump_endpoint *ump,
 		snd_rawmidi_set_ops(rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT,
 				    &snd_ump_legacy_output_ops);
 	snprintf(rmidi->name, sizeof(rmidi->name), "%.68s (MIDI 1.0)",
-		 ump->info.name);
+		 ump->core.name);
 	rmidi->info_flags = ump->core.info_flags & ~SNDRV_RAWMIDI_INFO_UMP;
 	rmidi->ops = &snd_ump_legacy_ops;
 	rmidi->private_data = ump;
-- 
2.53.0



