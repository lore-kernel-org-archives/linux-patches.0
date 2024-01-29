Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B289E15D5B3;
	Mon, 29 Jan 2024 17:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548404; cv=none; b=iYduyzR977qrctaaB5TYpsBxkZjP3NogN6UdWi53A9nCDk7FyqOwYGK2CwPuFx2jnRDdho6jGLJqTgZ4aDj6j5PxPynS2JLnLpZvL2h6d7SRrx2tzXBwZKBTLbaF3P2vekY1jcrJjnTCXidJjgBoYhDZKq6DYAhh6tYh3mCBY6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548404; c=relaxed/simple;
	bh=RKLhUkO3newr6w+eJkIyWF378Rjw1lzWUBhXaRfne8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eK2SrJdy/DXr5uPU2VvueWVmiLr4hwLZ8oFTq6hbqSTXE7qYPITP0sHICfwxEGB+cFwQasce//VHvi9QZW8lSvnR1c0AFV57+/HpTUxiyb9muG8w5qrilzBVHEFncGVklqezOdoGW/J+8wJOR8oFOVCqHKbHowkNrE4iHI0gO7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWLHbLE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWLHbLE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CA5C43399;
	Mon, 29 Jan 2024 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548404;
	bh=RKLhUkO3newr6w+eJkIyWF378Rjw1lzWUBhXaRfne8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWLHbLE9pnStny8zl6GqHlvHFpchYytm3XZw9SkpZWK/Xt1sCsbln5VBENKNHyJXU
	 CS9e3ZRchiZI0cJ/X0CLfQ1E4UNXHKwiBSVuddwYF7NddoKPEVT13yG2a7fiQwuAlI
	 hFGzsv8deitusgaCL059ZkV0q5B+us2a62hkl10Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 183/185] tick/sched: Preserve number of idle sleeps across CPU hotplug events
Date: Mon, 29 Jan 2024 09:06:23 -0800
Message-ID: <20240129170004.462635902@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Tim Chen <tim.c.chen@linux.intel.com>

commit 9a574ea9069be30b835a3da772c039993c43369b upstream.

Commit 71fee48f ("tick-sched: Fix idle and iowait sleeptime accounting vs
CPU hotplug") preserved total idle sleep time and iowait sleeptime across
CPU hotplug events.

Similar reasoning applies to the number of idle calls and idle sleeps to
get the proper average of sleep time per idle invocation.

Preserve those fields too.

Fixes: 71fee48f ("tick-sched: Fix idle and iowait sleeptime accounting vs CPU hotplug")
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240122233534.3094238-1-tim.c.chen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/tick-sched.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1557,6 +1557,7 @@ void tick_cancel_sched_timer(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t idle_sleeptime, iowait_sleeptime;
+	unsigned long idle_calls, idle_sleeps;
 
 # ifdef CONFIG_HIGH_RES_TIMERS
 	if (ts->sched_timer.base)
@@ -1565,9 +1566,13 @@ void tick_cancel_sched_timer(int cpu)
 
 	idle_sleeptime = ts->idle_sleeptime;
 	iowait_sleeptime = ts->iowait_sleeptime;
+	idle_calls = ts->idle_calls;
+	idle_sleeps = ts->idle_sleeps;
 	memset(ts, 0, sizeof(*ts));
 	ts->idle_sleeptime = idle_sleeptime;
 	ts->iowait_sleeptime = iowait_sleeptime;
+	ts->idle_calls = idle_calls;
+	ts->idle_sleeps = idle_sleeps;
 }
 #endif
 


