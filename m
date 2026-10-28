Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210150;
	b=y5mzCRlyU4pQ5pl64Gg9+0jz6uuhzbxjjLU8JzXbY03ixgDObqiJKiPcRL5e7UhZ5nLD
	 lCiR/QYBmuILl/w1mjKyZrd/vV0otwUCMEV3CMg6vNyQsqDwzPagtQ/LGOmvmdpgaSqzS
	 GWQeOOodPLd2j2SvbcNJLF+uws4UpQCIKkQAyMNFPvU6iiysS2OLoRkNRFqEAicYc03MZ
	 r4lI0mBBjYMWvTpe+wQp+ySnGgOfk6Mx2+Hhx1FY8tmzZGm8OwcLC3tqBOV89iyHUHS06
	 BYkl6raS5C4c+e54COhh3Ay0uL3lKpZNNtAwiZXHOVnRhxSEPzGMXEFLl3pavKHeFfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/wl2gt7uC1GWPQxISFmM4CkcSi0xj7eIGrUVKFO0RAI=;
	b=VrhfUSCRruJReJ73TU9D0EDGP8Lp5NiQxWA77SR8HKQGQmIk7Qu0I0ep/86YrAgIUnqf
	 wnWg37+en4l2Ktiy4/nnR8aqTJZRpVtYwhmUFvWo0LWLdV8P9oSZsTU8WEkFzf1DWukT0
	 SBFbP3yNskZtyArowVsiF/UHweA11/5Y9m+H2lHIQ+O2ilLIk62d1bBYiXJRfta6NuRgg
	 yDCnzCek25/kPBCX5rSKCbXFzGmaiKSt48z+WCiQJL8ptCvaX858Apbpeht5A34jbPi7b
	 U+HyhiV0lxcYTyVovSDqwqGpFKZzh3pcWi8qtW0JbHdSui4NsBo/9alVLCXSIuNvhWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CfeGOxn1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8918C606A31A;
	Wed, 28 Oct 2026 17:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CfeGOxn1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6161F01825;
	Wed, 28 Oct 2026 17:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210150;
	bh=/wl2gt7uC1GWPQxISFmM4CkcSi0xj7eIGrUVKFO0RAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfeGOxn1ilxQ6eSLxGD6EKXapNvouIpgfwetG8oI2DR1NADtwWwHyNcs5bUdxtJQV
	 Ea05lrkIsF8PiarMX/5gxGPH98pcFPNng0s5VbSMxEaZHV04F0FgbgfYZClaKRq9eR
	 zdToYF94BWnvAmS3+2B5NACmez6blNyDLg7D59jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/168] perf: Track the perf mlock gift separately
Date: Wed, 28 Oct 2026 18:00:28 +0100
Message-ID: <20261028165945.267786396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit 78436f3882fb8d848c823bf8cf754988202c5ca5 upstream.

The locked_vm field in struct user_struct was originally introduced by
commit 789f90fcf6b0 ("perf_counter: per user mlock gift") to provide an
mlock-like budget for perf measured against mm->pinned_vm (since 2011).

perf grants each user a 'gift' of perf_event_mlock_kb * online CPUs of
buffer pages which is charged to user->locked_vm without any RLIMIT_MEMLOCK
check.

Only pages beyond the gift are checked against RLIMIT_MEMLOCK, per-mm, via
mm->pinned_vm, which makes it different from the standard mlock() check,
which is per-mm and made against RLIMIT_MEMLOCK.

However, since this was introduced, a number of other components have
utilised this field where a shared resource needed to be limited against
RLIMIT_MEMLOCK.

The other users are currently MSG_ZEROCOPY, io_uring, AF_XDP, iommufd,
s390 KVM zPCI and most recently, secretmem in commit 97d34aa65c29
("mm/secretmem: properly account locked pages").

This field is shared between all of these, but because the gift is not
checked against RLIMIT_MEMLOCK, user->locked_vm alone can exceed it - 16
CPUs * 516 KiB is already more than the default 8 MiB - after which every
other user of the field fails unconditionally.

This was reported by a user who saw secretmem failing while running a
simultaneous perf record.

