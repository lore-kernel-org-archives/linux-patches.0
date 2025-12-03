Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24749368287;
	Wed,  3 Dec 2025 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780763; cv=none; b=RNnXfYecUIHg7fsRb9g1didi3rRRSnD1G95FXEg/Sxgo5ic/mmKfw/nb8tEjwh3zlBsth+Z5sBxBgPTAh5YzCiUUGYyw+XDHsE3SELdupUU7qgSceb5FtIsxGxb9O9gddZ6K9zIQO+uL5om42NcppNtSVz6T7iOOdQTcmiTMYtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780763; c=relaxed/simple;
	bh=sZM6BBW01MED9VPcrT5uDa2sL12YSOHQj8iYvVut6ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaOUHEc12bN0f0v/vKlqD4JCYpGfeWt4aJuaGN8nmJGp7Of3T3oB1O0Kz8yVrYxiBXWIBCNFUSISx/A6JFfC7Hb2i7HREbLUXbeDUti/FX/qTgFfT2d2ayR42AenIfBMZTrNnhz3RJlPxai6fgn3dF09nYCACMd9jRxNudDlv8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ke3ryLQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ke3ryLQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F87EC4CEF5;
	Wed,  3 Dec 2025 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780762;
	bh=sZM6BBW01MED9VPcrT5uDa2sL12YSOHQj8iYvVut6ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ke3ryLQpOIw+yUhqUPjjEMim4I3570Ewejvc050ifnPMXo0Imhl/zf6nR5P1g8ZPB
	 84wAu4Wbl9L/g3fjFWGf8NtMCqYHHi37L/qgt4I/MXfMhFXddt+FFZozE0EspUTAq+
	 Dfo79ll7JSqG6qsAdk9q7j54H94w/KfOgpbnlr5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Dave Airlie <airlied@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 082/132] mm/memfd: fix information leak in hugetlb folios
Date: Wed,  3 Dec 2025 16:29:21 +0100
Message-ID: <20251203152346.331538323@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit de8798965fd0d9a6c47fc2ac57767ec32de12b49 upstream.

When allocating hugetlb folios for memfd, three initialization steps are
missing:

1. Folios are not zeroed, leading to kernel memory disclosure to userspace
2. Folios are not marked uptodate before adding to page cache
3. hugetlb_fault_mutex is not taken before hugetlb_add_to_page_cache()

The memfd allocation path bypasses the normal page fault handler
(hugetlb_no_page) which would handle all of these initialization steps.
This is problematic especially for udmabuf use cases where folios are
pinned and directly accessed by userspace via DMA.

Fix by matching the initialization pattern used in hugetlb_no_page():
- Zero the folio using folio_zero_user() which is optimized for huge pages
- Mark it uptodate with folio_mark_uptodate()
- Take hugetlb_fault_mutex before adding to page cache to prevent races

The folio_zero_user() change also fixes a potential security issue where
uninitialized kernel memory could be disclosed to userspace through read()
or mmap() operations on the memfd.

Link: https://lkml.kernel.org/r/20251112145034.2320452-1-kartikey406@gmail.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20251112031631.2315651-1-kartikey406@gmail.com/ [v1]
Closes: https://syzkaller.appspot.com/bug?extid=f64019ba229e3a5c411b
Suggested-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com> (v2)
Cc: Christoph Hellwig <hch@lst.de> (v6)
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memfd.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -90,9 +90,36 @@ struct folio *memfd_alloc_folio(struct f
 						    NULL,
 						    gfp_mask);
 		if (folio) {
+			u32 hash;
+
+			/*
+			 * Zero the folio to prevent information leaks to userspace.
+			 * Use folio_zero_user() which is optimized for huge/gigantic
+			 * pages. Pass 0 as addr_hint since this is not a faulting path
+			 *  and we don't have a user virtual address yet.
+			 */
+			folio_zero_user(folio, 0);
+
+			/*
+			 * Mark the folio uptodate before adding to page cache,
+			 * as required by filemap.c and other hugetlb paths.
+			 */
+			__folio_mark_uptodate(folio);
+
+			/*
+			 * Serialize hugepage allocation and instantiation to prevent
+			 * races with concurrent allocations, as required by all other
+			 * callers of hugetlb_add_to_page_cache().
+			 */
+			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
+
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+
 			if (err) {
 				folio_put(folio);
 				return ERR_PTR(err);


