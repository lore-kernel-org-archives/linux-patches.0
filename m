Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC6363C;
	Thu, 15 Aug 2024 14:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731312; cv=none; b=g+7JgdIwr7yAE6bfvCl8HzvE+/+oEK9TPAJADZiljA03Z+5YQaSHH/NYbQGI6gXzg800ivvSH6jNwk0k40BMLIYxD/9LX6PtBaA7vuNYdgj2C4/DWOyWC5Ir7EoG+Bs3o8PPJAcT1JGJhPj3Vj4mr+7dG8113oloknNX7/k1O0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731312; c=relaxed/simple;
	bh=Y/f/xmSytC0pav0/hauTG7HaXkIBG+Y9AOCa8z11gcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/ixjWau6SZ8Pklix3ZDApQ8UuYRkdR7BuWl3OkeAZCwxy3Frtb6MIk88hmo1/bjvshSTl4n2+RmARAC5GDEuua84RSwKYI8A1aW6M19N50qZFMeyghT5OSn3reukTKfRoGnYD4vICD1yc+trEQquZepE5JPvBCgt3RRmtzRJlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVjM/3hK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVjM/3hK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443A3C4AF0A;
	Thu, 15 Aug 2024 14:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731312;
	bh=Y/f/xmSytC0pav0/hauTG7HaXkIBG+Y9AOCa8z11gcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVjM/3hKH6VIeExwEB0jm46yaYGK9oPRAMPrlWrUhOjmWKUR8gwhRkCksqvMSFXy5
	 XjckbI05AA4H0bszRFCA6L4lOdn+9z6IdX/woTnp4TTQresrKmYyiF2fyiL+qhHPWA
	 iXp+U0OOO+AiNlNPuYfi1pvOQ5Wod23wo+0wA53g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Liao <liaoyu15@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 089/259] tick/broadcast: Make takeover of broadcast hrtimer reliable
Date: Thu, 15 Aug 2024 15:23:42 +0200
Message-ID: <20240815131906.238317987@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

From: Yu Liao <liaoyu15@huawei.com>

commit f7d43dd206e7e18c182f200e67a8db8c209907fa upstream.

Running the LTP hotplug stress test on a aarch64 machine results in
rcu_sched stall warnings when the broadcast hrtimer was owned by the
un-plugged CPU. The issue is the following:

CPU1 (owns the broadcast hrtimer)	CPU2

				tick_broadcast_enter()
				  // shutdown local timer device
				  broadcast_shutdown_local()
				...
				tick_broadcast_exit()
				  clockevents_switch_state(dev, CLOCK_EVT_STATE_ONESHOT)
				  // timer device is not programmed
				  cpumask_set_cpu(cpu, tick_broadcast_force_mask)

				initiates offlining of CPU1
take_cpu_down()
/*
 * CPU1 shuts down and does not
 * send broadcast IPI anymore
 */
				takedown_cpu()
				  hotplug_cpu__broadcast_tick_pull()
				    // move broadcast hrtimer to this CPU
				    clockevents_program_event()
				      bc_set_next()
					hrtimer_start()
					/*
					 * timer device is not programmed
					 * because only the first expiring
					 * timer will trigger clockevent
					 * device reprogramming
					 */

What happens is that CPU2 exits broadcast mode with force bit set, then the
local timer device is not reprogrammed and CPU2 expects to receive the
expired event by the broadcast IPI. But this does not happen because CPU1
is offlined by CPU2. CPU switches the clockevent device to ONESHOT state,
but does not reprogram the device.

The subsequent reprogramming of the hrtimer broadcast device does not
program the clockevent device of CPU2 either because the pending expiry
time is already in the past and the CPU expects the event to be delivered.
As a consequence all CPUs which wait for a broadcast event to be delivered
are stuck forever.

Fix this issue by reprogramming the local timer device if the broadcast
force bit of the CPU is set so that the broadcast hrtimer is delivered.

[ tglx: Massage comment and change log. Add Fixes tag ]

Fixes: 989dcb645ca7 ("tick: Handle broadcast wakeup of multiple cpus")
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240711124843.64167-1-liaoyu15@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/tick-broadcast.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -944,6 +944,7 @@ void tick_broadcast_switch_to_oneshot(vo
 #ifdef CONFIG_HOTPLUG_CPU
 void hotplug_cpu__broadcast_tick_pull(int deadcpu)
 {
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	struct clock_event_device *bc;
 	unsigned long flags;
 
@@ -951,6 +952,28 @@ void hotplug_cpu__broadcast_tick_pull(in
 	bc = tick_broadcast_device.evtdev;
 
 	if (bc && broadcast_needs_cpu(bc, deadcpu)) {
+		/*
+		 * If the broadcast force bit of the current CPU is set,
+		 * then the current CPU has not yet reprogrammed the local
+		 * timer device to avoid a ping-pong race. See
+		 * ___tick_broadcast_oneshot_control().
+		 *
+		 * If the broadcast device is hrtimer based then
+		 * programming the broadcast event below does not have any
+		 * effect because the local clockevent device is not
+		 * running and not programmed because the broadcast event
+		 * is not earlier than the pending event of the local clock
+		 * event device. As a consequence all CPUs waiting for a
+		 * broadcast event are stuck forever.
+		 *
+		 * Detect this condition and reprogram the cpu local timer
+		 * device to avoid the starvation.
+		 */
+		if (tick_check_broadcast_expired()) {
+			cpumask_clear_cpu(smp_processor_id(), tick_broadcast_force_mask);
+			tick_program_event(td->evtdev->next_event, 1);
+		}
+
 		/* This moves the broadcast assignment to this CPU: */
 		clockevents_program_event(bc, bc->next_event, 1);
 	}


