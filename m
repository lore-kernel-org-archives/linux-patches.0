Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AA730E0EE;
	Fri, 12 Dec 2025 06:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765519946; cv=none; b=b2VJFqpjxfDKKkEFNaJMwjYNkN+asl866KpnUKLaZ2AZlKwYQn/4elKBl+3FKv9lLBoRTcfkTJfZG8fCcTmVIEKthsQo/LqMW/R7V4q3+6dWNlGCz1W0bw0tOKG7ciBiiluoZZczYXV0p4GA0oHx6bii1pWD+GM80lKiQ0mofyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765519946; c=relaxed/simple;
	bh=3/74Qr7EVIIQir0V3rtgwB12WXIr61WFooRVftKwk0U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=b1F5gESnKZWa3dXJZmDlZ9zUPh935h9quFEzkArkqGRrDTomwjopjnMU4psCTGCaPkQnDN2uB4FLssMQXQ6A879LOdBcjDVExfNWvp6W32xzst1mFt++XacqClEqRPeoXL3rXfpVYRya3HMuTq5awBHycWAmiDoNjNsLrzHt53Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olEIp0eO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olEIp0eO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6469DC116B1;
	Fri, 12 Dec 2025 06:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765519946;
	bh=3/74Qr7EVIIQir0V3rtgwB12WXIr61WFooRVftKwk0U=;
	h=From:To:Cc:Subject:Date:From;
	b=olEIp0eOcsMIRR1Wt/Nll9Wsbl0MdrvRbBw2BW5qFQnkKx8TAQxLyFaduDdmEicuY
	 kalp9HRlqD65ZGhpCYP3o/Wk3jHKudNRQ4sMDER0uxrJeJfzz240/aKtSWTL91/yBj
	 xy2Iuxnr2iXvf85u9ijtpbwJnNzQ4PzzAqsNr6xfQ9vepPlyseSDenBvdV/EUaXUVb
	 dNVA/Uj3gFeE8fzBxs+iEWdcniaj7HZiszbneRwRdD4mw8P9r5iK1xwjPmB+Fd1TAf
	 NxcdrX03oMyEzcRjMTYhkY1g+hrRulSdG9BKNZN5TKpzSaZhy+kMdnILHNxxmV101I
	 dlqTyJsrxuyCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sam James <sam@gentoo.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.18-5.10] alpha: don't reference obsolete termio struct for TC* constants
Date: Fri, 12 Dec 2025 01:12:11 -0500
Message-ID: <20251212061223.305139-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sam James <sam@gentoo.org>

[ Upstream commit 9aeed9041929812a10a6d693af050846942a1d16 ]

Similar in nature to ab107276607af90b13a5994997e19b7b9731e251. glibc-2.42
drops the legacy termio struct, but the ioctls.h header still defines some
TC* constants in terms of termio (via sizeof). Hardcode the values instead.

This fixes building Python for example, which falls over like:
  ./Modules/termios.c:1119:16: error: invalid application of 'sizeof' to incomplete type 'struct termio'

Link: https://bugs.gentoo.org/961769
Link: https://bugs.gentoo.org/962600
Signed-off-by: Sam James <sam@gentoo.org>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/6ebd3451908785cad53b50ca6bc46cfe9d6bc03c.1764922497.git.sam@gentoo.org
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Summary

### 1. COMMIT MESSAGE ANALYSIS

This commit addresses a **userspace build failure** caused by glibc-2.42
removing the legacy `struct termio` definition. The kernel's uapi header
`arch/alpha/include/uapi/asm/ioctls.h` uses `sizeof(struct termio)` in
macro expansions, which fails when that struct is undefined.

