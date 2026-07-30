Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE8740E8FC;
	Thu, 30 Jul 2026 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424685; cv=none; b=U64uwG72YLd6Nnk+BYx3EhIzjx+3chKjRsnZku+XWaOHPO8YQbTZUnb5SFN4vHmbmjrRRjId0RGD4lL5g9Hq5oie+aWW07VBxcT0Q7maFAKN/PrDEbclXwFCX5elahKHTH2TssAv4IUFRCC3Ni169osvEHz74NXmcqyeksMStXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424685; c=relaxed/simple;
	bh=CjA8rzZk3uApC4v2S6ohurK9pJRkb7WCOZUpbNtIzLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMMaHOlCSqkBm3DrMZeY1Ou3Zz67dDftOrMzTGfy0TVXv1zX9jH+C2p3OZdpJDJgI0GonIJp6H8P0RlgcF5T0+V0a1MDcl6KzcIDS3Q7Yt77VGeO0aJgmhOc5IOuXBRe9pIF+4/VfSiBFunXM7jExS2U1yljy20hnq4rvPLNP0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsIiRz9j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsIiRz9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1A31F000E9;
	Thu, 30 Jul 2026 15:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424683;
	bh=U2P2i95jFtZA3E4/VUD+KVnqY+k7wR65hj36Hb84aFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsIiRz9jy4sUGajD5opYiCvGcTnroGB0cv9idldcjkDog7DtU7uteonvgu6Zy4k9h
	 pX323uTcpDtyfAxLZbzPbqAjWaV92Iz8a6TFgNWB6aOFE5LdsolpmS3cmYLFuOd28x
	 FeKLp6cEr6U1v3bcJWYxLh4cJf2g/4hootdB9Ah0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.18 480/675] x86/boot/compressed: Disable jump tables
Date: Thu, 30 Jul 2026 16:13:30 +0200
Message-ID: <20260730141455.327722791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 4a9ec5ec9555ad62dc5b81a37ac946025c2ea002 upstream.

After a recent upstream LLVM change to start generating jump and lookup
tables in switch statements in more instances [1], linking the
compressed x86 boot image when CONFIG_KERNEL_ZSTD is enabled fails with:

  ld.lld: error: Unexpected run-time relocations (.rela) detected!

Dumping the relocations in misc.o, which is the only file influenced by
CONFIG_KERNEL_ZSTD in the decompressor, shows dynamic relocations to
some string constants, which correspond to the string literals in the
switch statement in handle_zstd_error():

  Relocation section '.rela.data.rel.ro' at offset 0x277b0 contains 31 entries:
      Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
  0000000000000000  0000006600000001 R_X86_64_64            0000000000000000 .rodata.str1.1 + 73a
  0000000000000008  0000006600000001 R_X86_64_64            0000000000000000 .rodata.str1.1 + 78e
  0000000000000010  0000006600000001 R_X86_64_64            0000000000000000 .rodata.str1.1 + 78e
  0000000000000018  0000006600000001 R_X86_64_64            0000000000000000 .rodata.str1.1 + 78e
  ...

This optimization is problematic for the decompressor environment, as it
is built as -fPIE without any explicit absolute references (as described
at the top of misc.c) while not applying any dynamic relocations, hence
the linker assertion. To opt out of this optimization, which is of
little value in this special early boot code, and to mirror the other
x86 startup code in arch/x86/boot/startup, disable jump tables in the
decompressor.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/commit/fa02a6ed66b1700c996b49c96c6bc0eb014c9518 [1]
Link: https://patch.msgid.link/20260722-x86-boot-compressed-disable-jt-clang-v2-1-7373d38482fb@kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2165
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -27,6 +27,7 @@ targets := vmlinux vmlinux.bin vmlinux.b
 KBUILD_CFLAGS := -m$(BITS) -O2 $(CLANG_FLAGS)
 KBUILD_CFLAGS += -std=gnu11
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIE
+KBUILD_CFLAGS += -fno-jump-tables
 KBUILD_CFLAGS += -Wundef
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 cflags-$(CONFIG_X86_32) := -march=i386


