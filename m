Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC6426F288;
	Thu, 12 Mar 2026 20:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347218; cv=none; b=p3oWnnAMUNHhMTiqegD2bnLIB7o+ip/SxjVQuRx+B5C/vvPfh57AyvYoUIG+SVNOLCpkqUBigcAV04JV8UHrqpo5KY865tO40AbtTZFkzuGzfoiS0mUp37ejfvuMBRkHfcgUhAYtyCHRcVa3LQwVxfkDqenfZr+6C3Q6Bp/YYhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347218; c=relaxed/simple;
	bh=xo8kDoBM/TEMmt+3aEgoc8CUjRtf0gNtJNlcgIjm3XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UI/6sS0jH8Mj/LyMt0gDoFzfykJjau6x9JsDcLfDJMcsiJIYg5geoPr9FngSmk9mFGOgrs5hKNPY1eN1SGh7Scy3Ql/vtjepj63W3sJ56X5G/iR/HROlEbZzwamTn7tPLRNXX5dfE83EOI39wjJd73qUZ9F+L7dI9eX7B5tzYJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7QNnS/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7QNnS/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF16FC2BC86;
	Thu, 12 Mar 2026 20:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347218;
	bh=xo8kDoBM/TEMmt+3aEgoc8CUjRtf0gNtJNlcgIjm3XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7QNnS/MmsDZ3YSjG5BrGxG+uS+uJsiQyY2YE8y/zVgRnj73/49PMJ2IF7ypY/Pqh
	 5dbM3fK/1J5/4k07wiiJ6G5yw+gLmOfmgmN2+LTWh/iRTd9ayBejVDDJXnbjhxlY9s
	 EZdEQVJh6mytPJ3lIXGC1TYWoiuufnODm+Y3nVWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wake Liu <wakel@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/265] kselftest/harness: Use helper to avoid zero-size memset warning
Date: Thu, 12 Mar 2026 21:10:23 +0100
Message-ID: <20260312201026.857947669@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wake Liu <wakel@google.com>

[ Upstream commit 19b8a76cd99bde6d299e60490f3e62b8d3df3997 ]

When building kselftests with a toolchain that enables source
fortification (e.g., Android's build environment, which uses
-D_FORTIFY_SOURCE=3), a build failure occurs in tests that use an
empty FIXTURE().

The root cause is that an empty fixture struct results in
`sizeof(self_private)` evaluating to 0. The compiler's fortification
checks then detect the `memset()` call with a compile-time constant size
of 0, issuing a `-Wuser-defined-warnings` which is promoted to an error
by `-Werror`.

An initial attempt to guard the call with `if (sizeof(self_private) > 0)`
was insufficient. The compiler's static analysis is aggressive enough
to flag the `memset(..., 0)` pattern before evaluating the conditional,
thus still triggering the error.

To resolve this robustly, this change introduces a `static inline`
helper function, `__kselftest_memset_safe()`. This function wraps the
size check and the `memset()` call. By replacing the direct `memset()`
in the `__TEST_F_IMPL` macro with a call to this helper, we create an
abstraction boundary. This prevents the compiler's static analyzer from
"seeing" the problematic pattern at the macro expansion site, resolving
the build failure.

Build Context:
Compiler: Android (14488419, +pgo, +bolt, +lto, +mlgo, based on r584948) clang version 22.0.0 (https://android.googlesource.com/toolchain/llvm-project 2d65e4108033380e6fe8e08b1f1826cd2bfb0c99)
Relevant Options: -O2 -Wall -Werror -D_FORTIFY_SOURCE=3 -target i686-linux-android10000

Test: m kselftest_futex_futex_requeue_pi

Removed Gerrit Change-Id
Shuah Khan <skhan@linuxfoundation.org>

Link: https://lore.kernel.org/r/20251224084120.249417-1-wakel@google.com
Signed-off-by: Wake Liu <wakel@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 6be268151426 ("selftests/harness: order TEST_F and XFAIL_ADD constructors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 666c9fde76da9..d67ec4d762db3 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -69,6 +69,12 @@
 
 #include "kselftest.h"
 
+static inline void __kselftest_memset_safe(void *s, int c, size_t n)
+{
+	if (n > 0)
+		memset(s, c, n);
+}
+
 #define TEST_TIMEOUT_DEFAULT 30
 
 /* Utilities exposed to the test definitions */
@@ -418,7 +424,7 @@
 				self = mmap(NULL, sizeof(*self), PROT_READ | PROT_WRITE, \
 					MAP_SHARED | MAP_ANONYMOUS, -1, 0); \
 			} else { \
-				memset(&self_private, 0, sizeof(self_private)); \
+				__kselftest_memset_safe(&self_private, 0, sizeof(self_private)); \
 				self = &self_private; \
 			} \
 		} \
-- 
2.51.0



