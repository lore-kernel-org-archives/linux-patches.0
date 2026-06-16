Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C5647A0A1;
	Tue, 16 Jun 2026 17:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629757; cv=none; b=sgirTSrGhPHIH4amhm7kag7/RrjI2N6d3BSZI5V3nt0lk9C+cxZCKbOPMVEgmPwm22IuVJHyw2XXYn3tn9K/t3TlkZLju2go0hUkJXeH7KwjxNmu+dwMM33Y/3Z8hB5ohQBlg0WEb9AZZgZssnlEyy6+AmycYw+JMlbFVon11mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629757; c=relaxed/simple;
	bh=kkuE/xUdTikCeJgzh/xcQHLqcxgKOC/zvFq0XziSE04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APeojr9hJWLA1nCyPphAMbVhsWoRdL5D1mIMqhdR7HckbFs8PaCJzz8FCsbwnq1MP/gEoaMdtGSpCqqnXXIQYB9XCMSNIeFzgoxGze7kdNApv0g9yv7mieJZSWoHgnkAxSlQHjvOqbFXmptOCK0t8Yo1KLMrF1kwNHMrLahKiz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uv6BqyBd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uv6BqyBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D421F000E9;
	Tue, 16 Jun 2026 17:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629756;
	bh=jZ2o9Jdvc5z3DMcIGtSQDuQQAy1Mq+H0zzqwnp+FpHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uv6BqyBdQYbBnehc5W5iveGdwSj57GK2x/0N0/nshbFD/yM83fCcfZoNgckBxdklh
	 ITf2DZlm8oXgdtcW1lBml0REjD0nrQe6duOxCULk8Ey0CGZeiDaniPyjvQc+V/I73M
	 BWLRt63ys1xLrr8fX8ylulZVYVDpJY0tE0K1L0xE=
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
Subject: [PATCH 6.6 347/452] mm/hugetlb: restore reservation on error in hugetlb folio copy paths
Date: Tue, 16 Jun 2026 20:29:34 +0530
Message-ID: <20260616145135.465001191@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5174,6 +5174,7 @@ again:
 							    addr, dst_vma);
 				folio_put(pte_folio);
 				if (ret) {
+					restore_reserve_on_error(h, dst_vma, addr, new_folio);
 					folio_put(new_folio);
 					break;
 				}
@@ -6383,6 +6384,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
+			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
 			folio_put(folio);
 			goto out;
 		}


