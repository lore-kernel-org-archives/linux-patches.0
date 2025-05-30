Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465E025742C;
	Fri, 30 May 2025 12:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608818; cv=none; b=qPZT6JOjzFGhFcSFOhUC5q3bsPiqtRyAJ6PX7QbbOSftnwqrTlUKxU3Er5A1HmaaXUwWknF2HLDSenEvi+yWj7iaLdBWpHN/ksAGMyDUIP32A8b7GBzthVJGTAxJXNI2U8O/hQy9z+lxnJ1TUrLJuLEbnQfRF6oWI6H2SfwcGyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608818; c=relaxed/simple;
	bh=sMlTGzqEhPxm0wua/9JqG7yF3nrtXRJWwT7BLt5S0QQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QiRtAnEtoDwmdjKoqrsdopq2kqW0oCKtYQ0/q5ICPT6XPJ1U2KtdeMUOyyENwJw7v7oHyoRyYaVfbMB4GxvOinrMx33bqnsxVqe/aqoKxXhPuiMMLl7XFefgwHOSGwG/PyzieL5DsMrBa0Zj7nBFkNzWTR6RIpnbN8KGKzusvWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=quFbv6Pp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="quFbv6Pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7A8C4CEE9;
	Fri, 30 May 2025 12:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608818;
	bh=sMlTGzqEhPxm0wua/9JqG7yF3nrtXRJWwT7BLt5S0QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quFbv6Pp4ej0mIu3e9MVMRsBi7d6XRr1Zp9NWtkGg3kZMxPfqChzMXdY3aM6OO5Se
	 8q6oBhfj1aqN2t7k+X7/jnoDdTaK7zKfF1a7/rXMla5+0LW6EyZjkxWmefAj77KTb0
	 N12ITlguJie0Yur3tmO1m2iR2vBLeuHF58gEKv0NlrqmQbULf+u50ZKp7+DiUVkX+j
	 oHE/jxqRdQrAuVqzQ07UWTTYgO0zACIGD9Ht0P7sHM+baVV/a/OZdAs5tgoRNEDxLF
	 bZPH+A2VLIMlgURTnOvXQe8BhY8LODgXtCnGPSmOpoqNC6FvDazZu1PGiM2gDG5D0t
	 zFWo69ZWingMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org,
	clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 6.12 04/26] tools/nolibc: use intmax definitions from compiler
Date: Fri, 30 May 2025 08:39:50 -0400
Message-Id: <20250530124012.2575409-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530124012.2575409-1-sashal@kernel.org>
References: <20250530124012.2575409-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
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

**YES** This commit should be backported to stable kernel trees. ##
Detailed Analysis: ### Code Changes Analysis: The commit makes a
targeted fix to `tools/include/nolibc/stdint.h` by replacing: ```c
typedef int64_t intmax_t; typedef uint64_t uintmax_t; ``` with: ```c
typedef __INTMAX_TYPE__ intmax_t; typedef __UINTMAX_TYPE__ uintmax_t;
``` ### Problem Being Fixed: This addresses a **compiler format checking
incompatibility** where: - The compiler's printf format checking uses
intmax types from the compiler itself, not from libc - This mismatch
causes compilation errors with clang 19 on arm64 - The error occurs
because nolibc defined intmax_t as `unsigned long long` while the
compiler expected `unsigned long` ### Evidence Supporting Backport: **1.
Similar Pattern Match:** This closely follows the pattern of Similar
Commit #4 and #5 (both marked YES for backport): - Similar Commit #4:
Fixed integer type definitions for 32-bit platforms (backported) -
Similar Commit #5: Fixed printf format mismatches with compiler warnings
(backported with Cc: stable@vger.kernel.org) **2. Bug Fix Nature:** This
is clearly a **bug fix** that: - Resolves compilation failures with
clang 19 - Fixes format checking incompatibilities between compiler and
library definitions - Affects actual build failures, not just warnings
**3. Low Risk/High Impact:** - **Minimal change scope**: Only changes 2
typedef lines - **Contained to nolibc**: Affects only the tools/nolibc
subsystem - **Uses compiler-provided types**: More robust than hardcoded
definitions - **Fixes build breakage**: Critical for users with newer
compilers **4. Aligns with Stable Criteria:** - Fixes important build
issues affecting users - Small, contained change with minimal regression
risk - No architectural changes or new features - Resolves compatibility
with current/newer toolchains **5. Historical Context:** From the kernel
repository examination: - Previous similar format-related fixes (commit
92098b1c10cb) were already tagged for stable with `Cc:
stable@vger.kernel.org` - The nolibc subsystem has a history of
backporting compiler compatibility fixes - The pattern of using
compiler-provided types (like `__SIZE_TYPE__`) is already established in
the codebase **6. User Impact:** This prevents build failures for users
with: - clang 19 on arm64 - Potentially other compiler/architecture
combinations where intmax_t definitions differ - Any nolibc-based
applications or tests The commit represents exactly the type of fix that
stable trees are designed for: a small, targeted fix that resolves build
breakage without introducing new features or architectural changes.

 tools/include/nolibc/stdint.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/include/nolibc/stdint.h b/tools/include/nolibc/stdint.h
index cd79ddd6170e0..b052ad6303c38 100644
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

