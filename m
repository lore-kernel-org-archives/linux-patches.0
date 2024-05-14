Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD4655C3B;
	Tue, 14 May 2024 10:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682554; cv=none; b=lN0+g2VYotpf9eoIpl0DqMyU0XZZpoTfEURzYXzo4SB1nFt0QgYKXs7s/+qjjwqjTqbx2lMCvdrGnQwdblefVnucuvcnv2VpaHa+vt9MhddA+Z62NprWteVQC9Ua3uTLLhd8lO4v8SyPEj9SPF9o6J39j2esVWpUSUOIJh/zB78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682554; c=relaxed/simple;
	bh=OQfAQgNt3zsMTau3MOkMEgN5zOBWYSLufvZKwsP89zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXJVlz8FHtQgJc/LvojLWbNmCn0FqfYnwwbbYPnqjuJ3WtqlbIEjaAsdtojvEt9B/rtN03qmhz/vPuSmkmmsjDo1N/GbIOiqho6hRopTX0xSRdY9xCTuJLMWlXQa5Uqq918wIa4rlEl6XPeAx0V/hm2FXjX4ViltQGEaOlGmgcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xEGf6n0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xEGf6n0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8C6C2BD10;
	Tue, 14 May 2024 10:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682554;
	bh=OQfAQgNt3zsMTau3MOkMEgN5zOBWYSLufvZKwsP89zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xEGf6n0/e+8Myo2OgijUMknXos5k+bD/BPDJCjTcPN0fMM/Zl+Wl4bB+DKpOhS4Cr
	 yZ1Hg2gGxnSuuFC7zr7AhO2UfWj0QEzePUF2woHGGriUrWt73oAqbNs2o1KnuH4xDB
	 dWQdII0MHbUn6eAGIVCRsVPh0Nj+vanHV7vBtBh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 039/336] s390/mm: Fix clearing storage keys for huge pages
Date: Tue, 14 May 2024 12:14:03 +0200
Message-ID: <20240514101040.084662408@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



