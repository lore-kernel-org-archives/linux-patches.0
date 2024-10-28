Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562488837;
	Mon, 28 Oct 2024 06:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097927; cv=none; b=n5P/vMW1wPn53ubexl9xt8qgJnzF41oV6q6WZr6DEX7uHyLa09cmjcK4Xd2esM6Zb3WYW3F3WWEqHfjVO9zeqp503/a3VmLhXR/p/VJfSx9KgpCjsRCvOfm+ZZvmlZoFcCLoacJgC/dezplmIyMJH7f64U+qi1CzR60TQApeIQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097927; c=relaxed/simple;
	bh=V+YLAFC5i6ULhrkyC56E9FnDYobR2VLRUH4eALv9hHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2KPQ0FiHvG2gMe/KPM9nc1jSnm35HLD9oBe1UIE/zECiHwp5I21WdZbzyMl4/H5qJC39BicMNzfqQFcAbK9c6yRLe9KbhUigrV4Vd0sF3u3joQF4YHqbDD3IUeX3RYynAvvAlXvx7erv07PA+svdtN0UOXf02dPsLyt+CDxLwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OM6hx9D8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OM6hx9D8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73E4C4CEC3;
	Mon, 28 Oct 2024 06:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097927;
	bh=V+YLAFC5i6ULhrkyC56E9FnDYobR2VLRUH4eALv9hHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OM6hx9D891/XlMqL0a0wd4JRzI9hW9xO2MZ7eqDGxlUGLcw5me04ihUhJp0mWwzBD
	 5waJWTHPF6gNPiT2AajDjzXofgNo43I3FofI0IipnyCeRccbQLdDFZnqpzSU2QQBtr
	 gfGcnEG4chcpUSJRsRSlRmvVWk4mNZLK/xEFW/xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	"kernelci.org bot" <bot@kernelci.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 208/208] task_work: make TWA_NMI_CURRENT handling conditional on IRQ_WORK
Date: Mon, 28 Oct 2024 07:26:28 +0100
Message-ID: <20241028062311.771469998@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit cec6937dd1aae1b38d147bd190cb895d06cf96d0 upstream.

The TWA_NMI_CURRENT handling very much depends on IRQ_WORK, but that
isn't universally enabled everywhere.

Maybe the IRQ_WORK infrastructure should just be unconditional - x86
ends up indirectly enabling it through unconditionally enabling
PERF_EVENTS, for example.  But it also gets enabled by having SMP
support, or even if you just have PRINTK enabled.

But in the meantime TWA_NMI_CURRENT causes tons of build failures on
various odd minimal configs.  Which did show up in linux-next, but
despite that nobody bothered to fix it or even inform me until -rc1 was
out.

Fixes: 466e4d801cd4 ("task_work: Add TWA_NMI_CURRENT as an additional notify mode")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: kernelci.org bot <bot@kernelci.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/task_work.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -6,12 +6,14 @@
 
 static struct callback_head work_exited; /* all we need is ->next == NULL */
 
+#ifdef CONFIG_IRQ_WORK
 static void task_work_set_notify_irq(struct irq_work *entry)
 {
 	test_and_set_tsk_thread_flag(current, TIF_NOTIFY_RESUME);
 }
 static DEFINE_PER_CPU(struct irq_work, irq_work_NMI_resume) =
 	IRQ_WORK_INIT_HARD(task_work_set_notify_irq);
+#endif
 
 /**
  * task_work_add - ask the @task to execute @work->func()
@@ -59,6 +61,8 @@ int task_work_add(struct task_struct *ta
 	if (notify == TWA_NMI_CURRENT) {
 		if (WARN_ON_ONCE(task != current))
 			return -EINVAL;
+		if (!IS_ENABLED(CONFIG_IRQ_WORK))
+			return -EINVAL;
 	} else {
 		/*
 		 * Record the work call stack in order to print it in KASAN
@@ -92,9 +96,11 @@ int task_work_add(struct task_struct *ta
 	case TWA_SIGNAL_NO_IPI:
 		__set_notify_signal(task);
 		break;
+#ifdef CONFIG_IRQ_WORK
 	case TWA_NMI_CURRENT:
 		irq_work_queue(this_cpu_ptr(&irq_work_NMI_resume));
 		break;
+#endif
 	default:
 		WARN_ON_ONCE(1);
 		break;


