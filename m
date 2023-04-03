Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2086FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15730C4339B;
	Mon,  3 Apr 2023 14:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533192;
	bh=Ks/vrInK+T10ZMd95fnDkU1UIouez3jI1LEu6oF2Mog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/dNz4lm2dxOUJix3yF836qVlvaEIju1MEPqVGmsdYY30U5iFBV+OGrNJDP2xofv1
	 B/fJhZPyqZNyyOZ6dgzVLU532Y0md8JxYZHtotKiW88hV4RjHuj7G6QjVR5H1me3Or
	 F9lafsuQ9AALLGozqVwPnHibzMYor9Yk4oZBzovE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yury Norov <yury.norov@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 048/187] sched_getaffinity: dont assume cpumask_size() is fully initialized
Date: Mon,  3 Apr 2023 16:08:13 +0200
Message-Id: <20230403140417.558102543@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 6015b1aca1a233379625385feb01dd014aca60b5 ]

The getaffinity() system call uses 'cpumask_size()' to decide how big
the CPU mask is - so far so good.  It is indeed the allocation size of a
cpumask.

But the code also assumes that the whole allocation is initialized
without actually doing so itself.  That's wrong, because we might have
fixed-size allocations (making copying and clearing more efficient), but
not all of it is then necessarily used if 'nr_cpu_ids' is smaller.

Having checked other users of 'cpumask_size()', they all seem to be ok,
either using it purely for the allocation size, or explicitly zeroing
the cpumask before using the size in bytes to copy it.

See for example the ublk_ctrl_get_queue_affinity() function that uses
the proper 'zalloc_cpumask_var()' to make sure that the whole mask is
cleared, whether the storage is on the stack or if it was an external
allocation.

Fix this by just zeroing the allocation before using it.  Do the same
for the compat version of sched_getaffinity(), which had the same logic.

Also, for consistency, make sched_getaffinity() use 'cpumask_bits()' to
access the bits.  For a cpumask_var_t, it ends up being a pointer to the
same data either way, but it's just a good idea to treat it like you
would a 'cpumask_t'.  The compat case already did that.

Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Link: https://lore.kernel.org/lkml/7d026744-6bd6-6827-0471-b5e8eae0be3f@arm.com/
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/compat.c     | 2 +-
 kernel/sched/core.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index 55551989d9da5..fb50f29d9b361 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -152,7 +152,7 @@ COMPAT_SYSCALL_DEFINE3(sched_getaffinity, compat_pid_t,  pid, unsigned int, len,
 	if (len & (sizeof(compat_ulong_t)-1))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	ret = sched_getaffinity(pid, mask);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9a0698353d60f..57d84b534cdea 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8404,14 +8404,14 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 	if (len & (sizeof(unsigned long)-1))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
 		unsigned int retlen = min(len, cpumask_size());
 
-		if (copy_to_user(user_mask_ptr, mask, retlen))
+		if (copy_to_user(user_mask_ptr, cpumask_bits(mask), retlen))
 			ret = -EFAULT;
 		else
 			ret = retlen;
-- 
2.39.2



