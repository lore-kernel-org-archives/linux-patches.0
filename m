Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3BA492E2A;
	Wed,  9 Sep 2026 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962583; cv=none; b=PZNBUTkh2OJKIoqf4lt4fPc8DCjqNrSY/gRaJXkG/t0SvW45mWivPDWP177j0/23Q4GRD4juzjb410It7ErJTNckP5YU3uZbkJwTHE532BK1f2D3f2MANAhoUHBbFeH69/yBWwgqfqXbOBo7IJ6TkxiCpHhjHa8KDCGj/MGwPOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962583; c=relaxed/simple;
	bh=MWnyeBEJGomljyHHuuirQgK87D/b1A8y5iew3cO131s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPfsVxgz+aJawcyI5piN8wWJlNjeVDPKx1DEjba4obLcfma4RtDwglqkGS2drKhv+tECZg589xoM1paiS0qW40X+FCcHbU76AJNX0C56HUxu9FKLKX/FBx7B//IbPj2HmK1Uy1jaRhZEMFNZ5V3RA/OgpP9fUFjsKxccGn6aBkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+HRqKAY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+HRqKAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EA91F00A3A;
	Wed,  9 Sep 2026 14:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962582;
	bh=9bqYKjUh0P0bMdg+g7RiVaGHIlF92Q0EGtUsGTXRrXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+HRqKAY/rrk369Uv2GqN+h4uE1tvJ7sUi9zixzVCkrfQKrblFsCXt0VmbC7dBSiJ
	 HZex2CT0rx0/m3CMzf2DNCUzY7/GJWff/cQRABF55QIy+Vw6oszd5YQ3i/Vq77mTNu
	 ePT4a1J9wgBK/N0VucffNK8m8uTeY/iSoxqrJKdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 338/556] LoongArch: Expand module virtual address space to 2GB
Date: Wed,  9 Sep 2026 15:40:18 +0200
Message-ID: <20260909134242.547324724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 18210a104bb97e28c26dc31fd9fc7b5c381fec62 upstream.

The current 256MB module virtual address space is easily exhausted when
loading massive graphics drivers such as amdgpu along with the large
unstripped symbol tables, resulting in allocation failures of "execmem:
unable to allocate memory".

Thus, expand the module virtual address space to 2GB while keeping
the current normal code model '-mcmodel=normal', rather than using the
medium code model '-mcmodel=medium'. This approach avoids the extra
performance overhead and larger binary size of forcing every function
call into a 2-instruction sequence of 'pcaddu18i + jirl'.

Given that individual module code segments rarely exceed 128MB, most
jumps remain fast direct calls by using the bl instruction. For the
long-distance jumps exceeding the +/-128MB limit, apply_r_larch_b26()
emits PLT entries, while signed_imm_check() guarantees the run-time
safety by rejecting any out-of-bound instruction offsets.

There is still a risk that the distance between .init.text and .text of
the same module exceeds 128MB. So we divide the 2GB virtual space to be
two sub-regions: the first 256MB is for module text, and the rest is for
module data.

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/pgtable.h |    2 +-
 arch/loongarch/mm/init.c             |   17 ++++++++++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -96,7 +96,7 @@ struct vm_area_struct;
 #ifdef CONFIG_64BIT
 
 #define MODULES_VADDR	(vm_map_base + PCI_IOSIZE + (2 * PAGE_SIZE))
-#define MODULES_END	(MODULES_VADDR + SZ_256M)
+#define MODULES_END	(MODULES_VADDR + SZ_2G) /* 256MB for text, rest for data */
 
 #ifdef CONFIG_KFENCE
 #define KFENCE_AREA_SIZE	(((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 + 2) * PAGE_SIZE)
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -237,15 +237,26 @@ pte_t invalid_pte_table[PTRS_PER_PTE] __
 EXPORT_SYMBOL(invalid_pte_table);
 
 #if defined(CONFIG_EXECMEM) && defined(MODULES_VADDR)
+#define MODULES_TEXT_START (MODULES_VADDR)
+#define MODULES_TEXT_END   (MODULES_VADDR + SZ_256M)
+#define MODULES_DATA_START (MODULES_VADDR + SZ_256M)
+#define MODULES_DATA_END   (MODULES_END)
+
 static struct execmem_info execmem_info __ro_after_init;
 
 struct execmem_info __init *execmem_arch_setup(void)
 {
 	execmem_info = (struct execmem_info){
 		.ranges = {
-			[EXECMEM_DEFAULT] = {
-				.start	= MODULES_VADDR,
-				.end	= MODULES_END,
+			[EXECMEM_MODULE_TEXT] = {
+				.start	= MODULES_TEXT_START,
+				.end	= MODULES_TEXT_END,
+				.pgprot	= PAGE_KERNEL,
+				.alignment = 1,
+			},
+			[EXECMEM_MODULE_DATA] = {
+				.start	= MODULES_DATA_START,
+				.end	= MODULES_DATA_END,
 				.pgprot	= PAGE_KERNEL,
 				.alignment = 1,
 			},


