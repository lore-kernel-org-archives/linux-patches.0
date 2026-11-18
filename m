Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031682;
	b=A4MNX1UkUGPpg7ffpdXr6C82MkMNHqe1lGril1fgLg05PmYhQgAv1aPaLj7NOLBQKMXM
	 C64vhgpp3KdaSZSeDVX4bqsZevqVabL2LXleQuKjnGD7A8xdi8PoS2YsRUCfMGCSHhkMl
	 hZ+wsbkvn1fH3GehKmP7xvfNl//tLZdKjy23vNGgZAL87pgEG5W98gAje33BdCeTUewlT
	 bVUU48RYDGhFW8hLOnaJsIK+nMLivv+8+XaBWwJETqAmSf9sdB4GV8j8dB+zBRpeqonXl
	 +SJnG6uHQPvkixMCb4pedKok4mZ2xhBu7kKJjrROal9hoPyLOegJSf/qSApVH9b5mwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JsjcNUTLNvrZ/eLnzNzMvAsyB3TgohIzaFFlO60z/h8=;
	b=5dG4gXgn3YY8jVKf95so8rYD+wt6dsjaCF3ytYKxIKqg1zdPXTWXzV09/qefyCNFktdv
	 hi7HKA9iK3JExNmXgWVEhp37rJ3hz5jEw6Neehn0lFpIWNnPbpZLBP4K9m4gsmyEY73s8
	 h8xDcpkMTx+eaA2+/0Vq3n9HM9VD2W12Ipiw61kDHceKCmYTuEmoF4UPe3NXp49KlOjIj
	 6WcrHm5Fo1r3N6V8XRlVc0+up7pMoJ+zXyG7WH5GlEXlD5cpEB2oOYnrIEEVYgAPleqSd
	 acnIaaTm7uwR/10/DY7qeTQgIGRIBWtk0i2G0Ycch4FV+/rKVdVD56PQQPf4PJ9PWyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nxKrmPUv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ACD606A31C;
	Wed, 18 Nov 2026 19:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nxKrmPUv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FF21F000C4;
	Wed, 18 Nov 2026 19:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031682;
	bh=JsjcNUTLNvrZ/eLnzNzMvAsyB3TgohIzaFFlO60z/h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxKrmPUvk/SZ40kOdssZPAB+wMuWm6zHHek4R0eSAKA5jEUM9FMoWUF/Llj/SwgrS
	 Xk3/96mWNasBTdstDSVm1h0z13HiyZ64KjqUnF8Jr1Wzqzs8R5h9oStRwPCacnAjdu
	 ietwZltZ90GyR+bmxagkpkNLq7wPK9hl6S3oArD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1142/1756] s390/ptrace: Preserve ILC when updating system call number
Date: Wed, 18 Nov 2026 15:54:29 +0100
Message-ID: <20261118150055.506612972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 946b9dcff33bd4669464674ae1c00683b875be55 ]

When an attached debugger changes gpr2 via PTRACE_POKEUSR while the
traced process has PIF_SYSCALL set, the int_code in pt_regs is also
updated. In case of an svc it contains the instruction length code
(ILC), as well as the system call number.

The ptrace code sets the ILC unconditionally to a value which matches the
svc instruction. However the svc instruction also may have been executed
via the execute or execute relative long instruction, which have a
different length. Therefore preserve the ILC and only change the system
call number using syscall_set_nr().

This makes sure that in case of a PSW rewind the instruction address
points to the correct instruction.

Fixes: 56e62a737028 ("s390: convert to generic entry")
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ptrace.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 1cfed8b710b8c..caf8d3cc18792 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -32,6 +32,7 @@
 #include <asm/runtime_instr.h>
 #include <asm/facility.h>
 #include <asm/fpu.h>
+#include <asm/syscall.h>
 
 #include "entry.h"
 
@@ -347,11 +348,9 @@ static int __poke_user(struct task_struct *child, addr_t addr, addr_t data)
 				return -EINVAL;
 		}
 
-		if (test_pt_regs_flag(regs, PIF_SYSCALL) &&
-			addr == offsetof(struct user, regs.gprs[2])) {
-			struct pt_regs *regs = task_pt_regs(child);
-
-			regs->int_code = 0x20000 | (data & 0xffff);
+		if (addr == offsetof(struct user, regs.gprs[2])) {
+			if (test_pt_regs_flag(regs, PIF_SYSCALL))
+				syscall_set_nr(child, regs, data);
 		}
 		*(addr_t *)((addr_t) &regs->psw + addr) = data;
 	} else if (addr < offsetof(struct user, regs.orig_gpr2)) {
-- 
2.53.0



