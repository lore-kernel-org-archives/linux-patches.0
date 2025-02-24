Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B055A1946DF;
	Mon, 24 Feb 2025 14:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409061; cv=none; b=hm/0r+x0qZOXKvjpTEPDnaZrkxjR+bHX0CdgRPrmjmxp5taJPiHgKidXZlW4Cl7WBBsrX8FPzG1wMwHb/a3Mwx0e5BGsd1Be84NNwfoi3elBR4f7Hre+xaZ/yC8/VxDw5fS2UJ3lxby3n6CYBxMkExLNwoTLLAx7+V98zkgtBlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409061; c=relaxed/simple;
	bh=odnbsf9p0bTjZXsX71lDJxkw41DiscYetvvlZDu1ZJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmI0Jbvnfdv69CYppUVb86ILd7KN+GTyi7iI7FwQLugryA/9h0WFDcZ0SMXhZcWaW49b69NuAC0uxGfPIsv3BiPX9279vInNDpNTokGL6sMVqTPYDS8JJMWiZRAYvygIF20T9laxr4VxC//jsoKXIz+0K13971sEgbJI7+2Rkd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jw4sUHkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jw4sUHkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD7AC4CED6;
	Mon, 24 Feb 2025 14:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409061;
	bh=odnbsf9p0bTjZXsX71lDJxkw41DiscYetvvlZDu1ZJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jw4sUHknvyq5aXXHWrKKxjqhyxlyC6shtaqcNDU8vIKt99tjGMVSmzWN+e7ji4gFX
	 dbvP4Vi5XT9meXU4c4QH953LKu2NKx8px5sislikZ+spK/tPhARhB1SIK+G1C5EDHI
	 AwtPYSc3QUG60JRMDdyW5whUXGilicBwsZPeqpos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Rojek <contact@artur-rojek.eu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Uros Bizjak <ubizjak@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 085/138] irqchip/jcore-aic, clocksource/drivers/jcore: Fix jcore-pit interrupt request
Date: Mon, 24 Feb 2025 15:35:15 +0100
Message-ID: <20250224142607.818777744@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



