Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215103;
	b=eEcFjuvergBG/pgnGTW2cTGH0gEmet+Hfgudu7DJzIkfylDpiIHoRQE3QZ4ryslUtHrV
	 ha7lZvFCvNvTadd3SVF2SeYSHhe34TSx7qwpqWyEDbDgrUhHh7WLQV6sf1cgiYajEjQdI
	 a5yOuU83XkvPn00ZExfBxCjxoVPSq4TzYAoLyydQi3uw1DlzXLOblCqFUUnY2q3OW1hyi
	 y90GB5TdG9kYbOSOnzw+2Uzzmisux+CorTUZcMZWDShhdbPw/GCovWD5x/ZPJL2xWkKY4
	 yEycxOJBdedcjaTbsUG27conSizuSG2CJs3mo9dfE2wy+SIYAJG7G8iLsO/+9vnr4ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6pjXSQokKODI4dmDZBTId/+CQFM5uK9caagmq6vpN3g=;
	b=XTiuanBabPvEuhbXGeBXR5R8lyN153S99iwiytEUxbTH1VWK3qo9u6/o3aO/kN+IF20i
	 QaKasz2QRBW44yh7k9CYwg0narMCobmrYOEWb41AfKuA+griC0nVtWnqlZUtzKu3gal4i
	 IVBXRNVV7paw3rKDU5MV1AfVqnYqLRX/kFZgRH9hNe7IndzJ2PfRh+KVsmVagF6y0Wubs
	 0NKxhRfXYD1+Ijff3n/SoD08/2GTKVnITVP5XBmUNNZWIZoyhvqhorPK+1iyrqIbXC2YV
	 a/PIen6aFnmPf0kqfnlM7HQrhh1zenJFrnoefWdZ23OyuBBj2JAbwsEsbdiyEDSv/qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9f+YDxi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C16606A31C;
	Wed, 28 Oct 2026 19:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9f+YDxi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29371F01825;
	Wed, 28 Oct 2026 19:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215102;
	bh=6pjXSQokKODI4dmDZBTId/+CQFM5uK9caagmq6vpN3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9f+YDxiRC0RkQg9QbZaHxa3m9Xi7Zv1n82/ND3Ex39b/UyBuo7yHkVPnjd/Emxp0
	 RGDccw1gnA+dBRbi7e4Tq+EoPf2ufYBrgznPjaYsRmED4LFZH7a2WXr8WPaWF7kUOv
	 Qj//YaNcGelV4j9z/t6I9Rf+uuMTx+BKW/+++l/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Lianjie Wang <karin0.zst@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1039/1887] hwrng: core - use RCU and work_struct to fix race condition
Date: Wed, 28 Oct 2026 17:52:15 +0100
Message-ID: <20261028170523.054423091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lianjie Wang <karin0.zst@gmail.com>

[ Upstream commit cc2f39d6ac48e6e3cb2d6240bc0d6df839dd0828 ]

Currently, hwrng_fill is not cleared until the hwrng_fillfn() thread
exits. Since hwrng_unregister() reads hwrng_fill outside the rng_mutex
lock, a concurrent hwrng_unregister() may call kthread_stop() again on
the same task.

Additionally, if hwrng_unregister() is called immediately after
hwrng_register(), the stopped thread may have never been executed. Thus,
hwrng_fill remains dirty even after hwrng_unregister() returns. In this
case, subsequent calls to hwrng_register() will fail to start new
threads, and hwrng_unregister() will call kthread_stop() on the same
freed task. In both cases, a use-after-free occurs:

refcount_t: addition on 0; use-after-free.
WARNING: ... at lib/refcount.c:25 refcount_warn_saturate+0xec/0x1c0
Call Trace:
 kthread_stop+0x181/0x360
 hwrng_unregister+0x288/0x380
 virtrng_remove+0xe3/0x200

This patch fixes the race by protecting the global hwrng_fill pointer
inside the rng_mutex lock, so that hwrng_fillfn() thread is stopped only
once, and calls to kthread_run() and kthread_stop() are serialized
with the lock held.

To avoid deadlock in hwrng_fillfn() while being stopped with the lock
held, we convert current_rng to RCU, so that get_current_rng() can read
current_rng without holding the lock. To remove the lock from put_rng(),
we also delay the actual cleanup into a work_struct.

