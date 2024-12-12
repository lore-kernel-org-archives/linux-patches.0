Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780BE236938;
	Thu, 12 Dec 2024 16:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021946; cv=none; b=odqskBY5IR/5h4jlPRvNMGgBVObWEN+LzCHm+y0Grz+iQiTMThwNPecpu5j42CrUVWWduoOClk2WR5tPPZBCA/wPB8S0nZqvSWYBLNQTzTsZa3eCTYW5FUE49j0TCHa6SERegBuTTQiJcT7GbStfIkseLIhDd6vNmKDgwp/xJp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021946; c=relaxed/simple;
	bh=bzR2wCWl5pC5YIM6HoEzcL36mdNa1Z0B7SdU4T2Uoo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9TCtxHsyPZ6+uG8t1jahYCsfIUeWADdq6kN06hFcfRbyz42wpDe9n0ZkIPXzbh+I/1RHcXpcOuDeKiCw0dvx0yEN1WzkLWuyFw9VtFn/xADIJtIWNFeM3Xuv0qybnUIiO5TDz7F4Vw0OkBgahbyzY/0qxwsoYRgh2RF3tSbx/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NmqKGJ55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NmqKGJ55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5B5C4CECE;
	Thu, 12 Dec 2024 16:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021946;
	bh=bzR2wCWl5pC5YIM6HoEzcL36mdNa1Z0B7SdU4T2Uoo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmqKGJ55taon4XdIVfWiLhxy5Ibg8ENrXsaMQm2RX7qQPXmTMWEthgk7Gu1hu6sZ6
	 h6/YTuS4WN4mKBJQE2UMOfRjkkl86duCS36z4omW0zSMbkuNQhqJnjfdw1FVmPUzI4
	 xt2/ciEiVIWOvYF4U9aLtFyqb4RayHre8LlK2P84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH 5.15 106/565] seqlock/latch: Provide raw_read_seqcount_latch_retry()
Date: Thu, 12 Dec 2024 15:55:01 +0100
Message-ID: <20241212144315.667797021@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit d16317de9b412aa7bd3598c607112298e36b4352 ]

The read side of seqcount_latch consists of:

  do {
    seq = raw_read_seqcount_latch(&latch->seq);
    ...
  } while (read_seqcount_latch_retry(&latch->seq, seq));

which is asymmetric in the raw_ department, and sure enough,
read_seqcount_latch_retry() includes (explicit) instrumentation where
raw_read_seqcount_latch() does not.

This inconsistency becomes a problem when trying to use it from
noinstr code. As such, fix it by renaming and re-implementing
raw_read_seqcount_latch_retry() without the instrumentation.

