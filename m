Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3903D981;
	Wed, 21 Feb 2024 14:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525099; cv=none; b=TK3Iptl+AIbtZcmtwOOfOwueI2YAaYeLpcx9rnOqrEzRx94Eam1P5Gf9z6EGaqtwfaDtiSPtYPUinQJiR7SxLCPOkhSLPmWJoRFWJNHcny2+BFPTapvkLeKahQ+5tniGX3ZsORY0G2JwyxgGbJcB5k/qKr4Cg6BfFK0DqR68kb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525099; c=relaxed/simple;
	bh=svFvsT0f21uQ2vJf3kmlWKN7qu9twkImaBEXfPpRq0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wy5/bJk39QE3VFSjy9E7fhjL/EpxC7+yD0FcFIzN9QregmMS+gwpn6r3b3PNKCgtujk6pM2Kok0rIVV6vHSU0PojjL/QFpRrI00U73FvxfqmzxuMO/ZEvflJcR7gyPgObVki/3lfXulVewGXMa09eO4QhO1/yDTQ3XTwIcQYRRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAooFjWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAooFjWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F060C433F1;
	Wed, 21 Feb 2024 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525099;
	bh=svFvsT0f21uQ2vJf3kmlWKN7qu9twkImaBEXfPpRq0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAooFjWWOcExocRNaCjtEhu+r8Bei1gSr5fkZp4zdTaTb0F2ACKI11oMTL1oos8o7
	 5BzyH1ieJgjGsKHLlivKRkkJ/9N7saSn0CVpULicKE6BGZkVFmc2GdxW77wXjmNK0f
	 NqODtIVh7EwLH3fDjmZw0BYWNJ7QuYMDyrhj6c08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 059/267] tick/sched: Preserve number of idle sleeps across CPU hotplug events
Date: Wed, 21 Feb 2024 14:06:40 +0100
Message-ID: <20240221125941.858649978@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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
@@ -1398,6 +1398,7 @@ void tick_cancel_sched_timer(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t idle_sleeptime, iowait_sleeptime;
+	unsigned long idle_calls, idle_sleeps;
 
 # ifdef CONFIG_HIGH_RES_TIMERS
 	if (ts->sched_timer.base)
@@ -1406,9 +1407,13 @@ void tick_cancel_sched_timer(int cpu)
 
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
 


