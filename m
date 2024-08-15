Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D90019DF9E;
	Thu, 15 Aug 2024 13:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728637; cv=none; b=inKW+HXXGRXetSaOlzJG4TPz6q405Ka7PjKbSG80p2uz3sGjxItxwMfB7TByobD5g2rkQR/jBv6c/lLq0++quK60FX2wHdQ6vXDfoWVU8PbY8oVesB+6Envxjn4+yu6L8hTh37yab08Mc+VXXUEI/jm1JJCFVluqnt98k91FIxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728637; c=relaxed/simple;
	bh=XLoZ/oy099eFbx/caLdlUBMSfNSwI8KAPN6jK5kmB4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGfqDSB0q/trzj4jmBKe6GxegR8/nJk9C1RWp5VApnHWJsWrj8l7P3mgDwPx2SI+ZYmeqHgSBP9qnp6HULITFtKKmmt4CUVZ6Jr9mjrB/QqZ4LE+frRhxg2QOvKzH4XUKp2XaAz/jCZjqZ7yVKlDdBSb0UP4/zBLevMWDeid9DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMWx4frp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMWx4frp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8A5C32786;
	Thu, 15 Aug 2024 13:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728637;
	bh=XLoZ/oy099eFbx/caLdlUBMSfNSwI8KAPN6jK5kmB4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMWx4frpac8ISBIuRULLS9OeVzeGx3hVg13DyxYggj4iHyw0lOk3XInqi5eIXXiEA
	 2l6q3P2q4kJI3nfGDb+FC6j7V6nJmUH8dFTLFtTolj1MmFa0NJdRugkOxRZkZBK5IU
	 uy8//p03alPh56x5OXzmsTSn2lokfwHe4H9kohDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Liao <liaoyu15@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 062/196] tick/broadcast: Make takeover of broadcast hrtimer reliable
Date: Thu, 15 Aug 2024 15:22:59 +0200
Message-ID: <20240815131854.449625304@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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
@@ -941,6 +941,7 @@ void tick_broadcast_switch_to_oneshot(vo
 #ifdef CONFIG_HOTPLUG_CPU
 void hotplug_cpu__broadcast_tick_pull(int deadcpu)
 {
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	struct clock_event_device *bc;
 	unsigned long flags;
 
@@ -948,6 +949,28 @@ void hotplug_cpu__broadcast_tick_pull(in
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


