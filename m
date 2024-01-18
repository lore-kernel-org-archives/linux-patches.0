Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F9622323;
	Thu, 18 Jan 2024 10:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575335; cv=none; b=CVt3aZQuj1qfVF9PrbMJN49uo6pH6+0IA3UB8gUc4Gvmr1xYhge4gngbdMzmyneR0Nvkj3EGICeWobiAabnxdJK34kSvPPzk9mM1TpXLJt8hVreo4h0S8WYW4tYzvw9nR0YsopOnwTYMx/u0VxFHG52JjGKnpGRcY2iuiP841J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575335; c=relaxed/simple;
	bh=u/Z6fmQMtCcPPltj3cGL0WSBPIUDSpHf3J5MkDgiT1s=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=UUqM5WSrJ/U1JVPn2jYTDZ6noH16AcyqKThYufZ73QWMQvaylcW8rxXSmRQaSz+YPu6ge6rCRV7VqnwrQUgy50omgCQJ5N70Nbidx+twza3zRTJgfnwbwmzxOi4LpsoNUQJ3a4kqHrEtoSXpwVAHIKVbCVCs9LBvZE05bbzMTfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmXTKgrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmXTKgrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCF8C43390;
	Thu, 18 Jan 2024 10:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575335;
	bh=u/Z6fmQMtCcPPltj3cGL0WSBPIUDSpHf3J5MkDgiT1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmXTKgrh28acqCCR8H3bWj4zP06R2JbzuKVZXqz2GfZBZhrZwwuLJ/cQ4xGMhCBWQ
	 4gCU8bBoQIzTpf6uSt4kisQ4jrs54FZ6MWK9TAiCKWIgwpgkbzytfAVA7maDFZ47JP
	 Vt1MOfR8B5PmPNlsEPuQVw4tFCEXJ0oduhZYES8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Rui <wangrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/150] LoongArch: Apply dynamic relocations for LLD
Date: Thu, 18 Jan 2024 11:48:08 +0100
Message-ID: <20240118104323.024232838@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WANG Rui <wangrui@loongson.cn>

[ Upstream commit eea673e9d5ea994c60b550ffb684413d3759b3f4 ]

For the following assembly code:

     .text
     .global func
 func:
     nop

     .data
 var:
     .dword func

When linked with `-pie`, GNU LD populates the `var` variable with the
pre-relocated value of `func`. However, LLVM LLD does not exhibit the
same behavior. This issue also arises with the `kernel_entry` in arch/
loongarch/kernel/head.S:

 _head:
     .word   MZ_MAGIC                /* "MZ", MS-DOS header */
     .org    0x8
     .dword  kernel_entry            /* Kernel entry point */

The correct kernel entry from the MS-DOS header is crucial for jumping
to vmlinux from zboot. This necessity is why the compressed relocatable
kernel compiled by Clang encounters difficulties in booting.

To address this problem, it is proposed to apply dynamic relocations to
place with `--apply-dynamic-relocs`.

Link: https://github.com/ClangBuiltLinux/linux/issues/1962
Signed-off-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index 96747bfec1a1..d423fba7c406 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -80,7 +80,7 @@ endif
 
 ifeq ($(CONFIG_RELOCATABLE),y)
 KBUILD_CFLAGS_KERNEL		+= -fPIE
-LDFLAGS_vmlinux			+= -static -pie --no-dynamic-linker -z notext
+LDFLAGS_vmlinux			+= -static -pie --no-dynamic-linker -z notext $(call ld-option, --apply-dynamic-relocs)
 endif
 
 cflags-y += $(call cc-option, -mno-check-zero-division)
-- 
2.43.0



