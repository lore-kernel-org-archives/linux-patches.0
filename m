Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284432E7377;
	Thu, 28 May 2026 20:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999729; cv=none; b=LBHwUAoCiCT0xs7R3jvMTS3aP6zxQjZagiFjCDdBP518fcHBxDxZhYFxKYjeMSWWCa0a8PqnUFpB9bpqDWbRj5gFQImFoPREL0LkE+QWuqba3rQ8C794LGoX5Q6jvYKfOY58KcKITZMYBtXhCUEhkLi2MiX/BM/RJ4Lgw4QMFuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999729; c=relaxed/simple;
	bh=XL0AtoR0KuCtdIp16uDpjStivcDwGn+1co3Ivwwm9TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hags6k8OlyLBr2WjEOiIGRjCV1mYh4S6nvqPPRU2DYLKVv4u3HsTR3L36e4LIHT7bI8UxBPFt6DWw2ebicaCLHbRfWIv6zgIrCathWOsWHK1PQZqZNbvBCTXiU4UptFTKZyCMn8escxcS5JCy/G6IAstyBHZISIQb58eE6qMuU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyay6Q5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyay6Q5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879D41F000E9;
	Thu, 28 May 2026 20:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999728;
	bh=FPs5ZKMfc/QJyBOMVQYkcccXiPGF5SNqOXJbddRc1FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyay6Q5tGPXzoHBtSZHCzobEof4wVBPHuOhp8liZdYZrc2gIkmo4gIaQVGdcpf5+v
	 Ry020cEQVFJ91Q9Ld2bnzeE/1EMxDYysRjutmgAslO9pbYgJr5DC6Hka8TbXX7JAr3
	 T17gNTUEZHelp0ZB521Vlul2KrI25ZQDoxfNrLjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 153/377] batman-adv: tp_meter: fix race condition in send error reporting
Date: Thu, 28 May 2026 21:46:31 +0200
Message-ID: <20260528194642.824267178@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 71dce47f0758537fff78fddb5fb0d4632d29b29f upstream.

batadv_tp_sender_shutdown() previously used two separate variables to track
session state: sending (an atomic flag indicating whether the session was
active) and reason (a plain enum storing the stop reason). This introduced
a race window between the two writes: after sending was cleared to 0,
batadv_tp_send() could observe the stopped state and call
batadv_tp_sender_end() before reason was written, causing the wrong stop
reason to be reported to the caller.

Fix this by consolidating both variables into a single atomic send_result,
which holds 0 while the session is running and the stop reason once it
ends.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/tp_meter.c |   40 +++++++++++++++++++++++++---------------
 net/batman-adv/types.h    |   10 +++++-----
 2 files changed, 30 insertions(+), 20 deletions(-)

