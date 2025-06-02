Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397E122AE7C;
	Mon,  2 Jun 2025 14:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873234; cv=none; b=eqy7bU/Zu4gpnzZxepwkUjHKRIDcC2yLKveiZcXipc9WL+VtteVH4IdkPj7Fi+PpDor96ZxM6kyT9kxBLa7g6QAPHnN8KOFFqGS7WaRUFYX7Mg8thk6zeEUIUrKGFSwXq9fhmcdXqKjOZlB1wkFzP8YIJD87Z+A7KJHGu5nclMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873234; c=relaxed/simple;
	bh=8pBTdPVml3yNlr97X8schvnGc1j2V44Jn2gaQBFF2xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcdzsejlKqtHailUNLRE+uOi+cgn9X6Zu7/Q5eE5RPzAeoxF9bHglrip0M9dwn/MWb47yw/rbVjANsHVU3zMMox237blfww0uoDNJSfpJzPDn67xy9QeWDKX+UOZWmnSjmqe2Pr/87PfcY4GVTAFrSNpzpvqzSr+NoO4LXeIm/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mINA3qHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mINA3qHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575FBC4CEEB;
	Mon,  2 Jun 2025 14:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873233;
	bh=8pBTdPVml3yNlr97X8schvnGc1j2V44Jn2gaQBFF2xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mINA3qHkmbrNDTtskFYh9f955y416PBWB6m0B2zwVuO25rZCXW9bU17fwK0bY3yj2
	 OJubB9N4UmvACsYTE05YoTjc9sAP52cGKdPnjBBNgNRcPax5hocmd+ZPhWCkrlW49O
	 ZdjhQwnLyKoW0oKU1Px4AFPkU8qjl60Qt3PocR2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Jesse Taube <mr.bossman075@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/444] riscv: Allow NOMMU kernels to access all of RAM
Date: Mon,  2 Jun 2025 15:41:52 +0200
Message-ID: <20250602134342.878370449@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit 2c0391b29b27f315c1b4c29ffde66f50b29fab99 ]

NOMMU kernels currently cannot access memory below the kernel link
address. Remove this restriction by setting PAGE_OFFSET to the actual
start of RAM, as determined from the devicetree. The kernel link address
must be a constant, so keep using CONFIG_PAGE_OFFSET for that purpose.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Jesse Taube <mr.bossman075@gmail.com>
Link: https://lore.kernel.org/r/20241026171441.3047904-3-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/page.h    | 12 ++++--------
 arch/riscv/include/asm/pgtable.h |  2 +-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/include/asm/page.h b/arch/riscv/include/asm/page.h
index 4d1f58848129e..dbb9d0d0f405e 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -26,12 +26,9 @@
  * When not using MMU this corresponds to the first free page in
  * physical memory (aligned on a page boundary).
  */
-#ifdef CONFIG_64BIT
 #ifdef CONFIG_MMU
+#ifdef CONFIG_64BIT
 #define PAGE_OFFSET		kernel_map.page_offset
-#else
-#define PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
-#endif
 /*
  * By default, CONFIG_PAGE_OFFSET value corresponds to SV57 address space so
  * define the PAGE_OFFSET value for SV48 and SV39.
@@ -41,6 +38,9 @@
 #else
 #define PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 #endif /* CONFIG_64BIT */
+#else
+#define PAGE_OFFSET		((unsigned long)phys_ram_base)
+#endif /* CONFIG_MMU */
 
 #ifndef __ASSEMBLY__
 
@@ -97,11 +97,7 @@ typedef struct page *pgtable_t;
 #define MIN_MEMBLOCK_ADDR      0
 #endif
 
-#ifdef CONFIG_MMU
 #define ARCH_PFN_OFFSET		(PFN_DOWN((unsigned long)phys_ram_base))
-#else
-#define ARCH_PFN_OFFSET		(PAGE_OFFSET >> PAGE_SHIFT)
-#endif /* CONFIG_MMU */
 
 struct kernel_mapping {
 	unsigned long page_offset;
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index f540b2625714d..332a6bf72b1d5 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -12,7 +12,7 @@
 #include <asm/pgtable-bits.h>
 
 #ifndef CONFIG_MMU
-#define KERNEL_LINK_ADDR	PAGE_OFFSET
+#define KERNEL_LINK_ADDR	_AC(CONFIG_PAGE_OFFSET, UL)
 #define KERN_VIRT_SIZE		(UL(-1))
 #else
 
-- 
2.39.5



