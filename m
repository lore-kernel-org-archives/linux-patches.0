Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA0A440A16;
	Wed, 23 Sep 2026 14:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174571; cv=none; b=HdjWoOKmYMZBg22V2v4r+YekkIdM4Z+osk5c8fsWlk1as89Ip3V4VW0YYFPUdWL0hbEvn0Ne3zP0BChdkrH8O+PHLwEekKP2svWF7quKTmcU1rutewJkv4Dr27JRIpRomKQvtKIy8n21yxuNBNI0rL2xuX5a/G7oBUtRbVJtqVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174571; c=relaxed/simple;
	bh=6/uDEXqzsqXa7L7Zx8JmzNsS21rJJuALxOBhBmP5v+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkQ7IGmWiSsWHmI8Iu79lcQHBiNhHVXpJE24VS/xcnEbtJgf4OzHrdQfexLvbiemAMaWz7of7jySNGYEwg0vYH1je0j/SXzmEVu6GhXewrX8pAc8tSFeYeeu//5jeUNNvh0A6KzosjuZhgecQ3b8WeDYZ3/vLEHyM21zyBTfQf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0NOUoOi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0NOUoOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E691F000FF;
	Wed, 23 Sep 2026 14:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174570;
	bh=OgoZi8gljy5+QytS8jPnDAQ/i+FMcjTcq661/UXOWjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U0NOUoOij3gghe/4F3pNcHby40lUcUl9qUj9c3ADuxdaXSeR7CrFgO9MtHnjef6Io
	 UIlX+4puwSNq/uVpSXDLqS4Gl+ezFvoU8IUjyQ2TMCCXCKhAz7NadIQncT/uihiJ6N
	 6FHBY9EVK+FZSZag8Mm6LVwWIwORzemq5tR+J2eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 157/398] drop_monitor: use timer_shutdown_sync() to prevent timer rearming during teardown
Date: Wed, 23 Sep 2026 16:03:51 +0200
Message-ID: <20260923140647.505811367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index 172fd2dcbfe93..b56da4d8c879e 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1084,7 +1084,7 @@ static int net_dm_hw_monitor_start(struct netlink_ext_ack *extack)
 		struct per_cpu_dm_data *hw_data = &per_cpu(dm_hw_cpu_data, cpu);
 		struct sk_buff *skb;
 
-		timer_delete_sync(&hw_data->send_timer);
+		timer_shutdown_sync(&hw_data->send_timer);
 		cancel_work_sync(&hw_data->dm_alert_work);
 		while ((skb = __skb_dequeue(&hw_data->drop_queue))) {
 			struct devlink_trap_metadata *hw_metadata;
@@ -1118,7 +1118,7 @@ static void net_dm_hw_monitor_stop(struct netlink_ext_ack *extack)
 		struct per_cpu_dm_data *hw_data = &per_cpu(dm_hw_cpu_data, cpu);
 		struct sk_buff *skb;
 
-		timer_delete_sync(&hw_data->send_timer);
+		timer_shutdown_sync(&hw_data->send_timer);
 		cancel_work_sync(&hw_data->dm_alert_work);
 		while ((skb = __skb_dequeue(&hw_data->drop_queue))) {
 			struct devlink_trap_metadata *hw_metadata;
@@ -1180,7 +1180,7 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
 		struct sk_buff *skb;
 
-		timer_delete_sync(&data->send_timer);
+		timer_shutdown_sync(&data->send_timer);
 		cancel_work_sync(&data->dm_alert_work);
 		while ((skb = __skb_dequeue(&data->drop_queue)))
 			consume_skb(skb);
@@ -1208,7 +1208,7 @@ static void net_dm_trace_off_set(void)
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
 		struct sk_buff *skb;
 
-		timer_delete_sync(&data->send_timer);
+		timer_shutdown_sync(&data->send_timer);
 		cancel_work_sync(&data->dm_alert_work);
 		while ((skb = __skb_dequeue(&data->drop_queue)))
 			consume_skb(skb);
-- 
2.53.0