--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -413,11 +413,14 @@ static void batadv_tp_sender_cleanup(str
 static void batadv_tp_sender_end(struct batadv_priv *bat_priv,
 				 struct batadv_tp_vars *tp_vars)
 {
+	enum batadv_tp_meter_reason reason;
 	u32 session_cookie;
 
+	reason = atomic_read(&tp_vars->send_result);
+
 	batadv_dbg(BATADV_DBG_TP_METER, bat_priv,
 		   "Test towards %pM finished..shutting down (reason=%d)\n",
-		   tp_vars->other_end, tp_vars->reason);
+		   tp_vars->other_end, reason);
 
 	batadv_dbg(BATADV_DBG_TP_METER, bat_priv,
 		   "Last timing stats: SRTT=%ums RTTVAR=%ums RTO=%ums\n",
@@ -430,7 +433,7 @@ static void batadv_tp_sender_end(struct
 	session_cookie = batadv_tp_session_cookie(tp_vars->session,
 						  tp_vars->icmp_uid);
 
-	batadv_tp_batctl_notify(tp_vars->reason,
+	batadv_tp_batctl_notify(reason,
 				tp_vars->other_end,
 				bat_priv,
 				tp_vars->start_time,
@@ -446,10 +449,18 @@ static void batadv_tp_sender_end(struct
 static void batadv_tp_sender_shutdown(struct batadv_tp_vars *tp_vars,
 				      enum batadv_tp_meter_reason reason)
 {
-	if (atomic_xchg(&tp_vars->sending, 0) != 1)
-		return;
+	atomic_cmpxchg(&tp_vars->send_result, 0, reason);
+}
 
-	tp_vars->reason = reason;
+/**
+ * batadv_tp_sender_stopped() - check if tp session was stopped with reason
+ * @tp_vars: the private data of the current TP meter session
+ *
+ * Return: whether stop reason was found
+ */
+static bool batadv_tp_sender_stopped(struct batadv_tp_vars *tp_vars)
+{
+	return atomic_read(&tp_vars->send_result) != 0;
 }
 
 /**
@@ -479,7 +490,7 @@ static void batadv_tp_reset_sender_timer
 	/* most of the time this function is invoked while normal packet
 	 * reception...
 	 */
-	if (unlikely(atomic_read(&tp_vars->sending) == 0))
+	if (unlikely(batadv_tp_sender_stopped(tp_vars)))
 		/* timer ref will be dropped in batadv_tp_sender_cleanup */
 		return;
 
@@ -499,7 +510,7 @@ static void batadv_tp_sender_timeout(str
 	struct batadv_tp_vars *tp_vars = timer_container_of(tp_vars, t, timer);
 	struct batadv_priv *bat_priv = tp_vars->bat_priv;
 
-	if (atomic_read(&tp_vars->sending) == 0)
+	if (batadv_tp_sender_stopped(tp_vars))
 		return;
 
 	/* if the user waited long enough...shutdown the test */
@@ -661,7 +672,7 @@ static void batadv_tp_recv_ack(struct ba
 	if (unlikely(tp_vars->role != BATADV_TP_SENDER))
 		goto out;
 
-	if (unlikely(atomic_read(&tp_vars->sending) == 0))
+	if (unlikely(batadv_tp_sender_stopped(tp_vars)))
 		goto out;
 
 	/* old ACK? silently drop it.. */
@@ -827,21 +838,21 @@ static int batadv_tp_send(void *arg)
 
 	if (unlikely(tp_vars->role != BATADV_TP_SENDER)) {
 		err = BATADV_TP_REASON_DST_UNREACHABLE;
-		tp_vars->reason = err;
+		batadv_tp_sender_shutdown(tp_vars, err);
 		goto out;
 	}
 
 	orig_node = batadv_orig_hash_find(bat_priv, tp_vars->other_end);
 	if (unlikely(!orig_node)) {
 		err = BATADV_TP_REASON_DST_UNREACHABLE;
-		tp_vars->reason = err;
+		batadv_tp_sender_shutdown(tp_vars, err);
 		goto out;
 	}
 
 	primary_if = batadv_primary_if_get_selected(bat_priv);
 	if (unlikely(!primary_if)) {
 		err = BATADV_TP_REASON_DST_UNREACHABLE;
-		tp_vars->reason = err;
+		batadv_tp_sender_shutdown(tp_vars, err);
 		goto out;
 	}
 
@@ -860,7 +871,7 @@ static int batadv_tp_send(void *arg)
 	queue_delayed_work(batadv_event_workqueue, &tp_vars->finish_work,
 			   msecs_to_jiffies(tp_vars->test_length));
 
-	while (atomic_read(&tp_vars->sending) != 0) {
+	while (!batadv_tp_sender_stopped(tp_vars)) {
 		if (unlikely(!batadv_tp_avail(tp_vars, payload_len))) {
 			batadv_tp_wait_available(tp_vars, payload_len);
 			continue;
@@ -883,8 +894,7 @@ static int batadv_tp_send(void *arg)
 				   "Meter: %s() cannot send packets (%d)\n",
 				   __func__, err);
 			/* ensure nobody else tries to stop the thread now */
-			if (atomic_xchg(&tp_vars->sending, 0) == 1)
-				tp_vars->reason = err;
+			batadv_tp_sender_shutdown(tp_vars, err);
 			break;
 		}
 
@@ -1006,7 +1016,7 @@ void batadv_tp_start(struct batadv_priv
 	ether_addr_copy(tp_vars->other_end, dst);
 	kref_init(&tp_vars->refcount);
 	tp_vars->role = BATADV_TP_SENDER;
-	atomic_set(&tp_vars->sending, 1);
+	atomic_set(&tp_vars->send_result, 0);
 	memcpy(tp_vars->session, session_id, sizeof(session_id));
 	tp_vars->icmp_uid = icmp_uid;
 
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1329,15 +1329,15 @@ struct batadv_tp_vars {
 	/** @role: receiver/sender modi */
 	enum batadv_tp_meter_role role;
 
-	/** @sending: sending binary semaphore: 1 if sending, 0 is not */
-	atomic_t sending;
+	/**
+	 * @send_result: 0 when sending is ongoing and otherwise
+	 * enum batadv_tp_meter_reason
+	 */
+	atomic_t send_result;
 
 	/** @receiving: receiving binary semaphore: 1 if receiving, 0 is not */
 	atomic_t receiving;
 
-	/** @reason: reason for a stopped session */
-	enum batadv_tp_meter_reason reason;
-
 	/** @finish_work: work item for the finishing procedure */
 	struct delayed_work finish_work;
 


