Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDB61E490B;
	Tue, 15 Oct 2024 11:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992159; cv=none; b=WAlZR2GXKC6Ai2HJJzsujXXHGcxCwtm1CE3PXBwSJfdejHvOX0EwwzncEq2+ZTsxLYVOuovxkVSsfESd6qm/ik+Cd9TiUl9ThOpahLytebDfE5Wf3RUIxmHQvoeS/G2DP6QOF76V3x30TFFoe9kerTu5QIHpUNHz1HIZnOQz0n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992159; c=relaxed/simple;
	bh=5HKTQziiWj9Q61QENxeFjnJpTyOuB6YAopP4hNU6/tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jG37p8GUtt2aV+9tOujE1jcadQzUHnkmdgSAC6nO2i00JoOw5RrHlggwki2zhHosaGM8wD7blY6VcUFDW3ebRBXUoQpGsNSo025pnuj/6bfKnFFoJEhzIl7UHJw7QHGniTE5e7Ela62H5jpL8Ez+xj8/E7gxrb1ShVaVkIpxkII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0p2PEqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0p2PEqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB75AC4CEC6;
	Tue, 15 Oct 2024 11:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992159;
	bh=5HKTQziiWj9Q61QENxeFjnJpTyOuB6YAopP4hNU6/tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0p2PEqCON+EKRatFb1YWoP0sNFxA6qp17/Af1vNyONEZaFcA5EpHhFP6OF+Rppgc
	 zlCyyJ5SHSwqFJgKOZWx6lwL95KGG0cgMgOBADQBZNtMFHQl21crgbSet/qnYLlCSZ
	 Md3GLZVprVeHmSZ+KDvitJn1gmlEPq3oUiKBJGgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 5.15 035/691] mm: avoid leaving partial pfn mappings around in error case
Date: Tue, 15 Oct 2024 13:19:43 +0200
Message-ID: <20241015112441.730743136@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 79a61cc3fc0466ad2b7b89618a6157785f0293b3 upstream.

As Jann points out, PFN mappings are special, because unlike normal
memory mappings, there is no lifetime information associated with the
mapping - it is just a raw mapping of PFNs with no reference counting of
a 'struct page'.

That's all very much intentional, but it does mean that it's easy to
mess up the cleanup in case of errors.  Yes, a failed mmap() will always
eventually clean up any partial mappings, but without any explicit
lifetime in the page table mapping itself, it's very easy to do the
error handling in the wrong order.

In particular, it's easy to mistakenly free the physical backing store
before the page tables are actually cleaned up and (temporarily) have
stale dangling PTE entries.

To make this situation less error-prone, just make sure that any partial
pfn mapping is torn down early, before any other error handling.

Reported-and-tested-by: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2380,11 +2380,7 @@ static inline int remap_p4d_range(struct
 	return 0;
 }
 
-/*
- * Variant of remap_pfn_range that does not call track_pfn_remap.  The caller
- * must have pre-validated the caching bits of the pgprot_t.
- */
-int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long addr,
+static int remap_pfn_range_internal(struct vm_area_struct *vma, unsigned long addr,
 		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
 	pgd_t *pgd;
@@ -2437,6 +2433,27 @@ int remap_pfn_range_notrack(struct vm_ar
 	return 0;
 }
 
+/*
+ * Variant of remap_pfn_range that does not call track_pfn_remap.  The caller
+ * must have pre-validated the caching bits of the pgprot_t.
+ */
+int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t prot)
+{
+	int error = remap_pfn_range_internal(vma, addr, pfn, size, prot);
+
+	if (!error)
+		return 0;
+
+	/*
+	 * A partial pfn range mapping is dangerous: it does not
+	 * maintain page reference counts, and callers may free
+	 * pages due to the error. So zap it early.
+	 */
+	zap_page_range_single(vma, addr, size, NULL);
+	return error;
+}
+
 /**
  * remap_pfn_range - remap kernel memory to userspace
  * @vma: user vma to map to


