Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCF22F58;
	Wed, 11 May 2022 18:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9460C34100;
	Wed, 11 May 2022 18:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1652295021;
	bh=uWfZdAk0PxnLwPOVrQC6qfy5AARkFg7cXs9CQ8AeM34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3PwFceqTQ44qGMGOap/dWKbgcX9jy1AOjkJKFLhpDq7W2TKxtALPu0kZq3cRBwAj
	 5D2MIyngAkgsrxpW3KfgeC6fYrX73fBPnuNyV9PYsMSuu6AnMQPT+IIINbzSgTC9O0
	 lcWRSLBOaj9ws0/TKIYFKqnnCSTcatJqcO5shqIYPjCsmbSojG0DtpNrun1nHxb8Nd
	 zOvjKkftg2KNS43RXehoD6R4xTTxoi0gOwstKCjf6XtH76dMISO7hMBezQmowuH78D
	 64ZUvDtMmuFaQEJbGNDbLoDjK7cGgZBGXgrNTxDvVuywFJpGy19mQPqp9Tw4X6Ey68
	 Fj+iXS9ykjvzA==
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
Subject: [PATCH v2 2/2] powerpc/vdso: Link with ld.lld when requested
Date: Wed, 11 May 2022 11:50:01 -0700
Message-Id: <20220511185001.3269404-3-nathan@kernel.org>
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

The PowerPC vDSO uses $(CC) to link, which differs from the rest of the
kernel, which uses $(LD) directly. As a result, the default linker of
the compiler is used, which may differ from the linker requested by the
builder. For example:

  $ make ARCH=powerpc LLVM=1 mrproper defconfig arch/powerpc/kernel/vdso/
  ...

  $ llvm-readelf -p .comment arch/powerpc/kernel/vdso/vdso{32,64}.so.dbg

  File: arch/powerpc/kernel/vdso/vdso32.so.dbg
  String dump of section '.comment':
  [     0] clang version 14.0.0 (Fedora 14.0.0-1.fc37)

  File: arch/powerpc/kernel/vdso/vdso64.so.dbg
  String dump of section '.comment':
  [     0] clang version 14.0.0 (Fedora 14.0.0-1.fc37)

LLVM=1 sets LD=ld.lld but ld.lld is not used to link the vDSO; GNU ld is
because "ld" is the default linker for clang on most Linux platforms.

This is a problem for Clang's Link Time Optimization as implemented in
the kernel because use of GNU ld with LTO requires the LLVMgold plugin,
which is not technically supported for ld.bfd per
https://llvm.org/docs/GoldPlugin.html. Furthermore, if LLVMgold.so is
missing from a user's system, the build will fail, even though LTO as it
is implemented in the kernel requires ld.lld to avoid this dependency in
the first place.

Ultimately, the PowerPC vDSO should be converted to compiling and
linking with $(CC) and $(LD) respectively but there were issues last
time this was tried, potentially due to older but supported tool
versions. To avoid regressing GCC + binutils, use the compiler option
'-fuse-ld', which tells the compiler which linker to use when it is
invoked as both the compiler and linker. Use '-fuse-ld=lld' when
LD=ld.lld has been specified (CONFIG_LD_IS_LLD) so that the vDSO is
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
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
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

