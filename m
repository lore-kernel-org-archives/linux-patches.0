Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D1C194A45;
	Tue, 27 May 2025 17:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368375; cv=none; b=JEghPI+hjQpDgt+K/vEjZC4dg2bil/RcuVzld5LZWDwT8jt8aiSnDEP/4wZRZS3OSv1JPLVMhZlufhWOXKvzMblOtpZkgH8XDQ2U1pqA/tXo36kIrlxlC669yZ9IU/mjTfEXkw7vQuLgTuAbHW+N408s7riG5Rgmr158+NaUfW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368375; c=relaxed/simple;
	bh=X5vzyjgCjzHxwGuZc8o6T0UNnkSIkqBeAVNK6pNdL3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BehO+1WfVnW+wCBRPgpHqJ+6XxAdap3dfX08M6M+O0rKb59soRRNvjlIbb+HQjgqzMs+RlorUqJ1uIqffaGtAKO2PWaKIYsUXXjzESvUc0lxRSsFLpPbFBBn1YLlYMBPzbsB+8LWHg9P2OINPRw/ML/pTVjWU8vm7HOEIm97bvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeqnpBeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeqnpBeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59A4C4CEE9;
	Tue, 27 May 2025 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368375;
	bh=X5vzyjgCjzHxwGuZc8o6T0UNnkSIkqBeAVNK6pNdL3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeqnpBeO37UPD6xMWdCQ7O3gOoh4GOie95bbP6fUAkFwY6iRV5CLctIX4SuH+9BIB
	 i7h3yvB1KZWVXm6MRDxXvDMEWtLQMIDs2riYqE5JJS2oyhVIdB/Zf6Zt/GJb817ZvT
	 2d2SNKuuerqxUSsDaijCVVTzFPcNhqZROi3gHJaE=
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
Subject: [PATCH 6.14 687/783] kernel/fork: only call untrack_pfn_clear() on VMAs duplicated for fork()
Date: Tue, 27 May 2025 18:28:04 +0200
Message-ID: <20250527162541.112289645@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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
index ca2ca3884f763..5e640468baff1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -504,10 +504,6 @@ struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig)
 	vma_numab_state_init(new);
 	dup_anon_vma_name(orig, new);
 
-	/* track_pfn_copy() will later take care of copying internal state. */
-	if (unlikely(new->vm_flags & VM_PFNMAP))
-		untrack_pfn_clear(new);
-
 	return new;
 }
 
@@ -698,6 +694,11 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
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



