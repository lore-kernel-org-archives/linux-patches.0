Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA518FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D759C433D2;
	Mon, 15 May 2023 16:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169098;
	bh=geAYbqJTdw9vQ1ipsgI6z4N/ERJkcvpD0dtA64i853Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEvdNavUUBD4dWgGjX84Se9xgk5476CXbNi/50iw9a7BGDVpx2NTheqSZrM6gPACX
	 cgSc9HB2I4V5HT1XE3rpPDFr3klRt6v2vkQbf+YZl6ugOdKDYroeLSH1q6yNTP10g7
	 PISp17V4HBvIEjJ68TzPbSk8k1LJHPArppoDBH9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamlakant Patel <Kamlakant.Patel@cavium.com>,
	Corey Minyard <cminyard@mvista.com>,
	Kamlakant Patel <kamlakant.patel@cavium.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 141/191] ipmi: Fix SSIF flag requests
Date: Mon, 15 May 2023 18:26:18 +0200
Message-Id: <20230515161712.516789141@linuxfoundation.org>
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

[ Upstream commit a1466ec5b671651b848df17fc9233ecbb7d35f9f ]

Commit 89986496de141 ("ipmi: Turn off all activity on an idle ipmi
interface") modified the IPMI code to only request events when the
driver had somethine waiting for events.  The SSIF code, however,
was using the event fetch request to also fetch the flags.

Add a timer and the proper handling for the upper layer telling
whether flags fetches are required.

Reported-by: Kamlakant Patel <Kamlakant.Patel@cavium.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Tested-by: Kamlakant Patel <kamlakant.patel@cavium.com>
Stable-dep-of: 6d2555cde291 ("ipmi: fix SSIF not responding under certain cond.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 64 ++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 12 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index fd1a487443f02..469da2290c2a0 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -88,6 +88,12 @@
 #define SSIF_MSG_JIFFIES	((SSIF_MSG_USEC * 1000) / TICK_NSEC)
 #define SSIF_MSG_PART_JIFFIES	((SSIF_MSG_PART_USEC * 1000) / TICK_NSEC)
 
+/*
+ * Timeout for the watch, only used for get flag timer.
+ */
+#define SSIF_WATCH_TIMEOUT_MSEC	   100
+#define SSIF_WATCH_TIMEOUT_JIFFIES msecs_to_jiffies(SSIF_WATCH_TIMEOUT_MSEC)
+
 enum ssif_intf_state {
 	SSIF_NORMAL,
 	SSIF_GETTING_FLAGS,
@@ -268,6 +274,9 @@ struct ssif_info {
 	struct timer_list retry_timer;
 	int retries_left;
 
+	bool need_watch;		/* Need to look for flags? */
+	struct timer_list watch_timer;	/* Flag fetch timer. */
+
 	/* Info from SSIF cmd */
 	unsigned char max_xmit_msg_size;
 	unsigned char max_recv_msg_size;
@@ -558,6 +567,26 @@ static void retry_timeout(struct timer_list *t)
 		start_get(ssif_info);
 }
 
+static void watch_timeout(struct timer_list *t)
+{
+	struct ssif_info *ssif_info = from_timer(ssif_info, t, watch_timer);
+	unsigned long oflags, *flags;
+
+	if (ssif_info->stopping)
+		return;
+
+	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
+	if (ssif_info->need_watch) {
+		mod_timer(&ssif_info->watch_timer,
+			  jiffies + SSIF_WATCH_TIMEOUT_JIFFIES);
+		if (SSIF_IDLE(ssif_info)) {
+			start_flag_fetch(ssif_info, flags); /* Releases lock */
+			return;
+		}
+		ssif_info->req_flags = true;
+	}
+	ipmi_ssif_unlock_cond(ssif_info, flags);
+}
 
 static void ssif_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		       unsigned int data)
@@ -1103,8 +1132,7 @@ static int get_smi_info(void *send_info, struct ipmi_smi_info *data)
 }
 
 /*
- * Instead of having our own timer to periodically check the message
- * flags, we let the message handler drive us.
+ * Upper layer wants us to request events.
  */
 static void request_events(void *send_info)
 {
@@ -1115,18 +1143,27 @@ static void request_events(void *send_info)
 		return;
 
 	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
-	/*
-	 * Request flags first, not events, because the lower layer
-	 * doesn't have a way to send an attention.  But make sure
-	 * event checking still happens.
-	 */
 	ssif_info->req_events = true;
-	if (SSIF_IDLE(ssif_info))
-		start_flag_fetch(ssif_info, flags);
-	else {
-		ssif_info->req_flags = true;
-		ipmi_ssif_unlock_cond(ssif_info, flags);
+	ipmi_ssif_unlock_cond(ssif_info, flags);
+}
+
+/*
+ * Upper layer is changing the flag saying whether we need to request
+ * flags periodically or not.
+ */
+static void ssif_set_need_watch(void *send_info, bool enable)
+{
+	struct ssif_info *ssif_info = (struct ssif_info *) send_info;
+	unsigned long oflags, *flags;
+
+	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
+	if (enable != ssif_info->need_watch) {
+		ssif_info->need_watch = enable;
+		if (ssif_info->need_watch)
+			mod_timer(&ssif_info->watch_timer,
+				  jiffies + SSIF_WATCH_TIMEOUT_JIFFIES);
 	}
+	ipmi_ssif_unlock_cond(ssif_info, flags);
 }
 
 static int ssif_start_processing(void            *send_info,
@@ -1253,6 +1290,7 @@ static void shutdown_ssif(void *send_info)
 		schedule_timeout(1);
 
 	ssif_info->stopping = true;
+	del_timer_sync(&ssif_info->watch_timer);
 	del_timer_sync(&ssif_info->retry_timer);
 	if (ssif_info->thread) {
 		complete(&ssif_info->wake_thread);
@@ -1632,6 +1670,7 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	spin_lock_init(&ssif_info->lock);
 	ssif_info->ssif_state = SSIF_NORMAL;
 	timer_setup(&ssif_info->retry_timer, retry_timeout, 0);
+	timer_setup(&ssif_info->watch_timer, watch_timeout, 0);
 
 	for (i = 0; i < SSIF_NUM_STATS; i++)
 		atomic_set(&ssif_info->stats[i], 0);
@@ -1645,6 +1684,7 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	ssif_info->handlers.get_smi_info = get_smi_info;
 	ssif_info->handlers.sender = sender;
 	ssif_info->handlers.request_events = request_events;
+	ssif_info->handlers.set_need_watch = ssif_set_need_watch;
 
 	{
 		unsigned int thread_num;
-- 
2.39.2



