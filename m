Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCC669D02;
	Wed, 21 Feb 2024 13:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521294; cv=none; b=APCi3KBEdM1/OABXcI+sldq9d1ewcXOWE2bXDFoPybX2hbYuYGOysUxlpcPDRngbt9/l6buw9AtNa+DKj7utWcf+XV64BXp/Xcga8T9FF25m/fyazQsf+2bNpOiP0LIabV5MFXHJEpvtLhV6LO9KQiAJlR8VR2KeRqDpPxSp/uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521294; c=relaxed/simple;
	bh=+jkd0s9kilwobAZmuCh2OkBhN6GjOMx6oWMO9WvhRDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+nEhvmYlRjf3QGGRsqrrSv6vhHZ1e/ab+D6czYculRTVY4BEYRHVT6Cr/zuT6VGLOXqaEyLRGyinL38K8h6H/PmpecWS/Z/eAAMoH7p+OZALm/i1/z/XVtqspekhZ/+5qaYK526Kaokqf6awYkeRhcG8EEed+2EZC9P3Tt6fFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVrQfeUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVrQfeUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4B3C433C7;
	Wed, 21 Feb 2024 13:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521293;
	bh=+jkd0s9kilwobAZmuCh2OkBhN6GjOMx6oWMO9WvhRDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVrQfeUEBO7urbCqFhmQvTuNbHxHyyncxZxJC+qrxOBFG/G5/6u/6hoHOBHmqly9p
	 PemJm1bqjL60hFSGFxi/SPSM985JUPUsoj3IqVuGdjRs8PpIvMi4pLDVRmdfuoijP3
	 hnWO0LMV18K1Si1qZLYsjSOflaFN3XpkQk1bukbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 047/202] tick/sched: Preserve number of idle sleeps across CPU hotplug events
Date: Wed, 21 Feb 2024 14:05:48 +0100
Message-ID: <20240221125933.332241128@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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
@@ -1346,6 +1346,7 @@ void tick_cancel_sched_timer(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t idle_sleeptime, iowait_sleeptime;
+	unsigned long idle_calls, idle_sleeps;
 
 # ifdef CONFIG_HIGH_RES_TIMERS
 	if (ts->sched_timer.base)
@@ -1354,9 +1355,13 @@ void tick_cancel_sched_timer(int cpu)
 
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
 


