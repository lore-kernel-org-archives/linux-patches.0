Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD4B315785;
	Sat, 12 Sep 2026 13:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221116; cv=none; b=lq7HffH4Fj5TaPBwVQ5/lHqbIdi4Bai6VOd223MJXpHX1UGN4DR517JxRx+ZlgPHtT/97bzS+upBnOkQulG895mBGskOdEOc8OGL78Xfabq++V12zilnXP/TurEt1QQtK+RWc7Av1ZhnjZGMKvcInd9gECcGav/eNx8WauopdBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221116; c=relaxed/simple;
	bh=TVUqbsZcYXb/GTYsX73t76aDZNqp/4GtBwxi+nBrQ94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAN8TFqSKvgw9BY1sVosXskC0PW+kJOrenmbJySIwwEG8jq1UMkNZ/jLGIKPEuqAyu9BmFx3yAR9RnV0bxYQJqFuxgDrQ1I3WR8rIDBkXg9Vwth3DllLZFex7kfqSQ33Y5FBkSVcCRrlfba3tCnDe+Ro9bBmNBfRQiOtWqudIPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TozFehCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TozFehCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880F11F000FF;
	Sat, 12 Sep 2026 13:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221114;
	bh=vcGNHrw4BcHRJU0fUNiDHd23aFeq2JN9JdVR/Q3XUfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TozFehCGYH2Hvox+3wnxusSw9YGpo9FSByu3MLyHhf31jux/9gGtzUy4Q5mn17dMd
	 W+7JyIjEnS0uaNP1cqCsvdsHYz8YghmWApNFmD92QeN7sCb4Tbzcr5IBRBtKDrlgaA
	 xd1tcD6JJ4YFcUFx88Rrw+NTiI8Q/CjMRyLZ7oIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	William Kucharski <william.kucharski@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0300/1424] xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
Date: Sat, 12 Sep 2026 08:45:32 +0200
Message-ID: <20260912065614.005023756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Zi Yan <ziy@nvidia.com>

commit 789763523fb43cdc328de5cb5dcd19240ccf90d8 upstream.

XArray operations that allocate xa_nodes, such as xas_nomem() and
xas_alloc(), add __GFP_ACCOUNT when the array has XA_FLAGS_ACCOUNT set.
This charges the allocated memory and avoids the workingset convergence
issue described by commit 7b785645e8f13 ("mm: fix page cache convergence
regression").

xas_split_alloc() does not add _GFP_ACCOUNT when XA_FLAGS_ACCOUNT is
present.  Fix it.

Link: https://lore.kernel.org/20260804-add-gfp_account-to-xas_split_alloc-v3-2-38cb3ff325c5@nvidia.com
Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/xarray.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1012,6 +1012,9 @@ void xas_split_alloc(struct xa_state *xa
 	if (xas->xa_shift + XA_CHUNK_SHIFT > order)
 		return;
 
+	if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
+		gfp |= __GFP_ACCOUNT;
+
 	do {
 		unsigned int i;
 		void *sibling = NULL;


