Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC174F85C7;
	Tue, 13 Oct 2026 12:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894589; cv=none; b=V9xv2y7SOPQecIWMmD03nMcT4Z/2vSKXuMw0tTYl9iv81ojyXUEhKIbCwpii+J7UYcot9zVZViKV/lTvwzMVNDGYmDeSY6kBAOmPBTXMn54m4ZV3C9DvqibQfPAYuBtSIxXHA+ZWGgeJb2/XSbq+hjVRpNyok0dga6Y5aOQhYF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894589; c=relaxed/simple;
	bh=Cld4bFiUlgixUW1bNHMqY8gqAsuOoAQtGzUh1d9p4ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldVU+XOc5J9HQiNJjZSsPEmxIR3TosmMgIWpKOTw55kCfc9hYLn+ep9bh1oF5A6YYFnXX/s8m/1Nm+BrRhvWYeg8s8p0nMQXqj+z4krGactPrbzVFeaez1JvfpNTF8zvNA3yW1flM79btrmycEr5paNE1ztYzy3Bff4Bi6KQ3QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VYNGBek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VYNGBek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE271F000FF;
	Tue, 13 Oct 2026 12:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894588;
	bh=+fkrDtNGtwejUeUSIvjjPdqCmjFAsDn7KwhhiyMGf2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0VYNGBek8845EhIW4B6hbXrN8c3h74EXpydYgfS49hk4U9X1T4UA+7xwsc71UOi26
	 zxoWUSPHY+jy09eCzfCh4uDQhx0w8snRzgqtBZ+cFJb/L5etEG0og0sQ44lOnTT54D
	 f18dXa5YqpgT+SX312UwTwBb2zocAgcMKAaphM74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 610/621] workqueue: fix devm_alloc_workqueue() va_list misuse
Date: Tue, 13 Oct 2026 13:40:05 +0200
Message-ID: <20261013112935.273421176@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 0de4cb473aed57ee4ba7e0551ad27bddc19fc519 upstream.

devm_alloc_workqueue() built a va_list and passed it as a single
positional argument to the variadic alloc_workqueue() macro:

	va_start(args, max_active);
	wq = alloc_workqueue(fmt, flags, max_active, args);
	va_end(args);

C does not allow forwarding a va_list through a ... parameter.
alloc_workqueue() expands to alloc_workqueue_noprof(), which runs
its own va_start() over its ... params, so the inner
vsnprintf(wq->name, sizeof(wq->name), fmt, args) in
__alloc_workqueue() received the outer va_list object as the first
variadic slot rather than the caller's actual format arguments.

Add a new static helper alloc_workqueue_va() that wraps
__alloc_workqueue() and runs wq_init_lockdep() on success, and
fold both alloc_workqueue_noprof() and devm_alloc_workqueue_noprof()
onto it as suggested by Tejun.

The wq_init_lockdep() step is required on the devm path
too, otherwise __flush_workqueue()'s on-stack
COMPLETION_INITIALIZER_ONSTACK_MAP would NULL-deref wq->lockdep_map.

No caller changes are required. devm_alloc_ordered_workqueue() is
a macro forwarding to devm_alloc_workqueue() and inherits the fix.
Two in-tree callers actively trigger the broken path on every probe:

  drivers/power/supply/mt6370-charger.c:889
  drivers/power/supply/max77705_charger.c:649

both of which use devm_alloc_ordered_workqueue(dev, "%s", 0,
dev_name(dev)).

A standalone reproducer module is available at[1].

Link: https://github.com/leitao/debug/blob/main/workqueue/valist/wq_va_test.c [1]
Fixes: 1dfc9d60a69e ("workqueue: devres: Add device-managed allocate workqueue")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/workqueue.h |    6 ++++--
 kernel/workqueue.c        |   28 +++++++++++++++++++---------
 2 files changed, 23 insertions(+), 11 deletions(-)

--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -529,8 +529,10 @@ alloc_workqueue_noprof(const char *fmt,
  * Pointer to the allocated workqueue on success, %NULL on failure.
  */
 __printf(2, 5) struct workqueue_struct *
-devm_alloc_workqueue(struct device *dev, const char *fmt, unsigned int flags,
-		     int max_active, ...);
+devm_alloc_workqueue_noprof(struct device *dev, const char *fmt,
+			    unsigned int flags, int max_active, ...);
+#define devm_alloc_workqueue(...)	\
+	alloc_hooks(devm_alloc_workqueue_noprof(__VA_ARGS__))
 
 #ifdef CONFIG_LOCKDEP
 /**
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5875,6 +5875,20 @@ err_destroy:
 	return NULL;
 }
 
+static struct workqueue_struct *alloc_workqueue_va(const char *fmt,
+						   unsigned int flags,
+						   int max_active,
+						   va_list args)
+{
+	struct workqueue_struct *wq;
+
+	wq = __alloc_workqueue(fmt, flags, max_active, args);
+	if (wq)
+		wq_init_lockdep(wq);
+
+	return wq;
+}
+
 __printf(1, 4)
 struct workqueue_struct *alloc_workqueue_noprof(const char *fmt,
 						unsigned int flags,
@@ -5884,12 +5898,8 @@ struct workqueue_struct *alloc_workqueue
 	va_list args;
 
 	va_start(args, max_active);
-	wq = __alloc_workqueue(fmt, flags, max_active, args);
+	wq = alloc_workqueue_va(fmt, flags, max_active, args);
 	va_end(args);
-	if (!wq)
-		return NULL;
-
-	wq_init_lockdep(wq);
 
 	return wq;
 }
@@ -5901,15 +5911,15 @@ static void devm_workqueue_release(void
 }
 
 __printf(2, 5) struct workqueue_struct *
-devm_alloc_workqueue(struct device *dev, const char *fmt, unsigned int flags,
-		     int max_active, ...)
+devm_alloc_workqueue_noprof(struct device *dev, const char *fmt,
+			    unsigned int flags, int max_active, ...)
 {
 	struct workqueue_struct *wq;
 	va_list args;
 	int ret;
 
 	va_start(args, max_active);
-	wq = alloc_workqueue(fmt, flags, max_active, args);
+	wq = alloc_workqueue_va(fmt, flags, max_active, args);
 	va_end(args);
 	if (!wq)
 		return NULL;
@@ -5920,7 +5930,7 @@ devm_alloc_workqueue(struct device *dev,
 
 	return wq;
 }
-EXPORT_SYMBOL_GPL(devm_alloc_workqueue);
+EXPORT_SYMBOL_GPL(devm_alloc_workqueue_noprof);
 
 #ifdef CONFIG_LOCKDEP
 __printf(1, 5)


