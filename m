Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62F723A8;
	Mon,  9 May 2022 20:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5777C385BA;
	Mon,  9 May 2022 20:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1652129219;
	bh=LPoqNytL/dcXDmLHjdnmp6kf5QofpJwXrg3EPyjgqos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T40M0ShhTHT+jgDXHoKyf9PluyRWQACDA8mmu5u3L7mXyahxPpQcgh+5fJOGubg7R
	 e0qoGsdw9sWIKHfyJ++BPzzJXqMhb9xKZONQyzcXjLFIE4pqINaLp2aOPvSCuVD4H1
	 3wtUwcQWrjOWFMIhk2lNd/nkg68EHozJHfZj990tLnHbbP9POMfolsaOyYdbIaaafh
	 Tr+gN1APyHp4KdLBCZ40fk0KCGsG4kaPiL0fSldtXekPOpH73KZFBitiN/7vMZTf5M
	 wyE22IhjHf22BOXTMWzqz/3Ejv8WcJP1XyncWJfDYaDwwBZyx4W9Jo3eHt6SDtBnYJ
	 Pj6UdKYdeqm7A==
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
Subject: [PATCH 2/2] powerpc/vdso: Link with ld.lld when requested
Date: Mon,  9 May 2022 13:46:35 -0700
Message-Id: <20220509204635.2539549-3-nathan@kernel.org>
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

The PowerPC vDSO is linked with $(CC) instead of $(LD), which means the
default linker of the compiler is used instead of the linker requested
by the builder.

  $ make ARCH=powerpc LLVM=1 mrproper defconfig arch/powerpc/kernel/vdso/
  ...

  $ llvm-readelf -p .comment arch/powerpc/kernel/vdso/vdso{32,64}.so.dbg

  File: arch/powerpc/kernel/vdso/vdso32.so.dbg
  String dump of section '.comment':
  [     0] clang version 14.0.0 (Fedora 14.0.0-1.fc37)

  File: arch/powerpc/kernel/vdso/vdso64.so.dbg
  String dump of section '.comment':
  [     0] clang version 14.0.0 (Fedora 14.0.0-1.fc37)

The compiler option '-fuse-ld' tells the compiler which linker to use
when it is invoked as both the compiler and linker. Use '-fuse-ld=lld'
when LD=ld.lld has been specified (CONFIG_LD_IS_LLD) so that the vDSO is
linked with the same linker as the rest of the kernel.

  $ llvm-readelf -p .comment arch/powerpc/kernel/vdso/vdso{32,64}.so.dbg

  File: arch/powerpc/kernel/vdso/vdso32.so.dbg
  String dump of section '.comment':
  [     0] Linker: LLD 14.0.0
  [    14] clang version 14.0.0 (Fedora 14.0.0-1.fc37)

  File: arch/powerpc/kernel/vdso/vdso64.so.dbg
  String dump of section '.comment':
  [     0] Linker: LLD 14.0.0
  [    14] clang version 14.0.0 (Fedora 14.0.0-1.fc37)

LD can be a full path to ld.lld, which will not be handled properly by
'-fuse-ld=lld' if the full path to ld.lld is outside of the compiler's
search path. '-fuse-ld' can take a path to the linker but it is
deprecated in clang 12.0.0; '--ld-path' is preferred for this scenario.

Use '--ld-path' if it is supported, as it will handle a full path or
just 'ld.lld' properly. See the LLVM commit below for the full details
of '--ld-path'.

Link: https://github.com/ClangBuiltLinux/linux/issues/774
Link: https://github.com/llvm/llvm-project/commit/1bc5c84710a8c73ef21295e63c19d10a8c71f2f5
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/kernel/vdso/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index 954974287ee7..096b0bf1335f 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -48,6 +48,7 @@ UBSAN_SANITIZE := n
 KASAN_SANITIZE := n
 
 ccflags-y := -shared -fno-common -fno-builtin -nostdlib -Wl,--hash-style=both
+ccflags-$(CONFIG_LD_IS_LLD) += $(call cc-option,--ld-path=$(LD),-fuse-ld=lld)
 
 CC32FLAGS := -Wl,-soname=linux-vdso32.so.1 -m32
 AS32FLAGS := -D__VDSO32__ -s
-- 
2.36.1

