Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D3A2236FB;
	Mon, 10 Mar 2025 17:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626538; cv=none; b=gAEMpxEiayc9tWJFdQ8e5ggjYX99mJFXGrkQbyTjtA7ug28j27RYukcBFw3HB8hxGF52xtCP5PnxiKTWiNmZSVEmQMFb/lScAmyW7Ku0UY86WbjiEUqApy/yB4OONcnJvjV3d4z94mdTuRaaSSkezngMXnNvL+RghJmDTJxPruY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626538; c=relaxed/simple;
	bh=uS/qRKFNSe2ZuEz5wsCaCnqtGLDjphC/2E2Svp9ZYvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCmsJtKGUC/nCqWPpGBeBPKzNTo0vhhJt8qeg3K+notd/hJ3u81aZVfKMH+K/WVS0M5SSQ58WLKLvSuEfHHTq/Y93ECMTNORpvhEeAGzi08qIMFQfTBXPLTSNfONLZEFvBFgG+r4pfIpJAnIn1tjjs3rq1wmBCJOdvvetrixu5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+w9apjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+w9apjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8F4C4CEE5;
	Mon, 10 Mar 2025 17:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626538;
	bh=uS/qRKFNSe2ZuEz5wsCaCnqtGLDjphC/2E2Svp9ZYvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+w9apjYjZvkY6w5OXtEXQxcmg/jWlKcJzHQH4w/cZg573+yLLbuYBhBKt1EhIYhC
	 LS/tC2FoPEiObiwogEfwq/WqkJgozJFLqFjPXo2eKMJFYPgnDkdmQ3Be3lBt79XLxr
	 q7+flnmd3xp0ILQ3OKUuDMsKB0iPy1LuHjnQHzUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4cb9fad083898f54c517@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 026/207] ALSA: seq: Avoid module auto-load handling at event delivery
Date: Mon, 10 Mar 2025 18:03:39 +0100
Message-ID: <20250310170448.813303913@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c9ce148ea753bef66686460fa3cec6641cdfbb9f upstream.

snd_seq_client_use_ptr() is supposed to return the snd_seq_client
object for the given client ID, and it tries to handle the module
auto-loading when no matching object is found.  Although the module
handling is performed only conditionally with "!in_interrupt()", this
condition may be fragile, e.g. when the code is called from the ALSA
timer callback where the spinlock is temporarily disabled while the
irq is disabled.  Then his doesn't fit well and spews the error about
sleep from invalid context, as complained recently by syzbot.

Also, in general, handling the module-loading at each time if no
matching object is found is really an overkill.  It can be still
useful when performed at the top-level ioctl or proc reads, but it
shouldn't be done at event delivery at all.

For addressing the issues above, this patch disables the module
handling in snd_seq_client_use_ptr() in normal cases like event
deliveries, but allow only in limited and safe situations.
A new function client_load_and_use_ptr() is used for the cases where
the module loading can be done safely, instead.

Reported-by: syzbot+4cb9fad083898f54c517@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/67c272e5.050a0220.dc10f.0159.GAE@google.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250301114530.8975-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_clientmgr.c |   46 ++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 16 deletions(-)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -106,7 +106,7 @@ static struct snd_seq_client *clientptr(
 	return clienttab[clientid];
 }
 
-struct snd_seq_client *snd_seq_client_use_ptr(int clientid)
+static struct snd_seq_client *client_use_ptr(int clientid, bool load_module)
 {
 	unsigned long flags;
 	struct snd_seq_client *client;
@@ -126,7 +126,7 @@ struct snd_seq_client *snd_seq_client_us
 	}
 	spin_unlock_irqrestore(&clients_lock, flags);
 #ifdef CONFIG_MODULES
