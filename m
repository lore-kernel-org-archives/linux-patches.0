Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA51F26D4F9;
	Wed, 30 Jul 2025 09:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868217; cv=none; b=MTQUjJk1f8SEB3o9va125f/ZAbGdhny41e7yxzTirDHISlQduTBPCP4eRf0iCJVvE6hSBLLsurQyJZgvZhZ86LzgZxIDz2GS1S60DQdnixnZLP2l5H/Ms8TyNXfxppD4Y/2mgly8631WBzLNfYGeDtU3lCWlKUPpox5ZrXo1m9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868217; c=relaxed/simple;
	bh=mYsTNTamxS5CCGcfl3/A8G8ax7dJTiOKL0HI1Rorgi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyHy82YbXy3S2kf3DYpc+khEl2HeI6DvBhAGej4BXwipYwgzMphnWEHUklooRSadNeSNBxxd6sN2+Zxle7KluSKkYAC9l93j2ZwmN1ROyvqCaIYfnuXBgZmR+sOj4E/Edwv+nrrq2d9KiJtluV5vZcL5wVjQ5MJ8S+kHeHI9PpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ViSUshSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViSUshSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A38C4CEE7;
	Wed, 30 Jul 2025 09:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868217;
	bh=mYsTNTamxS5CCGcfl3/A8G8ax7dJTiOKL0HI1Rorgi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ViSUshSdF1X9TPHFHiC/nRpnU0xaB3LWMHCldN8+jvhlEPuX/rfG894nT98x2Edd5
	 lWqyusglRKETmtuytmyLZJxRcVc8VqKBoYyUVUx8oIG9+u1Ze4tVU5TyMUPqPAIw/u
	 lKpS85iBcUuF0ODXdrKLS+sUYM07fdP6FWdnFOk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 01/76] Input: gpio-keys - fix a sleep while atomic with PREEMPT_RT
Date: Wed, 30 Jul 2025 11:34:54 +0200
Message-ID: <20250730093226.912243258@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit f4a8f561d08e39f7833d4a278ebfb12a41eef15f upstream.

When enabling PREEMPT_RT, the gpio_keys_irq_timer() callback runs in
hard irq context, but the input_event() takes a spin_lock, which isn't
allowed there as it is converted to a rt_spin_lock().

[ 4054.289999] BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
[ 4054.290028] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/0
...
[ 4054.290195]  __might_resched+0x13c/0x1f4
[ 4054.290209]  rt_spin_lock+0x54/0x11c
[ 4054.290219]  input_event+0x48/0x80
[ 4054.290230]  gpio_keys_irq_timer+0x4c/0x78
[ 4054.290243]  __hrtimer_run_queues+0x1a4/0x438
[ 4054.290257]  hrtimer_interrupt+0xe4/0x240
[ 4054.290269]  arch_timer_handler_phys+0x2c/0x44
[ 4054.290283]  handle_percpu_devid_irq+0x8c/0x14c
[ 4054.290297]  handle_irq_desc+0x40/0x58
[ 4054.290307]  generic_handle_domain_irq+0x1c/0x28
[ 4054.290316]  gic_handle_irq+0x44/0xcc

Considering the gpio_keys_irq_isr() can run in any context, e.g. it can
be threaded, it seems there's no point in requesting the timer isr to
run in hard irq context.

Relax the hrtimer not to use the hard context.

Fixes: 019002f20cb5 ("Input: gpio-keys - use hrtimer for release timer")
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Link: https://lore.kernel.org/r/20250528-gpio_keys_preempt_rt-v2-1-3fc55a9c3619@foss.st.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ adjusted context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/gpio_keys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -495,7 +495,7 @@ static irqreturn_t gpio_keys_irq_isr(int
 	if (bdata->release_delay)
 		hrtimer_start(&bdata->release_timer,
 			      ms_to_ktime(bdata->release_delay),
-			      HRTIMER_MODE_REL_HARD);
+			      HRTIMER_MODE_REL);
 out:
 	spin_unlock_irqrestore(&bdata->lock, flags);
 	return IRQ_HANDLED;
@@ -632,7 +632,7 @@ static int gpio_keys_setup_key(struct pl
 
 		bdata->release_delay = button->debounce_interval;
 		hrtimer_init(&bdata->release_timer,
-			     CLOCK_REALTIME, HRTIMER_MODE_REL_HARD);
+			     CLOCK_REALTIME, HRTIMER_MODE_REL);
 		bdata->release_timer.function = gpio_keys_irq_timer;
 
 		isr = gpio_keys_irq_isr;


