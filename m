Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5870438C437;
	Tue, 16 Jun 2026 18:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635368; cv=none; b=tBdfoaKCaTTyVg33+ayC85dnKC8WDLkE3Mjs21BRw9IAOsgwSZeTkkr6FOLYS65jnWkjRyr6RPqXiQYKnp3lSTrXtPisiMZVzhltg8olj8GBdci8RtrAQ82xJX8w81Mi82IbbyH2+tKHsavGCdCBHAZLYEjca0Wynt4rVJ8BhVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635368; c=relaxed/simple;
	bh=l+cjbS4vVcRgh0j/Hrb+LBQMdBGRrdQPoyiXtjCE1s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKrDZ0mYa6+36+2Bx+rrkad3DaD4/GZ9HZjO4B+aaGUqxA3jJGU6STK3/EXZY7y9RPhSKdZ1hdWbv2AedeOsLmGJydBMV7J0gzbxBxFLA4uLgOoaV820UZZsz+BtE5MdAJ6pCMpeJFK8ZTD9TlYD79Fj8wFNNvjVQvguF4nCAts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCZ5UK2l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCZ5UK2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEF91F000E9;
	Tue, 16 Jun 2026 18:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635367;
	bh=L7oguIJbz4GSgk6FqFuV/nlYJvpm+93tUBgfDfzbP8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCZ5UK2lbiaZ2v18qAYBGE2OWOiwYufkgVj5Oh9Vh4ujEpjkFSmauJdcCY1hYvFF+
	 eEkAvvoH5CgfAvMiJJfhHkl7r2ZWmNBd/HveWgc4zRxkOAsGC00WWF6gFLNFMHmcSQ
	 1YsJu2nQoxOgl1DczcseES5AzYnsVq4Y7+7lKe8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/342] batman-adv: tp_meter: fix race condition in send error reporting
Date: Tue, 16 Jun 2026 20:25:31 +0530
Message-ID: <20260616145049.888286838@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 40 ++++++++++++++++++++++++---------------
 net/batman-adv/types.h    | 10 +++++-----
 2 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 578da029a7b3d8..b93cb86129769c 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -402,11 +402,14 @@ static void batadv_tp_sender_cleanup(struct batadv_priv *bat_priv,
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
@@ -419,7 +422,7 @@ static void batadv_tp_sender_end(struct batadv_priv *bat_priv,
 	session_cookie = batadv_tp_session_cookie(tp_vars->session,
 						  tp_vars->icmp_uid);
 
-	batadv_tp_batctl_notify(tp_vars->reason,
+	batadv_tp_batctl_notify(reason,
 				tp_vars->other_end,
 				bat_priv,
 				tp_vars->start_time,
@@ -435,10 +438,18 @@ static void batadv_tp_sender_end(struct batadv_priv *bat_priv,
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
@@ -468,7 +479,7 @@ static void batadv_tp_reset_sender_timer(struct batadv_tp_vars *tp_vars)
 	/* most of the time this function is invoked while normal packet
 	 * reception...
 	 */
-	if (unlikely(atomic_read(&tp_vars->sending) == 0))
+	if (unlikely(batadv_tp_sender_stopped(tp_vars)))
 		/* timer ref will be dropped in batadv_tp_sender_cleanup */
 		return;
 
@@ -488,7 +499,7 @@ static void batadv_tp_sender_timeout(struct timer_list *t)
 	struct batadv_tp_vars *tp_vars = from_timer(tp_vars, t, timer);
 	struct batadv_priv *bat_priv = tp_vars->bat_priv;
 
-	if (atomic_read(&tp_vars->sending) == 0)
+	if (batadv_tp_sender_stopped(tp_vars))
 		return;
 
 	/* if the user waited long enough...shutdown the test */
@@ -650,7 +661,7 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 	if (unlikely(tp_vars->role != BATADV_TP_SENDER))
 		goto out;
 
-	if (unlikely(atomic_read(&tp_vars->sending) == 0))
+	if (unlikely(batadv_tp_sender_stopped(tp_vars)))
 		goto out;
 
 	/* old ACK? silently drop it.. */
@@ -819,21 +830,21 @@ static int batadv_tp_send(void *arg)
 
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
 
@@ -852,7 +863,7 @@ static int batadv_tp_send(void *arg)
 	queue_delayed_work(batadv_event_workqueue, &tp_vars->finish_work,
 			   msecs_to_jiffies(tp_vars->test_length));
 
-	while (atomic_read(&tp_vars->sending) != 0) {
+	while (!batadv_tp_sender_stopped(tp_vars)) {
 		if (unlikely(!batadv_tp_avail(tp_vars, payload_len))) {
 			batadv_tp_wait_available(tp_vars, payload_len);
 			continue;
@@ -875,8 +886,7 @@ static int batadv_tp_send(void *arg)
 				   "Meter: %s() cannot send packets (%d)\n",
 				   __func__, err);
 			/* ensure nobody else tries to stop the thread now */
-			if (atomic_xchg(&tp_vars->sending, 0) == 1)
-				tp_vars->reason = err;
+			batadv_tp_sender_shutdown(tp_vars, err);
 			break;
 		}
 
@@ -997,7 +1007,7 @@ void batadv_tp_start(struct batadv_priv *bat_priv, const u8 *dst,
 	ether_addr_copy(tp_vars->other_end, dst);
 	kref_init(&tp_vars->refcount);
 	tp_vars->role = BATADV_TP_SENDER;
-	atomic_set(&tp_vars->sending, 1);
+	atomic_set(&tp_vars->send_result, 0);
 	memcpy(tp_vars->session, session_id, sizeof(session_id));
 	tp_vars->icmp_uid = icmp_uid;
 
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 288fe330946fb4..aee90f613e13c5 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1407,11 +1407,11 @@ struct batadv_tp_vars {
 	/** @role: receiver/sender modi */
 	enum batadv_tp_meter_role role;
 
-	/** @sending: sending binary semaphore: 1 if sending, 0 is not */
-	atomic_t sending;
-
-	/** @reason: reason for a stopped session */
-	enum batadv_tp_meter_reason reason;
+	/**
+	 * @send_result: 0 when sending is ongoing and otherwise
+	 * enum batadv_tp_meter_reason
+	 */
+	atomic_t send_result;
 
 	/** @finish_work: work item for the finishing procedure */
 	struct delayed_work finish_work;
-- 
2.53.0



