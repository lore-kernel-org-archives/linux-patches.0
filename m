Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035312BF3E2;
	Tue, 10 Mar 2026 11:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141148; cv=none; b=S51hUb9Hv1OX3ITXl5515iwKTJN6Sbs+cfHxs3tNgFaulGYEzIJqfZAxVCtlJ7FoZ881V6jWQKzPufxEA/xEVs3LJ7kkU8hzybSMd4U0nMtOkpI5/PT4NszNcKFJ3C3d0teGCJ0j5eMQxNyJNaC2++qdAnbtweAxUov89LgZu8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141148; c=relaxed/simple;
	bh=pEfgP5kTwCemvrPzFbLeTpgu4kq2EIp7cX7C5a/oPdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XINXEoYdnfgOfAWtSF1D4N15e9uiHWBdpRC5/3CRWR5UnLnmRsG42p9jLHbmXBeoq+9vSLNYiZLZsCjJAI9cefmzlrAs5fxOtr/PBSybMZCZqBGZnklrKu/PIzR4ncyl/sy+9RbuBj5Bo3nWjPxn7fHrF6YEEsVdmjBfqJU+tTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OToOdqYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OToOdqYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEBCC2BC9E;
	Tue, 10 Mar 2026 11:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141147;
	bh=pEfgP5kTwCemvrPzFbLeTpgu4kq2EIp7cX7C5a/oPdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OToOdqYNd3OBrU17fe1f31RD44HnZ/oPETTwrbZKJdvZQbqZvdWJoS/Tt0EhvMhHR
	 RoUhx7y6LJk7NaHpygpiL84R7az3NsThIa+v6BOAIpRw8yCFqSFegOy7nH1vjAx6eu
	 ZvZGW6upiwZ/0cp1LlJR6SdKBlYVZLD+awP6eIT3oHfO1AGphGq9PSu8Nq7NAwZRzw
	 hQRrGl6TjZLLCnj+d0IjQiP9+NyYIKNS5SiFm1iJifwHRXbbrlFeBbBB0mrC3KAlxe
	 cobJACCtWUl15AU0WUsLsOMixXwwM5B84WYB5WtKgHUMO3kbWLPinikEZgjOVO39DE
	 imTpjFEa/utYw==
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
Subject: [PATCH 6.19 150/311] mm: thp: deny THP for files on anonymous inodes
Date: Tue, 10 Mar 2026 07:03:17 -0400
Message-ID: <b4da286ddaac026b68533ed4da45be1e52f4d1ac.1773140655.git.sashal@kernel.org>
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
index 40cf59301c21a..d3beddd8cc30a 100644
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

