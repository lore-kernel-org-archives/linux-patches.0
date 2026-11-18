Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021731;
	b=v+Spdmc1awJnxvIPWYzYElshemUmL/mJLE/2Rz5FKKwmLwst+V8wWMHzKeYPnOpUU1nJ
	 scRnnpHluRTIO+euZIl1HI+Uvov7TAL3NwctKtqnHez96+QhtnqmZw9YmHmaloNcVKYeo
	 o+7tLR03FXvxTkpQwQ6CR0dDt+hAez/m0yVNjjE+iXvy3sbJ8aftt0Pg2C4Qe1dbpg9Pf
	 n2Vqh3f+lz9izahr+9q65hN8cekRLA0VyTcb/lMbIMaHmS2rP3daQX5jbLMQME1PcCIzi
	 3JnNXrDQhMkyX3W6auuBMP7ssAfjFSxDRCH9HUuAOwULONiwd6rzwlUf+tpT6WcMgIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fj3m6av2pkgyYuwZIVT8e5GBoBeHzjoTtVRgWLzUPmg=;
	b=xTZD06ICBSMGwkUPl/26u6hJCWZd/xusW9j/9e7G8kgoDzIHzJTojD4s9NAVRXQRe0fW
	 nuuKb9WyTP+H8drdtmjBnbS83/e7Fh97KEGTDDbRPcxJUxzRX1K9jqohJbUKhAYgcnexS
	 DC6ZLmV7xvpOrcsO/fUxq2c3csd+0V83qzfZgBR0qHk1ZJotKuWP8NN1788tPfr35HasD
	 dXvfIT5lBZf4eYcMSgV2nC0t8U1Nd5avzT5fc94H6h9eQ2JKBQyXOUL3uVZinyUTjIHTO
	 cGN7LgdAhnLD8RU918JCbj0lCZk2CG/XiJ5iIdvV0a47rNLEmQDF3KurYpk2InTBZCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7seLJhR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D715C60A2603;
	Wed, 18 Nov 2026 17:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7seLJhR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1D71F000CE;
	Wed, 18 Nov 2026 17:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021731;
	bh=Fj3m6av2pkgyYuwZIVT8e5GBoBeHzjoTtVRgWLzUPmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7seLJhRE+Z6wkXY98bRL3+m6hmO/V11nRX20i14r3SWGJFpVX5sYr8OuAPrUiduC
	 rkCqGdI4ukNqRMiiwZZo6OK+p2K7EHYkhRXKD9qK9X1HMyK642j1laDMzu8osTY4Er
	 fKuO/iNFMP0abiIxv0PBK2i8sHSjftxzMykMKKoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2404/2651] ALSA: ump: Drain sequencer callbacks before freeing their client
Date: Wed, 18 Nov 2026 16:00:44 +0100
Message-ID: <20261118150411.885355676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4c1e81db376f8..ca9dcec198832 100644
--- a/sound/core/seq/seq_ump_client.c
+++ b/sound/core/seq/seq_ump_client.c
@@ -353,12 +353,12 @@ static int create_ump_endpoint_port(struct seq_ump_client *client)
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
@@ -523,7 +523,8 @@ static int snd_seq_ump_probe(struct snd_seq_device *dev)
 	snd_seq_kernel_client_put(cptr);
 
 	ump->seq_client = client;
-	ump->seq_ops = &seq_ump_ops;
+	/* Publish the initialized client before callbacks can observe seq_ops. */
+	smp_store_release(&ump->seq_ops, &seq_ump_ops);
 	return 0;
 
  error:
diff --git a/sound/core/ump.c b/sound/core/ump.c
index f6482a9bfe614..20cae15e76fcf 100644
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



