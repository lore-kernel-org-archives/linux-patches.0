Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355E91D558;
	Thu, 11 Apr 2024 10:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831474; cv=none; b=F/BlSHzxiaR1Q2S2WEuGMknTLSerTtoIUqWYGtOFbz0E6ZN33zebA4WoZ1ZdxD8Vwq3mpui/NtLNCoEXJoOkt0ufjwT61TSkmcQ1eRcd6AyVhsMx7UU0++wtzV2OkAn15hRus1ePGNzYVz5fRRUz5T0HeZL4hZmAgeFWexTG7EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831474; c=relaxed/simple;
	bh=xs+Yml+Jjw9LIF3ZyWxE0OVnM1lFsYZiybuL58GhEog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfems0d6P8M1MFcGo3ZH9fbfXqe99tkcyTXzIqkTeiSGCYALnLAq9qMA449SAmgZoL822g+tQKTzCYX91oKpjGWmbfZ3xw/hkbnkWu0211rJQQPnrUG45fWoRXBRMKlVAKQ/YExqkpVS3FJhpwzEog0+/YkqbKdCSMfy2VzW8aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXzKQBa6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXzKQBa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC05C433F1;
	Thu, 11 Apr 2024 10:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831474;
	bh=xs+Yml+Jjw9LIF3ZyWxE0OVnM1lFsYZiybuL58GhEog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXzKQBa66J1s+Y1N3twWLz6MaQtsfjIY5zQBUrcLCjNJ1HXm3k0B1j3FaQD+43SCP
	 6JrnMP8i8aUvmiCiLKeH0Om3ZseIzlSkuhz5Pjts79zvzHfV20DbsmGOuOlFIz+WvZ
	 pyA23kW2V5buERHCw1iWGI0Ldpf9/eAPiRb1+OKg=
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
Subject: [PATCH 5.10 005/294] timers: Use del_timer_sync() even on UP
Date: Thu, 11 Apr 2024 11:52:48 +0200
Message-ID: <20240411095435.800194478@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d10bc7e73b41e..a3125373139e1 100644
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
index 3157a6434a615..9edce790b3aa5 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1341,7 +1341,6 @@ static inline void timer_sync_wait_running(struct timer_base *base) { }
 static inline void del_timer_wait_running(struct timer_list *timer) { }
 #endif
 
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 /**
  * del_timer_sync - Deactivate a timer and wait for the handler to finish.
  * @timer:	The timer to be deactivated
@@ -1415,7 +1414,6 @@ int del_timer_sync(struct timer_list *timer)
 	return ret;
 }
 EXPORT_SYMBOL(del_timer_sync);
-#endif
 
 static void call_timer_fn(struct timer_list *timer,
 			  void (*fn)(struct timer_list *),
-- 
2.43.0



