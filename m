Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1254F85B7;
	Tue, 13 Oct 2026 12:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895424; cv=none; b=CD+5Is0bULEe++uKmRVC9+0T6T4elVhT99lWZe5J//X2um+K6QmUvvvwUlcs+1dwY25Vj7Q/HT60PTfkljRWOTWf7CLth4tavrf5Y9fxD7cLvR5nJ6DIa2JUf2bKyhRif/RDxqPbN44mQMcXcDI8Kj/sWr+IsjvGsfvJnQAtf7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895424; c=relaxed/simple;
	bh=poADd7scYg5L6H7ero4KSwqrxo1X9LYyfRuZfXs1fRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQqSpVheM44aYHKD2w3SIw5XNDEHR5V1pzsT92D/MDzJsL5vCn1gUFBc3BjXopFSiLjupyu5iHBekH8cgxVtU74rgIfHRwpeWrBD/8F+PM/z4tfAEP3lcFywbo8OqBv0sBPp4K/Lhw+ksCTTHKeM/XEQgBvQ2fYznG/AeyH+Zbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ef5Fauoy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ef5Fauoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102131F000FF;
	Tue, 13 Oct 2026 12:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895423;
	bh=mYVAQ4bLaDo3rHokBDEO2MFqth6E7Z+0MflsIJXq4R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ef5Fauoy6sDTK7Rv9kJTOZmh+D/MoEud+lZNE2/+Tj0q5qcKYNPnrCEfp6P+/uA9y
	 ymmEAdKJpBSpoQP6BrMLSUHf0SMCiPGGlr7RDjR+axQIOmdutNpvuIykQXLKVVMr9J
	 a8MiT+YnNYWXVUTuW8bXJav/HSy1Q0orHQa8jvv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Hugh Dickins <hughd@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Lance Yang <ioworker0@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 268/497] mm: factor out the order calculation into a new helper
Date: Tue, 13 Oct 2026 13:37:15 +0200
Message-ID: <20261013112914.254061617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit da243c5479add600bdd58c910c9fae3355b4f026 ]

Patch series "Support large folios for tmpfs", v3.

Traditionally, tmpfs only supported PMD-sized large folios.  However
nowadays with other file systems supporting any sized large folios, and
extending anonymous to support mTHP, we should not restrict tmpfs to
allocating only PMD-sized large folios, making it more special.  Instead,
we should allow tmpfs can allocate any sized large folios.

Considering that tmpfs already has the 'huge=' option to control the
PMD-sized large folios allocation, we can extend the 'huge=' option to
allow any sized large folios.  The semantics of the 'huge=' mount option
are:

huge=never: no any sized large folios
huge=always: any sized large folios
huge=within_size: like 'always' but respect the i_size
huge=advise: like 'always' if requested with madvise()

Note: for tmpfs mmap() faults, due to the lack of a write size hint, still
allocate the PMD-sized large folios if huge=always/within_size/advise is
set.

Moreover, the 'deny' and 'force' testing options controlled by
'/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the same
semantics.  The 'deny' can disable any sized large folios for tmpfs, while
the 'force' can enable PMD sized large folios for tmpfs.

This patch (of 6):

Factor out the order calculation into a new helper, which can be reused by
shmem in the following patch.

Link: https://lkml.kernel.org/r/cover.1732779148.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/5505f9ea50942820c1924d1803bfdd3a524e54f6.1732779148.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 72c3d682c165 ("mm: shmem: ignore sysfs configs for shmem forced collapse")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pagemap.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 68a5f1ff3301c..01717aa4a054b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -727,6 +727,16 @@ typedef unsigned int __bitwise fgf_t;
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
 
+static inline unsigned int filemap_get_order(size_t size)
+{
+	unsigned int shift = ilog2(size);
+
+	if (shift <= PAGE_SHIFT)
+		return 0;
+
+	return shift - PAGE_SHIFT;
+}
+
 /**
  * fgf_set_order - Encode a length in the fgf_t flags.
  * @size: The suggested size of the folio to create.
@@ -740,11 +750,11 @@ typedef unsigned int __bitwise fgf_t;
  */
 static inline fgf_t fgf_set_order(size_t size)
 {
-	unsigned int shift = ilog2(size);
+	unsigned int order = filemap_get_order(size);
 
-	if (shift <= PAGE_SHIFT)
+	if (!order)
 		return 0;
-	return (__force fgf_t)((shift - PAGE_SHIFT) << 26);
+	return (__force fgf_t)(order << 26);
 }
 
 void *filemap_get_entry(struct address_space *mapping, pgoff_t index);
-- 
2.53.0



