Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C951474AF;
	Fri,  6 Dec 2024 14:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496823; cv=none; b=RCZCpl1dsg7juuVc48mZp/LGz9VdEwG6RP9o4KIR8BpL/EX9ijZhlincTABTZae+fvWUzuzCTxa/5YDL2SgKE2UGIR+j1WjljFx5zapzuWbmBFWU7gaToxk0c4CbXw9kHwhdHMfJgVHTifi0jMkMk6v/KcLpkDI54R79vTmp89Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496823; c=relaxed/simple;
	bh=PxPvXxRjQaWfCCtiiWiMIMvQ40RyfxtyR848ZcuBijU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2tBZFRJQSk/CM5aQKvWwaboe75eOoRkCUgqVx4vIC50BpCETFTv54xl1ONLh2SJxrnBqMGmkFwaEES4YNGJma2ygsKnlQTqZRyr8r/ym4k1UPGzMZJ3D/zfJeSVNH8qnIQa0aS2cIv9g1bTI//hEbjt23npP55xmFXj99GDErc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6ISOmgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6ISOmgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68092C4CED1;
	Fri,  6 Dec 2024 14:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496822;
	bh=PxPvXxRjQaWfCCtiiWiMIMvQ40RyfxtyR848ZcuBijU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6ISOmgstPWhTuhWlnW1UEyXPv9Nx/l6VtTjMhnqNyvEY5Bz2wwnCPCCBNOrRVVa6
	 bSY9BFHbNGVfobJXCF7YoNdShelQQ28sE409RIo9pqn4Nvae9IkQ42FwepZOfelON/
	 DNsZn0uZ5yfgbuK+WOQUNbTf3MRrgCbTaOVyZYbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/676] kcsan, seqlock: Support seqcount_latch_t
Date: Fri,  6 Dec 2024 15:28:47 +0100
Message-ID: <20241206143657.579595547@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

[ Upstream commit 5c1806c41ce0a0110db5dd4c483cf2dc28b3ddf0 ]

While fuzzing an arm64 kernel, Alexander Potapenko reported:

| BUG: KCSAN: data-race in ktime_get_mono_fast_ns / timekeeping_update
|
| write to 0xffffffc082e74248 of 56 bytes by interrupt on cpu 0:
|  update_fast_timekeeper kernel/time/timekeeping.c:430 [inline]
|  timekeeping_update+0x1d8/0x2d8 kernel/time/timekeeping.c:768
|  timekeeping_advance+0x9e8/0xb78 kernel/time/timekeeping.c:2344
|  update_wall_time+0x18/0x38 kernel/time/timekeeping.c:2360
|  [...]
|
| read to 0xffffffc082e74258 of 8 bytes by task 5260 on cpu 1:
|  __ktime_get_fast_ns kernel/time/timekeeping.c:372 [inline]
|  ktime_get_mono_fast_ns+0x88/0x174 kernel/time/timekeeping.c:489
|  init_srcu_struct_fields+0x40c/0x530 kernel/rcu/srcutree.c:263
|  init_srcu_struct+0x14/0x20 kernel/rcu/srcutree.c:311
|  [...]
|
| value changed: 0x000002f875d33266 -> 0x000002f877416866
|
| Reported by Kernel Concurrency Sanitizer on:
| CPU: 1 UID: 0 PID: 5260 Comm: syz.2.7483 Not tainted 6.12.0-rc3-dirty #78

This is a false positive data race between a seqcount latch writer and a reader
accessing stale data. Since its introduction, KCSAN has never understood the
seqcount_latch interface (due to being unannotated).

Unlike the regular seqlock interface, the seqcount_latch interface for latch
writers never has had a well-defined critical section, making it difficult to
teach tooling where the critical section starts and ends.

Introduce an instrumentable (non-raw) seqcount_latch interface, with
which we can clearly denote writer critical sections. This both helps
readability and tooling like KCSAN to understand when the writer is done
updating all latch copies.

Fixes: 88ecd153be95 ("seqlock, kcsan: Add annotations for KCSAN")
Reported-by: Alexander Potapenko <glider@google.com>
Co-developed-by: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Signed-off-by: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241104161910.780003-4-elver@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/locking/seqlock.rst |  2 +-
 include/linux/seqlock.h           | 86 +++++++++++++++++++++++++------
 2 files changed, 72 insertions(+), 16 deletions(-)

diff --git a/Documentation/locking/seqlock.rst b/Documentation/locking/seqlock.rst
index bfda1a5fecadc..ec6411d02ac8f 100644
--- a/Documentation/locking/seqlock.rst
+++ b/Documentation/locking/seqlock.rst
@@ -153,7 +153,7 @@ Use seqcount_latch_t when the write side sections cannot be protected
 from interruption by readers. This is typically the case when the read
 side can be invoked from NMI handlers.
 
-Check `raw_write_seqcount_latch()` for more information.
+Check `write_seqcount_latch()` for more information.
 
 
 .. _seqlock_t:
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index e9bd2f65d7f4e..484f9a179fc12 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -682,6 +682,23 @@ static __always_inline unsigned raw_read_seqcount_latch(const seqcount_latch_t *
 	return READ_ONCE(s->seqcount.sequence);
 }
 
