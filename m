Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5075D7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C417C433C1;
	Wed,  2 Nov 2022 02:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357176;
	bh=e+GIMqHRV/aeDZ8etUA+qQFFEiRSYaRx49n5SwYQp/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDrSu4yfXR/ne2G6De1T7H8ROWPHU3T7s4/pXC1DrWFOSxf/SCwyfp2UrFj04ZkQu
	 yOWaR/iaHhnpNHp6xyOBC4fWEzA8s67SvBBedk1UBar17UtoQNSD9Z7XP0J4J/sGT8
	 8uY6ohpmsNPiDG/wHfK/PhRd6tSh+6sfK4WOgQEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Rapoport <rppt@kernel.org>,
	Pavel Kozlov <pavel.kozlov@synopsys.com>,
	Vineet Gupta <vgupta@kernel.org>
Subject: [PATCH 6.0 097/240] ARC: mm: fix leakage of memory allocated for PTE
Date: Wed,  2 Nov 2022 03:31:12 +0100
Message-Id: <20221102022113.587705818@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Kozlov <pavel.kozlov@synopsys.com>

commit 4fd9df10cb7a9289fbd22d669f9f98164d95a1ce upstream.

Since commit d9820ff ("ARC: mm: switch pgtable_t back to struct page *")
a memory leakage problem occurs. Memory allocated for page table entries
not released during process termination. This issue can be reproduced by
a small program that allocates a large amount of memory. After several
runs, you'll see that the amount of free memory has reduced and will
continue to reduce after each run. All ARC CPUs are effected by this
issue. The issue was introduced since the kernel stable release v5.15-rc1.

As described in commit d9820ff after switch pgtable_t back to struct
page *, a pointer to "struct page" and appropriate functions are used to
allocate and free a memory page for PTEs, but the pmd_pgtable macro hasn't
changed and returns the direct virtual address from the PMD (PGD) entry.
Than this address used as a parameter in the __pte_free() and as a result
this function couldn't release memory page allocated for PTEs.

Fix this issue by changing the pmd_pgtable macro and returning pointer to
struct page.

Fixes: d9820ff76f95 ("ARC: mm: switch pgtable_t back to struct page *")
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Pavel Kozlov <pavel.kozlov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/include/asm/pgtable-levels.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arc/include/asm/pgtable-levels.h
+++ b/arch/arc/include/asm/pgtable-levels.h
@@ -161,7 +161,7 @@
 #define pmd_pfn(pmd)		((pmd_val(pmd) & PAGE_MASK) >> PAGE_SHIFT)
 #define pmd_page(pmd)		virt_to_page(pmd_page_vaddr(pmd))
 #define set_pmd(pmdp, pmd)	(*(pmdp) = pmd)
-#define pmd_pgtable(pmd)	((pgtable_t) pmd_page_vaddr(pmd))
+#define pmd_pgtable(pmd)	((pgtable_t) pmd_page(pmd))
 
 /*
  * 4th level paging: pte


