Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90ED1C5D78;
	Wed, 19 Mar 2025 14:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394838; cv=none; b=EL2vBN6vsNmMLSavZorWpZFsCPWXzc5qwZzGacluyfSwBg3g/HnzIhaHO+RZo9r4upAkUBMnub8qclkRNSKFI90ouDJpJxCzgNjrBj8um2nPD3ZitdPuwC/jpJufiZOdlX1tsuPQiSzTXBPPJPMk23eBdgc6i+mrqymmvS7rBW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394838; c=relaxed/simple;
	bh=CX1t4RZtDuEHhM07litRjO8I2GWFY6ovCctH/gw9/Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcEe7uczGLqrHJe0a4fSca3TVRdSNGSIaU9qSa4n1uCWJCsmpoFc1xFzLohZV85ghvsPY6k+6eymssG5/RdJhEtp0Qp+IbwBR+Gp/xCXzWBhiAqNDTBJesBdCsYSuHZT8vEMuI6W24YR6FvHVOz67XVtSnSsYZ5hcigurVNm0ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpAYv6Hd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpAYv6Hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF2AC4CEE8;
	Wed, 19 Mar 2025 14:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394838;
	bh=CX1t4RZtDuEHhM07litRjO8I2GWFY6ovCctH/gw9/Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpAYv6HdnZANHyexPkkEpqZMNs4zcrX8jDYTEyja2Xsqn8dYuQBroMOY9WAqhwjoM
	 Zzggq0txI1A2FRnXUFHuA7RfiYjW6Zh1DwKbpAlmAlnZHTexMRQYkEHGxonVu4aghb
	 jG+hFlgQ+WmDHj3KwD2nXOyndKgDkwMhJU5ttleU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Peter Xu <peterx@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Barry Song <21cnbao@gmail.com>,
	Barry Song <v-songbaohua@oppo.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Jann Horn <jannh@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcow (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 002/241] userfaultfd: fix PTE unmapping stack-allocated PTE copies
Date: Wed, 19 Mar 2025 07:27:52 -0700
Message-ID: <20250319143027.755521515@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

commit 927e926d72d9155fde3264459fe9bfd7b5e40d28 upstream.

Current implementation of move_pages_pte() copies source and destination
PTEs in order to detect concurrent changes to PTEs involved in the move.
However these copies are also used to unmap the PTEs, which will fail if
CONFIG_HIGHPTE is enabled because the copies are allocated on the stack.
Fix this by using the actual PTEs which were kmap()ed.

Link: https://lkml.kernel.org/r/20250226185510.2732648-3-surenb@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1274,8 +1274,8 @@ retry:
 			spin_unlock(src_ptl);
 
 			if (!locked) {
-				pte_unmap(&orig_src_pte);
-				pte_unmap(&orig_dst_pte);
+				pte_unmap(src_pte);
+				pte_unmap(dst_pte);
 				src_pte = dst_pte = NULL;
 				/* now we can block and wait */
 				folio_lock(src_folio);
@@ -1291,8 +1291,8 @@ retry:
 		/* at this point we have src_folio locked */
 		if (folio_test_large(src_folio)) {
 			/* split_folio() can block */
-			pte_unmap(&orig_src_pte);
-			pte_unmap(&orig_dst_pte);
+			pte_unmap(src_pte);
+			pte_unmap(dst_pte);
 			src_pte = dst_pte = NULL;
 			err = split_folio(src_folio);
 			if (err)
@@ -1317,8 +1317,8 @@ retry:
 				goto out;
 			}
 			if (!anon_vma_trylock_write(src_anon_vma)) {
-				pte_unmap(&orig_src_pte);
-				pte_unmap(&orig_dst_pte);
+				pte_unmap(src_pte);
+				pte_unmap(dst_pte);
 				src_pte = dst_pte = NULL;
 				/* now we can block and wait */
 				anon_vma_lock_write(src_anon_vma);
@@ -1336,8 +1336,8 @@ retry:
 		entry = pte_to_swp_entry(orig_src_pte);
 		if (non_swap_entry(entry)) {
 			if (is_migration_entry(entry)) {
-				pte_unmap(&orig_src_pte);
-				pte_unmap(&orig_dst_pte);
+				pte_unmap(src_pte);
+				pte_unmap(dst_pte);
 				src_pte = dst_pte = NULL;
 				migration_entry_wait(mm, src_pmd, src_addr);
 				err = -EAGAIN;
@@ -1380,8 +1380,8 @@ retry:
 			src_folio = folio;
 			src_folio_pte = orig_src_pte;
 			if (!folio_trylock(src_folio)) {
-				pte_unmap(&orig_src_pte);
-				pte_unmap(&orig_dst_pte);
+				pte_unmap(src_pte);
+				pte_unmap(dst_pte);
 				src_pte = dst_pte = NULL;
 				put_swap_device(si);
 				si = NULL;


