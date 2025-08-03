Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7043621C176;
	Sun,  3 Aug 2025 21:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256202; cv=none; b=ivejLYmiPRmWuSH8kYK+CqNG2MXRzzhyMPW4vTk9ujy6T2uZGHDD+Ej4H2pnzJJRa1wPAIvc4s9kmjmuMF4f7I14XHJyqsRHqZbKTWt6c1Rn3ZL/wonf4t4wwoY4SPuE+pA9RxoywtQX8OSprdnxzrZ/qgsZsCKk+rqYVTLyWk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256202; c=relaxed/simple;
	bh=uF9qpFX3ed7leyRa7f8E5DkG+FodscKwZGF5TkXRHUM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tj7qOHrr/8b94CUSUsMA3DwkEXwg1PPKYwlyPDjN+5o/YaeyT2di2zF/xlOxzh47+uJStdEMwkOZv4tVidTkTwGD/su5D7tuupZCFkWxOHZEc9BfNFnYHYYuovR/SEirgtymmx2/z1Xjz3T4aw7EEn7cNTdFyt3brNEkvcPzf4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NMihE+/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NMihE+/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16489C4CEEB;
	Sun,  3 Aug 2025 21:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256202;
	bh=uF9qpFX3ed7leyRa7f8E5DkG+FodscKwZGF5TkXRHUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMihE+/YRNhlNp7yiYzqz5L9M0XMdmlIeVDklr+lDf2KPq+p+9RGzPCQY34d8ReVC
	 +Dx4O8AhCLD6nEjVsC6HIv9+7FCz7qskjirGMfy5HJwTpPzwIxh/5zeSgeABjaHp5x
	 NuzKyG2JxlGJPXygMhgZdJ+HhKFbUM+FTA12EKrWFUiiAZRJo8979b9lETWBPHwS1X
	 9C05PQ7OZkBZctJ4Umb9cnkDxc63SVCZPGR4j73srMTblIfFmrBxnHeKL2l2Ypch7P
	 LNBVm8AmmnJhuzcFwT8m42gRE8nKAoN5P/8l3I5BmEOTDn/VI8v/KCYigQrvvISJd7
	 gJU6l+qGYGxxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 5/9] arm64: Handle KCOV __init vs inline mismatches
Date: Sun,  3 Aug 2025 17:23:05 -0400
Message-Id: <20250803212309.3549683-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212309.3549683-1-sashal@kernel.org>
References: <20250803212309.3549683-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.296
Content-Transfer-Encoding: 8bit

From: Kees Cook <kees@kernel.org>

[ Upstream commit 65c430906efffee9bd7551d474f01a6b1197df90 ]

GCC appears to have kind of fragile inlining heuristics, in the
sense that it can change whether or not it inlines something based on
optimizations. It looks like the kcov instrumentation being added (or in
this case, removed) from a function changes the optimization results,
and some functions marked "inline" are _not_ inlined. In that case,
we end up with __init code calling a function not marked __init, and we
get the build warnings I'm trying to eliminate in the coming patch that
adds __no_sanitize_coverage to __init functions:

WARNING: modpost: vmlinux: section mismatch in reference: acpi_get_enable_method+0x1c (section: .text.unlikely) -> acpi_psci_present (section: .init.text)

This problem is somewhat fragile (though using either __always_inline
or __init will deterministically solve it), but we've tripped over
this before with GCC and the solution has usually been to just use
__always_inline and move on.

For arm64 this requires forcing one ACPI function to be inlined with
__always_inline.

Link: https://lore.kernel.org/r/20250724055029.3623499-1-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, here is my determination:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real build warning/bug**: The commit addresses section
   mismatch warnings that occur when GCC's inlining heuristics change
   due to KCOV instrumentation. These warnings indicate potential
   runtime issues where __init code (which gets discarded after boot)
   calls non-__init functions, which could lead to crashes if those
   functions are called after the __init sections are freed.

2. **Minimal and contained change**: The fix is extremely simple - it
   only changes one function declaration from `static inline` to `static
   __always_inline` in arch/arm64/include/asm/acpi.h:153. This is a
   minimal change with very low risk.


4. **Prevents build regressions**: Without this fix, enabling KCOV
   instrumentation could cause build failures or warnings in stable
   kernels, which would be a regression for users who need to use KCOV
   for testing.

5. **Well-understood issue**: The commit message clearly explains the
   root cause - GCC's fragile inlining heuristics that change based on
   optimizations/instrumentation. The solution (__always_inline) is a
   well-established pattern in the kernel for forcing inlining.

6. **No functional change**: The change only affects compilation
   behavior by forcing inlining. The actual runtime behavior remains
   identical - `acpi_get_enable_method()` still calls
   `acpi_psci_present()` (marked __init) and returns the same values.

The specific code change shows `acpi_get_enable_method()` being changed
from `static inline` to `static __always_inline`. This function calls
`acpi_psci_present()`, which is marked `__init` (as seen in
arch/arm64/kernel/acpi.c:110). Without forced inlining, GCC might not
inline `acpi_get_enable_method()`, resulting in non-__init code calling
__init code, triggering the section mismatch warning.

This is exactly the type of targeted, low-risk fix that stable trees are
meant to include.

 arch/arm64/include/asm/acpi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index cbf97e648d19..d1ddf5575973 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -141,7 +141,7 @@ acpi_set_mailbox_entry(int cpu, struct acpi_madt_generic_interrupt *processor)
 {}
 #endif
 
-static inline const char *acpi_get_enable_method(int cpu)
+static __always_inline const char *acpi_get_enable_method(int cpu)
 {
 	if (acpi_psci_present())
 		return "psci";
-- 
2.39.5