Resolve the issue by simply giving perf its own field separate from the
rest.

BPF used user->locked_vm up until commit 80ee81e0403c ("bpf: Eliminate
rlimit-based memory accounting infra for bpf maps") which landed in 5.11.

Thus also eliminate the now-defunct ifdef for CONFIG_BPF_SYSCALL for
user->locked_vm.

This issue exists between all of the components which use user->locked_vm
and perf, however secretmem is the first user who has caused a report over
many years and has been backported, so target the fix at that.

Fixes: 97d34aa65c29 ("mm/secretmem: properly account locked pages")
Closes: https://lore.kernel.org/20261002175651.811343-1-ameer.hamza@truenas.com
Reported-by: Ameer Hamza <ameer.hamza@truenas.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
[ ljs - Applied to open-coded accounting in perf_mmap()/perf_mmap_close(). ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/user.h |  8 +++++---
 kernel/events/core.c       | 12 ++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index 8d7e5521f7cdd..ec262b605437c 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -23,11 +23,13 @@ struct user_struct {
 	struct hlist_node uidhash_node;
 	kuid_t uid;
 
-#if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
-	defined(CONFIG_NET) || defined(CONFIG_IO_URING) || \
+#if defined(CONFIG_NET) || defined(CONFIG_IO_URING) || \
 	defined(CONFIG_VFIO_PCI_ZDEV_KVM) || IS_ENABLED(CONFIG_IOMMUFD) || \
 	defined(CONFIG_SECRETMEM)
-	atomic_long_t locked_vm;
+	atomic_long_t locked_vm;	/* pinned pages charged to RLIMIT_MEMLOCK */
+#endif
+#ifdef CONFIG_PERF_EVENTS
+	atomic_long_t perf_mlock;	/* perf buffer pages within perf_event_mlock_kb */
 #endif
 #ifdef CONFIG_WATCH_QUEUE
 	atomic_t nr_watches;	/* The number of watches this user currently has */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a6c78d8ee1cf9..70b8d75d7c78e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6408,7 +6408,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 		perf_pmu_output_stop(event);
 
 		/* now it's safe to free the pages */
-		atomic_long_sub(rb->aux_nr_pages - rb->aux_mmap_locked, &mmap_user->locked_vm);
+		atomic_long_sub(rb->aux_nr_pages - rb->aux_mmap_locked, &mmap_user->perf_mlock);
 		atomic64_sub(rb->aux_mmap_locked, &vma->vm_mm->pinned_vm);
 
 		/* this has to be the last one */
@@ -6483,7 +6483,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	 */
 
 	atomic_long_sub((size >> PAGE_SHIFT) + 1 - mmap_locked,
-			&mmap_user->locked_vm);
+			&mmap_user->perf_mlock);
 	atomic64_sub(mmap_locked, &vma->vm_mm->pinned_vm);
 	free_uid(mmap_user);
 
@@ -6643,11 +6643,11 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	 */
 	user_lock_limit *= num_online_cpus();
 
-	user_locked = atomic_long_read(&user->locked_vm);
+	user_locked = atomic_long_read(&user->perf_mlock);
 
 	/*
 	 * sysctl_perf_event_mlock may have changed, so that
-	 *     user->locked_vm > user_lock_limit
+	 *     user->perf_mlock > user_lock_limit
 	 */
 	if (user_locked > user_lock_limit)
 		user_locked = user_lock_limit;
@@ -6655,7 +6655,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 	if (user_locked > user_lock_limit) {
 		/*
-		 * charge locked_vm until it hits user_lock_limit;
+		 * charge perf_mlock until it hits user_lock_limit;
 		 * charge the rest from pinned_vm
 		 */
 		extra = user_locked - user_lock_limit;
@@ -6707,7 +6707,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 unlock:
 	if (!ret) {
-		atomic_long_add(user_extra, &user->locked_vm);
+		atomic_long_add(user_extra, &user->perf_mlock);
 		atomic64_add(extra, &vma->vm_mm->pinned_vm);
 
 		atomic_inc(&event->mmap_count);
-- 
2.53.0



