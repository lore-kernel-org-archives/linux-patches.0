Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8038A46D2A3;
	Fri,  9 Oct 2026 14:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555731; cv=none; b=c8N6JaGoPrs3GLDqNz7XLK+HV2qQSE9CmrO1FX2NXB32OzKGi2XcAdMEz2f+sJat0qnhfTn5S82W0uk2ETFTDGIfr0CngWu6Xb47NSIhQPZfOiG5A11dfvIKnBxoZ9xiy1Wv3gvDM52yvLcXss/vVRUUPsrNRumCfCneHNxNJfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555731; c=relaxed/simple;
	bh=bI1BKMN7y/Woy9G/prLrWnl8yq8iDXNu4slzoZW78k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1i1ckzblAYn0BM4xOmjdTQ1JT4hN87KfC/9Rs6C3RC2ExvixmwAT51zlIbU/qJo2GgdssOQ5Pgednr5fFL2cOhqLdQbqx4mXAHfJ0PCQhu6XxjqEC4Y5CQzxmfZwnusH7/vslVqdZ4a+DDPwXeceRVlhbK996WAorfmHSEXTQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13fic7Aw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13fic7Aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AB41F00893;
	Fri,  9 Oct 2026 14:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555730;
	bh=mP6P9Ap9PRLaKpp5Ar9riPE1vIBXMnFMwneNxClzu5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13fic7Aw9U0gkQQklpL29FS0tVSp5xfZ99S8jI0XjaciMHdZiJ78cC6AWGu7luLjf
	 9HyMQjoBISSj9WKrshn8GJbdSa1Y/XiC4VRqDb74sMzQRY1y8QuXmSt6LnXQlPCPRN
	 ZBFjgG5bDH0WLrsQZLPzO4AqmkcZe++Raiwp8AF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH 7.2 056/428] mm/vma: predicate setting mmap_prepare VMA fields on new vma alloc
Date: Fri,  9 Oct 2026 16:06:33 +0200
Message-ID: <20261009140947.362926445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit 976d5e0ddac885b0219252f004f6c561c344df9d upstream.

It only makes sense to manipulate VMA fields if a new VMA was allocated,
rather than merged.

VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
keeps its own, which is also what the legacy f_op->mmap path does since it
never touches an existing VMA.

Currently, these fields will get overwritten by whatever state is
established in the mmap_prepare hook, and if the VMA was merged,
vm_ops->mapped will not have been called, so this could destructively
clear existing state without replacing it with anything valid.

There is an implicit requirement that vm_private_data and vm_ops are
fungible across VMAs which means that losing the 'new' state is fine.

However in this case the 'old' state is being overwritten by potentially
invalid 'new' state, so this must be rectified.

Additionally constify have_mmap_prepare while here.

All existing in-tree users either derive state from the file or are
unmergeable due to VMA flags, so this has no direct impact.

Link: https://lore.kernel.org/20260923-fix-mmap-prepare-overwrite-v1-1-3b3f1bfcdf5e@kernel.org
Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2745,7 +2745,7 @@ static unsigned long __mmap_region(struc
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
-	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
+	const bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
 	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, vma_flags, file);
 	struct vm_area_desc desc = {
@@ -2787,7 +2787,7 @@ static unsigned long __mmap_region(struc
 		allocated_new = true;
 	}
 
-	if (have_mmap_prepare)
+	if (have_mmap_prepare && allocated_new)
 		set_vma_user_defined_fields(vma, &map);
 
 	__mmap_complete(&map, vma);


