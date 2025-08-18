Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC2D320CA0;
	Mon, 18 Aug 2025 13:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524370; cv=none; b=YEg0BrEFaoDPybH7PT8R5mzxlq6lpg/qAcG3AA5A0JRbprEmYjGc6lDmEoW+jMB6afHSLsF5cyGu6OSF69axednK65Eh5r2m9KKIaegkuH4+2XLmVlR2iKvUMLoJR7uHd+bDMATOMitxgCNhLOs+f1gOmZjrNJC/zh7x8EIkdbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524370; c=relaxed/simple;
	bh=DuMIwXnhghcZ1sYS4rLV5KGx4H3Hqq4vmLYMyxbugls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpNQ9c8JtiOtZv+6n10hhzxTcI7OnYaQuIinU1BAyK6oGmyQ6vnCBovvSsBX/fqUm1t4HNBynkWK2Ia8wqC/H6Q6nss4SpBr+EAYQbN/wdBpbc2I+8KOKZkO6FVNhGH5m0N6e6GA5n9F5wmSqhuPzrmb7qR0B8BmgHPxWPDTV44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txrGlX2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txrGlX2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D91EC4CEEB;
	Mon, 18 Aug 2025 13:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524370;
	bh=DuMIwXnhghcZ1sYS4rLV5KGx4H3Hqq4vmLYMyxbugls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txrGlX2IW98dksZ8bXY0sjTR5493f3VOeURvqzkMhNmjGv+56smpNr86pckFdrRLw
	 /3XLpiQC51UAMlP/ZpH1BGzFVfy5oGcUUFKnRRJueGBaWy1gzg6l+p8mALsJDxri31
	 tG3dJBaNNvYANlq1bME+oj5uFVw6BHf/UQI6LpdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c2f65e2801743ca64e08@syzkaller.appspotmail.com,
	Yi Liu <yi.l.liu@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.15 451/515] iommufd: Prevent ALIGN() overflow
Date: Mon, 18 Aug 2025 14:47:17 +0200
Message-ID: <20250818124515.780138745@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit b42497e3c0e74db061eafad41c0cd7243c46436b upstream.

When allocating IOVA the candidate range gets aligned to the target
alignment. If the range is close to ULONG_MAX then the ALIGN() can
wrap resulting in a corrupted iova.

Open code the ALIGN() using get_add_overflow() to prevent this.
This simplifies the checks as we don't need to check for length earlier
either.

Consolidate the two copies of this code under a single helper.

This bug would allow userspace to create a mapping that overlaps with some
other mapping or a reserved range.

Cc: stable@vger.kernel.org
Fixes: 51fe6141f0f6 ("iommufd: Data structure to provide IOVA to PFN mapping")
Reported-by: syzbot+c2f65e2801743ca64e08@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/685af644.a00a0220.2e5631.0094.GAE@google.com
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Link: https://patch.msgid.link/all/1-v1-7b4a16fc390b+10f4-iommufd_alloc_overflow_jgg@nvidia.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/io_pagetable.c |   41 +++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 16 deletions(-)

--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -70,36 +70,45 @@ struct iopt_area *iopt_area_contig_next(
 	return iter->area;
 }
 
-static bool __alloc_iova_check_hole(struct interval_tree_double_span_iter *span,
-				    unsigned long length,
-				    unsigned long iova_alignment,
-				    unsigned long page_offset)
+static bool __alloc_iova_check_range(unsigned long *start, unsigned long last,
+				     unsigned long length,
+				     unsigned long iova_alignment,
+				     unsigned long page_offset)
 {
-	if (span->is_used || span->last_hole - span->start_hole < length - 1)
+	unsigned long aligned_start;
+
+	/* ALIGN_UP() */
+	if (check_add_overflow(*start, iova_alignment - 1, &aligned_start))
 		return false;
+	aligned_start &= ~(iova_alignment - 1);
+	aligned_start |= page_offset;
 
-	span->start_hole = ALIGN(span->start_hole, iova_alignment) |
-			   page_offset;
-	if (span->start_hole > span->last_hole ||
-	    span->last_hole - span->start_hole < length - 1)
+	if (aligned_start >= last || last - aligned_start < length - 1)
 		return false;
+	*start = aligned_start;
 	return true;
 }
 
-static bool __alloc_iova_check_used(struct interval_tree_span_iter *span,
+static bool __alloc_iova_check_hole(struct interval_tree_double_span_iter *span,
 				    unsigned long length,
 				    unsigned long iova_alignment,
 				    unsigned long page_offset)
 {
-	if (span->is_hole || span->last_used - span->start_used < length - 1)
+	if (span->is_used)
 		return false;
+	return __alloc_iova_check_range(&span->start_hole, span->last_hole,
+					length, iova_alignment, page_offset);
+}
 
-	span->start_used = ALIGN(span->start_used, iova_alignment) |
-			   page_offset;
-	if (span->start_used > span->last_used ||
-	    span->last_used - span->start_used < length - 1)
+static bool __alloc_iova_check_used(struct interval_tree_span_iter *span,
+				    unsigned long length,
+				    unsigned long iova_alignment,
+				    unsigned long page_offset)
+{
+	if (span->is_hole)
 		return false;
-	return true;
+	return __alloc_iova_check_range(&span->start_used, span->last_used,
+					length, iova_alignment, page_offset);
 }
 
 /*


