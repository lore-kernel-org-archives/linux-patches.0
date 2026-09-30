Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E059D52ED21;
	Wed, 30 Sep 2026 17:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790595; cv=none; b=nPlB26UOMFM0ZSX2MvxYRGXmIOy0AC9pFz8CuiTL4dy7qdLm7/ZChBBPn5QwabiuRz0q9sJF2FCPD1k6BKSK104eTzKELWR1nljp8CflukgBcM4fd/TEEGSMGlp2YXTJxkqIxLHxnCAB4ntoPt7HxcXGNKpUyF7VB1gjfHErQIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790595; c=relaxed/simple;
	bh=XkMlMF+LJ/uYGUZrc1M172Fof8v2HzdluntJClAG+kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPw/2gQp8pv7IE46rZJZXs5C1wz7vaumu6Pkqn02N4sysKy1yBvP4GwwboCsJhocMDOQBD7oOTzRw+Wj285vsKs249r8FZRKDpVro+RYoxlGiNtsxURgBVR492/GLCCyUVDbLhbBvc2XpAtaYeFMZ/6Rwq9FRz50LHJb6GrWsk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHSk8VbU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHSk8VbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1211F000FF;
	Wed, 30 Sep 2026 17:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790593;
	bh=/S0rBlHAbnCUiZJIc4AnPh3QeaXekzDJtaR1j8RwBeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YHSk8VbURAa6RYDyxhKptfAoFBRP0Hvmki2MG85JGFkM1YsfwbrtuwzUlZxel85yw
	 wg1H5OBU0ovZan7ZRadhPJwkf99v7PaPqUbr17ovQXViuq7B8Smr4kMeoRl1LaZo6L
	 aSPGb5PMeBCXavj9yK3q5eq8UkqfHmX1udxQ+mos=
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
Subject: [PATCH 6.12 877/877] mm/hugetlb: keep max_huge_pages when dissolving surplus folios
Date: Wed, 30 Sep 2026 17:29:48 +0200
Message-ID: <20260930152433.658484329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -2248,7 +2248,8 @@ retry:
 		if (h->surplus_huge_pages_node[folio_nid(folio)])
 			adjust_surplus = true;
 		remove_hugetlb_folio(h, folio, adjust_surplus);
-		h->max_huge_pages--;
+		if (!adjust_surplus)
+			h->max_huge_pages--;
 		spin_unlock_irq(&hugetlb_lock);
 
 		/*
@@ -2268,7 +2269,8 @@ retry:
 			if (rc) {
 				spin_lock_irq(&hugetlb_lock);
 				add_hugetlb_folio(h, folio, adjust_surplus);
-				h->max_huge_pages++;
+				if (!adjust_surplus)
+					h->max_huge_pages++;
 				goto out;
 			}
 		} else


