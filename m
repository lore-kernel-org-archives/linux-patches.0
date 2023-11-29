Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779192B9CA
	for <patches@lists.linux.dev>; Wed, 29 Nov 2023 21:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lTAd3QVv"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1cff3a03d8eso2501645ad.2
        for <patches@lists.linux.dev>; Wed, 29 Nov 2023 13:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701294256; x=1701899056; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oaAuMlegGKyvqGQjlfSP0WNWjaMX9AyKOGu0wZi1ey8=;
        b=lTAd3QVvXAsqpGRk5cVy8tmdCGhFJypXSTVlzvXrLEEaVEZVKc7UmHJSGfp4J1tdDC
         LQV3JABaUTOhNaENtChCfx1ocEVJR8B5k3DYp1NLMC7EjDD/PtASsxcx9PXBkbl0tLXn
         W932nmNU37luwlvlffunfSHRBP+Hb3OO7pYfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701294256; x=1701899056;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oaAuMlegGKyvqGQjlfSP0WNWjaMX9AyKOGu0wZi1ey8=;
        b=AfRrbuzHOHjJ5Hm0t5yD9V5FBBhnC5ZVd6kOsZ9hclbN8vKPU/kyg9mxGRCZEmSW9x
         2WZWDcUIxTUibZrcfIl5bp3GldkMlsdyDgKss0euFeCs6uTulICAdtC+E/iYg4+OVxfD
         EdTUlXzRsfY4vl7fHuEMCtcNUxmSvJGPyiHeUUXkOLIRrHau86hAC/yZ8y+OesSM2/0U
         dMbqo9L5Etyd71dsfvr6QNj/4qGytQjhDyXI8N/R6JekETp0rdE55nbXFpKzcUgl3cbO
         9CYUqacQH8P3wkBDCJyxqqYEhJdzs5jDpOwThuKnpnstB3RmsmNQ3LHbT70nUq2ojnwN
         /zOg==
X-Gm-Message-State: AOJu0YwdD6VBj//0pyvlkaNo3yMBz+mNGlL1fxjnmt8p/cGRs8XLfvY2
	5/07rZ3Tc98S6D4NCCYQUMPclg==
X-Google-Smtp-Source: AGHT+IGw9mcglXCfEIiIcMH/2PCnFrfP/7r764D4go315sp7mNqaJGFq+jVTw5facnm9yzjHe+0sZA==
X-Received: by 2002:a17:903:249:b0:1ce:64fb:e507 with SMTP id j9-20020a170903024900b001ce64fbe507mr23901888plh.27.1701294255812;
        Wed, 29 Nov 2023 13:44:15 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:d538:51cb:f23a:b78c])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902d2ca00b001cfcbeceacesm6793162plc.117.2023.11.29.13.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 13:44:15 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kasan-dev@googlegroups.com
Subject: [PATCH v2] lkdtm: Add kfence read after free crash type
Date: Wed, 29 Nov 2023 13:44:04 -0800
Message-ID: <20231129214413.3156334-1-swboyd@chromium.org>
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

Cc: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <kasan-dev@googlegroups.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

Changes from v1 (https://lore.kernel.org/r/20231127234946.2514120-1-swboyd@chromium.org):
 * Removed ifdefs so code is always available but fails without kfence

 drivers/misc/lkdtm/heap.c | 60 +++++++++++++++++++++++++++++++++++++++
 include/linux/kfence.h    |  2 ++
 2 files changed, 62 insertions(+)

diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
index 0ce4cbf6abda..4f467d3972a6 100644
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
@@ -132,6 +133,64 @@ static void lkdtm_READ_AFTER_FREE(void)
 	kfree(val);
 }
 
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
+
 static void lkdtm_WRITE_BUDDY_AFTER_FREE(void)
 {
 	unsigned long p = __get_free_page(GFP_KERNEL);
@@ -327,6 +386,7 @@ static struct crashtype crashtypes[] = {
 	CRASHTYPE(VMALLOC_LINEAR_OVERFLOW),
 	CRASHTYPE(WRITE_AFTER_FREE),
 	CRASHTYPE(READ_AFTER_FREE),
+	CRASHTYPE(KFENCE_READ_AFTER_FREE),
 	CRASHTYPE(WRITE_BUDDY_AFTER_FREE),
 	CRASHTYPE(READ_BUDDY_AFTER_FREE),
 	CRASHTYPE(SLAB_INIT_ON_ALLOC),
diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 401af4757514..88100cc9caba 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -223,6 +223,8 @@ bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *sla
 
 #else /* CONFIG_KFENCE */
 
+#define kfence_sample_interval	(0)
+
 static inline bool is_kfence_address(const void *addr) { return false; }
 static inline void kfence_alloc_pool_and_metadata(void) { }
 static inline void kfence_init(void) { }

base-commit: b85ea95d086471afb4ad062012a4d73cd328fa86
-- 
https://chromeos.dev

