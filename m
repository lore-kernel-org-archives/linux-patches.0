Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D2213A25F;
	Tue,  9 Jul 2024 11:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523941; cv=none; b=DKIorX0ggbWc1LQChyXxSo2kNThPYwDGugruwabNVzeWU5bRIZhFcRM0uq45HEznFzVWDC983HpqhR3wuXlSEnT3BU45kswZ44RT0d1lJewcOeUmnxm2cq9M3nJmjdllSryk2TavMsBfkWGIKO0ttMDvbm92pSMtxbsQQfpN28A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523941; c=relaxed/simple;
	bh=JtiZDC0elF+ls3cuvfAtlgqamQjacyCcGzJdbHqiSz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XM6x+sC81F8QK2PWfWdLmWczqR8xJjjX7KccqjK9ULcc/pQbZHWUgfDSO4wbdabwvJD2EDum3UyhM0+isaP8S/wlVjvKOtNi0EVSbbBzmAWMNSnx5ovzsRaYtvmWozT0m6VsrGQuXKJYxvCva9lUSX7ojnyX+1l5GvUguOsyVio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rW2FaRF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rW2FaRF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF16C32786;
	Tue,  9 Jul 2024 11:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523941;
	bh=JtiZDC0elF+ls3cuvfAtlgqamQjacyCcGzJdbHqiSz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rW2FaRF3wz4UuWtGi7H9pdOPy7YsEhYKjF7EUmSRDCJ+MWAI32MmnDcTyZ/8Sm+zj
	 gAUqtYWewc9exC4fZ5g3ILoJiu1UW2krDXDFbZMHFjYonKja1K/z3TOIrZg38xX2X+
	 r84GY1BlLmBxulDUVxKaYUjmBYEISo4Lx3fSPaiU=
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
Subject: [PATCH 6.9 002/197] locking/mutex: Introduce devm_mutex_init()
Date: Tue,  9 Jul 2024 13:07:36 +0200
Message-ID: <20240709110708.999748307@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: efc347b9efee ("leds: mlxreg: Use devm_mutex_init() for mutex initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mutex.h        | 27 +++++++++++++++++++++++++++
 kernel/locking/mutex-debug.c | 12 ++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 67edc4ca2beeb..a561c629d89f0 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -22,6 +22,8 @@
 #include <linux/cleanup.h>
 #include <linux/mutex_types.h>
 
+struct device;
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname)			\
 		, .dep_map = {					\
@@ -117,6 +119,31 @@ do {							\
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



