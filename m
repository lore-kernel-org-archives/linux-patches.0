Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C70146A62;
	Thu, 13 Jun 2024 11:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279584; cv=none; b=SlqCMgbFO3bkL48MpAHnL+eEvhiMljK5fwCxZ+l6GbPeq+FYvfvOjfbXZWQpu+PoIZEGiDMYEmg1bZABJqP3vq+reR3kBPRqgjRnjx/t/9IHTNkUxXsD9O16arQQklPmL/M6kW0ONEMz0LFkzSL4IJ3KF45cKGhQrVFhduUf2iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279584; c=relaxed/simple;
	bh=ISQFPfGzY9OYrryy2+O2NgqELlBZCTrmatc3Lmrm5qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlFCaPEbI4NAUpaN1D4OisUEN6NEVU1gFWW69UJU8QzCvHTjdB2muC9/KCS2VP6/TXzBIcNeiX6JxumOb9u/SL8S3a7ri+ddr0Egaxg3acX9LGKcs4Xd5TK1D54nnthkG2U7A2gdRx2LgEzTihimclWBmQN3AwMjymRwdaZ+Rs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShAJcNVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShAJcNVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF446C2BBFC;
	Thu, 13 Jun 2024 11:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279584;
	bh=ISQFPfGzY9OYrryy2+O2NgqELlBZCTrmatc3Lmrm5qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShAJcNVENRdlgNVLLbmym4g/j2xXlgzJ2tT0jxljYhXutuvo6Wig8GcJqDw/d6pDY
	 9azLFmRpLlcq7Li7AfIzu2MOCjizsRQ8FDVBA/5jTGCKI/JE1m0SJlingR0RsfcGXR
	 wVSHcYsf1HTiAbmXUk7+Ro6d/hrj+3ozLIkAsch0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Salvador <osalvador@suse.de>,
	Breno Leitao <leitao@debian.org>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+d3fe2dc5ffe9380b714b@syzkaller.appspotmail.com
Subject: [PATCH 6.9 095/157] mm/hugetlb: do not call vma_add_reservation upon ENOMEM
Date: Thu, 13 Jun 2024 13:33:40 +0200
Message-ID: <20240613113231.100259173@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

From: Oscar Salvador <osalvador@suse.de>

commit 8daf9c702ee7f825f0de8600abff764acfedea13 upstream.

sysbot reported a splat [1] on __unmap_hugepage_range().  This is because
vma_needs_reservation() can return -ENOMEM if
allocate_file_region_entries() fails to allocate the file_region struct
for the reservation.

Check for that and do not call vma_add_reservation() if that is the case,
otherwise region_abort() and region_del() will see that we do not have any
file_regions.

If we detect that vma_needs_reservation() returned -ENOMEM, we clear the
hugetlb_restore_reserve flag as if this reservation was still consumed, so
free_huge_folio() will not increment the resv count.

[1] https://lore.kernel.org/linux-mm/0000000000004096100617c58d54@google.com/T/#ma5983bc1ab18a54910da83416b3f89f3c7ee43aa

Link: https://lkml.kernel.org/r/20240528205323.20439-1-osalvador@suse.de
Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-and-tested-by: syzbot+d3fe2dc5ffe9380b714b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/0000000000004096100617c58d54@google.com/
Cc: Breno Leitao <leitao@debian.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5774,8 +5774,20 @@ void __unmap_hugepage_range(struct mmu_g
 		 * do_exit() will not see it, and will keep the reservation
 		 * forever.
 		 */
-		if (adjust_reservation && vma_needs_reservation(h, vma, address))
-			vma_add_reservation(h, vma, address);
+		if (adjust_reservation) {
+			int rc = vma_needs_reservation(h, vma, address);
+
+			if (rc < 0)
+				/* Pressumably allocate_file_region_entries failed
+				 * to allocate a file_region struct. Clear
+				 * hugetlb_restore_reserve so that global reserve
+				 * count will not be incremented by free_huge_folio.
+				 * Act as if we consumed the reservation.
+				 */
+				folio_clear_hugetlb_restore_reserve(page_folio(page));
+			else if (rc)
+				vma_add_reservation(h, vma, address);
+		}
 
 		tlb_remove_page_size(tlb, page, huge_page_size(h));
 		/*


