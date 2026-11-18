Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032971;
	b=YoHWeAw3Iv58qKwQnTK93CFYIbiaSPweIfbe140AhxoQP+sapkmvXkM+F3I3DOS5QWqm
	 OuwSuO611eGc7Iqrtcq+19GdGMsHdeuMcn3Ai3aoctIfT2eoS+Yg7Qbt5urFk3PekXF+l
	 uk/6Z6KC8CT3XYXEckdJm8CBH+ITFpHy2+SbhoTch6hVgyJW8f7gTEnOVRN9l9CGASV/U
	 gGlpyGnGmhWUAI0cayd7VtGFgpTy1x0sJlK/ElDlDoIF/8G74UVAHZpS++314QwEr7kxV
	 fuqKZbEl6OvTZtRy7pE8wbHrSqe87BogKu8TJBUV/HGcHlDWk/cWF64Z/FR1eotpckg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qWbd5ioPwbQXNJNi3C1ZUG6AyJPbq0RDqjhZuoysr2s=;
	b=GTuDKdChjiyedYr+gKdCJD1vlKGePbiOsRSlia7+Ix6FiPX+OP0Q5wNdjPS7thY5kTZ6
	 3EQJJRu30WsC4EUoWXXLj6N+1ySsFmcKX9M3wMaCg+L1TyPuO/dvXKVqGoFPJIIaWsnlh
	 skjHCbv96jas8ZcOxPR9ZPYRSQOHsV+4clEOGQ5dE5d8uRgj00CVoY9S5lPc7Ri64g/V1
	 AvtAn/SKRQYG1iAdwxGlRtDC67tyYQ9K/dRxSHBZA38UzHxI7fxzcwnOy7qNDIZqM9K6a
	 lY5lSk1RGjbM2/u23/5JzZwUBkcfaEOByNPIZysWmlECf5YEN+6cpb8ZDjRVuRhpZtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xEJuSwcR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F66606A325;
	Wed, 18 Nov 2026 20:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xEJuSwcR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578C51F000C4;
	Wed, 18 Nov 2026 20:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032970;
	bh=qWbd5ioPwbQXNJNi3C1ZUG6AyJPbq0RDqjhZuoysr2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xEJuSwcR8e0RyofOLnwlPHQYtO3zaQNvRwpYSi/SCVd7mKCnUEwsg6H9+LIWWac8n
	 2JEXzQc18lo4NgUM6qU3ZRwOTz2W6y+9ks87QZHAr0uY6XeMlVv+HvQBninsfqRXWV
	 aqQCKIZ4OgWM54M0IRF8gHakPCd43/PZJNiI6jok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1560/1756] ALSA: ump: Drain sequencer callbacks before freeing their client
Date: Wed, 18 Nov 2026 16:01:27 +0100
Message-ID: <20261118150111.517658636@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 9b30046de03acb3b3f2135d45af6be7ee0b565b6 ]

seq_ump_client_free() cancels group_notify_work while the endpoint still
publishes seq_ops and seq_client. A received Function Block update can
enter the sequencer callback after cancellation and queue the work again.
Even disabling the work cannot protect a callback that already loaded
seq_client and then resumes after the client has been freed.

A USB UMP endpoint can continue receiving while its sequencer binding
is removed. The following order uses the same endpoint and client:

  Sequencer binding removal             UMP input completion
  -------------------------             --------------------
  cancel_work_sync()
                                        load seq_ops and seq_client
  delete sequencer client
  clear endpoint binding
  kfree(client)
                                        schedule group_notify_work
                                        read client->seq_client

Cover all calls through seq_ops with SRCU in the UMP core. Withdraw the
operations pointer and wait for those callbacks before canceling work
and deleting the client. No producer can then queue work after the final
cancellation, and both the client and callback code remain available
until the last in-flight callback returns.

Publish seq_ops with release/acquire ordering so the separately stored
seq_client is initialized before any callback uses it. Use SRCU because
sequencer notification delivery can sleep; no callback needs to change
its existing execution context or allocation behavior.

Fixes: 4a16a3af0571 ("ALSA: seq: ump: Handle FB info update")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/pm-pmb-00625126b81966d1bf1d-v2-915f6bbabe1fd458c3ab@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/ump.h             |  5 +++
 sound/core/seq/seq_ump_client.c |  5 +--
 sound/core/ump.c                | 59 ++++++++++++++++++++++++++++-----
 3 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/include/sound/ump.h b/include/sound/ump.h
