Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63B378B4B;
	Wed, 21 Feb 2024 14:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524848; cv=none; b=Dm/dJUcwPJEt36gpP/YrK/N0aUYstQffA74U9vCLOmXiL5R4/1gidOLbCI/MEEuii6GBDwiEkwhny55mR8J8TCFwBnr5cTCl+CFgLwMrq3zpJFPNlzQ+ChKyIKaNOT1azM02j8JqYC3n/KGAikbDKKW/wEJZv22nzaZlkB4zOK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524848; c=relaxed/simple;
	bh=Jl0DoNZwelgC0ypbMBKWdjr2ErjC36f+0bZqqaux3T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mn+8pWiI1F0+zyA5TIR+vIW8vi+qgw+LOwQIRSUp8pR7+9Wg+8jOGuifeJGkWBke5qLe4xJXyRaWBQzkOzdXU3xDwqvlNQWnZyHKGkmQRnX5cmRA0ZLb5Rbb3kEa6Kpo3V0dq9793Tw/Qu4NAUq/HISen90wd2eJo3GYFqmEzkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVhW5IdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVhW5IdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6CDC433F1;
	Wed, 21 Feb 2024 14:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524848;
	bh=Jl0DoNZwelgC0ypbMBKWdjr2ErjC36f+0bZqqaux3T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVhW5IdTmrg26ulPPUA11t3ZWZ2UFbnCFfaLo12vpqCwMPs7WPtmXubnGG0y3nomr
	 rP8r/xhj3usBsDMmvxij9wH53wB+KUvRQfaD6hOGaMng8FIOl+v0ID3uzjtHR3pA7b
	 SXgKh7RxCXNR0+2GA2MtLTcJwf9FqsFiBN1qav+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 5.10 367/379] hrtimer: Ignore slack time for RT tasks in schedule_hrtimeout_range()
Date: Wed, 21 Feb 2024 14:09:06 +0100
Message-ID: <20240221130005.920168000@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Davidlohr Bueso <dave@stgolabs.net>

commit 0c52310f260014d95c1310364379772cb74cf82d upstream.

While in theory the timer can be triggered before expires + delta, for the
cases of RT tasks they really have no business giving any lenience for
extra slack time, so override any passed value by the user and always use
zero for schedule_hrtimeout_range() calls. Furthermore, this is similar to
what the nanosleep(2) family already does with current->timer_slack_ns.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20230123173206.6764-3-dave@stgolabs.net
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/hrtimer.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2164,7 +2164,7 @@ void __init hrtimers_init(void)
 /**
  * schedule_hrtimeout_range_clock - sleep until timeout
  * @expires:	timeout value (ktime_t)
- * @delta:	slack in expires timeout (ktime_t)
+ * @delta:	slack in expires timeout (ktime_t) for SCHED_OTHER tasks
  * @mode:	timer mode
  * @clock_id:	timer clock to be used
  */
@@ -2191,6 +2191,13 @@ schedule_hrtimeout_range_clock(ktime_t *
 		return -EINTR;
 	}
 
+	/*
+	 * Override any slack passed by the user if under
+	 * rt contraints.
+	 */
+	if (rt_task(current))
+		delta = 0;
+
 	hrtimer_init_sleeper_on_stack(&t, clock_id, mode);
 	hrtimer_set_expires_range_ns(&t.timer, *expires, delta);
 	hrtimer_sleeper_start_expires(&t, mode);
@@ -2210,7 +2217,7 @@ EXPORT_SYMBOL_GPL(schedule_hrtimeout_ran
 /**
  * schedule_hrtimeout_range - sleep until timeout
  * @expires:	timeout value (ktime_t)
- * @delta:	slack in expires timeout (ktime_t)
+ * @delta:	slack in expires timeout (ktime_t) for SCHED_OTHER tasks
  * @mode:	timer mode
  *
  * Make the current task sleep until the given expiry time has
@@ -2218,7 +2225,8 @@ EXPORT_SYMBOL_GPL(schedule_hrtimeout_ran
  * the current task state has been set (see set_current_state()).
  *
  * The @delta argument gives the kernel the freedom to schedule the
- * actual wakeup to a time that is both power and performance friendly.
+ * actual wakeup to a time that is both power and performance friendly
+ * for regular (non RT/DL) tasks.
  * The kernel give the normal best effort behavior for "@expires+@delta",
  * but may decide to fire the timer earlier, but no earlier than @expires.
  *


