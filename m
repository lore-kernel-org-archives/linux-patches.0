Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B005389108;
	Tue, 10 Mar 2026 11:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142052; cv=none; b=HF5NC+M/rNHSkPnq/qFLsrUfwJBKQBCOUKiPj4jICKB3Qj4qauoFCu95CDGSgZHyjKX8pMiAmP7k7FTb0Rkda1MMqDJqvZTICAcifQF7MjqlP3EmNiR9XBntz75+bo1OcuZJmSfDw3jeVaFE2lTknFNwO/YWJYMhzpIm97igsRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142052; c=relaxed/simple;
	bh=1EBbqV21kCmiLx00WIO/0oTSBzzPSH+EX6YAqTsbp/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwnQaX3AJZ2lVZlu9by5KyKm2uPNUWpyTE9aa3BLrQKvfNu77HG7lRKaHqjASAiJlQPyw4voncAnQ6lJUnnv64VH2UWQkjm+ZqpZlDitcz9R5aEpoKIDSp8kZliu3MC+R6bbaFw7LsAwfmJQoTj6QQ8SwdI4RGVMiv02JKALXKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XbJVdOmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XbJVdOmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A58FC2BC9E;
	Tue, 10 Mar 2026 11:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142052;
	bh=1EBbqV21kCmiLx00WIO/0oTSBzzPSH+EX6YAqTsbp/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbJVdOmyUWzi8UFoohlthD83zgBz0k3gPBnyZtZ7SP+dtuJZ88tRVFXNA7Cm/eVSq
	 Tzu/aYTYeBwGTYq66htAPlYaLIWxKQBsEgdZ44uL5n1RRXtz5VAdphU24FlFyxttDL
	 vOSZTmu000TXYsK/EzRECHDo1+Ml09bnqCLTfHW1FtsQweoLzRTezQtxtlJeg02/q5
	 67fYJtIFaraofC/rFKfCq+nb+207l9HOSM63DNVdNRhAO0OGTZVWt2YJOzAMYsbMAE
	 +NhMJpsC77Tnhbm6tqQD/oWZ0B3Sad8x5ttR7f5hCooVzayCbc61ldrkHPI2XMHqnE
	 G5koLq3mGBYYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Fangrui Song <i@maskray.me>,
	Liam Howlett <liam.howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <shy828301@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 178/314] mm: thp: deny THP for files on anonymous inodes
Date: Tue, 10 Mar 2026 07:17:17 -0400
Message-ID: <4c0f46df2a92aca7d6242e08817773487e3132a0.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit dd085fe9a8ebfc5d10314c60452db38d2b75e609 upstream.

file_thp_enabled() incorrectly allows THP for files on anonymous inodes
(e.g. guest_memfd and secretmem). These files are created via
alloc_file_pseudo(), which does not call get_write_access() and leaves
inode->i_writecount at 0. Combined with S_ISREG(inode->i_mode) being
true, they appear as read-only regular files when
CONFIG_READ_ONLY_THP_FOR_FS is enabled, making them eligible for THP
collapse.

Anonymous inodes can never pass the inode_is_open_for_write() check
since their i_writecount is never incremented through the normal VFS
open path. The right thing to do is to exclude them from THP eligibility
altogether, since CONFIG_READ_ONLY_THP_FOR_FS was designed for real
filesystem files (e.g. shared libraries), not for pseudo-filesystem
inodes.

For guest_memfd, this allows khugepaged and MADV_COLLAPSE to create
large folios in the page cache via the collapse path, but the
guest_memfd fault handler does not support large folios. This triggers
WARN_ON_ONCE(folio_test_large(folio)) in kvm_gmem_fault_user_mapping().

For secretmem, collapse_file() tries to copy page contents through the
direct map, but secretmem pages are removed from the direct map. This
can result in a kernel crash:

    BUG: unable to handle page fault for address: ffff88810284d000
    RIP: 0010:memcpy_orig+0x16/0x130
    Call Trace:
     collapse_file
     hpage_collapse_scan_file
     madvise_collapse

Secretmem is not affected by the crash on upstream as the memory failure
recovery handles the failed copy gracefully, but it still triggers
confusing false memory failure reports:

    Memory failure: 0x106d96f: recovery action for clean unevictable
    LRU page: Recovered

Check IS_ANON_FILE(inode) in file_thp_enabled() to deny THP for all
anonymous inode files.

Link: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
Link: https://lore.kernel.org/linux-mm/CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com
Link: https://lkml.kernel.org/r/20260214001535.435626-1-kartikey406@gmail.com
Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Fangrui Song <i@maskray.me>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8ad170b9855a5..35ec12c4d7766 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -94,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 
 	inode = file_inode(vma->vm_file);
 
+	if (IS_ANON_FILE(inode))
+		return false;
+
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
-- 
2.51.0

