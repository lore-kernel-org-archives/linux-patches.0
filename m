Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECD4413224;
	Wed,  4 Feb 2026 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216629; cv=none; b=MmRAY5iLSyauuqKPuKqxl1QoccBmohTYl4wcZB/W0IawVARWc+vwpwa8xAI9KQJr2GDg/KaB7YCBOs7jYdCRwWzxi09a5WQVKo3zXSyqXmuxsk0dy6It69qPK3SMf9pUE4isUSfOctClJVsPOEUxvmkOT2yheZA6vGRnN4OGefE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216629; c=relaxed/simple;
	bh=zw7GOsJ5EdVvusk8DGMnYif0MCBTX23LsviIuXUOg7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpoMYHuRbSp0gQfjfyrwt1rHBmxcxTtUpvxeAqGfwiFgZtE1yxlCshUsZvTcxVY0ej3aToo3xBHeixtZnX4Vng2p203wDztMxab51eAfDR1eb4MLQubvCnq1Jl0AeZ2qfRmAbSaJ9QVP/i45iU0IH5i5SgITmSenlbynfSNliF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMgIIJw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMgIIJw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E873AC4CEF7;
	Wed,  4 Feb 2026 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216629;
	bh=zw7GOsJ5EdVvusk8DGMnYif0MCBTX23LsviIuXUOg7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMgIIJw5z1gzbZK0QrkkhrWhEZwbNWfGPMa2KxZM0QBzshJutdbzGBsq3HBrykvSn
	 EDmKgX2bN1krASdpGhEWnNHlQFTrrkxGb0mGMPPZToZB2qCSLFGphOIgrK6bNNW5FC
	 TB8kfGGrShWAjmHtCdhSi/RSoGPmMCSIdkDNyp3Q=
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
Subject: [PATCH 5.10 146/161] mm/pagewalk: add walk_page_range_vma()
Date: Wed,  4 Feb 2026 15:40:09 +0100
Message-ID: <20260204143857.001106418@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -461,6 +461,26 @@ int walk_page_range_novma(struct mm_stru
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


