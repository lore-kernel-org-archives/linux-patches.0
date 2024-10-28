Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581BF18E04F;
	Mon, 28 Oct 2024 06:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096918; cv=none; b=k7yXDtCBnZofT/0YgUllZqlF2lDtB3ta/F1l4KhMNKbmY0kuQ0FS5N1m3OGudNMQ7aM6AzrZ7avcrCXNTSubz6ymXMnuSUTbaUw2MBozafD5SVRg9yYI2ejrwCw2e3944x4Adsuqoy8wgGmKS9gfyfdb2tScbZWSIPBK7h92Igs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096918; c=relaxed/simple;
	bh=pXChInKFqMsnvunToDVllVVcDoQkSAw9G/QlM+hU3b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwshK/kC1gu8ZquMxERBJL2nvkwDwOUYMGrt4F2ncbpvuwOHgLk+CrSmLX9OJ1IWcu6empGZNdfajx5t9WCJ0gbf5NZ993aJ040fTWmcm9pfmoNt3qgJr+wV4ZB4ZRSYLsa63EDD2I1bYBoRZ/fYrQHZXZsE+cy0vJfCeHMm1Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcUSoVOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcUSoVOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99EFC4CEC3;
	Mon, 28 Oct 2024 06:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096918;
	bh=pXChInKFqMsnvunToDVllVVcDoQkSAw9G/QlM+hU3b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcUSoVOd72AhBrhpaCbjraC7NGsOKyuLkTb/Ipcy7VFNi6mJeJTiLCZqrqEMI8kX7
	 UtbHPNVVVHLcC35daqfkyiN2yvWa5hbyzsbWsc9phArm/radAfiZt+LxYka6QSVZic
	 m43T33nwBbmOJWVC8tVeG4cRcC/3u7N8ko90PJfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 44/80] arm64: Force position-independent veneers
Date: Mon, 28 Oct 2024 07:25:24 +0100
Message-ID: <20241028062253.845471398@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 9abe390e689f4f5c23c5f507754f8678431b4f72 ]

Certain portions of code always need to be position-independent
regardless of CONFIG_RELOCATABLE, including code which is executed in an
idmap or which is executed before relocations are applied. In some
kernel configurations the LLD linker generates position-dependent
veneers for such code, and when executed these result in early boot-time
failures.

Marc Zyngier encountered a boot failure resulting from this when
building a (particularly cursed) configuration with LLVM, as he reported
to the list:

  https://lore.kernel.org/linux-arm-kernel/86wmjwvatn.wl-maz@kernel.org/

In Marc's kernel configuration, the .head.text and .rodata.text sections
end up more than 128MiB apart, requiring a veneer to branch between the
two:

| [mark@lakrids:~/src/linux]% usekorg 14.1.0 aarch64-linux-objdump -t vmlinux | grep -w _text
| ffff800080000000 g       .head.text     0000000000000000 _text
| [mark@lakrids:~/src/linux]% usekorg 14.1.0 aarch64-linux-objdump -t vmlinux | grep -w primary_entry
| ffff8000889df0e0 g       .rodata.text   000000000000006c primary_entry,

... consequently, LLD inserts a position-dependent veneer for the branch
from _stext (in .head.text) to primary_entry (in .rodata.text):

| ffff800080000000 <_text>:
| ffff800080000000:       fa405a4d        ccmp    x18, #0x0, #0xd, pl     // pl = nfrst
| ffff800080000004:       14003fff        b       ffff800080010000 <__AArch64AbsLongThunk_primary_entry>
...
| ffff800080010000 <__AArch64AbsLongThunk_primary_entry>:
| ffff800080010000:       58000050        ldr     x16, ffff800080010008 <__AArch64AbsLongThunk_primary_entry+0x8>
| ffff800080010004:       d61f0200        br      x16
| ffff800080010008:       889df0e0        .word   0x889df0e0
| ffff80008001000c:       ffff8000        .word   0xffff8000

... and as this is executed early in boot before the kernel is mapped in
TTBR1 this results in a silent boot failure.

Fix this by passing '--pic-veneer' to the linker, which will cause the
linker to use position-independent veneers, e.g.

| ffff800080000000 <_text>:
| ffff800080000000:       fa405a4d        ccmp    x18, #0x0, #0xd, pl     // pl = nfrst
| ffff800080000004:       14003fff        b       ffff800080010000 <__AArch64ADRPThunk_primary_entry>
...
| ffff800080010000 <__AArch64ADRPThunk_primary_entry>:
| ffff800080010000:       f004e3f0        adrp    x16, ffff800089c8f000 <__idmap_text_start>
| ffff800080010004:       91038210        add     x16, x16, #0xe0
| ffff800080010008:       d61f0200        br      x16

I've opted to pass '--pic-veneer' unconditionally, as:

* In addition to solving the boot failure, these sequences are generally
  nicer as they require fewer instructions and don't need to perform
  data accesses.

* While the position-independent veneer sequences have a limited +/-2GiB
  range, this is not a new restriction. Even kernels built with
  CONFIG_RELOCATABLE=n are limited to 2GiB in size as we have several
  structues using 32-bit relative offsets and PPREL32 relocations, which
  are similarly limited to +/-2GiB in range. These include extable
  entries, jump table entries, and alt_instr entries.

* GNU LD defaults to using position-independent veneers, and supports
  the same '--pic-veneer' option, so this change is not expected to
  adversely affect GNU LD.

I've tested with GNU LD 2.30 to 2.42 inclusive and LLVM 13.0.1 to 19.1.0
inclusive, using the kernel.org binaries from:

* https://mirrors.edge.kernel.org/pub/tools/crosstool/
* https://mirrors.edge.kernel.org/pub/tools/llvm/

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reported-by: Marc Zyngier <maz@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Will Deacon <will@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20240927101838.3061054-1-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index c744b1e7b3569..29eed96fe0e72 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -10,7 +10,7 @@
 #
 # Copyright (C) 1995-2001 by Russell King
 
-LDFLAGS_vmlinux	:=--no-undefined -X
+LDFLAGS_vmlinux	:=--no-undefined -X --pic-veneer
 
 ifeq ($(CONFIG_RELOCATABLE), y)
 # Pass --no-apply-dynamic-relocs to restore pre-binutils-2.27 behaviour
-- 
2.43.0



