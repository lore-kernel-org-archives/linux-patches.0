Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B5422FF35;
	Mon, 23 Jun 2025 13:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684619; cv=none; b=CmjJ9PlLEFjPdpTDz/yMWDCY1BQWruwzSZoh9rBVBSRsKthQwzekMC2gPBZP4z638lN7a+Vk8uPHysSx5/2qGpoQHgrGLJO8WRpxi6pFgC7NgLe7lptvFsV3g4/veEwtVqcIIEWyMFgZ14Zo0CltDmnLDpNaAh4Wdgnh1nHpTc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684619; c=relaxed/simple;
	bh=DnrPAZA7rOmmwBAijl3QvTQ7VRFrDqihiokSMyAFGlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdzzDCwHQ7Yipy2WnluJAXk0dioCV7pOxoOYdmj17gWo4lj1BCWijCv2X5vbLvIWZb/qCSo8JIy7mDKVQqj4HWAtJLpVi8RtXdQv1timHXHkCQTJRhRfoC1rJzjxusLEhqh2FWzDFQuv8hLjU8osIfmXRGOTwdNive9xF0ep5+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rUSD/X8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rUSD/X8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3F9C4CEEA;
	Mon, 23 Jun 2025 13:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684619;
	bh=DnrPAZA7rOmmwBAijl3QvTQ7VRFrDqihiokSMyAFGlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rUSD/X8wWi1tNcJdZCE66x75DOcN+deFDR++KNMfWlbXSIAt+ytkr6lWXIok4iAa
	 c/bt0+PvgSuHf3QyYDHjXC1d0cazOmd9cI/70boLATW4XP0eeQ62pbCq88i1I0T/zF
	 dKcn0y/m96FXHMpxEB2SO4yLn8WoGzrhUzCDguE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.15 119/592] Input: gpio-keys - fix a sleep while atomic with PREEMPT_RT
Date: Mon, 23 Jun 2025 15:01:17 +0200
Message-ID: <20250623130703.100917577@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/gpio_keys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -486,7 +486,7 @@ static irqreturn_t gpio_keys_irq_isr(int
 	if (bdata->release_delay)
 		hrtimer_start(&bdata->release_timer,
 			      ms_to_ktime(bdata->release_delay),
-			      HRTIMER_MODE_REL_HARD);
+			      HRTIMER_MODE_REL);
 out:
 	return IRQ_HANDLED;
 }
@@ -628,7 +628,7 @@ static int gpio_keys_setup_key(struct pl
 
 		bdata->release_delay = button->debounce_interval;
 		hrtimer_setup(&bdata->release_timer, gpio_keys_irq_timer,
-			      CLOCK_REALTIME, HRTIMER_MODE_REL_HARD);
+			      CLOCK_REALTIME, HRTIMER_MODE_REL);
 
 		isr = gpio_keys_irq_isr;
 		irqflags = 0;


