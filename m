Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA7022D9E3;
	Mon, 30 Jun 2025 21:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317229; cv=none; b=fkRp2esAbxrMFzCBVykYBGzHI9/e1ajTIYQAc0EgSu9aHe1SIrKjTQXBWbo8qYfar45pTMncbseICY77Fh2ORkD9u45ILoIIOuhXze/reu3U99BkNv+WQrtcZ5M2d/R5uAJ+lMVxlouZQtg71ennT/+PFSt9+mvtV0mzwI8XwNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317229; c=relaxed/simple;
	bh=VpkFFoZxR8VVeaY5vlWpftgNiTxHj8o19hcfht9EpB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=czKrGo11QCqtlKeZqFEscFyglHMXdVLgDPz+qJkmkYeQT87Y7jpl2sXiWALEZT9n7VHqCCT2peFve6Ifsdj1qlc55yd+PVnOVFmpsiVfRGUqTgOFyG+OGtrk6GJ4c14aZEbqymMyWuV0A0rNIpaBodWvZ7fvMrCuhW154nGP+r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kaJ8PtpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kaJ8PtpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0009C4CEE3;
	Mon, 30 Jun 2025 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317229;
	bh=VpkFFoZxR8VVeaY5vlWpftgNiTxHj8o19hcfht9EpB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaJ8PtpDNIjAXJQQeZWP7U5cBM2VUyLyNAzDjaLoaK83HrSLD4B7IttLvzzBOlNPR
	 Kc8pgSaSoZKdi+d8WzQfTBfPcxke7La0HDglj+NI+DajL8G5y+ZdYatsHs+s/w6RIP
	 b5n0quAiKOkAsYouW+XhdZAvPYb9+kwnUdLZxQVLn4wmiZEFkWjZ5e+OOApUj1G/Od
	 NjZsfBN4mOn3CpSHPhQfKUnsA5Rq5CJ02j8MWhjLlDW/FRhwZHZsj66Gcimpiw1WKy
	 zNXekiCzFMdkviMK1gB7s1Ax9TxK5AWViBGbP1KjANI+kPD1T+jKGrvzsE3EwdHoTi
	 reiDoW8gjjSGw==
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
	namcao@linutronix.de,
	thomas.weissschuh@linutronix.de,
	linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.12 18/21] riscv: vdso: Exclude .rodata from the PT_DYNAMIC segment
Date: Mon, 30 Jun 2025 16:45:33 -0400
Message-Id: <20250630204536.1358327-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204536.1358327-1-sashal@kernel.org>
References: <20250630204536.1358327-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.35
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
index cbe2a179331d2..99e51f7755393 100644
--- a/arch/riscv/kernel/vdso/vdso.lds.S
+++ b/arch/riscv/kernel/vdso/vdso.lds.S
@@ -31,7 +31,7 @@ SECTIONS
 		*(.data .data.* .gnu.linkonce.d.*)
 		*(.dynbss)
 		*(.bss .bss.* .gnu.linkonce.b.*)
-	}
+	}						:text
 
 	.note		: { *(.note.*) }		:text	:note
 
-- 
2.39.5

