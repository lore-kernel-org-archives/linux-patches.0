Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC042798E6;
	Tue, 27 May 2025 17:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365948; cv=none; b=WFTy+q/3Cf+qsrPqmrIumB8kkITRfoKVaxqy89fuy0DkJnHEglSoiDWVC3JOpEpS0MitY/sILJy3TZDqkakR82zFXa9WpaNfO41WQh4NKKg2fGR53lIDM35IjXqh4MhzC9CNBSC8biIAnffobpxzq32nFfagLQhDtcjeAAHptC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365948; c=relaxed/simple;
	bh=zUv9unDr/csTW4Hl9SKuvhO5S+8g/QxqdJ5xeIZVfVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKLWrHDgCaVWzwMlAfwWLZZztiHfyn1bI5hU8Ic34H2q3NhSl5VrBhXD5K+SXagQ/GZKG0J1U+vLhg7fiknMK+Zwd04XG5HjFfHrMPZ5Oa9yGN3+BYFEEg24hfAWGu1sXYCalHbG5D4M+/7r0jtmEACzVntZHT2AgAyvZY0cLGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KObcG44K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KObcG44K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C93CC4CEE9;
	Tue, 27 May 2025 17:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365947;
	bh=zUv9unDr/csTW4Hl9SKuvhO5S+8g/QxqdJ5xeIZVfVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KObcG44Kwes0rMu9m9WUbBXnJ59iopn8LTHdlfL2lY40yA8gTS6V3AozLuDciqiLk
	 EaPrF9xJLtPkSRg+lHfynvVDV2sed9r0yNXyReSmMWqFSHA34UxsHxVDFv8GVyADr+
	 VGz0jCcs7NPD06PLfFkfQPGDs5KusW5nvHA/uWB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ingo Molnar <mingo@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Rik van Riel <riel@surriel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 540/626] kernel/fork: only call untrack_pfn_clear() on VMAs duplicated for fork()
Date: Tue, 27 May 2025 18:27:13 +0200
Message-ID: <20250527162506.927604804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit e9f180d7cfde23b9f8eebd60272465176373ab2c ]

Not intuitive, but vm_area_dup() located in kernel/fork.c is not only used
for duplicating VMAs during fork(), but also for duplicating VMAs when
splitting VMAs or when mremap()'ing them.

VM_PFNMAP mappings can at least get ordinarily mremap()'ed (no change in
size) and apparently also shrunk during mremap(), which implies
duplicating the VMA in __split_vma() first.

In case of ordinary mremap() (no change in size), we first duplicate the
VMA in copy_vma_and_data()->copy_vma() to then call untrack_pfn_clear() on
the old VMA: we effectively move the VM_PAT reservation.  So the
untrack_pfn_clear() call on the new VMA duplicating is wrong in that
context.

Splitting of VMAs seems problematic, because we don't duplicate/adjust the
reservation when splitting the VMA.  Instead, in memtype_erase() -- called
during zapping/munmap -- we shrink a reservation in case only the end
address matches: Assume we split a VMA into A and B, both would share a
reservation until B is unmapped.

So when unmapping B, the reservation would be updated to cover only A.
When unmapping A, we would properly remove the now-shrunk reservation.
That scenario describes the mremap() shrinking (old_size > new_size),
where we split + unmap B, and the untrack_pfn_clear() on the new VMA when
is wrong.

What if we manage to split a VM_PFNMAP VMA into A and B and unmap A first?
It would be broken because we would never free the reservation.  Likely,
there are ways to trigger such a VMA split outside of mremap().

Affecting other VMA duplication was not intended, vm_area_dup() being used
outside of kernel/fork.c was an oversight.  So let's fix that for; how to
handle VMA splits better should be investigated separately.

With a simple reproducer that uses mprotect() to split such a VMA I can
trigger

x86/PAT: pat_mremap:26448 freeing invalid memtype [mem 0x00000000-0x00000fff]

Link: https://lkml.kernel.org/r/20250422144942.2871395-1-david@redhat.com
Fixes: dc84bc2aba85 ("x86/mm/pat: Fix VM_PAT handling when fork() fails in copy_page_range()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 12decadff468f..97c9afe3efc38 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -505,10 +505,6 @@ struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig)
 	vma_numab_state_init(new);
 	dup_anon_vma_name(orig, new);
 
-	/* track_pfn_copy() will later take care of copying internal state. */
-	if (unlikely(new->vm_flags & VM_PFNMAP))
-		untrack_pfn_clear(new);
-
 	return new;
 }
 
@@ -699,6 +695,11 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 		tmp = vm_area_dup(mpnt);
 		if (!tmp)
 			goto fail_nomem;
+
+		/* track_pfn_copy() will later take care of copying internal state. */
+		if (unlikely(tmp->vm_flags & VM_PFNMAP))
+			untrack_pfn_clear(tmp);
+
 		retval = vma_dup_policy(mpnt, tmp);
 		if (retval)
 			goto fail_nomem_policy;
-- 
2.39.5



