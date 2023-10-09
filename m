Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB32D23D1
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbVR9hAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BE4C433C8;
	Mon,  9 Oct 2023 13:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857369;
	bh=Kl1/x780WCEcyjtI43YxPbR41sMRQ4EVsBsA4vnotao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbVR9hAYuNwbe8Iz19I/0Sb3DPm0PJJ0xxdNVU55hUW8NWcEpetWfgRXrdqwDBvkM
	 mAjc79LS0+SU92Rz7WjeQw7v2LwPj3iNn+DoIIXOwduRhbQBYkxEAfTwsOIul/ALYF
	 kXqzrng6HPi4BsuccNVD2sOhH3tJklHAR0KQV8aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/162] mm/memory: add vm_normal_folio()
Date: Mon,  9 Oct 2023 15:00:05 +0200
Message-ID: <20231009130123.614056789@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

From: Vishal Moola (Oracle) <vishal.moola@gmail.com>

[ Upstream commit 318e9342fbbb6888d903d86e83865609901a1c65 ]

Patch series "Convert deactivate_page() to folio_deactivate()", v4.

Deactivate_page() has already been converted to use folios.  This patch
series modifies the callers of deactivate_page() to use folios.  It also
introduces vm_normal_folio() to assist with folio conversions, and
converts deactivate_page() to folio_deactivate() which takes in a folio.

This patch (of 4):

Introduce a wrapper function called vm_normal_folio().  This function
calls vm_normal_page() and returns the folio of the page found, or null if
no page is found.

This function allows callers to get a folio from a pte, which will
eventually allow them to completely replace their struct page variables
with struct folio instead.

Link: https://lkml.kernel.org/r/20221221180848.20774-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20221221180848.20774-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 24526268f4e3 ("mm: mempolicy: keep VMA walk if both MPOL_MF_STRICT and MPOL_MF_MOVE are specified")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 104ec00823da8..eefb0948110ae 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1906,6 +1906,8 @@ static inline bool can_do_mlock(void) { return false; }
 extern int user_shm_lock(size_t, struct ucounts *);
 extern void user_shm_unlock(size_t, struct ucounts *);
 
+struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
+			     pte_t pte);
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
diff --git a/mm/memory.c b/mm/memory.c
index 2083078cd0615..0d1b3ee8fcd7a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -672,6 +672,16 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 	return pfn_to_page(pfn);
 }
 
+struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
+			    pte_t pte)
+{
+	struct page *page = vm_normal_page(vma, addr, pte);
+
+	if (page)
+		return page_folio(page);
+	return NULL;
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd)
-- 
2.40.1



