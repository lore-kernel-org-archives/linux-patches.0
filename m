Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050943;
	b=vVHRWMkfP47OSjTY+TN9TmS5x6t7MTHsgAM43zPY1jMQu0XqAqEXU+MXPdKfQRw6UBob
	 v5CuYt8IBtsqM/CMWjs6omHeMi4OxsuqoBqG5hCb15ggJEHUnMkZB3XIeRFhNNRQguYYT
	 C2lv6D9G0QhV3NYGULYFSwGgp8nNtNeZbmIP3ymA26E1tiJeQFcC4vIQP32oy+lsjRxLu
	 C+PXWRz7sqFqDm7IYrb4CyJnNjai7hFcYw9YpgPH/rNY103h2JjvdPx2q8BsXH/fYIH1L
	 DWcRcVqDjpytVVaBQjVyqkMOTOpdNykJpgx4rasaN2J5aA3a6C1Qn2GbT+iHNOmUGeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1kdYGCf+kNkSCP9briYXe8CpUbwzyjPiFe46tQbJ8sY=;
	b=qUr4r0bQdfIm9SJLVIsIhOh3VTDu5oTqQD6XUnsJIbUvGVqm5qGFLGlKQXJ/gFDhhJ5g
	 qkTzqzEDYn6YSr1pMtpYJsP9X4yMS378uapbknvpP7xYDrCRH+hNgsI9NzvT3fRyfeWcC
	 uwQrpPwzDu92cXEhankXL6lm1DHI/3hfCmzpkO8qxVWDFF0ZAKQCltEcX0nv9k/KXM0OJ
	 8xI3iRNbeHpBwGZT1JIa61eJbKnsWA7mH7Sgn29Hst7bnQVGzfff5Dub9ijHShGpuIkBr
	 YDi9Trl0Wo4oIH24huVfepsS4VIO6xY2XU226jKluueBsE6MBzr08DfwXdfpCSolttg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2je8h+L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7C7606A330;
	Thu, 19 Nov 2026 01:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2je8h+L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255221F000C4;
	Thu, 19 Nov 2026 01:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050942;
	bh=1kdYGCf+kNkSCP9briYXe8CpUbwzyjPiFe46tQbJ8sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2je8h+LK/HsQPWSn700tiYRLgDYSAZJk4rj5voE9tsUw0dilS3ohJy/946ABx39i
	 /ublSPvBcDgQQQnjTq845Gg/Za23Nmyl7VAdcfrIb8gV4iQbdSjEAobd8100PLv6f4
	 tMILFDTSsVIn5Ok3II70tYe2ziPelZjJJIsENe7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	syzbot+1cd571a672400ef3a930@syzkaller.appspotmail.com,
	Jann Horn <jannh@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Paul Moore <paul@paul-moore.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>,
	James Morris <jmorris@namei.org>,
	Mimi Zohar <zohar@linux.ibm.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shu Han <ebpqwerty472123@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	yao zhang1 <yao.zhang1@amlogic.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0006/2214] mm: split critical region in remap_file_pages() and invoke LSMs in between
Date: Wed, 18 Nov 2026 15:28:02 +0100
Message-ID: <20261118150010.419996762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

commit 58a039e679fe72bd0efa8b2abe669a7914bb4429 upstream.

Commit ea7e2d5e49c0 ("mm: call the security_mmap_file() LSM hook in
remap_file_pages()") fixed a security issue, it added an LSM check when
trying to remap file pages, so that LSMs have the opportunity to evaluate
such action like for other memory operations such as mmap() and
mprotect().

However, that commit called security_mmap_file() inside the mmap_lock
lock, while the other calls do it before taking the lock, after commit
8b3ec6814c83 ("take security_mmap_file() outside of ->mmap_sem").

This caused lock inversion issue with IMA which was taking the mmap_lock
and i_mutex lock in the opposite way when the remap_file_pages() system
call was called.

Solve the issue by splitting the critical region in remap_file_pages() in
two regions: the first takes a read lock of mmap_lock, retrieves the VMA
and the file descriptor associated, and calculates the 'prot' and 'flags'
variables; the second takes a write lock on mmap_lock, checks that the VMA
flags and the VMA file descriptor are the same as the ones obtained in the
first critical region (otherwise the system call fails), and calls
do_mmap().

In between, after releasing the read lock and before taking the write
lock, call security_mmap_file(), and solve the lock inversion issue.

Link: https://lkml.kernel.org/r/20241018161415.3845146-1-roberto.sassu@huaweicloud.com
Fixes: ea7e2d5e49c0 ("mm: call the security_mmap_file() LSM hook in remap_file_pages()")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reported-by: syzbot+1cd571a672400ef3a930@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-security-module/66f7b10e.050a0220.46d20.0036.GAE@google.com/
Tested-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Tested-by: syzbot+1cd571a672400ef3a930@syzkaller.appspotmail.com
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Eric Snowberg <eric.snowberg@oracle.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Shu Han <ebpqwerty472123@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 58a039e679fe72bd0efa8b2abe669a7914bb4429)
Signed-off-by: yao zhang1 <yao.zhang1@amlogic.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 69 +++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 17 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 4e3c2f796fdd1..226b513b688c2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2999,6 +2999,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	unsigned long populate = 0;
 	unsigned long ret = -EINVAL;
 	struct file *file;
