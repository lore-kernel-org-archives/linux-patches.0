Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E638317163;
	Thu, 28 May 2026 20:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999804; cv=none; b=YXfvWaCfZB6ci4N+ELoE+7gTD9UpnslV0O/rcr5lHAYgg83VgfLMKRXnjbqBtGH/MpepY2T65wK15ZmeiIJ7qm+hk2CxRiWunrPt34FaySoDaHijK/vN+Kj4rYKYfLij0gWRK9UtR0QlcQLyWQ1IgVkOPdDpsdP1rDz87wKk+vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999804; c=relaxed/simple;
	bh=WVC6qBcXn5I2eTZYAihebY8O9jrpJ7R38M1NzlKiQVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQo9DHr+3lX2kuZeefxblUqdgZR8hV2GtSXGM64ibHwXGCb1IetLV5oe0YlbKqVGLRCsI3BrN/DetVG7SrvBDjzIHZ5cHzpHTVZP7Z55OIyDXj+6qbyYucq5vZyn5OxQg34wDpyhurKAziWG8si96QX8tYHWL7wUllWJl+riJMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqKWfJDa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqKWfJDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED56B1F000E9;
	Thu, 28 May 2026 20:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999803;
	bh=kQTncH24LjILz7d2GHnLbKB9JdCszy6/xgQPHva0saY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cqKWfJDa52NMuzur+iWT5H31B9Uecyo6T1by0zuRdBXZUxQa/1nYLqixkLBDEWYfX
	 6Na7vyvm63qfkapcyNSYQjuI2zNtRzoZs4VrkkrRfgUpex5EPensI5OD7CB6fJQZLK
	 u6ilaPUk5Iql2YovmOi2b4fLWxEfA8TcCy2u7Y38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 151/377] batman-adv: tp_meter: directly shut down timer on cleanup
Date: Thu, 28 May 2026 21:46:29 +0200
Message-ID: <20260528194642.765646523@linuxfoundation.org>
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

commit d5487249a81ea658717614009c8f46acc5b7101a upstream.

batadv_tp_sender_cleanup() was calling timer_delete_sync() followed by
timer_delete() to guard against the timer handler re-arming itself between
the two calls. This double-deletion hack relied on the sending status being
set to 0 to suppress re-arming.

Replace both calls with a single timer_shutdown_sync(). This function both
waits for any running timer callback to complete (like timer_delete_sync())
and permanently disarms the timer so it cannot be re-armed afterwards,
making re-arming prevention unconditional and self-documenting.

The re-arming property is also required because otherwise:

1. context 0 (batadv_tp_recv_ack()) checks in
   batadv_tp_reset_sender_timer() if sending is still 1 -> it is
2. context 1 changes in batadv_tp_sender_shutdown() sending to 0 and in
   this process forces the kthread to stop timer in
   batadv_tp_sender_cleanup()
3. context 0 continues in batadv_tp_reset_sender_timer() and rearms the
   timer -> but the reference for it is already gone

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/tp_meter.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -400,13 +400,7 @@ static void batadv_tp_sender_cleanup(str
 	batadv_tp_list_detach(tp_vars);
 
 	/* kill the timer and remove its reference */
-	timer_delete_sync(&tp_vars->timer);
-	/* the worker might have rearmed itself therefore we kill it again. Note
-	 * that if the worker should run again before invoking the following
-	 * timer_delete(), it would not re-arm itself once again because the status
-	 * is OFF now
-	 */
-	timer_delete(&tp_vars->timer);
+	timer_shutdown_sync(&tp_vars->timer);
 	batadv_tp_vars_put(tp_vars);
 }
 


