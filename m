Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38B21BD01D;
	Mon,  4 Aug 2025 00:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268106; cv=none; b=StCp9vlUAhWeJJwmfc/ZboCO0W+cSpopJIAo0NYEeHwaNJcR4ozArv8INXxEIMt7hEKyYtb5K430qTwOq1yi/LtmilZfnM9yX6YLLpqCfWome9Ebl7DBw2pLWNLn8Mc9Lw4yGH7m8UF3MnmVJdmOA1Vgmnw01lVxw0e0AaYM8rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268106; c=relaxed/simple;
	bh=KoEGNmfvKPDfWbbmgLFnz7UV8fyqUemgT0HiFtNlw04=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cVjTPDdWNk+JbClljHD2NXuw1RMYjvzp6dPSftdWYQPNt2B2L2qj7QGQexZeo5lblqh+LL2Ft2/fcxxXHenq2ttyMWA51no9cY19mGa11BXeL9eMWZ8DcKLotkc9Za6bxgI0drpniN2ieOHnnKe2pFgqqAYOm4OpqpgY6cy7ilc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ly1HUrHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ly1HUrHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4684CC4CEEB;
	Mon,  4 Aug 2025 00:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268105;
	bh=KoEGNmfvKPDfWbbmgLFnz7UV8fyqUemgT0HiFtNlw04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ly1HUrHxdokdQH7IbAdGi8GltvQ7TEi1KwbrodSlzVhdR2Yi0uoUhJcL4hh1kq6tI
	 4m8Xxv6fg0XOS9+ec/7AaTZK6EG2glR2KMTHRTDiDNaJHX+Pct8edx8jygVgRu5u5i
	 7Ndqmadsod5v5Afvox9sWzu8Cq2h/povhCTPMTs9kn+1reNr+M/onA2+FDk2dk3GKt
	 /52Z4/jiF9gJqxkzJTPOywmmhZHyPeBdmQxO4yTjF2nmeQdbF7ejUmSopnretKfdG0
	 wq/PtajUd8s/o0TXMajiIMGqz/NvBDOkcWtLDw272j+D8bohNSYjhNeQM+EgbpfJcK
	 sDV31VgjrDnhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	peterz@infradead.org,
	jpoimboe@kernel.org
Subject: [PATCH AUTOSEL 5.10 25/39] x86/bugs: Avoid warning when overriding return thunk
Date: Sun,  3 Aug 2025 20:40:27 -0400
Message-Id: <20250804004041.3628812-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804004041.3628812-1-sashal@kernel.org>
References: <20250804004041.3628812-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.240
Content-Transfer-Encoding: 8bit

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit 9f85fdb9fc5a1bd308a10a0a7d7e34f2712ba58b ]

The purpose of the warning is to prevent an unexpected change to the return
thunk mitigation. However, there are legitimate cases where the return
thunk is intentionally set more than once. For example, ITS and SRSO both
can set the return thunk after retbleed has set it. In both the cases
retbleed is still mitigated.

Replace the warning with an info about the active return thunk.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250611-eibrs-fix-v4-3-5ff86cac6c61@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Key Reasons for Backporting:

### 1. **Fixes a Real User-Visible Issue**
The code change shows that the original warning was triggering in
legitimate scenarios:
```c
- if (x86_return_thunk != __x86_return_thunk)
- pr_warn("x86/bugs: return thunk changed\n");
```
This warning would appear in kernel logs whenever multiple CPU
vulnerability mitigations interact, which is a normal and expected
behavior. The false positive warnings could:
- Cause unnecessary alarm for system administrators
- Clutter kernel logs with misleading information
- Potentially mask real issues by creating noise

### 2. **Small, Contained Change**
The commit is minimal and focused:
- Only modifies 3 lines of functional code
- Changes are confined to a single function (`set_return_thunk()`)
- Simply replaces a conditional warning with an unconditional info
  message:
```c
+       pr_info("active return thunk: %ps\n", thunk);
```

### 3. **No Risk of Regression**
The change is safe because:
- It doesn't modify any security logic or mitigation behavior
- The function still sets the return thunk exactly as before
- The new info message provides better visibility into which mitigation
  is active
- The `%ps` format specifier safely prints the function symbol name

### 4. **Addresses Security Mitigation Interactions**
The commit message explicitly states that "ITS and SRSO both can set the
return thunk after retbleed has set it" and that "retbleed is still
mitigated." This is important for stable kernels because:
- Multiple CVE mitigations (Retbleed, SRSO, ITS) need to coexist
- The warning was incorrectly flagging legitimate mitigation sequences
- Stable kernels need these mitigations to work together without false
  alarms

### 5. **Part of Critical Security Infrastructure**
The x86/bugs subsystem handles CPU vulnerability mitigations for:
- CVE-2023-20569 (SRSO)
- CVE-2024-28956 (ITS)
- Retbleed vulnerabilities
These are critical security features that need to function correctly in
stable kernels.

### 6. **Improves Operational Visibility**
The new info message (`pr_info("active return thunk: %ps\n", thunk);`)
actually improves debugging and system monitoring by:
- Showing which specific return thunk is currently active
- Providing better audit trail for security mitigation changes
- Using proper function symbol printing with `%ps`

## Conclusion:
This commit meets all the criteria for stable backporting:
- Fixes a real issue (false positive warnings)
- Minimal risk (3-line change, no logic modifications)
- Improves system behavior without introducing new features
- Addresses interaction between critical security mitigations
- Makes the kernel more reliable and less confusing for operators

The change is particularly important for stable kernels that need to
support multiple CPU vulnerability mitigations simultaneously without
generating misleading warnings.

 arch/x86/kernel/cpu/bugs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 7c269dcb7cec..6ff9fd836d87 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -67,10 +67,9 @@ void (*x86_return_thunk)(void) __ro_after_init = &__x86_return_thunk;
 
 static void __init set_return_thunk(void *thunk)
 {
-	if (x86_return_thunk != __x86_return_thunk)
-		pr_warn("x86/bugs: return thunk changed\n");
-
 	x86_return_thunk = thunk;
+
+	pr_info("active return thunk: %ps\n", thunk);
 }
 
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
-- 
2.39.5

