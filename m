Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA5419B59C;
	Tue, 16 Jul 2024 16:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145944; cv=none; b=DclWEedXN5u3Z2rTgC1VwJpVIfcYHB0Kycb6YErlNAxDTdXjjNa5MtUB3M5yM3Rz9Hcv0fgjmO7mPbmorEpS3jI7ePpvYpBtlRN1hanr1wm3T1//F3kEtSdnWSoIRJhQJKV9mYNICn1hXIKXeDKNJec91OvPmTEGl+w2rYVxSWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145944; c=relaxed/simple;
	bh=CExSc/qwkYlvlm4XQup32LNl6JZzBCz0u7crYzy4uBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aRf6+bURuhpfb9xBR6dRJTVKiAQQts+WCV+TmS0FYTg2z2Qh6eiKCmY60QuUkdlKYSD/DcCDczHSw7H1D0f+l/hssjqLw1oDauH8IcCFZ3tdcDobQaY3a/Fr2QlAdJKVQJ3qd6+7tFZDNHyyfqAUyFclaj65/8NUypCryewx5Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rN817ONt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rN817ONt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3358CC116B1;
	Tue, 16 Jul 2024 16:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145944;
	bh=CExSc/qwkYlvlm4XQup32LNl6JZzBCz0u7crYzy4uBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rN817ONt+0Fz3tmLJ86+T1fvgZ4luoMLsvALoiLqpp3NMX4QGl8jtf9oXsvQmqpHa
	 kJYs1wjUIwvint3CSBhi9ZcTud10x630DsjUcqpkhq7inF1ayhZaNFuN4b1qYUI66A
	 emYrp9IlfJd/qulK+2UlMm7QzEEcHMYHt3PoY7sU=
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
Subject: [PATCH 5.15 001/144] locking/mutex: Introduce devm_mutex_init()
Date: Tue, 16 Jul 2024 17:31:10 +0200
Message-ID: <20240716152752.583490101@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8f226d460f51c..9ef01b9d24563 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -20,6 +20,8 @@
 #include <linux/osq_lock.h>
 #include <linux/debug_locks.h>
 
+struct device;
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname)			\
 		, .dep_map = {					\
@@ -170,6 +172,31 @@ do {							\
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