Specifically the instrumentation in question is kcsan_atomic_next(0)
in do___read_seqcount_retry(). Loosing this annotation is not a
problem because raw_read_seqcount_latch() does not pass through
kcsan_atomic_next(KCSAN_SEQLOCK_REGION_MAX).

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Michael Kelley <mikelley@microsoft.com>  # Hyper-V
Link: https://lore.kernel.org/r/20230519102715.233598176@infradead.org
Stable-dep-of: 5c1806c41ce0 ("kcsan, seqlock: Support seqcount_latch_t")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rbtree_latch.h |  2 +-
 include/linux/seqlock.h      | 15 ++++++++-------
 kernel/printk/printk.c       |  2 +-
 kernel/time/sched_clock.c    |  2 +-
 kernel/time/timekeeping.c    |  4 ++--
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/rbtree_latch.h b/include/linux/rbtree_latch.h
index 3d1a9e716b803..6a0999c26c7cf 100644
--- a/include/linux/rbtree_latch.h
+++ b/include/linux/rbtree_latch.h
@@ -206,7 +206,7 @@ latch_tree_find(void *key, struct latch_tree_root *root,
 	do {
 		seq = raw_read_seqcount_latch(&root->seq);
 		node = __lt_find(key, root, seq & 1, ops->comp);
-	} while (read_seqcount_latch_retry(&root->seq, seq));
+	} while (raw_read_seqcount_latch_retry(&root->seq, seq));
 
 	return node;
 }
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 2c5d0102315d2..97831499d5005 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -675,9 +675,9 @@ typedef struct {
  *
  * Return: sequence counter raw value. Use the lowest bit as an index for
  * picking which data copy to read. The full counter must then be checked
- * with read_seqcount_latch_retry().
+ * with raw_read_seqcount_latch_retry().
  */
-static inline unsigned raw_read_seqcount_latch(const seqcount_latch_t *s)
+static __always_inline unsigned raw_read_seqcount_latch(const seqcount_latch_t *s)
 {
 	/*
 	 * Pairs with the first smp_wmb() in raw_write_seqcount_latch().
@@ -687,16 +687,17 @@ static inline unsigned raw_read_seqcount_latch(const seqcount_latch_t *s)
 }
 
 /**
- * read_seqcount_latch_retry() - end a seqcount_latch_t read section
+ * raw_read_seqcount_latch_retry() - end a seqcount_latch_t read section
  * @s:		Pointer to seqcount_latch_t
  * @start:	count, from raw_read_seqcount_latch()
  *
  * Return: true if a read section retry is required, else false
  */
-static inline int
-read_seqcount_latch_retry(const seqcount_latch_t *s, unsigned start)
+static __always_inline int
+raw_read_seqcount_latch_retry(const seqcount_latch_t *s, unsigned start)
 {
-	return read_seqcount_retry(&s->seqcount, start);
+	smp_rmb();
+	return unlikely(READ_ONCE(s->seqcount.sequence) != start);
 }
 
 /**
@@ -756,7 +757,7 @@ read_seqcount_latch_retry(const seqcount_latch_t *s, unsigned start)
  *			entry = data_query(latch->data[idx], ...);
  *
  *		// This includes needed smp_rmb()
- *		} while (read_seqcount_latch_retry(&latch->seq, seq));
+ *		} while (raw_read_seqcount_latch_retry(&latch->seq, seq));
  *
  *		return entry;
  *	}
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 323931ff61191..5e81d2a79d5cc 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -457,7 +457,7 @@ static u64 latched_seq_read_nolock(struct latched_seq *ls)
 		seq = raw_read_seqcount_latch(&ls->latch);
 		idx = seq & 0x1;
 		val = ls->val[idx];
-	} while (read_seqcount_latch_retry(&ls->latch, seq));
+	} while (raw_read_seqcount_latch_retry(&ls->latch, seq));
 
 	return val;
 }
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index b1b9b12899f5e..f3657e964616a 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -76,7 +76,7 @@ notrace struct clock_read_data *sched_clock_read_begin(unsigned int *seq)
 
 notrace int sched_clock_read_retry(unsigned int seq)
 {
-	return read_seqcount_latch_retry(&cd.seq, seq);
+	return raw_read_seqcount_latch_retry(&cd.seq, seq);
 }
 
 unsigned long long notrace sched_clock(void)
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 7f755127bee41..07c949c10de28 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -450,7 +450,7 @@ static __always_inline u64 __ktime_get_fast_ns(struct tk_fast *tkf)
 		tkr = tkf->base + (seq & 0x01);
 		now = ktime_to_ns(tkr->base);
 		now += fast_tk_get_delta_ns(tkr);
-	} while (read_seqcount_latch_retry(&tkf->seq, seq));
+	} while (raw_read_seqcount_latch_retry(&tkf->seq, seq));
 
 	return now;
 }
@@ -549,7 +549,7 @@ static __always_inline u64 __ktime_get_real_fast(struct tk_fast *tkf, u64 *mono)
 		basem = ktime_to_ns(tkr->base);
 		baser = ktime_to_ns(tkr->base_real);
 		delta = fast_tk_get_delta_ns(tkr);
-	} while (read_seqcount_latch_retry(&tkf->seq, seq));
+	} while (raw_read_seqcount_latch_retry(&tkf->seq, seq));
 
 	if (mono)
 		*mono = basem + delta;
-- 
2.43.0



