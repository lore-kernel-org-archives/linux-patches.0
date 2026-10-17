Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9586C34C98C;
	Sat, 17 Oct 2026 17:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259272; cv=none; b=BAm+s3OMP8kTwN4Y1j8xI0cmdvkVEvghkGn1dn98zHRGgt+60WziF4wjYhE9vkIArLQ2Al1TrKqCCrbupmtXyNXycbZUgLwaDzwYhhiDuc78M60c65uUNBJO6Sz+5KlSNybX/j8RBrnwVIOe3lNuNOW3aW43gn3pvLSmEHYKf4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259272; c=relaxed/simple;
	bh=Mq5gMQfRg/Mi39ktnlokECv63Uxg5EZTTxYqwBnRjeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5ArdVbd90QxGlA/gaj1KoBjM0r+kFcUEvSunCYc9V5V2FsnruhaO8H25s3y/WMs4OaX/yF6EkRi31rclVwtLM0ZHGIVJmUEelvqKEVjTItAqC25h0K0Mj9BvGErVxrZ0gX+V87/Do2I3OdKFbBKM1cQbL4+ag9h8O2QGvcSQxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEicIPqv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEicIPqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE4B1F000C4;
	Sat, 17 Oct 2026 17:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259271;
	bh=uRO25qogchOvxysu4aFDtilPLDALeRZMYGH3TZoEOQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEicIPqvdfFpvML/WkjkMYQqn8CAQQV5nLl8Iq1W8L1+6oYIKDNlWjhzu2boVL3Lj
	 XEuojz6xOHXbMeMUa+xQKPXSpdBoaI+1hMxDW0YJ6bGU1Qmfvbn+/0JGym8i9J6PnN
	 eikPLfRMLQV70C5dh7Eg77e/+A5pBhGVc6V9RE/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1159/1674] ALSA: seq: Drop superfluous filter argument of get_event_dest_client()
Date: Sat, 17 Oct 2026 17:57:11 +0200
Message-ID: <20261017160500.900660498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit 3531df81dca2f42accbc11821c5fa28e4104efd5 ]

All callers of get_event_dest_clienter() pass 0 to the filter
argument, and it means that the check there is utterly redundant.

Drop the superfluous filter argument and its check as a code cleanup.

Link: https://patch.msgid.link/20240819084757.11902-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: efc86691e4d8 ("ALSA: seq: Fix kernel heap address leak in bounce_error_event()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 30dc8310bfa84..7f117d4a369d0 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -70,7 +70,7 @@ static int bounce_error_event(struct snd_seq_client *client,
 			      int err, int atomic, int hop);
 static int snd_seq_deliver_single_event(struct snd_seq_client *client,
 					struct snd_seq_event *event,
-					int filter, int atomic, int hop);
+					int atomic, int hop);
 
 #if IS_ENABLED(CONFIG_SND_SEQ_UMP)
 static void free_ump_info(struct snd_seq_client *client);
@@ -539,10 +539,8 @@ static int check_port_perm(struct snd_seq_client_port *port, unsigned int flags)
 
 /*
  * check if the destination client is available, and return the pointer
- * if filter is non-zero, client filter bitmap is tested.
  */
-static struct snd_seq_client *get_event_dest_client(struct snd_seq_event *event,
-						    int filter)
+static struct snd_seq_client *get_event_dest_client(struct snd_seq_event *event)
 {
 	struct snd_seq_client *dest;
 
@@ -557,8 +555,6 @@ static struct snd_seq_client *get_event_dest_client(struct snd_seq_event *event,
 	if ((dest->filter & SNDRV_SEQ_FILTER_USE_EVENT) &&
 	    ! test_bit(event->type, dest->event_filter))
 		goto __not_avail;
-	if (filter && !(dest->filter & filter))
-		goto __not_avail;
 
 	return dest; /* ok - accessible */
 __not_avail:
@@ -602,7 +598,7 @@ static int bounce_error_event(struct snd_seq_client *client,
 	bounce_ev.data.quote.origin = event->dest;
 	bounce_ev.data.quote.event = event;
 	bounce_ev.data.quote.value = -err; /* use positive value */
-	result = snd_seq_deliver_single_event(NULL, &bounce_ev, 0, atomic, hop + 1);
+	result = snd_seq_deliver_single_event(NULL, &bounce_ev, atomic, hop + 1);
 	if (result < 0) {
 		client->event_lost++;
 		return result;
@@ -669,7 +665,7 @@ int __snd_seq_deliver_single_event(struct snd_seq_client *dest,
  */
 static int snd_seq_deliver_single_event(struct snd_seq_client *client,
 					struct snd_seq_event *event,
-					int filter, int atomic, int hop)
+					int atomic, int hop)
 {
 	struct snd_seq_client *dest = NULL;
 	struct snd_seq_client_port *dest_port = NULL;
@@ -678,7 +674,7 @@ static int snd_seq_deliver_single_event(struct snd_seq_client *client,
 
 	direct = snd_seq_ev_is_direct(event);
 
-	dest = get_event_dest_client(event, filter);
+	dest = get_event_dest_client(event);
 	if (dest == NULL)
 		goto __skip;
 	dest_port = snd_seq_port_use_ptr(dest, event->dest.port);
@@ -770,8 +766,7 @@ static int __deliver_to_subscribers(struct snd_seq_client *client,
 			/* convert time according to flag with subscription */
 			update_timestamp_of_queue(event, subs->info.queue,
 						  subs->info.flags & SNDRV_SEQ_PORT_SUBS_TIME_REAL);
-		err = snd_seq_deliver_single_event(client, event,
-						   0, atomic, hop);
+		err = snd_seq_deliver_single_event(client, event, atomic, hop);
 		if (err < 0) {
 			/* save first error that occurs and continue */
 			if (!result)
@@ -852,7 +847,7 @@ static int snd_seq_deliver_event(struct snd_seq_client *client, struct snd_seq_e
 	    event->dest.client == SNDRV_SEQ_ADDRESS_SUBSCRIBERS)
 		result = deliver_to_subscribers(client, event, atomic, hop);
 	else
-		result = snd_seq_deliver_single_event(client, event, 0, atomic, hop);
+		result = snd_seq_deliver_single_event(client, event, atomic, hop);
 
 	return result;
 }
-- 
2.53.0



