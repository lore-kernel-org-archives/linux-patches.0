Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915831ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FAEC433C9;
	Tue, 25 Jul 2023 11:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285754;
	bh=HsjOsyZpM0XOvf7Yw5OEliG1tMtf61Syx8aBjyVFuTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxkp68D5iVVcRLK+f0WmBUrkdWkAPpCI1wVqL7FE8viu3G++uXrmzvdH15nuuACVU
	 Ja4lxjZ+bcflp8RN6HsWFZbTc0fkXqq1YxFKthCWwM5/Mo7n4K6jdgxrt1cdAYkv2B
	 NBOdMZ8wIlCxVSWUkYHNWuTOkNspmErrNjTqr4Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Russell King <linux@armlinux.org.uk>,
	Steve Capper <steve.capper@arm.com>,
	Will Deacon <will@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 289/313] arm64: mm: fix VA-range sanity check
Date: Tue, 25 Jul 2023 12:47:22 +0200
Message-ID: <20230725104533.604140391@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit ab9b4008092c86dc12497af155a0901cc1156999 ]

Both create_mapping_noalloc() and update_mapping_prot() sanity-check
their 'virt' parameter, but the check itself doesn't make much sense.
The condition used today appears to be a historical accident.

The sanity-check condition:

	if ((virt >= PAGE_END) && (virt < VMALLOC_START)) {
		[ ... warning here ... ]
		return;
	}

... can only be true for the KASAN shadow region or the module region,
and there's no reason to exclude these specifically for creating and
updateing mappings.

When arm64 support was first upstreamed in commit:

  c1cc1552616d0f35 ("arm64: MMU initialisation")

... the condition was:

	if (virt < VMALLOC_START) {
		[ ... warning here ... ]
		return;
	}

At the time, VMALLOC_START was the lowest kernel address, and this was
checking whether 'virt' would be translated via TTBR1.

Subsequently in commit:

  14c127c957c1c607 ("arm64: mm: Flip kernel VA space")

... the condition was changed to:

	if ((virt >= VA_START) && (virt < VMALLOC_START)) {
		[ ... warning here ... ]
		return;
	}

This appear to have been a thinko. The commit moved the linear map to
the bottom of the kernel address space, with VMALLOC_START being at the
halfway point. The old condition would warn for changes to the linear
map below this, and at the time VA_START was the end of the linear map.

Subsequently we cleaned up the naming of VA_START in commit:

  77ad4ce69321abbe ("arm64: memory: rename VA_START to PAGE_END")

... keeping the erroneous condition as:

	if ((virt >= PAGE_END) && (virt < VMALLOC_START)) {
		[ ... warning here ... ]
		return;
	}

Correct the condition to check against the start of the TTBR1 address
space, which is currently PAGE_OFFSET. This simplifies the logic, and
more clearly matches the "outside kernel range" message in the warning.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20230615102628.1052103-1-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 5cf575f23af28..8e934bb44f12e 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -399,7 +399,7 @@ static phys_addr_t pgd_pgtable_alloc(int shift)
 static void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
 				  phys_addr_t size, pgprot_t prot)
 {
-	if ((virt >= PAGE_END) && (virt < VMALLOC_START)) {
+	if (virt < PAGE_OFFSET) {
 		pr_warn("BUG: not creating mapping for %pa at 0x%016lx - outside kernel range\n",
 			&phys, virt);
 		return;
@@ -426,7 +426,7 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 				phys_addr_t size, pgprot_t prot)
 {
-	if ((virt >= PAGE_END) && (virt < VMALLOC_START)) {
+	if (virt < PAGE_OFFSET) {
 		pr_warn("BUG: not updating mapping for %pa at 0x%016lx - outside kernel range\n",
 			&phys, virt);
 		return;
-- 
2.39.2



