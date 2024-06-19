Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B7913DDC0;
	Wed, 19 Jun 2024 13:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804078; cv=none; b=SNoZrR/MTPePpIjv6nFXxOfek6+WI9HHsikwqVzZYbzj1UgAdkescQvnbClvI6ig6j79/Epora6I/Pgku+li9147dtyxiW2VPC8CLrN5kEdlMcB4KqQdVcxcN4TSt+2ZkWtxGhY0kR/QEDGOlDgg/HrdyQCfI11PpysjILHYyE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804078; c=relaxed/simple;
	bh=Nfd7LJdyiZ+cvEF3CRmaU23OrGnyiBty4l5umyEVJi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQ5ycLXEGD4URafNzSDb7Prcb9JLNqfmn+yYRuArE5USePzmzbte2RcbdiNsZtiQPer2d4v/aLmRxjXcgB7YxA7wpvFUsLqANOCE5PGhtypeX3K3HRpBW9IbVevpCaH2zP7POO+hwCzVnPGCrOhxkH5YruGdq0bRtyQuWcwVPSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nzac4ZrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nzac4ZrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ADDC2BBFC;
	Wed, 19 Jun 2024 13:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804078;
	bh=Nfd7LJdyiZ+cvEF3CRmaU23OrGnyiBty4l5umyEVJi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nzac4ZrHZ2b9rd2M0AGejpzLXn5vjVWlI2Bj2SBzpRDtiqhTD4YHR+dJimalFYgkA
	 Ij11GzCseIWiicm3KOYOg/HJEXKSTL69b92zZ7cUBia/4J8Se6/eml3IP98ENwc548
	 Y0P5O8BCnWfJAh8XhkgoxrDniqPeI1VzjXjrH7Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 200/217] tick/nohz_full: Dont abuse smp_call_function_single() in tick_setup_device()
Date: Wed, 19 Jun 2024 14:57:23 +0200
Message-ID: <20240619125604.403349324@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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
 


