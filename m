Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94963757EB;
	Mon, 15 Apr 2024 14:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191169; cv=none; b=Vb34Fyr88bh5hddXgW+ZknEbK8KUf1gmZMeyzeNqkdU/6g3nlxTr9vFZRtsh0ojUX3OHZrm8LQ/yajiEyICcoxSsf9AI7/GNZx6YP28caiglrMlAl2zdz45t2cXd9shkfpx781ncjfqdkd2NpSRYq2M5XH+7DMCcObJpbKZcOFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191169; c=relaxed/simple;
	bh=OA0ginYu+FXmGA7iabCdGLMntfHNio8NP4tByc7VuQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWs3QSa60mu0H1GMmL9/fvmvJCIJBIqGTiQanyeQsI0CNpUVTxU/a5+reIgaXqdyfqNpmS2IT0fXuzojpOMsQ07N3MbT4sEuO0Qx3pX53W4BzzYXIRNvcfiKK2D5MunSfUWZt305W3yvS0Ta4/2ZtpclZpNZ8xDihxk6ItBXZec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMvvA59D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMvvA59D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F31C113CC;
	Mon, 15 Apr 2024 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191169;
	bh=OA0ginYu+FXmGA7iabCdGLMntfHNio8NP4tByc7VuQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMvvA59Dm9Pwkhc3iBh9cwECH6FAmBDFpBJuxOR2WUr61KSvQCPaQxYd5mtfku3GX
	 lnLOluowU0ZBdXxycoZ6unFYaFHaKZUSS3QOi/WDTfnWTMfUpEYxpGoy6c8D+g/dGQ
	 S24cvPdQbOa5iMjE7VWCRtVrEiPDs0m6cn5IDYRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	"5 . 16+" <stable@kernel.org>
Subject: [PATCH 6.8 017/172] PM: s2idle: Make sure CPUs will wakeup directly on resume
Date: Mon, 15 Apr 2024 16:18:36 +0200
Message-ID: <20240415142000.876719822@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna-Maria Behnsen <anna-maria@linutronix.de>

commit 3c89a068bfd0698a5478f4cf39493595ef757d5e upstream.

s2idle works like a regular suspend with freezing processes and freezing
devices. All CPUs except the control CPU go into idle. Once this is
completed the control CPU kicks all other CPUs out of idle, so that they
reenter the idle loop and then enter s2idle state. The control CPU then
issues an swait() on the suspend state and therefore enters the idle loop
as well.

Due to being kicked out of idle, the other CPUs leave their NOHZ states,
which means the tick is active and the corresponding hrtimer is programmed
to the next jiffie.

On entering s2idle the CPUs shut down their local clockevent device to
prevent wakeups. The last CPU which enters s2idle shuts down its local
clockevent and freezes timekeeping.

On resume, one of the CPUs receives the wakeup interrupt, unfreezes
timekeeping and its local clockevent and starts the resume process. At that
point all other CPUs are still in s2idle with their clockevents switched
off. They only resume when they are kicked by another CPU or after resuming
devices and then receiving a device interrupt.

That means there is no guarantee that all CPUs will wakeup directly on
resume. As a consequence there is no guarantee that timers which are queued
on those CPUs and should expire directly after resume, are handled. Also
timer list timers which are remotely queued to one of those CPUs after
resume will not result in a reprogramming IPI as the tick is
active. Queueing a hrtimer will also not result in a reprogramming IPI
because the first hrtimer event is already in the past.

The recent introduction of the timer pull model (7ee988770326 ("timers:
Implement the hierarchical pull model")) amplifies this problem, if the
current migrator is one of the non woken up CPUs. When a non pinned timer
list timer is queued and the queuing CPU goes idle, it relies on the still
suspended migrator CPU to expire the timer which will happen by chance.

The problem exists since commit 8d89835b0467 ("PM: suspend: Do not pause
cpuidle in the suspend-to-idle path"). There the cpuidle_pause() call which
in turn invoked a wakeup for all idle CPUs was moved to a later point in
the resume process. This might not be reached or reached very late because
it waits on a timer of a still suspended CPU.

Address this by kicking all CPUs out of idle after the control CPU returns
from swait() so that they resume their timers and restore consistent system
state.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218641
Fixes: 8d89835b0467 ("PM: suspend: Do not pause cpuidle in the suspend-to-idle path")
Signed-off-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Cc: 5.16+ <stable@kernel.org> # 5.16+
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/suspend.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -106,6 +106,12 @@ static void s2idle_enter(void)
 	swait_event_exclusive(s2idle_wait_head,
 		    s2idle_state == S2IDLE_STATE_WAKE);
 
+	/*
+	 * Kick all CPUs to ensure that they resume their timers and restore
+	 * consistent system state.
+	 */
+	wake_up_all_idle_cpus();
+
 	cpus_read_unlock();
 
 	raw_spin_lock_irq(&s2idle_lock);


