Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7013E6BB52;
	Wed, 21 Feb 2024 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521632; cv=none; b=jg8CcwxeULR8moYd8PcQyeUuYFxbmgLmYkLGYPcN/RH0wtl7fVnBnGDOSvqBdo/j48Z2ock2WXSvipttEoQk0RpR1i1HcjmdEOJdSZ7pRDOKssHqV6SaFRGxrCSVB2r3zrSJ9DDvDtylu4Wzi4w70kE1X6W+SCp0g9Mgta7n3tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521632; c=relaxed/simple;
	bh=eeo7VjluBpS2KcCid9l/OXkFGngYKJOW33nrUYm/m3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLtDsT8VJhal9Vzkv8GGbsaoTKZsDc2GKOlJo/NWOAjhRc4XL6ami0ZH3dZM/G6K3BzwJtXNRqa32XyazzElUangZzgskGUCwLoq8GLZzZojxRY+NfBDgyTTr9GAG2P03LOKZAfXnjE2NrV5an790KxQvmOPQUcaM+zCVpCUKmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYINneWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYINneWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC99AC433F1;
	Wed, 21 Feb 2024 13:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521632;
	bh=eeo7VjluBpS2KcCid9l/OXkFGngYKJOW33nrUYm/m3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYINneWeeGUGsCLqACS+LY/6NSYJhkza3klcyM5759y7zyBrNAp+ZPq/mh1PlwWnS
	 Mf3i+2S31sB/T48hN8w/+AvuYmuNlFwZRwboMO7MrGr7EkAz1U3jOk3mwTTRhnFvkJ
	 qd7ZgbU4pE8OGKhQmrKhmuB4omb8g9i40CuPbAZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 164/202] hrtimer: Report offline hrtimer enqueue
Date: Wed, 21 Feb 2024 14:07:45 +0100
Message-ID: <20240221125937.037456245@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

commit dad6a09f3148257ac1773cd90934d721d68ab595 upstream.

The hrtimers migration on CPU-down hotplug process has been moved
earlier, before the CPU actually goes to die. This leaves a small window
of opportunity to queue an hrtimer in a blind spot, leaving it ignored.

For example a practical case has been reported with RCU waking up a
SCHED_FIFO task right before the CPUHP_AP_IDLE_DEAD stage, queuing that
way a sched/rt timer to the local offline CPU.

Make sure such situations never go unnoticed and warn when that happens.

Fixes: 5c0930ccaad5 ("hrtimers: Push pending hrtimers away from outgoing CPU earlier")
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240129235646.3171983-4-boqun.feng@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hrtimer.h |    4 +++-
 kernel/time/hrtimer.c   |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -182,6 +182,7 @@ enum  hrtimer_base_type {
  * @hang_detected:	The last hrtimer interrupt detected a hang
  * @softirq_activated:	displays, if the softirq is raised - update of softirq
  *			related settings is not required then.
+ * @online:		CPU is online from an hrtimers point of view
  * @nr_events:		Total number of hrtimer interrupt events
  * @nr_retries:		Total number of hrtimer interrupt retries
  * @nr_hangs:		Total number of hrtimer interrupt hangs
@@ -206,7 +207,8 @@ struct hrtimer_cpu_base {
 	unsigned int			hres_active		: 1,
 					in_hrtirq		: 1,
 					hang_detected		: 1,
-					softirq_activated       : 1;
+					softirq_activated       : 1,
+					online			: 1;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	unsigned int			nr_events;
 	unsigned short			nr_retries;
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -970,6 +970,7 @@ static int enqueue_hrtimer(struct hrtime
 			   enum hrtimer_mode mode)
 {
 	debug_activate(timer, mode);
+	WARN_ON_ONCE(!base->cpu_base->online);
 
 	base->cpu_base->active_bases |= 1 << base->index;
 
@@ -1887,6 +1888,7 @@ int hrtimers_prepare_cpu(unsigned int cp
 	cpu_base->softirq_next_timer = NULL;
 	cpu_base->expires_next = KTIME_MAX;
 	cpu_base->softirq_expires_next = KTIME_MAX;
+	cpu_base->online = 1;
 	return 0;
 }
 
@@ -1953,6 +1955,7 @@ int hrtimers_cpu_dying(unsigned int dyin
 	smp_call_function_single(ncpu, retrigger_next_event, NULL, 0);
 
 	raw_spin_unlock(&new_base->lock);
+	old_base->online = 0;
 	raw_spin_unlock(&old_base->lock);
 
 	return 0;


