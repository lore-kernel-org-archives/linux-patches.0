Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D80872618;
	Fri, 12 Dec 2025 06:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765519952; cv=none; b=Dp5CkZvBSdmhr1AIJ1HBGOGtF1L5YA1IsHqY7gC1NYzZZAZdoheSsVM7SFWWcsZZLmRSxaPGjJkO3N+LkohuLWoYQVFlHYQkp+35TVIWCmHyOMDHC3cvmH8n5tDW4y5O0oiqMTf8ckhK718CfRwconxlBAeDHUznKZLgAueo9Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765519952; c=relaxed/simple;
	bh=tu35v5JnahKDsmp5vWzJfU95RMwm0sPSKcmBSUpkSDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lK4sVeWkyPSmhVyHm82muYG2JhH1/nHgnswiW9WHJQNoJCntjZLhhtzSLSpYLJ3R1r5fT83pCvSiQj5J9uHSu7SeCFR6kxRf9asoS+BQ4BEYjonIUKaniQ25zuObt6cVSsXP/dn+6QU3rONM+U0NsCeGoHXGcc7BEg31L4UW2uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Szdrq9GD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Szdrq9GD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9964CC16AAE;
	Fri, 12 Dec 2025 06:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765519952;
	bh=tu35v5JnahKDsmp5vWzJfU95RMwm0sPSKcmBSUpkSDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Szdrq9GDzcfXkTz1z+U+6vV8FIPOGzAfB01ToY0aURn2Eqmimse2bmGIiuHu9i6fZ
	 jPdpVxBN2O5t9+uT3j1gdpDRQZQZ+tAuqGdPrKrCaTCFTLomVvogf6x5myDGhBhKO7
	 6qhV6yNRgnZ6/NCpE4fiFWVwpKRZc7S/BfrQZQYITFzeIMEERG3TYrwsMnJTQqR98k
	 jJFvZuwRYVhjsSklsVmrbEfb0LWxxaYs02uTYnTM6rXxYPyaOGyShTPWFLMhzN53Jx
	 tFqp/3Gak1U44YAiDTbMJZB60eVjI6ASl1i7EZnKnX+qVpM2VfEept5Nw5F1kZtns5
	 YJDDUN+dIcHoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>,
	linux@armlinux.org.uk,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	nathan@kernel.org,
	kees@kernel.org,
	peterz@infradead.org,
	lumag@kernel.org,
	richard@nod.at,
	chrisi.schrefl@gmail.com,
	lukas.bulwahn@redhat.com,
	afd@ti.com,
	linux-arm-kernel@lists.infradead.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-5.10] ARM: 9461/1: Disable HIGHPTE on PREEMPT_RT kernels
Date: Fri, 12 Dec 2025 01:12:12 -0500
Message-ID: <20251212061223.305139-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251212061223.305139-1-sashal@kernel.org>
References: <20251212061223.305139-1-sashal@kernel.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit fedadc4137234c3d00c4785eeed3e747fe9036ae ]

gup_pgd_range() is invoked with disabled interrupts and invokes
__kmap_local_page_prot() via pte_offset_map(), gup_p4d_range().
With HIGHPTE enabled, __kmap_local_page_prot() invokes kmap_high_get()
which uses a spinlock_t via lock_kmap_any(). This leads to an
sleeping-while-atomic error on PREEMPT_RT because spinlock_t becomes a
sleeping lock and must not be acquired in atomic context.

The loop in map_new_virtual() uses wait_queue_head_t for wake up which
also is using a spinlock_t.

Since HIGHPTE is rarely needed at all, turn it off for PREEMPT_RT
to allow the use of get_user_pages_fast().

[arnd: rework patch to turn off HIGHPTE instead of HAVE_PAST_GUP]

Co-developed-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Commit Analysis: ARM: 9461/1: Disable HIGHPTE on PREEMPT_RT kernels

## 1. COMMIT MESSAGE ANALYSIS

**Problem identified**: The commit addresses a "sleeping-while-atomic"
bug on PREEMPT_RT ARM kernels. The issue occurs because:
- `gup_pgd_range()` runs with interrupts disabled (atomic context)
- With HIGHPTE enabled, the code path calls `kmap_high_get()` which
  acquires a `spinlock_t` via `lock_kmap_any()`
- On PREEMPT_RT, `spinlock_t` becomes a sleeping lock (mutex)
- Attempting to acquire a sleeping lock in atomic context is a bug

**Tags present**:
- Acked-by: Linus Walleij (ARM/pinctrl maintainer)
- Reviewed-by: Arnd Bergmann (major ARM contributor)
- Signed-off-by: Sebastian Andrzej Siewior (PREEMPT_RT maintainer)
- Signed-off-by: Russell King (ARM maintainer)

