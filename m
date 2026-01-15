Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1705F3BF309;
	Thu, 15 Jan 2026 17:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497198; cv=none; b=un7Gki9YdG91Kk9KuIgS5O3e5iFNZmZ5gWF0xcWlEL2GH8oq8UNBfXe+YjqXOznl8ejCcIas9SiReZ4rAkcZyHLWRsJcUcS38dxD81hge/4783Cyxoy34KHrx2NqadYad6BtQeZReKbvegk7Twd8ckaIh5B3+IhgZ9dQQxEq2ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497198; c=relaxed/simple;
	bh=RrLfK0K+6p7FEpMXYV5KqOZpgu9QQo+4mbP35aH+Qkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbIsHOUIR4NFtHv1hu62Jz8ewA6PE3BMnt6WWg7T/tIpiZo2hlcw2kV804e+IiA/6q6EhS1XttaAcyCz+RZMDzUhMMxjWu77cmKpxr5a75jt9LO99SqBcSoM5jJtRObLNFvfrq1bGkqdaFOnNkOEfXIKHa5+IZwYkfGMe5Sk8ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEZybczx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEZybczx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B35BC116D0;
	Thu, 15 Jan 2026 17:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497198;
	bh=RrLfK0K+6p7FEpMXYV5KqOZpgu9QQo+4mbP35aH+Qkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEZybczxyRGT6P156fjn8YQTiCNeWKQVLUn5M60iS2a2uFC3AccVHRoPG+DWJcGRo
	 Sp1zd8Qhir9pQP9u3Jrz/BBHrCRSiz5u/X5quQWCB62yqzulj3v7XxYW6UtcawZfSC
	 wNy5QeSANtyIdnrgpxQAgAmmMhMJxBUAUhebLuOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH 6.1 53/72] mm/pagewalk: add walk_page_range_vma()
Date: Thu, 15 Jan 2026 17:49:03 +0100
Message-ID: <20260115164145.415688005@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit e07cda5f232fac4de0925d8a4c92e51e41fa2f6e ]

Let's add walk_page_range_vma(), which is similar to walk_page_vma(),
however, is only interested in a subset of the VMA range.

To be used in KSM code to stop using follow_page() next.

Link: https://lkml.kernel.org/r/20221021101141.84170-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: f5548c318d6 ("ksm: use range-walk function to jump over holes in scan_get_next_rmap_item")
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pagewalk.h |    3 +++
 mm/pagewalk.c            |   20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -99,6 +99,9 @@ int walk_page_range_novma(struct mm_stru
 			  unsigned long end, const struct mm_walk_ops *ops,
 			  pgd_t *pgd,
 			  void *private);
+int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, const struct mm_walk_ops *ops,
+			void *private);
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		void *private);
 int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -517,6 +517,26 @@ int walk_page_range_novma(struct mm_stru
 	return walk_pgd_range(start, end, &walk);
 }
 
+int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, const struct mm_walk_ops *ops,
+			void *private)
+{
+	struct mm_walk walk = {
+		.ops		= ops,
+		.mm		= vma->vm_mm,
+		.vma		= vma,
+		.private	= private,
+	};
+
+	if (start >= end || !walk.mm)
+		return -EINVAL;
+	if (start < vma->vm_start || end > vma->vm_end)
+		return -EINVAL;
+
+	mmap_assert_locked(walk.mm);
+	return __walk_page_range(start, end, &walk);
+}
+
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		void *private)
 {


