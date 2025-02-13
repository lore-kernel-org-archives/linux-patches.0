Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96351993B7;
	Thu, 13 Feb 2025 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458247; cv=none; b=ddPXlrTHqnHWoGf/0uUDLnQ55pc1B/i2wB0VgSo+Ni4jcOG7fkXMgae22pcLqI2yQ2t1UM4HOfNLzSMgcHGhcv3MgrzDUHVD+IeW8QNWM660a4BZvx3b7X658NFSb742C6+hUpsdH69bE5to8cjEQtCEYn3kG6FzyvsVZOKqNWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458247; c=relaxed/simple;
	bh=5UHVh1GBLpw9lzq9yGnA0zY7y1vLS+vO3iPbHm8/7Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ff3kUSQEEp7c8vIJMlIa3u7zVzeimxeokB7hZgtGrj+bVjRdyGndbBbnfzUxVUyrY/8OtRxtNMTBbsU5rUdPMM8P9aa1Wl60qCAKycElaQ6ttTzcMp4nLA8XeTWErOCO2xEFpmM5vegUQhl5bhyMCFLrVzdkjMeQ+Tj3Jy5pGfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhs0igZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhs0igZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D58C4CED1;
	Thu, 13 Feb 2025 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458246;
	bh=5UHVh1GBLpw9lzq9yGnA0zY7y1vLS+vO3iPbHm8/7Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhs0igZaFXukZr57I36MJfLSHw8S98Jq4j14btEf3Fvb9Q/MTNgHChhj4ep4Ewa4X
	 RouO2hrMcTEy+EFgaTa+BsdlWxpXuDOJbx5XmYCtueihEE9tQjMrEhfS4JdmHHut68
	 4LKf698ZWuQL9/yomNnLmkie27w/NPGvSb0juXMM=
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
Subject: [PATCH 6.12 344/422] mm/compaction: fix UBSAN shift-out-of-bounds warning
Date: Thu, 13 Feb 2025 15:28:13 +0100
Message-ID: <20250213142449.829477754@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


