Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1A72EA49E;
	Thu,  3 Jul 2025 14:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554688; cv=none; b=qwbgptX7YSzmyrQGBK7I0FoNk8JQhdDZy2QlQFmeUabmTTQ7RyP1AdGmLkgp/3AVzdf1xC/blnbcG/1g1c1IeGLhvfY0ikTgMerHaXQAibfrqkcl4kffItpvi7VuiR/3nNeWdEcoZnbLBrECvPusHMPb03nX0wCwXmuOd9TmM3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554688; c=relaxed/simple;
	bh=UbAo0ZAU+URQaJIPKXZEijKLqaJ9y0DKQFO09yMFNSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3LuHpXQbTix0TvdgOL3Wucd1hIccIXMOf4wX6z9gQ5scB9H2lnyN7/FgifDd+xc7YDHtsCA4QJV1OhEwroXNKK5yIJGHo5t0wzKZQgRFY/4V4kZJrDxc6dUsooSkbphHRSPvTW+D3iFzTdUcCuE9Clswa8KlQXbFs2fSJCo17g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmgD4kDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmgD4kDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C845EC4CEED;
	Thu,  3 Jul 2025 14:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554688;
	bh=UbAo0ZAU+URQaJIPKXZEijKLqaJ9y0DKQFO09yMFNSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmgD4kDQgVtzaTmcx+X2WR4GSh77dZVtwsbOgEuFujy70RdCiUk8LRCq1ZI3N+cxv
	 aGSU0+y/qDyr75cPnfwGOFD1BJDYEC7Km7o4GWR42aF0RJGMtVcqnhSL8AWVVY/rR0
	 Gy3VR2jqYCFCm70X6V/l7gn/xHRTZQtZuZOkzqSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 047/263] um: use proper care when taking mmap lock during segfault
Date: Thu,  3 Jul 2025 16:39:27 +0200
Message-ID: <20250703144006.191011222@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 6767e8784cd2e8b386a62330ea6864949d983a3e ]

Segfaults can occur at times where the mmap lock cannot be taken. If
that happens the segfault handler may not be able to take the mmap lock.

Fix the code to use the same approach as most other architectures.
Unfortunately, this requires copying code from mm/memory.c and modifying
it slightly as UML does not have exception tables.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20250408074524.300153-2-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/trap.c | 129 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 117 insertions(+), 12 deletions(-)

diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index ef2272e92a432..8a2e68d07de61 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -18,6 +18,122 @@
 #include <skas.h>
 #include <arch.h>
 
+/*
+ * NOTE: UML does not have exception tables. As such, this is almost a copy
+ * of the code in mm/memory.c, only adjusting the logic to simply check whether
+ * we are coming from the kernel instead of doing an additional lookup in the
+ * exception table.
+ * We can do this simplification because we never get here if the exception was
+ * fixable.
+ */
+static inline bool get_mmap_lock_carefully(struct mm_struct *mm, bool is_user)
+{
+	if (likely(mmap_read_trylock(mm)))
+		return true;
+
+	if (!is_user)
+		return false;
+
+	return !mmap_read_lock_killable(mm);
+}
+
+static inline bool mmap_upgrade_trylock(struct mm_struct *mm)
+{
+	/*
+	 * We don't have this operation yet.
+	 *
+	 * It should be easy enough to do: it's basically a
+	 *    atomic_long_try_cmpxchg_acquire()
+	 * from RWSEM_READER_BIAS -> RWSEM_WRITER_LOCKED, but
+	 * it also needs the proper lockdep magic etc.
+	 */
+	return false;
+}
+
+static inline bool upgrade_mmap_lock_carefully(struct mm_struct *mm, bool is_user)
+{
+	mmap_read_unlock(mm);
+	if (!is_user)
+		return false;
+
+	return !mmap_write_lock_killable(mm);
+}
+
+/*
+ * Helper for page fault handling.
+ *
+ * This is kind of equivalend to "mmap_read_lock()" followed
+ * by "find_extend_vma()", except it's a lot more careful about
+ * the locking (and will drop the lock on failure).
+ *
+ * For example, if we have a kernel bug that causes a page
+ * fault, we don't want to just use mmap_read_lock() to get
+ * the mm lock, because that would deadlock if the bug were
+ * to happen while we're holding the mm lock for writing.
+ *
+ * So this checks the exception tables on kernel faults in
+ * order to only do this all for instructions that are actually
+ * expected to fault.
+ *
+ * We can also actually take the mm lock for writing if we
+ * need to extend the vma, which helps the VM layer a lot.
+ */
+static struct vm_area_struct *
+um_lock_mm_and_find_vma(struct mm_struct *mm,
+			unsigned long addr, bool is_user)
+{
+	struct vm_area_struct *vma;
+
+	if (!get_mmap_lock_carefully(mm, is_user))
+		return NULL;
+
+	vma = find_vma(mm, addr);
+	if (likely(vma && (vma->vm_start <= addr)))
+		return vma;
+
+	/*
+	 * Well, dang. We might still be successful, but only
+	 * if we can extend a vma to do so.
+	 */
+	if (!vma || !(vma->vm_flags & VM_GROWSDOWN)) {
+		mmap_read_unlock(mm);
+		return NULL;
+	}
+
+	/*
+	 * We can try to upgrade the mmap lock atomically,
+	 * in which case we can continue to use the vma
+	 * we already looked up.
+	 *
+	 * Otherwise we'll have to drop the mmap lock and
+	 * re-take it, and also look up the vma again,
+	 * re-checking it.
+	 */
+	if (!mmap_upgrade_trylock(mm)) {
+		if (!upgrade_mmap_lock_carefully(mm, is_user))
+			return NULL;
+
+		vma = find_vma(mm, addr);
+		if (!vma)
+			goto fail;
+		if (vma->vm_start <= addr)
+			goto success;
+		if (!(vma->vm_flags & VM_GROWSDOWN))
+			goto fail;
+	}
+
+	if (expand_stack_locked(vma, addr))
+		goto fail;
+
+success:
+	mmap_write_downgrade(mm);
+	return vma;
+
+fail:
+	mmap_write_unlock(mm);
+	return NULL;
+}
+
 /*
  * Note this is constrained to return 0, -EFAULT, -EACCES, -ENOMEM by
  * segv().
@@ -44,21 +160,10 @@ int handle_page_fault(unsigned long address, unsigned long ip,
 	if (is_user)
 		flags |= FAULT_FLAG_USER;
 retry:
-	mmap_read_lock(mm);
-	vma = find_vma(mm, address);
-	if (!vma)
-		goto out;
-	if (vma->vm_start <= address)
-		goto good_area;
-	if (!(vma->vm_flags & VM_GROWSDOWN))
-		goto out;
-	if (is_user && !ARCH_IS_STACKGROW(address))
-		goto out;
-	vma = expand_stack(mm, address);
+	vma = um_lock_mm_and_find_vma(mm, address, is_user);
 	if (!vma)
 		goto out_nosemaphore;
 
-good_area:
 	*code_out = SEGV_ACCERR;
 	if (is_write) {
 		if (!(vma->vm_flags & VM_WRITE))
-- 
2.39.5



