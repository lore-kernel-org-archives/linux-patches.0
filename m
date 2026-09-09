Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0476C54A7E7;
	Wed,  9 Sep 2026 14:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963724; cv=none; b=q8xeTH6Ex19G7Lm/g8r+3jZmv4VgODMk6ecyw8el+Fyi6cZrruvXtjQ2wRoEK5xMxspTdEO23YUJZDGVjyT829zWHeNowAjze3Vt4sHfa8gMh/9REbHNeEJnDxb12K3IizO8WMKfIT3I/fts/Je6IjGLEBnmMkCAfpCiMGucQtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963724; c=relaxed/simple;
	bh=sruFRJCcqepWF/lGumkvfWpRkN8GMsxobEw0ziSqCiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJIoGZ/HzJ2o1rzAbRVUZ6gx11luGJ3TCNfu94Pm8gFo+LuTG+AS/64O4iaB040gx6mKsAZivvwrGnLizMBJgef43zka8dKEbWzw5KWqsuR9VqKVQStcCHDEu8zRNrsnUf3pW6tLcOzvi+NQANTRThhRudONeZ6ZIxP0AnJjMiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z30S/URE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z30S/URE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A921F00A3A;
	Wed,  9 Sep 2026 14:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963722;
	bh=mp7ncXdU+G/Tci5wo0sHWWgDW8Yujwfy7fCKt0USaxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z30S/URE7M9GATtrEFnXdetJe7xkqpoghxSQNp0oReE8WCgWgh3M8yYWOD8ZXo1XZ
	 0A/XAnhokNoBw+ql6rnkg9llohhw/D0OTyQ3NVOsuT1Nyw5A6lAzYstW2mOs66dDDq
	 l2zetV/4qrAaXWxIhRf6sW1VXPIVEd2Co1I47ISg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 116/583] mm/hugetlb: keep max_huge_pages when dissolving surplus folios
Date: Wed,  9 Sep 2026 15:36:41 +0200
Message-ID: <20260909134242.147044900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Longlong Xia <xialonglong@kylinos.cn>

commit 267bede12d3b108ca29997ce280e927a570ec97f upstream.

dissolve_free_hugetlb_folio() can remove a free folio as surplus when its
node has surplus pages.  In that case remove_hugetlb_folio() decrements
both nr_huge_pages and surplus_huge_pages, leaving the persistent pool
size unchanged.

Updating max_huge_pages as if a persistent folio had been removed can
therefore corrupt the persistent pool target and underflow it when
max_huge_pages is zero.  Keep max_huge_pages unchanged for surplus folios,
including the vmemmap restoration rollback path.

Link: https://lore.kernel.org/20260814083027.1419487-1-xialonglong2025@163.com
Fixes: cb402bbdabca ("mm/hugetlb: fix surplus pages in dissolve_free_huge_page()")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Longlong Xia <xialonglong@kylinos.cn>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2140,7 +2140,8 @@ retry:
 		if (h->surplus_huge_pages_node[folio_nid(folio)])
 			adjust_surplus = true;
 		remove_hugetlb_folio(h, folio, adjust_surplus);
-		h->max_huge_pages--;
+		if (!adjust_surplus)
+			h->max_huge_pages--;
 		spin_unlock_irq(&hugetlb_lock);
 
 		/*
@@ -2160,7 +2161,8 @@ retry:
 			if (rc) {
 				spin_lock_irq(&hugetlb_lock);
 				add_hugetlb_folio(h, folio, adjust_surplus);
-				h->max_huge_pages++;
+				if (!adjust_surplus)
+					h->max_huge_pages++;
 				goto out;
 			}
 		} else


