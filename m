Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02D11A6185;
	Tue, 30 Jul 2024 16:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356364; cv=none; b=cOxXSp64I/wLg+bNcXgKYBu8sOSfStw7xVHQ1sD+viGBIGGBy/z4LDWEnkCcOdyWa53BkQgDrDKY5U4qXLKLx0FUPBn8+4JKErsvMap+EoDzciUp7iP5NsNbAfO1qwo/S5+m7JtogJxbOhuDAblA3wtRfoJ3Q8eh/bZGfKqbH3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356364; c=relaxed/simple;
	bh=MblFA2xUHOX2vBHLOhXW+/UmZ74ahvgWwq7MPYb6y/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sH0d8r2SrWHcYuLlvEPltOdt5mIYeSedEOFwyzG8lwNCQkspCDG9pZkVlu4uCFW2lArm+PcuIRpNLTdAB0vS5S0HY7ry9JwLlWZQYgLyhpo5BeuV24qtYSmQ3zeA1i5ZY9JENVJGAoz5R6zryLwvrSjUSzRtkvlgaaz1ZtVvs0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tG6WVBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tG6WVBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45811C32782;
	Tue, 30 Jul 2024 16:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356364;
	bh=MblFA2xUHOX2vBHLOhXW+/UmZ74ahvgWwq7MPYb6y/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tG6WVBCTu2rhbK0Il4F03RW9bi52fAJCfdT2DYooKlv9AnShqFha21LdHNnTet6L
	 BxcxEk3SL2gXKCphQsJG36PKTmJG+QSZNnsDXDJ6qqZMGNxHM38Sr26zdrHKeLQgP9
	 CtgqfU4Ilfz9ABVviwbx/2YGOenqy7nFUJ2+nThw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 143/809] x86/sev: Do RMP memory coverage check after max_pfn has been set
Date: Tue, 30 Jul 2024 17:40:19 +0200
Message-ID: <20240730151730.255525974@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit 0440feb090790c6243bca85d6a794824e71ff26c ]

The RMP table is probed early in the boot process before max_pfn has been
set, so the logic to check if the RMP covers all of system memory is not
valid.

Move the RMP memory coverage check from snp_probe_rmptable_info() into
snp_rmptable_init(), which is well after max_pfn has been set. Also, fix
the calculation to use PFN_UP instead of PHYS_PFN, in order to compute
the required RMP size properly.

Fixes: 216d106c7ff7 ("x86/sev: Add SEV-SNP host initialization support")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/bec4364c7e34358cc576f01bb197a7796a109169.1718984524.git.thomas.lendacky@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/virt/svm/sev.c | 44 ++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 0ae10535c6999..0ce17766c0e52 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -120,7 +120,7 @@ static __init void snp_enable(void *arg)
 
 bool snp_probe_rmptable_info(void)
 {
-	u64 max_rmp_pfn, calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
+	u64 rmp_sz, rmp_base, rmp_end;
 
 	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
 	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
@@ -137,28 +137,11 @@ bool snp_probe_rmptable_info(void)
 
 	rmp_sz = rmp_end - rmp_base + 1;
 
-	/*
-	 * Calculate the amount the memory that must be reserved by the BIOS to
-	 * address the whole RAM, including the bookkeeping area. The RMP itself
-	 * must also be covered.
-	 */
-	max_rmp_pfn = max_pfn;
-	if (PHYS_PFN(rmp_end) > max_pfn)
-		max_rmp_pfn = PHYS_PFN(rmp_end);
-
-	calc_rmp_sz = (max_rmp_pfn << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
-
-	if (calc_rmp_sz > rmp_sz) {
-		pr_err("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
-		       calc_rmp_sz, rmp_sz);
-		return false;
-	}
-
 	probed_rmp_base = rmp_base;
 	probed_rmp_size = rmp_sz;
 
 	pr_info("RMP table physical range [0x%016llx - 0x%016llx]\n",
-		probed_rmp_base, probed_rmp_base + probed_rmp_size - 1);
+		rmp_base, rmp_end);
 
 	return true;
 }
@@ -206,9 +189,8 @@ void __init snp_fixup_e820_tables(void)
  */
 static int __init snp_rmptable_init(void)
 {
+	u64 max_rmp_pfn, calc_rmp_sz, rmptable_size, rmp_end, val;
 	void *rmptable_start;
-	u64 rmptable_size;
-	u64 val;
 
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return 0;
@@ -219,10 +201,28 @@ static int __init snp_rmptable_init(void)
 	if (!probed_rmp_size)
 		goto nosnp;
 
+	rmp_end = probed_rmp_base + probed_rmp_size - 1;
+
+	/*
+	 * Calculate the amount the memory that must be reserved by the BIOS to
+	 * address the whole RAM, including the bookkeeping area. The RMP itself
+	 * must also be covered.
+	 */
+	max_rmp_pfn = max_pfn;
+	if (PFN_UP(rmp_end) > max_pfn)
+		max_rmp_pfn = PFN_UP(rmp_end);
+
+	calc_rmp_sz = (max_rmp_pfn << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
+	if (calc_rmp_sz > probed_rmp_size) {
+		pr_err("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
+		       calc_rmp_sz, probed_rmp_size);
+		goto nosnp;
+	}
+
 	rmptable_start = memremap(probed_rmp_base, probed_rmp_size, MEMREMAP_WB);
 	if (!rmptable_start) {
 		pr_err("Failed to map RMP table\n");
-		return 1;
+		goto nosnp;
 	}
 
 	/*
-- 
2.43.0



