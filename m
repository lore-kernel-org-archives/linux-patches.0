Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A281AA59;
	Wed, 30 Sep 2026 18:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791461; cv=none; b=RoGXLb1Wy9+muJIR3uFkXsAFzZzfb3syrIb9hccmSgL8zKmeEC2DtHc4pc7+di00oq1JTofyTDY95q5YkQNCIC2r9ryxG/5i5BYhVHx1gKSXfoRag6ERNcPm6Lh4m/OY18w/j+1Sy4b6aD3rtapuloUbkQzQ7fGrV48mWuXTW+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791461; c=relaxed/simple;
	bh=YmjR41BXDY7IL7MyopoS0xx8+7sv8fFQIq944hDPfEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTVjPlGIZbIghnGkfCoXGdcTEhWR1G2Au6KIUR3qfTl9YI0IkDBrtGdwHYR8aAJ5SRc2mGOEWGQYxWpqqgIzQXeW6z/yymBLq4F1d6XCAYTCetPB03Cu2T1hb7iPelXxETV8iUcokXgpKI9NAZBEyEL07qSzgzId4XH8uctf2c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJeRv20S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJeRv20S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F391F000FF;
	Wed, 30 Sep 2026 18:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791460;
	bh=UpPqiO/pCt9Pf07dMHptfs9Jwyi4aXUkpuhQPY6cuqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJeRv20SRHX627AjCFw0WXX1ngnfwc7uycOIjhD3F0a+m2Hu47zeZ6RyLkg3O+uCr
	 069IFIPvMyuRTJy9Lpz3NKDqe6psrFXbmxiSZ+6Aye27KkY624UXxcu1dU07rAQoPi
	 a+41G3izv30ULcwl8nL4bntn/alhsGaxtDhxg48o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <longman@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/752] locking/lockdep: Introduce lock_sync()
Date: Wed, 30 Sep 2026 17:22:23 +0200
Message-ID: <20260930152404.192381146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boqun Feng <boqun.feng@gmail.com>

[ Upstream commit 2f1f043e7bea3fbf4c1869df2f7a0312bc8ca2bf ]

Currently, functions like synchronize_srcu() do not have lockdep
annotations resembling those of other write-side locking primitives.
Such annotations might look as follows:

	lock_acquire();
	lock_release();

Such annotations would tell lockdep that synchronize_srcu() acts like
an empty critical section that waits for other (read-side) critical
sections to finish.  This would definitely catch some deadlock, but
as pointed out by Paul Mckenney [1], this could also introduce false
positives because of irq-safe/unsafe detection.  Of course, there are
tricks could help with this:

	might_sleep(); // Existing statement in __synchronize_srcu().
	if (IS_ENABLED(CONFIG_PROVE_LOCKING)) {
		local_irq_disable();
		lock_acquire();
		lock_release();
		local_irq_enable();
	}

But it would be better for lockdep to provide a separate annonation for
functions like synchronize_srcu(), so that people won't need to repeat
the ugly tricks above.

Therefore introduce lock_sync(), which is simply an lock+unlock
pair with no irq safe/unsafe deadlock check.  This works because the
to-be-annontated functions do not create real critical sections, and
there is therefore no way that irq can create extra dependencies.

[1]: https://lore.kernel.org/lkml/20180412021233.ewncg5jjuzjw3x62@tardis/

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
[ boqun: Fix typos reported by Davidlohr Bueso and Paul E. Mckenney ]
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Stable-dep-of: 02c6be7d675b ("locking/lockdep: Invalidate stale class_cache entries for zapped classes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/lockdep.h  |  5 +++++
 kernel/locking/lockdep.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index c6a06273f69a8..4ec21addcec3a 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -272,6 +272,10 @@ extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 extern void lock_release(struct lockdep_map *lock, unsigned long ip);
 
+extern void lock_sync(struct lockdep_map *lock, unsigned int subclass,
+		      int read, int check, struct lockdep_map *nest_lock,
+		      unsigned long ip);
+
 /* lock_is_held_type() returns */
 #define LOCK_STATE_UNKNOWN	-1
 #define LOCK_STATE_NOT_HELD	0
@@ -572,6 +576,7 @@ do {									\
 #define lock_map_acquire_read(l)		lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
 #define lock_map_acquire_tryread(l)		lock_acquire_shared_recursive(l, 0, 1, NULL, _THIS_IP_)
 #define lock_map_release(l)			lock_release(l, _THIS_IP_)
+#define lock_map_sync(l)			lock_sync(l, 0, 0, 1, NULL, _THIS_IP_)
 
 #ifdef CONFIG_PROVE_LOCKING
 # define might_lock(lock)						\
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index fc4dfaf115a23..585d0b5574a5c 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5649,6 +5649,40 @@ void lock_release(struct lockdep_map *lock, unsigned long ip)
 }
 EXPORT_SYMBOL_GPL(lock_release);
 
+/*
+ * lock_sync() - A special annotation for synchronize_{s,}rcu()-like API.
+ *
+ * No actual critical section is created by the APIs annotated with this: these
+ * APIs are used to wait for one or multiple critical sections (on other CPUs
+ * or threads), and it means that calling these APIs inside these critical
+ * sections is potential deadlock.
+ *
+ * This annotation acts as an acquire+release annotation pair with hardirqoff
+ * being 1. Since there's no critical section, no interrupt can create extra
+ * dependencies "inside" the annotation, hardirqoff == 1 allows us to avoid
+ * false positives.
+ */
+void lock_sync(struct lockdep_map *lock, unsigned subclass, int read,
+	       int check, struct lockdep_map *nest_lock, unsigned long ip)
+{
+	unsigned long flags;
+
+	if (unlikely(!lockdep_enabled()))
+		return;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+
+	lockdep_recursion_inc();
+	__lock_acquire(lock, subclass, 0, read, check, 1, nest_lock, ip, 0, 0);
+
+	if (__lock_release(lock, ip))
+		check_chain_key(current);
+	lockdep_recursion_finish();
+	raw_local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(lock_sync);
+
 noinstr int lock_is_held_type(const struct lockdep_map *lock, int read)
 {
 	unsigned long flags;
-- 
2.53.0