index 73f97f88e2ed7..387143783a9b5 100644
--- a/include/sound/ump.h
+++ b/include/sound/ump.h
@@ -66,6 +66,7 @@ struct snd_ump_endpoint {
 
 #if IS_ENABLED(CONFIG_SND_SEQUENCER)
 	struct snd_seq_device *seq_dev;
+	/* Published after seq_client; calls are covered by UMP core SRCU. */
 	const struct snd_seq_ump_ops *seq_ops;
 	void *seq_client;
 #endif
@@ -126,6 +127,10 @@ int snd_ump_receive_ump_val(struct snd_ump_endpoint *ump, u32 val);
 int snd_ump_switch_protocol(struct snd_ump_endpoint *ump, unsigned int protocol);
 void snd_ump_update_group_attrs(struct snd_ump_endpoint *ump);
 
+#if IS_ENABLED(CONFIG_SND_SEQUENCER)
+void snd_ump_detach_seq(struct snd_ump_endpoint *ump);
+#endif
+
 /*
  * Some definitions for UMP
  */
diff --git a/sound/core/seq/seq_ump_client.c b/sound/core/seq/seq_ump_client.c
index ad794c22cc420..73b9af190d585 100644
--- a/sound/core/seq/seq_ump_client.c
+++ b/sound/core/seq/seq_ump_client.c
@@ -346,12 +346,12 @@ static int create_ump_endpoint_port(struct seq_ump_client *client)
 /* release the client resources */
 static void seq_ump_client_free(struct seq_ump_client *client)
 {
+	snd_ump_detach_seq(client->ump);
 	cancel_work_sync(&client->group_notify_work);
 
 	if (client->seq_client >= 0)
 		snd_seq_delete_kernel_client(client->seq_client);
 
-	client->ump->seq_ops = NULL;
 	client->ump->seq_client = NULL;
 
 	kfree(client);
@@ -518,7 +518,8 @@ static int snd_seq_ump_probe(struct device *_dev)
 	snd_seq_kernel_client_put(cptr);
 
 	ump->seq_client = client;
-	ump->seq_ops = &seq_ump_ops;
+	/* Publish the initialized client before callbacks can observe seq_ops. */
+	smp_store_release(&ump->seq_ops, &seq_ump_ops);
 	return 0;
 
  error:
diff --git a/sound/core/ump.c b/sound/core/ump.c
index 8ee4350d5ed6e..6bd04270baefa 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/export.h>
 #include <linux/mm.h>
+#include <linux/srcu.h>
 #include <sound/core.h>
 #include <sound/rawmidi.h>
 #include <sound/ump.h>
@@ -18,6 +19,31 @@
 #define ump_info(ump, fmt, args...)	dev_info((ump)->core.dev, fmt, ##args)
 #define ump_dbg(ump, fmt, args...)	dev_dbg((ump)->core.dev, fmt, ##args)
 
+#if IS_ENABLED(CONFIG_SND_SEQUENCER)
+DEFINE_STATIC_SRCU(ump_seq_srcu);
+
+static const struct snd_seq_ump_ops *seq_ops_load(struct snd_ump_endpoint *ump)
+{
+	/* Pair with publication after seq_client has been initialized. */
+	return smp_load_acquire(&ump->seq_ops);
+}
+
+/**
+ * snd_ump_detach_seq - stop callbacks to a sequencer binding
+ * @ump: UMP endpoint
+ *
+ * Withdraw the binding and wait for all callbacks already in progress.
+ * The caller can then drain binding work and free the sequencer client.
+ * Must not be called from one of the binding callbacks.
+ */
+void snd_ump_detach_seq(struct snd_ump_endpoint *ump)
+{
+	WRITE_ONCE(ump->seq_ops, NULL);
+	synchronize_srcu(&ump_seq_srcu);
+}
+EXPORT_SYMBOL_GPL(snd_ump_detach_seq);
+#endif
+
 static int snd_ump_dev_register(struct snd_rawmidi *rmidi);
 static int snd_ump_dev_unregister(struct snd_rawmidi *rmidi);
 static long snd_ump_ioctl(struct snd_rawmidi *rmidi, unsigned int cmd,
@@ -348,8 +374,13 @@ int snd_ump_receive(struct snd_ump_endpoint *ump, const u32 *buffer, int count)
 			continue;
 		ump_handle_stream_msg(ump, ump->input_buf, n);
 #if IS_ENABLED(CONFIG_SND_SEQUENCER)
-		if (ump->seq_ops)
-			ump->seq_ops->input_receive(ump, ump->input_buf, n);
+		scoped_guard(srcu, &ump_seq_srcu) {
+			const struct snd_seq_ump_ops *ops;
+
+			ops = seq_ops_load(ump);
+			if (ops)
+				ops->input_receive(ump, ump->input_buf, n);
+		}
 #endif
 		process_legacy_input(ump, ump->input_buf, n);
 	}
@@ -699,8 +730,12 @@ static void choose_default_protocol(struct snd_ump_endpoint *ump)
 static void seq_notify_ep_change(struct snd_ump_endpoint *ump)
 {
 #if IS_ENABLED(CONFIG_SND_SEQUENCER)
-	if (ump->parsed && ump->seq_ops && ump->seq_ops->notify_ep_change)
-		ump->seq_ops->notify_ep_change(ump);
+	const struct snd_seq_ump_ops *ops;
+
+	guard(srcu)(&ump_seq_srcu);
+	ops = seq_ops_load(ump);
+	if (ump->parsed && ops && ops->notify_ep_change)
+		ops->notify_ep_change(ump);
 #endif
 }
 
@@ -797,8 +832,12 @@ static int ump_handle_product_id_msg(struct snd_ump_endpoint *ump,
 static void seq_notify_protocol(struct snd_ump_endpoint *ump)
 {
 #if IS_ENABLED(CONFIG_SND_SEQUENCER)
-	if (ump->seq_ops && ump->seq_ops->switch_protocol)
-		ump->seq_ops->switch_protocol(ump);
+	const struct snd_seq_ump_ops *ops;
+
+	guard(srcu)(&ump_seq_srcu);
+	ops = seq_ops_load(ump);
+	if (ops && ops->switch_protocol)
+		ops->switch_protocol(ump);
 #endif /* CONFIG_SND_SEQUENCER */
 }
 
@@ -893,8 +932,12 @@ static void seq_notify_fb_change(struct snd_ump_endpoint *ump,
 				 struct snd_ump_block *fb)
 {
 #if IS_ENABLED(CONFIG_SND_SEQUENCER)
-	if (ump->seq_ops && ump->seq_ops->notify_fb_change)
-		ump->seq_ops->notify_fb_change(ump, fb);
+	const struct snd_seq_ump_ops *ops;
+
+	guard(srcu)(&ump_seq_srcu);
+	ops = seq_ops_load(ump);
+	if (ops && ops->notify_fb_change)
+		ops->notify_fb_change(ump, fb);
 #endif
 }
 
-- 
2.53.0



