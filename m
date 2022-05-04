Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882FE20F7
	for <patches@lists.linux.dev>; Wed,  4 May 2022 22:31:50 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id p6so2498107pjm.1
        for <patches@lists.linux.dev>; Wed, 04 May 2022 15:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ym7pQ9PZG06J3qUsaBV/BTn83s/gyQ6wOepfY5bJx4I=;
        b=K7Wi0bnRVZZG7Pk+DpEAKVfKWMruzNrAKFojyu/NTd/EAasFTz+Nc5rLyaefVBSnAk
         yL81ghqlIEHAXwSwYEn9G+LYHDCjfQnNueIb55SLHwdvdyRGvlS0vp0de8dtMqoSS7kV
         5TPN3YkPubWDOI3SOK+dFL+sc6p3jWtI6aDoM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ym7pQ9PZG06J3qUsaBV/BTn83s/gyQ6wOepfY5bJx4I=;
        b=mmqOBNPeFaIinSRmJ/irWmSYtAn/X8CLv8qoYlLrSkLuwv2wMoy1Bg8EAm4gYlkDZ/
         /98A/9kDsiLBFlL1sJr68H8kflLHCL0Y/m1g9g+NuFrCGy9bOoW2hdJIlpr29+g4ci00
         ZfihlOsWxg4MpCfwSDGfiKnInYN3o5+7OYX5jgm0C0v5lXnb8wdspDsZCA/CiSpWJQPh
         BZLZ/eP2WoV481pvOlxufSDzoxUpEVkjkm/R6hQYwlIsr32gZ0goK4qnMX3h03j/N7ng
         GrLDTLQoy7hCqL0w0ci+4Cdde0mP2Vj1yA5gpKuP7KnMY0fzypkbcuFM00ecaERM9/Ct
         +aKQ==
X-Gm-Message-State: AOAM531eURCAp7aryfY8y2/S2Tv6wdR/bmxc3GrD/ZhbDa4Z4gx3Vspi
	/SDCTpWQ2y2y1cl7MG5GAkaxXw==
X-Google-Smtp-Source: ABdhPJxL3oGX9IusDtlyD6KSqAAElSfPht86DVn85gFyo1oMW4VvNzPns8mPrm3XWZr4yJbyMOuT5g==
X-Received: by 2002:a17:90a:8418:b0:1d2:7c69:e3bf with SMTP id j24-20020a17090a841800b001d27c69e3bfmr2171270pjn.44.1651703509905;
        Wed, 04 May 2022 15:31:49 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:597f:a6c6:7682:e714])
        by smtp.gmail.com with ESMTPSA id q21-20020a62ae15000000b0050dc76281e2sm8690810pff.188.2022.05.04.15.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 15:31:49 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: John Stultz <john.stultz@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Guenter Roeck <groeck@chromium.org>
Subject: [PATCH] timers: Provide a better debugobjects hint for delayed works
Date: Wed,  4 May 2022 15:31:48 -0700
Message-Id: <20220504223148.644228-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With debugobjects enabled the timer hint for freeing of active timers
embedded inside delayed works is always the same, i.e. the hint is
delayed_work_timer_fn(), even though the function the delayed work is
going to run can be wildly different depending on what work was
scheduled. Enabling workqueue debugobjects doesn't help either because
the delayed work isn't considered active until it is actually queued to
run on a workqueue. That's because if the work is freed while the timer
is pending the work isn't considered active to debugobjects so we don't
get any information about freeing an active work.

Provide better information here by special casing delayed works in the
timer debugobjects hint logic so that the work function is returned
instead of the timer function delayed_work_timer_fn(). This will help us
understand what delayed work was pending that got freed, leading to
faster bug resolutions.

Cc: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

I have an alternative approach which is to treat delayed works with a
different debug_obj_descr structure but it basically boils down to
another version of timer debugobjects in the workqueue code. The idea is
to make the delayed work active once the timer is queued and then
convert it over from a delayed work descriptor to a work descriptor once
the timer runs delayed_work_timer_fn() or when we pull it off to flush
out.

 kernel/time/timer.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 9dd2a39cb3b0..7b3c1019835c 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -44,6 +44,7 @@
 #include <linux/slab.h>
 #include <linux/compat.h>
 #include <linux/random.h>
+#include <linux/workqueue.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -617,7 +618,17 @@ static const struct debug_obj_descr timer_debug_descr;
 
 static void *timer_debug_hint(void *addr)
 {
-	return ((struct timer_list *) addr)->function;
+	struct timer_list *timer = addr;
+
+	if (timer->function == delayed_work_timer_fn) {
+		struct delayed_work *dwork;
+
+		dwork = container_of(timer, struct delayed_work, timer);
+
+		return dwork->work.func;
+	}
+
+	return timer->function;
 }
 
 static bool timer_is_static_object(void *addr)

base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a
-- 
https://chromeos.dev

