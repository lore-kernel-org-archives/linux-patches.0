Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E48321445;
	Sat, 17 Oct 2026 17:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257347; cv=none; b=DwRX3bYO2xAhkkjeSC9oCxLoFOjOEd+z0RMH7ap9TaZLaAiGWMMrroE/Ol8uaAg8mZhqYSNQcdxk5tKpw6KCaq6QagiHZi6tpR38F6/yooTo5b/GtjlQAU/S/IcnGyxGeTHgeuCC6PvOKdDrSlxbyLmidBp5KV7h3kILy3EH0h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257347; c=relaxed/simple;
	bh=g1WSkHP45QFeiU0m+ROsPcGK15WQKAdEhpONYMxzaxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpUVgRg61oMgKfAtfdY/hoeIq4tz2Y00JDb6RTPYpKQLils0/DIIWrq/BqU1Yutp8XYf94hwDMd+CLSQllkXVLeJeBzRIeHdQ1SKUyt8LqxsztzAIDBQvNAfvN/rmcc8+dodt9KIxtVlHre2hnPp89HEJ1dNRYj0FjBrdsWciqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1u2yYYSn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1u2yYYSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4371F000C4;
	Sat, 17 Oct 2026 17:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257345;
	bh=tHHVYWvJUrjFK6Bsgvn2OwYJJmRK4X2NwtC6KAkbtnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1u2yYYSnq3qAGcHLBXZhG7dFFaVq1Y0cq6RdF2zA+5DZn5S9vcnCUS+edtM2Gvz3a
	 nRnFDNy89UUY1f8rxfYHu4+NtNJnc1uDvNqRoe4mN6dsvCPQjM5xz7w/2P/ycMFwXL
	 fFb3OulwHVhR3nyYEest9THKonIuwKxMgLL7fFWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 0523/1674] drm/i915/gt: Unmask interrupts only when ACTIVE is true
Date: Sat, 17 Oct 2026 17:46:35 +0200
Message-ID: <20261017160444.531158453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Karas <krzysztof.karas@intel.com>

commit 5346b1cec6afa4f9b4b49a9f84e3cfef95a3f7bb upstream.

There is a small race window between intel_rps_boost() reading
a stale ACTIVE state and queuing rps->work, where ACTIVE may be
changed via asynchronous calls triggered by wakeref drop.
This means that rps_work() could be triggered after the GT has
been parked, so unmasking RPS PM interrupts would happen without
holding PM wakelock. This sequence of events may be observed
during live_rc6_ctx_wa() selftest:

1) live_rc6_ctx_wa()
   -> intel_engine_pm_put()
      -> wakeref_put()

ASYNC1) wakeref_put() callback
          -> __engine_park()
             -> intel_gt_pm_put_async()
                -> intel_gt_pm_put_async_untracked()
                   -> intel_wakeref_put_async()

ASYNC2) wakeref_put_async() callback
          -> __gt_park()
             -> intel_rps_park()
                -> intel_rps_clear_active() [clear ACTIVE]
                WITH INTERRUPTS:
                -> rps_disable_interrupts()
                   -> cancel_work_sync(rps->work)
                   -> rps_reset_interrupts() [rps->pm_iir = 0]
                WITHOUT INTERRUPTS (TIMER mode):
                -> rps_stop_timer()
                   -> cancel_work_sync(rps->work)

2) live_rc6_ctx_wa()
   -> intel_gt_wait_for_idle()
      -> intel_gt_retire_requests_timeout()
         -> dma_fence_wait_timeout()
            -> ops->wait() [i915_fence_wait()]
               -> i915_request_wait_timeout()
                  -> intel_rps_boost()
                     -> intel_rps_is_active() [check ACTIVE]
                        [OPEN RACE WINDOW]
                     -> queue_work(rps->work)
         -> retire_requests()
            -> i915_request_retire()
               -> intel_rps_dec_waiters() [from 1 to 0]

If ASYNC1 and ASYNC2 would execute during [OPEN RACE WINDOW],
then:

3) rps_work() executes from the workqueue and may satisfy
   "(!pm_iir && !client_boost)" test (in TIMER mode rps->pm_iir
   is zeroed by an earlier rps_work() call or never gets a new
   value after previous intel_rps_unpark() event), so it jumps
   to "out" label, bypassing intel_rps_is_active() guard and
   executes gen6_gt_pm_unmask_irq();

4) GT is parked and runtime PM wakelock is dropped, so only
   a raw reference in __gt_park() ->
   intel_display_power_put_async() remains for 100ms, then the
   MMIO write in gen6_gt_pm_unmask_irq() detects missing
   wakelock via assert_rpm_wakelock_held() and emits
   "RPM wakelock ref not held during HW access" tainting kernel.

Commit 3e7abf814193 ("drm/i915: Extract GT render power state management")
dropped the "if (rps->interrupts_enabled)" guard that
gen6_pm_rps_work() had around this unmask in i915_irq.c.
INTEL_RPS_ACTIVE brackets the same window, since it is set in
intel_rps_unpark() before rps_enable_interrupts() and
rps_start_timer() and cleared in intel_rps_park() before
rps_stop_timer() and rps_disable_interrupts().

Skip unmasking when RPS is no longer active (reaching unmask
operation is independent of INTERRUPT mode). This does not
prevent RPS operation from resuming on the next unpark.
In interrupt mode, intel_rps_unpark() calls
rps_enable_interrupts(), which enables and unmasks the PM
interrupts. In timer mode, it calls rps_start_timer(),
restarting periodic engine-busyness evaluation. The timer
generates software RPS events and queues rps_work() directly,
independently of PM interrupt delivery. Neither mode requires
the late worker to unmask interrupts while the GT is parked

Fixes: 3e7abf814193 ("drm/i915: Extract GT render power state management")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/16562
Cc: stable@vger.kernel.org # v5.5+
Assisted-by: GitHub-Copilot:claude-opus-5
Assisted-by: GitHub-Copilot:gpt-6-astra
Signed-off-by: Krzysztof Karas <krzysztof.karas@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patch.msgid.link/20260910081329.3300417-1-krzysztof.karas@intel.com
(cherry picked from commit ca4a6deadad15b91ee083afe445fa6bdbfb68206)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_rps.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -1886,7 +1886,8 @@ static void rps_work(struct work_struct
 
 out:
 	spin_lock_irq(gt->irq_lock);
-	gen6_gt_pm_unmask_irq(gt, rps->pm_events);
+	if (intel_rps_is_active(rps))
+		gen6_gt_pm_unmask_irq(gt, rps->pm_events);
 	spin_unlock_irq(gt->irq_lock);
 }
 


