Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAC23C46E
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 23:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oHrHzQ/x"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-285a64dcf3eso1719537a91.1
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 15:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701128989; x=1701733789; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wBWO3qiHF6ynp4gh0IQevir8rNrrtCuaI4IulQnqpxU=;
        b=oHrHzQ/xu2J2XkWIdlHZBxmOBZg86j+clyySXGi1AokEu8M0hK2y58Bg/PPRDnz5gR
         Y+KFasCIu/QCwUxwaY8MF4rPjVlDi/MqpEobTx+maHfcO2H7XaNrOAbyupfW0Xgushw3
         279A+Cp/A1cwb70aQfRzh9MXbti9NOqHtFtKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701128989; x=1701733789;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wBWO3qiHF6ynp4gh0IQevir8rNrrtCuaI4IulQnqpxU=;
        b=lvzDaNvu7M5E3TDIL0nqsb1DVVoyfiiYfHLAaiUGGdteGAHltzR9/eFKpkmD+pakrt
         /D0qew28E+U9IiO/X7BCrIdmFsysPI8bYnT3NXnGtN5wb54CWRHnUvJPq11EiTRfoifY
         Av5c4FCoK5ZY1QNmGzL0WVqhXn0hG6wsz2LskrIBILiY6Ia+A+MRo3UUvzXUiX56+GqQ
         Ra4Zh5kLvDmt9dUqI39/7PxqCW6A0cPAyNSfkiK33NDk0yNqyRBzc1VAjAnj+3oUfeC1
         5LQSVOAMJ9SSr7EDJP1ZIg/Lh85zHR1gQ2NXkLB4pd2tBd9bfqanVesrgMgfpF0UXfRZ
         ow3g==
X-Gm-Message-State: AOJu0YynnygDuCyCZ8MXHtO/J2dSdbZFqOT0yfg8UDMFC0C/ClB8PUZP
	cfTfojqF9TEFUjwTA9qFAA7Yhg==
X-Google-Smtp-Source: AGHT+IFiK1TL6iRqDxnEarhUDv5XQ6c1bUCpPYgE2MBOLdZUHwEMQYstZPZ9fZDxk9Gf4SGi+drnNQ==
X-Received: by 2002:a17:90b:3807:b0:285:e16c:fb0a with SMTP id mq7-20020a17090b380700b00285e16cfb0amr3227082pjb.4.1701128988683;
        Mon, 27 Nov 2023 15:49:48 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:6438:b5d1:198e:8bb0])
        by smtp.gmail.com with ESMTPSA id cu20-20020a17090afa9400b00282ecb631a9sm7860556pjb.25.2023.11.27.15.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 15:49:48 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] lkdtm: Add kfence read after free crash type
Date: Mon, 27 Nov 2023 15:49:45 -0800
Message-ID: <20231127234946.2514120-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the ability to allocate memory from kfence and trigger a read after
free on that memory to validate that kfence is working properly. This is
used by ChromeOS integration tests to validate that kfence errors can be
collected on user devices and parsed properly.

Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/misc/lkdtm/heap.c | 64 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
index 0ce4cbf6abda..608872bcc7e0 100644
--- a/drivers/misc/lkdtm/heap.c
+++ b/drivers/misc/lkdtm/heap.c
@@ -4,6 +4,7 @@
  * page allocation and slab allocations.
  */
 #include "lkdtm.h"
+#include <linux/kfence.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
@@ -132,6 +133,66 @@ static void lkdtm_READ_AFTER_FREE(void)
 	kfree(val);
 }
 
+#if IS_ENABLED(CONFIG_KFENCE)
+static void lkdtm_KFENCE_READ_AFTER_FREE(void)
+{
+	int *base, val, saw;
+	unsigned long timeout, resched_after;
+	size_t len = 1024;
+	/*
+	 * The slub allocator will use the either the first word or
+	 * the middle of the allocation to store the free pointer,
+	 * depending on configurations. Store in the second word to
+	 * avoid running into the freelist.
+	 */
+	size_t offset = sizeof(*base);
+
+	/*
+	 * 100x the sample interval should be more than enough to ensure we get
+	 * a KFENCE allocation eventually.
+	 */
+	timeout = jiffies + msecs_to_jiffies(100 * kfence_sample_interval);
+	/*
+	 * Especially for non-preemption kernels, ensure the allocation-gate
+	 * timer can catch up: after @resched_after, every failed allocation
+	 * attempt yields, to ensure the allocation-gate timer is scheduled.
+	 */
+	resched_after = jiffies + msecs_to_jiffies(kfence_sample_interval);
+	do {
+		base = kmalloc(len, GFP_KERNEL);
+		if (!base) {
+			pr_err("FAIL: Unable to allocate kfence memory!\n");
+			return;
+		}
+
+		if (is_kfence_address(base)) {
+			val = 0x12345678;
+			base[offset] = val;
+			pr_info("Value in memory before free: %x\n", base[offset]);
+
+			kfree(base);
+
+			pr_info("Attempting bad read from freed memory\n");
+			saw = base[offset];
+			if (saw != val) {
+				/* Good! Poisoning happened, so declare a win. */
+				pr_info("Memory correctly poisoned (%x)\n", saw);
+			} else {
+				pr_err("FAIL: Memory was not poisoned!\n");
+				pr_expected_config_param(CONFIG_INIT_ON_FREE_DEFAULT_ON, "init_on_free");
+			}
+			return;
+		}
+
+		kfree(base);
+		if (time_after(jiffies, resched_after))
+			cond_resched();
+	} while (time_before(jiffies, timeout));
+
+	pr_err("FAIL: kfence memory never allocated!\n");
+}
+#endif
+
 static void lkdtm_WRITE_BUDDY_AFTER_FREE(void)
 {
 	unsigned long p = __get_free_page(GFP_KERNEL);
@@ -327,6 +388,9 @@ static struct crashtype crashtypes[] = {
 	CRASHTYPE(VMALLOC_LINEAR_OVERFLOW),
 	CRASHTYPE(WRITE_AFTER_FREE),
 	CRASHTYPE(READ_AFTER_FREE),
+#if IS_ENABLED(CONFIG_KFENCE)
+	CRASHTYPE(KFENCE_READ_AFTER_FREE),
+#endif
 	CRASHTYPE(WRITE_BUDDY_AFTER_FREE),
 	CRASHTYPE(READ_BUDDY_AFTER_FREE),
 	CRASHTYPE(SLAB_INIT_ON_ALLOC),
-- 
https://chromeos.dev

