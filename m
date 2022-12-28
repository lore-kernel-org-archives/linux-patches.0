Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65041863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1B3C433EF;
	Wed, 28 Dec 2022 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240975;
	bh=GmCXSwPE5NP+SaO5s7kju7LigtOKyGlQFSX61WElufY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6ZyAlxiLGB5L64nFQqNTa4nZGb83246heH6+NHvhMRZjbgDvQarDffcjRy0sFzyb
	 cx+iZBDfoiIncueAP5DkQTWc2P7ffZbTqOd6baJ3+JTvFUSK5VxaZMaxgNAd0OzL1y
	 dHIE54d+9YQV80ae9QMbQN1Y+xH52FbR+c/JQaQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tong Tiangen <tongtiangen@huawei.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 423/731] riscv/mm: add arch hook arch_clear_hugepage_flags
Date: Wed, 28 Dec 2022 15:38:50 +0100
Message-Id: <20221228144308.830342918@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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



