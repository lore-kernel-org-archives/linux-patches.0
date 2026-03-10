Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C5F381AF8;
	Tue, 10 Mar 2026 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140769; cv=none; b=n6dJRfTatzSAgTx5O8mgaPrrE9aad2aI0rpkj/0rNki+v18Br/vaTEO4PsuhqNeii93yurBjqBLELeqtw/Wl0LnUxJovWtoqVHXaV2usJbYlISBpBL7tsFvoOsVdv4wZ/xnAcfEAsL4g4U0ODx7HCemTlCS2NUt7RfzQ9wCNdiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140769; c=relaxed/simple;
	bh=4Uw3rbhPIpjWT+KTWz+d/ibpcIgb/7XP+USSZW4yF+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlV5uXOsqiqq0fGmwh+dZE8IiIqvAqZZRGyHEINAsNuNVOFi4f5BvsXiUVFTywnMbYXlWHicPtHGPY0Iocwa5Hvnn/NoSf9YWdSYpzDzyaoeveFG4UalO81QgMQLZXVQUtQv7zGB42xAbv5NUflQLsewJvawuRNyTj3OxQ+mmG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B1ouNFlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1ouNFlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0300C19423;
	Tue, 10 Mar 2026 11:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140768;
	bh=4Uw3rbhPIpjWT+KTWz+d/ibpcIgb/7XP+USSZW4yF+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1ouNFlXXLcEmzA5WAS+bS2zf4O37mLQnjVvroWC5ZZOJWFrZjnJsSr8WKCswRttM
	 mn+hwBKLQvSFDrA9211aou0KPwYk2OTNNM8HDeQ2sQQBV2QhY1SDRROE+EtvpoufUw
	 i+aBSOsvYFPfrJhpMhsblRkhs2CGhoBDRWHDehG+vWUB3KjjAYIjEh+sbjNWfmPgJn
	 0OJ69lzqaPbREQwAJyvmwtaru2BfVK/Wo+dTST1u53Hco2dj3xU3N/PtyL9d/rVe0M
	 /i99tFDkp64JXISHs5wSfSMPx8YYdRlEoBqDz5w7hE/bzSHo1oRd8CGlKT6x1iIlFh
	 +62QsqklVvBpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haocheng Yu <yuhaocheng035@gmail.com>,
	kernel test robot <lkp@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 001/311] perf/core: Fix refcount bug and potential UAF in perf_mmap
Date: Tue, 10 Mar 2026 07:00:48 -0400
Message-ID: <f1336d6544902b9273e41080663fc11a01187e90.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haocheng Yu <yuhaocheng035@gmail.com>

commit 77de62ad3de3967818c3dbe656b7336ebee461d2 upstream.

Syzkaller reported a refcount_t: addition on 0; use-after-free warning
in perf_mmap.

The issue is caused by a race condition between a failing mmap() setup
and a concurrent mmap() on a dependent event (e.g., using output
redirection).

In perf_mmap(), the ring_buffer (rb) is allocated and assigned to
event->rb with the mmap_mutex held. The mutex is then released to
perform map_range().

If map_range() fails, perf_mmap_close() is called to clean up.
However, since the mutex was dropped, another thread attaching to
this event (via inherited events or output redirection) can acquire
the mutex, observe the valid event->rb pointer, and attempt to
increment its reference count. If the cleanup path has already
dropped the reference count to zero, this results in a
use-after-free or refcount saturation warning.

Fix this by extending the scope of mmap_mutex to cover the
map_range() call. This ensures that the ring buffer initialization
and mapping (or cleanup on failure) happens atomically effectively,
preventing other threads from accessing a half-initialized or
dying ring buffer.

Closes: https://lore.kernel.org/oe-kbuild-all/202602020208.m7KIjdzW-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Haocheng Yu <yuhaocheng035@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260202162057.7237-1-yuhaocheng035@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 69c56cad88a89..c0bb657e28e31 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7188,28 +7188,28 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 			ret = perf_mmap_aux(vma, event, nr_pages);
 		if (ret)
 			return ret;
-	}
 
-	/*
-	 * Since pinned accounting is per vm we cannot allow fork() to copy our
-	 * vma.
-	 */
-	vm_flags_set(vma, VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &perf_mmap_vmops;
+		/*
+		 * Since pinned accounting is per vm we cannot allow fork() to copy our
+		 * vma.
+		 */
+		vm_flags_set(vma, VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP);
+		vma->vm_ops = &perf_mmap_vmops;
 
-	mapped = get_mapped(event, event_mapped);
-	if (mapped)
-		mapped(event, vma->vm_mm);
+		mapped = get_mapped(event, event_mapped);
+		if (mapped)
+			mapped(event, vma->vm_mm);
 
-	/*
-	 * Try to map it into the page table. On fail, invoke
-	 * perf_mmap_close() to undo the above, as the callsite expects
-	 * full cleanup in this case and therefore does not invoke
-	 * vmops::close().
-	 */
-	ret = map_range(event->rb, vma);
-	if (ret)
-		perf_mmap_close(vma);
+		/*
+		 * Try to map it into the page table. On fail, invoke
+		 * perf_mmap_close() to undo the above, as the callsite expects
+		 * full cleanup in this case and therefore does not invoke
+		 * vmops::close().
+		 */
+		ret = map_range(event->rb, vma);
+		if (ret)
+			perf_mmap_close(vma);
+	}
 
 	return ret;
 }
-- 
2.51.0

