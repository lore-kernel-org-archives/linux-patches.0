Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7112EBDCB;
	Mon, 24 Nov 2025 08:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971620; cv=none; b=illedImsCbruPQtpyIsfwEDEH303o91VLNx7LVO8rqezUUdHAd8AE8xUjGx0DqCbQUs7gPpU4xYZyyZab0Me3n54vHGdGcLOJ7xyIU3L4S4mfHxwxpfTHtpB4EnscIjQGsyLEgkV8W8ByNuEV+Ilb88idC8IX7ttWwNoRqBwkK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971620; c=relaxed/simple;
	bh=2DfJovqnBSCssy0NJz7G7Dmqx2CQZ/KxyDUq+b46ELE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIMvOl3i7IGwGGPPkaecFH5TtviWRTSlDhhd4sgjANKWFOuZXtlFRIj6VVcJ8f+OV2CWnX7bZd7darYaguMOP3IM4PiPGYzSnTwZwYKyY+cLQYXOitpjT7ajVI8Ldyok2QL9mB4uLWFOzE0NQLexe6h0eOuOOE3AG9pa6CGqhDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dE1RTFQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dE1RTFQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857E3C4CEF1;
	Mon, 24 Nov 2025 08:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971620;
	bh=2DfJovqnBSCssy0NJz7G7Dmqx2CQZ/KxyDUq+b46ELE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dE1RTFQW2AKN0OLU6X9CMvIps2wTT9FbdqO7l/kZN4zFKHVne7A6acxe0WfujwM1A
	 7eiSdh3qvfyh8mmo1Bu8XEveqT/0S4v5mxI7svb/g0VJAYmQwHP85eCto66AdH//DJ
	 o8QB0np0oTEIKsOcRv7YDOjUDabnQZOOPMYSnjS6N+ZuTZcRjQEQkEle1CIJYIssoi
	 2W7qCF8iMOwmthGJwcob7bOghEDppUKMOegVMX13Db/pZzqtNeAYIzf8iXxv7a1A0B
	 oqj0ahqaMBrSZhcm5qX5O9UffVM6JTyQY2UJ64ijOAE6WXSLV2mECL6BxzEB6IQ5bi
	 YbiSMw1/DyVmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17-5.10] samples: work around glibc redefining some of our defines wrong
Date: Mon, 24 Nov 2025 03:06:22 -0500
Message-ID: <20251124080644.3871678-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124080644.3871678-1-sashal@kernel.org>
References: <20251124080644.3871678-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit a48f822908982353c3256e35a089e9e7d0d61580 ]

Apparently as of version 2.42, glibc headers define AT_RENAME_NOREPLACE
and some of the other flags for renameat2() and friends in <stdio.h>.

Which would all be fine, except for inexplicable reasons glibc decided
to define them _differently_ from the kernel definitions, which then
makes some of our sample code that includes both kernel headers and user
space headers unhappy, because the compiler will (correctly) complain
about redefining things.

Now, mixing kernel headers and user space headers is always a somewhat
iffy proposition due to namespacing issues, but it's kind of inevitable
in our sample and selftest code.  And this is just glibc being stupid.

Those defines come from the kernel, glibc is exposing the kernel
interfaces, and glibc shouldn't make up some random new expressions for
these values.

It's not like glibc headers changed the actual result values, but they
arbitrarily just decided to use a different expression to describe those
values.  The kernel just does

    #define AT_RENAME_NOREPLACE  0x0001

while glibc does

    # define RENAME_NOREPLACE (1 << 0)
    # define AT_RENAME_NOREPLACE RENAME_NOREPLACE

instead.  Same value in the end, but very different macro definition.

For absolutely no reason.

This has since been fixed in the glibc development tree, so eventually
we'll end up with the canonical expressions and no clashes.  But in the
meantime the broken headers are in the glibc-2.42 release and have made
it out into distributions.

Do a minimal work-around to make the samples build cleanly by just
undefining the affected macros in between the user space header include
and the kernel header includes.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## COMPREHENSIVE ANALYSIS

### 1. COMMIT MESSAGE ANALYSIS
**Problem:** The commit addresses a build failure introduced by glibc
version 2.42. The glibc headers (`<stdio.h>`) began defining
`AT_RENAME_NOREPLACE`, `AT_RENAME_EXCHANGE`, and `AT_RENAME_WHITEOUT`
using bitwise shift expressions (e.g., `1 << 0`). The Linux kernel
headers (`<linux/stat.h>`, `<linux/fcntl.h>`) define these same
constants using hexadecimal literals (e.g., `0x0001`). When sample
programs include both sets of headers, the compiler detects a macro
redefinition mismatch, causing the build to fail.

**Solution:** The fix implements a workaround by explicitly `#undef`-ing
the conflicting macros after including the glibc headers but before
including the kernel headers. This ensures the kernel headers can define
them without conflict.

