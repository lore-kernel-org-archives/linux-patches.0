Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC274CB4A;
	Mon,  1 Apr 2024 16:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990650; cv=none; b=SnDN6cDxA1uJFqp395YnyAxi4OcSvL5kDZC4i3C4LTZk+JjuV8TSL+PiNAamQdU+voXv81t0c4truIH6UqXRee1y/BzY0IP2ssuo8hUKpwm6XoO/MC4ltoDkZdVjIBaNcS1fKya4AePCIwAKAPfKaTTxh+oto04f7hHhUUZFDnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990650; c=relaxed/simple;
	bh=9Og3EpXUF8+HutkmYLMU9zzqmM3oYy2I7PKjtOMpfNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9mZZxJ52jOXysgm0mZVwipZ958+OMb80VVwZ0z2eoF5SzPh9S40Gnosd3bjpWZtvIJALiY/4TG+/fMQzURFSjdJ9zQmKxYd+pWP3l2WoJS3C3WYUDPopm2gyL+dU7kRW+rPVTKuvrr+TnLWUyp4xIY1z7GVhliwIeAI1G8iwIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlDtJ01x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlDtJ01x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5914C43394;
	Mon,  1 Apr 2024 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990650;
	bh=9Og3EpXUF8+HutkmYLMU9zzqmM3oYy2I7PKjtOMpfNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlDtJ01xAfST1ViYUHFaOUuNC2pNjlHPWlY/M3NOnV4oIaIuialAVqtTxCQK+H7c3
	 t4wzAMKwOthQWFW4kFD32bqm3asjwFvO7ZcNQMVOXM8JQI6Gye15C4m2gmQAyLcX1z
	 EdKmwRqi70dsRIIDPNz2fZ4eVHaU8l/+/FilKaow=
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
Subject: [PATCH 6.1 007/272] timers: Use del_timer_sync() even on UP
Date: Mon,  1 Apr 2024 17:43:17 +0200
Message-ID: <20240401152530.510030738@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 648f00105f588..82bb2e4d3b7c2 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -183,12 +183,7 @@ extern int timer_reduce(struct timer_list *timer, unsigned long expires);
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
index ab9688a2ae190..9d09a2a0ad708 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1394,7 +1394,6 @@ static inline void timer_sync_wait_running(struct timer_base *base) { }
 static inline void del_timer_wait_running(struct timer_list *timer) { }
 #endif
 
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 /**
  * del_timer_sync - Deactivate a timer and wait for the handler to finish.
  * @timer:	The timer to be deactivated
@@ -1475,7 +1474,6 @@ int del_timer_sync(struct timer_list *timer)
 	return ret;
 }
 EXPORT_SYMBOL(del_timer_sync);
-#endif
 
 static void call_timer_fn(struct timer_list *timer,
 			  void (*fn)(struct timer_list *),
-- 
2.43.0



