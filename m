Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032956;
	b=n0Tho+rE4wg++bcztwbSBk3Ng2o2toEDHt0onG4RAXqGkjkm3uBlhoHBZhTIFPcY6YXP
	 kLk5DSu2clAhT4R3X6AcIoTS2J+kLUsGB0EbaLiF+sdFqXtodinZMudGpidgmLQH+GIaN
	 g4L4EC70A3EZN197EAl32i293ozG98LQiYmA1S4ta9QLaHMUSlpv5FlQSN+4k+bsso/Zs
	 rrqfisioLSJ3wgfM9qUhDl5ae/fgO40l1HQNKvxUH4l+i6+V2hpTAxa6SaZvNQn79EYz8
	 mMxeU/U4KzU2wyrLkcN54uW0LpefdvYVodi9NtmXJVyEaFOtL/zVtz3SfN2VqDbaU5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kJyIF1niwEzBI910GcBNYaZAptT6H19A29wLBcBo9i4=;
	b=nw1s6rBsHCa1vLeDKUbL0Qw7wpqXCLxNUAel9rdZgr5Kdnqx1fsGBP8QhgVialsq/tRX
	 Vv2SG93do4LALSPpwwGI52OQx00fPUMDFx948MSBe3P3fkE3zHj1ya6hxx+H3AHbrt9iV
	 5G4tiseqlskDU+E7pg2++KxBuZQ6izQyDWn/+22J3XWCNyHOatNh1dqQ0h4S5qvwTXJ6o
	 IiIsVTjzhYGsAVhk/59hwmhB1I5bNMvYU7jjfuJmIdp4nJecHGzeAfLarCOUHJl3BJaYZ
	 XkimJTMkQjjzwVTC5BEvDUYTi1RiDCeQGxRN3PRG0izVPedXjvpMbuDIO1livr6szJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IlMAJzHG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBF9606A325;
	Wed, 18 Nov 2026 20:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IlMAJzHG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2A51F000C4;
	Wed, 18 Nov 2026 20:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032956;
	bh=kJyIF1niwEzBI910GcBNYaZAptT6H19A29wLBcBo9i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlMAJzHGet3JCDQtFaiIaUbUAgOTv2kLIBwGMExewKJ0urc41fVUr41chNhPqZf1/
	 MStGXmhVjpGtpvm3Ybux1ik0bujAnGhn1+KUpYycm79phzdAIA47GIqoZy+A5JOtLL
	 6VplnwPLeyFHf7BhO9Mcy/d7eKPgYm6p6GfA6x4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1559/1756] ALSA: seq: Notify UMP EP and FB changes
Date: Wed, 18 Nov 2026 16:01:26 +0100
Message-ID: <20261118150111.446608004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3ab4a3199c782eae9b683b952f3ec5a766e4a096 ]

So far we notify the sequencer client and port changes upon UMP FB
changes, but those aren't really corresponding to the UMP updates.
e.g. when a FB info gets updated, it's not notified but done only when
some of sequencer port attribute is changed.  This is no ideal
behavior.

This patch adds the two new sequencer event types for notifying the
UMP EP and FB changes via the announce port.  The new event takes
snd_seq_ev_ump_notify type data, which is compatible with
snd_seq_addr (where the port number is replaced with the block
number).

The events are sent when the EP and FB info gets updated explicitly
via ioctl, or the backend UMP receives the corresponding UMP
messages.

The sequencer protocol version is bumped to 1.0.5 along with it.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250110155943.31578-9-tiwai@suse.de
Stable-dep-of: 9b30046de03a ("ALSA: ump: Drain sequencer callbacks before freeing their client")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/sound/designs/midi-2.0.rst |  7 +++++
 include/sound/ump.h                      |  1 +
 include/uapi/sound/asequencer.h          | 12 ++++++-
 sound/core/seq/seq_clientmgr.c           | 10 ++++++
 sound/core/seq/seq_system.h              | 10 ++++++
 sound/core/seq/seq_ump_client.c          | 40 ++++++++++++++++++++++--
 sound/core/ump.c                         | 23 ++++++++++++--
 7 files changed, 97 insertions(+), 6 deletions(-)

