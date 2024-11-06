Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01411DFE38;
	Wed,  6 Nov 2024 13:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898745; cv=none; b=NonCqnw870+XajxR1lPeNQ+NsCwGdEdSs+FkWS8DWSHHByecbb1D8zNwAZNjEFU17adzwn8wcOUShUX+zTVbX9Mq4VCoSYo5GWzgtlanJS9VzBjwYbFy5vLzCdt++DqFchTIvv404LE37drduAjdJhCuK/+5wOj4AmIV824WpS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898745; c=relaxed/simple;
	bh=kZ2fSRLMHs+Am28rO0r6Pg/uFUna114JA8xqoD9V48c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iM1+xr9JT0WjNsCs5zmElDtBB8qDv8v8O6g1IxRpI8YizyxNbWzwTCSIAaE/rGzPSYp//iMnrVhuGBmLYq2WHmUPz92MFQLA8WhqGSDjqNe2zDbhWEQf18SPdeLVunRY4GqQmLAjdWeQ36zN0C4Nf3+E4wwVR16Gb+qT699JpQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qc+9/wkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qc+9/wkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7F7C4CECD;
	Wed,  6 Nov 2024 13:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898745;
	bh=kZ2fSRLMHs+Am28rO0r6Pg/uFUna114JA8xqoD9V48c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qc+9/wkc5Hy3fX007ROaPqToiyUYdQGWYeI85oLE1Fge42tBQ+t7Cb2rO3d+wjOyG
	 EvHiDp5Od/WYZwiOQzDunZphdvBxnf6f5UfTOf9a4wMPkC8sVBVtD73JjtO3Ly6W6A
	 XCaGVkA+kMCvAMHyZfRDa+aMwnxlgwb4d98NmMwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Waiman Long <longman@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Carlos Llamas <cmllamas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 340/462] locking/lockdep: Avoid potential access of invalid memory in lock_class
Date: Wed,  6 Nov 2024 13:03:53 +0100
Message-ID: <20241106120339.922549484@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

commit 61cc4534b6550997c97a03759ab46b29d44c0017 upstream.

It was found that reading /proc/lockdep after a lockdep splat may
potentially cause an access to freed memory if lockdep_unregister_key()
is called after the splat but before access to /proc/lockdep [1]. This
is due to the fact that graph_lock() call in lockdep_unregister_key()
fails after the clearing of debug_locks by the splat process.

After lockdep_unregister_key() is called, the lock_name may be freed
but the corresponding lock_class structure still have a reference to
it. That invalid memory pointer will then be accessed when /proc/lockdep
is read by a user and a use-after-free (UAF) error will be reported if
KASAN is enabled.

To fix this problem, lockdep_unregister_key() is now modified to always
search for a matching key irrespective of the debug_locks state and
zap the corresponding lock class if a matching one is found.

[1] https://lore.kernel.org/lkml/77f05c15-81b6-bddd-9650-80d5f23fe330@i-love.sakura.ne.jp/

Fixes: 8b39adbee805 ("locking/lockdep: Make lockdep_unregister_key() honor 'debug_locks' again")
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lkml.kernel.org/r/20220103023558.1377055-1-longman@redhat.com
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index b9fabbab39183..8e0351970a1da 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5302,7 +5302,13 @@ void lockdep_reset_lock(struct lockdep_map *lock)
 		lockdep_reset_lock_reg(lock);
 }
 
-/* Unregister a dynamically allocated key. */
+/*
+ * Unregister a dynamically allocated key.
+ *
+ * Unlike lockdep_register_key(), a search is always done to find a matching
+ * key irrespective of debug_locks to avoid potential invalid access to freed
+ * memory in lock_class entry.
+ */
 void lockdep_unregister_key(struct lock_class_key *key)
 {
 	struct hlist_head *hash_head = keyhashentry(key);
@@ -5317,10 +5323,8 @@ void lockdep_unregister_key(struct lock_class_key *key)
 		return;
 
 	raw_local_irq_save(flags);
-	if (!graph_lock())
-		goto out_irq;
+	lockdep_lock();
 
-	pf = get_pending_free();
 	hlist_for_each_entry_rcu(k, hash_head, hash_entry) {
 		if (k == key) {
 			hlist_del_rcu(&k->hash_entry);
@@ -5328,11 +5332,13 @@ void lockdep_unregister_key(struct lock_class_key *key)
 			break;
 		}
 	}
-	WARN_ON_ONCE(!found);
-	__lockdep_free_key_range(pf, key, 1);
-	call_rcu_zapped(pf);
-	graph_unlock();
-out_irq:
+	WARN_ON_ONCE(!found && debug_locks);
+	if (found) {
+		pf = get_pending_free();
+		__lockdep_free_key_range(pf, key, 1);
+		call_rcu_zapped(pf);
+	}
+	lockdep_unlock();
 	raw_local_irq_restore(flags);
 
 	/* Wait until is_dynamic_key() has finished accessing k->hash_entry. */
-- 
2.43.0



