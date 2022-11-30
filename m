Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624C579C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB33BC433D7;
	Wed, 30 Nov 2022 18:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833356;
	bh=G02EEvcYH5gnTW8yQ8yQBaC17QixYgFD0fZ0pWxC4Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ljl8iYDB9Q0NYHsgSEFcrBJe8zLPwLKoVeX06T/Gd33c7Xx2DGOX5nHQ0dbK5n3GP
	 GrRoYSiTs482MD2QQfRmjWhn03S1+Ng5WsKi2efJHG/respS63ZhVf3Q91QkeWtnSP
	 GAsgQypinzKEh9w8tWxcVOL1tqhXm44NoBw00E98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/206] arm64/syscall: Include asm/ptrace.h in syscall_wrapper header.
Date: Wed, 30 Nov 2022 19:21:41 +0100
Message-Id: <20221130180534.246729684@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit acfc35cfcee5df419391671ef1a631f43feee4e3 ]

Add the same change for ARM64 as done in the commit 9440c4294160
("x86/syscall: Include asm/ptrace.h in syscall_wrapper header") to
make sure all syscalls see 'struct pt_regs' definition and resulted
BTF for '__arm64_sys_*(struct pt_regs *regs)' functions point to
actual struct.

Without this patch, the BPF verifier refuses to load a tracing prog
which accesses pt_regs.

  bpf(BPF_PROG_LOAD, {prog_type=0x1a, ...}, 128) = -1 EACCES

With this patch, we can see the correct error, which saves us time
in debugging the prog.

  bpf(BPF_PROG_LOAD, {prog_type=0x1a, ...}, 128) = 4
  bpf(BPF_RAW_TRACEPOINT_OPEN, {raw_tracepoint={name=NULL, prog_fd=4}}, 128) = -1 ENOTSUPP

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20221031215728.50389-1-kuniyu@amazon.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/syscall_wrapper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/syscall_wrapper.h b/arch/arm64/include/asm/syscall_wrapper.h
index b383b4802a7b..d30217c21eff 100644
--- a/arch/arm64/include/asm/syscall_wrapper.h
+++ b/arch/arm64/include/asm/syscall_wrapper.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_SYSCALL_WRAPPER_H
 #define __ASM_SYSCALL_WRAPPER_H
 
-struct pt_regs;
+#include <asm/ptrace.h>
 
 #define SC_ARM64_REGS_TO_ARGS(x, ...)				\
 	__MAP(x,__SC_ARGS					\
-- 
2.35.1



