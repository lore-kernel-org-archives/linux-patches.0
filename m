Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877B3320F
	for <patches@lists.linux.dev>; Thu, 19 May 2022 20:22:03 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so6202177pjq.2
        for <patches@lists.linux.dev>; Thu, 19 May 2022 13:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ikC7s8FLRXJFc1LdsVuepwYga4To/xbr9UiroOMnwlE=;
        b=VMA1UEkrpWsGAEdk+YJdxwzY/cT10CGh42g+oGDMCn73r8d9uau8akVuwvpFL3M3Qc
         ufpJae9aH2VoMOsDMYlCrD1D01xVNnG9Rg9YvBoBCsUDCPyZOTuOSMY+lWvkGmMn3Fax
         kZAr+6BOhrSRSxzUhXafoJbpmXxMM1cRIbqGM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ikC7s8FLRXJFc1LdsVuepwYga4To/xbr9UiroOMnwlE=;
        b=a5AjDBZi1Ge34bLDLMeh1kQFKWALHt3FwoyRypDRxybYE0KjyxdmpQP55mdhfqqAD4
         THX4eywcChjZnSBaoOj/pYGu6ky+kxydUeeec2JK52xd0TdNuOhppuK0oYBSYH8e81gF
         BMhhvTw3luakha4uzUs9Hwrb/poaTKCyTneazPT0+/ANneQTtiikKs7uFaXrP2XllJfW
         f8axoNRh5QJH7Bw/RWoOjG6PcN/kZqnPtOihzei1z6/G1MlKW52ofEl5Zf78wYXTtbpO
         INAzkrVRaqhugHU3gZsQYesK/EEyG5kKdseX9rvsdtNNRBYI9Z4TVd+hMTurNS4kAurn
         Jxtg==
X-Gm-Message-State: AOAM533MxiSMY7FWrahiOukhe+Mn2aD4rAA7RTsPX9cta9rAmoG4az4L
	sYM6ioHXyEHr7q6U3PjJ9mj0fA==
X-Google-Smtp-Source: ABdhPJyuyroQFkEHApH6ZtW60SRNeIl8ztFC4B7AmueG52xlJk1NKqOhR79ConbdqjJv+VwA2GdlHA==
X-Received: by 2002:a17:902:9308:b0:15f:12dc:7c7c with SMTP id bc8-20020a170902930800b0015f12dc7c7cmr6297934plb.141.1652991722924;
        Thu, 19 May 2022 13:22:02 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:8377:9713:b193:7dde])
        by smtp.gmail.com with ESMTPSA id ru13-20020a17090b2bcd00b001df4a0e9357sm243395pjb.12.2022.05.19.13.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 13:22:02 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>
Subject: [PATCH] debugobjects: Print object pointer in debug_print_object()
Date: Thu, 19 May 2022 13:22:01 -0700
Message-Id: <20220519202201.2348343-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Delayed kobject debugging (CONFIG_DEBUG_KOBJECT_RELEASE) prints the
kobject pointer that's being released in kobject_release() before
scheduling a randomly delayed work to do the actual release work. If the
caller of kobject_put() frees the kobject upon return then we'll
typically see a debugobject warning about freeing an active timer.
Usually the release function is the function that does the kfree() of
the struct containing the kobject.

For example the following print is seen

 kobject: 'queue' (ffff888114236190): kobject_release, parent 0000000000000000 (delayed 1000)
 ------------[ cut here ]------------
 ODEBUG: free active (active state 0) object type: timer_list hint: kobject_delayed_cleanup+0x0/0x390

but we can't match up the kobject printk with the debug object printk
because it could be any number of kobjects that was released around that
time. The random delay for the work doesn't help either.

Print the address of the object being tracked to help us figure out
which kobject is the problem here. Note that we don't use %px here to
match the other %p usage in debugobject debugging. Due to %p usage we'll
have to disable pointer hashing to correlate the two pointer printks.

Cc: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 lib/debugobjects.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 6946f8e204e3..a1c987e967e0 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -503,9 +503,9 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
 			descr->debug_hint(obj->object) : NULL;
 		limit++;
 		WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
-				 "object type: %s hint: %pS\n",
+				 "object: %p object type: %s hint: %pS\n",
 			msg, obj_states[obj->state], obj->astate,
-			descr->name, hint);
+			obj->object, descr->name, hint);
 	}
 	debug_objects_warnings++;
 }

base-commit: ffb217a13a2eaf6d5bd974fc83036a53ca69f1e2
-- 
https://chromeos.dev

