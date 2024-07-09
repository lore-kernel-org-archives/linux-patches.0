Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5CD38382;
	Tue,  9 Jul 2024 11:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523482; cv=none; b=V3nGhgB8YIgM+cTlzgdRsEAz+Oi+iSeY0mqBbZnzMZcgfTuvVypWQuyR4kHKHhLaLIALta7swByOBQAj9T5+RsDMFJlda7cguaqVHG8nH9EACMjVccsBmUm1BfVvqvyDza8oOUiTqQ8SqSv8YNI7/Up7klSMWM7LMgFxoJXMYSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523482; c=relaxed/simple;
	bh=Mp2wgn1zSYqUfawu0YUC6/l65kM/AavNfXgfd0aN+7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKdDmI0XRVyMbfkxR9FpKv4Cz2IsDp5Kop0uW0tn/JMxO4/R0zzaSYcKzFg52l9DtSzQtT6kIiUa0eiIS82Q9ix1DANqRIDnJEeaZJ6I4d7OHLcvV0jB4jc2BupJq7VgrbOie7dZcLNjxYvPjPHp+Fciw9bkkPw7vrLFpSGjggo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ahnnk7MQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ahnnk7MQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82044C3277B;
	Tue,  9 Jul 2024 11:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523482;
	bh=Mp2wgn1zSYqUfawu0YUC6/l65kM/AavNfXgfd0aN+7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ahnnk7MQ7eVM+XfKdYyMx9hQTsjYN+g3PaJrz8tWDkvfHCROwXcBFWfE5iM/NrtlE
	 S5uyxsJeEHV91CAxPPPg5KNnBFdbcM3yXs1kvmq3dnE+bEgtH4WylSvyWhvqUM9f91
	 JbwfzknWVo+JRK0TUpqrqr9IT97do6XyA9fdYsD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	George Stark <gnstark@salutedevices.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/139] locking/mutex: Introduce devm_mutex_init()
Date: Tue,  9 Jul 2024 13:08:21 +0200
Message-ID: <20240709110658.206061808@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Stark <gnstark@salutedevices.com>

[ Upstream commit 4cd47222e435dec8e3787614924174f53fcfb5ae ]

Using of devm API leads to a certain order of releasing resources.
So all dependent resources which are not devm-wrapped should be deleted
with respect to devm-release order. Mutex is one of such objects that
often is bound to other resources and has no own devm wrapping.
Since mutex_destroy() actually does nothing in non-debug builds
frequently calling mutex_destroy() is just ignored which is safe for now
but wrong formally and can lead to a problem if mutex_destroy() will be
extended so introduce devm_mutex_init().

Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: George Stark <gnstark@salutedevices.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20240411161032.609544-2-gnstark@salutedevices.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mutex.h        | 27 +++++++++++++++++++++++++++
 kernel/locking/mutex-debug.c | 12 ++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index a33aa9eb9fc3b..5b5630e58407a 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -21,6 +21,8 @@
 #include <linux/debug_locks.h>
 #include <linux/cleanup.h>
 
+struct device;
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname)			\
 		, .dep_map = {					\
@@ -171,6 +173,31 @@ do {							\
 } while (0)
 #endif /* CONFIG_PREEMPT_RT */
 
+#ifdef CONFIG_DEBUG_MUTEXES
+
+int __devm_mutex_init(struct device *dev, struct mutex *lock);
+
+#else
+
+static inline int __devm_mutex_init(struct device *dev, struct mutex *lock)
+{
+	/*
+	 * When CONFIG_DEBUG_MUTEXES is off mutex_destroy() is just a nop so
+	 * no really need to register it in the devm subsystem.
+	 */
+	return 0;
+}
+
+#endif
+
+#define devm_mutex_init(dev, mutex)			\
+({							\
+	typeof(mutex) mutex_ = (mutex);			\
+							\
+	mutex_init(mutex_);				\
+	__devm_mutex_init(dev, mutex_);			\
+})
+
 /*
  * See kernel/locking/mutex.c for detailed documentation of these APIs.
  * Also see Documentation/locking/mutex-design.rst.
diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index bc8abb8549d20..6e6f6071cfa27 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -12,6 +12,7 @@
  */
 #include <linux/mutex.h>
 #include <linux/delay.h>
+#include <linux/device.h>
 #include <linux/export.h>
 #include <linux/poison.h>
 #include <linux/sched.h>
@@ -89,6 +90,17 @@ void debug_mutex_init(struct mutex *lock, const char *name,
 	lock->magic = lock;
 }
 
+static void devm_mutex_release(void *res)
+{
+	mutex_destroy(res);
+}
+
+int __devm_mutex_init(struct device *dev, struct mutex *lock)
+{
+	return devm_add_action_or_reset(dev, devm_mutex_release, lock);
+}
+EXPORT_SYMBOL_GPL(__devm_mutex_init);
+
 /***
  * mutex_destroy - mark a mutex unusable
  * @lock: the mutex to be destroyed
-- 
2.43.0