+/**
+ * read_seqcount_latch() - pick even/odd latch data copy
+ * @s: Pointer to seqcount_latch_t
+ *
+ * See write_seqcount_latch() for details and a full reader/writer usage
+ * example.
+ *
+ * Return: sequence counter raw value. Use the lowest bit as an index for
+ * picking which data copy to read. The full counter must then be checked
+ * with read_seqcount_latch_retry().
+ */
+static __always_inline unsigned read_seqcount_latch(const seqcount_latch_t *s)
+{
+	kcsan_atomic_next(KCSAN_SEQLOCK_REGION_MAX);
+	return raw_read_seqcount_latch(s);
+}
+
 /**
  * raw_read_seqcount_latch_retry() - end a seqcount_latch_t read section
  * @s:		Pointer to seqcount_latch_t
@@ -696,9 +713,34 @@ raw_read_seqcount_latch_retry(const seqcount_latch_t *s, unsigned start)
 	return unlikely(READ_ONCE(s->seqcount.sequence) != start);
 }
 
+/**
+ * read_seqcount_latch_retry() - end a seqcount_latch_t read section
+ * @s:		Pointer to seqcount_latch_t
+ * @start:	count, from read_seqcount_latch()
+ *
+ * Return: true if a read section retry is required, else false
+ */
+static __always_inline int
+read_seqcount_latch_retry(const seqcount_latch_t *s, unsigned start)
+{
+	kcsan_atomic_next(0);
+	return raw_read_seqcount_latch_retry(s, start);
+}
+
 /**
  * raw_write_seqcount_latch() - redirect latch readers to even/odd copy
  * @s: Pointer to seqcount_latch_t
+ */
+static __always_inline void raw_write_seqcount_latch(seqcount_latch_t *s)
+{
+	smp_wmb();	/* prior stores before incrementing "sequence" */
+	s->seqcount.sequence++;
+	smp_wmb();      /* increment "sequence" before following stores */
+}
+
+/**
+ * write_seqcount_latch_begin() - redirect latch readers to odd copy
+ * @s: Pointer to seqcount_latch_t
  *
  * The latch technique is a multiversion concurrency control method that allows
  * queries during non-atomic modifications. If you can guarantee queries never
@@ -726,17 +768,11 @@ raw_read_seqcount_latch_retry(const seqcount_latch_t *s, unsigned start)
  *
  *	void latch_modify(struct latch_struct *latch, ...)
  *	{
- *		smp_wmb();	// Ensure that the last data[1] update is visible
- *		latch->seq.sequence++;
- *		smp_wmb();	// Ensure that the seqcount update is visible
- *
+ *		write_seqcount_latch_begin(&latch->seq);
  *		modify(latch->data[0], ...);
- *
- *		smp_wmb();	// Ensure that the data[0] update is visible
- *		latch->seq.sequence++;
- *		smp_wmb();	// Ensure that the seqcount update is visible
- *
+ *		write_seqcount_latch(&latch->seq);
  *		modify(latch->data[1], ...);
+ *		write_seqcount_latch_end(&latch->seq);
  *	}
  *
  * The query will have a form like::
@@ -747,13 +783,13 @@ raw_read_seqcount_latch_retry(const seqcount_latch_t *s, unsigned start)
  *		unsigned seq, idx;
  *
  *		do {
- *			seq = raw_read_seqcount_latch(&latch->seq);
+ *			seq = read_seqcount_latch(&latch->seq);
  *
  *			idx = seq & 0x01;
  *			entry = data_query(latch->data[idx], ...);
  *
  *		// This includes needed smp_rmb()
- *		} while (raw_read_seqcount_latch_retry(&latch->seq, seq));
+ *		} while (read_seqcount_latch_retry(&latch->seq, seq));
  *
  *		return entry;
  *	}
@@ -777,11 +813,31 @@ raw_read_seqcount_latch_retry(const seqcount_latch_t *s, unsigned start)
  *	When data is a dynamic data structure; one should use regular RCU
  *	patterns to manage the lifetimes of the objects within.
  */
-static inline void raw_write_seqcount_latch(seqcount_latch_t *s)
+static __always_inline void write_seqcount_latch_begin(seqcount_latch_t *s)
 {
-	smp_wmb();	/* prior stores before incrementing "sequence" */
-	s->seqcount.sequence++;
-	smp_wmb();      /* increment "sequence" before following stores */
+	kcsan_nestable_atomic_begin();
+	raw_write_seqcount_latch(s);
+}
+
+/**
+ * write_seqcount_latch() - redirect latch readers to even copy
+ * @s: Pointer to seqcount_latch_t
+ */
+static __always_inline void write_seqcount_latch(seqcount_latch_t *s)
+{
+	raw_write_seqcount_latch(s);
+}
+
+/**
+ * write_seqcount_latch_end() - end a seqcount_latch_t write section
+ * @s:		Pointer to seqcount_latch_t
+ *
+ * Marks the end of a seqcount_latch_t writer section, after all copies of the
+ * latch-protected data have been updated.
+ */
+static __always_inline void write_seqcount_latch_end(seqcount_latch_t *s)
+{
+	kcsan_nestable_atomic_end();
 }
 
 /*
-- 
2.43.0



