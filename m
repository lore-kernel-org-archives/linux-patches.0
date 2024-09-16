Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2448155CA5;
	Mon, 16 Sep 2024 12:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488274; cv=none; b=gVmNestrjMXVwWI7aUCJ/w8f5R8RUoEBQhgSxuboGNjoA4hgWL2XEdTBotXzU+T98DC8BwUde2N+DEMi4eUkr3gpir4y/tsurZfJR94KteTC+E9ctkd3XwgZ8tYR91qkFEMgKGIQOray69Xh6/gUPDCwkoZdWh+VdGY2ZMh0tGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488274; c=relaxed/simple;
	bh=irQzuFiTspjxNqzGisvvkxxFf8/pbRUxVsFkdBfAwGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGtzPt4YhEM4Dtku3HKKDk9LJQj0omGgI1VzZadOQAa/ts56UqroTUFN4/nKtZ6ZcCRe8/XQSbAInLpmh6piDPSZw82d7jzYN/E6iefpT0QY/MG8OBs9OjzlHcSe6iNn8JTNazzDbeUZ25azvoevnHXKl6ozRyfEOzloCdH/Dz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/vEAWtu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/vEAWtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245D2C4CEC4;
	Mon, 16 Sep 2024 12:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488273;
	bh=irQzuFiTspjxNqzGisvvkxxFf8/pbRUxVsFkdBfAwGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/vEAWtuugbCfl6PM5bQoeKCK4WQanJkoT1CdCjHnbmOUBpbcG8+cL+/QCg7dY66L
	 bsoSFA9EIenx0thlF86wuE134pH+rtKR2b6Pd5CJu2oFSVI3Az2oCkO7mJ0RA0x1jN
	 JyeOFpjx1ptKDgJIXeGBeBNeigqVRfVbk0Kvums0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.10 055/121] mm: avoid leaving partial pfn mappings around in error case
Date: Mon, 16 Sep 2024 13:43:49 +0200
Message-ID: <20240916114230.971579306@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2581,11 +2581,7 @@ static inline int remap_p4d_range(struct
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
@@ -2638,6 +2634,27 @@ int remap_pfn_range_notrack(struct vm_ar
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