diff --git a/Documentation/sound/designs/midi-2.0.rst b/Documentation/sound/designs/midi-2.0.rst
index d6c17a47c8320..71a343c93fe7d 100644
--- a/Documentation/sound/designs/midi-2.0.rst
+++ b/Documentation/sound/designs/midi-2.0.rst
@@ -388,6 +388,13 @@ Sequencer API Extensions
   announcement to the ALSA sequencer system port, similarly like the
   normal port change notification.
 
+* There are two extended event types for notifying the UMP Endpoint and
+  Function Block changes via the system announcement port:
+  type 68 (`SNDRV_SEQ_EVENT_UMP_EP_CHANGE`) and type 69
+  (`SNDRV_SEQ_EVENT_UMP_BLOCK_CHANGE`). They take the new type,
+  `snd_seq_ev_ump_notify` in the payload, indicating the client number
+  and the FB number that are changed.
+
 
 MIDI2 USB Gadget Function Driver
 ================================
diff --git a/include/sound/ump.h b/include/sound/ump.h
index 532c2c3ea28e3..73f97f88e2ed7 100644
--- a/include/sound/ump.h
+++ b/include/sound/ump.h
@@ -83,6 +83,7 @@ struct snd_ump_ops {
 struct snd_seq_ump_ops {
 	void (*input_receive)(struct snd_ump_endpoint *ump,
 			      const u32 *data, int words);
+	int (*notify_ep_change)(struct snd_ump_endpoint *ump);
 	int (*notify_fb_change)(struct snd_ump_endpoint *ump,
 				struct snd_ump_block *fb);
 	int (*switch_protocol)(struct snd_ump_endpoint *ump);
diff --git a/include/uapi/sound/asequencer.h b/include/uapi/sound/asequencer.h
index bc30c1f2a1094..a5c41f771e059 100644
--- a/include/uapi/sound/asequencer.h
+++ b/include/uapi/sound/asequencer.h
@@ -10,7 +10,7 @@
 #include <sound/asound.h>
 
 /** version of the sequencer */
-#define SNDRV_SEQ_VERSION SNDRV_PROTOCOL_VERSION(1, 0, 4)
+#define SNDRV_SEQ_VERSION SNDRV_PROTOCOL_VERSION(1, 0, 5)
 
 /**
  * definition of sequencer event types
@@ -92,6 +92,9 @@
 #define SNDRV_SEQ_EVENT_PORT_SUBSCRIBED	66	/* ports connected */
 #define SNDRV_SEQ_EVENT_PORT_UNSUBSCRIBED 67	/* ports disconnected */
 
+#define SNDRV_SEQ_EVENT_UMP_EP_CHANGE	68	/* UMP EP info has changed */
+#define SNDRV_SEQ_EVENT_UMP_BLOCK_CHANGE 69	/* UMP block info has changed */
+
 /* 70-89:  synthesizer events - obsoleted */
 
 /** user-defined events with fixed length
@@ -253,6 +256,12 @@ struct snd_seq_ev_quote {
 	struct snd_seq_event *event;		/* quoted event */
 } __packed;
 
+	/* UMP info change notify */
+struct snd_seq_ev_ump_notify {
+	unsigned char client;	/**< Client number */
+	unsigned char block;	/**< Block number (optional) */
+};
+
 union snd_seq_event_data { /* event data... */
 	struct snd_seq_ev_note note;
 	struct snd_seq_ev_ctrl control;
@@ -265,6 +274,7 @@ union snd_seq_event_data { /* event data... */
 	struct snd_seq_connect connect;
 	struct snd_seq_result result;
 	struct snd_seq_ev_quote quote;
+	struct snd_seq_ev_ump_notify ump_notify;
 };
 
 	/* sequencer event */
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 55014bfc02570..6d0c0937236da 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -2295,6 +2295,16 @@ static int snd_seq_ioctl_client_ump_info(struct snd_seq_client *caller,
  error:
 	mutex_unlock(&cptr->ioctl_mutex);
 	snd_seq_client_unlock(cptr);
+	if (!err && cmd == SNDRV_SEQ_IOCTL_SET_CLIENT_UMP_INFO) {
+		if (type == SNDRV_SEQ_CLIENT_UMP_INFO_ENDPOINT)
+			snd_seq_system_ump_notify(client, 0,
+						  SNDRV_SEQ_EVENT_UMP_EP_CHANGE,
+						  false);
+		else
+			snd_seq_system_ump_notify(client, type - 1,
+						  SNDRV_SEQ_EVENT_UMP_BLOCK_CHANGE,
+						  false);
+	}
 	return err;
 }
 #endif
diff --git a/sound/core/seq/seq_system.h b/sound/core/seq/seq_system.h
index a118f7252b62a..62e513f748715 100644
--- a/sound/core/seq/seq_system.h
+++ b/sound/core/seq/seq_system.h
@@ -16,6 +16,16 @@ void snd_seq_system_broadcast(int client, int port, int type, bool atomic);
 #define notify_event(client, port, type) \
 	snd_seq_system_broadcast(client, port, type, false)
 
+/* notify UMP EP/FB change event */
+static inline void snd_seq_system_ump_notify(int client, int block, int type,
+					     bool atomic)
+{
+	/* reuse the existing snd_seq_system_broadcast():
+	 * struct snd_seq_ev_ump_notify is compatible with struct snd_seq_addr
+	 */
+	snd_seq_system_broadcast(client, block, type, atomic);
+}
+
 #define snd_seq_system_client_ev_client_start(client) notify_event(client, 0, SNDRV_SEQ_EVENT_CLIENT_START)
 #define snd_seq_system_client_ev_client_exit(client) notify_event(client, 0, SNDRV_SEQ_EVENT_CLIENT_EXIT)
 #define snd_seq_system_client_ev_client_change(client) notify_event(client, 0, SNDRV_SEQ_EVENT_CLIENT_CHANGE)
diff --git a/sound/core/seq/seq_ump_client.c b/sound/core/seq/seq_ump_client.c
index 0d5d5ade87e68..ad794c22cc420 100644
--- a/sound/core/seq/seq_ump_client.c
+++ b/sound/core/seq/seq_ump_client.c
@@ -401,6 +401,33 @@ static void handle_group_notify(struct work_struct *work)
 	setup_client_group_filter(client);
 }
 
+/* UMP EP change notification */
+static int seq_ump_notify_ep_change(struct snd_ump_endpoint *ump)
+{
+	struct seq_ump_client *client = ump->seq_client;
+	struct snd_seq_client *cptr;
+	int client_id;
+
+	if (!client)
+		return -ENODEV;
+	client_id = client->seq_client;
+	cptr = snd_seq_kernel_client_get(client_id);
+	if (!cptr)
+		return -ENODEV;
+
+	snd_seq_system_ump_notify(client_id, 0, SNDRV_SEQ_EVENT_UMP_EP_CHANGE,
+				  true);
+
+	/* update sequencer client name if needed */
+	if (*ump->core.name && strcmp(ump->core.name, cptr->name)) {
+		strscpy(cptr->name, ump->core.name, sizeof(cptr->name));
+		snd_seq_system_client_ev_client_change(client_id);
+	}
+
+	snd_seq_kernel_client_put(cptr);
+	return 0;
+}
+
 /* UMP FB change notification */
 static int seq_ump_notify_fb_change(struct snd_ump_endpoint *ump,
 				    struct snd_ump_block *fb)
@@ -410,20 +437,29 @@ static int seq_ump_notify_fb_change(struct snd_ump_endpoint *ump,
 	if (!client)
 		return -ENODEV;
 	schedule_work(&client->group_notify_work);
+	snd_seq_system_ump_notify(client->seq_client, fb->info.block_id,
+				  SNDRV_SEQ_EVENT_UMP_BLOCK_CHANGE,
+				  true);
 	return 0;
 }
 
 /* UMP protocol change notification; just update the midi_version field */
 static int seq_ump_switch_protocol(struct snd_ump_endpoint *ump)
 {
-	if (!ump->seq_client)
+	struct seq_ump_client *client = ump->seq_client;
+
+	if (!client)
 		return -ENODEV;
-	setup_client_midi_version(ump->seq_client);
+	setup_client_midi_version(client);
+	snd_seq_system_ump_notify(client->seq_client, 0,
+				  SNDRV_SEQ_EVENT_UMP_EP_CHANGE,
+				  true);
 	return 0;
 }
 
 static const struct snd_seq_ump_ops seq_ump_ops = {
 	.input_receive = seq_ump_input_receive,
+	.notify_ep_change = seq_ump_notify_ep_change,
 	.notify_fb_change = seq_ump_notify_fb_change,
 	.switch_protocol = seq_ump_switch_protocol,
 };
diff --git a/sound/core/ump.c b/sound/core/ump.c
index e35253cc019d2..8ee4350d5ed6e 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -695,6 +695,15 @@ static void choose_default_protocol(struct snd_ump_endpoint *ump)
 		ump->info.protocol |= SNDRV_UMP_EP_INFO_PROTO_MIDI1;
 }
 
