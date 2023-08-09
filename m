Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4072314A8D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE29EC433C8;
	Wed,  9 Aug 2023 10:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578254;
	bh=vy0OOD+YSoZmSiOgeeQwh8tKBFm1C0IeJLb3ivRcqOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQqJMSGIUi+tElF5KVE5ucV3IJ4gf23sR6sz8CM4XowqF+tDmSjJ5cuDBKW631OoC
	 AeCcuv+xEiV/8fLj08PeuDapJNEz5zCvNIPVoTFZaZ4x/0/QwrD6DMQE81nxa59ou6
	 q7tjqQ4kmTLfIR2jZ8bBRMtPCdRB2+u/hfmDfNic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Kravetz <mike.kravetz@oracle.com>,
	kernel test robot <oliver.sang@intel.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Erdem Aktas <erdemaktas@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 131/165] Revert "page cache: fix page_cache_next/prev_miss off by one"
Date: Wed,  9 Aug 2023 12:41:02 +0200
Message-ID: <20230809103647.102352796@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 16f8eb3eea9eb2a1568279d64ca4dc977e7aa538 upstream.

This reverts commit 9425c591e06a9ab27a145ba655fb50532cf0bcc9

The reverted commit fixed up routines primarily used by readahead code
such that they could also be used by hugetlb.  Unfortunately, this
caused a performance regression as pointed out by the Closes: tag.

The hugetlb code which uses page_cache_next_miss will be addressed in
a subsequent patch.

Link: https://lkml.kernel.org/r/20230621212403.174710-1-mike.kravetz@oracle.com
Fixes: 9425c591e06a ("page cache: fix page_cache_next/prev_miss off by one")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202306211346.1e9ff03e-oliver.sang@intel.com
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Erdem Aktas <erdemaktas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1760,9 +1760,7 @@ bool __folio_lock_or_retry(struct folio
  *
  * Return: The index of the gap if found, otherwise an index outside the
  * range specified (in which case 'return - index >= max_scan' will be true).
- * In the rare case of index wrap-around, 0 will be returned.  0 will also
- * be returned if index == 0 and there is a gap at the index.  We can not
- * wrap-around if passed index == 0.
+ * In the rare case of index wrap-around, 0 will be returned.
  */
 pgoff_t page_cache_next_miss(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan)
@@ -1772,13 +1770,12 @@ pgoff_t page_cache_next_miss(struct addr
 	while (max_scan--) {
 		void *entry = xas_next(&xas);
 		if (!entry || xa_is_value(entry))
-			return xas.xa_index;
-		if (xas.xa_index == 0 && index != 0)
-			return xas.xa_index;
+			break;
+		if (xas.xa_index == 0)
+			break;
 	}
 
-	/* No gaps in range and no wrap-around, return index beyond range */
-	return xas.xa_index + 1;
+	return xas.xa_index;
 }
 EXPORT_SYMBOL(page_cache_next_miss);
 
@@ -1799,9 +1796,7 @@ EXPORT_SYMBOL(page_cache_next_miss);
  *
  * Return: The index of the gap if found, otherwise an index outside the
  * range specified (in which case 'index - return >= max_scan' will be true).
- * In the rare case of wrap-around, ULONG_MAX will be returned.  ULONG_MAX
- * will also be returned if index == ULONG_MAX and there is a gap at the
- * index.  We can not wrap-around if passed index == ULONG_MAX.
+ * In the rare case of wrap-around, ULONG_MAX will be returned.
  */
 pgoff_t page_cache_prev_miss(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan)
@@ -1811,13 +1806,12 @@ pgoff_t page_cache_prev_miss(struct addr
 	while (max_scan--) {
 		void *entry = xas_prev(&xas);
 		if (!entry || xa_is_value(entry))
-			return xas.xa_index;
-		if (xas.xa_index == ULONG_MAX && index != ULONG_MAX)
-			return xas.xa_index;
+			break;
+		if (xas.xa_index == ULONG_MAX)
+			break;
 	}
 
-	/* No gaps in range and no wrap-around, return index beyond range */
-	return xas.xa_index - 1;
+	return xas.xa_index;
 }
 EXPORT_SYMBOL(page_cache_prev_miss);
 


