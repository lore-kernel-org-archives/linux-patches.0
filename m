Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448CE14273
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCC+7kGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9765C433C7;
	Wed,  4 Oct 2023 18:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444473;
	bh=URyQkwBwU41rF1H3uSHW5liIDHrWLjpZoRG7ISYsCAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCC+7kGiZIxSYw+UMGoHNdpLeUdoRfKPcsjIEzWq3NxHR1Axvs5A0zNjE27z38mG/
	 YtIghZGuontW2DWDDxRQCks2+jNo0wp1SCyIrnoeKi7efg0Z6ZUmBEJ6o4QFzNe80I
	 GjwQ0VDZ0bokamwTZoxBNDTZW0OydXw4o0SE5L9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youling Tang <tangyouling@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.5 262/321] LoongArch: Add support for 32_PCREL relocation type
Date: Wed,  4 Oct 2023 19:56:47 +0200
Message-ID: <20231004175241.397428142@linuxfoundation.org>
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

commit c1c2ce2d3bf903c50f3da7346d394127ffcc93ac upstream.

When build and update kernel with the latest upstream binutils and
loongson3_defconfig, module loader fails with:

  kmod: zsmalloc: Unsupport relocation type 99, please add its support.
  kmod: fuse: Unsupport relocation type 99, please add its support.
  kmod: ipmi_msghandler: Unsupport relocation type 99, please add its support.
  kmod: ipmi_msghandler: Unsupport relocation type 99, please add its support.
  kmod: pstore: Unsupport relocation type 99, please add its support.
  kmod: drm_display_helper: Unsupport relocation type 99, please add its support.
  kmod: drm_display_helper: Unsupport relocation type 99, please add its support.
  kmod: drm_display_helper: Unsupport relocation type 99, please add its support.
  kmod: fuse: Unsupport relocation type 99, please add its support.
  kmod: fat: Unsupport relocation type 99, please add its support.

This is because the latest upstream binutils replaces a pair of ADD32
and SUB32 with 32_PCREL, so add support for 32_PCREL relocation type.

Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=ecb802d02eeb
Cc: <stable@vger.kernel.org>
Co-developed-by: Youling Tang <tangyouling@loongson.cn>
Signed-off-by: Youling Tang <tangyouling@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/module.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/loongarch/kernel/module.c
+++ b/arch/loongarch/kernel/module.c
@@ -367,6 +367,15 @@ static int apply_r_larch_got_pc(struct m
 	return apply_r_larch_pcala(mod, location, got, rela_stack, rela_stack_top, type);
 }
 
+static int apply_r_larch_32_pcrel(struct module *mod, u32 *location, Elf_Addr v,
+				  s64 *rela_stack, size_t *rela_stack_top, unsigned int type)
+{
+	ptrdiff_t offset = (void *)v - (void *)location;
+
+	*(u32 *)location = offset;
+	return 0;
+}
+
 /*
  * reloc_handlers_rela() - Apply a particular relocation to a module
  * @mod: the module to apply the reloc to
@@ -396,6 +405,7 @@ static reloc_rela_handler reloc_rela_han
 	[R_LARCH_SOP_POP_32_S_10_5 ... R_LARCH_SOP_POP_32_U] = apply_r_larch_sop_imm_field,
 	[R_LARCH_ADD32 ... R_LARCH_SUB64]		     = apply_r_larch_add_sub,
 	[R_LARCH_PCALA_HI20...R_LARCH_PCALA64_HI12]	     = apply_r_larch_pcala,
+	[R_LARCH_32_PCREL]				     = apply_r_larch_32_pcrel,
 };
 
 int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,


