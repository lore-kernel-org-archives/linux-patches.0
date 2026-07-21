Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EB92417D9;
	Tue, 21 Jul 2026 18:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659244; cv=none; b=lzrGt2D8KQxdD3ImGU4SCjveUOOBTOcBjcpuVn7w833oWqSM4wUO8ek8Fd0ZkO3/iMtiokH4PlprKgPOIRhKXTZM+Qtxw2RZq4CvabsR4lkdylri7Bw2pj6OGJTR0fiPyWX06aPRzT4HlacXuYOEDebO4UHL9xohiekn+aL7YNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659244; c=relaxed/simple;
	bh=ncams3pFeB/2LmIcGe1gFNX9kNhEztfa5jCN1JHgzCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXhMcLbU72sXXqfnes+d3klKHLgqcQ8PFnfioncOD/hvVRCDbDteq58j6KJKalnRDNJc8Zabq6dnEcNr0e+maZSnSE8FMwoSAetjLRzV7dSAvhOHRyL+SFh7dEF2ldD4rjErAt+HqxHmdAOIS5/EmDNBlbfdYFJjQc4zMJCzMlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIWmO3ti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIWmO3ti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F471F000E9;
	Tue, 21 Jul 2026 18:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659242;
	bh=YGbM6sycopSP67ygoJUm9dlNn3nD/H8rwDjyiBPM808=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fIWmO3tiRJaGqSZZDMc3I4hlKhJIdCTZ3XFBznml3h1kxay9avG9SEkCLzwQ/6tXH
	 34IfVyZqrSgqgd27BqSCgnV/CyYBlvS3t/KCfDCvDQziZVTEpHvR3vl//YVabv+h5m
	 KpxIoPoR6qHyC0nKrTWQwWWdZhvfQdYFUtd881aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>,
	Brendan Jackman <jackmanb@google.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 1448/1611] mm/compaction: handle free_pages_prepare() properly in compaction_free()
Date: Tue, 21 Jul 2026 17:26:04 +0200
Message-ID: <20260721152548.019536218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Zi Yan <ziy@nvidia.com>

commit 7da7d599b8a83271c464adfd5ef160202b470570 upstream.

free_pages_prepare() can fail but compaction_free() does not handle the
failure case.  Failed pages should not be added back to cc->freepages for
future use, since they can be either PageHWPoison or free_page_is_bad()
and might cause data corruption.

Link: https://lore.kernel.org/20260622-handle_free_pages_prepare_in_compaction_free-v1-1-fcf3b14abcf7@nvidia.com
Fixes: 733aea0b3a7b ("mm/compaction: add support for >0 order folio memory compaction.")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/compaction.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1858,15 +1858,14 @@ static void compaction_free(struct folio
 	int order = folio_order(dst);
 	struct page *page = &dst->page;
 
-	if (folio_put_testzero(dst)) {
-		free_pages_prepare(page, order);
+	if (folio_put_testzero(dst) && free_pages_prepare(page, order)) {
 		list_add(&dst->lru, &cc->freepages[order]);
 		cc->nr_freepages += 1 << order;
 	}
 	cc->nr_migratepages += 1 << order;
 	/*
-	 * someone else has referenced the page, we cannot take it back to our
-	 * free list.
+	 * someone else has referenced the page or free_pages_prepare() fails,
+	 * we cannot take it back to our free list.
 	 */
 }
 


