Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3313BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89B3C433D2;
	Tue,  7 Mar 2023 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211690;
	bh=WkIg0ju4dYTrICm/AZnEQmw58BFhiMBugI/e0nsK6SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmkU1UWttinojixrd6mDHlstxqA4s2XwM8QbxOpXREyJOHXmwqhIcN3+VDLjXnh46
	 2tyQ1Q0OlKSpvca8vLhx4GA+WCAUvFGJT0FETEtB8VGajJK6eKYCZMgl/yYKaHWH+H
	 rMr1vP/cTDpwUW660RzI50VV2GqTaeHN6TOCuing=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <muchun.song@linux.dev>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.2 0927/1001] arm64: mm: hugetlb: Disable HUGETLB_PAGE_OPTIMIZE_VMEMMAP
Date: Tue,  7 Mar 2023 18:01:39 +0100
Message-Id: <20230307170102.323771061@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Catalin Marinas <catalin.marinas@arm.com>

commit 060a2c92d1b627c86c5c42ca69baf00457c00c5a upstream.

Revert the HUGETLB_PAGE_FREE_VMEMMAP selection from commit 1e63ac088f20
("arm64: mm: hugetlb: enable HUGETLB_PAGE_FREE_VMEMMAP for arm64") but
keep the flush_dcache_page() compound_head() change as it aligns with
the corresponding check in the __sync_icache_dcache() function.

The original config option was renamed in commit 47010c040dec ("mm:
hugetlb_vmemmap: cleanup CONFIG_HUGETLB_PAGE_FREE_VMEMMAP*") to
HUGETLB_PAGE_OPTIMIZE_VMEMMAP and the flush_dcache_page() check was
further simplified by commit 2da1c30929a2 ("mm: hugetlb_vmemmap: delete
hugetlb_optimize_vmemmap_enabled()").

The reason for the revert is that the generic vmemmap_remap_pte()
function changes both the permissions (writeable to read-only) and the
output address (pfn) of the vmemmap ptes. This is deemed UNPREDICTABLE
by the Arm architecture without a break-before-make sequence (make the
PTE invalid, TLBI, write the new valid PTE). However, such sequence is
not possible since the vmemmap may be concurrently accessed by the
kernel. Disable the optimisation until a better solution is found.

Fixes: 1e63ac088f20 ("arm64: mm: hugetlb: enable HUGETLB_PAGE_FREE_VMEMMAP for arm64")
Cc: <stable@vger.kernel.org> # 5.19.x
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/Y9pZALdn3pKiJUeQ@arm.com
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20230222175232.540851-1-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -100,7 +100,6 @@ config ARM64
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
-	select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES


