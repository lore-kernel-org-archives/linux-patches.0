Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C1315AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF3AC433C9;
	Wed,  9 Aug 2023 10:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577867;
	bh=jwvgWVtNftjjBSavMJVmhqFPAca+IA7DejtQ3+/t+bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCBzq4NHdnmzlwARu9u1MDw8i3My8zwwwrMVbftoSq6ai8EOYykykrs8XgDlHbrL0
	 dXSjpFm/4hRo2JnqD595wfAakol+UdelPJqO9GiNMn3tXx5/1qn8k96mdueYajm522
	 rUETdoMl6mm4TFILk7gj8Ap5+VAr6rjLwPq2NcNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.4 022/165] word-at-a-time: use the same return type for has_zero regardless of endianness
Date: Wed,  9 Aug 2023 12:39:13 +0200
Message-ID: <20230809103643.524583362@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ndesaulniers@google.com <ndesaulniers@google.com>

[ Upstream commit 79e8328e5acbe691bbde029a52c89d70dcbc22f3 ]

Compiling big-endian targets with Clang produces the diagnostic:

  fs/namei.c:2173:13: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
	} while (!(has_zero(a, &adata, &constants) | has_zero(b, &bdata, &constants)));
	          ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                               ||
  fs/namei.c:2173:13: note: cast one or both operands to int to silence this warning

It appears that when has_zero was introduced, two definitions were
produced with different signatures (in particular different return
types).

Looking at the usage in hash_name() in fs/namei.c, I suspect that
has_zero() is meant to be invoked twice per while loop iteration; using
logical-or would not update `bdata` when `a` did not have zeros.  So I
think it's preferred to always return an unsigned long rather than a
bool than update the while loop in hash_name() to use a logical-or
rather than bitwise-or.

[ Also changed powerpc version to do the same  - Linus ]

Link: https://github.com/ClangBuiltLinux/linux/issues/1832
Link: https://lore.kernel.org/lkml/20230801-bitwise-v1-1-799bec468dc4@google.com/
Fixes: 36126f8f2ed8 ("word-at-a-time: make the interfaces truly generic")
Debugged-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/word-at-a-time.h | 2 +-
 include/asm-generic/word-at-a-time.h      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/word-at-a-time.h b/arch/powerpc/include/asm/word-at-a-time.h
index 46c31fb8748d5..30a12d2086871 100644
--- a/arch/powerpc/include/asm/word-at-a-time.h
+++ b/arch/powerpc/include/asm/word-at-a-time.h
@@ -34,7 +34,7 @@ static inline long find_zero(unsigned long mask)
 	return leading_zero_bits >> 3;
 }
 
-static inline bool has_zero(unsigned long val, unsigned long *data, const struct word_at_a_time *c)
+static inline unsigned long has_zero(unsigned long val, unsigned long *data, const struct word_at_a_time *c)
 {
 	unsigned long rhs = val | c->low_bits;
 	*data = rhs;
diff --git a/include/asm-generic/word-at-a-time.h b/include/asm-generic/word-at-a-time.h
index 20c93f08c9933..95a1d214108a5 100644
--- a/include/asm-generic/word-at-a-time.h
+++ b/include/asm-generic/word-at-a-time.h
@@ -38,7 +38,7 @@ static inline long find_zero(unsigned long mask)
 	return (mask >> 8) ? byte : byte + 1;
 }
 
-static inline bool has_zero(unsigned long val, unsigned long *data, const struct word_at_a_time *c)
+static inline unsigned long has_zero(unsigned long val, unsigned long *data, const struct word_at_a_time *c)
 {
 	unsigned long rhs = val | c->low_bits;
 	*data = rhs;
-- 
2.40.1



