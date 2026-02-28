Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B5937144D;
	Sat, 28 Feb 2026 17:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301455; cv=none; b=Sna5uurbio2nfsSZYePNPea2FvZh3LjtKCuu7RhCmPEcsR9uaX7l1XmaipgN6woCqTGG24m12Rx8g8Xd6wGFtEEuP2RZ43FsONBJlaMW6How63a8hBDxoV/7El4LSv0H3hQGjQtWvO98Vf2OxwDIJ5hhM3y/geVZPsVLtGKVayw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301455; c=relaxed/simple;
	bh=fMpcn8d298xN2tM9VYuw2N4fJGekmnKxTTaw0+CGlY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOssQeLHx7VXacsQ1RHbrNPmCZyAuNrLdCaAdpOyNX77a+o60P7VRCX9iG96OEToz0rQw+B7QoHfJ9UaMBg4W7n3QuoN5s6GHjsIVnkk3MVSDAklRU2JFhmRLwGEIfVYm5zgVMqfiVOMhAm8R9wwLesKJnCx++AQg2CI0rreFHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HxpslaJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HxpslaJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DECAC116D0;
	Sat, 28 Feb 2026 17:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301455;
	bh=fMpcn8d298xN2tM9VYuw2N4fJGekmnKxTTaw0+CGlY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxpslaJMA+7BRMO7g03q/SVssfahi1/8ezMs3XZT8oAsP2OlqRHZF8IwKtmLkyAQ2
	 qsgeuAZh+Cx8SrY2Kjyla70yPamJGPXqmxtJ9yaU2qlkeJxRSexnze+jGANu8xav8A
	 d0cxD6U11+9aPAfvjzU5kysogBI8J6GjnW/o/kHAaAeKwYkisCLvvPMKl86aKPJVTZ
	 qinsP/PdzYGIhKq28GLjawM1QlXUEsTpy5+oBSZA4B2dFoGMKmccsgXXG9fNCaSDZR
	 LnfY74aBqI/K9kNUcklhRVtB+gj0wDYokLjTg8bnW8RBoCw4F6S8SDDKM35l36upiY
	 kXFGC2IEXRHLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nathan Chancellor <nathan@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 641/752] compiler-clang.h: require LLVM 19.1.0 or higher for __typeof_unqual__
Date: Sat, 28 Feb 2026 12:45:52 -0500
Message-ID: <20260228174750.1542406-641-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit e8d899d301346a5591c9d1af06c3c9b3501cf84b ]

When building the kernel using a version of LLVM between llvmorg-19-init
(the first commit of the LLVM 19 development cycle) and the change in
LLVM that actually added __typeof_unqual__ for all C modes [1], which
might happen during a bisect of LLVM, there is a build failure:

  In file included from arch/x86/kernel/asm-offsets.c:9:
  In file included from include/linux/crypto.h:15:
  In file included from include/linux/completion.h:12:
  In file included from include/linux/swait.h:7:
  In file included from include/linux/spinlock.h:56:
  In file included from include/linux/preempt.h:79:
  arch/x86/include/asm/preempt.h:61:2: error: call to undeclared function '__typeof_unqual__'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     61 |         raw_cpu_and_4(__preempt_count, ~PREEMPT_NEED_RESCHED);
        |         ^
  arch/x86/include/asm/percpu.h:478:36: note: expanded from macro 'raw_cpu_and_4'
    478 | #define raw_cpu_and_4(pcp, val)                         percpu_binary_op(4, , "and", (pcp), val)
        |                                                         ^
  arch/x86/include/asm/percpu.h:210:3: note: expanded from macro 'percpu_binary_op'
    210 |                 TYPEOF_UNQUAL(_var) pto_tmp__;                          \
        |                 ^
  include/linux/compiler.h:248:29: note: expanded from macro 'TYPEOF_UNQUAL'
    248 | # define TYPEOF_UNQUAL(exp) __typeof_unqual__(exp)
        |                             ^

The current logic of CC_HAS_TYPEOF_UNQUAL just checks for a major
version of 19 but half of the 19 development cycle did not have support
for __typeof_unqual__.

Harden the logic of CC_HAS_TYPEOF_UNQUAL to avoid this error by only
using __typeof_unqual__ with a released version of LLVM 19, which is
greater than or equal to 19.1.0 with LLVM's versioning scheme that
matches GCC's [2].

Link: https://github.com/llvm/llvm-project/commit/cc308f60d41744b5920ec2e2e5b25e1273c8704b [1]
Link: https://github.com/llvm/llvm-project/commit/4532617ae420056bf32f6403dde07fb99d276a49 [2]
Link: https://lkml.kernel.org/r/20260116-require-llvm-19-1-for-typeof_unqual-v1-1-3b9a4a4b212b@kernel.org
Fixes: ac053946f5c4 ("compiler.h: introduce TYPEOF_UNQUAL() macro")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler-clang.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
index 107ce05bd16eb..cccc72fd336b8 100644
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -152,4 +152,4 @@
  * Bindgen uses LLVM even if our C compiler is GCC, so we cannot
  * rely on the auto-detected CONFIG_CC_HAS_TYPEOF_UNQUAL.
  */
-#define CC_HAS_TYPEOF_UNQUAL (__clang_major__ >= 19)
+#define CC_HAS_TYPEOF_UNQUAL (__clang_major__ > 19 || (__clang_major__ == 19 && __clang_minor__ > 0))
-- 
2.51.0

