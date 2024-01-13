Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780D315BD;
	Sat, 13 Jan 2024 09:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGQfp98x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3711C433F1;
	Sat, 13 Jan 2024 09:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139964;
	bh=pxqDMjwblP7PAU1+/62aqNH56HB7WUjnIXb5jXsQD1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGQfp98xQZJc9TKI1PqfvZtEmxXbQzIH/8f7ZmujgcYnBho0bH6ks4FFbvfa5vb6s
	 QmMQFZAbY1Q2/HsCcTlYnwLQHbQBhUNlv/vB3Km5Z2/vfaMG8wFzW0uFG5w058qrOK
	 U5zcgGvzprIGbtBaXQv9cxu6IEw476U4cFe30lQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/43] mm/memory-failure: check the mapcount of the precise page
Date: Sat, 13 Jan 2024 10:50:06 +0100
Message-ID: <20240113094207.786197636@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.930684111@linuxfoundation.org>
References: <20240113094206.930684111@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit c79c5a0a00a9457718056b588f312baadf44e471 ]

A process may map only some of the pages in a folio, and might be missed
if it maps the poisoned page but not the head page.  Or it might be
unnecessarily hit if it maps the head page, but not the poisoned page.

Link: https://lkml.kernel.org/r/20231218135837.3310403-3-willy@infradead.org
Fixes: 7af446a841a2 ("HWPOISON, hugetlb: enable error handling path for hugepage")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-failure.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 652283a1353d7..f320ff02cc196 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1010,7 +1010,7 @@ static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * This check implies we don't kill processes if their pages
 	 * are in the swap cache early. Those are always late kills.
 	 */
-	if (!page_mapped(hpage))
+	if (!page_mapped(p))
 		return true;
 
 	if (PageKsm(p)) {
@@ -1075,12 +1075,12 @@ static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				unmap_success = false;
 			}
 		} else {
-			unmap_success = try_to_unmap(hpage, ttu);
+			unmap_success = try_to_unmap(p, ttu);
 		}
 	}
 	if (!unmap_success)
 		pr_err("Memory failure: %#lx: failed to unmap page (mapcount=%d)\n",
-		       pfn, page_mapcount(hpage));
+		       pfn, page_mapcount(p));
 
 	/*
 	 * try_to_unmap() might put mlocked page in lru cache, so call
-- 
2.43.0



