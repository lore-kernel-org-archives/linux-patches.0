Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3310C1547F5;
	Mon, 16 Sep 2024 12:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488616; cv=none; b=KwtZyfsiKXYr4lYbwezAlY1qEWngP6yufAl4VdNmal4Z63740Iwwr219YGkFVSP0QKssjaWuzDTINrAEIi/zPNBdiCzK5PUHxrhzS5L0ZS8M7Bs267GO0gBKwUodjVwBAPe4c/hzCd+VuxBxhe62VCaUsUlPPdg7MY9X5uRhau4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488616; c=relaxed/simple;
	bh=nJpOfDU8B0ps+Mj9Z5LqTpYSs8oVZbqfXWY3FB36M2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5jMpjgh/GJJfWw1buS+1CpWezIHDE4+UIPceG6z5rgo2aUCCDguFHI8uahaF2B2il4K7dWYi125kwnUi/5cpwrPP9TqMcn1Pa9xtsSOMSiPt5rv/VKEsRTlmo60FXJDei3BQJlkFQZS9D5VvfrAdUD94NGbvpGEezpA39vNlk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+d+9TBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+d+9TBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DDDC4CEC4;
	Mon, 16 Sep 2024 12:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488616;
	bh=nJpOfDU8B0ps+Mj9Z5LqTpYSs8oVZbqfXWY3FB36M2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+d+9TBUp7uDILtOZwkF/+d4FkrS8Q2zBtDk9aqOs1X6AKCKFc3EYOLQ8udWsxojS
	 i6df29661OMkdQfdLmnr6+SUwW4YeYfdsRnKLEf/2BeYA720ZGfJqBgtO1WwP1I7GE
	 kJtlyStomF+/Dyq5vXdc6CVtIkH0eqM4GASm5800=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.6 46/91] mm: avoid leaving partial pfn mappings around in error case
Date: Mon, 16 Sep 2024 13:44:22 +0200
Message-ID: <20240916114226.017097211@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2424,11 +2424,7 @@ static inline int remap_p4d_range(struct
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
@@ -2481,6 +2477,27 @@ int remap_pfn_range_notrack(struct vm_ar
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