+/* notify the EP info/name change to sequencer */
+static void seq_notify_ep_change(struct snd_ump_endpoint *ump)
+{
+#if IS_ENABLED(CONFIG_SND_SEQUENCER)
+	if (ump->parsed && ump->seq_ops && ump->seq_ops->notify_ep_change)
+		ump->seq_ops->notify_ep_change(ump);
+#endif
+}
+
 /* handle EP info stream message; update the UMP attributes */
 static int ump_handle_ep_info_msg(struct snd_ump_endpoint *ump,
 				  const union snd_ump_stream_msg *buf)
@@ -719,6 +728,7 @@ static int ump_handle_ep_info_msg(struct snd_ump_endpoint *ump,
 
 	ump->info.protocol &= ump->info.protocol_caps;
 	choose_default_protocol(ump);
+	seq_notify_ep_change(ump);
 
 	return 1; /* finished */
 }
@@ -741,6 +751,7 @@ static int ump_handle_device_info_msg(struct snd_ump_endpoint *ump,
 		ump->info.family_id,
 		ump->info.model_id,
 		ump->info.sw_revision);
+	seq_notify_ep_change(ump);
 	return 1; /* finished */
 }
 
@@ -762,6 +773,7 @@ static int ump_handle_ep_name_msg(struct snd_ump_endpoint *ump,
 	if (ret && ump->parsed) {
 		ump_set_rawmidi_name(ump);
 		ump_legacy_set_rawmidi_name(ump);
+		seq_notify_ep_change(ump);
 	}
 
 	return ret;
@@ -771,9 +783,14 @@ static int ump_handle_ep_name_msg(struct snd_ump_endpoint *ump,
 static int ump_handle_product_id_msg(struct snd_ump_endpoint *ump,
 				     const union snd_ump_stream_msg *buf)
 {
-	return ump_append_string(ump, ump->info.product_id,
-				 sizeof(ump->info.product_id),
-				 buf->raw, 2);
+	int ret;
+
+	ret = ump_append_string(ump, ump->info.product_id,
+				sizeof(ump->info.product_id),
+				buf->raw, 2);
+	if (ret)
+		seq_notify_ep_change(ump);
+	return ret;
 }
 
 /* notify the protocol change to sequencer */
-- 
2.53.0



