Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D22397E80;
	Tue, 21 Jul 2026 20:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666854; cv=none; b=jNd3h3Fzjt7VfzaHWiG3Clcf+TyVNuCh94Zd64YbcP1L5IhceU8uLw2OCnF5ETtGJv6JGc8nS+tuevCMXsYUvGsEAKXbkksoem9lyOyFzVUmKVEPqfUifiAmd1IrgcqxCBUGusr0jHWlsykunnMdw6WtzWeVjLgumVhOyKvp3Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666854; c=relaxed/simple;
	bh=XP19CFrcEryIF6GnCd9berjzug6vwo4kU/N/BIRxXcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruP/tgrxLk/pggDIqKl2yL+w4GYGgAqLxPamtxq2ZkxJtHEIhshXB+xkYYA55PciiazXiIBms2sHEW6xiK56L+qQZl+LMHwzHgeNiQCBlQ7u8VG85gEKzLBtcmLu4FjJ8Q7XOuQ0flLOaSrpGIofFR5yd+gMqYwo8ga7upg5cwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nr9CiRn6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nr9CiRn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6586B1F000E9;
	Tue, 21 Jul 2026 20:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666853;
	bh=2qQ8fr4abLG1Z6pjlUOyMwx/DTZkuUS+A1MXLRNYbMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nr9CiRn67miz62h61DTcxZIuk5GqgtM+W5gcqpZmwtr0sxwwIBjBfgaodg8KQ+NbW
	 /KEsX3xsos+d6ngLAlNOEx4CGU+v02qdlP0tn/M/JEI6Hcxjfnw9a4bO4gsyq+WaK1
	 IehKCyt1tLL2gBfAwljJ6GuRgfvTpUDY5NYLfh9o=
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
Subject: [PATCH 6.6 0841/1266] arm64/mm: convert ptep_clear() to ptep_get_and_clear()
Date: Tue, 21 Jul 2026 17:21:18 +0200
Message-ID: <20260721152500.675339982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 398310ce919614..688d11b1cabdb4 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -228,7 +228,7 @@ static void clear_flush(struct mm_struct *mm,
 	unsigned long i, saddr = addr;
 
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
-		ptep_clear(mm, addr, ptep);
+		ptep_get_and_clear(mm, addr, ptep);
 
 	flush_tlb_range(&vma, saddr, addr);
 }
-- 
2.53.0



