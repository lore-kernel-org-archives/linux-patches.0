Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFF32F33;
	Wed, 11 May 2022 18:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F918C34116;
	Wed, 11 May 2022 18:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1652295020;
	bh=KFtyK20wD7qo3wx7y06tzmCYkVP3dZQUR8hshfm6OQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrXbXPNa7Vz8OrBEmX/RvrQpymYcwQmcnu4Pr03TYdhA2Yg1mcMLWfvSIUK0jQKRO
	 +XIogWi14iyKeRdr/bUtRUXNulSyAmkIYNNyfIcAugT+NFuCfLY31+cgobwxaSQsAs
	 Hr3sDp+l6mUJz8fdroa98/2xqTY+b2fTtl8sAu3lRm9NbyOi3TJTnt+4wpKIZm4fa1
	 GeaezhNFs4HuCHMhvRPoy0qxB1VNouKZExwauBz1f8WZGGnWGVYQwYhm3mC9zsKJOT
	 cMqoO6rX5M7gZC2zbBO9eW+0ifhiRd22mhIEkNTuaYKTmI4sW0Y//KuKEx5IiY7/5P
	 gkD1aCAjEP2RQ==
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
Subject: [PATCH v2 1/2] powerpc/vdso: Remove unused ENTRY in linker scripts
Date: Wed, 11 May 2022 11:50:00 -0700
Message-Id: <20220511185001.3269404-2-nathan@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220511185001.3269404-1-nathan@kernel.org>
References: <20220511185001.3269404-1-nathan@kernel.org>
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

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
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

