Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CC828312F;
	Mon,  9 Feb 2026 14:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648799; cv=none; b=RgSNrtfHAQI0G6/++4tXdDp3IKWe4DNUc8sc725HN2b6xEPhwrEeNWdgDDX595R0DePS2pIoK/SpoQBDfZ6Crh6E2Jp4SVQG3Q0Uy2w0Nkn6kDAWpuDQWwYMKc0hboc2lK3Yu2HZCQpGLNU3HH/BmXOWsTKoJUmyOwcrSMHTURE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648799; c=relaxed/simple;
	bh=t/vWMxUcuoETOopdqw1QLL9d4niSxDFVLvY6hU7w7s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViB7tOsF9AO/31mWri2T6d/r2c7k9mWJ1ZVRSrcHOEAyQj01NFP/h4yD3Dpi+60F/+R5WsM78ZQnNFBqVcQygnHO4boPS4nWxL4MdqB6ABeS5VaUhEuCyP6M8B5SJj5mGLrhUGzzBX5GWDEY+h9CUWegCn6VM/ONIaVl1lfs4Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiLByD0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiLByD0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D197DC116C6;
	Mon,  9 Feb 2026 14:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648799;
	bh=t/vWMxUcuoETOopdqw1QLL9d4niSxDFVLvY6hU7w7s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiLByD0HceM6b6/Tt9V0xj6xS4bcAQ3uE1HxqCtb3AhbA6CbnhMFUxb1pxcqcEKvU
	 26d9L+c98duS384d8j9wWOV7XfJ19hxnfhYKyJOEA6BhQQc4LZDzzimRQXm0LI09TD
	 zea1iyqQRaqF56AvF/3Iv4jH5Y0ZXqctUNb0u1eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 5.15 19/75] timers: Provide timer_shutdown[_sync]()
Date: Mon,  9 Feb 2026 15:24:16 +0100
Message-ID: <20260209142302.537225371@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit f571faf6e443b6011ccb585d57866177af1f643c ]

Tearing down timers which have circular dependencies to other
functionality, e.g. workqueues, where the timer can schedule work and work
can arm timers, is not trivial.

In those cases it is desired to shutdown the timer in a way which prevents
rearming of the timer. The mechanism to do so is to set timer->function to
NULL and use this as an indicator for the timer arming functions to ignore
the (re)arm request.

Expose new interfaces for this: timer_shutdown_sync() and timer_shutdown().

timer_shutdown_sync() has the same functionality as timer_delete_sync()
plus the NULL-ification of the timer function.

timer_shutdown() has the same functionality as timer_delete() plus the
NULL-ification of the timer function.

In both cases the rearming of the timer is prevented by silently discarding
rearm attempts due to timer->function being NULL.

Co-developed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home
Link: https://lore.kernel.org/all/20221110064101.429013735@goodmis.org
Link: https://lore.kernel.org/r/20221123201625.314230270@linutronix.de
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/timer.h |    2 +
 kernel/time/timer.c   |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -184,6 +184,8 @@ extern void add_timer(struct timer_list
 extern int try_to_del_timer_sync(struct timer_list *timer);
 extern int timer_delete_sync(struct timer_list *timer);
 extern int timer_delete(struct timer_list *timer);
+extern int timer_shutdown_sync(struct timer_list *timer);
+extern int timer_shutdown(struct timer_list *timer);
 
 /**
  * del_timer_sync - Delete a pending timer and wait for a running callback
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1310,6 +1310,27 @@ int timer_delete(struct timer_list *time
 EXPORT_SYMBOL(timer_delete);
 
 /**
+ * timer_shutdown - Deactivate a timer and prevent rearming
+ * @timer:	The timer to be deactivated
+ *
+ * The function does not wait for an eventually running timer callback on a
+ * different CPU but it prevents rearming of the timer. Any attempt to arm
+ * @timer after this function returns will be silently ignored.
+ *
+ * This function is useful for teardown code and should only be used when
+ * timer_shutdown_sync() cannot be invoked due to locking or context constraints.
+ *
+ * Return:
+ * * %0 - The timer was not pending
+ * * %1 - The timer was pending
+ */
+int timer_shutdown(struct timer_list *timer)
+{
+	return __timer_delete(timer, true);
+}
+EXPORT_SYMBOL_GPL(timer_shutdown);
+
+/**
  * __try_to_del_timer_sync - Internal function: Try to deactivate a timer
  * @timer:	Timer to deactivate
  * @shutdown:	If true, this indicates that the timer is about to be
@@ -1542,6 +1563,9 @@ static int __timer_delete_sync(struct ti
  * lock. If there is the possibility of a concurrent rearm then the return
  * value of the function is meaningless.
  *
+ * If such a guarantee is needed, e.g. for teardown situations then use
+ * timer_shutdown_sync() instead.
+ *
  * Return:
  * * %0	- The timer was not pending
  * * %1	- The timer was pending and deactivated
@@ -1552,6 +1576,48 @@ int timer_delete_sync(struct timer_list
 }
 EXPORT_SYMBOL(timer_delete_sync);
 
+/**
+ * timer_shutdown_sync - Shutdown a timer and prevent rearming
+ * @timer: The timer to be shutdown
+ *
+ * When the function returns it is guaranteed that:
+ *   - @timer is not queued
+ *   - The callback function of @timer is not running
+ *   - @timer cannot be enqueued again. Any attempt to rearm
+ *     @timer is silently ignored.
+ *
+ * See timer_delete_sync() for synchronization rules.
+ *
+ * This function is useful for final teardown of an infrastructure where
+ * the timer is subject to a circular dependency problem.
+ *
+ * A common pattern for this is a timer and a workqueue where the timer can
+ * schedule work and work can arm the timer. On shutdown the workqueue must
+ * be destroyed and the timer must be prevented from rearming. Unless the
+ * code has conditionals like 'if (mything->in_shutdown)' to prevent that
+ * there is no way to get this correct with timer_delete_sync().
+ *
+ * timer_shutdown_sync() is solving the problem. The correct ordering of
+ * calls in this case is:
+ *
+ *	timer_shutdown_sync(&mything->timer);
+ *	workqueue_destroy(&mything->workqueue);
+ *
+ * After this 'mything' can be safely freed.
+ *
+ * This obviously implies that the timer is not required to be functional
+ * for the rest of the shutdown operation.
+ *
+ * Return:
+ * * %0 - The timer was not pending
+ * * %1 - The timer was pending
+ */
+int timer_shutdown_sync(struct timer_list *timer)
+{
+	return __timer_delete_sync(timer, true);
+}
+EXPORT_SYMBOL_GPL(timer_shutdown_sync);
+
 static void call_timer_fn(struct timer_list *timer,
 			  void (*fn)(struct timer_list *),
 			  unsigned long baseclk)


