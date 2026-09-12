Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468BF4BEE2A;
	Sat, 12 Sep 2026 10:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210518; cv=none; b=N4BWhoej9glmRw99qLEKHniyO+NVO3I9S1q1fu7MAyU9t3UTyNeQwSU1OmpOF0dVtVadKFfxCLdnBpPNlnc0ZgJ9puaHG/HB13ZA2r0Jx2bQ4JJKRBfH/BzQBd0Xn9taSH8Vp1+MkyvA11E6bz2jIyu+v7uvuuVMWfp6jfLWxuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210518; c=relaxed/simple;
	bh=xIMwsMDeH0UriPREMsDxdDwoSJJWB43/PCjKSjcnnS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATlUtyRGxFE7npqsqJk8oPKNby4/MO2xd3oQfd7KHLqYlsv0rcShXXIIGf/bKAPhERYEtfkjxAO3B1URZn1qe+iSNGarAB58H6SZfu6wf87w8+nHyZE6EKEOkz1y7h+uQOuRkT+YPuUuyiYOuNc2czQZvFh6qyXQ6rrQ/pWWQYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLohW90B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLohW90B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE3B1F000FF;
	Sat, 12 Sep 2026 10:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210516;
	bh=iUJbQSztN3M7gX2VP5dcFPNJWAMpIzZhZ4h2HY8DkqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLohW90B2KVHe49Nir+TXsu8CSRDTTclcUKoBSdt6Va1pPKCxRePjFbrP2q+4eDnf
	 1JKEElJg2CLe7GSQQkyu5wkOHq1Gm0l1bPiElroDPiJze+4k9VjNWNdUIxlBe0nal5
	 TWDwYElKiPN3s/jZ7qwkKy15FCdnWB5a4xuJVvgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1041/1518] bpf: Avoid faultable build ID reads under mm locks
Date: Sat, 12 Sep 2026 08:53:30 +0200
Message-ID: <20260912065647.000754273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit fad3021faf7b0b64e9daea41c5662b65c8ad7379 ]

Sleepable build ID parsing can block in __kernel_read() [1], so the
stackmap sleepable path must not call it while holding mmap_lock or a
per-VMA read lock.

The issue and the fix are conceptually similar to a recent procfs
patch [2]. A similar VMA locking pattern has already been used in
PROCMAP_QUERY [3].

Resolve each covered VMA with a stable read-side reference, preferring
lock_vma_under_rcu() and falling back to mmap_read_trylock() only long
enough to acquire the VMA read lock. Take a reference to the backing
file, drop the VMA lock, and then parse the build ID through
(sleepable) build_id_parse_file().

We have to use mmap_read_trylock() (and give up on failure) in this
context because taking mmap_read_lock() is generally unsafe on code
paths reachable from BPF programs [4], and may lead to deadlocks.

[1] https://lore.kernel.org/all/20251218005818.614819-1-shakeel.butt@linux.dev/
[2] https://lore.kernel.org/all/20260128183232.2854138-1-andrii@kernel.org/
[3] https://lore.kernel.org/all/20250808152850.2580887-1-surenb@google.com/
[4] https://lore.kernel.org/bpf/2895ecd8-df1e-4cc0-b9f9-aef893dc2360@linux.dev/

