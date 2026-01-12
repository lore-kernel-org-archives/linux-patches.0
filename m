Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD5D2D8375;
	Mon, 12 Jan 2026 14:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229924; cv=none; b=UYH/Oy1Hy6H0BkJwKGUJAsAwC9T6fO72Wh9yz2pesK/+Axm7+919yYMxYGjFEcb568u3U2QLvPLmVY2Y6GcFBkP4C9ueScMUfVA2VtcSMz+ioPOQyP4SJ0WXI2jIt5b2KwjbIoobvjMBITx4Rk+GQsqNp3mSOvI93jCYEAkLbQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229924; c=relaxed/simple;
	bh=TcP8aCz11Hd2xDXus4EA8Y7dbVgzx5ZbKfqVHRsQz48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3U+UaDQ7IL9jx5Mhav8XRkKjIioHwwbHIivmDkXlBw3O3RetE62tYm8MDNMv8a8pf7J7Fei+XnoqS3I8cVDlYCXdyPWMt7ycsZ+hO4xR5QpldQc8rSeKQoAHZXQLORWlqHSrFTlzC/Z4qOpTv60Xo9L6rV+VcLGnnC97ZA9Pcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WthNu8Wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WthNu8Wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4A3C19423;
	Mon, 12 Jan 2026 14:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229924;
	bh=TcP8aCz11Hd2xDXus4EA8Y7dbVgzx5ZbKfqVHRsQz48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WthNu8Wb/7yZtL2GioS+un2O2XbJUft41Vqd4XwyQT8Ws6HT2KYMpk1jH5eERe00l
	 +cOWLRp9rR4ZUaOELHZ6xVsAuQzZbm2M9AMqYfesIJBWDpV3+/L0HWNLSVDNOe9JyD
	 AsJA5kfnRUBeZZ5ACeQ3VsM2a5T+geC+7jDCEaD6prrgqIYxw07xn28c/sgbz4O2Xy
	 DMOW29bcXjGW4vwS0I9HZxQV1X2e6F8HYGRSKAYtsRAoVJfPs75MRfObpwOJq2nbXv
	 Ucpsi1Q5l0YiC+bRNJqZwz9Ct3XrccxusxgQ/YeciYC5hd+ypP8PzYP9ueLV9RvlvL
	 Lg7DR3zKt17QA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brendan Jackman <jackmanb@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>,
	nathan@kernel.org,
	ardb@kernel.org,
	mingo@kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18] x86/sev: Disable GCOV on noinstr object
Date: Mon, 12 Jan 2026 09:58:03 -0500
Message-ID: <20260112145840.724774-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112145840.724774-1-sashal@kernel.org>
References: <20260112145840.724774-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.5
Content-Transfer-Encoding: 8bit

From: Brendan Jackman <jackmanb@google.com>

[ Upstream commit 9efb74f84ba82a9de81fc921baf3c5e2decf8256 ]

With Debian clang version 19.1.7 (3+build5) there are calls to
kasan_check_write() from __sev_es_nmi_complete(), which violates noinstr.  Fix
it by disabling GCOV for the noinstr object, as has been done for previous
such instrumentation issues.

Note that this file already disables __SANITIZE_ADDRESS__ and
__SANITIZE_THREAD__, thus calls like kasan_check_write() ought to be nops
regardless of GCOV. This has been fixed in other patches. However, to avoid
any other accidental instrumentation showing up, (and since, in principle GCOV
is instrumentation and hence should be disabled for noinstr code anyway),
disable GCOV overall as well.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Marco Elver <elver@google.com>
Link: https://patch.msgid.link/20251216-gcov-inline-noinstr-v3-3-10244d154451@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: x86/sev: Disable GCOV on noinstr object

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly explains the problem:
- With Clang 19.1.7, GCOV instrumentation causes calls to
  `kasan_check_write()` from `__sev_es_nmi_complete()`
- This violates the `noinstr` (no instrumentation) attribute requirement
- The fix follows an established pattern already used in the same file
  for other sanitizers

Key review tags:
- Signed-off-by maintainers from Google and AMD (Borislav Petkov, well-
  known x86 maintainer)
- Acked-by from Marco Elver (instrumentation/sanitizer expert at Google)

### 2. CODE CHANGE ANALYSIS

The change is trivially simple - one line added to a Makefile:

```makefile
GCOV_PROFILE_noinstr.o          := n
```

This disables GCOV code coverage profiling for the `noinstr.o` object
file. The context shows this follows an established pattern:
- `UBSAN_SANITIZE_noinstr.o := n` - already disables UBSAN
- `KASAN_SANITIZE_noinstr.o := n` - already disables KASAN
- `KCSAN_SANITIZE_noinstr.o := n` - already disables KCSAN

The `noinstr` attribute is critical for code that runs in sensitive
contexts like NMI handlers, where any unexpected function calls can
cause deadlocks, crashes, or undefined behavior.

### 3. CLASSIFICATION

This is a **build fix** that prevents instrumentation violations. When
`noinstr` code gets instrumented:
- NMI handlers may call functions that aren't safe in NMI context
- Potential deadlocks if instrumentation takes locks
- Potential crashes or undefined behavior

This falls squarely under the "build fixes" exception category for
stable backports.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 2 (including blank line)
- **Files touched**: 1 Makefile only
- **Complexity**: Minimal
- **Risk**: Extremely low

This change cannot cause regressions because:
1. It's a Makefile-only change, not code modification
2. It only disables optional build-time instrumentation
3. GCOV is used for code coverage analysis, not production functionality
4. The pattern is already used in the same file for other sanitizers

### 5. USER IMPACT

- **Affected users**: Those building with GCOV enabled + Clang 19+ + AMD
  SEV support
- **Severity if hit**: noinstr violations in NMI handlers can cause
  crashes or deadlocks - severe
- **Scope**: Relatively niche configuration, but real for users who hit
  it

### 6. STABILITY INDICATORS

- Reviewed and acked by instrumentation expert (Marco Elver)
- Signed off by well-known x86 maintainer (Borislav Petkov)
- Follows well-established pattern in the kernel

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- The affected Makefile with existing `*_SANITIZE_noinstr.o` lines
  exists in stable trees with SEV support

### VERDICT

**Pros:**
- Trivially small change (1 line)
- Fixes a real instrumentation violation issue
- Zero risk of runtime regression
- Follows established pattern already in the file
- Well-reviewed by appropriate experts
- Falls under "build fixes" exception

**Cons:**
- Requires specific toolchain configuration to trigger
- Somewhat niche (Clang 19 + GCOV + SEV)

This is a textbook example of a safe, low-risk build fix. It disables
optional instrumentation for code that must not be instrumented
(`noinstr`). The change is defensive, harmless, and prevents potential
crashes/deadlocks in NMI handlers. Even if users don't actively hit the
issue with their current toolchain, disabling GCOV for noinstr code is
the correct thing to do.

**YES**

 arch/x86/coco/sev/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/coco/sev/Makefile b/arch/x86/coco/sev/Makefile
index 3b8ae214a6a64..b2e9ec2f69014 100644
--- a/arch/x86/coco/sev/Makefile
+++ b/arch/x86/coco/sev/Makefile
@@ -8,3 +8,5 @@ UBSAN_SANITIZE_noinstr.o	:= n
 # GCC may fail to respect __no_sanitize_address or __no_kcsan when inlining
 KASAN_SANITIZE_noinstr.o	:= n
 KCSAN_SANITIZE_noinstr.o	:= n
+
+GCOV_PROFILE_noinstr.o		:= n
-- 
2.51.0

