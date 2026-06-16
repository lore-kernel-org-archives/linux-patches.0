Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0B644CF52;
	Tue, 16 Jun 2026 15:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624444; cv=none; b=K6Z9xEBX9Hl8hoq3dnvZOFUF0t+BS3Tm55ysI5uaUCFKFde+psIk2ChSS5j8MlRXUSwhyQv8ip3pRElKunUcQJ9nFNDBBgG+7DgqeEzmk565YfqyPEnfY3pgUqL3XBT1b+7ZfjbsAlfB0kvnj/G2ua3NPLfyXXEMUIDV7M8cfro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624444; c=relaxed/simple;
	bh=De92+8TcrcaEkvxv2GyesLIvnx3BP1sM5QZw910CiTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhcpYDrvpVNPD2ymY3QmliPusKbfmeVzW48rQTgeky+JcIBZgYwDJHmmFobD2DZpecKsBlOg4r++V+B0bUEUD47q3T6D4g4DClc0Nzh3oEe3VSSisxntVRSzJc8FlMuVWWNUMAEu2rW2j26kNWhxGJLuEXAsmjxtOkGX42tfxi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDC14v5b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDC14v5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185B41F000E9;
	Tue, 16 Jun 2026 15:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624443;
	bh=rqa8hurC/LdTTkg7yeoHqh7QdAVjm+YLm2yfF8ZMR74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pDC14v5bRxJmfzrCL0yYsxiffFSUCkWdboZg/JBwIHU+b4f9pc8VROhwVqUQ9tDt8
	 Xe7J91YOcrSe8xXiGf/3bGVTi0tI985NlqUGyVCD50FijwZNt9BIpUhLgDw106uVsD
	 KHtxL814WVOs8wQA62eja1CFCYfu3llZckKpFdp0=
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
Subject: [PATCH 7.0 304/378] mm/hugetlb: restore reservation on error in hugetlb folio copy paths
Date: Tue, 16 Jun 2026 20:28:55 +0530
Message-ID: <20260616145126.156282487@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4996,6 +4996,7 @@ again:
 							    addr, dst_vma);
 				folio_put(pte_folio);
 				if (ret) {
+					restore_reserve_on_error(h, dst_vma, addr, new_folio);
 					folio_put(new_folio);
 					break;
 				}
@@ -6292,6 +6293,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
+			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
 			folio_put(folio);
 			goto out;
 		}


