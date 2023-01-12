Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC16749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF37FC433EF;
	Thu, 12 Jan 2023 14:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532982;
	bh=GmCXSwPE5NP+SaO5s7kju7LigtOKyGlQFSX61WElufY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egnNkK0+t9BdFVsxQ8nVHgMQQ9I7MCmbmf4X+oeZRMfvuqt4h4cWbCgk0E2yFueXw
	 d5NaH/xN5PXPKzVgnvr52258A7St1hHTgPT6VM67P1EHttsHQ/tDmUH1parY9Wz86s
	 8ZNGXS0t6n36t+564puGce1SFspMoZ27Vwc51Ygs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tong Tiangen <tongtiangen@huawei.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 331/783] riscv/mm: add arch hook arch_clear_hugepage_flags
Date: Thu, 12 Jan 2023 14:50:47 +0100
Message-Id: <20230112135539.648707238@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tong Tiangen <tongtiangen@huawei.com>

[ Upstream commit d8bf77a1dc3079692f54be3087a5fd16d90027b0 ]

With the PG_arch_1 we keep track if the page's data cache is clean,
architecture rely on this property to treat new pages as dirty with
respect to the data cache and perform the flushing before mapping the pages
into userspace.

This patch adds a new architecture hook, arch_clear_hugepage_flags,so that
architectures which rely on the page flags being in a particular state for
fresh allocations can adjust the flags accordingly when a page is freed
into the pool.

Fixes: 9e953cda5cdf ("riscv: Introduce huge page support for 32/64bit kernel")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Link: https://lore.kernel.org/r/20221024094725.3054311-3-tongtiangen@huawei.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/hugetlb.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/include/asm/hugetlb.h b/arch/riscv/include/asm/hugetlb.h
index a5c2ca1d1cd8..ec19d6afc896 100644
--- a/arch/riscv/include/asm/hugetlb.h
+++ b/arch/riscv/include/asm/hugetlb.h
@@ -5,4 +5,10 @@
 #include <asm-generic/hugetlb.h>
 #include <asm/page.h>
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+	clear_bit(PG_dcache_clean, &page->flags);
+}
+#define arch_clear_hugepage_flags arch_clear_hugepage_flags
+
 #endif /* _ASM_RISCV_HUGETLB_H */
-- 
2.35.1



