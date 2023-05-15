Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079AFFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600A1C433D2;
	Mon, 15 May 2023 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169104;
	bh=HfDodf6FnSpmApYuf+l6inHqkXmo66v1BdyJQKhJGyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vp3TuYu3tlhkCbAuL8SXvW+ap3JbLk8uC+O4nnrdjnnao1PS+aRwutNKPB4m6I1D2
	 0BOGOfAN5KVYlFhFTZeYJrlPRJLrnVGscGhnUlP9avyzINLQfQ/lkA3m6wvvbPWu5g
	 U6oYV95GCzDO6FS5AMLasEnkxuAuroeQ9jnLqIjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <cminyard@mvista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 143/191] ipmi_ssif: Rename idle state and check
Date: Mon, 15 May 2023 18:26:20 +0200
Message-Id: <20230515161712.599961299@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit 8230831c43a328c2be6d28c65d3f77e14c59986b ]

Rename the SSIF_IDLE() to IS_SSIF_IDLE(), since that is more clear, and
rename SSIF_NORMAL to SSIF_IDLE, since that's more accurate.

Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Stable-dep-of: 6d2555cde291 ("ipmi: fix SSIF not responding under certain cond.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 46 +++++++++++++++++------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index e760501e50b20..566be60fa1377 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -95,7 +95,7 @@
 #define SSIF_WATCH_WATCHDOG_TIMEOUT	msecs_to_jiffies(250)
 
 enum ssif_intf_state {
-	SSIF_NORMAL,
+	SSIF_IDLE,
 	SSIF_GETTING_FLAGS,
 	SSIF_GETTING_EVENTS,
 	SSIF_CLEARING_FLAGS,
@@ -103,8 +103,8 @@ enum ssif_intf_state {
 	/* FIXME - add watchdog stuff. */
 };
 
-#define SSIF_IDLE(ssif)	 ((ssif)->ssif_state == SSIF_NORMAL \
-			  && (ssif)->curr_msg == NULL)
+#define IS_SSIF_IDLE(ssif) ((ssif)->ssif_state == SSIF_IDLE \
+			    && (ssif)->curr_msg == NULL)
 
 /*
  * Indexes into stats[] in ssif_info below.
@@ -349,9 +349,9 @@ static void return_hosed_msg(struct ssif_info *ssif_info,
 
 /*
  * Must be called with the message lock held.  This will release the
- * message lock.  Note that the caller will check SSIF_IDLE and start a
- * new operation, so there is no need to check for new messages to
- * start in here.
+ * message lock.  Note that the caller will check IS_SSIF_IDLE and
+ * start a new operation, so there is no need to check for new
+ * messages to start in here.
  */
 static void start_clear_flags(struct ssif_info *ssif_info, unsigned long *flags)
 {
@@ -368,7 +368,7 @@ static void start_clear_flags(struct ssif_info *ssif_info, unsigned long *flags)
 
 	if (start_send(ssif_info, msg, 3) != 0) {
 		/* Error, just go to normal state. */
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 	}
 }
 
@@ -383,7 +383,7 @@ static void start_flag_fetch(struct ssif_info *ssif_info, unsigned long *flags)
 	mb[0] = (IPMI_NETFN_APP_REQUEST << 2);
 	mb[1] = IPMI_GET_MSG_FLAGS_CMD;
 	if (start_send(ssif_info, mb, 2) != 0)
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 }
 
 static void check_start_send(struct ssif_info *ssif_info, unsigned long *flags,
@@ -394,7 +394,7 @@ static void check_start_send(struct ssif_info *ssif_info, unsigned long *flags,
 
 		flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
 		ssif_info->curr_msg = NULL;
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		ipmi_free_smi_msg(msg);
 	}
@@ -408,7 +408,7 @@ static void start_event_fetch(struct ssif_info *ssif_info, unsigned long *flags)
 
 	msg = ipmi_alloc_smi_msg();
 	if (!msg) {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -431,7 +431,7 @@ static void start_recv_msg_fetch(struct ssif_info *ssif_info,
 
 	msg = ipmi_alloc_smi_msg();
 	if (!msg) {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -449,9 +449,9 @@ static void start_recv_msg_fetch(struct ssif_info *ssif_info,
 
 /*
  * Must be called with the message lock held.  This will release the
- * message lock.  Note that the caller will check SSIF_IDLE and start a
- * new operation, so there is no need to check for new messages to
- * start in here.
+ * message lock.  Note that the caller will check IS_SSIF_IDLE and
+ * start a new operation, so there is no need to check for new
+ * messages to start in here.
  */
 static void handle_flags(struct ssif_info *ssif_info, unsigned long *flags)
 {
@@ -467,7 +467,7 @@ static void handle_flags(struct ssif_info *ssif_info, unsigned long *flags)
 		/* Events available. */
 		start_event_fetch(ssif_info, flags);
 	else {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 	}
 }
@@ -579,7 +579,7 @@ static void watch_timeout(struct timer_list *t)
 	if (ssif_info->watch_timeout) {
 		mod_timer(&ssif_info->watch_timer,
 			  jiffies + ssif_info->watch_timeout);
-		if (SSIF_IDLE(ssif_info)) {
+		if (IS_SSIF_IDLE(ssif_info)) {
 			start_flag_fetch(ssif_info, flags); /* Releases lock */
 			return;
 		}
@@ -776,7 +776,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 	}
 
 	switch (ssif_info->ssif_state) {
-	case SSIF_NORMAL:
+	case SSIF_IDLE:
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		if (!msg)
 			break;
@@ -794,7 +794,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			 * Error fetching flags, or invalid length,
 			 * just give up for now.
 			 */
-			ssif_info->ssif_state = SSIF_NORMAL;
+			ssif_info->ssif_state = SSIF_IDLE;
 			ipmi_ssif_unlock_cond(ssif_info, flags);
 			pr_warn(PFX "Error getting flags: %d %d, %x\n",
 			       result, len, (len >= 3) ? data[2] : 0);
@@ -825,7 +825,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			pr_warn(PFX "Invalid response clearing flags: %x %x\n",
 				data[0], data[1]);
 		}
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		break;
 
@@ -901,7 +901,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 	}
 
 	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
-	if (SSIF_IDLE(ssif_info) && !ssif_info->stopping) {
+	if (IS_SSIF_IDLE(ssif_info) && !ssif_info->stopping) {
 		if (ssif_info->req_events)
 			start_event_fetch(ssif_info, flags);
 		else if (ssif_info->req_flags)
@@ -1070,7 +1070,7 @@ static void start_next_msg(struct ssif_info *ssif_info, unsigned long *flags)
 	unsigned long oflags;
 
  restart:
-	if (!SSIF_IDLE(ssif_info)) {
+	if (!IS_SSIF_IDLE(ssif_info)) {
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -1292,7 +1292,7 @@ static void shutdown_ssif(void *send_info)
 	dev_set_drvdata(&ssif_info->client->dev, NULL);
 
 	/* make sure the driver is not looking for flags any more. */
-	while (ssif_info->ssif_state != SSIF_NORMAL)
+	while (ssif_info->ssif_state != SSIF_IDLE)
 		schedule_timeout(1);
 
 	ssif_info->stopping = true;
@@ -1674,7 +1674,7 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	spin_lock_init(&ssif_info->lock);
-	ssif_info->ssif_state = SSIF_NORMAL;
+	ssif_info->ssif_state = SSIF_IDLE;
 	timer_setup(&ssif_info->retry_timer, retry_timeout, 0);
 	timer_setup(&ssif_info->watch_timer, watch_timeout, 0);
 
-- 
2.39.2



