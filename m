Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249472EBBAA;
	Thu,  3 Jul 2025 14:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553954; cv=none; b=dWBw7TE1ZwDLwPtxVPVMph7O7kkktbANN+U7XlilClf9RQ7kwujl4LxRd5tNYAGBuf3k52SpLwV+UUYpeMX24ttNHgtlBpwu76Vcj+3zDjUpNauCGvbEtDnkgVERjjXLf+Yud2DQwAgHbRYT1p4fO69+FUXl1tfqXY6v/oyRpE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553954; c=relaxed/simple;
	bh=TwiBEQaPLOxUhU4FbtkUIkh/BufI73sbwrwAKxJrwXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+xdrGS/R8JDs+ls9Xe/Yi9cbBeOzXXuPESHSyjPoVt4fFxSJMk73m/0BnUSJE5byrrP28Yew52Nm802ocfKVMVcrw5lE1HyJK+CG6QgoAPZ92bZNlE/UQDDHezah6bdKSMimfruPqk8Ew/sN4Vo3H6Y7ZIGBspTGaOU1Q9QeTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeoAAdAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeoAAdAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720D2C4CEE3;
	Thu,  3 Jul 2025 14:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553953;
	bh=TwiBEQaPLOxUhU4FbtkUIkh/BufI73sbwrwAKxJrwXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VeoAAdAPH2CF6AliU4TEjw6cLB3ZA8BcZg3AT5ogaTB2wNisB1FPcxwR/G6FS7kTu
	 pKUT7o0e4TWzGHGUPw5pJvi/GBele14eRqMBe0zsH1ETSBpPNE0LK5Sh1+Z+C+BOkm
	 5xBkSPnjaT5qyX4wnFEqUuAHDAPv10+wWhMEskTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/218] um: use proper care when taking mmap lock during segfault
Date: Thu,  3 Jul 2025 16:39:43 +0200
Message-ID: <20250703143957.354971169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 97c8df9c44017..9077bdb26cc35 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -17,6 +17,122 @@
 #include <os.h>
 #include <skas.h>
 
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
@@ -43,21 +159,10 @@ int handle_page_fault(unsigned long address, unsigned long ip,
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



