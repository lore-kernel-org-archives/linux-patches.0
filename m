Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3265A4FD7A7;
	Tue, 13 Oct 2026 12:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893434; cv=none; b=j6R1kfyAqggsGxKWClx8gUrk4Nw+Dkc0W3E/2gdNf7OiIrvYsImAARK+2HkG9Ka2bcIaq5/56b2mpcPKoUS7ndevg9ggGpRbi9VsM1o3kHNpHZhTWKLR/NjpxjaAv+VBhGeJs1XEt29lM7i2lilMB6a6GjlWeAIGnGC+vXwqnWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893434; c=relaxed/simple;
	bh=sjkUf1TGI0N4osin+AmcVCC272eZxi9UOPjTVEL6MI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJh9WGR1CNiQ0jkgkmZU4tBQC9S1A3VjVjT27fswd5iuWZHixxRv4fNUvkH9ixFqwSVvRACQNnCiZwBANiw4JfAWjitdKljHFpgGP1L4ysta/WxjbS5ZF0IfyWCTSoyVzh/c84+E031lWtRfI9kcnmnmZVmlD6EiONID5krz7no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+OggJBQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+OggJBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548B61F000FF;
	Tue, 13 Oct 2026 12:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893432;
	bh=kccGkG4iJNQz+WzLuTOQsHkhtwtudFDcOMmPeyL2LYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+OggJBQU7rQqc01OfFfPkRyjCF9E70g9lrPsTA9LodGja1UWSGkHml8GyFpqEh/9
	 LRXFwsXi+yMGFxXPwg8W3tH6cRc9K6FFQ8Fn+4wOyUYaiQee8RfXPhKucd7SwX1rTu
	 NXfccM6f5hxqC9p0ikEi9CedxI/EWrhX24Ye+U8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Tejun Heo <tj@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 224/621] workqueue: devres: Add device-managed allocate workqueue
Date: Tue, 13 Oct 2026 13:33:39 +0200
Message-ID: <20261013112926.173592986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 1dfc9d60a69ec148e1cb709256617d86e5f0e8f8 ]

Add a Resource-managed version of alloc_workqueue() to fix common
problem of drivers mixing devm() calls with destroy_workqueue.  Such
naive and discouraged driver approach leads to difficult to debug bugs
when the driver:

1. Allocates workqueue in standard way and destroys it in driver
   remove() callback,
2. Sets work struct with devm_work_autocancel(),
3. Registers interrupt handler with devm_request_threaded_irq().

Which leads to following unbind/removal path:

1. destroy_workqueue() via driver remove(),
   Any interrupt coming now would still execute the interrupt handler,
   which queues work on destroyed workqueue.
2. devm_irq_release(),
3. devm_work_drop() -> cancel_work_sync() on destroyed workqueue.

devm_alloc_workqueue() has two benefits:
1. Solves above problem of mix-and-match devres and non-devres code in
   driver,
2. Simplify any sane drivers which were correctly using
   alloc_workqueue() + devm_add_action_or_reset().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 1e668baadefb ("power: supply: max77705: Free allocated workqueue and fix removal order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../driver-api/driver-model/devres.rst        |  4 +++
 include/linux/workqueue.h                     | 22 +++++++++++++++
 kernel/workqueue.c                            | 28 +++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/Documentation/driver-api/driver-model/devres.rst b/Documentation/driver-api/driver-model/devres.rst
index 2b36ebde9cece..012f42a48f855 100644
--- a/Documentation/driver-api/driver-model/devres.rst
+++ b/Documentation/driver-api/driver-model/devres.rst
@@ -466,3 +466,7 @@ SPI
 
 WATCHDOG
   devm_watchdog_register_device()
+
+WORKQUEUE
+  devm_alloc_workqueue()
+  devm_alloc_ordered_workqueue()
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index dabc351cc127d..30fd0cb3229c1 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -512,6 +512,26 @@ __printf(1, 4) struct workqueue_struct *
 alloc_workqueue_noprof(const char *fmt, unsigned int flags, int max_active, ...);
 #define alloc_workqueue(...)	alloc_hooks(alloc_workqueue_noprof(__VA_ARGS__))
 
+/**
+ * devm_alloc_workqueue - Resource-managed allocate a workqueue
+ * @dev: Device to allocate workqueue for
+ * @fmt: printf format for the name of the workqueue
+ * @flags: WQ_* flags
+ * @max_active: max in-flight work items, 0 for default
+ * @...: args for @fmt
+ *
+ * Resource managed workqueue, see alloc_workqueue() for details.
+ *
+ * The workqueue will be automatically destroyed on driver detach.  Typically
+ * this should be used in drivers already relying on devm interafaces.
+ *
+ * RETURNS:
+ * Pointer to the allocated workqueue on success, %NULL on failure.
+ */
+__printf(2, 5) struct workqueue_struct *
+devm_alloc_workqueue(struct device *dev, const char *fmt, unsigned int flags,
+		     int max_active, ...);
+
 #ifdef CONFIG_LOCKDEP
 /**
  * alloc_workqueue_lockdep_map - allocate a workqueue with user-defined lockdep_map
@@ -568,6 +588,8 @@ alloc_workqueue_lockdep_map(const char *fmt, unsigned int flags, int max_active,
  */
 #define alloc_ordered_workqueue(fmt, flags, args...)			\
 	alloc_workqueue(fmt, WQ_UNBOUND | __WQ_ORDERED | (flags), 1, ##args)
+#define devm_alloc_ordered_workqueue(dev, fmt, flags, args...)		\
+	devm_alloc_workqueue(dev, fmt, WQ_UNBOUND | __WQ_ORDERED | (flags), 1, ##args)
 
 #define create_workqueue(name)						\
 	alloc_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_PERCPU, 1, (name))
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 308299b48c96f..2c78034eca12b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -41,6 +41,7 @@
 #include <linux/mempolicy.h>
 #include <linux/freezer.h>
 #include <linux/debug_locks.h>
+#include <linux/device/devres.h>
 #include <linux/lockdep.h>
 #include <linux/idr.h>
 #include <linux/jhash.h>
@@ -5894,6 +5895,33 @@ struct workqueue_struct *alloc_workqueue_noprof(const char *fmt,
 }
 EXPORT_SYMBOL_GPL(alloc_workqueue_noprof);
 
+static void devm_workqueue_release(void *res)
+{
+	destroy_workqueue(res);
+}
+
+__printf(2, 5) struct workqueue_struct *
+devm_alloc_workqueue(struct device *dev, const char *fmt, unsigned int flags,
+		     int max_active, ...)
+{
+	struct workqueue_struct *wq;
+	va_list args;
+	int ret;
+
+	va_start(args, max_active);
+	wq = alloc_workqueue(fmt, flags, max_active, args);
+	va_end(args);
+	if (!wq)
+		return NULL;
+
+	ret = devm_add_action_or_reset(dev, devm_workqueue_release, wq);
+	if (ret)
+		return NULL;
+
+	return wq;
+}
+EXPORT_SYMBOL_GPL(devm_alloc_workqueue);
+
 #ifdef CONFIG_LOCKDEP
 __printf(1, 5)
 struct workqueue_struct *
-- 
2.53.0



