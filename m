Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF812459DC;
	Tue, 17 Mar 2026 17:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768015; cv=none; b=swQG1PmshsTcOvjLurOaHyODQeFoz9PaVn9kMkh7NVRwng+Tw3QcEhyyKVqrb67ADUFeSr1gXZX5+Qx2CvyMb6ALhAJZOSfYkngL85e2mAefSa73lncsG7riO43jLmLy6IufpV1BVLQPcXxzwKAqyKq2WHrVMtJTfLq9FWzhVaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768015; c=relaxed/simple;
	bh=9wsOM5YZP6I/p/RoCaOSsSlVZwbDv9kcDA5iiw8lY8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGox9k4t/rAGKEQXXZ+N5vlPlJFRIjkzqmdd2iWstUAkaf4dB6nO/VvxyPJI66xtyEo2mUyGG1jFdkRWWWH7nEkfBmimbnMpcxi7/nj5W2tIV/zeShdXKQI0I4gNIj4uZkyvHpR+e6djHfzRnZMQLKyTSwHOUsXuQAyC6yVd8H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXXd/yOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXXd/yOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BE2C4CEF7;
	Tue, 17 Mar 2026 17:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768015;
	bh=9wsOM5YZP6I/p/RoCaOSsSlVZwbDv9kcDA5iiw8lY8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXXd/yOeB9+lP+04haCzDFE6ZT5k2nd78M1ZiXeHp9ZXYMFzj7Q33cVQgqAjDtfwi
	 qMAfg1TGV/moKQ/KDm92iVJxdc21+8k7HTJGjYTvyHpc1XnBuMMzMRhl64eesse5L5
	 EHkF1ouRqJ2T9KoW8evVp2GPHtsYkx4d4WwAlXik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Rasmussen <axelrasmussen@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 180/333] Revert "ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()"
Date: Tue, 17 Mar 2026 17:33:29 +0100
Message-ID: <20260317163006.030793941@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Axel Rasmussen <axelrasmussen@google.com>

commit 2d28ed588f8d7d0d41b0a4fad7f0d05e4bbf1797 upstream.

This change swapped out mod_node_page_state for lruvec_stat_add_folio.
But, these two APIs are not interchangeable: the lruvec version also
increments memcg stats, in addition to "global" pgdat stats.

So after this change, the "pagetables" memcg stat in memory.stat always
yields "0", which is a userspace visible regression.

I tried to look for a refactor where we add a variant of
lruvec_stat_mod_folio which takes a pgdat and a memcg instead of a folio,
to try to adhere to the spirit of the original patch.  But at the end of
the day this just means we have to call folio_memcg(ptdesc_folio(ptdesc))
anyway, which doesn't really accomplish much.

This regression is visible in master as well as 6.18 stable, so CC stable
too.

Link: https://lkml.kernel.org/r/20260225002434.2953895-1-axelrasmussen@google.com
Fixes: f0c92726e89f ("ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()")
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3138,26 +3138,21 @@ static inline bool ptlock_init(struct pt
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
-static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
-{
-	return compound_nr(ptdesc_page(ptdesc));
-}
-
 static inline void __pagetable_ctor(struct ptdesc *ptdesc)
 {
-	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
+	struct folio *folio = ptdesc_folio(ptdesc);
 
-	__SetPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
+	__folio_set_pgtable(folio);
+	lruvec_stat_add_folio(folio, NR_PAGETABLE);
 }
 
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
-	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
+	struct folio *folio = ptdesc_folio(ptdesc);
 
 	ptlock_free(ptdesc);
-	__ClearPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
+	__folio_clear_pgtable(folio);
+	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)


