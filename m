Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D798284693;
	Wed, 23 Apr 2025 14:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420334; cv=none; b=HVq1J9N5wV7IhfEivP48/79Tb4FEedtkFpfwxY53kv+ITCv/3bM00meWTSufkhWY4yj0Cjbdf40BOykpqYT9vhSDQNv6heNmNj2nGy4sohCXwwxSlk6Gyc9D4SaF7VmhW0StJo5ngJVarEYPudwtX2COw8ddEVlqsbLJfDZXn/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420334; c=relaxed/simple;
	bh=6x1Y2qDzDgeFRvuqpF5qfn/n066UG/0AcB1gZWGko1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZOe01QUWAWxOJAg0NdQeo1GRt8yhwLyMLu9e/Yuz3fDMIayRZbFS/AeG6qZg6zWmwqfbT4qB+gIeiMo5VU5l9hatSrWA/nY8jtOvGnb78D41ZhB47PaQD3oxAia0J9j4AEhkgSAoaAzNFnlcKRtJVs4n0OZfdryFoFQBwU3jlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDZwX7js; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDZwX7js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C7EC4CEE2;
	Wed, 23 Apr 2025 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420334;
	bh=6x1Y2qDzDgeFRvuqpF5qfn/n066UG/0AcB1gZWGko1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDZwX7jsq4GesmyQ4Oy75KEraz9DAhWwFZexScZqVgf9z2Xn9w9uPf/H1wXyuS10z
	 ISNeRam9QwRwtIr0k7sGmKpkbQrlEvi9hzNd9gu0ntWjsbTY6kO4/KXsknZBrE2gtF
	 dwQlQx6KuuDlE8Sc2G1bsooQ808YaciDoBLPjymo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Daniel Axtens <dja@axtens.net>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 120/223] mm: fix apply_to_existing_page_range()
Date: Wed, 23 Apr 2025 16:43:12 +0200
Message-ID: <20250423142621.995251391@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

commit a995199384347261bb3f21b2e171fa7f988bd2f8 upstream.

In the case of apply_to_existing_page_range(), apply_to_pte_range() is
reached with 'create' set to false.  When !create, the loop over the PTE
page table is broken.

apply_to_pte_range() will only move to the next PTE entry if 'create' is
true or if the current entry is not pte_none().

This means that the user of apply_to_existing_page_range() will not have
'fn' called for any entries after the first pte_none() in the PTE page
table.

Fix the loop logic in apply_to_pte_range().

There are no known runtime issues from this, but the fix is trivial enough
for stable@ even without a known buggy user.

Link: https://lkml.kernel.org/r/20250409094043.1629234-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: be1db4753ee6 ("mm/memory.c: add apply_to_existing_page_range() helper")
Cc: Daniel Axtens <dja@axtens.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2811,11 +2811,11 @@ static int apply_to_pte_range(struct mm_
 	if (fn) {
 		do {
 			if (create || !pte_none(ptep_get(pte))) {
-				err = fn(pte++, addr, data);
+				err = fn(pte, addr, data);
 				if (err)
 					break;
 			}
-		} while (addr += PAGE_SIZE, addr != end);
+		} while (pte++, addr += PAGE_SIZE, addr != end);
 	}
 	*mask |= PGTBL_PTE_MODIFIED;
 


