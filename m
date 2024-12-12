Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9196F2FE;
	Thu, 12 Dec 2024 15:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017811; cv=none; b=mCBWiKyhSpTlfiAPJjZ44di4sgb5akCc6aLsFnQToUlRggHlRXV8GOZ1N4/bhOusRTiJ8yqJcbor1PEKkv6J/sdDalKBxCTGKVamuqYZ2XEYI+WwEED5S7K/fV8WpRPtegMWMPjLr+F9Sg28/SYTjEYDa5UPr+lanEwTWM9uhSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017811; c=relaxed/simple;
	bh=Zo4FzIFUAQYmtCmmKBWR5+IzdqHZng7Q5YKmssNZ4kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+zioswWv5X7jaHvdr4NtolRQvteEUQ7QqRuzvLlYLjZ1BHByrGpVFG14ZHhOudtE0u44FO1Om5wid0J90xFBvOuxUhmzoxUzTPV2wgoA/FfeT2IoQ6K6lzzXll21RTE1A9ly8ULjNZkFmW7yfDJNcmGpzmAGA9raGUrGK8LfxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaAiTKld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaAiTKld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF1FC4CED0;
	Thu, 12 Dec 2024 15:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017811;
	bh=Zo4FzIFUAQYmtCmmKBWR5+IzdqHZng7Q5YKmssNZ4kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaAiTKld/Ba6zDN3cJ9b9oYezSxUJH+3nTjyH/+Ftt+qM8w5cBSKOp7E5zIAm10a1
	 UMff087sQ9+Ib0U5613qjY3x9jQmO85NpTRcH8EfU1vNInYYnBxX8pWJNaz24waZap
	 rmqgkS53emNDDy7AaU2bX65jEl3cTMOIwCmbTVEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/356] ALSA: seq: ump: Use automatic cleanup of kfree()
Date: Thu, 12 Dec 2024 15:57:16 +0100
Message-ID: <20241212144249.273635709@linuxfoundation.org>
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

[ Upstream commit 316e38ef776663a7a4c5d76438c42c948c574df4 ]

There are common patterns where a temporary buffer is allocated and
freed at the exit, and those can be simplified with the recent cleanup
mechanism via __free(kfree).

No functional changes, only code refactoring.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240222111509.28390-9-tiwai@suse.de
Stable-dep-of: aaa55faa2495 ("ALSA: seq: ump: Fix seq port updates per FB info notify")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_client.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/sound/core/seq/seq_ump_client.c b/sound/core/seq/seq_ump_client.c
index eaf7181b9af5b..b4c7543a24249 100644
--- a/sound/core/seq/seq_ump_client.c
+++ b/sound/core/seq/seq_ump_client.c
@@ -225,18 +225,15 @@ static bool skip_group(struct seq_ump_client *client, struct seq_ump_group *grou
 static int seq_ump_group_init(struct seq_ump_client *client, int group_index)
 {
 	struct seq_ump_group *group = &client->groups[group_index];
-	struct snd_seq_port_info *port;
+	struct snd_seq_port_info *port __free(kfree) = NULL;
 	struct snd_seq_port_callback pcallbacks;
-	int err;
 
 	if (skip_group(client, group))
 		return 0;
 
 	port = kzalloc(sizeof(*port), GFP_KERNEL);
-	if (!port) {
-		err = -ENOMEM;
-		goto error;
-	}
+	if (!port)
+		return -ENOMEM;
 
 	fill_port_info(port, client, group);
 	port->flags = SNDRV_SEQ_PORT_FLG_GIVEN_PORT;
@@ -249,24 +246,22 @@ static int seq_ump_group_init(struct seq_ump_client *client, int group_index)
 	pcallbacks.unuse = seq_ump_unuse;
 	pcallbacks.event_input = seq_ump_process_event;
 	port->kernel = &pcallbacks;
-	err = snd_seq_kernel_client_ctl(client->seq_client,
-					SNDRV_SEQ_IOCTL_CREATE_PORT,
-					port);
- error:
-	kfree(port);
-	return err;
+	return snd_seq_kernel_client_ctl(client->seq_client,
+					 SNDRV_SEQ_IOCTL_CREATE_PORT,
+					 port);
 }
 
 /* update the sequencer ports; called from notify_fb_change callback */
 static void update_port_infos(struct seq_ump_client *client)
 {
-	struct snd_seq_port_info *old, *new;
+	struct snd_seq_port_info *old __free(kfree) = NULL;
+	struct snd_seq_port_info *new __free(kfree) = NULL;
 	int i, err;
 
 	old = kzalloc(sizeof(*old), GFP_KERNEL);
 	new = kzalloc(sizeof(*new), GFP_KERNEL);
 	if (!old || !new)
-		goto error;
+		return;
 
 	for (i = 0; i < SNDRV_UMP_MAX_GROUPS; i++) {
 		if (skip_group(client, &client->groups[i]))
@@ -278,7 +273,7 @@ static void update_port_infos(struct seq_ump_client *client)
 						SNDRV_SEQ_IOCTL_GET_PORT_INFO,
 						old);
 		if (err < 0)
-			goto error;
+			return;
 		fill_port_info(new, client, &client->groups[i]);
 		if (old->capability == new->capability &&
 		    !strcmp(old->name, new->name))
@@ -287,13 +282,10 @@ static void update_port_infos(struct seq_ump_client *client)
 						SNDRV_SEQ_IOCTL_SET_PORT_INFO,
 						new);
 		if (err < 0)
-			goto error;
+			return;
 		/* notify to system port */
 		snd_seq_system_client_ev_port_change(client->seq_client, i);
 	}
- error:
-	kfree(new);
-	kfree(old);
 }
 
 /* update dir_bits and active flag for all groups in the client */
@@ -350,7 +342,7 @@ static void update_group_attrs(struct seq_ump_client *client)
 /* create a UMP Endpoint port */
 static int create_ump_endpoint_port(struct seq_ump_client *client)
 {
-	struct snd_seq_port_info *port;
+	struct snd_seq_port_info *port __free(kfree) = NULL;
 	struct snd_seq_port_callback pcallbacks;
 	unsigned int rawmidi_info = client->ump->core.info_flags;
 	int err;
@@ -399,7 +391,6 @@ static int create_ump_endpoint_port(struct seq_ump_client *client)
 	err = snd_seq_kernel_client_ctl(client->seq_client,
 					SNDRV_SEQ_IOCTL_CREATE_PORT,
 					port);
-	kfree(port);
 	return err;
 }
 
-- 
2.43.0



