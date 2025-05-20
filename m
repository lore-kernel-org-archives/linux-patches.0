Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C492907;
	Tue, 20 May 2025 14:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750520; cv=none; b=rjw159Ji0misStLEQvNmQamKkwY8EiZ3rno3pGt9xxjPc18Xx77z/eMYz/H3/Gvw5hDj8o8ZrcBp7BHq3MOJd1bnXIBUkENJoza+qWyZzvzsZ3uXx3dmpG18ZqvGyV9lJpom5VZX9wEgu3h+MsPIij1ORIyhSlgViSjwnUR25T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750520; c=relaxed/simple;
	bh=Djk6t3fieimd/NAyIypWOTqL8yGDxCX+QKVbRr7YUzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYD8/8+qp91ubiMzknzExt3aVQacWX2ey6GgtFiw32068OohDVVnpImsK8T5ZG0ki5txzpmRF5EEm1/yLFJrwhgEOUDawUiQa0aSPd+mqFWaeej27MYf7ILlDI4SscfrVl/Nv6W/QeZa8BN2Gz8LGoQzDSEHCLZQDqoJi8ksWDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmfvnrcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmfvnrcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD667C4CEE9;
	Tue, 20 May 2025 14:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750520;
	bh=Djk6t3fieimd/NAyIypWOTqL8yGDxCX+QKVbRr7YUzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmfvnrcNxj0N88PpnoPVJVRbKxZ8xA4yjw7bElZyDLi+5c8bxQagzUBMjk9ggTvyw
	 jK0W654hvItKyteGzEmodOyVcJWE5aEXjSL2ue2luMTi6YF1roQERCsbRC1tOk8MKP
	 vW2nrOEMrLzTU3r0mJuCBVFq6k1da+90v8vA+KH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 034/145] ALSA: seq: Fix delivery of UMP events to group ports
Date: Tue, 20 May 2025 15:50:04 +0200
Message-ID: <20250520125811.901376362@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ff7b190aef6cccdb6f14d20c5753081fe6420e0b ]

When an event with UMP message is sent to a UMP client, the EP port
receives always no matter where the event is sent to, as it's a
catch-all port.  OTOH, if an event is sent to EP port, and if the
event has a certain UMP Group, it should have been delivered to the
associated UMP Group port, too, but this was ignored, so far.

This patch addresses the behavior.  Now a UMP event sent to the
Endpoint port will be delivered to the subscribers of the UMP group
port the event is associated with.

The patch also does a bit of refactoring to simplify the code about
__deliver_to_subscribers().

