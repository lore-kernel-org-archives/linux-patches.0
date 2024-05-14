Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B962374E;
	Tue, 14 May 2024 11:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687569; cv=none; b=D5qwRueKDe7Wj+xLsz+8fTT06og8cUx5dEBqEl4KtqQWUNDjx48RvaclZLzU2p/FxzYugolboN+8qWLkuXeDNiwWLHi60LgotznLqU1Xi5/Yoh5a4DKR0R99wgpkTC/KxmtE7K5LGym7+JkKaAlmgkm9bzvOVhaBa3x4VkJ2WFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687569; c=relaxed/simple;
	bh=HX8LJPITG+zJoEqAwn3qsRayiKlL2weF/rHDSWac++A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/Lu3skzRx58phR8LE/tQ/zjM7IH8KOIIvyH8Oxiup4+y4dkOtFRy07xP8d279c/A1ekCwRZ4zlDKID0mzSUm9SZfe4IpJINQ773rGr7j8leir5TmMlbjiV62dT/4f3QOkbSwB+XmElHP2eakBvMY20C5DNRbYQVGP8NEhq5gVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qq6H+u3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qq6H+u3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25D3C32781;
	Tue, 14 May 2024 11:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687569;
	bh=HX8LJPITG+zJoEqAwn3qsRayiKlL2weF/rHDSWac++A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qq6H+u3qlIzXLfb/utbVlOUE5dlCtPofw0EFRaWAiETp0rMH+RxEr4Zm3hXbf5kKu
	 hRs9yhgwHSjkSumf/sGQV+H9djKPPC5LzqSC1aMn4OcoDi9oqKqCBjy8PaR8yNL+ic
	 icZt2y5hFFnldN/v/x/Z6zwW6pUGtH4y5/4pPJF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/168] s390/mm: Fix clearing storage keys for huge pages
Date: Tue, 14 May 2024 12:18:47 +0200
Message-ID: <20240514101007.790014620@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 412050af2ea39407fe43324b0be4ab641530ce88 ]

The function __storage_key_init_range() expects the end address to be
the first byte outside the range to be initialized. I.e. end - start
should be the size of the area to be initialized.

The current code works because __storage_key_init_range() will still loop
over every page in the range, but it is slower than using sske_frame().

Fixes: 3afdfca69870 ("s390/mm: Clear skeys for newly mapped huge guest pmds")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240416114220.28489-3-imbrenda@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/hugetlbpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
index da36d13ffc162..8631307d3defc 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -146,7 +146,7 @@ static void clear_huge_pte_skeys(struct mm_struct *mm, unsigned long rste)
 	}
 
 	if (!test_and_set_bit(PG_arch_1, &page->flags))
-		__storage_key_init_range(paddr, paddr + size - 1);
+		__storage_key_init_range(paddr, paddr + size);
 }
 
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
-- 
2.43.0



