Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A18BAD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6333C433C1;
	Thu, 27 Oct 2022 17:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890212;
	bh=DkYr3Qm0PUnrO3mwNXjgXtHcLfaQTljJcwpXKWr9D5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zHxE1A+Ur+21ZoJBIa14733YRdEygg4fc4t8cWq1J2UsffGEAragT2VfWoY6oTnTo
	 AexL++nk57rltlNfzxspsBATMO1eeU7mQXMEsIS4FHy4JYBLRFtMvBfiNWJMntG23s
	 3Y56w+19dXj2YblNXtu6UN0qUvVac0KT9GDIuUOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Mortensen <will@extrahop.com>,
	Charlotte Tan <charlotte@extrahop.com>,
	Aaron Tomlin <atomlin@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 65/79] iommu/vt-d: Allow NVS regions in arch_rmrr_sanity_check()
Date: Thu, 27 Oct 2022 18:56:03 +0200
Message-Id: <20221027165057.079308170@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Charlotte Tan <charlotte@extrahop.com>

[ Upstream commit 5566e68d829f5d87670d5984c1c2ccb4c518405f ]

arch_rmrr_sanity_check() warns if the RMRR is not covered by an ACPI
Reserved region, but it seems like it should accept an NVS region as
well. The ACPI spec
https://uefi.org/specs/ACPI/6.5/15_System_Address_Map_Interfaces.html
uses similar wording for "Reserved" and "NVS" region types; for NVS
regions it says "This range of addresses is in use or reserved by the
system and must not be used by the operating system."

There is an old comment on this mailing list that also suggests NVS
regions should pass the arch_rmrr_sanity_check() test:

 The warnings come from arch_rmrr_sanity_check() since it checks whether
 the region is E820_TYPE_RESERVED. However, if the purpose of the check
 is to detect RMRR has regions that may be used by OS as free memory,
 isn't  E820_TYPE_NVS safe, too?

This patch overlaps with another proposed patch that would add the region
type to the log since sometimes the bug reporter sees this log on the
console but doesn't know to include the kernel log:

https://lore.kernel.org/lkml/20220611204859.234975-3-atomlin@redhat.com/

Here's an example of the "Firmware Bug" apparent false positive (wrapped
for line length):

 DMAR: [Firmware Bug]: No firmware reserved region can cover this RMRR
       [0x000000006f760000-0x000000006f762fff], contact BIOS vendor for
       fixes
 DMAR: [Firmware Bug]: Your BIOS is broken; bad RMRR
       [0x000000006f760000-0x000000006f762fff]

This is the snippet from the e820 table:

 BIOS-e820: [mem 0x0000000068bff000-0x000000006ebfefff] reserved
 BIOS-e820: [mem 0x000000006ebff000-0x000000006f9fefff] ACPI NVS
 BIOS-e820: [mem 0x000000006f9ff000-0x000000006fffefff] ACPI data

Fixes: f036c7fa0ab6 ("iommu/vt-d: Check VT-d RMRR region in BIOS is reported as reserved")
Cc: Will Mortensen <will@extrahop.com>
Link: https://lore.kernel.org/linux-iommu/64a5843d-850d-e58c-4fc2-0a0eeeb656dc@nec.com/
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216443
Signed-off-by: Charlotte Tan <charlotte@extrahop.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Link: https://lore.kernel.org/r/20220929044449.32515-1-charlotte@extrahop.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/iommu.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index bf1ed2ddc74b..7a983119bc40 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -17,8 +17,10 @@ arch_rmrr_sanity_check(struct acpi_dmar_reserved_memory *rmrr)
 {
 	u64 start = rmrr->base_address;
 	u64 end = rmrr->end_address + 1;
+	int entry_type;
 
-	if (e820__mapped_all(start, end, E820_TYPE_RESERVED))
+	entry_type = e820__get_entry_type(start, end);
+	if (entry_type == E820_TYPE_RESERVED || entry_type == E820_TYPE_NVS)
 		return 0;
 
 	pr_err(FW_BUG "No firmware reserved region can cover this RMRR [%#018Lx-%#018Lx], contact BIOS vendor for fixes\n",
-- 
2.35.1



