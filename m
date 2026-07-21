Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4870F471410;
	Tue, 21 Jul 2026 20:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664138; cv=none; b=BhtJy6qbX+T1CuvrHKxcMaQNgeWgVewI1+7VYHHV8gNJN7/2KBCz7m9QWMWehPLAdEM4KaJpXMBJ9zdKRmX2KEDKfELfXiLBJdJTABuqUhX5BM9ftYQUPIrKLvvKbcEW6tS3WNEvta8SITMsI/wqRGTwuF5i9179Ot2wQnxQCP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664138; c=relaxed/simple;
	bh=rDPNVtU1TrNqGIqtX1szJFXey7VP+6f+MPNGq61ZShc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oqj2LNscT4zzFwc73NQNESPRrV7DyIOCx4JpmsECJOZ5Z5soNDs+X6f5kAhRVsKNgle2LOunOmOt89jkd/PXElS7um52b5zD4W/aLYyyVMPmD5RTpikbu5nwUUxRt/Yd4PP0e9WvVuabqJDajNuMxC3zpxX9/ma6aV0VGLp8WYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SGEnqC9T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGEnqC9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CCF1F000E9;
	Tue, 21 Jul 2026 20:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664136;
	bh=6hXgXaNGgK7KA6rzec3DwGvAurEuUtSjEO2Z9Lu2m+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGEnqC9TVx93tuauJQlItAIEA3iVMiwahT1IGn00BtQDl7Mzxs4L7k7T4ikZeXRcx
	 skggST9y2CNMlRaJlMM1fHQFSqOQNAEH9LOsDyMJLxjzA43g4LS+vIEl1SgL9/RzlA
	 82HM4BTEijU0s28wUv7b1FwIUTOBG5/+rUv8W8CM=
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
Subject: [PATCH 6.12 1086/1276] mm/compaction: handle free_pages_prepare() properly in compaction_free()
Date: Tue, 21 Jul 2026 17:25:29 +0200
Message-ID: <20260721152510.286333798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -1894,15 +1894,14 @@ static void compaction_free(struct folio
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
 


