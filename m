Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D85F9F4
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7423C433C8;
	Mon, 11 Sep 2023 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440763;
	bh=WQXEP1AM/tpC0OwmoZtHkfQmwOYbOBUrDefZ2bWiR9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xF/sGXIaTOHsohMjaqvuUgU/c02DQHOBlWILpue1wr1oxMJoaYN1xSLioJbwIvIif
	 KcSxWLPfxOyObxyCBKQqaKVKvSBL0rVHS0RDF4KtKRwD2b9mB5StSmuJXdw4ixZ33u
	 BbRxlO5UjGEUnAwArfc/EUvqf7ZRYizjHsr78RpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 177/739] arm64: mm: use ptep_clear() instead of pte_clear() in clear_flush()
Date: Mon, 11 Sep 2023 15:39:36 +0200
Message-ID: <20230911134656.138531837@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Zheng <zhengqi.arch@bytedance.com>

[ Upstream commit 00de2c9f26b15f1a6f2af516dd8ec5f8d28189b7 ]

In clear_flush(), the original pte may be a present entry, so we should
use ptep_clear() to let page_table_check track the pte clearing operation,
otherwise it may cause false positive in subsequent set_pte_at().

Link: https://lkml.kernel.org/r/20230810093241.1181142-1-qi.zheng@linux.dev
Fixes: 42b2547137f5 ("arm64/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/hugetlbpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 21716c9406821..9c52718ea7509 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -236,7 +236,7 @@ static void clear_flush(struct mm_struct *mm,
 	unsigned long i, saddr = addr;
 
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
-		pte_clear(mm, addr, ptep);
+		ptep_clear(mm, addr, ptep);
 
 	flush_tlb_range(&vma, saddr, addr);
 }
-- 
2.40.1



