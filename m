Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E20145B28;
	Thu, 11 Apr 2024 10:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830510; cv=none; b=il7k4oMNSr9jSE/XeEQjQSlXzV4jZ1wNzXYXEjIbOS5lVXtFMYelEyFFWGFvKTei/+oMnwqbUsPmnLv9a3jGYvjqnrkfyJ33lyUP/Xl0euRPh6n3uT4/f+3nS596T3FPIVLyg3y9BNpMlIko3xho84tBWFClgNH15nwj3hNri2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830510; c=relaxed/simple;
	bh=qWvnpqrlscQDcnT5C4NQki9FzVjHaJbDZ4IKzGVKXVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxL+Vidj2pao56AQSGgq4FJhFlxXOIkrO4aJCvV409M39o7GUA4c5TbBAFVlzG+3YZ8NTs1YTWnsUMl/s/xqnxXqIBp3W0Andz9qzTymdOO9Z/UYK3qfPCjWoya8FgdoqmWoQI0rzE8vhzDHVMqWUrhsPXddghY0FlAAAOsTo0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjJRirFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjJRirFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD23AC433F1;
	Thu, 11 Apr 2024 10:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830510;
	bh=qWvnpqrlscQDcnT5C4NQki9FzVjHaJbDZ4IKzGVKXVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjJRirFLkg7qQrDB14I+bUbG5WHTKVUkuRvOubg8Dzk8gxYnoseMzlbGva8Dk6D8w
	 k03jtqO+IXnDgLrH7907Z5Ud4/sRbeMnsO8Ffp8aurzgQAMoPjvcyHOOPEXFA5gAGZ
	 GJBybBlOdcCH2FSk4OcQsj1zZ9edyh8o/hOj0OfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/215] timers: Use del_timer_sync() even on UP
Date: Thu, 11 Apr 2024 11:53:34 +0200
Message-ID: <20240411095425.041695142@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 168f6b6ffbeec0b9333f3582e4cf637300858db5 ]

del_timer_sync() is assumed to be pointless on uniprocessor systems and can
be mapped to del_timer() because in theory del_timer() can never be invoked
while the timer callback function is executed.

This is not entirely true because del_timer() can be invoked from interrupt
context and therefore hit in the middle of a running timer callback.

Contrary to that del_timer_sync() is not allowed to be invoked from
interrupt context unless the affected timer is marked with TIMER_IRQSAFE.
del_timer_sync() has proper checks in place to detect such a situation.

Give up on the UP optimization and make del_timer_sync() unconditionally
available.

Co-developed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home
Link: https://lore.kernel.org/all/20221110064101.429013735@goodmis.org
Link: https://lore.kernel.org/r/20221123201624.888306160@linutronix.de
Stable-dep-of: 0f7352557a35 ("wifi: brcmfmac: Fix use-after-free bug in brcmf_cfg80211_detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/timer.h | 7 +------
 kernel/time/timer.c   | 2 --
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 1e6650ed066d5..4de865f516154 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -182,12 +182,7 @@ extern int timer_reduce(struct timer_list *timer, unsigned long expires);
 extern void add_timer(struct timer_list *timer);
 
 extern int try_to_del_timer_sync(struct timer_list *timer);
-
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
-  extern int del_timer_sync(struct timer_list *timer);
-#else
-# define del_timer_sync(t)		del_timer(t)
-#endif
+extern int del_timer_sync(struct timer_list *timer);
 
 #define del_singleshot_timer_sync(t) del_timer_sync(t)
 
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 973c66d9b3f90..0dfd1cacc4a00 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1345,7 +1345,6 @@ static inline void timer_sync_wait_running(struct timer_base *base) { }
 static inline void del_timer_wait_running(struct timer_list *timer) { }
 #endif
 
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 /**
  * del_timer_sync - Deactivate a timer and wait for the handler to finish.
  * @timer:	The timer to be deactivated
@@ -1419,7 +1418,6 @@ int del_timer_sync(struct timer_list *timer)
 	return ret;
 }
 EXPORT_SYMBOL(del_timer_sync);
-#endif
 
 static void call_timer_fn(struct timer_list *timer,
 			  void (*fn)(struct timer_list *),
-- 
2.43.0



