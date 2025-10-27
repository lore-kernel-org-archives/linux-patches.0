Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278AE22A4DB;
	Mon, 27 Oct 2025 19:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592684; cv=none; b=NifbEN1AfyA5uSiOpSX0FOrXqNpoAvsnylTSao+C0+wuP91PnUfKpR3EWSyHuPb1LRwCCxPM6ZEh6usjlmfZ9HgDWEJlUm8JQaVg3vHtjYQIYKFwrgC6hKUbb+r33q1y4zYxNDQWj3yfI72GFkJRTAbR8vZ+zxfoNLk0wNDgr6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592684; c=relaxed/simple;
	bh=R+b1Oy20HuQfqVSsApk8HxKMmROwQDEieiBLTvfYlHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9qP6wTPdkmpt5g8nr27ukEK4S3ke+SfItl7+C4KzBk5h/fTuYv/CWGmFfdm6FMFGzxHBl3P10clEPTL+8bhSYalOv7ZMSY00djtzvA2yGgF5bigYBorD6crlaeewJxTLs3Gg/ptDxLUib9Br1mw/2TyAkxSlMTKxf1bTYfGwes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGar4Cva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGar4Cva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA17C4CEF1;
	Mon, 27 Oct 2025 19:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592683;
	bh=R+b1Oy20HuQfqVSsApk8HxKMmROwQDEieiBLTvfYlHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGar4Cva2yrBmrrpttnYn+JeL1/6HQcmJ7iMDt97Umq8qRSKoGF6y/lSJwV83jMwO
	 rvGOu82K5funqA+TgIigVPqFgA1OZU0tFNT5Q2sNSHmzFVCM/yG5jTiB65Gveh2Xp+
	 atgnAER88nlSXLd89BxZIVA7d9jGvsohAxWPMa34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 29/84] arm64, mm: avoid always making PTE dirty in pte_mkwrite()
Date: Mon, 27 Oct 2025 19:36:18 +0100
Message-ID: <20251027183439.595353130@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Huang Ying <ying.huang@linux.alibaba.com>

[ Upstream commit 143937ca51cc6ae2fccc61a1cb916abb24cd34f5 ]

Current pte_mkwrite_novma() makes PTE dirty unconditionally.  This may
mark some pages that are never written dirty wrongly.  For example,
do_swap_page() may map the exclusive pages with writable and clean PTEs
if the VMA is writable and the page fault is for read access.
However, current pte_mkwrite_novma() implementation always dirties the
PTE.  This may cause unnecessary disk writing if the pages are
never written before being reclaimed.

So, change pte_mkwrite_novma() to clear the PTE_RDONLY bit only if the
PTE_DIRTY bit is set to make it possible to make the PTE writable and
clean.

The current behavior was introduced in commit 73e86cb03cf2 ("arm64:
Move PTE_RDONLY bit handling out of set_pte_at()").  Before that,
pte_mkwrite() only sets the PTE_WRITE bit, while set_pte_at() only
clears the PTE_RDONLY bit if both the PTE_WRITE and the PTE_DIRTY bits
are set.

To test the performance impact of the patch, on an arm64 server
machine, run 16 redis-server processes on socket 1 and 16
memtier_benchmark processes on socket 0 with mostly get
transactions (that is, redis-server will mostly read memory only).
The memory footprint of redis-server is larger than the available
memory, so swap out/in will be triggered.  Test results show that the
patch can avoid most swapping out because the pages are mostly clean.
And the benchmark throughput improves ~23.9% in the test.

Fixes: 73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 0212129b13d07..92e43b3a10df9 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -184,7 +184,8 @@ static inline pmd_t set_pmd_bit(pmd_t pmd, pgprot_t prot)
 static inline pte_t pte_mkwrite_novma(pte_t pte)
 {
 	pte = set_pte_bit(pte, __pgprot(PTE_WRITE));
-	pte = clear_pte_bit(pte, __pgprot(PTE_RDONLY));
+	if (pte_sw_dirty(pte))
+		pte = clear_pte_bit(pte, __pgprot(PTE_RDONLY));
 	return pte;
 }
 
-- 
2.51.0



