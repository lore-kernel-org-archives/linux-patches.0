Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C4314273
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEHlxq2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A887C433CA;
	Wed,  4 Oct 2023 18:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444475;
	bh=UWdoLL4FDL9sgllCdc6SjV6qklYeQMMCbbFBvQjoh44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEHlxq2q8KNzY61FJUQH5RGKpK7KflmegURiqNJoAX7xJ/E6fuZsLYVSlbCD3Zk2Y
	 MYJixPah0Crvs7JIOniksmjDJc/ksYaobxrLYgaInszSx7KtlaAbBH1OGDrRMcOLWh
	 Pzhi0CDdcQtCz0CI1QCp5xP1J3UAnsJFksIucZLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.5 263/321] LoongArch: Add support for 64_PCREL relocation type
Date: Wed,  4 Oct 2023 19:56:48 +0200
Message-ID: <20231004175241.446306828@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit b1dc55a3d6a86cc2c1ae664ad7280bff4c0fc28f upstream.

When build and update kernel with the latest upstream binutils and
loongson3_defconfig, module loader fails with:

  kmod: zsmalloc: Unknown relocation type 109
  kmod: fuse: Unknown relocation type 109
  kmod: fuse: Unknown relocation type 109
  kmod: radeon: Unknown relocation type 109
  kmod: nf_tables: Unknown relocation type 109
  kmod: nf_tables: Unknown relocation type 109

This is because the latest upstream binutils replaces a pair of ADD64
and SUB64 with 64_PCREL, so add support for 64_PCREL relocation type.

Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=ecb802d02eeb
Cc: <stable@vger.kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/module.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/loongarch/kernel/module.c
+++ b/arch/loongarch/kernel/module.c
@@ -376,6 +376,15 @@ static int apply_r_larch_32_pcrel(struct
 	return 0;
 }
 
+static int apply_r_larch_64_pcrel(struct module *mod, u32 *location, Elf_Addr v,
+				  s64 *rela_stack, size_t *rela_stack_top, unsigned int type)
+{
+	ptrdiff_t offset = (void *)v - (void *)location;
+
+	*(u64 *)location = offset;
+	return 0;
+}
+
 /*
  * reloc_handlers_rela() - Apply a particular relocation to a module
  * @mod: the module to apply the reloc to
@@ -406,6 +415,7 @@ static reloc_rela_handler reloc_rela_han
 	[R_LARCH_ADD32 ... R_LARCH_SUB64]		     = apply_r_larch_add_sub,
 	[R_LARCH_PCALA_HI20...R_LARCH_PCALA64_HI12]	     = apply_r_larch_pcala,
 	[R_LARCH_32_PCREL]				     = apply_r_larch_32_pcrel,
+	[R_LARCH_64_PCREL]				     = apply_r_larch_64_pcrel,
 };
 
 int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,


