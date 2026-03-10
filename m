Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7242BF3E2;
	Tue, 10 Mar 2026 11:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141064; cv=none; b=JAJVkHgDQT6GV+zTFkhNKo2IH+5GhDxiA+mHwOnZKVM5nhHQjU6nzCxLaY/ecmGNCNqcSk2kJBWYTnHC93hEyCz/y+k3QvGJtWzyLCSNanLBoYSOJjWt6S6XvfCyy2u5rfa3R+iLI/SkJHW84AY6jEnrWOcyuG/AeVOFUtnUNLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141064; c=relaxed/simple;
	bh=29QlYA/pv8CUlbtBqeGD0NiZBFv15xML1hQZ593EqzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLg99TOqpR7j7nyBHj+3NL7FfLwap/SHhn1MasKGboFQTsqY3NzgxRZAOyj7stlp1KNRfbpBpV55UmdogA+hGqkcNb3eCfNYptzeW9ozfxVA/7CEr4tCIRivDiSEIKo999AkrhUmkaV7/LHu0FDd/fVZiy5GdnNucbzajIXhwtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cd6L56SA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cd6L56SA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A757EC2BCB0;
	Tue, 10 Mar 2026 11:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141064;
	bh=29QlYA/pv8CUlbtBqeGD0NiZBFv15xML1hQZ593EqzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cd6L56SAZXm5RmJEXCZACG4xkeDh53YU3oDHxng2mCDDYZomHh/1WIIlWqizxLvU3
	 tDXBS/ECSf4gKuA7eovnPg9jk/LswCTv6sCnvy8o92ujnN6Y73XhwX0SnUoglQFreT
	 Nqa2WIK4XcgAHYhyucx+4UWcEG98PdTJUliKn9Y4SKWGqN0P4UhtN+zilRnV5U+qFQ
	 jdsHBKJUy1sxWAjePXCORZIY/saFpgziaIpbDjgARizB8eI1ivQTet3Y7bHd96DJwJ
	 w5D/WnoA536ad2kFzUYuY9ohwOBVmicl//5PKybmNrChguumObLAaF3NPUVDcGpd6p
	 k+1qQaNaesIbA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Zeng Heng <zengheng4@huawei.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 064/311] arm64: io: Extract user memory type in ioremap_prot()
Date: Tue, 10 Mar 2026 07:01:51 -0400
Message-ID: <61e65a309b85ef60b626e66ff7dd5e7132f85bd4.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Will Deacon <will@kernel.org>

[ Upstream commit 8f098037139b294050053123ab2bc0f819d08932 ]

The only caller of ioremap_prot() outside of the generic ioremap()
implementation is generic_access_phys(), which passes a 'pgprot_t' value
determined from the user mapping of the target 'pfn' being accessed by
the kernel. On arm64, the 'pgprot_t' contains all of the non-address
bits from the pte, including the permission controls, and so we end up
returning a new user mapping from ioremap_prot() which faults when
accessed from the kernel on systems with PAN:

  | Unable to handle kernel read from unreadable memory at virtual address ffff80008ea89000
  | ...
  | Call trace:
  |   __memcpy_fromio+0x80/0xf8
  |   generic_access_phys+0x20c/0x2b8
  |   __access_remote_vm+0x46c/0x5b8
  |   access_remote_vm+0x18/0x30
  |   environ_read+0x238/0x3e8
  |   vfs_read+0xe4/0x2b0
  |   ksys_read+0xcc/0x178
  |   __arm64_sys_read+0x4c/0x68

Extract only the memory type from the user 'pgprot_t' in ioremap_prot()
and assert that we're being passed a user mapping, to protect us against
any changes in future that may require additional handling. To avoid
falsely flagging users of ioremap(), provide our own ioremap() macro
which simply wraps __ioremap_prot().

Cc: Zeng Heng <zengheng4@huawei.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 893dea9ccd08 ("arm64: Add HAVE_IOREMAP_PROT support")
Reported-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/io.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index cd2fddfe814ac..8cbd1e96fd50b 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -266,10 +266,23 @@ typedef int (*ioremap_prot_hook_t)(phys_addr_t phys_addr, size_t size,
 int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
 void __iomem *__ioremap_prot(phys_addr_t phys, size_t size, pgprot_t prot);
 
-#define ioremap_prot __ioremap_prot
+static inline void __iomem *ioremap_prot(phys_addr_t phys, size_t size,
+					 pgprot_t user_prot)
+{
+	pgprot_t prot;
+	ptdesc_t user_prot_val = pgprot_val(user_prot);
+
+	if (WARN_ON_ONCE(!(user_prot_val & PTE_USER)))
+		return NULL;
 
-#define _PAGE_IOREMAP PROT_DEVICE_nGnRE
+	prot = __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK,
+			       user_prot_val & PTE_ATTRINDX_MASK);
+	return __ioremap_prot(phys, size, prot);
+}
+#define ioremap_prot ioremap_prot
 
+#define ioremap(addr, size)	\
+	__ioremap_prot((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define ioremap_wc(addr, size)	\
 	__ioremap_prot((addr), (size), __pgprot(PROT_NORMAL_NC))
 #define ioremap_np(addr, size)	\
-- 
2.51.0

