Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E17221E097;
	Mon, 19 May 2025 21:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689701; cv=none; b=laszKx869fYR5pzxpZ8G0cIJM0tXLqvq2c/7gFysrfKcctDhJUUWG0E9P41Tij+4xyy8+q4oLv8oHMSWD79QCb5iHLmimk6aKbAczqKeQvOkavfSP0HwX7tDrifcpK/aebm7XqMFmeJWiG0L0DwRzQR44MA667ctRZYQKs/9sSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689701; c=relaxed/simple;
	bh=30rj3aT4x2mhiXGF1zXj6be4OgmvOdtpHNcNpqUTl/g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ov3CkAJFVKO7bTFaC08Ws7fw9SWwJ/Vdal/GgqvEjSj8NiTLMsubJATZMCiyjXIwEBmdSLx0mACEHBdncChR11lmTC9BYgToIzm1uUPQv4v14kckLwJL65ews7JabckCOAk43Em6VNjQskRHbVeNGDlZAsKU83jVR4objOPHu4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aonjhItK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aonjhItK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31153C4CEE4;
	Mon, 19 May 2025 21:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689701;
	bh=30rj3aT4x2mhiXGF1zXj6be4OgmvOdtpHNcNpqUTl/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aonjhItKF83GGcv8B7Z4WA4RTRxT1RziRn3wAXSHvxdK6Sm0LiaSxqRURK79dIB3h
	 q7FVUDDhVvyRyQoxz95gsbnW8ubYH7xQ5hlZdoHxN3gDjM9C/OhpWXBrKogdIjfCDP
	 AA58LPSu5LZB4ENLdispfYqUVLgYp95Jvb04IwlXCS8FoKHX6rFuORoM048qSmgP8s
	 8WBv/5rMqo1VH7Q71yg7JU7n7n7lagDBKZdO5kmM+wXLn6x4/hQXsBv87VqaiqnZ8w
	 hUEDQbHel8AmmUF/rLdSYpES7hLJYs7MtB5FjSAaqdKlTX9uIFPLaeYTv6saUBZWmc
	 g4gzOqTNkSpow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Paolo Pisati <paolo.pisati@canonical.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 06/23] kbuild: Require pahole <v1.28 or >v1.29 with GENDWARFKSYMS on X86
Date: Mon, 19 May 2025 17:21:13 -0400
Message-Id: <20250519212131.1985647-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212131.1985647-1-sashal@kernel.org>
References: <20250519212131.1985647-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.7
Content-Transfer-Encoding: 8bit

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

