Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17218213EFC;
	Tue, 12 Nov 2024 10:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407380; cv=none; b=A8lB+mCuG2P/KTAV5UehbHg7QQe2UQ21pCEZ0gX4ViyIlyvM45oWkw2AcWWqZ0zckXeojNonLj/SnCq4w2JrCcwM1y0rke7dRxLzqlAqpbvVJuvulRRzbZ43B2MIleRntERmFOjKn2jc88bnNy8iP157crhyp2BwxCtmbpZmuaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407380; c=relaxed/simple;
	bh=+Fjx6AAawz1MbfoM2z6/aJrlxi4u9xrSWj5FaB/ksB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ec+aC5xFjvQHV7OcTaa/jeMgQX6Skf8RMaC7CTO1XPOfN3FzpxMcUxyZHMWMa+yZ9x6/PNF6jc2KdBeays1yjEowRVhSOsunnqmA23nY0TYaHj67k5Pz+FhO+5ZzsXXPgjLKm4AFRS6N+pKdP92+89mH0DnlVXSSycTV4ugQYVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPl5bpT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPl5bpT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84209C4CECD;
	Tue, 12 Nov 2024 10:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407380;
	bh=+Fjx6AAawz1MbfoM2z6/aJrlxi4u9xrSWj5FaB/ksB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPl5bpT3FWsXDaWu9QEbO8AT6g3PPC7e/FfTdOacJNRxPTY1B4IiFmJ62vDKIXX6q
	 x2uP5QF6fXXItqOg3mR1y809eoM4LUY18WWNaR3OU1YXQ5tCzDr26snPsO0PjMTQ9E
	 WlgqF92w4HiUSxiJXdhABK06QtZihTtoI2cO4diA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.1 59/98] thermal/drivers/qcom/lmh: Remove false lockdep backtrace
Date: Tue, 12 Nov 2024 11:21:14 +0100
Message-ID: <20241112101846.513662974@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit f16beaaee248eaa37ad40b5905924fcf70ae02e3 upstream.

Annotate LMH IRQs with lockdep classes so that the lockdep doesn't
report possible recursive locking issue between LMH and GIC interrupts.

For the reference:

       CPU0
       ----
  lock(&irq_desc_lock_class);
  lock(&irq_desc_lock_class);

 *** DEADLOCK ***

Call trace:
 dump_backtrace+0x98/0xf0
 show_stack+0x18/0x24
 dump_stack_lvl+0x90/0xd0
 dump_stack+0x18/0x24
 print_deadlock_bug+0x258/0x348
 __lock_acquire+0x1078/0x1f44
 lock_acquire+0x1fc/0x32c
 _raw_spin_lock_irqsave+0x60/0x88
 __irq_get_desc_lock+0x58/0x98
 enable_irq+0x38/0xa0
 lmh_enable_interrupt+0x2c/0x38
 irq_enable+0x40/0x8c
 __irq_startup+0x78/0xa4
 irq_startup+0x78/0x168
 __enable_irq+0x70/0x7c
 enable_irq+0x4c/0xa0
 qcom_cpufreq_ready+0x20/0x2c
 cpufreq_online+0x2a8/0x988
 cpufreq_add_dev+0x80/0x98
 subsys_interface_register+0x104/0x134
 cpufreq_register_driver+0x150/0x234
 qcom_cpufreq_hw_driver_probe+0x2a8/0x388
 platform_probe+0x68/0xc0
 really_probe+0xbc/0x298
 __driver_probe_device+0x78/0x12c
 driver_probe_device+0x3c/0x160
 __device_attach_driver+0xb8/0x138
 bus_for_each_drv+0x84/0xe0
 __device_attach+0x9c/0x188
 device_initial_probe+0x14/0x20
 bus_probe_device+0xac/0xb0
 deferred_probe_work_func+0x8c/0xc8
 process_one_work+0x20c/0x62c
 worker_thread+0x1bc/0x36c
 kthread+0x120/0x124
 ret_from_fork+0x10/0x20

Fixes: 53bca371cdf7 ("thermal/drivers/qcom: Add support for LMh driver")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241011-lmh-lockdep-v1-1-495cbbe6fef1@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/qcom/lmh.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/thermal/qcom/lmh.c
+++ b/drivers/thermal/qcom/lmh.c
@@ -73,7 +73,14 @@ static struct irq_chip lmh_irq_chip = {
 static int lmh_irq_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
 {
 	struct lmh_hw_data *lmh_data = d->host_data;
+	static struct lock_class_key lmh_lock_key;
+	static struct lock_class_key lmh_request_key;
 
+	/*
+	 * This lock class tells lockdep that GPIO irqs are in a different
+	 * category than their parents, so it won't report false recursion.
+	 */
+	irq_set_lockdep_class(irq, &lmh_lock_key, &lmh_request_key);
 	irq_set_chip_and_handler(irq, &lmh_irq_chip, handle_simple_irq);
 	irq_set_chip_data(irq, lmh_data);
 


