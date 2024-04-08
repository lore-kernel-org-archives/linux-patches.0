Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBCF7F492;
	Mon,  8 Apr 2024 14:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584999; cv=none; b=d1YcL+8eqB5o5upeqvALx949N7j8FLCRvy4dm45qX7R9pBpDe/GxhfwjjyfCkU5JuLkNoiyvV8/QVeAa6u6OeEemZJUP3Gc1l3EydUtEuStZ0vwd8b3/3mPHRRnF1Oqwn6CknmPvkwOB5oHpWKPwvcbRP9pajOkTKFtTvwE3f3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584999; c=relaxed/simple;
	bh=74JCT4EIqqZFrnyW3bFHlnIHj8XoDjUw/KbuTzr3EXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBaB3rM+l5dbAeKtgGX4skWVBBp7yvGTXC8emVmotDzxOELvN/X7njBP4mKacOVjKnnnIw+C1YnrSFUdpataR21wUl5EYcAuNKhXgkZciD5uzN372YSx/C5XBPkx77W17Qi8lVEsXkzu5SCxmpT+czm2opdL8exs5yz+0/WQScU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPsk3Xa7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPsk3Xa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033EDC433C7;
	Mon,  8 Apr 2024 14:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584999;
	bh=74JCT4EIqqZFrnyW3bFHlnIHj8XoDjUw/KbuTzr3EXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPsk3Xa7WnYEBJTqkgA2ERVgGUKas5wDD94I5A60XCzIXzLUocQqxALVpGPNKrbjH
	 HAT/yv7xp7EOWz1LxN3JtDf9OsSQXQ/3mfJrTuwZsFfszqo3ELJt/bICchw61Ua07u
	 6e/MkC+rLLyeNL6rgqUukH/GKAvhQi2gyOn25wu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 5.15 629/690] locking/rwsem: Disable preemption while trying for rwsem lock
Date: Mon,  8 Apr 2024 14:58:15 +0200
Message-ID: <20240408125422.444420264@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>

commit 48dfb5d2560d36fb16c7d430c229d1604ea7d185 upstream.

Make the region inside the rwsem_write_trylock non preemptible.

We observe RT task is hogging CPU when trying to acquire rwsem lock
which was acquired by a kworker task but before the rwsem owner was set.

Here is the scenario:
1. CFS task (affined to a particular CPU) takes rwsem lock.

2. CFS task gets preempted by a RT task before setting owner.

3. RT task (FIFO) is trying to acquire the lock, but spinning until
RT throttling happens for the lock as the lock was taken by CFS task.

This patch attempts to fix the above issue by disabling preemption
until owner is set for the lock. While at it also fix the issues
at the places where rwsem_{set,clear}_owner() are called.

This also adds lockdep annotation of preemption disable in
rwsem_{set,clear}_owner() on Peter Z. suggestion.

Signed-off-by: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>
Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/1662661467-24203-1-git-send-email-quic_mojha@quicinc.com
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rwsem.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -133,14 +133,19 @@
  * the owner value concurrently without lock. Read from owner, however,
  * may not need READ_ONCE() as long as the pointer value is only used
  * for comparison and isn't being dereferenced.
+ *
+ * Both rwsem_{set,clear}_owner() functions should be in the same
+ * preempt disable section as the atomic op that changes sem->count.
  */
 static inline void rwsem_set_owner(struct rw_semaphore *sem)
 {
+	lockdep_assert_preemption_disabled();
 	atomic_long_set(&sem->owner, (long)current);
 }
 
 static inline void rwsem_clear_owner(struct rw_semaphore *sem)
 {
+	lockdep_assert_preemption_disabled();
 	atomic_long_set(&sem->owner, 0);
 }
 
@@ -251,13 +256,16 @@ static inline bool rwsem_read_trylock(st
 static inline bool rwsem_write_trylock(struct rw_semaphore *sem)
 {
 	long tmp = RWSEM_UNLOCKED_VALUE;
+	bool ret = false;
 
+	preempt_disable();
 	if (atomic_long_try_cmpxchg_acquire(&sem->count, &tmp, RWSEM_WRITER_LOCKED)) {
 		rwsem_set_owner(sem);
-		return true;
+		ret = true;
 	}
 
-	return false;
+	preempt_enable();
+	return ret;
 }
 
 /*
@@ -1341,8 +1349,10 @@ static inline void __up_write(struct rw_
 	DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) &&
 			    !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE), sem);
 
+	preempt_disable();
 	rwsem_clear_owner(sem);
 	tmp = atomic_long_fetch_add_release(-RWSEM_WRITER_LOCKED, &sem->count);
+	preempt_enable();
 	if (unlikely(tmp & RWSEM_FLAG_WAITERS))
 		rwsem_wake(sem);
 }


