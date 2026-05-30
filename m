Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2749F3B388B;
	Sat, 30 May 2026 18:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165871; cv=none; b=Q2krK2Yf6+JwYcJa8ZECiDHcv7BYxVt3Zw+TF/ZNPjzohbq8So2xmPRr3Q4BDZPEYocd7ng94gTnlwNDjWe/ll3x9/HAW/PnPzNG5TeK45kBzKU1fuGUd/5cp8pSVg7u5xKV5pIKpE4d2Se+mw582LD0KZ893j7/2uxXwPL7/FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165871; c=relaxed/simple;
	bh=nRZMjATo5oI2hpjm9h1AicwWL48xG+PM3bJNFMQpyHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FX8vkYc2Wfi+Ft93ypjy0Abh72a9DqFds07vnQMBAjMIlc9onJWwqqfSgsUWVM93A7HmmZXn3JtnNHGnkO747jFW8olRKsP3tbr9vaqNDXNBqQOCWOfMbCGRfJ2ZVY5PYvT+TNeQo9dhCwINcsCnSyRnvw0T2pWe9oZTv8Z5QuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egRfaMf4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egRfaMf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD601F00893;
	Sat, 30 May 2026 18:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165869;
	bh=H4qk0q+xHm6440fowFPJwPdhn09W0ocw0ZrPAEeQa3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egRfaMf4GGa5B2HFqKt7fAUn/cJjJvob1qYv6LwMyXGycgUpTziqdcAOGZ4CWaXRf
	 zEHa4yww9jrZ5ZYcF9akapQuVkJuS3GLYodRBHEx1gcykDe8MeCkAOLsez9btOPa60
	 zczHCXvR+mGM4r3b4rprTg44MmafNjwj7P+2RBBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 5.10 205/589] ipmi: Add limits to event and receive message requests
Date: Sat, 30 May 2026 18:01:26 +0200
Message-ID: <20260530160230.332964347@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

commit c4cca236968683eb0d59abfb12d5c7e4d8514227 upstream.

The driver would just fetch events and receive messages until the
BMC said it was done.  To avoid issues with BMCs that never say they are
done, add a limit of 10 fetches at a time.

In addition, an si interface has an attn state it can return from the
hardware which is supposed to cause a flag fetch to see if the driver
needs to fetch events or message or a few other things.  If the attn
bit gets stuck, it's a similar problem.  So allow messages in between
flag fetches so the driver itself doesn't get stuck.

This is a more general fix than the previous fix for the specific bad
BMC, but should fix the more general issue of a BMC that won't stop
saying it has data.

This has been there from the beginning of the driver.  It's not a bug
per-se, but it is accounting for bugs in BMCs.

Reported-by: Matt Fleming <mfleming@cloudflare.com>
Closes: https://lore.kernel.org/lkml/20260415115930.3428942-1-matt@readmodwrite.com/
Fixes: <1da177e4c3f4> ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |   54 +++++++++++++++++++++++++++++++--------
 drivers/char/ipmi/ipmi_ssif.c    |   23 +++++++++++++++-
 2 files changed, 64 insertions(+), 13 deletions(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -161,6 +161,10 @@ struct smi_info {
 			     OEM2_DATA_AVAIL)
 	unsigned char       msg_flags;
 
+	/* When requesting events and messages, don't do it forever. */
+	unsigned int        num_requests_in_a_row;
+	bool		    last_was_flag_fetch;
+
 	/* Does the BMC have an event buffer? */
 	bool		    has_event_buffer;
 
@@ -392,7 +396,10 @@ static void start_getting_msg_queue(stru
 
 	start_new_msg(smi_info, smi_info->curr_msg->data,
 		      smi_info->curr_msg->data_size);
-	smi_info->si_state = SI_GETTING_MESSAGES;
+	if (smi_info->si_state != SI_GETTING_MESSAGES) {
+		smi_info->num_requests_in_a_row = 0;
+		smi_info->si_state = SI_GETTING_MESSAGES;
+	}
 }
 
 static void start_getting_events(struct smi_info *smi_info)
@@ -403,7 +410,10 @@ static void start_getting_events(struct
 
 	start_new_msg(smi_info, smi_info->curr_msg->data,
 		      smi_info->curr_msg->data_size);
-	smi_info->si_state = SI_GETTING_EVENTS;
+	if (smi_info->si_state != SI_GETTING_EVENTS) {
+		smi_info->num_requests_in_a_row = 0;
+		smi_info->si_state = SI_GETTING_EVENTS;
+	}
 }
 
 /*
@@ -577,6 +587,7 @@ static void handle_transaction_done(stru
 			smi_info->si_state = SI_NORMAL;
 		} else {
 			smi_info->msg_flags = msg[3];
+			smi_info->last_was_flag_fetch = true;
 			handle_flags(smi_info);
 		}
 		break;
@@ -622,6 +633,11 @@ static void handle_transaction_done(stru
 		} else {
 			smi_inc_stat(smi_info, events);
 
+			smi_info->num_requests_in_a_row++;
+			if (smi_info->num_requests_in_a_row > 10)
+				/* Stop if we do this too many times. */
+				smi_info->msg_flags &= ~EVENT_MSG_BUFFER_FULL;
+
 			/*
 			 * Do this before we deliver the message
 			 * because delivering the message releases the
@@ -660,6 +676,11 @@ static void handle_transaction_done(stru
 		} else {
 			smi_inc_stat(smi_info, incoming_messages);
 
+			smi_info->num_requests_in_a_row++;
+			if (smi_info->num_requests_in_a_row > 10)
+				/* Stop if we do this too many times. */
+				smi_info->msg_flags &= ~RECEIVE_MSG_AVAIL;
+
 			/*
 			 * Do this before we deliver the message
 			 * because delivering the message releases the
@@ -788,6 +809,26 @@ restart:
 	}
 
 	/*
+	 * If we are currently idle, or if the last thing that was
+	 * done was a flag fetch and there is a message pending, try
+	 * to start the next message.
+	 *
+	 * We do the waiting message check to avoid a stuck flag
+	 * completely wedging the driver.  Let a message through
+	 * in between flag operations if that happens.
+	 */
+	if (si_sm_result == SI_SM_IDLE ||
+	    (si_sm_result == SI_SM_ATTN && smi_info->waiting_msg &&
+	     smi_info->last_was_flag_fetch)) {
+		smi_info->last_was_flag_fetch = false;
+		smi_inc_stat(smi_info, idles);
+
+		si_sm_result = start_next_msg(smi_info);
+		if (si_sm_result != SI_SM_IDLE)
+			goto restart;
+	}
+
+	/*
 	 * We prefer handling attn over new messages.  But don't do
 	 * this if there is not yet an upper layer to handle anything.
 	 */
@@ -820,15 +861,6 @@ restart:
 		}
 	}
 
