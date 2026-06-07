Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AC21FE47B;
	Sun,  7 Jun 2026 10:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828245; cv=none; b=T1ZIeJrZCc9XUfWMPVi1WCL+pSwGDmjcBQ4EIPoOlF63Xr2ZQBE0kAGQnHqwsr2PYVFJU+9L579lTm1+RSYe/3GD09CqJ9U/GKFMp2gAWJh3plYSb4wRD4XJ7Xv3ktvlyx19aenJokRzM8csC1mEjQKLo24I9dptZcQkOANINyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828245; c=relaxed/simple;
	bh=B6hOUfvIr5UivY8JWmucP2bii7LUgIohkTEKDAnu7dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANSJx1lZaEEiBvRPOJjmQ/xl0a0W6LXdXHIM8ukkK8dmhVW/UiFObCNSOzeN8iZ5euAL5Gbc4LHXWgtD96z5K78voupr5WwDqO4iaGI5/eqEzqk0licNLevJQk3f1z+2bLob/7AAIZ3FMAo2u/mz85m8uwLF/+VbLF+Q98Saufs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jz9mfsZ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jz9mfsZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8822A1F00893;
	Sun,  7 Jun 2026 10:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828244;
	bh=0oyTqJrIIr1wsK6w9HRG8BM4jKhtVWDAPnQ+KeCvN+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jz9mfsZ2LO+q+GjT8lzTSiJGUVh/c86mDe3kKoJuJ2vCEb5lN0hge0KRTttjthgto
	 kJz9pKIKAUXiF2/509mGsf5sWh5v2Po6Sz5tcaIG0IjzRJ6uP4rAR1U9tK7GuFSPeq
	 DxX1CBkTjNM4+/Zv+sjmb0gqDbD6iQMz0zdwlfbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/307] arm64: io: Extract user memory type in ioremap_prot()
Date: Sun,  7 Jun 2026 11:58:40 +0200
Message-ID: <20260607095732.277639306@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
[ Modified ioremap_prot() parameter, using "unsigned long user_prot" instead of
"pgprot_t user_prot" to fix conflict with generic header ]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/io.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index e6ad41131d80b4..46bd37707e080e 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -276,10 +276,23 @@ typedef int (*ioremap_prot_hook_t)(phys_addr_t phys_addr, size_t size,
 int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
 void __iomem *__ioremap_prot(phys_addr_t phys, size_t size, pgprot_t prot);
 
-#define ioremap_prot ioremap_prot
+static inline void __iomem *ioremap_prot(phys_addr_t phys, size_t size,
+					 unsigned long user_prot)
+{
+	pgprot_t prot;
+	pteval_t user_prot_val = pgprot_val(__pgprot(user_prot));
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
2.53.0



