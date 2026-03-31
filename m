Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E6D3E316C;
	Tue, 31 Mar 2026 16:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974274; cv=none; b=S5tfvMfSe05EMlqjdiVDa5wmrLCFUMGuBIf1p4yRJ/dG8TX6rzbnJKyDY6Bhfoga67htuI8V/XxM4zTsa6aujYKi7co4sw6qR2KkycaKC/O23ukd1zo+cqx3MTKsuBfn9pc9eb3vmWYCbUxaq4qWeZeWZKJz+nODDfEZcC8Nn+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974274; c=relaxed/simple;
	bh=AGAGt/IILTDmF0A9Ntac58v7eUv+arNLYn12DGn8K7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6i/nxp/inCxu7960FNuZZ/21LpS8s1Z7v8j485pcN5PS7mVdsHt6jVgddFFad5xLrPQyuMuI9srQbZUj29rMX/vUPwBGFgknQjmv2e47cEVcQAn656yeumFEbyE3O1vnfKoYVFPbiBn2ybqCO2/r1+rxay7YfjTifQdg4fGvyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeJbgjCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeJbgjCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D22FC19423;
	Tue, 31 Mar 2026 16:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974273;
	bh=AGAGt/IILTDmF0A9Ntac58v7eUv+arNLYn12DGn8K7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeJbgjCIh1cbtfT0I4xbIBTOJ3pyU23UgTEEBe9Z5X7n5Je/tAiv2qmtFazZ1pPNL
	 0PjSFufU7fFei3Uq/nXQKXnXEO7fzpWrnXUkeZ9hTnAjWElxWI6w0utwYuIuek0Lv6
	 0uANRu68N2fKUyzA21cwCGecDShEmfbg3ZGwx59s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Daniel Gomez <da.gomez@samsung.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/175] module: Fix kernel panic when a symbol st_shndx is out of bounds
Date: Tue, 31 Mar 2026 18:20:06 +0200
Message-ID: <20260331161730.597914430@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit f9d69d5e7bde2295eb7488a56f094ac8f5383b92 ]

The module loader doesn't check for bounds of the ELF section index in
simplify_symbols():

       for (i = 1; i < symsec->sh_size / sizeof(Elf_Sym); i++) {
		const char *name = info->strtab + sym[i].st_name;

		switch (sym[i].st_shndx) {
		case SHN_COMMON:

		[...]

		default:
			/* Divert to percpu allocation if a percpu var. */
			if (sym[i].st_shndx == info->index.pcpu)
				secbase = (unsigned long)mod_percpu(mod);
			else
  /** HERE --> **/		secbase = info->sechdrs[sym[i].st_shndx].sh_addr;
			sym[i].st_value += secbase;
			break;
		}
	}

A symbol with an out-of-bounds st_shndx value, for example 0xffff
(known as SHN_XINDEX or SHN_HIRESERVE), may cause a kernel panic:

  BUG: unable to handle page fault for address: ...
  RIP: 0010:simplify_symbols+0x2b2/0x480
  ...
  Kernel panic - not syncing: Fatal exception

This can happen when module ELF is legitimately using SHN_XINDEX or
when it is corrupted.

Add a bounds check in simplify_symbols() to validate that st_shndx is
within the valid range before using it.

This issue was discovered due to a bug in llvm-objcopy, see relevant
discussion for details [1].

[1] https://lore.kernel.org/linux-modules/20251224005752.201911-1-ihor.solodrai@linux.dev/

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 627680e568fcc..76d90c20de674 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1424,6 +1424,13 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 			break;
 
 		default:
+			if (sym[i].st_shndx >= info->hdr->e_shnum) {
+				pr_err("%s: Symbol %s has an invalid section index %u (max %u)\n",
+				       mod->name, name, sym[i].st_shndx, info->hdr->e_shnum - 1);
+				ret = -ENOEXEC;
+				break;
+			}
+
 			/* Divert to percpu allocation if a percpu var. */
 			if (sym[i].st_shndx == info->index.pcpu)
 				secbase = (unsigned long)mod_percpu(mod);
-- 
2.51.0



