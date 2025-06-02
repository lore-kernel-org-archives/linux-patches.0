Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C946C1C5D72;
	Mon,  2 Jun 2025 13:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872740; cv=none; b=tBv1qOFNbWt0My3VeA4S/V/ndXgwEvsn4olK9Y2tEsH1QhEE7UF/oCUpaE/DtEr8ROOPncV8p8oQJjfbE8MBJ9DuUGEmjiFFUtIPxm9Z0hZNfzDOQ/wwWtFbgfp1E1S5P0/7lJ9FgQPlo5t2ntF8GnPF953tat0Ou/hUZAaxWrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872740; c=relaxed/simple;
	bh=lsNj/VeJ+/aSUdJuVM/ID30AGXJAUyUT+0nheGBe9M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQLMeC27NPrvmT4hub0cDU86ab43sPZlOAVOK5LZv0v6Vk39lMevPrXelm8apku8dZC0nwUMUMq3u7FCeSyq2WkOD/K3CqoFZGUfs0GFh3kaAr2AmXRYAgxqNFC3n5tGTiirH/2jmquq6ok/w2fgzN0khjL+ohdOdvLEcrZ5nKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMQbYdLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMQbYdLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16DCC4CEEB;
	Mon,  2 Jun 2025 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872739;
	bh=lsNj/VeJ+/aSUdJuVM/ID30AGXJAUyUT+0nheGBe9M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMQbYdLnsWM9vkRXr8uSLob6wl7Qoh410vKC7BSLvs5Emd5txXW8g/FElilUEnBlC
	 VDYbFnx2Y9xyFmbZ3a5a0IBvB271brnw8rtnF5nccK+yFGDHZX7jBk3Gf4G03+Xq68
	 jXA/ZCHdqmVVVxKwK8uWT1A77GqFoXGR7z+BvF3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Pisati <paolo.pisati@canonical.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 53/73] kbuild: Require pahole <v1.28 or >v1.29 with GENDWARFKSYMS on X86
Date: Mon,  2 Jun 2025 15:47:39 +0200
Message-ID: <20250602134243.784571567@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit 9520a2b3f0b5e182f73410e45b9b92ea51d9b828 ]

With CONFIG_GENDWARFKSYMS, __gendwarfksyms_ptr variables are
added to the kernel in EXPORT_SYMBOL() to ensure DWARF type
information is available for exported symbols in the TUs where
they're actually exported. These symbols are dropped when linking
vmlinux, but dangling references to them remain in DWARF.

With CONFIG_DEBUG_INFO_BTF enabled on X86, pahole versions after
commit 47dcb534e253 ("btf_encoder: Stop indexing symbols for
VARs") and before commit 9810758003ce ("btf_encoder: Verify 0
address DWARF variables are in ELF section") place these symbols
in the .data..percpu section, which results in an "Invalid
offset" error in btf_datasec_check_meta() during boot, as all
the variables are at zero offset and have non-zero size. If
CONFIG_DEBUG_INFO_BTF_MODULES is enabled, this also results in a
failure to load modules with:

  failed to validate module [$module] BTF: -22

As the issue occurs in pahole v1.28 and the fix was merged
after v1.29 was released, require pahole <v1.28 or >v1.29 when
GENDWARFKSYMS is enabled with DEBUG_INFO_BTF on X86.

Reported-by: Paolo Pisati <paolo.pisati@canonical.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/module/Kconfig b/kernel/module/Kconfig
index d7762ef5949a2..39278737bb68f 100644
--- a/kernel/module/Kconfig
+++ b/kernel/module/Kconfig
@@ -192,6 +192,11 @@ config GENDWARFKSYMS
 	depends on !DEBUG_INFO_REDUCED && !DEBUG_INFO_SPLIT
 	# Requires ELF object files.
 	depends on !LTO
+	# To avoid conflicts with the discarded __gendwarfksyms_ptr symbols on
+	# X86, requires pahole before commit 47dcb534e253 ("btf_encoder: Stop
+	# indexing symbols for VARs") or after commit 9810758003ce ("btf_encoder:
+	# Verify 0 address DWARF variables are in ELF section").
+	depends on !X86 || !DEBUG_INFO_BTF || PAHOLE_VERSION < 128 || PAHOLE_VERSION > 129
 	help
 	  Calculate symbol versions from DWARF debugging information using
 	  gendwarfksyms. Requires DEBUG_INFO to be enabled.
-- 
2.39.5



