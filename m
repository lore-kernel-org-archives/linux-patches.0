Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E35F23A8;
	Mon,  9 May 2022 20:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54442C385BC;
	Mon,  9 May 2022 20:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1652129218;
	bh=8b9BPSUDAbX/vgt6SHngGTCLvHF7koypNrvZpxSa5Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XES4qUCAyhyBfNoKKttczOaGkMn9KiNfx7WItnK6Spbf90sutbnriX4PGoGcZBRx7
	 qsycQkwhrnmzL7mcWeK6x5gmAIFRqp3AvdAxkirZw1uY1imLNVAjuQOQMhJJtNHqbi
	 PzSl8jyD1QKQQRckCtHzJ1RK9EZ4+puJgxQ+YpXtWeu71t8qu8sPbhegJlJvzc9dXt
	 sIKKsmI7NA8eFQ10/f8fC7iq2TvAwWa9qHpwo8776u5B5BUsTN7B7/QrbSY9F+Z0Bl
	 hIgRlv3kHkMhzCBjFOiy77UsOcqJpSiZlkmxfeHLxhRDcElQOXDAaeuPW66aJJNEO+
	 BC4x4giXWd8vA==
From: Nathan Chancellor <nathan@kernel.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 1/2] powerpc/vdso: Remove unused ENTRY in linker scripts
Date: Mon,  9 May 2022 13:46:34 -0700
Message-Id: <20220509204635.2539549-2-nathan@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220509204635.2539549-1-nathan@kernel.org>
References: <20220509204635.2539549-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When linking vdso{32,64}.so.dbg with ld.lld, there is a warning about
not finding _start for the starting address:

  ld.lld: warning: cannot find entry symbol _start; not setting start address
  ld.lld: warning: cannot find entry symbol _start; not setting start address

Looking at GCC + GNU ld, the entry point address is 0x0:

  $ llvm-readelf -h vdso{32,64}.so.dbg &| rg "(File|Entry point address):"
  File: vdso32.so.dbg
    Entry point address:               0x0
  File: vdso64.so.dbg
    Entry point address:               0x0

This matches what ld.lld emits:

  $ powerpc64le-linux-gnu-readelf -p .comment vdso{32,64}.so.dbg

  File: vdso32.so.dbg

  String dump of section '.comment':
    [     0]  Linker: LLD 14.0.0
    [    14]  clang version 14.0.0 (Fedora 14.0.0-1.fc37)

  File: vdso64.so.dbg

  String dump of section '.comment':
    [     0]  Linker: LLD 14.0.0
    [    14]  clang version 14.0.0 (Fedora 14.0.0-1.fc37)

  $ llvm-readelf -h vdso{32,64}.so.dbg &| rg "(File|Entry point address):"
  File: vdso32.so.dbg
    Entry point address:               0x0
  File: vdso64.so.dbg
    Entry point address:               0x0

Remove ENTRY to remove the warning, as it is unnecessary for the vDSO to
function correctly.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/kernel/vdso/vdso32.lds.S | 1 -
 arch/powerpc/kernel/vdso/vdso64.lds.S | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/powerpc/kernel/vdso/vdso32.lds.S b/arch/powerpc/kernel/vdso/vdso32.lds.S
index 58e0099f70f4..e0d19d74455f 100644
--- a/arch/powerpc/kernel/vdso/vdso32.lds.S
+++ b/arch/powerpc/kernel/vdso/vdso32.lds.S
@@ -13,7 +13,6 @@ OUTPUT_FORMAT("elf32-powerpcle", "elf32-powerpcle", "elf32-powerpcle")
 OUTPUT_FORMAT("elf32-powerpc", "elf32-powerpc", "elf32-powerpc")
 #endif
 OUTPUT_ARCH(powerpc:common)
-ENTRY(_start)
 
 SECTIONS
 {
diff --git a/arch/powerpc/kernel/vdso/vdso64.lds.S b/arch/powerpc/kernel/vdso/vdso64.lds.S
index 0288cad428b0..1a4a7bc4c815 100644
--- a/arch/powerpc/kernel/vdso/vdso64.lds.S
+++ b/arch/powerpc/kernel/vdso/vdso64.lds.S
@@ -13,7 +13,6 @@ OUTPUT_FORMAT("elf64-powerpcle", "elf64-powerpcle", "elf64-powerpcle")
 OUTPUT_FORMAT("elf64-powerpc", "elf64-powerpc", "elf64-powerpc")
 #endif
 OUTPUT_ARCH(powerpc:common64)
-ENTRY(_start)
 
 SECTIONS
 {
-- 
2.36.1

