Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4410E1885B8;
	Mon, 24 Feb 2025 14:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408600; cv=none; b=YE4GCcZi2/9BjYO7KXaPvssSFaztTbIMrnjpdovJbTV5s4ynQVb2oGozbJDKhGdO3UkGMo9awSpda0/ttG9X7UMSaqXrsYpfxM9VXlwVv3G7j/2yr+t2852qDtDh9IiDcWS/rnyvjAkN9dForH94i7cJefUSILB5fylnfHj2xQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408600; c=relaxed/simple;
	bh=+eZoJ88QDrWFPe8xZr4K7aKW/OrMEh6BXiXD0Jg81co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOQReuJS7L9fNpFtH0J5EF7relw5tUFeD4OeAN/l4qFN3lEztBIgHgqCfXwYrdfeIIhwiPBDhgZP8s9rf86Og1vaiUZX17/2zpSMr5S5LImUFnMn6lrc9x2xcQJq3S/pp8ZAy4YlIU606s0Wg34I/viVOaOOTCpLQLInsejr024=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3wIX1Mz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3wIX1Mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A7BC4CED6;
	Mon, 24 Feb 2025 14:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408599;
	bh=+eZoJ88QDrWFPe8xZr4K7aKW/OrMEh6BXiXD0Jg81co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3wIX1Mz/RIX6hhKRk01BCSyBU6FGqfF5V+9XaWgCOe7mj0DYQdKbeg8NEHy+Ft9H
	 9KhQTQeavkjZSbV6vQl0K+0a9nnIpoxL1OrPfH9ImDznOSEDTwFB9z+Cl2UA+ydRa/
	 JcChyuJThjdjvTioXw7QIAwgjAqi5rmZsyzLKzko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Rojek <contact@artur-rojek.eu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Uros Bizjak <ubizjak@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/154] irqchip/jcore-aic, clocksource/drivers/jcore: Fix jcore-pit interrupt request
Date: Mon, 24 Feb 2025 15:35:04 +0100
Message-ID: <20250224142611.170996790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artur Rojek <contact@artur-rojek.eu>

[ Upstream commit d7e3fd658248f257006227285095d190e70ee73a ]

The jcore-aic irqchip does not have separate interrupt numbers reserved for
cpu-local vs global interrupts. Therefore the device drivers need to
request the given interrupt as per CPU interrupt.

69a9dcbd2d65 ("clocksource/drivers/jcore: Use request_percpu_irq()")
converted the clocksource driver over to request_percpu_irq(), but failed
to do add all the required changes, resulting in a failure to register PIT
interrupts.

Fix this by:

 1) Explicitly mark the interrupt via irq_set_percpu_devid() in
    jcore_pit_init().

 2) Enable and disable the per CPU interrupt in the CPU hotplug callbacks.

 3) Pass the correct per-cpu cookie to the irq handler by using
    handle_percpu_devid_irq() instead of handle_percpu_irq() in
    handle_jcore_irq().

[ tglx: Massage change log ]

Fixes: 69a9dcbd2d65 ("clocksource/drivers/jcore: Use request_percpu_irq()")
Signed-off-by: Artur Rojek <contact@artur-rojek.eu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Uros Bizjak <ubizjak@gmail.com>
Link: https://lore.kernel.org/all/20250216175545.35079-3-contact@artur-rojek.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/jcore-pit.c | 15 ++++++++++++++-
 drivers/irqchip/irq-jcore-aic.c |  2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/jcore-pit.c b/drivers/clocksource/jcore-pit.c
index a3fe98cd38382..82815428f8f92 100644
--- a/drivers/clocksource/jcore-pit.c
+++ b/drivers/clocksource/jcore-pit.c
@@ -114,6 +114,18 @@ static int jcore_pit_local_init(unsigned cpu)
 	pit->periodic_delta = DIV_ROUND_CLOSEST(NSEC_PER_SEC, HZ * buspd);
 
 	clockevents_config_and_register(&pit->ced, freq, 1, ULONG_MAX);
+	enable_percpu_irq(pit->ced.irq, IRQ_TYPE_NONE);
+
+	return 0;
+}
+
+static int jcore_pit_local_teardown(unsigned cpu)
+{
+	struct jcore_pit *pit = this_cpu_ptr(jcore_pit_percpu);
+
+	pr_info("Local J-Core PIT teardown on cpu %u\n", cpu);
+
+	disable_percpu_irq(pit->ced.irq);
 
 	return 0;
 }
@@ -168,6 +180,7 @@ static int __init jcore_pit_init(struct device_node *node)
 		return -ENOMEM;
 	}
 
+	irq_set_percpu_devid(pit_irq);
 	err = request_percpu_irq(pit_irq, jcore_timer_interrupt,
 				 "jcore_pit", jcore_pit_percpu);
 	if (err) {
@@ -237,7 +250,7 @@ static int __init jcore_pit_init(struct device_node *node)
 
 	cpuhp_setup_state(CPUHP_AP_JCORE_TIMER_STARTING,
 			  "clockevents/jcore:starting",
-			  jcore_pit_local_init, NULL);
+			  jcore_pit_local_init, jcore_pit_local_teardown);
 
 	return 0;
 }
diff --git a/drivers/irqchip/irq-jcore-aic.c b/drivers/irqchip/irq-jcore-aic.c
index b9dcc8e78c750..1f613eb7b7f03 100644
--- a/drivers/irqchip/irq-jcore-aic.c
+++ b/drivers/irqchip/irq-jcore-aic.c
@@ -38,7 +38,7 @@ static struct irq_chip jcore_aic;
 static void handle_jcore_irq(struct irq_desc *desc)
 {
 	if (irqd_is_per_cpu(irq_desc_get_irq_data(desc)))
-		handle_percpu_irq(desc);
+		handle_percpu_devid_irq(desc);
 	else
 		handle_simple_irq(desc);
 }
-- 
2.39.5



