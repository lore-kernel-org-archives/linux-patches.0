Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C885F3207
	for <patches@lists.linux.dev>; Wed, 11 May 2022 20:19:53 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id j10-20020a17090a94ca00b001dd2131159aso5975459pjw.0
        for <patches@lists.linux.dev>; Wed, 11 May 2022 13:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gw0Wy/q20wEZd72lzxD2a0cUuCarQEEakePN17Bh29I=;
        b=ErQThYIf24YWagDeM8IZdV77fNmIH8MVxfnwE+zwvUi11262Mv5M9J9uGR9j4Y01e2
         nM/GIe4fwnl7y5kl6kWHmAk+YMuFN2OJh8DjY17hzWWzYxRjMf7qf/bdi3Nkua5220VR
         vB2m10/ou/LIxDWxnxWQ0o2d/HtWPjorXV5oE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gw0Wy/q20wEZd72lzxD2a0cUuCarQEEakePN17Bh29I=;
        b=VdSlDWEzOy/eqTNvVUoAld0LnXOwYGlauza5V2XkgZb8OvrqUkAEEDKmNFc1I0fBy9
         RmmVGurmIK8WgK679rY2az6g5SJZ7Y1HhiX/Brq2YjwQYcNhK0hHfOoKj1zeuextMnNA
         l6+9XMzbBpl0g7XWLVxGpDUSsaG28lQ3YpsuHdsnHMX1KvqE8qAlUycNQIgCfyLXz/Ww
         LKu4hOWpc5BxPIzezvnrKy4aLwLXs4h7ssklISJ3Vc32NQK6bE6PNKEpWJMuhI0PzZem
         v32t4jRkQc7rBpmibh8Trzk1HxdafWlEOH0lBqnOYTeLasSv2PAT//oJhcHbvDuiEUiC
         nvgQ==
X-Gm-Message-State: AOAM532JiR3GsmxWUSIM3saDCZ608yxXv9dNaMQiZgl93syKZHzZWneq
	0yyzuqYIePOvlUQHXnpbQisTSbrecg8FWw==
X-Google-Smtp-Source: ABdhPJwgCPJuzeIZbUoJFQnwWW4mzTiy/xhRt63UDwPNrpwk8vjx7kJz23BXc4wMqpPu1j8rzx43aA==
X-Received: by 2002:a17:90b:3646:b0:1d8:15c5:464b with SMTP id nh6-20020a17090b364600b001d815c5464bmr7264403pjb.63.1652300393282;
        Wed, 11 May 2022 13:19:53 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:193f:f17a:ab0d:1f83])
        by smtp.gmail.com with ESMTPSA id y5-20020aa78045000000b0050dd876f5f8sm2161306pfm.49.2022.05.11.13.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 13:19:52 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: John Stultz <jstultz@google.com>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Guenter Roeck <groeck@chromium.org>
Subject: [PATCH v2] timers: Provide a better debugobjects hint for delayed works
Date: Wed, 11 May 2022 13:19:51 -0700
Message-Id: <20220511201951.42408-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With debugobjects enabled the timer hint for freeing of active timers
embedded inside delayed works is always the same, i.e. the hint is
delayed_work_timer_fn, even though the function the delayed work is
going to run can be wildly different depending on what work was queued.
Enabling workqueue debugobjects doesn't help either because the delayed
work isn't considered active until it is actually queued to run on a
workqueue. If the work is freed while the timer is pending the work
isn't considered active so we don't get any information from workqueue
debugobjects.

Special case delayed works in the timer debugobjects hint logic so that
the delayed work function is returned instead of the
delayed_work_timer_fn. This will help us understand what delayed work
was pending that got freed. Apply the same treatment for
kthread_delayed_work because it follows the same pattern.

Cc: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

Feel free to reassign authorship to tglx.

Changes from v1 (https://lore.kernel.org/r/20220504223148.644228-1-swboyd@chromium.org):
 * Use counter proposed patch from tglx
 * Deref function pointer to get proper hint
 * Add 't' the function pointer to make checkpatch quiet

 kernel/time/timer.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 9dd2a39cb3b0..8637990a3842 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -615,9 +615,39 @@ static void internal_add_timer(struct timer_base *base, struct timer_list *timer
 
 static const struct debug_obj_descr timer_debug_descr;
 
+struct timer_hint {
+	void	(*function)(struct timer_list *t);
+	long	offset;
+};
+
+#define TIMER_HINT(fn, container, timr, hintfn)			\
+	{							\
+		.function = fn,					\
+		.offset	  = offsetof(container, hintfn) -	\
+			    offsetof(container, timr)		\
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
+		if (timer_hints[i].function == timer->function) {
+			void (**fn)(void) = addr + timer_hints[i].offset;
+
+			return *fn;
+		}
+	}
+
+	return timer->function;
 }
 
 static bool timer_is_static_object(void *addr)

base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a
-- 
https://chromeos.dev

