Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B2526B091;
	Thu, 13 Feb 2025 15:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459951; cv=none; b=H9uf2Bpr7TkeGDF/BJKHmNixidpBn5P9bWulqS9DDjo7W/Pf0mq1Yu1uKQYNq51c+lrY9Fr1BxE9sodZZ9BBWqfzygyXiJcIxmNwBu37rt9AFyVf8IjMaOvctHlqi8ui1jp8ikepXHpWhtGv6+sBsPnC8funUvQQgVv0DUIOdCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459951; c=relaxed/simple;
	bh=kSxBppXARG35Rq0IxoZF4XuGFdCNxqZOTN/W9Yuce6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWWxnNfjulbs66i5EuemsADWar3Te4AfErZSZpClKQOipvNehfBQiLMJ90+3NZXDQ9JxV94TI+aao+fdyDWgPKc6C1Flcq89l5wAZ2so+mnPKgVhHWHSzlI5C8fIOtC1NLU9YouhXx0LuEM60zDH0XGy0IDZuVZ0GybZ+0Y51RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfpa763R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfpa763R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28ECAC4CEE4;
	Thu, 13 Feb 2025 15:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459951;
	bh=kSxBppXARG35Rq0IxoZF4XuGFdCNxqZOTN/W9Yuce6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfpa763RHYGBCkNYwp+swr1JZVWoTwG4CnCQ/hHtlDBEU2Omi/Roty4OBCVj6DhWr
	 sLboAGOaQsUH7+I+jy0lBM8cabMFTI/aW9bpHoUBMPkCo9ZEiT6YTNpPmJ+HHhzjat
	 smQ2iDvvLAgZa8YttUGuKFpEfq08LuG/awbf50e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 381/443] mm/compaction: fix UBSAN shift-out-of-bounds warning
Date: Thu, 13 Feb 2025 15:29:06 +0100
Message-ID: <20250213142455.307110976@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Shixin <liushixin2@huawei.com>

commit d1366e74342e75555af2648a2964deb2d5c92200 upstream.

syzkaller reported a UBSAN shift-out-of-bounds warning of (1UL << order)
in isolate_freepages_block().  The bogus compound_order can be any value
because it is union with flags.  Add back the MAX_PAGE_ORDER check to fix
the warning.

Link: https://lkml.kernel.org/r/20250123021029.2826736-1-liushixin2@huawei.com
Fixes: 3da0272a4c7d ("mm/compaction: correctly return failure with bogus compound_order in strict mode")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/compaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -630,7 +630,8 @@ static unsigned long isolate_freepages_b
 		if (PageCompound(page)) {
 			const unsigned int order = compound_order(page);
 
-			if (blockpfn + (1UL << order) <= end_pfn) {
+			if ((order <= MAX_PAGE_ORDER) &&
+			    (blockpfn + (1UL << order) <= end_pfn)) {
 				blockpfn += (1UL << order) - 1;
 				page += (1UL << order) - 1;
 				nr_scanned += (1UL << order) - 1;