**Key signals:**
- Links to two real bug reports (Gentoo bugs #961769 and #962600)
- References a prior fix (ab107276607af) for powerpc with the exact same
  issue
- Has `Reviewed-by:` tag
- Demonstrates real-world impact: Python build failure

### 2. CODE CHANGE ANALYSIS

**What the change does:**
```c
// Before: Uses sizeof(struct termio) in macro expansion
#define TCGETA          _IOR('t', 23, struct termio)
// After: Pre-computed constant
#define TCGETA          0x40127417
```

**Verification of the hardcoded values:**
Looking at `arch/alpha/include/uapi/asm/ioctl.h`, the ioctl encoding on
alpha is:
- `_IOC_SIZESHIFT` = 16, `_IOC_DIRSHIFT` = 29
- `_IOC_READ` = 2, `_IOC_WRITE` = 4

For `TCGETA = _IOR('t', 23, struct termio)`:
- dir=2, type=0x74, nr=0x17, size=18(0x12)
- Result: `(2<<29)|(0x74<<8)|(0x17)|(0x12<<16)` = **0x40127417** ✓

The hardcoded values are mathematically correct.

### 3. CLASSIFICATION

**Category: BUILD FIX**

This falls under the **build fixes** exception category - it's critical
for users who need to build userspace software with modern glibc. Other
architectures (powerpc, sh, xtensa) already have identical fixes in the
tree.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 4
- **Files touched:** 1 (alpha-specific uapi header)
- **Risk: EXTREMELY LOW**
  - No runtime behavior change - only affects compilation
  - The ioctl numbers are identical (pre-computed vs macro-computed)
  - Pattern already established in other architectures

### 5. USER IMPACT

- **Affected users:** Anyone on alpha using glibc 2.42+ (e.g., Gentoo
  users)
- **Severity:** Critical for affected users - cannot build Python, and
  potentially many other programs that use termios
- **Scope:** Limited to alpha architecture, but complete blocker for
  those users

### 6. STABILITY INDICATORS

- Has `Reviewed-by:` tag
- Same pattern accepted for powerpc (commit ab107276607af)
- Documented with actual bug reports showing real users affected
- No runtime changes - purely compile-time fix

### 7. DEPENDENCY CHECK

- **No dependencies** - standalone fix
- The affected file exists in all stable trees (uapi header)
- Clean application expected

### Final Assessment

**Pros:**
- Fixes a real, documented build breakage with modern glibc
- Extremely small and localized (4 lines, 1 file)
- Zero runtime risk - mathematically equivalent values
- Established precedent with powerpc fix
- Has review tag and bug report links

**Cons:**
- No explicit `Cc: stable@vger.kernel.org` tag
- Alpha is a niche architecture

**Verdict:** This is textbook stable material. It's a build fix that:
1. Is obviously correct (values are mathematically equivalent)
2. Fixes a real bug (complete build failure)
3. Is small and contained (4 lines)
4. Has no runtime risk whatsoever
5. Follows established precedent from other architectures

The lack of a stable tag is not disqualifying - many valid stable
patches don't have it. Build compatibility with modern toolchains is
exactly what stable trees need to maintain.

**YES**

 arch/alpha/include/uapi/asm/ioctls.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/ioctls.h b/arch/alpha/include/uapi/asm/ioctls.h
index 971311605288f..a09d04b49cc65 100644
--- a/arch/alpha/include/uapi/asm/ioctls.h
+++ b/arch/alpha/include/uapi/asm/ioctls.h
@@ -23,10 +23,10 @@
 #define TCSETSW		_IOW('t', 21, struct termios)
 #define TCSETSF		_IOW('t', 22, struct termios)
 
-#define TCGETA		_IOR('t', 23, struct termio)
-#define TCSETA		_IOW('t', 24, struct termio)
-#define TCSETAW		_IOW('t', 25, struct termio)
-#define TCSETAF		_IOW('t', 28, struct termio)
+#define TCGETA          0x40127417
+#define TCSETA          0x80127418
+#define TCSETAW         0x80127419
+#define TCSETAF         0x8012741c
 
 #define TCSBRK		_IO('t', 29)
 #define TCXONC		_IO('t', 30)
-- 
2.51.0

