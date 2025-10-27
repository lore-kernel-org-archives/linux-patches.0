Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E5427FD62;
	Mon, 27 Oct 2025 19:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593138; cv=none; b=ExCCyk8OsmI8Ph+coMCP50UfGXcYTDmUmgK4Zapsnd1gmPXhk1NYJENxmrL97jHLAFR/2yZzt0xlU/tzU5P7URBP972kjptHUWOP4wG22QQ7Di+xTpRtXU0og8xCCZjo2DEH+JMQneucL15onNj+PVipZRBASJKqhg/6+GNDAN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593138; c=relaxed/simple;
	bh=GcE8wO/pCMUl5QmbGdCM3opfjDx3SkkqXxmGP/vvtwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpmtCUp+pq8o8fL2qJFC029yMNh0o15jmAunuHI/MMyd55udLqmFgKVNZ+RzK/aXkn87AsFI5FU+32g7RIDtgWi3DC+pB8aY8LIBS81lvq+q1YC+5LcRqn0aSIfVNyV885VgRQElMvtXR9cW0LK3tmaMKEOokhmTka9JN+TqJJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qR4+CzVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qR4+CzVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A060C4CEF1;
	Mon, 27 Oct 2025 19:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593138;
	bh=GcE8wO/pCMUl5QmbGdCM3opfjDx3SkkqXxmGP/vvtwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qR4+CzVFslMiZQ1LkxBcBDD8osEInwpp+WpcNT9dKDKFsG6ja1OBIQ9U4M3ktJ97+
	 BrcnyYnUk5nacBHwhRA4QApbr8CF2j8pPh3KMoTvISf11lDe/u5+6bI7mCpe9YvVLA
	 Pn5Jgr24OUOk0YjCfSEbruyXF3G7f2Y0xGzvEBZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 027/184] s390/mm: Use __GFP_ACCOUNT for user page table allocations
Date: Mon, 27 Oct 2025 19:35:09 +0100
Message-ID: <20251027183515.657473164@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 5671ce2a1fc6b4a16cff962423bc416b92cac3c8 ]

Add missing kmemcg accounting of user page table allocations.

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/pgalloc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index d2f6f1f6d2fcb..ad3e0f7f7fc1f 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -16,9 +16,13 @@
 
 unsigned long *crst_table_alloc(struct mm_struct *mm)
 {
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, CRST_ALLOC_ORDER);
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
+	struct ptdesc *ptdesc;
 	unsigned long *table;
 
+	if (mm == &init_mm)
+		gfp &= ~__GFP_ACCOUNT;
+	ptdesc = pagetable_alloc(gfp, CRST_ALLOC_ORDER);
 	if (!ptdesc)
 		return NULL;
 	table = ptdesc_to_virt(ptdesc);
@@ -117,7 +121,7 @@ struct ptdesc *page_table_alloc_pgste(struct mm_struct *mm)
 	struct ptdesc *ptdesc;
 	u64 *table;
 
-	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	ptdesc = pagetable_alloc(GFP_KERNEL_ACCOUNT, 0);
 	if (ptdesc) {
 		table = (u64 *)ptdesc_to_virt(ptdesc);
 		__arch_set_page_dat(table, 1);
@@ -136,10 +140,13 @@ void page_table_free_pgste(struct ptdesc *ptdesc)
 
 unsigned long *page_table_alloc(struct mm_struct *mm)
 {
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
 	struct ptdesc *ptdesc;
 	unsigned long *table;
 
-	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	if (mm == &init_mm)
+		gfp &= ~__GFP_ACCOUNT;
+	ptdesc = pagetable_alloc(gfp, 0);
 	if (!ptdesc)
 		return NULL;
 	if (!pagetable_pte_ctor(mm, ptdesc)) {
-- 
2.51.0



