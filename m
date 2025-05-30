Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEF222DA00;
	Fri, 30 May 2025 12:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608740; cv=none; b=NbtDW8cZK1E91EpYKbRg9Ynhp9HVkjSczCcsg0Sq5UDYSjjjzLW2834jLpk1Jw/IrafXmpLz+C6ahZCfzUyd3/4POXKPzgWLn8snbIYhXxciax8njHobfBgernBYSi8XOYkSmjSCg29ooD87T6W+iP5SenMC+q1gLcXb2YsuH74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608740; c=relaxed/simple;
	bh=sMlTGzqEhPxm0wua/9JqG7yF3nrtXRJWwT7BLt5S0QQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uOy83gK9265BB+Ja/izQu5EG0yr32yjxzSK8nS1X3Z8Rnu9k8Wa+EoXmXG9zkTsBlu4CruS3IbhrAwnfuHT2WLevvQ9hN/mtuqPWoCTJpGKmlx23X/20WORoqTg3ge0g25LRKhqjq6JgOa1jX/rF7mlbOydXtdtN0DCkz4kwC0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ByrP8Kxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ByrP8Kxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3F8C4CEEF;
	Fri, 30 May 2025 12:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608739;
	bh=sMlTGzqEhPxm0wua/9JqG7yF3nrtXRJWwT7BLt5S0QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByrP8KxorDQ6CadOal+MXuDtSySMrXJ7b7ihjsSGMWDifS5yWbT1TNmpwq9GELDS1
	 Z0chBdM9uWPO6NfZDTv/WyVn4N6svGkPBCU/7JtaHqy7Xy7EguZ3jm+tFZaiqT9ype
	 k3EYYVrN9jRcqBpftJ6eK3/MuSXDhCVHgMTz9xunNARVcRLRSrmhnPmvM8umfo/ddd
	 pGhnJ52jY+JQZJ64gzx/5CTUBWeHzY9Ev5mOWT+4CTycPe9UIVQ918kEQEixl9jSUP
	 PBsFNHr6Y895EK4j2W4ew6OLSQrQ7KEmXVG/EDsLX139OyodrMLeQQwQ/2R7f7IExu
	 sSAilJ5Y4LpSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org,
	clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 6.15 05/30] tools/nolibc: use intmax definitions from compiler
Date: Fri, 30 May 2025 08:38:27 -0400
Message-Id: <20250530123852.2574030-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530123852.2574030-1-sashal@kernel.org>
References: <20250530123852.2574030-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
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

