Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F5F1465A8;
	Tue, 25 Jun 2024 09:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308739; cv=none; b=aKlCIBKx4b2y6OwElKiqYHbhAWpVN0yl0hj646ovgWcFhPT9DPbQVn0YPCcTrxq4BWp+XynxpbROysqm8qfMejh9VaNoZuHWF9zQZMtK7n54MLE+D+G4Ne4sXgsqaFjMfFanc9Au0qjsnLtK/p4Dwlc4+TEohtW9bqUUegUFd7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308739; c=relaxed/simple;
	bh=KFcSb8A9AHHdLO1S5owDiLm6lPJZzD3rIuTi15E2f5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwwriqHDF73IGJWYRJKCkj7WboH49dCRB3sfYs/DDmx+daQwoT5ikevnkw+sZEzQC9D6qKb1ZkEzrcForUaieW3osgv+FQJyGr3soMAbCLZ7pO07T3n+g4GiNBt1RnS5h1Qy05t+W0M7Psk0P9j5ZhaqGFEdfOFGxhiQe8f8gto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiWKuurH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiWKuurH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F083AC32781;
	Tue, 25 Jun 2024 09:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308739;
	bh=KFcSb8A9AHHdLO1S5owDiLm6lPJZzD3rIuTi15E2f5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiWKuurHWznYD5x6RJNfv83KeAgIufVwolq6qInFVs2c6f5BAwfgu0VKoBoia6SPe
	 tjNb2eHbVQhUi5aClC3l0L9I2fwCrdUY74brQaEv67AyaQbHv16KtLLqiynf/HXFRR
	 49wB2fcCiXBNcqWfDyW2+ooIQMLlIN63QnXhh1cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <baohua@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Michal Hocko <mhocko@kernel.org>,
	xu xin <xu.xin16@zte.com.cn>,
	Yang Yang <yang.yang29@zte.com.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 223/250] mm: huge_memory: fix misused mapping_large_folio_support() for anon folios
Date: Tue, 25 Jun 2024 11:33:01 +0200
Message-ID: <20240625085556.612897317@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

commit 6a50c9b512f7734bc356f4bd47885a6f7c98491a upstream.

When I did a large folios split test, a WARNING "[ 5059.122759][ T166]
Cannot split file folio to non-0 order" was triggered.  But the test cases
are only for anonmous folios.  while mapping_large_folio_support() is only
reasonable for page cache folios.

In split_huge_page_to_list_to_order(), the folio passed to
mapping_large_folio_support() maybe anonmous folio.  The folio_test_anon()
check is missing.  So the split of the anonmous THP is failed.  This is
also the same for shmem_mapping().  We'd better add a check for both.  But
the shmem_mapping() in __split_huge_page() is not involved, as for
anonmous folios, the end parameter is set to -1, so (head[i].index >= end)
is always false.  shmem_mapping() is not called.

Also add a VM_WARN_ON_ONCE() in mapping_large_folio_support() for anon
mapping, So we can detect the wrong use more easily.

THP folios maybe exist in the pagecache even the file system doesn't
support large folio, it is because when CONFIG_TRANSPARENT_HUGEPAGE is
enabled, khugepaged will try to collapse read-only file-backed pages to
THP.  But the mapping does not actually support multi order large folios
properly.

Using /sys/kernel/debug/split_huge_pages to verify this, with this patch,
large anon THP is successfully split and the warning is ceased.

Link: https://lkml.kernel.org/r/202406071740485174hcFl7jRxncsHDtI-Pz-o@zte.com.cn
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pagemap.h |    4 ++++
 mm/huge_memory.c        |   28 +++++++++++++++++-----------
 2 files changed, 21 insertions(+), 11 deletions(-)

--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -379,6 +379,10 @@ static inline void mapping_set_large_fol
  */
 static inline bool mapping_large_folio_support(struct address_space *mapping)
 {
+	/* AS_LARGE_FOLIO_SUPPORT is only reasonable for pagecache folios */
+	VM_WARN_ONCE((unsigned long)mapping & PAGE_MAPPING_ANON,
+			"Anonymous mapping always supports large folio");
+
 	return IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 		test_bit(AS_LARGE_FOLIO_SUPPORT, &mapping->flags);
 }
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3058,30 +3058,36 @@ int split_huge_page_to_list_to_order(str
 	if (new_order >= folio_order(folio))
 		return -EINVAL;
 
-	/* Cannot split anonymous THP to order-1 */
-	if (new_order == 1 && folio_test_anon(folio)) {
-		VM_WARN_ONCE(1, "Cannot split to order-1 folio");
-		return -EINVAL;
-	}
-
-	if (new_order) {
-		/* Only swapping a whole PMD-mapped folio is supported */
-		if (folio_test_swapcache(folio))
+	if (folio_test_anon(folio)) {
+		/* order-1 is not supported for anonymous THP. */
+		if (new_order == 1) {
+			VM_WARN_ONCE(1, "Cannot split to order-1 folio");
 			return -EINVAL;
+		}
+	} else if (new_order) {
 		/* Split shmem folio to non-zero order not supported */
 		if (shmem_mapping(folio->mapping)) {
 			VM_WARN_ONCE(1,
 				"Cannot split shmem folio to non-0 order");
 			return -EINVAL;
 		}
-		/* No split if the file system does not support large folio */
-		if (!mapping_large_folio_support(folio->mapping)) {
+		/*
+		 * No split if the file system does not support large folio.
+		 * Note that we might still have THPs in such mappings due to
+		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
+		 * does not actually support large folios properly.
+		 */
+		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
+		    !mapping_large_folio_support(folio->mapping)) {
 			VM_WARN_ONCE(1,
 				"Cannot split file folio to non-0 order");
 			return -EINVAL;
 		}
 	}
 
+	/* Only swapping a whole PMD-mapped folio is supported */
+	if (folio_test_swapcache(folio) && new_order)
+		return -EINVAL;
 
 	is_hzp = is_huge_zero_page(&folio->page);
 	if (is_hzp) {


