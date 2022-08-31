Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DE72F5D;
	Wed, 31 Aug 2022 15:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89678C433C1;
	Wed, 31 Aug 2022 15:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1661959298;
	bh=DTL+LV2yF2EH+15dxhJXJ7zmzomlghacq3fufP//T8g=;
	h=From:To:Cc:Subject:Date:From;
	b=uXMTB1pzQhVDzse2eYe/8fReXNqRMnQhKSVL2CIhKlqloRVvQDRTOewBE7hor/JOx
	 d/aUvJZzk9oOiwH1rnRAuSiZxyCYYnjYaAT5jGThcsse21w1aulO8aykX5M27CyXQd
	 mGY1POf0PmgNFhpHCnYtEdDXjim59m3G4gHxRyPn0Nj7eOHZNHFVGeETdKnw5rlXDp
	 rCz4IsOUdTy235EpZoMo88pmu2v66QVenNSHBrOmOXoeGz4T59FkekGj6XoTNlK7v+
	 y6NCuqG5j114iAEwU0jGIHlOuoDQlW0EDyRoZtTncI9XQwb+Adh+R+ck7m15a1Wrzc
	 AC7kEk7O3SbwA==
From: Nathan Chancellor <nathan@kernel.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] powerpc/math_emu/efp: Include module.h
Date: Wed, 31 Aug 2022 08:20:15 -0700
Message-Id: <20220831152014.3501664-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building with a recent version of clang, there are a couple of
errors around the call to module_init():

  arch/powerpc/math-emu/math_efp.c:927:1: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
  module_init(spe_mathemu_init);
  ^
  int
  arch/powerpc/math-emu/math_efp.c:927:13: error: a parameter list without types is only allowed in a function definition
  module_init(spe_mathemu_init);
              ^
  2 errors generated.

module_init() is a macro, which is not getting expanded because module.h
is not included in this file. Add the include so that the macro can
expand properly, clearing up the build failure.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

No Fixes tag because it seems likely that this is a transient include
issue (the code builds with GCC). The robot blamed commit e8c07082a810
("Kbuild: move to -std=gnu11") but I think that just exposed these
errors, not caused them.

 arch/powerpc/math-emu/math_efp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
index 39b84e7452e1..aa3bb8da1cb9 100644
--- a/arch/powerpc/math-emu/math_efp.c
+++ b/arch/powerpc/math-emu/math_efp.c
@@ -17,6 +17,7 @@
 
 #include <linux/types.h>
 #include <linux/prctl.h>
+#include <linux/module.h>
 
 #include <linux/uaccess.h>
 #include <asm/reg.h>

base-commit: dcf8e5633e2e69ad60b730ab5905608b756a032f
-- 
2.37.3