**Context:** The commit is signed off by Linus Torvalds, indicating
high-level validation. While it lacks a "Cc: stable" tag, the nature of
the change (fixing a build regression caused by external environment
changes) is a standard candidate for backporting.

### 2. DEEP CODE RESEARCH
**Affected Files:**
- `samples/vfs/test-statx.c` (Added in v4.20, present in 5.4+, 5.10+,
  5.15+, 6.1+, 6.6+ stable trees)
- `samples/watch_queue/watch_test.c` (Added in v5.8, present in 5.10+,
  5.15+, 6.1+, 6.6+ stable trees)

**Technical Mechanism:**
The conflict arises from the preprocessor.
- **Kernel Definition (`include/uapi/linux/fcntl.h`):**
  ```c
  #define AT_RENAME_NOREPLACE     0x0001
  ```
- **New Glibc Definition:**
  ```c
  #define RENAME_NOREPLACE (1 << 0)
  #define AT_RENAME_NOREPLACE RENAME_NOREPLACE
  ```
Because `0x0001` is not textually identical to `(1 << 0)` (or the
expansion thereof), the preprocessor flags this as a redefinition error.

**The Fix:**
The commit inserts:
```c
// Work around glibc header silliness
#undef AT_RENAME_NOREPLACE
#undef AT_RENAME_EXCHANGE
#undef AT_RENAME_WHITEOUT
```
This effectively cleans the slate before the kernel headers are parsed,
restoring the canonical kernel definitions for the remainder of the
file.

### 3. STABLE KERNEL RULES ASSESSMENT
**Classification:** **BUILD FIX**

This falls strictly under the **EXCEPTIONS** list in the stable kernel
rules:
> "4. BUILD FIXES: Fixes for compilation errors or warnings... These are
critical for users who need to build the kernel"

**Compliance Check:**
- **Obviously correct:** Yes. It is a standard preprocessor workaround
  for header conflicts.
- **Fixes a real bug:** Yes. Users with modern distributions (Fedora
  Rawhide, Arch, etc.) cannot compile the kernel samples without this.
- **Small and contained:** Yes. 12 lines of added code, strictly
  preprocessor directives.
- **No new features:** Yes. It preserves existing behavior.

### 4. RISK ASSESSMENT
**Risk:** **ZERO**
- **Scope:** The changes are limited exclusively to the `samples/`
  directory. These files are user-space example programs and tests; they
  are not part of the kernel image (vmlinuz) or modules (.ko).
- **Runtime Impact:** None. The macros resolve to the same numeric
  values (`1` vs `0x0001`), so the compiled binary behavior is
  identical.
- **Regression Potential:** None. The `#undef` only affects the specific
  translation units of the sample programs.

### 5. USER IMPACT EVALUATION
**Target Audience:** Developers, distribution maintainers, and CI
systems building the full kernel tree (including `make samples`).
**Severity:** Medium (Build Breakage). While it doesn't break the booted
kernel, build failures are blocking issues that disrupt workflows and
testing. As glibc 2.42 propagates to stable distributions (Debian,
Ubuntu, RHEL), this issue will become widespread.

### 6. CONCLUSION
This commit is a textbook example of a stable backport candidate under
the "Build Fix" exception. It fixes a tangible regression caused by
toolchain/library updates, has zero risk to the kernel runtime, and
ensures the kernel source tree remains buildable on modern systems.

**YES**

 samples/vfs/test-statx.c         | 6 ++++++
 samples/watch_queue/watch_test.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/samples/vfs/test-statx.c b/samples/vfs/test-statx.c
index 49c7a46cee073..424a6fa15723c 100644
--- a/samples/vfs/test-statx.c
+++ b/samples/vfs/test-statx.c
@@ -19,6 +19,12 @@
 #include <time.h>
 #include <sys/syscall.h>
 #include <sys/types.h>
+
+// Work around glibc header silliness
+#undef AT_RENAME_NOREPLACE
+#undef AT_RENAME_EXCHANGE
+#undef AT_RENAME_WHITEOUT
+
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #define statx foo
diff --git a/samples/watch_queue/watch_test.c b/samples/watch_queue/watch_test.c
index 8c6cb57d5cfc5..24cf7d7a19725 100644
--- a/samples/watch_queue/watch_test.c
+++ b/samples/watch_queue/watch_test.c
@@ -16,6 +16,12 @@
 #include <errno.h>
 #include <sys/ioctl.h>
 #include <limits.h>
+
+// Work around glibc header silliness
+#undef AT_RENAME_NOREPLACE
+#undef AT_RENAME_EXCHANGE
+#undef AT_RENAME_WHITEOUT
+
 #include <linux/watch_queue.h>
 #include <linux/unistd.h>
 #include <linux/keyctl.h>
-- 
2.51.0