-	if (!in_interrupt()) {
+	if (load_module) {
 		static DECLARE_BITMAP(client_requested, SNDRV_SEQ_GLOBAL_CLIENTS);
 		static DECLARE_BITMAP(card_requested, SNDRV_CARDS);
 
@@ -168,6 +168,20 @@ struct snd_seq_client *snd_seq_client_us
 	return client;
 }
 
+/* get snd_seq_client object for the given id quickly */
+struct snd_seq_client *snd_seq_client_use_ptr(int clientid)
+{
+	return client_use_ptr(clientid, false);
+}
+
+/* get snd_seq_client object for the given id;
+ * if not found, retry after loading the modules
+ */
+static struct snd_seq_client *client_load_and_use_ptr(int clientid)
+{
+	return client_use_ptr(clientid, IS_ENABLED(CONFIG_MODULES));
+}
+
 /* Take refcount and perform ioctl_mutex lock on the given client;
  * used only for OSS sequencer
  * Unlock via snd_seq_client_ioctl_unlock() below
@@ -176,7 +190,7 @@ bool snd_seq_client_ioctl_lock(int clien
 {
 	struct snd_seq_client *client;
 
-	client = snd_seq_client_use_ptr(clientid);
+	client = client_load_and_use_ptr(clientid);
 	if (!client)
 		return false;
 	mutex_lock(&client->ioctl_mutex);
@@ -1195,7 +1209,7 @@ static int snd_seq_ioctl_running_mode(st
 	int err = 0;
 
 	/* requested client number */
-	cptr = snd_seq_client_use_ptr(info->client);
+	cptr = client_load_and_use_ptr(info->client);
 	if (cptr == NULL)
 		return -ENOENT;		/* don't change !!! */
 
@@ -1257,7 +1271,7 @@ static int snd_seq_ioctl_get_client_info
 	struct snd_seq_client *cptr;
 
 	/* requested client number */
-	cptr = snd_seq_client_use_ptr(client_info->client);
+	cptr = client_load_and_use_ptr(client_info->client);
 	if (cptr == NULL)
 		return -ENOENT;		/* don't change !!! */
 
@@ -1392,7 +1406,7 @@ static int snd_seq_ioctl_get_port_info(s
 	struct snd_seq_client *cptr;
 	struct snd_seq_client_port *port;
 
-	cptr = snd_seq_client_use_ptr(info->addr.client);
+	cptr = client_load_and_use_ptr(info->addr.client);
 	if (cptr == NULL)
 		return -ENXIO;
 
@@ -1496,10 +1510,10 @@ static int snd_seq_ioctl_subscribe_port(
 	struct snd_seq_client *receiver = NULL, *sender = NULL;
 	struct snd_seq_client_port *sport = NULL, *dport = NULL;
 
-	receiver = snd_seq_client_use_ptr(subs->dest.client);
+	receiver = client_load_and_use_ptr(subs->dest.client);
 	if (!receiver)
 		goto __end;
-	sender = snd_seq_client_use_ptr(subs->sender.client);
+	sender = client_load_and_use_ptr(subs->sender.client);
 	if (!sender)
 		goto __end;
 	sport = snd_seq_port_use_ptr(sender, subs->sender.port);
@@ -1864,7 +1878,7 @@ static int snd_seq_ioctl_get_client_pool
 	struct snd_seq_client_pool *info = arg;
 	struct snd_seq_client *cptr;
 
-	cptr = snd_seq_client_use_ptr(info->client);
+	cptr = client_load_and_use_ptr(info->client);
 	if (cptr == NULL)
 		return -ENOENT;
 	memset(info, 0, sizeof(*info));
@@ -1968,7 +1982,7 @@ static int snd_seq_ioctl_get_subscriptio
 	struct snd_seq_client_port *sport = NULL;
 
 	result = -EINVAL;
-	sender = snd_seq_client_use_ptr(subs->sender.client);
+	sender = client_load_and_use_ptr(subs->sender.client);
 	if (!sender)
 		goto __end;
 	sport = snd_seq_port_use_ptr(sender, subs->sender.port);
@@ -1999,7 +2013,7 @@ static int snd_seq_ioctl_query_subs(stru
 	struct list_head *p;
 	int i;
 
-	cptr = snd_seq_client_use_ptr(subs->root.client);
+	cptr = client_load_and_use_ptr(subs->root.client);
 	if (!cptr)
 		goto __end;
 	port = snd_seq_port_use_ptr(cptr, subs->root.port);
@@ -2066,7 +2080,7 @@ static int snd_seq_ioctl_query_next_clie
 	if (info->client < 0)
 		info->client = 0;
 	for (; info->client < SNDRV_SEQ_MAX_CLIENTS; info->client++) {
-		cptr = snd_seq_client_use_ptr(info->client);
+		cptr = client_load_and_use_ptr(info->client);
 		if (cptr)
 			break; /* found */
 	}
@@ -2089,7 +2103,7 @@ static int snd_seq_ioctl_query_next_port
 	struct snd_seq_client *cptr;
 	struct snd_seq_client_port *port = NULL;
 
-	cptr = snd_seq_client_use_ptr(info->addr.client);
+	cptr = client_load_and_use_ptr(info->addr.client);
 	if (cptr == NULL)
 		return -ENXIO;
 
@@ -2186,7 +2200,7 @@ static int snd_seq_ioctl_client_ump_info
 		size = sizeof(struct snd_ump_endpoint_info);
 	else
 		size = sizeof(struct snd_ump_block_info);
-	cptr = snd_seq_client_use_ptr(client);
+	cptr = client_load_and_use_ptr(client);
 	if (!cptr)
 		return -ENOENT;
 
@@ -2458,7 +2472,7 @@ int snd_seq_kernel_client_enqueue(int cl
 	if (check_event_type_and_length(ev))
 		return -EINVAL;
 
-	cptr = snd_seq_client_use_ptr(client);
+	cptr = client_load_and_use_ptr(client);
 	if (cptr == NULL)
 		return -EINVAL;
 	
@@ -2690,7 +2704,7 @@ void snd_seq_info_clients_read(struct sn
 
 	/* list the client table */
 	for (c = 0; c < SNDRV_SEQ_MAX_CLIENTS; c++) {
-		client = snd_seq_client_use_ptr(c);
+		client = client_load_and_use_ptr(c);
 		if (client == NULL)
 			continue;
 		if (client->type == NO_CLIENT) {


