Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3482D271478;
	Sun,  1 Jun 2025 23:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821206; cv=none; b=IgwiqnrLqWDG++0GXn7++vV52ZMDIMGWE0kBeMk96C1BYQmAPLL4MPskOvzW10xz8z4/HavKr4s7KVtHPKlKEcIYeEfR5hKCpmH+0ce84preZmrC3hvAxPXD15uqYUTUQ2OG5lQylNAav342OdxYP/qeZtbz09+C6Tnj1HvEonA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821206; c=relaxed/simple;
	bh=+ZH6OTkRxGA/CUXwXFSQTiU9wUtruA/4MRlla24b+Pg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=acUvXZW8ct02vm7KaevCh3Y7rEL+kBuH2fWXgh27sggGHk8wRrVUpMAKmMLpAbwtc32MzBCDeERQBb6E9VMDaF+CMNdP/+MZPFk4PKmVqGFeN/uNIk+nTg4rzWPYw28j3FIUN6fVMTkmGdDVs+a3qYssJx6jre/w/opj8U/j+Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9E4k074; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9E4k074"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1437CC4CEF1;
	Sun,  1 Jun 2025 23:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821206;
	bh=+ZH6OTkRxGA/CUXwXFSQTiU9wUtruA/4MRlla24b+Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9E4k074F1ARIe6YJsNyQViFqwReTkgWph7P1gMnHrKy1RZCIse7C8b7kn7eyj1tU
	 lr3y+zeZhS+jo1tFRbPMZZ/LgM94gejf1d/kbQUzaAJE8VrlXUZnTBA5U0RJRrGcit
	 BDZADTsKjrMnzYM0BBaZihF/bSw3MGIOoVJ4lLD5AX0HTkHOnmRhL013tuJifb9srq
	 ILw2GzfSrJEAW19rmvzX225UXbbgOk8xQVySSdZLy+iuJab57TEjZPEEAICvRTrtlg
	 vThVL8f+eQXdVTjFie7hlhxdr9t3J23c2PcEiUaeSICnUKp97pFonCLFPkcXELBWIf
	 LIrMYNbu410bw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>,
	linux@weissschuh.net,
	nathan@kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.6 64/66] tools/nolibc: use intmax definitions from compiler
Date: Sun,  1 Jun 2025 19:37:41 -0400
Message-Id: <20250601233744.3514795-64-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233744.3514795-1-sashal@kernel.org>
References: <20250601233744.3514795-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit e5407c0820ea5fa7117b85ed32b724af73156d63 ]

The printf format checking in the compiler uses the intmax types from
the compiler, not libc. This can lead to compiler errors.

Instead use the types already provided by the compiler.

Example issue with clang 19 for arm64:

nolibc-test.c:30:2: error: format specifies type 'uintmax_t' (aka 'unsigned long') but the argument has type 'uintmax_t' (aka 'unsigned long long') [-Werror,-Wformat]

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Analysis of the Code Changes The commit makes
a targeted fix to resolve compiler format checking errors by changing
the intmax type definitions in `tools/include/nolibc/stdint.h`: ```c
-typedef int64_t intmax_t; -typedef uint64_t uintmax_t; +typedef
__INTMAX_TYPE__ intmax_t; +typedef __UINTMAX_TYPE__ uintmax_t; ``` ##
Why This Should Be Backported ### 1. **Fixes Real Compilation Errors**
The commit addresses actual compiler errors that prevent successful
builds, as demonstrated by the clang 19 error message: ``` nolibc-
test.c:30:2: error: format specifies type 'uintmax_t' (aka 'unsigned
long') but the argument has type 'uintmax_t' (aka 'unsigned long long')
[-Werror,-Wformat] ``` This is a critical build breakage, not just a
warning. ### 2. **Small, Contained, Low-Risk Change** - Only changes 2
lines of code in a single header file - Does not modify any algorithms
or control flow - Uses well-established compiler built-ins that have
been available for decades - No risk of behavioral changes beyond fixing
the type compatibility issue ### 3. **Follows Established Pattern** The
change aligns with existing practice in the same file, which already
uses `__SIZE_TYPE__` for `size_t` definition. This demonstrates that
using compiler built-ins for fundamental types is the established
approach in nolibc. ### 4. **Cross-Platform Compatibility Fix** The
issue particularly affects: - Different compiler backends (GCC vs Clang)
- Different architectures where `long` vs `long long` sizes vary
(especially arm64) - Cross-compilation scenarios - Builds with strict
format checking enabled (`-Wformat -Werror`) ### 5. **Comparison with
Similar Commits** Looking at the reference commits provided: - **Similar
Commit #4** (Status: YES): Also fixes integer type issues in nolibc for
platform compatibility - **Similar Commit #5** (Status: YES): Also fixes
printf format mismatches with explicit stable tree marking (`Cc:
stable@vger.kernel.org`) This commit follows the same pattern of fixing
type/format compatibility issues that have been deemed worthy of
backporting. ### 6. **Tools Subsystem Stability** While this is in the
tools directory, nolibc is used for: - Kernel testing infrastructure -
Minimal userspace environments - Cross-compilation toolchains - Kernel
selftests Breaking builds in these contexts can impact kernel
development workflows across different platforms. ### 7. **No
Architectural Changes** The commit: - Doesn't introduce new features -
Doesn't change APIs - Doesn't modify kernel core functionality - Simply
ensures type consistency between compiler and library definitions ##
Conclusion This is exactly the type of targeted bug fix that stable
trees are designed for: it fixes a real compilation issue that affects
users, uses a minimal and safe approach, follows established patterns,
and has no risk of introducing regressions. The fix ensures that nolibc
can be compiled successfully across different compiler/architecture
combinations, which is essential for kernel development infrastructure.

 tools/include/nolibc/stdint.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/include/nolibc/stdint.h b/tools/include/nolibc/stdint.h
index 6665e272e2132..87a2b09e2dda5 100644
--- a/tools/include/nolibc/stdint.h
+++ b/tools/include/nolibc/stdint.h
@@ -39,8 +39,8 @@ typedef   size_t      uint_fast32_t;
 typedef  int64_t       int_fast64_t;
 typedef uint64_t      uint_fast64_t;
 
-typedef  int64_t           intmax_t;
-typedef uint64_t          uintmax_t;
+typedef __INTMAX_TYPE__    intmax_t;
+typedef __UINTMAX_TYPE__  uintmax_t;
 
 /* limits of integral types */
 
-- 
2.39.5

