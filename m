Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029D314AD15;
	Tue, 20 Feb 2024 21:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463271; cv=none; b=miLqGS5K/IiXnqFXcgPPyBhuUGaad7HceXMjWQQv90VnVDyRftriP0BM8jLh2nC2j+4rs7aVFF545aF0958YON1hajdLnb9Jw7CnbmD+eNZPmG0UUf822ctm3LlMRQW0yYTMZd/VZNS65gVIEdMfzzO67BWJFFN4nPDdNqcLFoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463271; c=relaxed/simple;
	bh=zSs6GmrKCmuOWTKqNJjMNgs3FYLWGCkqL9agh0yI8yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAajgWENMzlwhQsBDWObT5CJPD8Nf/F0bE2AQ/MjHgAJGVbsLIF9jpqHnrngVDOBqf7RZGxoGEn/p7IoUBkC1zWMCroh3Ed3UbLhc35Lh0N1zW2I3puT6UaAUu+8N2+FG2Y+SK7R3k04UEXv64ANPF77ACcOTg6IlCQmW0rD6kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18gNwpBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18gNwpBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A18C433F1;
	Tue, 20 Feb 2024 21:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463270;
	bh=zSs6GmrKCmuOWTKqNJjMNgs3FYLWGCkqL9agh0yI8yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18gNwpBC+FsNAOYYjDOpCj1IGdRAlfDFxn+kNIm08mkESUctGOlqGbALwlQ9I/N0h
	 Tcaod6+nUYHvqZo0cE776IefwBM/ebvj/OuKpv2Zsfk7synSvB+ZJ1yG3lXDGVxRGI
	 0zTGSDlh+pzu26wTuo1891NRzD7GV8iGFShPZyME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 6.1 189/197] hrtimer: Ignore slack time for RT tasks in schedule_hrtimeout_range()
Date: Tue, 20 Feb 2024 21:52:28 +0100
Message-ID: <20240220204846.736629649@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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
@@ -2266,7 +2266,7 @@ void __init hrtimers_init(void)
 /**
  * schedule_hrtimeout_range_clock - sleep until timeout
  * @expires:	timeout value (ktime_t)
- * @delta:	slack in expires timeout (ktime_t)
+ * @delta:	slack in expires timeout (ktime_t) for SCHED_OTHER tasks
  * @mode:	timer mode
  * @clock_id:	timer clock to be used
  */
@@ -2293,6 +2293,13 @@ schedule_hrtimeout_range_clock(ktime_t *
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
@@ -2312,7 +2319,7 @@ EXPORT_SYMBOL_GPL(schedule_hrtimeout_ran
 /**
  * schedule_hrtimeout_range - sleep until timeout
  * @expires:	timeout value (ktime_t)
- * @delta:	slack in expires timeout (ktime_t)
+ * @delta:	slack in expires timeout (ktime_t) for SCHED_OTHER tasks
  * @mode:	timer mode
  *
  * Make the current task sleep until the given expiry time has
@@ -2320,7 +2327,8 @@ EXPORT_SYMBOL_GPL(schedule_hrtimeout_ran
  * the current task state has been set (see set_current_state()).
  *
  * The @delta argument gives the kernel the freedom to schedule the
- * actual wakeup to a time that is both power and performance friendly.
+ * actual wakeup to a time that is both power and performance friendly
+ * for regular (non RT/DL) tasks.
  * The kernel give the normal best effort behavior for "@expires+@delta",
  * but may decide to fire the timer earlier, but no earlier than @expires.
  *