Fixes: d4dd9775ec24 ("bpf: wire up sleepable bpf_get_stack() and bpf_get_task_stack() helpers")
Suggested-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260525223948.1920986-3-ihor.solodrai@linux.dev
Stable-dep-of: fa9dcacdcdf4 ("bpf: Fix mmap_lock leak in irq_work path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 109 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 2b647a2f176b4..bd4c0e8163516 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -9,6 +9,7 @@
 #include <linux/perf_event.h>
 #include <linux/btf_ids.h>
 #include <linux/buildid.h>
+#include <linux/mmap_lock.h>
 #include "percpu_freelist.h"
 #include "mmap_unlock_work.h"
 
@@ -174,6 +175,109 @@ static inline void stack_map_build_id_set_valid(struct bpf_stack_build_id *id,
 		memcpy(id->build_id, build_id, BUILD_ID_SIZE_MAX);
 }
 
+struct stack_map_vma_lock {
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
+};
+
+/*
+ * Acquire a stable read-side reference on the VMA covering @ip.
+ *
+ * With CONFIG_PER_VMA_LOCK=y this returns a VMA with its per-VMA read
+ * lock held and mmap_lock dropped, so the caller may sleep.
+ *
+ * With CONFIG_PER_VMA_LOCK=n it returns a VMA with mmap_lock still
+ * held; the caller must snapshot any fields it needs and pin vm_file
+ * with get_file() before stack_map_unlock_vma() drops mmap_lock, as
+ * the VMA may be split, merged, or freed after that.
+ *
+ * Returns NULL on failure, in which case no lock is held.
+ */
+static struct vm_area_struct *
+stack_map_lock_vma(struct stack_map_vma_lock *lock, unsigned long ip)
+{
+	struct mm_struct *mm = lock->mm;
+	struct vm_area_struct *vma;
+
+	/* noop under !CONFIG_PER_VMA_LOCK */
+	vma = lock_vma_under_rcu(mm, ip);
+	if (vma) {
+		lock->vma = vma;
+		return vma;
+	}
+
+	/*
+	 * Taking mmap_read_lock() is unsafe here, because the caller BPF
+	 * program might already hold it, causing a deadlock.
+	 */
+	if (!mmap_read_trylock(mm))
+		return NULL;
+
+	vma = vma_lookup(mm, ip);
+	if (!vma) {
+		mmap_read_unlock(mm);
+		return NULL;
+	}
+
+#ifdef CONFIG_PER_VMA_LOCK
+	if (!vma_start_read_locked(vma)) {
+		mmap_read_unlock(mm);
+		return NULL;
+	}
+	mmap_read_unlock(mm);
+#endif
+
+	lock->vma = vma;
+	return vma;
+}
+
+static void stack_map_unlock_vma(struct stack_map_vma_lock *lock)
+{
+#ifdef CONFIG_PER_VMA_LOCK
+	vma_end_read(lock->vma);
+#else
+	mmap_read_unlock(lock->mm);
+#endif
+	lock->vma = NULL;
+}
+
+static void stack_map_get_build_id_offset_sleepable(struct bpf_stack_build_id *id_offs,
+						    u32 trace_nr)
+{
+	struct mm_struct *mm = current->mm;
+	struct stack_map_vma_lock lock = { .mm = mm };
+	struct vm_area_struct *vma;
+	struct file *file;
+	u64 offset;
+	u64 ip;
+
+	for (u32 i = 0; i < trace_nr; i++) {
+		ip = READ_ONCE(id_offs[i].ip);
+
+		vma = stack_map_lock_vma(&lock, ip);
+		if (!vma) {
+			stack_map_build_id_set_ip(&id_offs[i]);
+			continue;
+		}
+		if (vma_is_anonymous(vma) || !vma->vm_file) {
+			stack_map_build_id_set_ip(&id_offs[i]);
+			stack_map_unlock_vma(&lock);
+			continue;
+		}
+
+		file = get_file(vma->vm_file);
+		offset = stack_map_build_id_offset(vma->vm_pgoff, vma->vm_start, ip);
+		stack_map_unlock_vma(&lock);
+
+		/* build_id_parse_file() may block on filesystem reads */
+		if (build_id_parse_file(file, id_offs[i].build_id, NULL))
+			stack_map_build_id_set_ip(&id_offs[i]);
+		else
+			stack_map_build_id_set_valid(&id_offs[i], offset, id_offs[i].build_id);
+		fput(file);
+	}
+}
+
 /*
  * Expects all id_offs[i].ip values to be set to correct initial IPs.
  * They will be subsequently:
@@ -194,6 +298,11 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 	const unsigned char *prev_build_id = NULL;
 	int i;
 
+	if (may_fault && has_user_ctx) {
+		stack_map_get_build_id_offset_sleepable(id_offs, trace_nr);
+		return;
+	}
+
 	/* If the irq_work is in use, fall back to report ips. Same
 	 * fallback is used for kernel stack (!user) on a stackmap with
 	 * build_id.
-- 
2.53.0



