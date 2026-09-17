Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D140F3D16E5;
	Thu, 17 Sep 2026 18:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670366; cv=none; b=G0ugbk8PwhSaq0Ioij/tYg+QDiS6q7nItjZ72y0044Y8hO/E3Ug5o0eByjUMR2AZ9xCyjSsJvJ9UDDtG6WFubu7k7xCL4+1VLFOl9HaaXKxdGFDaGo9rgGaccUDcZiD6tfZDJSWIuqvziVhNAu76Ss67BGg57EHF0TjXFPZhNP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670366; c=relaxed/simple;
	bh=ohjbLMKBcykBk/J9HOS8dKWK6yX8S+nJ5CFd0DvOd+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3QIrJGV0vcHw8lKV4OCVvzTP60/qN+Fs3sP6niJZKMAhM3nLSoGRbKSM/66DRRv+Uk7gygPm6j5qzH6Tmx80rvOoGio7ShSi8pckyg31QCaw50Mcg72Vq9nI19whn3Z1dvtDwjfAp/HHmU09o3sSRugbdDCl/981R+Ejs7n1x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNDRmQAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNDRmQAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C3B1F000FF;
	Thu, 17 Sep 2026 18:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670364;
	bh=lDjFeqpVp6yVrVfDes//UhurDnJO2cwH7TVNokvyiHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNDRmQAu2++MkqV+Jsxtv/aGkffGEOn7X7PtP1+0P3CLUTznXZdTZehVrUZyCChj/
	 ra6cj+hEaKwiFQ4O+YoHCA9TEJOzncRtoDR7A7XZqjKoes1BbKjWs1IP8kR1Ie6tnP
	 lVfsnhOzEWZGMLzQiu6QbD+yKIIrjX9Y29Q3KRWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0602/1102] ALSA: ump: Copy safe string name to rawmidi
Date: Thu, 17 Sep 2026 16:09:05 +0100
Message-ID: <20260917151555.119247061@linuxfoundation.org>
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
index d7d82ccfa6e3f..ec939f332beff 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -740,6 +740,13 @@ static int ump_handle_device_info_msg(struct snd_ump_endpoint *ump,
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
@@ -1067,6 +1074,8 @@ int snd_ump_parse_endpoint(struct snd_ump_endpoint *ump)
 	if (err < 0)
 		ump_dbg(ump, "Unable to get UMP EP name string\n");
 
+	ump_set_rawmidi_name(ump);
+
 	/* Request Endpoint Product ID */
 	err = ump_req_msg(ump, msg, UMP_STREAM_MSG_REQUEST_PRODUCT_ID,
 			  UMP_STREAM_MSG_STATUS_PRODUCT_ID);
@@ -1283,7 +1292,7 @@ static void update_legacy_substreams(struct snd_ump_endpoint *ump,
 		idx = ump->legacy_mapping[s->number];
 		name = ump->groups[idx].name;
 		if (!*name)
-			name = ump->info.name;
+			name = ump->core.name;
 		scnprintf(s->name, sizeof(s->name), "Group %d (%.16s)%s",
 			  idx + 1, name,
 			  ump->groups[idx].active ? "" : " [Inactive]");
@@ -1331,7 +1340,7 @@ int snd_ump_attach_legacy_rawmidi(struct snd_ump_endpoint *ump,
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



