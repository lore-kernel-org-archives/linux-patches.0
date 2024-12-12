Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F75D22A803;
	Thu, 12 Dec 2024 16:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020786; cv=none; b=t3AS7bi2Z0hJ/ETyHAVOgDY6AXMi9Nl+OwEAy//byM0SJMEu3mYbf3PFSiZEy+M4RGZXRdzdLMDuIa0Hb6LlS5QEkkISEp+Vutyb1JeXHMUqtMAiQhtf295KtTqK405j7Gf6vSvGFGA6WBursWYYcsFVcGqetANDfvnPyRaBy3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020786; c=relaxed/simple;
	bh=1p6KekLdTty4fLxW030YDUGi0E+30ed3hVbZbLICuhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFSDwPp4hrU8f7o/jN24IM6OzxmimiZANO7o6nVAhxNJaU8g0x6YN64vW2ZfQx4qXQDwSzh9zruXCSXYt6X0suuY0obb4q1nqGhZG79HILWGMwuPQ3o0QPcCPHNcD99QF+ULjoRX0kln908fzFBiP1yPKkabUfok99G6Ke8KPGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UG5xwggi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UG5xwggi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907FDC4CECE;
	Thu, 12 Dec 2024 16:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020786;
	bh=1p6KekLdTty4fLxW030YDUGi0E+30ed3hVbZbLICuhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UG5xwggiKdWvzhMxblGnTIfhvVNHY3YcLBSTyCPQuqPLo6CADmRO03QQoUBW+a4D2
	 FykEbvjYr/3cw5MJ4Qhak+ST6ouWhGfp3hC7MlcqZsxLbaVjHva/OJTxCsaaH2MNJ8
	 +995aRr8x4z7zZSASsKrNynRBup3Cg3g9Nn3ITrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 560/772] powerpc/vdso: Include CLANG_FLAGS explicitly in ldflags-y
Date: Thu, 12 Dec 2024 15:58:25 +0100
Message-ID: <20241212144413.101416305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit a7e5eb53bf9b800d086e2ebcfebd9a3bb16bd1b0 ]

A future change will move CLANG_FLAGS from KBUILD_{A,C}FLAGS to
KBUILD_CPPFLAGS so that '--target' is available while preprocessing.
When that occurs, the following error appears when building the compat
PowerPC vDSO:

  clang: error: unsupported option '-mbig-endian' for target 'x86_64-pc-linux-gnu'
  make[3]: *** [.../arch/powerpc/kernel/vdso/Makefile:76: arch/powerpc/kernel/vdso/vdso32.so.dbg] Error 1

Explicitly add CLANG_FLAGS to ldflags-y, so that '--target' will always
be present.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: d677ce521334 ("powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index 7e69e87fbf744..84a513c1af331 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -53,7 +53,7 @@ UBSAN_SANITIZE := n
 KASAN_SANITIZE := n
 
 ccflags-y := -fno-common -fno-builtin
-ldflags-y := -Wl,--hash-style=both -nostdlib -shared -z noexecstack
+ldflags-y := -Wl,--hash-style=both -nostdlib -shared -z noexecstack $(CLANG_FLAGS)
 ldflags-$(CONFIG_LD_IS_LLD) += $(call cc-option,--ld-path=$(LD),-fuse-ld=lld)
 # Filter flags that clang will warn are unused for linking
 ldflags-y += $(filter-out $(CC_FLAGS_FTRACE) -Wa$(comma)%, $(KBUILD_CFLAGS))
-- 
2.43.0



