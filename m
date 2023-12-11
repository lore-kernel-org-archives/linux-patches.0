Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1E351C55;
	Mon, 11 Dec 2023 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKg1BIGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E9AC433C8;
	Mon, 11 Dec 2023 18:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319600;
	bh=dh75aQzL6do6aQaPE5u3fzxsCJ6pYf1nxYTpbNnswDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKg1BIGmZ5zKsmRSse/QSzJK/ik+HOYBHurkCWwOBPoTJzDQOfIT8ZZanDmHbtFjj
	 GifJzN6Tv3uK8LZz3z8mC6IuwhMjMgoTtW/cjWViJtm5bspG1Wbr7zdJR2w1kE6sQV
	 lUv3yqzroQTNhSqqltcawNyQ3OQsioHiRwzE13h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6ada951e7c0f7bc8a71e@syzkaller.appspotmail.com,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	Edward Adam Davis <eadavis@qq.com>,
	Muchun Song <muchun.song@linux.dev>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 165/244] hugetlb: fix null-ptr-deref in hugetlb_vma_lock_write
Date: Mon, 11 Dec 2023 19:20:58 +0100
Message-ID: <20231211182053.276001851@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 187da0f8250aa94bd96266096aef6f694e0b4cd2 upstream.

The routine __vma_private_lock tests for the existence of a reserve map
associated with a private hugetlb mapping.  A pointer to the reserve map
is in vma->vm_private_data.  __vma_private_lock was checking the pointer
for NULL.  However, it is possible that the low bits of the pointer could
be used as flags.  In such instances, vm_private_data is not NULL and not
a valid pointer.  This results in the null-ptr-deref reported by syzbot:

general protection fault, probably for non-canonical address 0xdffffc000000001d:
 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000e8-0x00000000000000ef]
CPU: 0 PID: 5048 Comm: syz-executor139 Not tainted 6.6.0-rc7-syzkaller-00142-g88
8cf78c29e2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 1
0/09/2023
RIP: 0010:__lock_acquire+0x109/0x5de0 kernel/locking/lockdep.c:5004
...
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5753 [inline]
 lock_acquire+0x1ae/0x510 kernel/locking/lockdep.c:5718
 down_write+0x93/0x200 kernel/locking/rwsem.c:1573
 hugetlb_vma_lock_write mm/hugetlb.c:300 [inline]
 hugetlb_vma_lock_write+0xae/0x100 mm/hugetlb.c:291
 __hugetlb_zap_begin+0x1e9/0x2b0 mm/hugetlb.c:5447
 hugetlb_zap_begin include/linux/hugetlb.h:258 [inline]
 unmap_vmas+0x2f4/0x470 mm/memory.c:1733
 exit_mmap+0x1ad/0xa60 mm/mmap.c:3230
 __mmput+0x12a/0x4d0 kernel/fork.c:1349
 mmput+0x62/0x70 kernel/fork.c:1371
 exit_mm kernel/exit.c:567 [inline]
 do_exit+0x9ad/0x2a20 kernel/exit.c:861
 __do_sys_exit kernel/exit.c:991 [inline]
 __se_sys_exit kernel/exit.c:989 [inline]
 __x64_sys_exit+0x42/0x50 kernel/exit.c:989
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Mask off low bit flags before checking for NULL pointer.  In addition, the
reserve map only 'belongs' to the OWNER (parent in parent/child
relationships) so also check for the OWNER flag.

Link: https://lkml.kernel.org/r/20231114012033.259600-1-mike.kravetz@oracle.com
Reported-by: syzbot+6ada951e7c0f7bc8a71e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/00000000000078d1e00608d7878b@google.com/
Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Edward Adam Davis <eadavis@qq.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    5 +----
 mm/hugetlb.c            |    7 +++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1265,10 +1265,7 @@ static inline bool __vma_shareable_lock(
 	return (vma->vm_flags & VM_MAYSHARE) && vma->vm_private_data;
 }
 
-static inline bool __vma_private_lock(struct vm_area_struct *vma)
-{
-	return (!(vma->vm_flags & VM_MAYSHARE)) && vma->vm_private_data;
-}
+bool __vma_private_lock(struct vm_area_struct *vma);
 
 /*
  * Safe version of huge_pte_offset() to check the locks.  See comments
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1189,6 +1189,13 @@ static int is_vma_resv_set(struct vm_are
 	return (get_vma_private_data(vma) & flag) != 0;
 }
 
+bool __vma_private_lock(struct vm_area_struct *vma)
+{
+	return !(vma->vm_flags & VM_MAYSHARE) &&
+		get_vma_private_data(vma) & ~HPAGE_RESV_MASK &&
+		is_vma_resv_set(vma, HPAGE_RESV_OWNER);
+}
+
 void hugetlb_dup_vma_private(struct vm_area_struct *vma)
 {
 	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);


