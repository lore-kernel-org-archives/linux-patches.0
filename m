Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EC619049B;
	Mon, 23 Jun 2025 21:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715646; cv=none; b=Rwh3RxA7pD1InZId1ZihWkmv84BkXTTvGZh2NDeTi5ZluVribodQHUaBr5WS4WAtvXf4sQRQM2tjnsYTv6J8FGnV1oGGkqARPTraJfgfIRHFByWultHSrB6txE1C7nnfuq70Trlo1+UNVO1tBL68gvEPj1aJn+wRMDsiHTI3TVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715646; c=relaxed/simple;
	bh=WsJmt/RYkZuaCF+4N3zLL5AzX/eiogCRSL0CqTRhbaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMSA7YYx8bekXmP1Sq/NKynbKGGGNAOi766nX47WmmogNZdR2T6Sfu6/00yx+KOh2fd2D88Rr0y8l1pJeRYbI7q837OFbmFZIZFpqo3PWFy61v2473mdPFmeawgVzOEuscXVFngdMMJJlCTaHhulPKumg64KDJv+/1g/a4igvqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yd1KwaMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yd1KwaMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F7EC4CEEA;
	Mon, 23 Jun 2025 21:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715645;
	bh=WsJmt/RYkZuaCF+4N3zLL5AzX/eiogCRSL0CqTRhbaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yd1KwaMw9KplY4fFYJFui1Iq7ZOqsQ4nbv0G2hZ5O77nGDUQAiSMp2Bw+3ze2vEi3
	 pagzDiCNDpPtdemBRThRAUQ4e8vMTLdXCwCfTe2+ooILOF4ExnYT9/nx5tNNx8FhQb
	 tXjbnd+AIvOd8xZ0zCXjv0naftq9mv1x+ud9swwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 212/290] LoongArch: Fix panic caused by NULL-PMD in huge_pte_offset()
Date: Mon, 23 Jun 2025 15:07:53 +0200
Message-ID: <20250623130633.304484330@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianyang Zhang <zhangtianyang@loongson.cn>

commit ee084fa96123ede8b0563a1b5a9b23adc43cd50d upstream.

ERROR INFO:

CPU 25 Unable to handle kernel paging request at virtual address 0x0
         ...
 Call Trace:
 [<900000000023c30c>] huge_pte_offset+0x3c/0x58
 [<900000000057fd4c>] hugetlb_follow_page_mask+0x74/0x438
 [<900000000051fee8>] __get_user_pages+0xe0/0x4c8
 [<9000000000522414>] faultin_page_range+0x84/0x380
 [<9000000000564e8c>] madvise_vma_behavior+0x534/0xa48
 [<900000000056689c>] do_madvise+0x1bc/0x3e8
 [<9000000000566df4>] sys_madvise+0x24/0x38
 [<90000000015b9e88>] do_syscall+0x78/0x98
 [<9000000000221f18>] handle_syscall+0xb8/0x158

In some cases, pmd may be NULL and rely on NULL as the return value for
processing, so it is necessary to determine this situation here.

Cc: stable@vger.kernel.org
Fixes: bd51834d1cf6 ("LoongArch: Return NULL from huge_pte_offset() for invalid PMD")
Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/hugetlbpage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/loongarch/mm/hugetlbpage.c
+++ b/arch/loongarch/mm/hugetlbpage.c
@@ -47,7 +47,8 @@ pte_t *huge_pte_offset(struct mm_struct
 				pmd = pmd_offset(pud, addr);
 		}
 	}
-	return pmd_none(pmdp_get(pmd)) ? NULL : (pte_t *) pmd;
+
+	return (!pmd || pmd_none(pmdp_get(pmd))) ? NULL : (pte_t *) pmd;
 }
 
 int pmd_huge(pmd_t pmd)