-	/* If we are currently idle, try to start the next message. */
-	if (si_sm_result == SI_SM_IDLE) {
-		smi_inc_stat(smi_info, idles);
-
-		si_sm_result = start_next_msg(smi_info);
-		if (si_sm_result != SI_SM_IDLE)
-			goto restart;
-	}
-
 	if ((si_sm_result == SI_SM_IDLE)
 	    && (atomic_read(&smi_info->req_events))) {
 		/*
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -225,6 +225,9 @@ struct ssif_info {
 	bool		    has_event_buffer;
 	bool		    supports_alert;
 
+	/* When requesting events and messages, don't do it forever. */
+	unsigned int        num_requests_in_a_row;
+
 	/*
 	 * Used to tell what we should do with alerts.  If we are
 	 * waiting on a response, read the data immediately.
@@ -419,7 +422,10 @@ static void start_event_fetch(struct ssi
 	}
 
 	ssif_info->curr_msg = msg;
-	ssif_info->ssif_state = SSIF_GETTING_EVENTS;
+	if (ssif_info->ssif_state != SSIF_GETTING_EVENTS) {
+		ssif_info->num_requests_in_a_row = 0;
+		ssif_info->ssif_state = SSIF_GETTING_EVENTS;
+	}
 	ipmi_ssif_unlock_cond(ssif_info, flags);
 
 	msg->data[0] = (IPMI_NETFN_APP_REQUEST << 2);
@@ -442,7 +448,10 @@ static void start_recv_msg_fetch(struct
 	}
 
 	ssif_info->curr_msg = msg;
-	ssif_info->ssif_state = SSIF_GETTING_MESSAGES;
+	if (ssif_info->ssif_state != SSIF_GETTING_MESSAGES) {
+		ssif_info->num_requests_in_a_row = 0;
+		ssif_info->ssif_state = SSIF_GETTING_MESSAGES;
+	}
 	ipmi_ssif_unlock_cond(ssif_info, flags);
 
 	msg->data[0] = (IPMI_NETFN_APP_REQUEST << 2);
@@ -851,6 +860,11 @@ static void msg_done_handler(struct ssif
 			ssif_info->msg_flags &= ~EVENT_MSG_BUFFER_FULL;
 			handle_flags(ssif_info, flags);
 		} else {
+			ssif_info->num_requests_in_a_row++;
+			if (ssif_info->num_requests_in_a_row > 10)
+				/* Stop if we do this too many times. */
+				ssif_info->msg_flags &= ~EVENT_MSG_BUFFER_FULL;
+
 			handle_flags(ssif_info, flags);
 			ssif_inc_stat(ssif_info, events);
 			deliver_recv_msg(ssif_info, msg);
@@ -884,6 +898,11 @@ static void msg_done_handler(struct ssif
 			ssif_info->msg_flags &= ~RECEIVE_MSG_AVAIL;
 			handle_flags(ssif_info, flags);
 		} else {
+			ssif_info->num_requests_in_a_row++;
+			if (ssif_info->num_requests_in_a_row > 10)
+				/* Stop if we do this too many times. */
+				ssif_info->msg_flags &= ~RECEIVE_MSG_AVAIL;
+
 			ssif_inc_stat(ssif_info, incoming_messages);
 			handle_flags(ssif_info, flags);
 			deliver_recv_msg(ssif_info, msg);