Since get_current_rng() no longer returns ERR_PTR values, the IS_ERR()
checks are removed from its callers.

With hwrng_fill protected by the rng_mutex lock, hwrng_fillfn() can no
longer clear hwrng_fill itself. Therefore, if hwrng_fillfn() returns
directly after current_rng is dropped, kthread_stop() would be called on
a freed task_struct later. To fix this, hwrng_fillfn() calls schedule()
now to keep the task alive until being stopped. The kthread_stop() call
is also moved from hwrng_unregister() to drop_current_rng(), ensuring
kthread_stop() is called on all possible paths where current_rng becomes
NULL, so that the thread would not wait forever.

Fixes: be4000bc4644 ("hwrng: create filler thread")
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Lianjie Wang <karin0.zst@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 149 ++++++++++++++++++++++------------
 include/linux/hw_random.h     |   2 +
 2 files changed, 100 insertions(+), 51 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index c319f99377096..1f72ffc2017ed 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -22,22 +22,24 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/random.h>
+#include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
+#include <linux/workqueue.h>
 
 #define RNG_MODULE_NAME		"hw_random"
 
 #define RNG_BUFFER_SIZE (SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES)
 
-static struct hwrng *current_rng;
+static struct hwrng __rcu *current_rng;
 /* the current rng has been explicitly chosen by user via sysfs */
 static int cur_rng_set_by_user;
 static struct task_struct *hwrng_fill;
 /* list of registered rngs */
 static LIST_HEAD(rng_list);
-/* Protects rng_list and current_rng */
+/* Protects rng_list, hwrng_fill and updating on current_rng */
 static DEFINE_MUTEX(rng_mutex);
 /* Protects rng read functions, data_avail, rng_buffer and rng_fillbuf */
 static DEFINE_MUTEX(reading_mutex);
@@ -76,18 +78,39 @@ static void add_early_randomness(struct hwrng *rng)
 		add_device_randomness(rng_fillbuf, bytes_read);
 }
 
