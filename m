Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D3A524D7;
	Mon, 11 Dec 2023 18:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbyPbSzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33FCC433C9;
	Mon, 11 Dec 2023 18:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319611;
	bh=cTF2GC+9aIFqD+6nB1EdY1Y6Qv+aPoLR8EYrpXfENq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbyPbSzvz5975Se0ft76Hu7bM36LyjtPQ6ZUt56B2/oI66pHjQv1i0IllBJwnZSvA
	 +5dfZ+Kwh+n3QaiAkiZ2YL6GAMK4DrQkLoXlnqSaHMsj6kIu2fdn8uPUUqi4OdkCnH
	 ZYnWIG1Un2psubJv8Lr7UE/yIR9zkK/1ARwDdZr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Jos=C3=A9=20Pekkarinen?= <jose.pekkarinen@foxhound.fi>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+89edd67979b52675ddec@syzkaller.appspotmail.com,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.6 168/244] mm: fix oops when filemap_map_pmd() without prealloc_pte
Date: Mon, 11 Dec 2023 19:21:01 +0100
Message-ID: <20231211182053.417228446@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 9aa1345d66b8132745ffb99b348b1492088da9e2 upstream.

syzbot reports oops in lockdep's __lock_acquire(), called from
__pte_offset_map_lock() called from filemap_map_pages(); or when I run the
repro, the oops comes in pmd_install(), called from filemap_map_pmd()
called from filemap_map_pages(), just before the __pte_offset_map_lock().

The problem is that filemap_map_pmd() has been assuming that when it finds
pmd_none(), a page table has already been prepared in prealloc_pte; and
indeed do_fault_around() has been careful to preallocate one there, when
it finds pmd_none(): but what if *pmd became none in between?

My 6.6 mods in mm/khugepaged.c, avoiding mmap_lock for write, have made it
easy for *pmd to be cleared while servicing a page fault; but even before
those, a huge *pmd might be zapped while a fault is serviced.

The difference in symptomatic stack traces comes from the "memory model"
in use: pmd_install() uses pmd_populate() uses page_to_pfn(): in some
models that is strict, and will oops on the NULL prealloc_pte; in other
models, it will construct a bogus value to be populated into *pmd, then
__pte_offset_map_lock() oops when trying to access split ptlock pointer
(or some other symptom in normal case of ptlock embedded not pointer).

Link: https://lore.kernel.org/linux-mm/20231115065506.19780-1-jose.pekkarinen@foxhound.fi/
Link: https://lkml.kernel.org/r/6ed0c50c-78ef-0719-b3c5-60c0c010431c@google.com
Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-and-tested-by: syzbot+89edd67979b52675ddec@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/0000000000005e44550608a0806c@google.com/
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>,
Cc: José Pekkarinen <jose.pekkarinen@foxhound.fi>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>    [5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3422,7 +3422,7 @@ static bool filemap_map_pmd(struct vm_fa
 		}
 	}
 
-	if (pmd_none(*vmf->pmd))
+	if (pmd_none(*vmf->pmd) && vmf->prealloc_pte)
 		pmd_install(mm, vmf->pmd, &vmf->prealloc_pte);
 
 	return false;


