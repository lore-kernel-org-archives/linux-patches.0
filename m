Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBAB44E045;
	Tue, 16 Jun 2026 16:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626226; cv=none; b=Bj6dctw9jqx8Dpirn0m/IQy/o0mM+JUkOdd16v8PzkSa/nTLYTQ+8lRwModqJXJjKRt3LFEDwsEVK4oBR4YE7LFViOmeezsq2RM8BsClOOc5eG/NmrPXpyMG93hC9jNrNq6C5dxCc//lVRMAxhHJnL2Mbq0u1VEJo0Y3oM44n/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626226; c=relaxed/simple;
	bh=+22ka7+TPN49jP4XD7yCcTIFJzL7YXStf9RcM1A6YF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2yVr6s4w8KmrUwLAOZ+HdWnFKVCkX3VR3UJaklkWyP5FXaxstrYpmN5xIdUbQI8EM/vUm/0nd8bE8kmOjmdzuimAn3zOqJ28KGiaAhqKPs5ZrfymuLo3PAxiePIJy2vvvCqt3ZDkQe6xDRvWvng821v5HxTwF0gEH930ija+oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6YfGf2t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6YfGf2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C5A1F000E9;
	Tue, 16 Jun 2026 16:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626224;
	bh=Ml1fut3ArSi1XG6ncicnBMfVTlwBYq5N9LRQ+17643M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6YfGf2tm/UT3BX/u80zdChAujRx3UcZsIsSTK8V4JOscBKZNwzCZvt4VEuSDr5bq
	 VfiIBdbQlNSNfsq4BHdrfqNchSIalowPtblMul2aoKTh5b7g0WQy6hnomwsgc/NIEW
	 9c29jGEqtuIjV7cHx508EXtiJbRx4JgU5Qw+F2gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	yuehaibing <yuehaibing@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 254/325] mm/hugetlb: restore reservation on error in hugetlb folio copy paths
Date: Tue, 16 Jun 2026 20:30:50 +0530
Message-ID: <20260616145111.210711054@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 40c81856e622a9dc59294a90d169ac07ea25b0b0 upstream.

Two sites in mm/hugetlb.c allocate a hugetlb folio via
alloc_hugetlb_folio() (consuming a VMA reservation) and then call
copy_user_large_folio(), which became int-returning in commit 1cb9dc4b475c
("mm: hwpoison: support recovery from HugePage copy-on-write faults") and
can now fail (e.g.  -EHWPOISON on a hwpoisoned source page).  On the
failure path, folio_put() restores the global hugetlb pool count through
free_huge_folio(), but the per-VMA reservation map entry is left marked
consumed:

  - hugetlb_mfill_atomic_pte() resubmission path (UFFDIO_COPY)
  - copy_hugetlb_page_range() fork-time CoW path when
    hugetlb_try_dup_anon_rmap() fails (rare: pinned hugetlb anon
    folio under fork)

User-visible effect: on UFFDIO_COPY into a private hugetlb VMA where the
resubmission copy fails, the reservation for that address is leaked from
the VMA's reserve map.  A subsequent fault at the same address takes the
no-reservation path, and under hugetlb pool pressure the task is SIGBUSed
at an address it had previously reserved.  The fork-time CoW path leaks
the same way in the child VMA's reserve map, though it requires the much
rarer combination of pinned hugetlb anon page + hwpoisoned source.

Add the missing restore_reserve_on_error() call before folio_put() on both
error paths.

Link: https://lore.kernel.org/20260520044912.6751-1-devnexen@gmail.com
Fixes: 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage copy-on-write faults")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: yuehaibing <yuehaibing@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5696,6 +5696,7 @@ again:
 							    addr, dst_vma);
 				folio_put(pte_folio);
 				if (ret) {
+					restore_reserve_on_error(h, dst_vma, addr, new_folio);
 					folio_put(new_folio);
 					break;
 				}
@@ -6987,6 +6988,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
+			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
 			folio_put(folio);
 			goto out;
 		}


