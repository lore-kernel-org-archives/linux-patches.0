Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90011F3B97;
	Mon, 30 Jun 2025 20:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317166; cv=none; b=PQWG+kNfiEByqSHW1kOgsjaY13UgZITDOPD0L86xYRYgDaSOGbWMjYOZGwMreEQUD31SoulXQq0IgIhHmcN+Tq2awYH4DHOG5YwErWeSkvJiQKRQTSCT2aBkwL2Hf9YcSRg1PP/2Vv8LhuIuEHv+r0iVyzhny2+MOpdBSRsq9X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317166; c=relaxed/simple;
	bh=EsZqcvUvp7a4JCp9st0FuMFpsHT2F3mKpjIq3oWzNaw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rpB9pPH75GSGReVgczXdj7NRBxdZax+wb9nm0MY8vvAl61jJPV0pTQpzRnR4R6t56bnxMrznCqCXDDmfP6aSNWwcqNI3Or8Fh9FSygTSstHxaeVNbRBXdABUBbP15AS283F9OhKvlpApF73rpyKwa2eWUcDfRXjWppDdb83+dSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqbPcXrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqbPcXrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D75C4CEE3;
	Mon, 30 Jun 2025 20:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317165;
	bh=EsZqcvUvp7a4JCp9st0FuMFpsHT2F3mKpjIq3oWzNaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqbPcXrOA8VCHjyLN4Zibj4yV6ILLyTkNe6bD05PVBsE6eyn5SCugKND+xSuIXfNy
	 c5YSYe8teulotXz3xZgjwn8nvlYOa7JnU2Fj75Ts4e0RzYee9/sglrKhGR7JVm0jss
	 wwHXXnHQ4gWPe2wdiMB0NaHzrzQ+NkQKLrOmhH9OsqdCqyd/E4do/IuFrt7hzec4cV
	 Yw1feSWHfS5fsnYJepcWpPL0IoHt5Uk2If42/bKOmEUhoyKIcCqz+pt+8QaJgc+dr3
	 WBDgiENhvxdsGcCyzNh4GZDNs7M4zDjHhHygKW+DCfdbsNXxKCKWNhLqeMwb2+KV8+
	 zXG4jKwC6ikGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fangrui Song <i@maskray.me>,
	Nathan Chancellor <nathan@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sasha Levin <sashal@kernel.org>,
	paul.walmsley@sifive.com,
	aou@eecs.berkeley.edu,
	tglx@linutronix.de,
	thomas.weissschuh@linutronix.de,
	namcao@linutronix.de,
	linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.15 20/23] riscv: vdso: Exclude .rodata from the PT_DYNAMIC segment
Date: Mon, 30 Jun 2025 16:44:25 -0400
Message-Id: <20250630204429.1357695-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204429.1357695-1-sashal@kernel.org>
References: <20250630204429.1357695-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.4
Content-Transfer-Encoding: 8bit

From: Fangrui Song <i@maskray.me>

[ Upstream commit e0eb1b6b0cd29ca7793c501d5960fd36ba11f110 ]

.rodata is implicitly included in the PT_DYNAMIC segment due to
inheriting the segment of the preceding .dynamic section (in both GNU ld
and LLD).  When the .rodata section's size is not a multiple of 16
bytes on riscv64, llvm-readelf will report a "PT_DYNAMIC dynamic table
is invalid" warning.  Note: in the presence of the .dynamic section, GNU
readelf and llvm-readelf's -d option decodes the dynamic section using
the section.

This issue arose after commit 8f8c1ff879fab60f80f3a7aec3000f47e5b03ba9
("riscv: vdso.lds.S: remove hardcoded 0x800 .text start addr"), which
placed .rodata directly after .dynamic by removing .eh_frame.

This patch resolves the implicit inclusion into PT_DYNAMIC by explicitly
specifying the :text output section phdr.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2093
Signed-off-by: Fangrui Song <i@maskray.me>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250602-riscv-vdso-v1-1-0620cf63cff0@maskray.me
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Regression Fix**: The commit explicitly fixes a regression
   introduced by commit 8f8c1ff879fab60f80f3a7aec3000f47e5b03ba9
   ("riscv: vdso.lds.S: remove hardcoded 0x800 .text start addr").
   Regression fixes are high-priority candidates for stable backporting.

2. **Fixes Invalid ELF Structure**: The issue is not merely cosmetic.
   The PT_DYNAMIC segment is reported as "invalid" by llvm-readelf,
   indicating the ELF structure is technically incorrect. From the
   linker script:
  ```
  .dynamic        : { *(.dynamic) }               :text   :dynamic
  .rodata         : {
  ...
  }  // implicitly inherits :dynamic from previous section
  ```
  Without the explicit `:text` specification, `.rodata` inherits the
  segment attributes from the preceding `.dynamic` section, incorrectly
  including it in the PT_DYNAMIC segment.

3. **Minimal and Safe Change**: The fix is a single-line change that
   adds `:text` to the `.rodata` section definition:
  ```diff
   - }
   +    }                                               :text
   ```
   This explicitly places `.rodata` in the text segment only, excluding
it from PT_DYNAMIC. The change has no functional impact beyond
correcting the ELF structure.

4. **Similar to Previous Backported Commits**: This is similar to commit
   #2 in the reference list ("riscv: vdso: fix section overlapping under
   some conditions") which was marked YES for backporting. Both commits
   fix structural issues in the vDSO linker script that cause
   build/tooling errors.

5. **Potential for Broader Impact**: While the immediate symptom is a
   warning from llvm-readelf, an invalid PT_DYNAMIC segment could
   potentially cause issues with:
   - Build systems that validate ELF structures
   - Runtime loaders with strict ELF validation
   - Debugging and analysis tools
   - Future toolchain versions that may be less tolerant of invalid
     structures

The commit meets the stable tree criteria: it fixes an important bug
(invalid ELF structure), the fix is small and contained, and there's
minimal risk of regression.

 arch/riscv/kernel/vdso/vdso.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
index 8e86965a8aae4..646e268ede443 100644
--- a/arch/riscv/kernel/vdso/vdso.lds.S
+++ b/arch/riscv/kernel/vdso/vdso.lds.S
@@ -30,7 +30,7 @@ SECTIONS
 		*(.data .data.* .gnu.linkonce.d.*)
 		*(.dynbss)
 		*(.bss .bss.* .gnu.linkonce.b.*)
-	}
+	}						:text
 
 	.note		: { *(.note.*) }		:text	:note
 
-- 
2.39.5

