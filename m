Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFDD468C08;
	Tue, 25 Aug 2026 13:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665014; cv=none; b=ZSuQXGlAR7vLSiVJ9jFlTS/3luwP49fSe8neEJtqG8nQtdn95YXYER19A39gh/61yUkwZJki1r7RqF+qUeZS8ULi13IhjrE1/MDUDaxKmWZmaaHYIw6FJ6b6dsH1DAWlOOfFcWDhk2L75x0HIJSN78vZprShR8Sa6VLv8/somoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665014; c=relaxed/simple;
	bh=ulaXi5YrMWANBCV5zTq3Hke0tGsWlKucBxLMPUVa89c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceVe1oYzuHIHMuGm4Sg8relnvcWIVPU6r+yt9J9kGq5cIeYxIauYwQQIPG0VLgZLnLgeA2dqFE7vgPY+yCXt6+8WFRxkKGsl96f3IB1au4YAF/LnwzAfHfpPekE1Ee4da4whGyPLH/lNCjpD6sS1eH1OpK0LxB7EEH06VcKW6KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3Ax8C/k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3Ax8C/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F99D1F000E9;
	Tue, 25 Aug 2026 13:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665013;
	bh=DEN+8dbbCuud4rEHqy114rcKKWdQuHV9xZON1zmh7jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3Ax8C/kFOwGYrozPXTvgKugxDC9X3Iq612tgLWR/mWUma2RSD4xspSDtIUQ1Elgq
	 UR2iJ39uVnt7slzpQeTxghwzCGhG3r3Hpz3UGAPOC9Fj3Xj3uhpPPmJ0fQ1F4fJH3X
	 lcCI/+HY6N2mDReqCOooIWi8Ak7BrUXa4i7EfGJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Yao Kai <yaokai34@huawei.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.1 079/101] futex: Fix race in futex_pivot_pending() during private hash resize
Date: Tue, 25 Aug 2026 15:25:57 +0200
Message-ID: <20260825132545.068503583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Kai <yaokai34@huawei.com>

commit 8e7ff730dd96519a333d1570edf1c3fabb6d3629 upstream.

A task performing a custom private hash resize can remain blocked in
uninterruptible sleep indefinitely.  The hung-task detector reports:

  INFO: task futex-resizer:314 blocked for more than 10 seconds.
  task:futex-resizer state:D stack:14824 pid:314 tgid:312 ppid:311

  Call Trace:
   __schedule+0x521/0xf30
   schedule+0x22/0xa0
   futex_hash_allocate+0x3db/0x490
   __do_sys_prctl+0x6f5/0xbd0
   do_syscall_64+0xf9/0x530
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  Kernel panic - not syncing: hung_task: blocked tasks

futex_pivot_pending() allows the resize request to continue when
either no replacement hash is pending (hash_new == NULL) or the current
hash reference count has reached zero.

After the final-reference wake, another futex task can complete the
pivot between the two observations:

  T1                                  T2

  futex_hash_allocate()
    wait_var_event(mm, ...)
      futex_pivot_pending(mm)
        hash_new != NULL
                                      futex_hash()
                                        futex_ref_get(old) -> false
                                        futex_pivot_hash(mm)
                                          hash_new = NULL
                                          __futex_pivot_hash(mm, new)
                                            rcu_assign_pointer(hash, new)
        fph = rcu_dereference(hash) /* new */
        futex_ref_is_dead(fph) -> false
      schedule()

The pivot changes the state from hash_new != NULL with a dead current
hash to hash_new == NULL with a live current hash.  Because
futex_pivot_pending() reads hash_new and hash without serialization,
the resize task can observe hash_new in the pre-pivot state and hash in
the post-pivot state, causing futex_pivot_pending() to return false even
though the pivot has completed.  The task then goes to sleep after the
wakeup has already been consumed.

Serialize state reads in futex_pivot_pending() using futex_mm_phash::lock.
This guarantees that futex_pivot_pending() observes hash_new and hash
atomically, eliminating the race condition.

Fixes: bd54df5ea7ca ("futex: Allow to resize the private local hash")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Yao Kai <yaokai34@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260804125530.3933754-1-yaokai34@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1786,12 +1786,12 @@ static bool futex_pivot_pending(struct m
 {
 	struct futex_private_hash *fph;
 
-	guard(rcu)();
+	guard(mutex)(&mm->futex_hash_lock);
 
 	if (!mm->futex_phash_new)
 		return true;
 
-	fph = rcu_dereference(mm->futex_phash);
+	fph = rcu_dereference_raw(mm->futex_phash);
 	return futex_ref_is_dead(fph);
 }
 


