Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B880742EE;
	Fri, 26 May 2023 15:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B199C433D2;
	Fri, 26 May 2023 15:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685116077;
	bh=MzumtO5ofDE932rsgGbPhIZT2RbvwCYn5PG0h8c8sWI=;
	h=From:Date:Subject:To:Cc:From;
	b=JA6sE9lVDE2iQmL4ocolcp+DhJXbetc2kBODiS0TNo3lAv3E9BNcLTjJ7EdIFgFaA
	 988ElpnDu/84utwpjRAd1PI0nKp2fl0qVU9H7a0KhiO/otN0gHCjNNQzobAVg/fllX
	 Ff/kHC3RK6iq+iSbsM3Y0uK7N+3u/hHbRivy9xPWojE0oUoQhEl/xuLOtPQyiXxEjK
	 nnE1kvjvj9Q9D5gyBlf4R2Kbd7+pOVjs9C6ZpZ2bTcQH7ObFpHCrIiTk5MevE3AUsk
	 VDE5ojvnIAhtzREaxJlZ0Nri8Wurr1HJS/lw3vj/R+NUW03xXaE/TXYlpCPCTiJiyp
	 to1DIHlT7q+xA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 26 May 2023 08:47:40 -0700
Subject: [PATCH] x86/csum: Fix clang -Wuninitialized in csum_partial()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230526-csum_partial-wuninitialized-v1-1-ebc0108dcec1@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJvUcGQC/x2N3QrCMAxGX2Xk2kDt/H+VIZK1mQu4OpJNxbF3t
 /XuO3xwzgLGKmxwqRZQfonJM2XYbioIPaU7o8TM4J2v3d4fMNg83EbSSeiB7zlJkjLlyxHdiai
 Ou7Pv3BGyoSVjbJVS6ItjIJtYyzEqd/L5Z5vruv4AU4v5fYYAAAA=
To: dave.hansen@linux.intel.com, x86@kernel.org
Cc: goldstein.w.n@gmail.com, ndesaulniers@google.com, trix@redhat.com, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2797; i=nathan@kernel.org;
 h=from:subject:message-id; bh=MzumtO5ofDE932rsgGbPhIZT2RbvwCYn5PG0h8c8sWI=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCkFV9Z0fpN6Inn6x/6t0m4eWVJ7+j/q1r66K2jFGvTxb
 wyn9yzOjlIWBjEOBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRUHuGf0asDxVC2J4rPO86
 b13w5UnGTZ5XrUw9lbtrPsXbP92/8wnDX/nglb1XTpkckH6yQrh+ZvoPm1W/So4FP1gg3NTGG1w
 UzAMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/x86/lib/csum-partial_64.c:74:20: error: variable 'result' is uninitialized when used here [-Werror,-Wuninitialized]
                  return csum_tail(result, temp64, odd);
                                   ^~~~~~
  arch/x86/lib/csum-partial_64.c:48:22: note: initialize the variable 'result' to silence this warning
          unsigned odd, result;
                              ^
                               = 0
  1 error generated.

The only initialization and uses of result in csum_partial() were moved
into csum_tail() but result is still being passed by value to
csum_tail() (clang's -Wuninitialized does not do interprocedural
analysis to realize that result is always assigned in csum_tail()
however). Sink the declaration of result into csum_tail() to clear up
the warning.

Fixes: 688eb8191b47 ("x86/csum: Improve performance of `csum_partial`")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/202305262039.3HUYjWJk-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/lib/csum-partial_64.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index fe5861951b15..cea25ca8b8cf 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -21,8 +21,10 @@ static inline unsigned short from32to16(unsigned a)
 	return b;
 }
 
-static inline __wsum csum_tail(unsigned int result, u64 temp64, int odd)
+static inline __wsum csum_tail(u64 temp64, int odd)
 {
+	unsigned int result;
+
 	result = add32_with_carry(temp64 >> 32, temp64 & 0xffffffff);
 	if (unlikely(odd)) {
 		result = from32to16(result);
@@ -45,7 +47,7 @@ static inline __wsum csum_tail(unsigned int result, u64 temp64, int odd)
 __wsum csum_partial(const void *buff, int len, __wsum sum)
 {
 	u64 temp64 = (__force u64)sum;
-	unsigned odd, result;
+	unsigned odd;
 
 	odd = 1 & (unsigned long) buff;
 	if (unlikely(odd)) {
@@ -71,7 +73,7 @@ __wsum csum_partial(const void *buff, int len, __wsum sum)
 		    "adcq $0,%[res]"
 		    : [res] "+r"(temp64)
 		    : [src] "r"(buff), "m"(*(const char(*)[40])buff));
-		return csum_tail(result, temp64, odd);
+		return csum_tail(temp64, odd);
 	}
 	if (unlikely(len >= 64)) {
 		/*
@@ -141,7 +143,7 @@ __wsum csum_partial(const void *buff, int len, __wsum sum)
 		    : [res] "+r"(temp64)
 		    : [trail] "r"(trail));
 	}
-	return csum_tail(result, temp64, odd);
+	return csum_tail(temp64, odd);
 }
 EXPORT_SYMBOL(csum_partial);
 

---
base-commit: 688eb8191b475db5acfd48634600b04fd3dda9ad
change-id: 20230526-csum_partial-wuninitialized-08aa3d492f07

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

