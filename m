Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DAB2D781B;
	Thu, 15 Jan 2026 17:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497049; cv=none; b=LfC7yW3owtQq87PbqnCDq2lrGwgHAq5Z9EU7Ewu+Jaa0SMKddXMSob3jkgTHie+WUc4YC5LF1gNLSt55vvC3aocejmY3+nk6VgVnes5Q98ZVMtp/nukdaq/8HCYCjW+qxf4OrSQ6uAapcKBVmQYLtqjBobYfwbJF7oEAejRMbOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497049; c=relaxed/simple;
	bh=I8W+aG/3zRePFkBX/8hxnKWxjJhJjilHuufJ7iTvI/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FY/Wq3b04f08uewLPbsoOSpVxG6IJbYnyWb7LKqJmHPW0NR/+PWKT4jcV5JPxFnjSdnl+Z+mitAtrEaVMDKzlJl+IK/U1G0X3Oi1hUCpArnkjCCp2wt+Ms85kZ+I1ki0CbwzAC9rOewI1ayn/Edrh/4PUiSQJU39mwEK4RmdLsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGvAtbpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGvAtbpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B455AC116D0;
	Thu, 15 Jan 2026 17:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497049;
	bh=I8W+aG/3zRePFkBX/8hxnKWxjJhJjilHuufJ7iTvI/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGvAtbpz4F8D9MnbuvEsQ48n5CokytHSpUaT2diN5SUv3HuU9qPfZxy6pQ+iUiT7/
	 OUYqJcu5BAHHM5Vclfl2vRkkXR0/gjm43fjakll9WJzics9dNdGD1kuRVHa/ZKm00y
	 kCT9k0wUsQJhWUfUOdoS1g8w6QBTPaZPlJ8BKfYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.1 06/72] counter: interrupt-cnt: Drop IRQF_NO_THREAD flag
Date: Thu, 15 Jan 2026 17:48:16 +0100
Message-ID: <20260115164143.722099028@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit 23f9485510c338476b9735d516c1d4aacb810d46 upstream.

An IRQ handler can either be IRQF_NO_THREAD or acquire spinlock_t, as
CONFIG_PROVE_RAW_LOCK_NESTING warns:
=============================
[ BUG: Invalid wait context ]
6.18.0-rc1+git... #1
-----------------------------
some-user-space-process/1251 is trying to lock:
(&counter->events_list_lock){....}-{3:3}, at: counter_push_event [counter]
other info that might help us debug this:
context-{2:2}
no locks held by some-user-space-process/....
stack backtrace:
CPU: 0 UID: 0 PID: 1251 Comm: some-user-space-process 6.18.0-rc1+git... #1 PREEMPT
Call trace:
 show_stack (C)
 dump_stack_lvl
 dump_stack
 __lock_acquire
 lock_acquire
 _raw_spin_lock_irqsave
 counter_push_event [counter]
 interrupt_cnt_isr [interrupt_cnt]
 __handle_irq_event_percpu
 handle_irq_event
 handle_simple_irq
 handle_irq_desc
 generic_handle_domain_irq
 gpio_irq_handler
 handle_irq_desc
 generic_handle_domain_irq
 gic_handle_irq
 call_on_irq_stack
 do_interrupt_handler
 el0_interrupt
 __el0_irq_handler_common
 el0t_64_irq_handler
 el0t_64_irq

... and Sebastian correctly points out. Remove IRQF_NO_THREAD as an
alternative to switching to raw_spinlock_t, because the latter would limit
all potential nested locks to raw_spinlock_t only.

Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20251117151314.xwLAZrWY@linutronix.de/
Fixes: a55ebd47f21f ("counter: add IRQ or GPIO based counter")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20251118083603.778626-1-alexander.sverdlin@siemens.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/interrupt-cnt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/counter/interrupt-cnt.c
+++ b/drivers/counter/interrupt-cnt.c
@@ -229,8 +229,7 @@ static int interrupt_cnt_probe(struct pl
 
 	irq_set_status_flags(priv->irq, IRQ_NOAUTOEN);
 	ret = devm_request_irq(dev, priv->irq, interrupt_cnt_isr,
-			       IRQF_TRIGGER_RISING | IRQF_NO_THREAD,
-			       dev_name(dev), counter);
+			       IRQF_TRIGGER_RISING, dev_name(dev), counter);
 	if (ret)
 		return ret;
 


