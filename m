Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB5A223710;
	Thu, 17 Apr 2025 18:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913597; cv=none; b=PDja9b/2lmBe0uXM8mTyKutJ4TanvlHBU8bM/3YTgY9nZOLPdt2BoZQvGyOjgIDft22vDMt8uihbCaMoqGYCrC7L46BuR8AQ2ZCRIQw8Sk5wwXES+znL2Hv9Vdlx+541uShQrTAXIQH1vSOzHZETtFdYmAoEi+O+TPdO0iyp8lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913597; c=relaxed/simple;
	bh=0w39aruh1drjTq/08r9gvZjOibcxX9HboKvDE1+EOHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbpPYd/1eQAc7h5R18tZJ3BIcOPCkr1i8PGLxf2QvzI7SnTFb/xxg1W7/u5XHJo7cySX9YZOUQG99ME0aeK24OtR8TEYJ1avkbZwANtG7nPmugAPwqgDzzP0p5rk93mCzIaG9hL7kWyKzEgF3ymFbK16dHGYLQrMPs1iMYk/ID4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bkQiVc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bkQiVc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8ACC4CEE4;
	Thu, 17 Apr 2025 18:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913597;
	bh=0w39aruh1drjTq/08r9gvZjOibcxX9HboKvDE1+EOHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1bkQiVc1VGdhj+xbxI/lFhHlEaEps6b+i24fB2PtXAO23jWFk8Yh/iFjzh0VADp97
	 OrRNvJebLW5Si7gK2BjHe3lQ2aPuVmlQw+KR2WXV28/nqbGN0lvac05ncpn87kwQHl
	 aOsbRruXqVnDSSWvZMP8rGZ1HeCoVEtUsKo/rx3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 361/449] mm/mremap: correctly handle partial mremap() of VMA starting at 0
Date: Thu, 17 Apr 2025 19:50:49 +0200
Message-ID: <20250417175132.760837945@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 937582ee8e8d227c30ec147629a0179131feaa80 upstream.

Patch series "refactor mremap and fix bug", v3.

The existing mremap() logic has grown organically over a very long period
of time, resulting in code that is in many parts, very difficult to follow
and full of subtleties and sources of confusion.

In addition, it is difficult to thread state through the operation
correctly, as function arguments have expanded, some parameters are
expected to be temporarily altered during the operation, others are
intended to remain static and some can be overridden.

This series completely refactors the mremap implementation, sensibly
separating functions, adding comments to explain the more subtle aspects
of the implementation and making use of small structs to thread state
through everything.

The reason for doing so is to lay the groundwork for planned future
changes to the mremap logic, changes which require the ability to easily
pass around state.

Additionally, it would be unhelpful to add yet more logic to code that is
already difficult to follow without first refactoring it like this.

The first patch in this series additionally fixes a bug when a VMA with
start address zero is partially remapped.

Tested on real hardware under heavy workload and all self tests are
passing.


This patch (of 3):

Consider the case of a partial mremap() (that results in a VMA split) of
an accountable VMA (i.e.  which has the VM_ACCOUNT flag set) whose start
address is zero, with the MREMAP_MAYMOVE flag specified and a scenario
where a move does in fact occur:

       addr  end
        |     |
        v     v
    |-------------|
    |     vma     |
    |-------------|
    0

This move is affected by unmapping the range [addr, end).  In order to
prevent an incorrect decrement of accounted memory which has already been
determined, the mremap() code in move_vma() clears VM_ACCOUNT from the VMA
prior to doing so, before reestablishing it in each of the VMAs
post-split:

    addr  end
     |     |
     v     v
 |---|     |---|
 | A |     | B |
 |---|     |---|

Commit 6b73cff239e5 ("mm: change munmap splitting order and move_vma()")
changed this logic such as to determine whether there is a need to do so
by establishing account_start and account_end and, in the instance where
such an operation is required, assigning them to vma->vm_start and
vma->vm_end.

Later the code checks if the operation is required for 'A' referenced
above thusly:

	if (account_start) {
		...
	}

However, if the VMA described above has vma->vm_start == 0, which is now
assigned to account_start, this branch will not be executed.

As a result, the VMA 'A' above will remain stripped of its VM_ACCOUNT
flag, incorrectly.

The fix is to simply convert these variables to booleans and set them as
required.

Link: https://lkml.kernel.org/r/cover.1741639347.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/dc55cb6db25d97c3d9e460de4986a323fa959676.1741639347.git.lorenzo.stoakes@oracle.com
Fixes: 6b73cff239e5 ("mm: change munmap splitting order and move_vma()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mremap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -705,8 +705,8 @@ static unsigned long move_vma(struct vm_
 	unsigned long vm_flags = vma->vm_flags;
 	unsigned long new_pgoff;
 	unsigned long moved_len;
-	unsigned long account_start = 0;
-	unsigned long account_end = 0;
+	bool account_start = false;
+	bool account_end = false;
 	unsigned long hiwater_vm;
 	int err = 0;
 	bool need_rmap_locks;
@@ -790,9 +790,9 @@ static unsigned long move_vma(struct vm_
 	if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP)) {
 		vm_flags_clear(vma, VM_ACCOUNT);
 		if (vma->vm_start < old_addr)
-			account_start = vma->vm_start;
+			account_start = true;
 		if (vma->vm_end > old_addr + old_len)
-			account_end = vma->vm_end;
+			account_end = true;
 	}
 
 	/*
@@ -832,7 +832,7 @@ static unsigned long move_vma(struct vm_
 		/* OOM: unable to split vma, just get accounts right */
 		if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP))
 			vm_acct_memory(old_len >> PAGE_SHIFT);
-		account_start = account_end = 0;
+		account_start = account_end = false;
 	}
 
 	if (vm_flags & VM_LOCKED) {


