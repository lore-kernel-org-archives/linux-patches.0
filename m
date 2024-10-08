Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8283C0C;
	Tue,  8 Oct 2024 04:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728361354; cv=none; b=bGC7fDKKDSptL0o9xRwf402vQ2odJURscxelGn/JWaZdNFD55EbUP97/CCdGCet8uRy/eDEMqQ9MiUA2KqJZeQpnqIAJAv4TvfYj0E8JqVRXPWiFo0ZmfpL7tJtIiDX9Wau2IrW8VDF0ZmXCVHiss9GdUfnXlcdG7P+onxytG0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728361354; c=relaxed/simple;
	bh=+wY/P7Mzm/p1v2vQEghvlVOqCHOLAZoABB4rJCcKJzw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lLcrU22JP1TLg22IiGu5tnDS0DnyGj97sa/Z0kCy2zEGBVDizg1uLRIGrJjOgMf6vLpn5BLj14S0M5pdhgnAEI9ZulL9g3XW2qsWZTDj5eHqsO9JtTjrjoMjqFESAsdPa8iyDd3EyBCi92ncI1rWQalVEDXRSlr0MAsQvtzEfq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gthp3Bj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gthp3Bj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27873C4CECC;
	Tue,  8 Oct 2024 04:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728361353;
	bh=+wY/P7Mzm/p1v2vQEghvlVOqCHOLAZoABB4rJCcKJzw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gthp3Bj0P2AIZDnyPvPDLU5BmlPwq0tkbebnzUDYhbZ0quFE3mS9Z/hCEbP3Jrf2d
	 1ojun3a306we9Zrn0f+yEuJpDwK+34DhKew3o5il85jQq7pSHjUqMYpifqfIEjdkdy
	 aAj/nbJuv87EDF+XUXrCXPNOZkU8t61CGDRfLoVoyVwn3tixuPgkccLwps5aS0zD8T
	 OXeeuMQi/9wPPbYv/CemMHHbqlY4U2jChy8Jyqmyte+8jJW+XV9fHMcdnkxTeqbuey
	 VYSZQdtbHgw5rGxhGFfeD+vDfElwjG9DCeJ0UqdTyASQ3zi1uvuqkz6Dk7I0eiscKP
	 tLXynFvQKvuHQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 07 Oct 2024 21:22:03 -0700
Subject: [PATCH 1/3] powerpc: Fix stack protector Kconfig test for clang
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-powerpc-fix-stackprotector-test-clang-v1-1-08c15b2694e4@kernel.org>
References: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
In-Reply-To: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Keith Packard <keithp@keithp.com>, linuxppc-dev@lists.ozlabs.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2181; i=nathan@kernel.org;
 h=from:subject:message-id; bh=+wY/P7Mzm/p1v2vQEghvlVOqCHOLAZoABB4rJCcKJzw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOksm9ufuT3Z4dui5vaR+eQnZn6u/ilr5kbkLllTuyLWh
 VFi3bHDHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiP/Yz/K9eZ7fa//CFlVr9
 MWoKFcJGFyPOd6hHa836+1T7e9sPLhWG/+WVS96c/fgieYHAubu3dtsmP+R/12xSwrRK9LDBNJb
 7z7gB
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang's in-progress per-task stack protector support [1] does not work
with the current Kconfig checks because '-mstack-protector-guard-offset'
is not provided, unlike all other architecture Kconfig checks.

  $ fd Kconfig -x rg -l mstack-protector-guard-offset
  ./arch/arm/Kconfig
  ./arch/riscv/Kconfig
  ./arch/arm64/Kconfig

This produces an error from clang, which is interpreted as the flags not
being supported at all when they really are.

  $ clang --target=powerpc64-linux-gnu \
          -mstack-protector-guard=tls \
          -mstack-protector-guard-reg=r13 \
          -c -o /dev/null -x c /dev/null
  clang: error: '-mstack-protector-guard=tls' is used without '-mstack-protector-guard-offset', and there is no default

This argument will always be provided by the build system, so mirror
other architectures and use '-mstack-protector-guard-offset=0' for
testing support, which fixes the issue for clang and does not regress
support with GCC.

Link: https://github.com/llvm/llvm-project/pull/110928 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8094a01974cca1d27002720e706f66bec2a2d035..eb98050b8c016bb23887a9d669d29e69d933c9c8 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -275,8 +275,8 @@ config PPC
 	select HAVE_RSEQ
 	select HAVE_SETUP_PER_CPU_AREA		if PPC64
 	select HAVE_SOFTIRQ_ON_OWN_STACK
-	select HAVE_STACKPROTECTOR		if PPC32 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r2)
-	select HAVE_STACKPROTECTOR		if PPC64 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r13)
+	select HAVE_STACKPROTECTOR		if PPC32 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r2 -mstack-protector-guard-offset=0)
+	select HAVE_STACKPROTECTOR		if PPC64 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r13 -mstack-protector-guard-offset=0)
 	select HAVE_STATIC_CALL			if PPC32
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_VIRT_CPU_ACCOUNTING

-- 
2.47.0