Fixes: 177ccf811df4 ("ALSA: seq: Support MIDI 2.0 UMP Endpoint port")
Link: https://patch.msgid.link/20250511134528.6314-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c   | 52 ++++++++++++++++++++------------
 sound/core/seq/seq_ump_convert.c | 18 +++++++++++
 sound/core/seq/seq_ump_convert.h |  1 +
 3 files changed, 52 insertions(+), 19 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 706f53e39b53c..0ae01b85bb18c 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -732,15 +732,21 @@ static int snd_seq_deliver_single_event(struct snd_seq_client *client,
  */
 static int __deliver_to_subscribers(struct snd_seq_client *client,
 				    struct snd_seq_event *event,
-				    struct snd_seq_client_port *src_port,
-				    int atomic, int hop)
+				    int port, int atomic, int hop)
 {
+	struct snd_seq_client_port *src_port;
 	struct snd_seq_subscribers *subs;
 	int err, result = 0, num_ev = 0;
 	union __snd_seq_event event_saved;
 	size_t saved_size;
 	struct snd_seq_port_subs_info *grp;
 
+	if (port < 0)
+		return 0;
+	src_port = snd_seq_port_use_ptr(client, port);
+	if (!src_port)
+		return 0;
+
 	/* save original event record */
 	saved_size = snd_seq_event_packet_size(event);
 	memcpy(&event_saved, event, saved_size);
@@ -775,6 +781,7 @@ static int __deliver_to_subscribers(struct snd_seq_client *client,
 		read_unlock(&grp->list_lock);
 	else
 		up_read(&grp->list_mutex);
+	snd_seq_port_unlock(src_port);
 	memcpy(event, &event_saved, saved_size);
 	return (result < 0) ? result : num_ev;
 }
@@ -783,25 +790,32 @@ static int deliver_to_subscribers(struct snd_seq_client *client,
 				  struct snd_seq_event *event,
 				  int atomic, int hop)
 {
-	struct snd_seq_client_port *src_port;
-	int ret = 0, ret2;
-
-	src_port = snd_seq_port_use_ptr(client, event->source.port);
-	if (src_port) {
-		ret = __deliver_to_subscribers(client, event, src_port, atomic, hop);
-		snd_seq_port_unlock(src_port);
-	}
-
-	if (client->ump_endpoint_port < 0 ||
-	    event->source.port == client->ump_endpoint_port)
-		return ret;
+	int ret;
+#if IS_ENABLED(CONFIG_SND_SEQ_UMP)
+	int ret2;
+#endif
 
-	src_port = snd_seq_port_use_ptr(client, client->ump_endpoint_port);
-	if (!src_port)
+	ret = __deliver_to_subscribers(client, event,
+				       event->source.port, atomic, hop);
+#if IS_ENABLED(CONFIG_SND_SEQ_UMP)
+	if (!snd_seq_client_is_ump(client) || client->ump_endpoint_port < 0)
 		return ret;
-	ret2 = __deliver_to_subscribers(client, event, src_port, atomic, hop);
-	snd_seq_port_unlock(src_port);
-	return ret2 < 0 ? ret2 : ret;
+	/* If it's an event from EP port (and with a UMP group),
+	 * deliver to subscribers of the corresponding UMP group port, too.
+	 * Or, if it's from non-EP port, deliver to subscribers of EP port, too.
+	 */
+	if (event->source.port == client->ump_endpoint_port)
+		ret2 = __deliver_to_subscribers(client, event,
+						snd_seq_ump_group_port(event),
+						atomic, hop);
+	else
+		ret2 = __deliver_to_subscribers(client, event,
+						client->ump_endpoint_port,
+						atomic, hop);
+	if (ret2 < 0)
+		return ret2;
+#endif
+	return ret;
 }
 
 /* deliver an event to the destination port(s).
diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index ff7e558b4d51d..db2f169cae11e 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -1285,3 +1285,21 @@ int snd_seq_deliver_to_ump(struct snd_seq_client *source,
 	else
 		return cvt_to_ump_midi1(dest, dest_port, event, atomic, hop);
 }
+
+/* return the UMP group-port number of the event;
+ * return -1 if groupless or non-UMP event
+ */
+int snd_seq_ump_group_port(const struct snd_seq_event *event)
+{
+	const struct snd_seq_ump_event *ump_ev =
+		(const struct snd_seq_ump_event *)event;
+	unsigned char type;
+
+	if (!snd_seq_ev_is_ump(event))
+		return -1;
+	type = ump_message_type(ump_ev->ump[0]);
+	if (ump_is_groupless_msg(type))
+		return -1;
+	/* group-port number starts from 1 */
+	return ump_message_group(ump_ev->ump[0]) + 1;
+}
diff --git a/sound/core/seq/seq_ump_convert.h b/sound/core/seq/seq_ump_convert.h
index 6c146d8032804..4abf0a7637d70 100644
--- a/sound/core/seq/seq_ump_convert.h
+++ b/sound/core/seq/seq_ump_convert.h
@@ -18,5 +18,6 @@ int snd_seq_deliver_to_ump(struct snd_seq_client *source,
 			   struct snd_seq_client_port *dest_port,
 			   struct snd_seq_event *event,
 			   int atomic, int hop);
+int snd_seq_ump_group_port(const struct snd_seq_event *event);
 
 #endif /* __SEQ_UMP_CONVERT_H */
-- 
2.39.5



