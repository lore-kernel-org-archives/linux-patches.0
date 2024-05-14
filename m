Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAA612A160;
	Tue, 14 May 2024 11:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687242; cv=none; b=c1pnTm6FHwB1Q8sR4LP1wnclxKnK9Aip9c8eR9MUW6kkenBu/0+okz19NoyXktTY1ni9Y3xjLLNcWGaK7W6LqsXoJk/ypwJ/XnOLuDcbMSW8Nx0GY4/7Ao8WC9odozArVC8hwIzfDSCiJ/V+PCA7y8hC2Q3A9P+nnQgQH9gqsGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687242; c=relaxed/simple;
	bh=ZnJBGdqqgIqGYVzR2n6+dQ0XUQQjJlT0u7lHGSQU+Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIFS/Vrj/N/tAds6BVIe+HTIMBB3aMlOgJ87khz/HW+ca+trMsmVBYHFXHRkxPmEa4XjKltiiuusAwysgA5ghNDI/naA+YOvPgjqR0yEgprkKahuWCbgKAwh+oxublYEoI90VS/ZvdvNap6kgijpJQkqcFROvvco1vaw9EwuPTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euMPHuOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euMPHuOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB0CC2BD10;
	Tue, 14 May 2024 11:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687242;
	bh=ZnJBGdqqgIqGYVzR2n6+dQ0XUQQjJlT0u7lHGSQU+Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euMPHuOxRw9/L6OxJb3RpgqtoECpj+MxvZrGAU/yn8zzCI3Y7Loke0/uLt1QPrfoS
	 S6TGHZhBtLcw0sCi3Fff60eRzHIdzl4c59EU8jGDpdM1Omu/LA8jOzVeVPGVlQqxZO
	 Rj1ZBUS6ahenr6H3hKN0kOtVVVsSmDYf4Rrbl+tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/111] s390/mm: Fix clearing storage keys for huge pages
Date: Tue, 14 May 2024 12:19:19 +0200
Message-ID: <20240514100957.929719362@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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
index 3b5a4d25ca9b5..0ca46f5d9438f 100644
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