+	vm_flags_t vm_flags;
 
 	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. See Documentation/vm/remap_file_pages.rst.\n",
 		     current->comm, current->pid);
@@ -3015,12 +3016,60 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	if (pgoff + (size >> PAGE_SHIFT) < pgoff)
 		return ret;
 
-	if (mmap_write_lock_killable(mm))
+	if (mmap_read_lock_killable(mm))
+		return -EINTR;
+
+	/*
+	 * Look up VMA under read lock first so we can perform the security
+	 * without holding locks (which can be problematic). We reacquire a
+	 * write lock later and check nothing changed underneath us.
+	 */
+	vma = vma_lookup(mm, start);
+
+	if (!vma || !(vma->vm_flags & VM_SHARED)) {
+		mmap_read_unlock(mm);
+		return -EINVAL;
+	}
+
+	prot |= vma->vm_flags & VM_READ ? PROT_READ : 0;
+	prot |= vma->vm_flags & VM_WRITE ? PROT_WRITE : 0;
+	prot |= vma->vm_flags & VM_EXEC ? PROT_EXEC : 0;
+
+	flags &= MAP_NONBLOCK;
+	flags |= MAP_SHARED | MAP_FIXED | MAP_POPULATE;
+	if (vma->vm_flags & VM_LOCKED)
+		flags |= MAP_LOCKED;
+
+	/* Save vm_flags used to calculate prot and flags, and recheck later. */
+	vm_flags = vma->vm_flags;
+	file = get_file(vma->vm_file);
+
+	mmap_read_unlock(mm);
+
+	/* Call outside mmap_lock to be consistent with other callers. */
+	ret = security_mmap_file(file, prot, flags);
+	if (ret) {
+		fput(file);
+		return ret;
+	}
+
+	ret = -EINVAL;
+
+	/* OK security check passed, take write lock + let it rip. */
+	if (mmap_write_lock_killable(mm)) {
+		fput(file);
 		return -EINTR;
+	}
 
 	vma = vma_lookup(mm, start);
 
-	if (!vma || !(vma->vm_flags & VM_SHARED))
+	if (!vma)
+		goto out;
+
+	/* Make sure things didn't change under us. */
+	if (vma->vm_flags != vm_flags)
+		goto out;
+	if (vma->vm_file != file)
 		goto out;
 
 	if (start + size > vma->vm_end) {
@@ -3045,25 +3094,11 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 			goto out;
 	}
 
-	prot |= vma->vm_flags & VM_READ ? PROT_READ : 0;
-	prot |= vma->vm_flags & VM_WRITE ? PROT_WRITE : 0;
-	prot |= vma->vm_flags & VM_EXEC ? PROT_EXEC : 0;
-
-	flags &= MAP_NONBLOCK;
-	flags |= MAP_SHARED | MAP_FIXED | MAP_POPULATE;
-	if (vma->vm_flags & VM_LOCKED)
-		flags |= MAP_LOCKED;
-
-	file = get_file(vma->vm_file);
-	ret = security_mmap_file(vma->vm_file, prot, flags);
-	if (ret)
-		goto out_fput;
 	ret = do_mmap(vma->vm_file, start, size,
 			prot, flags, pgoff, &populate, NULL);
-out_fput:
-	fput(file);
 out:
 	mmap_write_unlock(mm);
+	fput(file);
 	if (populate)
 		mm_populate(ret, populate);
 	if (!IS_ERR_VALUE(ret))
-- 
2.53.0



