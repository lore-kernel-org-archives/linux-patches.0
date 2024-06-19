Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8CA14389C;
	Wed, 19 Jun 2024 13:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802573; cv=none; b=Owhjt4o2q3WK7aH8xB+8CoVp1s+qugSu9TyzMniJ+xzVRFmtih9kIKg1HnjP8bSfis+MR04LzzlWvHz9Q8TD0uM2/AmguddO1YdATc9k6mAWf6PF/R21pB0Kuyv8d1OSQjPqV2zKCal1WRdDzV1unmTItv0GS5VLvbbCBSFp54Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802573; c=relaxed/simple;
	bh=WUy4inRCfvkQ5KUGTYVY7zcBbrLslhyD2Nuuocp7vyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLDqVUnP1yQme7beIf3xRL8Lm4ETnoQqrXIIr6yLfxAfrNl+tOM6VaMJ0wE/IHYueHFNJWlFXxT6vTIY4EMHkeyJxCNSvnNyXBkn0hyc8J3MXaFu7xZLFkbQEgLMc0EYlm231CrBK6EtYf8R333e4aGMGAQVPrE+N7zJh2a+FbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptgw9NRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptgw9NRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E353C4AF1A;
	Wed, 19 Jun 2024 13:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802573;
	bh=WUy4inRCfvkQ5KUGTYVY7zcBbrLslhyD2Nuuocp7vyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptgw9NRV9Mc6RJhzjpK246lXQWpmc5h23Yl+E/AdGTaEGG4tyx5ttMnPud4Wx+SwQ
	 Vkomc2b6sJLjFL8ujsAhIO2OCm+hMDT2oI8KFEFZb7NJ9ksEraMPSyYEp9vdK1t/TF
	 MusUnnlN8aZZaq17PBwqUrvxFN7R6IHia8NltNNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 242/267] tick/nohz_full: Dont abuse smp_call_function_single() in tick_setup_device()
Date: Wed, 19 Jun 2024 14:56:33 +0200
Message-ID: <20240619125615.611673215@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 07c54cc5988f19c9642fd463c2dbdac7fc52f777 upstream.

After the recent commit 5097cbcb38e6 ("sched/isolation: Prevent boot crash
when the boot CPU is nohz_full") the kernel no longer crashes, but there is
another problem.

In this case tick_setup_device() calls tick_take_do_timer_from_boot() to
update tick_do_timer_cpu and this triggers the WARN_ON_ONCE(irqs_disabled)
in smp_call_function_single().

Kill tick_take_do_timer_from_boot() and just use WRITE_ONCE(), the new
comment explains why this is safe (thanks Thomas!).

Fixes: 08ae95f4fd3b ("nohz_full: Allow the boot CPU to be nohz_full")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240528122019.GA28794@redhat.com
Link: https://lore.kernel.org/all/20240522151742.GA10400@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/tick-common.c |   42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -179,26 +179,6 @@ void tick_setup_periodic(struct clock_ev
 	}
 }
 
-#ifdef CONFIG_NO_HZ_FULL
-static void giveup_do_timer(void *info)
-{
-	int cpu = *(unsigned int *)info;
-
-	WARN_ON(tick_do_timer_cpu != smp_processor_id());
-
-	tick_do_timer_cpu = cpu;
-}
-
-static void tick_take_do_timer_from_boot(void)
-{
-	int cpu = smp_processor_id();
-	int from = tick_do_timer_boot_cpu;
-
-	if (from >= 0 && from != cpu)
-		smp_call_function_single(from, giveup_do_timer, &cpu, 1);
-}
-#endif
-
 /*
  * Setup the tick device
  */
@@ -222,19 +202,25 @@ static void tick_setup_device(struct tic
 			tick_next_period = ktime_get();
 #ifdef CONFIG_NO_HZ_FULL
 			/*
-			 * The boot CPU may be nohz_full, in which case set
-			 * tick_do_timer_boot_cpu so the first housekeeping
-			 * secondary that comes up will take do_timer from
-			 * us.
+			 * The boot CPU may be nohz_full, in which case the
+			 * first housekeeping secondary will take do_timer()
+			 * from it.
 			 */
 			if (tick_nohz_full_cpu(cpu))
 				tick_do_timer_boot_cpu = cpu;
 
-		} else if (tick_do_timer_boot_cpu != -1 &&
-						!tick_nohz_full_cpu(cpu)) {
-			tick_take_do_timer_from_boot();
+		} else if (tick_do_timer_boot_cpu != -1 && !tick_nohz_full_cpu(cpu)) {
 			tick_do_timer_boot_cpu = -1;
-			WARN_ON(tick_do_timer_cpu != cpu);
+			/*
+			 * The boot CPU will stay in periodic (NOHZ disabled)
+			 * mode until clocksource_done_booting() called after
+			 * smp_init() selects a high resolution clocksource and
+			 * timekeeping_notify() kicks the NOHZ stuff alive.
+			 *
+			 * So this WRITE_ONCE can only race with the READ_ONCE
+			 * check in tick_periodic() but this race is harmless.
+			 */
+			WRITE_ONCE(tick_do_timer_cpu, cpu);
 #endif
 		}
 


