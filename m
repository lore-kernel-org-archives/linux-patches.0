Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9347823C2
	for <patches@lists.linux.dev>; Tue, 10 May 2022 09:20:04 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1652174402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pGtYIOPDePSrNIMyokVXHcQNltfPtCMsxsULiEstEbQ=;
	b=nPOgK6B8c1YtqNNKXNUYD7yun57LoBc1wOBofPENs/rW4AXitbZvIY5rAPOwmW81HPL4Mh
	S6bLNwV6CkaooK1G6PpkEhHvbuvHHzFYOwT0y617LqGgoXdXNo8EMm2CQoxr/SwSdKGFK4
	zgFtBJ8Q2Ptqu38c0eq0RgB3DYUij15qFF8MjWrMAmiZCAstyOhzPbf//xWp3beC/yGCMo
	ZIRSfGxpEOG8FTF/e92AcAwKtxuPhEH4MMzPVdvbVmEM/EpZu8DH9EuQN4k6unBxfdrFYY
	MTIYgCQEEzFyh2swIIQXST8+xCrGM+1GLMt8dkJ6dqpjRK5lzdp12DYAdaLAsw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1652174402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pGtYIOPDePSrNIMyokVXHcQNltfPtCMsxsULiEstEbQ=;
	b=xh04S0rRh1Uye/zo/UEkIPc5L5YhYfWvr0RuEbdr5lOMYV9CaWAWHS5uavl/A8wLcaa8V/
	QxvpzoQ5MG9LEtDg==
To: Stephen Boyd <swboyd@chromium.org>, John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, Tejun Heo
 <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Guenter Roeck
 <groeck@chromium.org>
Subject: Re: [PATCH] timers: Provide a better debugobjects hint for delayed
 works
In-Reply-To: <20220504223148.644228-1-swboyd@chromium.org>
References: <20220504223148.644228-1-swboyd@chromium.org>
Date: Tue, 10 May 2022 11:20:01 +0200
Message-ID: <87sfphpwvy.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, May 04 2022 at 15:31, Stephen Boyd wrote:
> Provide better information here by special casing delayed works in the
> timer debugobjects hint logic so that the work function is returned
> instead of the timer function delayed_work_timer_fn(). This will help us
> understand what delayed work was pending that got freed, leading to
> faster bug resolutions.

Makes sense.

> ---
> I have an alternative approach which is to treat delayed works with a
> different debug_obj_descr structure but it basically boils down to
> another version of timer debugobjects in the workqueue code. The idea is
> to make the delayed work active once the timer is queued and then
> convert it over from a delayed work descriptor to a work descriptor once
> the timer runs delayed_work_timer_fn() or when we pull it off to flush
> out.

Nah.

>  #include <linux/uaccess.h>
>  #include <asm/unistd.h>
> @@ -617,7 +618,17 @@ static const struct debug_obj_descr timer_debug_descr;
>  
>  static void *timer_debug_hint(void *addr)
>  {
> -	return ((struct timer_list *) addr)->function;
> +	struct timer_list *timer = addr;
> +
> +	if (timer->function == delayed_work_timer_fn) {
> +		struct delayed_work *dwork;
> +
> +		dwork = container_of(timer, struct delayed_work, timer);
> +
> +		return dwork->work.func;
> +	}

The same issue exists for kthread_delayed_work_timer_fn.

So maybe something like the uncompiled/untested below.

Thanks,

        tglx
---
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -638,9 +638,35 @@ static void internal_add_timer(struct ti
 
 static const struct debug_obj_descr timer_debug_descr;
 
+struct timer_hint {
+	void	(*function)(struct timer_list *);
+	long	offset;
+};
+
+#define TIMER_HINT(fn, container, timr, hintfn)			\
+	{							\
+		.function = fn,					\
+		.offset	  = offsetof(container, hintfn) -	\
+			    offsetof(container, timr)	\
+	}
+
+static const struct timer_hint timer_hints[] = {
+	TIMER_HINT(delayed_work_timer_fn,
+		   struct delayed_work, timer, work.func),
+	TIMER_HINT(kthread_delayed_work_timer_fn,
+		   struct kthread_delayed_work, timer, work.func),
+};
+
 static void *timer_debug_hint(void *addr)
 {
-	return ((struct timer_list *) addr)->function;
+	struct timer_list *timer = addr;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(timer_hints); i++) {
+		if (timer_hints[i].function == timer->function)
+			return addr + timer_hints[i].offset;
+	}
+	return timer->function;
 }
 
 static bool timer_is_static_object(void *addr)

