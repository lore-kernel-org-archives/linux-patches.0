Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1501EB5A;
	Mon,  4 Mar 2024 21:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588965; cv=none; b=lp8xzrXBlt2FLge8HMJ6Wy9uhYj/w2yMeBdHps7d73a8elGFqDfWK2OqzbWngzZxWVy8tNSNM6NJxubpKi5zB+v9d5Dsjxea/RfovjPkawD8kPhCDoZendpg9xp10US0/7ioonXjvGXfYk23xhTDKynA+VaHREgPmT9GjHo6+qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588965; c=relaxed/simple;
	bh=QoPyVRp97RCT31iPScySNQ5ZXBfETowU8X+e7+W/ktw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCoRS/HmJBuCjnFraOH6HerPR402pVqErKSKGsBn9d0o6GBGW9VnvqbBMdq0vRtrsrBhoUzIcyHXOgHkVUDu7fB6tByRJnTs5TTyF3yB8prY8ClOj8y+dDBAgcHej++Fgys+wlLrSoP8fVNw7Ksih0xw1EhQV2mamgt/YbIEOzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQfTYcp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQfTYcp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D975C433C7;
	Mon,  4 Mar 2024 21:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588965;
	bh=QoPyVRp97RCT31iPScySNQ5ZXBfETowU8X+e7+W/ktw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQfTYcp/3bhc/3hqfDpCEJMeBjPyifgGi0Cs4XX91pmS7vrgP1tY8Wuboj9+N0Tlg
	 1gNM/TxB/H+ZIK1OUgpaIz+cGX1b2BpbmlGBoS7gbDgwT41lGez1gaoiNja7X2rWrC
	 RZac46gl/KX+5YgyjFc3uMSBVQ2BQ2g7tbsIQ1GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 125/215] x86/boot/compressed: Only build mem_encrypt.S if AMD_MEM_ENCRYPT=y
Date: Mon,  4 Mar 2024 21:23:08 +0000
Message-ID: <20240304211601.033041105@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 61de13df95901bc58456bc5acdbd3c18c66cf859 upstream.

Avoid building the mem_encrypt.o object if memory encryption support is
not enabled to begin with.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-17-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/Makefile      |    2 +-
 arch/x86/boot/compressed/mem_encrypt.S |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -100,7 +100,7 @@ vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) +=
 ifdef CONFIG_X86_64
 	vmlinux-objs-y += $(obj)/ident_map_64.o
 	vmlinux-objs-y += $(obj)/idt_64.o $(obj)/idt_handlers_64.o
-	vmlinux-objs-y += $(obj)/mem_encrypt.o
+	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/mem_encrypt.o
 	vmlinux-objs-y += $(obj)/pgtable_64.o
 	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/sev.o
 endif
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -307,7 +307,6 @@ SYM_FUNC_END(startup32_check_sev_cbit)
 
 	.data
 
-#ifdef CONFIG_AMD_MEM_ENCRYPT
 	.balign	8
 SYM_DATA(sme_me_mask,		.quad 0)
 SYM_DATA(sev_status,		.quad 0)
@@ -323,4 +322,3 @@ SYM_DATA_START_LOCAL(boot32_idt_desc)
 	.word	. - boot32_idt - 1
 	.long	0
 SYM_DATA_END(boot32_idt_desc)
-#endif


