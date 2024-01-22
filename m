Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9F94F207;
	Tue, 23 Jan 2024 00:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970460; cv=none; b=uvetEDjfWv5buZLKJoN4preKH4b1vQck4Pms6azoVZ2A3vt1PukjInxWj4jfwo6YSfCYiXaMVQ/t686V0n2YZhw7Wxc2hu4UDd8Bm9XHflGI8Drl0ZwvEwwr1x7uwO4TKmx27ybuhAmj5XsIbnUOgH06fvux69jA6px+2ne97Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970460; c=relaxed/simple;
	bh=9+BTKugS12MQXoTS37yzBQJlyHLZOFqKQ328/NEoWAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlrjdslTO6+CC6UQ4Dj/ouRo47VqCBCYRBYQrZCZ68ZC5bbCHWpkL8si6gxGfsgup6yvo/hLcvH7dGmxBfzu2Ire6uZ3F53NN5HdxIVTyTiilDvUOqAkwx4M6gxhf219Yk4ClLRNK0F5sM/Puv2nZgjFDorrdG6T/ajPaGozius=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyKMolIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyKMolIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE0EC433F1;
	Tue, 23 Jan 2024 00:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970460;
	bh=9+BTKugS12MQXoTS37yzBQJlyHLZOFqKQ328/NEoWAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyKMolIrOoqBcO6ozMJhhuOMlZ9LZ9yJZO0CRvzFwu7Mp6o461I8GG65Pzkl3QC6r
	 vRPi09VdOYYsBgqekP6tFPJB5lXVUgQq3AqW06MPUmzv9YQQpXLT0PuqP1LfqhDX7l
	 O6ooKZUkofS8p+Bv/dvV1PRANouTtHnjdxjYnkZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/417] powerpc: remove checks for binutils older than 2.25
Date: Mon, 22 Jan 2024 15:52:52 -0800
Message-ID: <20240122235751.635715305@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 54a11654de163994e32b24e3aa90ef81f4a3184d ]

Commit e4412739472b ("Documentation: raise minimum supported version of
binutils to 2.25") allows us to remove the checks for old binutils.

There is no more user for ld-ifversion. Remove it as well.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230119082250.151485-1-masahiroy@kernel.org
Stable-dep-of: 1b1e38002648 ("powerpc: add crtsavres.o to always-y instead of extra-y")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile     | 17 +----------------
 arch/powerpc/lib/Makefile |  2 +-
 scripts/Makefile.compiler |  4 ----
 3 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 054844153b1f..487e4967b60d 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -42,18 +42,13 @@ machine-$(CONFIG_PPC64) += 64
 machine-$(CONFIG_CPU_LITTLE_ENDIAN) += le
 UTS_MACHINE := $(subst $(space),,$(machine-y))
 
-# XXX This needs to be before we override LD below
-ifdef CONFIG_PPC32
-KBUILD_LDFLAGS_MODULE += arch/powerpc/lib/crtsavres.o
-else
-ifeq ($(call ld-ifversion, -ge, 22500, y),y)
+ifeq ($(CONFIG_PPC64)$(CONFIG_LD_IS_BFD),yy)
 # Have the linker provide sfpr if possible.
 # There is a corresponding test in arch/powerpc/lib/Makefile
 KBUILD_LDFLAGS_MODULE += --save-restore-funcs
 else
 KBUILD_LDFLAGS_MODULE += arch/powerpc/lib/crtsavres.o
 endif
-endif
 
 ifdef CONFIG_CPU_LITTLE_ENDIAN
 KBUILD_CFLAGS	+= -mlittle-endian
@@ -391,17 +386,7 @@ endif
 endif
 
 PHONY += checkbin
-# Check toolchain versions:
-# - gcc-4.6 is the minimum kernel-wide version so nothing required.
 checkbin:
-	@if test "x${CONFIG_LD_IS_LLD}" != "xy" -a \
-		"x$(call ld-ifversion, -le, 22400, y)" = "xy" ; then \
-		echo -n '*** binutils 2.24 miscompiles weak symbols ' ; \
-		echo 'in some circumstances.' ; \
-		echo    '*** binutils 2.23 do not define the TOC symbol ' ; \
-		echo -n '*** Please use a different binutils version.' ; \
-		false ; \
-	fi
 	@if test "x${CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT}" = "xy" -a \
 		"x${CONFIG_LD_IS_BFD}" = "xy" -a \
 		"${CONFIG_LD_VERSION}" = "23700" ; then \
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 8560c912186d..b705c89f3e21 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -42,7 +42,7 @@ obj-$(CONFIG_FUNCTION_ERROR_INJECTION)	+= error-inject.o
 # 64-bit linker creates .sfpr on demand for final link (vmlinux),
 # so it is only needed for modules, and only for older linkers which
 # do not support --save-restore-funcs
-ifeq ($(call ld-ifversion, -lt, 22500, y),y)
+ifndef CONFIG_LD_IS_BFD
 extra-$(CONFIG_PPC64)	+= crtsavres.o
 endif
 
diff --git a/scripts/Makefile.compiler b/scripts/Makefile.compiler
index 158c57f2acfd..87589a7ba27f 100644
--- a/scripts/Makefile.compiler
+++ b/scripts/Makefile.compiler
@@ -72,7 +72,3 @@ clang-min-version = $(shell [ $(CONFIG_CLANG_VERSION)0 -ge $(1)0 ] && echo y)
 # ld-option
 # Usage: KBUILD_LDFLAGS += $(call ld-option, -X, -Y)
 ld-option = $(call try-run, $(LD) $(KBUILD_LDFLAGS) $(1) -v,$(1),$(2),$(3))
-
-# ld-ifversion
-# Usage:  $(call ld-ifversion, -ge, 22252, y)
-ld-ifversion = $(shell [ $(CONFIG_LD_VERSION)0 $(1) $(2)0 ] && echo $(3) || echo $(4))
-- 
2.43.0



