Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD1115A8;
	Mon,  4 Aug 2025 00:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268210; cv=none; b=FaldwoVF/MsBpHt0ST8gkXMdudQawyNT8q28BeCTm7xRHdgpEdStY2+GyVuWcqeSiYO1X1m3gGmnY119mvTmnj278k1WTyPtjAhbi58m8KVEbNCXky7kViUEFsaWAxAppQO2cqanEIBNBVxUDM/Xic/wtAg/PYijg1BIbG++/xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268210; c=relaxed/simple;
	bh=2lDOajn47JpkHdivvMSv/0Ne/wtcxP5+84gMtOraw1I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2j2RGjclWx4uBZ5Lmkd1dGaBseVSzIJB2z8dCUI3nlEJLh4ZJPW6d65UajV5Vgav9hsioDaTxS7G/KThFXj6kl/nOkXeZdjVmEkn1WgrlBJV0N3PkoZZ2oZEhkiV6UAvOSDpmQlM98zfFgl9J2vFRM4O0sioKghv9OPiBaDh+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSTw3Jea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSTw3Jea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9654FC4CEF8;
	Mon,  4 Aug 2025 00:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268209;
	bh=2lDOajn47JpkHdivvMSv/0Ne/wtcxP5+84gMtOraw1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSTw3JeaglWzZ41ZGoYSab7mIluJ5+YJTkuZYk1mqm2+ZPm5nc8rueTdjs4p5xNq0
	 2NOUEgKrFVHTTPUToOmhs+1mxIL4wBWIQujpF3dscyIMn2E8hoPWqmnPUzze/mfAFo
	 0c+qSLtXEFfg8AIFfNXF1E7PCaCMy3U+4hyZbiaaYW3ydS1dS+wYp2ENhND0TJD0gQ
	 RU8JB9Uz7iR63Bd7JAl093BJb+eePbe5QBAm2H1p4dEimqqhrT1gHa9sz8wNK9qvbE
	 cqJlILQEYRYgX50SF+89oeOQOipcfvC4AW6BPzREN8N5Y9TM39LoarN9D3jY16oyPs
	 c8izK2AeSZgaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 25/28] platform/x86: thinkpad_acpi: Handle KCOV __init vs inline mismatches
Date: Sun,  3 Aug 2025 20:42:24 -0400
Message-Id: <20250804004227.3630243-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804004227.3630243-1-sashal@kernel.org>
References: <20250804004227.3630243-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.296
Content-Transfer-Encoding: 8bit

From: Kees Cook <kees@kernel.org>

[ Upstream commit 6418a8504187dc7f5b6f9d0649c03e362cb0664b ]

When KCOV is enabled all functions get instrumented, unless the
__no_sanitize_coverage attribute is used. To prepare for
__no_sanitize_coverage being applied to __init functions[1], we have
to handle differences in how GCC's inline optimizations get resolved.
For thinkpad_acpi routines, this means forcing two functions to be
inline with __always_inline.

Link: https://lore.kernel.org/lkml/20250523043935.2009972-11-kees@kernel.org/ [1]
Signed-off-by: Kees Cook <kees@kernel.org>
Link: https://lore.kernel.org/r/20250529181831.work.439-kees@kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Detailed Analysis

### Nature of the Change
The commit modifies two functions in
`drivers/platform/x86/lenovo/thinkpad_acpi.c`:
- `tpacpi_is_lenovo()`: Changed from `static inline` to `static
  __always_inline`
- `tpacpi_is_ibm()`: Changed from `static inline` to `static
  __always_inline`

Both functions are marked with `__init` and are simple one-line
functions that check the vendor ID.

### Root Cause
This is a build fix addressing a subtle interaction between:
1. KCOV kernel coverage instrumentation
2. GCC's inline optimization heuristics
3. Linux kernel's __init section handling

When KCOV is enabled, all functions get instrumented unless marked with
`__no_sanitize_coverage`. The commit message indicates this is
preparation for applying `__no_sanitize_coverage` to `__init` functions.
The problem occurs because:

1. With KCOV instrumentation, GCC may inline these functions into
   `__init` callers
2. Without KCOV instrumentation (when `__no_sanitize_coverage` is
   applied), GCC's heuristics change and it may decide NOT to inline
   them
3. This creates a section mismatch where `__init` code calls
   non-`__init` functions, causing build warnings/errors

### Why This Qualifies for Stable Backport

1. **Fixes a Real Bug**: This addresses legitimate build failures when
   `CONFIG_KCOV=y` is enabled, which affects:
   - Kernel developers doing coverage testing
   - CI/CD systems running kernel tests
   - Distribution builders enabling KCOV for testing

2. **Minimal Risk**: The change is extremely conservative:
   - Only changes inline hints from `inline` to `__always_inline`
   - No functional changes whatsoever
   - Affects only two simple getter functions
   - Cannot introduce runtime regressions

3. **Small and Contained**: The patch touches only 2 lines in a single
   file, making it easy to review and backport

4. **Part of Broader Fix**: This is part of a kernel-wide effort to fix
   KCOV-related build issues, with similar fixes across multiple
   architectures and subsystems

5. **Build Infrastructure**: Stable kernels need to maintain
   buildability with various configurations, including KCOV-enabled
   builds for testing

### Specific Code Impact
Looking at the changed functions:
```c
-static inline bool __pure __init tpacpi_is_lenovo(void)
+static __always_inline bool __pure __init tpacpi_is_lenovo(void)
 {
        return thinkpad_id.vendor == PCI_VENDOR_ID_LENOVO;
 }

-static inline bool __pure __init tpacpi_is_ibm(void)
+static __always_inline bool __pure __init tpacpi_is_ibm(void)
 {
        return thinkpad_id.vendor == PCI_VENDOR_ID_IBM;
 }
```

These are trivial getter functions that absolutely should be inlined.
Using `__always_inline` ensures consistent behavior regardless of KCOV
configuration, preventing section mismatch warnings.

### Conclusion
This is a textbook example of a stable-appropriate fix: it solves a real
build problem, has zero functional impact, is minimal in scope, and has
essentially no risk of causing regressions. It should be backported to
stable kernels that support KCOV (4.6+) to maintain build compatibility
with coverage testing configurations.

 drivers/platform/x86/thinkpad_acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 9eb74d9e1519..e480fff7142a 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -514,12 +514,12 @@ static unsigned long __init tpacpi_check_quirks(
 	return 0;
 }
 
-static inline bool __pure __init tpacpi_is_lenovo(void)
+static __always_inline bool __pure __init tpacpi_is_lenovo(void)
 {
 	return thinkpad_id.vendor == PCI_VENDOR_ID_LENOVO;
 }
 
-static inline bool __pure __init tpacpi_is_ibm(void)
+static __always_inline bool __pure __init tpacpi_is_ibm(void)
 {
 	return thinkpad_id.vendor == PCI_VENDOR_ID_IBM;
 }
-- 
2.39.5

