Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E406A334C3B;
	Wed, 23 Sep 2026 14:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173293; cv=none; b=e6ggjtMsLHbwOk4F4xGYs+JTP2ulzOQif82Mbg4sVGPpVrqyUmTEN76YTp/f/X3u5AfdlXQ5MaE4tWa65NthpkAWIyKFXzI7O5LA5mYVOqOteKujdCDAAGhDlmu3/X1t5YyC2Wmj3KAJTwYYCzdVpMh+cH6y3OFv7m2v9tRJuV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173293; c=relaxed/simple;
	bh=wRaOBCX6i3Ppmn9/X3R8HYwPzYCoFkZI5GpdDp6MGt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBpszYzW7qMCMx4MGDCwezmAewbTjykxk+eZEK6l1DAJtmkHB8BUY+T5kFXdcM5S2vq/XAmPoskGwO43Z8GqIsL7oCJQixsQv0OfgQm/Im1pelTjS5dQVcYHowQzKZGNXjWInD1pcj6VNgXB9mcLrc8x1zk+cyK6eskZnfGdFEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5/OY1wa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5/OY1wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9581F000FF;
	Wed, 23 Sep 2026 14:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173291;
	bh=oy8TiWaAwAgeFy1OoGuCg/Tu8WqD3N3U3GcFPNVfw/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5/OY1wa7HvYo0FIp7HOtyTKvrPCdX8BJiLHt1iC+/5n1BzB0buhN0SqkCpLNbYhn
	 sMqVrI8Cz8Vvp+UO/c6E3svXDZGrc2eC6H0t3Y9jLwklBLhM/XEBR25Xy9/1329s4+
	 b42+5nHgJGoTec4qvJFuLPwFGAgnejO0alBGLxks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 184/438] drop_monitor: use timer_shutdown_sync() to prevent timer rearming during teardown
Date: Wed, 23 Sep 2026 16:03:25 +0200
Message-ID: <20260923140649.534427435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c391a40f71886b28c082b47270f0e856fa3e1150 ]

In drop_monitor teardown paths (net_dm_trace_off_set(),
net_dm_hw_monitor_stop(), and error unwind paths in net_dm_trace_on_set()
and net_dm_hw_monitor_start()), per-CPU timers are stopped using
timer_delete_sync() followed by cancel_work_sync().

However, there is a circular dependency between send_timer and
dm_alert_work:
1) sched_send_work() (timer callback) schedules dm_alert_work.
2) send_dm_alert() / net_dm_hw_summary_work() calls reset_per_cpu_data()
   or net_dm_hw_reset_per_cpu_data().
3) If memory allocation fails under memory pressure in the reset
   function, it re-arms the timer via mod_timer(&data->send_timer, ...).

If dm_alert_work is running concurrently while timer_delete_sync()
executes on another CPU, an allocation failure in the worker will
re-arm the timer after timer_delete_sync() has already returned.
Once cancel_work_sync() completes and module_put() is called, the timer
remains active in the timer wheel. If the module is then unloaded, the
timer will fire and execute sched_send_work() in freed memory,
triggering a kernel panic / use-after-free.

Switch from timer_delete_sync() to timer_shutdown_sync(). This guarantees
that any in-flight timer handler has finished and prevents subsequent
re-arming attempts from running workers from succeeding. When monitoring
is restarted later, timer_setup() is invoked, which cleanly
re-initializes the timer.

Fixes: 9398e9c0b1d4 ("drop_monitor: Perform cleanup upon probe registration failure")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260910204612.3762015-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/drop_monitor.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 018d19e3a71de..873155ca72432 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1083,7 +1083,7 @@ static int net_dm_hw_monitor_start(struct netlink_ext_ack *extack)
 		struct per_cpu_dm_data *hw_data = &per_cpu(dm_hw_cpu_data, cpu);
 		struct sk_buff *skb;
 
-		timer_delete_sync(&hw_data->send_timer);
+		timer_shutdown_sync(&hw_data->send_timer);
 		cancel_work_sync(&hw_data->dm_alert_work);
 		while ((skb = __skb_dequeue(&hw_data->drop_queue))) {
 			struct devlink_trap_metadata *hw_metadata;
@@ -1117,7 +1117,7 @@ static void net_dm_hw_monitor_stop(struct netlink_ext_ack *extack)
 		struct per_cpu_dm_data *hw_data = &per_cpu(dm_hw_cpu_data, cpu);
 		struct sk_buff *skb;
 
-		timer_delete_sync(&hw_data->send_timer);
+		timer_shutdown_sync(&hw_data->send_timer);
 		cancel_work_sync(&hw_data->dm_alert_work);
 		while ((skb = __skb_dequeue(&hw_data->drop_queue))) {
 			struct devlink_trap_metadata *hw_metadata;
@@ -1179,7 +1179,7 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
 		struct sk_buff *skb;
 
-		timer_delete_sync(&data->send_timer);
+		timer_shutdown_sync(&data->send_timer);
 		cancel_work_sync(&data->dm_alert_work);
 		while ((skb = __skb_dequeue(&data->drop_queue)))
 			consume_skb(skb);
@@ -1207,7 +1207,7 @@ static void net_dm_trace_off_set(void)
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
 		struct sk_buff *skb;
 
-		timer_delete_sync(&data->send_timer);
+		timer_shutdown_sync(&data->send_timer);
 		cancel_work_sync(&data->dm_alert_work);
 		while ((skb = __skb_dequeue(&data->drop_queue)))
 			consume_skb(skb);
-- 
2.53.0