**Missing tags**: No `Cc: stable@vger.kernel.org` or `Fixes:` tag.

## 2. CODE CHANGE ANALYSIS

The change is a single-line Kconfig modification:

```diff
- depends on HIGHMEM
+       depends on HIGHMEM && !PREEMPT_RT
```

This simply prevents the `HIGHPTE` configuration option from being
selected when `PREEMPT_RT` is enabled. The technical mechanism of the
bug is clear:

1. `get_user_pages_fast()` → `gup_pgd_range()` (runs with interrupts
   disabled)
2. → `pte_offset_map()` → `__kmap_local_page_prot()` → `kmap_high_get()`
3. `kmap_high_get()` calls `lock_kmap_any()` which uses `spinlock_t`
4. On PREEMPT_RT: `spinlock_t` = sleeping lock → BUG in atomic context

The commit message notes that "HIGHPTE is rarely needed at all" - it's
an optimization to put page tables in high memory, which is typically
unnecessary on modern systems.

## 3. CLASSIFICATION

- **Bug type**: Runtime crash/BUG (sleeping-while-atomic violation)
- **Not a new feature**: Disables a problematic configuration
  combination
- **Not a security fix**: No CVE or security-sensitive code
- **Build fix category**: No, this is a runtime issue

## 4. SCOPE AND RISK ASSESSMENT

**Scope**:
- 1 file changed (`arch/arm/Kconfig`)
- 1 line modified
- Affects only ARM + PREEMPT_RT + HIGHMEM configurations

**Risk**: **Very low**
- This is a Kconfig dependency change only
- Users who previously had HIGHPTE enabled will now have it disabled on
  PREEMPT_RT
- The workaround is conservative (disable the problematic feature rather
  than complex code fixes)
- Cannot introduce regressions in other code paths

## 5. USER IMPACT

**Affected users**: ARM systems running PREEMPT_RT kernels with HIGHMEM
(systems with >~800MB RAM on 32-bit ARM)

**Severity**: High for affected users
- `get_user_pages_fast()` is a commonly used path for I/O and memory
  management
- Without this fix, users would hit kernel warnings/crashes when GUP
  fast path is used
- This completely breaks PREEMPT_RT usability on affected configurations

## 6. STABILITY INDICATORS

**Review chain is strong**:
- Sebastian Andrzej Siewior (PREEMPT_RT maintainer) developed this
- Arnd Bergmann reworked and reviewed it
- Linus Walleij acked it
- Russell King (ARM maintainer) accepted it

## 7. DEPENDENCY CHECK

This is a standalone Kconfig change. Dependencies:
- `PREEMPT_RT` must exist in the kernel - PREEMPT_RT was merged into
  mainline in kernel 6.12
- `HIGHPTE` and `HIGHMEM` options exist on ARM in all relevant kernel
  versions

The fix should apply cleanly to any stable tree with PREEMPT_RT support.

## STABLE KERNEL CRITERIA EVALUATION

| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✅ Yes - disables problematic config combination |
| Fixes real bug | ✅ Yes - sleeping-while-atomic crash |
| Important issue | ✅ Yes - crashes on PREEMPT_RT systems |
| Small and contained | ✅ Yes - 1 line Kconfig change |
| No new features | ✅ Yes - only disables an option |
| Clean application | ✅ Yes - simple dependency addition |

## CONCERNS

1. **No explicit stable request**: Maintainers didn't add `Cc: stable`.
   However, the fix is clearly appropriate for stable.
2. **PREEMPT_RT availability**: Only relevant for kernels 6.12+ where
   PREEMPT_RT was merged into mainline.

## CONCLUSION

This commit fixes a real, reproducible crash on ARM PREEMPT_RT systems.
The fix is minimal (1 line), obviously correct (disables problematic
feature combination), well-reviewed by relevant maintainers (ARM, RT),
and carries essentially zero risk. While there's no explicit stable tag,
the technical merits strongly support backporting.

The sleeping-while-atomic bug would make `get_user_pages_fast()`
unusable on affected configurations, which is a serious correctness
issue for PREEMPT_RT users who require deterministic behavior.

**YES**

 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4fb985b76e97f..70cd3b5b5a059 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1215,7 +1215,7 @@ config HIGHMEM
 
 config HIGHPTE
 	bool "Allocate 2nd-level pagetables from highmem" if EXPERT
-	depends on HIGHMEM
+	depends on HIGHMEM && !PREEMPT_RT
 	default y
 	help
 	  The VM uses one page of physical memory for each page table.
-- 
2.51.0

