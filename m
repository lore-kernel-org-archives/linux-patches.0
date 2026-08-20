Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A12237C925;
	Thu, 20 Aug 2026 15:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239122; cv=none; b=NhwEEOc90Lz8W4YhfDZqp9G5ixqYhmiHjTi0StR84cnn9Gbg7gpY2A/MiTPJgd16rITQpB5Z09SZeG+VjeBc1ghwIxDG/TGv426nTa9wHYUSiFZ7wOMXpQ3s7+igWKQjuSxtkKPpxk+pI9BIavl1seDdVEEw86qKIuLgSkEt7rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239122; c=relaxed/simple;
	bh=L3BjrioiV59UtC228zzJa/9LCHICANpzO7ThxR1+crQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vrxs/n0shKCG7ocBR5lX6g7eMn7zyvuBpHqUbwNo8Xm0J7QqjtfGv+O0zQioWCRTV3rLZdfY3CVU0wy3X9gbhoBQ4OngJsstCPLZMj6MdnubFG67Oa6HAhtg2Ue4VNVvdGuVGymbdkRlCctyP2pjkW/wq2c9cnZhuaM64UmCjB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nT4FtA47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nT4FtA47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BE41F000E9;
	Thu, 20 Aug 2026 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239121;
	bh=/Ee4bl2KjDnwCEN+MkDO4WSapIokcihKiMifvd2PiEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nT4FtA47jP8m6/SxTZkBMIwSAq0nYvTYhw5A36KAhg25XTr8K6x80S7uNDHiv0EVe
	 VrfuwkE9R4Xtw/2V8xJ7BUiPVQpBZPt4jQJ1wzjvXwEXOdZzzG1OvLIompNIRuUPxZ
	 QPnsjxXM8f9/V8VcYyDjwdGy22qD3hV1PsnDpyKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Yao Kai <yaokai34@huawei.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 156/217] futex: Fix race in futex_pivot_pending() during private hash resize
Date: Thu, 20 Aug 2026 16:55:24 +0200
Message-ID: <20260820145242.449783078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Kai <yaokai34@huawei.com>

[ Upstream commit 8e7ff730dd96519a333d1570edf1c3fabb6d3629 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1774,12 +1774,12 @@ static bool futex_pivot_pending(struct m
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
 


