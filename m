Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57D013DDDD;
	Thu, 11 Apr 2024 10:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829601; cv=none; b=I4TOvDUTn2gjFGx5YGD2Qlye74vxawSIeKIAeb/PlF9RQVq/2tk2ByR5MbCs9jmAvAzgpfa9xyWCMEcwa1d3aSq1+6k366ZuyDZLEzpOxLXgWmk9k2ApyXWVSOIOuLsiugkzVKnInkfOOoYyj8ySsMhVDdOCd4Ps6+DTgpR/g6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829601; c=relaxed/simple;
	bh=qu+BWgtz9zi+BH7/64gZ3r6MrQ2LpCJUox4CTaQ7DhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uG0gkRMrNg8BEBhXGuc2nGwRMKwcUnQkpcAShl86O+ODss5X6hclmYqjBg/1ogFU4SF8OoTlwUFp+COLDJS9UQT1LMmLN+Zi4VF149lQjBil/a7tya/szB07QypFsHz/LCeW/h83PA+VIqwAuxSM6gCLW8Eu4zjiNCSUDY5LPHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxBW1gek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxBW1gek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AABAC433C7;
	Thu, 11 Apr 2024 10:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829601;
	bh=qu+BWgtz9zi+BH7/64gZ3r6MrQ2LpCJUox4CTaQ7DhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxBW1gekecc/iBpqirLvJO9/UE3Z/BfCufE2OPABAwkvExyv6G2KGYDpp6WY9/mHv
	 c+zoLJvhqpbwniOSDXkK4/rsSbA7aa86UYeTnbiyCIhPZfEa9MKvC8HC8LIijfvLML
	 z3Z1ABacZxl2QN7vFqg8u2fRrzNwgCZNqMNq6A1k=
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
Subject: [PATCH 4.19 008/175] timers: Use del_timer_sync() even on UP
Date: Thu, 11 Apr 2024 11:53:51 +0200
Message-ID: <20240411095419.791913232@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 8e027cb10df01..a9c20a7ead305 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -171,12 +171,7 @@ extern int timer_reduce(struct timer_list *timer, unsigned long expires);
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
index f63efe259ae46..489bb01796de4 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1349,7 +1349,6 @@ static inline void timer_sync_wait_running(struct timer_base *base) { }
 static inline void del_timer_wait_running(struct timer_list *timer) { }
 #endif
 
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 /**
  * del_timer_sync - Deactivate a timer and wait for the handler to finish.
  * @timer:	The timer to be deactivated
@@ -1423,7 +1422,6 @@ int del_timer_sync(struct timer_list *timer)
 	return ret;
 }
 EXPORT_SYMBOL(del_timer_sync);
-#endif
 
 static void call_timer_fn(struct timer_list *timer,
 			  void (*fn)(struct timer_list *),
-- 
2.43.0



