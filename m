Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD2418787A;
	Sat, 17 Oct 2026 15:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252612; cv=none; b=gpUasaEKjrceWJF/3sQXuZgu5Urv5jUhduaZb2L1pjgzLRlAkauO/PMo43wESP5KZbOBhV2aZk4i+L4clZQvPwkZa8XqqzFuFj4Pt9c7SXLkwjxADas5Hi93l/cEgtaqZUF5KPB2yjbM+hPTHJibMrY+wpNZmtTGMUAYV/I/6BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252612; c=relaxed/simple;
	bh=lDimzYhRolPapeoWAebTW/ZaHIY2UsvUvXxq0HE1hbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mHpNhcv3pi2ZVTLQ3dpr8iJKsls/9d/RWtiKkI3MrvMQpE5ZLgV5b6apwq6DonVd8V9yWwdDHEAZiwkGS3hskvrsBhnoCOR7DmYDV664QNMAGUzimWD0uEtNL3LhZNcpu/oWasX0wL/ZGs86q9quAyl4OneOd4VAp0cin0VuE3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6486kik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6486kik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882C61F000C4;
	Sat, 17 Oct 2026 15:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252611;
	bh=OQ0xEGxrwPTLnmLYyjXyqb9laElUkHc3yk2EJfBnOEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6486kikiFPrxYsXUc+9N2TkjOkVyknkOg2BQgAztm1HllTi3npJETNs80B+7Hsgp
	 BRMKb8MoOpdD3Xxf0GMF5HAbvNKHji4RaF3AM7SHHXwpu3nEWkuzxZ7lHa4bTb070A
	 xTusyabOIDTSyBEDrghCMRmPIxxcKE4lrgUg/kZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 20/52] riscv: patch: Avoid early phys_to_page()
Date: Sat, 17 Oct 2026 17:54:21 +0200
Message-ID: <20261017155105.509422975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index db13c9ddf9e3d..16b243376f362 100644
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