-static inline void cleanup_rng(struct kref *kref)
+static void cleanup_rng_work(struct work_struct *work)
 {
-	struct hwrng *rng = container_of(kref, struct hwrng, ref);
+	struct hwrng *rng = container_of(work, struct hwrng, cleanup_work);
+
+	/*
+	 * Hold rng_mutex here so we serialize in case they set_current_rng
+	 * on rng again immediately.
+	 */
+	mutex_lock(&rng_mutex);
+
+	/* Skip if rng has been reinitialized. */
+	if (kref_read(&rng->ref)) {
+		mutex_unlock(&rng_mutex);
+		return;
+	}
 
 	if (rng->cleanup)
 		rng->cleanup(rng);
 
 	complete(&rng->cleanup_done);
+	mutex_unlock(&rng_mutex);
+}
+
+static inline void cleanup_rng(struct kref *kref)
+{
+	struct hwrng *rng = container_of(kref, struct hwrng, ref);
+
+	schedule_work(&rng->cleanup_work);
 }
 
 static int set_current_rng(struct hwrng *rng)
 {
+	struct hwrng *old_rng;
 	int err;
 
 	BUG_ON(!mutex_is_locked(&rng_mutex));
@@ -96,8 +119,14 @@ static int set_current_rng(struct hwrng *rng)
 	if (err)
 		return err;
 
-	drop_current_rng();
-	current_rng = rng;
+	old_rng = rcu_dereference_protected(current_rng,
+					    lockdep_is_held(&rng_mutex));
+	rcu_assign_pointer(current_rng, rng);
+
+	if (old_rng) {
+		synchronize_rcu();
+		kref_put(&old_rng->ref, cleanup_rng);
+	}
 
 	/* if necessary, start hwrng thread */
 	if (!hwrng_fill) {
@@ -113,47 +142,56 @@ static int set_current_rng(struct hwrng *rng)
 
 static void drop_current_rng(void)
 {
-	BUG_ON(!mutex_is_locked(&rng_mutex));
-	if (!current_rng)
+	struct hwrng *rng;
+
+	rng = rcu_dereference_protected(current_rng,
+					lockdep_is_held(&rng_mutex));
+	if (!rng)
 		return;
 
+	RCU_INIT_POINTER(current_rng, NULL);
+	synchronize_rcu();
+
+	if (hwrng_fill) {
+		kthread_stop(hwrng_fill);
+		hwrng_fill = NULL;
+	}
+
 	/* decrease last reference for triggering the cleanup */
-	kref_put(&current_rng->ref, cleanup_rng);
-	current_rng = NULL;
+	kref_put(&rng->ref, cleanup_rng);
 }
 
-/* Returns ERR_PTR(), NULL or refcounted hwrng */
+/* Returns NULL or refcounted hwrng */
 static struct hwrng *get_current_rng_nolock(void)
 {
-	if (current_rng)
-		kref_get(&current_rng->ref);
+	struct hwrng *rng;
+
+	rng = rcu_dereference_protected(current_rng,
+					lockdep_is_held(&rng_mutex));
+	if (rng)
+		kref_get(&rng->ref);
 
-	return current_rng;
+	return rng;
 }
 
 static struct hwrng *get_current_rng(void)
 {
 	struct hwrng *rng;
 
-	if (mutex_lock_interruptible(&rng_mutex))
-		return ERR_PTR(-ERESTARTSYS);
+	rcu_read_lock();
+	rng = rcu_dereference(current_rng);
+	if (rng)
+		kref_get(&rng->ref);
 
-	rng = get_current_rng_nolock();
+	rcu_read_unlock();
 
-	mutex_unlock(&rng_mutex);
 	return rng;
 }
 
 static void put_rng(struct hwrng *rng)
 {
-	/*
-	 * Hold rng_mutex here so we serialize in case they set_current_rng
-	 * on rng again immediately.
-	 */
-	mutex_lock(&rng_mutex);
 	if (rng)
 		kref_put(&rng->ref, cleanup_rng);
-	mutex_unlock(&rng_mutex);
 }
 
 static int hwrng_init(struct hwrng *rng)
@@ -222,10 +260,6 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 
 	while (size) {
 		rng = get_current_rng();
-		if (IS_ERR(rng)) {
-			err = PTR_ERR(rng);
-			goto out;
-		}
 		if (!rng) {
 			err = -ENODEV;
 			goto out;
@@ -312,7 +346,7 @@ static struct miscdevice rng_miscdev = {
 
 static int enable_best_rng(void)
 {
-	struct hwrng *rng, *new_rng = NULL;
+	struct hwrng *rng, *cur_rng, *new_rng = NULL;
 	int ret = -ENODEV;
 
 	BUG_ON(!mutex_is_locked(&rng_mutex));
@@ -330,7 +364,9 @@ static int enable_best_rng(void)
 			new_rng = rng;
 	}
 
-	ret = ((new_rng == current_rng) ? 0 : set_current_rng(new_rng));
+	cur_rng = rcu_dereference_protected(current_rng,
+					    lockdep_is_held(&rng_mutex));
+	ret = ((new_rng == cur_rng) ? 0 : set_current_rng(new_rng));
 	if (!ret)
 		cur_rng_set_by_user = 0;
 
@@ -381,8 +417,6 @@ static ssize_t rng_current_show(struct device *dev,
 	struct hwrng *rng;
 
 	rng = get_current_rng();
-	if (IS_ERR(rng))
-		return PTR_ERR(rng);
 
 	ret = snprintf(buf, PAGE_SIZE, "%s\n", rng ? rng->name : "none");
 	put_rng(rng);
@@ -426,8 +460,6 @@ static ssize_t rng_quality_show(struct device *dev,
 	struct hwrng *rng;
 
 	rng = get_current_rng();
-	if (IS_ERR(rng))
-		return PTR_ERR(rng);
 
 	if (!rng) /* no need to put_rng */
 		return -ENODEV;
@@ -442,6 +474,7 @@ static ssize_t rng_quality_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t len)
 {
+	struct hwrng *rng;
 	u16 quality;
 	int ret = -EINVAL;
 
@@ -458,12 +491,13 @@ static ssize_t rng_quality_store(struct device *dev,
 		goto out;
 	}
 
-	if (!current_rng) {
+	rng = rcu_dereference_protected(current_rng, lockdep_is_held(&rng_mutex));
+	if (!rng) {
 		ret = -ENODEV;
 		goto out;
 	}
 
-	current_rng->quality = quality;
+	rng->quality = quality;
 	current_quality = quality; /* obsolete */
 
 	/* the best available RNG may have changed */
@@ -509,8 +543,20 @@ static int hwrng_fillfn(void *unused)
 		struct hwrng *rng;
 
 		rng = get_current_rng();
-		if (IS_ERR(rng) || !rng)
+		if (!rng) {
+			/*
+			 * Keep the task_struct alive until kthread_stop()
+			 * is called to avoid UAF in drop_current_rng().
+			 */
+			while (!kthread_should_stop()) {
+				set_current_state(TASK_INTERRUPTIBLE);
+				if (!kthread_should_stop())
+					schedule();
+			}
+			set_current_state(TASK_RUNNING);
 			break;
+		}
+
 		mutex_lock(&reading_mutex);
 		rc = rng_get_data(rng, rng_fillbuf,
 				  rng_buffer_size(), 1);
@@ -538,14 +584,13 @@ static int hwrng_fillfn(void *unused)
 		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
 					   entropy >> 10);
 	}
-	hwrng_fill = NULL;
 	return 0;
 }
 
 int hwrng_register(struct hwrng *rng)
 {
 	int err = -EINVAL;
-	struct hwrng *tmp;
+	struct hwrng *cur_rng, *tmp;
 	bool is_new_current = false;
 
 	if (!rng->name || (!rng->data_read && !rng->read))
@@ -561,12 +606,15 @@ int hwrng_register(struct hwrng *rng)
 	}
 	list_add_tail(&rng->list, &rng_list);
 
+	INIT_WORK(&rng->cleanup_work, cleanup_rng_work);
 	init_completion(&rng->cleanup_done);
 	complete(&rng->cleanup_done);
 	init_completion(&rng->dying);
 
-	if (!current_rng ||
-	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
+	cur_rng = rcu_dereference_protected(current_rng,
+					    lockdep_is_held(&rng_mutex));
+	if (!cur_rng ||
+	    (!cur_rng_set_by_user && rng->quality > cur_rng->quality)) {
 		/*
 		 * Set new rng as current as the new rng source
 		 * provides better entropy quality and was not
@@ -604,15 +652,19 @@ EXPORT_SYMBOL_GPL(hwrng_register);
 
 void hwrng_unregister(struct hwrng *rng)
 {
-	struct hwrng *old_rng, *new_rng;
+	struct hwrng *cur_rng, *old_rng, *new_rng;
 	int err;
 
 	mutex_lock(&rng_mutex);
 
-	old_rng = current_rng;
+	old_rng = rcu_dereference_protected(current_rng,
+					    lockdep_is_held(&rng_mutex));
 	list_del(&rng->list);
 	complete_all(&rng->dying);
-	if (current_rng == rng) {
+
+	cur_rng = rcu_dereference_protected(current_rng,
+					    lockdep_is_held(&rng_mutex));
+	if (cur_rng == rng) {
 		err = enable_best_rng();
 		if (err) {
 			drop_current_rng();
@@ -621,12 +673,7 @@ void hwrng_unregister(struct hwrng *rng)
 	}
 
 	new_rng = get_current_rng_nolock();
-	if (list_empty(&rng_list)) {
-		mutex_unlock(&rng_mutex);
-		if (hwrng_fill)
-			kthread_stop(hwrng_fill);
-	} else
-		mutex_unlock(&rng_mutex);
+	mutex_unlock(&rng_mutex);
 
 	if (new_rng) {
 		if (old_rng != new_rng)
@@ -721,7 +768,7 @@ static int __init hwrng_modinit(void)
 static void __exit hwrng_modexit(void)
 {
 	mutex_lock(&rng_mutex);
-	BUG_ON(current_rng);
+	WARN_ON(rcu_access_pointer(current_rng));
 	kfree(rng_buffer);
 	kfree(rng_fillbuf);
 	mutex_unlock(&rng_mutex);
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 2505d58bd5829..e207044a776a5 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/kref.h>
+#include <linux/workqueue.h>
 
 /**
  * struct hwrng - Hardware Random Number Generator driver
@@ -49,6 +50,7 @@ struct hwrng {
 	/* internal. */
 	struct list_head list;
 	struct kref ref;
+	struct work_struct cleanup_work;
 	struct completion cleanup_done;
 	struct completion dying;
 };
-- 
2.53.0



