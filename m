Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649071BDF1;
	Wed,  3 Jan 2024 17:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uml3yC3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83561C433C9;
	Wed,  3 Jan 2024 17:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301283;
	bh=SLHTo2v3BQQFJT/kXWTL9DqNiGLFcIoM/JgjJy1SMws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uml3yC3T7HBFl6avjk/VRS/JdhPh+NkIid/PIp0pDcQ0bTOclrrYC2zQQRntb05xP
	 fSbX23kUeVM1Gsn3GpBadMhObKQOYMfZ9cMrAp+X9SPrHjQez73wOoRrkqjgkTMi2x
	 F92NkyGabOayqmeDKvm630d8JtiCgfRaS8d7zL78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 090/100] mm/memory-failure: check the mapcount of the precise page
Date: Wed,  3 Jan 2024 17:55:19 +0100
Message-ID: <20240103164909.660353168@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit c79c5a0a00a9457718056b588f312baadf44e471 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1421,7 +1421,7 @@ static bool hwpoison_user_mappings(struc
 	 * This check implies we don't kill processes if their pages
 	 * are in the swap cache early. Those are always late kills.
 	 */
-	if (!page_mapped(hpage))
+	if (!page_mapped(p))
 		return true;
 
 	if (PageKsm(p)) {
@@ -1477,10 +1477,10 @@ static bool hwpoison_user_mappings(struc
 		try_to_unmap(folio, ttu);
 	}
 
-	unmap_success = !page_mapped(hpage);
+	unmap_success = !page_mapped(p);
 	if (!unmap_success)
 		pr_err("%#lx: failed to unmap page (mapcount=%d)\n",
-		       pfn, page_mapcount(hpage));
+		       pfn, page_mapcount(p));
 
 	/*
 	 * try_to_unmap() might put mlocked page in lru cache, so call


