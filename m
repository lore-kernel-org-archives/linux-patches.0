Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEA554903;
	Tue, 14 May 2024 11:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684490; cv=none; b=UWcH5TAP1qjWczKU5cs+u9EQJsgcNrcw5HxUpTHyctGCsrnm7kmS/BUmXc7hDFt0XGPUvtvdSes83J+8rKUB2k3GQN0AvUSwuXqRNKLW9GVd3dvODkcrEGqyqKedp+zb99dJfe6yuRos39Y+DZ05sMY/SCINJURtAeE43+wZipE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684490; c=relaxed/simple;
	bh=ztLUksvn+onk6WL8bet3L/UlTOdnKPpMWys9DnzR2Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHxn8hbjY5Jwld2ZRn3Du6YRxxirUa9VaOUAwJoxEjLQAe05xqC+thsdf8uJCtYEfdzna6PX85+n2L3AGwcBx7rtVrumrfXpCotKbLPD09rKwqEbnS3UWqGsrhiKWRLUVhmWtC4YRlD7Ll8sLodM/3czn3KYFXVGAD8jxba8g30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oN624vnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oN624vnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7949CC2BD10;
	Tue, 14 May 2024 11:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684490;
	bh=ztLUksvn+onk6WL8bet3L/UlTOdnKPpMWys9DnzR2Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oN624vnNuVHjcWTAmaHS/RQ2fNV7Ru1OgTkmXeTlFho4yrFXFVMRM/uRAblznVMA4
	 aIpM/Vkm5f4+OYFNOyMDcO3aGvHyfL4LTapbhUzuIkIUpBQoYeDjVq/Ln7m9NRiHiH
	 wHbRY5TAyl3gg22qjC26EcuQBngwu5zE7qvIzYFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/301] s390/mm: Fix clearing storage keys for huge pages
Date: Tue, 14 May 2024 12:15:18 +0200
Message-ID: <20240514101034.021395988@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5f64f3d0fafbb..763469e518eec 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -139,7 +139,7 @@ static void clear_huge_pte_skeys(struct mm_struct *mm, unsigned long rste)
 	}
 
 	if (!test_and_set_bit(PG_arch_1, &page->flags))
-		__storage_key_init_range(paddr, paddr + size - 1);
+		__storage_key_init_range(paddr, paddr + size);
 }
 
 void __set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
-- 
2.43.0



