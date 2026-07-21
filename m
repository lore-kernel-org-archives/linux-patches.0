Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3989415F10;
	Tue, 21 Jul 2026 21:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669768; cv=none; b=R2ZyTHxRvYNUAe0OzMbqs2fxY2ibxdgx5YyJRVpVEOnF4+EqhMEixUH3C8mAiMsAaUZKsn1XE3KoV7Ql7jmTeH7/CJTFPudmQV3PskuM07FWEkQCHHhSbdIEQoUJvYGG33LDf4fsG7eJ0zbpdoKXZwIsU/DlOZjKXdEl4pSOUa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669768; c=relaxed/simple;
	bh=o2sOBOYiUR3awCLKJ/DlpzofR482VrxfqVsCEI1/F0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwiPtZJ2eq233eJld8/zi7hKo6SMrtuAEjjKEbTZr30E8jNOAv7+umpR7wU26wohIOlhxO96aDQkGF77FT/Ee5JxyKU9d7oQJ/f7PT7ZKHYnMuvvMXiwj2bcolcHm8eecb0d1PnHeQVvs3OudzEu90Jki3wBLR3y/PV/Yxo7K+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcRBrwe7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcRBrwe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431551F000E9;
	Tue, 21 Jul 2026 21:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669766;
	bh=UWY/znhiF1/W/1MufralEuvK4YxSLytYqz2x3xerCcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BcRBrwe7NNNoy6s9Y+5JGMYALtzjnocZU8xvw5DxP3MQJgSOlS7b/tseQ3yjMdgI2
	 eZqNuOZxSIsoJAFwOE0WsHJoIZwIxfxEdlLskU7aSg8zhssTpRfjroc+0gT+zBSm/7
	 Wl8ryQLwM+sjbRRmRxyxPxnEf461l7LsfOVUZPZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Barry Song <21cnbao@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Morse <james.morse@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Yang Shi <shy828301@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0679/1067] arm64/mm: convert ptep_clear() to ptep_get_and_clear()
Date: Tue, 21 Jul 2026 17:21:20 +0200
Message-ID: <20260721152439.787297992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit cbb0294fdd72a5f63ec59fad5c0a98d63bd572fc ]

ptep_clear() is a generic wrapper around the arch-implemented
ptep_get_and_clear().  We are about to convert ptep_get_and_clear() into a
public version and private version (__ptep_get_and_clear()) to support the
transparent contpte work.  We won't have a private version of ptep_clear()
so let's convert it to directly call ptep_get_and_clear().

Link: https://lkml.kernel.org/r/20240215103205.2607016-10-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ff4c5a0de1f2 ("arm64/mm: Optimize TLB flush in unmap_hotplug_[pmd|pud]_range()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/hugetlbpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 99810310efdda1..79f0d2a7768855 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -236,7 +236,7 @@ static void clear_flush(struct mm_struct *mm,
 	unsigned long i, saddr = addr;
 
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
-		ptep_clear(mm, addr, ptep);
+		ptep_get_and_clear(mm, addr, ptep);
 
 	flush_tlb_range(&vma, saddr, addr);
 }
-- 
2.53.0



