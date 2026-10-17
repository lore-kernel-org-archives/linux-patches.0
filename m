Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F36382F25;
	Sat, 17 Oct 2026 16:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253177; cv=none; b=OJ7KJyyhkRALu5056nd/HtyxuIqedJkhbHm+WSjvczoohqWUpR4spv59KXfhTVW9JRYCIScXoaxAc+2Fo6UN598n0Okm3LdULPN7I0YT0cz5b5dFpVPGtKa7w4G6VbfWX6QhqvTxPVNgiWxmJPEHJzMU+YaXNZMLEHPrYtErMII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253177; c=relaxed/simple;
	bh=B56Vj3fzqpOtpi+pvxPynCS0f02whqix21EcfA82u6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tnHDmivyznyf2caMcCdiRB3dVsQEnZej/lx+Efq/UTdi61g6YDuncx+nWxW4hD+ulhvsu3O/4Dx3vH9IJIPFywb9YD0yH+mqGhEbSTVndrZzmzc6k46sL4JOlPaT15nj6ksWrZaGGDRgPQLOx3cmW5JT8cuBUnkWeztf37MD3aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m07rI0VT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m07rI0VT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413BF1F000C4;
	Sat, 17 Oct 2026 16:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253175;
	bh=Bm0fEe2/+uAJED/vxxIf85vnf0dgloWJxf0kI+5XSMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m07rI0VT72Xj3KmkZXRAbBAy06KJQRtqEcoIp1XJDyLWkMuP0pi1xO5v7nb1WQn55
	 VkB8eAAlyPK8hItLkUWJNTex50+IdRQRMFUAH/28xV8XmPkYTHJxRIWwxuGu/xzTJT
	 h2KaUKIAJMDv11nhFOzIttHQaW/2CEPAHYmCheXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/869] riscv: patch: Avoid early phys_to_page()
Date: Sat, 17 Oct 2026 17:47:56 +0200
Message-ID: <20261017160037.914044169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivian Wang <wangruikang@iscas.ac.cn>

[ Upstream commit 6b60a128c2f43180664a614830f3c529497e0394 ]

Similarly to commit 8d09e2d569f6 ("arm64: patching: avoid early
page_to_phys()"), avoid using phys_to_page() for the kernel address case
in patch_map().

Since this is called from apply_boot_alternatives() in setup_arch(), and
commit 4267739cabb8 ("arch, mm: consolidate initialization of SPARSE
memory model") has moved sparse_init() to after setup_arch(),
phys_to_page() is not available there yet, and it panics on boot with
SPARSEMEM on RV32, which does not use SPARSEMEM_VMEMMAP.

Reported-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Closes: https://lore.kernel.org/r/20260223144108-dcace0b9-02e8-4b67-a7ce-f263bed36f26@linutronix.de/
Fixes: 4267739cabb8 ("arch, mm: consolidate initialization of SPARSE memory model")
Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260310-riscv-sparsemem-alternatives-fix-v1-1-659d5dd257e2@iscas.ac.cn
[pjw@kernel.org: fix the subject line to align with the patch description]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Stable-dep-of: a510e1ae8c90 ("riscv: patch: fix handling of bpf-jit execmem addresses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/patch.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index 34ef522f07a8c..f8826f1595e16 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -42,19 +42,20 @@ static inline bool is_kernel_exittext(uintptr_t addr)
 static __always_inline void *patch_map(void *addr, const unsigned int fixmap)
 {
 	uintptr_t uintaddr = (uintptr_t) addr;
-	struct page *page;
+	phys_addr_t phys;
 
-	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr))
-		page = phys_to_page(__pa_symbol(addr));
-	else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
-		page = vmalloc_to_page(addr);
-	else
-		return addr;
+	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr)) {
+		phys = __pa_symbol(addr);
+	} else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX)) {
+		struct page *page = vmalloc_to_page(addr);
 
-	BUG_ON(!page);
+		BUG_ON(!page);
+		phys = page_to_phys(page) + offset_in_page(addr);
+	} else {
+		return addr;
+	}
 
-	return (void *)set_fixmap_offset(fixmap, page_to_phys(page) +
-					 offset_in_page(addr));
+	return (void *)set_fixmap_offset(fixmap, phys);
 }
 
 static void patch_unmap(int fixmap)
-- 
2.53.0



