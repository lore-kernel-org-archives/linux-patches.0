Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D8C38759A;
	Tue, 10 Mar 2026 11:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141922; cv=none; b=c1NA+WYZKwuGk3AFXSPOIFGOr5UI/As+rIq3lzJXoEbiEX+Cw1W4Trqy3XhRaOI2WXk5iFtdN7+zqR9bAR3Mm+5yT69ZEqBXdxlM6hvWFcZhxiiq6fqUB8TgcwiWsBakjVfxgxSTdwoOJthZQmvwKsno/amYrrxrVM5qx5abIhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141922; c=relaxed/simple;
	bh=29QlYA/pv8CUlbtBqeGD0NiZBFv15xML1hQZ593EqzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jokF/SZhIr1ft060gbuvN95HJByUQ5FKECv441303lGEtsHWlj12uQgx6U9cG+c38dkeirzqz71h7RxlN3PIh+CZKFrLH4RLdEK+7qfxuTuLTheass/bd01hbuhUd3RT+dHIVhQfIxzyDKRqraFiTt5fi7ESXkocih2a191I2OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ORhOCWh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORhOCWh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE85C2BCB5;
	Tue, 10 Mar 2026 11:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141922;
	bh=29QlYA/pv8CUlbtBqeGD0NiZBFv15xML1hQZ593EqzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORhOCWh1Zc3tyb2NJbqeUVy1aX5508Qqh5EZJL0NQ+pCLEcHADVgRS+n6nstsM+Jt
	 YvsfUy2Eas6P0ZhvcmUz9J7EPSwOq9QVcE+m/tCeNXfoNY63LUEp9REjlpTP1j8ZEb
	 PB0H6r0gxh+kahzh0hXRZlDVjnyoUwafNOHEJOlp6Ry83Z7ri3UjGbKBpTDS89t1/3
	 sYZA4x36oNs7pLVnbVqemB0DpZQMtKL5ENM2Cu6Ly5HWWv+qIko4DijLvxwL0x530y
	 4vrOh/O/QHqK9Nt+WRMOXoHf9EqT1z2vBAOTOd1V50fG/QEkSwBxNqN/WGFogYIUID
	 HEZUZLA5zeyaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Zeng Heng <zengheng4@huawei.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/314] arm64: io: Extract user memory type in ioremap_prot()
Date: Tue, 10 Mar 2026 07:15:05 -0400
Message-ID: <860b2bfa5cfab871edccc72dbb9959db5455ad12.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

