Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDE23112B4;
	Mon, 13 Oct 2025 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369050; cv=none; b=rYOQITDkIjzPqbBk7C5OABm8T2zPw5UIkNXCujc2Ev+z/1o0B0TdnhreMNpJTVYCORT70DWW13R6Q2tlc8sF9wvznjwT05y4WG0dpKJYOnIjXHo/x8oOfZc49VZNCxR6H/j3Q/PE5+TIB79NeC/ypjueFpOtJBa5Ca/8PcILHx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369050; c=relaxed/simple;
	bh=xJogdsl6cmUWTs9ixDF5/KhfzW4bYvCjHpVOqvRpbdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1PRMqwB/QsTvvsr/QVEtBMhhddXdpdkVddgGd8wP8sCCHwc+Ja6TlFrectsJzcKlcf+ZXLsSrRyqXVLWtJUdeHj01Pv9pkg4NUpi3IgM5sSqoC98U7D8vS+c7wpAiHdXDVZwzYi9xMsLxC9atYvT5qfT8+Yhwly46g+qjKH+14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgCQGA1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgCQGA1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EEEC4CEFE;
	Mon, 13 Oct 2025 15:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369049;
	bh=xJogdsl6cmUWTs9ixDF5/KhfzW4bYvCjHpVOqvRpbdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgCQGA1MxgZ7qJ26eDPxQRG5JEMdBrwZA3LNNutQJhXvpeGH7VLlkerkKBl5KxJGB
	 37FH5uRfGrBeCTR/R+4VkTUTq+u76ERFO4vKaX3hZ4+qCeBahnOMLIM7lJP+Ghjk8h
	 X2QRUZzHVMKgbKIvU4H+t0s/Ulgrdasc2TuCNos8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 110/563] tick: Do not set device to detached state in tick_shutdown()
Date: Mon, 13 Oct 2025 16:39:31 +0200
Message-ID: <20251013144415.279043368@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit fe2a449a45b13df1562419e0104b4777b6ea5248 ]

tick_shutdown() sets the state of the clockevent device to detached
first and the invokes clockevents_exchange_device(), which in turn
invokes clockevents_switch_state().

But clockevents_switch_state() returns without invoking the device shutdown
callback as the device is already in detached state. As a consequence the
timer device is not shutdown when a CPU goes offline.

tick_shutdown() does this because it was originally invoked on a online CPU
and not on the outgoing CPU. It therefore could not access the clockevent
device of the already offlined CPU and just set the state.

Since commit 3b1596a21fbf tick_shutdown() is called on the outgoing CPU, so
the hardware device can be accessed.

Remove the state set before calling clockevents_exchange_device(), so that
the subsequent clockevents_switch_state() handles the state transition and
invokes the shutdown callback of the clockevent device.

[ tglx: Massaged change log ]

Fixes: 3b1596a21fbf ("clockevents: Shutdown and unregister current clockevents at CPUHP_AP_TICK_DYING")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/all/20250906064952.3749122-2-maobibo@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clockevents.c   |  2 +-
 kernel/time/tick-common.c   | 16 +++++-----------
 kernel/time/tick-internal.h |  2 +-
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index f3e831f62906f..a59bc75ab7c5b 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -633,7 +633,7 @@ void tick_offline_cpu(unsigned int cpu)
 	raw_spin_lock(&clockevents_lock);
 
 	tick_broadcast_offline(cpu);
-	tick_shutdown(cpu);
+	tick_shutdown();
 
 	/*
 	 * Unregister the clock event devices which were
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 9a3859443c042..7e33d3f2e889b 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -411,24 +411,18 @@ int tick_cpu_dying(unsigned int dying_cpu)
 }
 
 /*
- * Shutdown an event device on a given cpu:
+ * Shutdown an event device on the outgoing CPU:
  *
- * This is called on a life CPU, when a CPU is dead. So we cannot
- * access the hardware device itself.
- * We just set the mode and remove it from the lists.
+ * Called by the dying CPU during teardown, with clockevents_lock held
+ * and interrupts disabled.
  */
-void tick_shutdown(unsigned int cpu)
+void tick_shutdown(void)
 {
-	struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	struct clock_event_device *dev = td->evtdev;
 
 	td->mode = TICKDEV_MODE_PERIODIC;
 	if (dev) {
-		/*
-		 * Prevent that the clock events layer tries to call
-		 * the set mode function!
-		 */
-		clockevent_set_state(dev, CLOCK_EVT_STATE_DETACHED);
 		clockevents_exchange_device(dev, NULL);
 		dev->event_handler = clockevents_handle_noop;
 		td->evtdev = NULL;
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index faac36de35b9e..4e4f7bbe2a64b 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -26,7 +26,7 @@ extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
 extern void tick_check_new_device(struct clock_event_device *dev);
 extern void tick_offline_cpu(unsigned int cpu);
-extern void tick_shutdown(unsigned int cpu);
+extern void tick_shutdown(void);
 extern void tick_suspend(void);
 extern void tick_resume(void);
 extern bool tick_check_replacement(struct clock_event_device *curdev,
-- 
2.51.0



