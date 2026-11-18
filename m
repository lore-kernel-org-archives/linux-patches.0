Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019884;
	b=RWApzUfQ40dcB5pe7mcrkEcA0Mk7hgQLjFS5Ew7JsrPbJ8IXgH7dJFKAlgX3Poi4Cv/4
	 8qiV/PyI2UqnIpCWF8NBqgBIrKtTv/jRxaiTDweofKP3QRV/RSS4oBJIZYjjoNB9L3IHB
	 Dw4wyT2+M/iraf42Dyn8Ny7tjPdroqxLOQub95zUqGVHqskwLdle5pSQ79t9J0Kt6GloX
	 Z7ww3t4LNOhzvLDm6YL5zbtcd38XhjX91kGmw7ySWqI3xUuA2/C7ibkGO/oo+0TUl9uyq
	 AHylk/CMQviTKWix6rHMCGAg8ETCHBAVhMzBl0tM3aDDkKLx7u1JuYHwvTIJ+kjgVhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UY58Uwy76qFW2DwEibHXcbfPuTCbq89hDiUtqMjoVrg=;
	b=mIkPCxTiHWYKGsJzb/emLD2d0o9921TmYgHVp49ep90gshLzvsiXOE+98CBu125ESrLn
	 roohATPXoETqs+GJzSTlSvnRw2YAF9ID8fZ4vCqPW9qdFNUvXtswqyCn8TWb9bdbLWCdo
	 pavSF58ISHHZS8H1kWHw5R5yvCAxu4z9r20yv07QMR439jx6uMBX3nkjh+bTuA3R6hAw5
	 q3QdO6Km7xBw4qrj/L3luLGUC5Bf7ZIU8QlC3GpFLJ5OayAcxAaH7vnGXCaK4tTx7reg9
	 1K7NEGZ9KNIENAN75BZHbGZiSiN6OiD09Eb8NlWQ99b38bHugFxZ+OITB0GQZIPOGQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVvgbL9u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10646606A31C;
	Wed, 18 Nov 2026 16:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVvgbL9u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667251F000C4;
	Wed, 18 Nov 2026 16:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019883;
	bh=UY58Uwy76qFW2DwEibHXcbfPuTCbq89hDiUtqMjoVrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVvgbL9u2k+me5LzlROXv2iN3fYNMzyKcVOGOuQiEjJA4ny0WteVOFTl5t9YQw6hl
	 K5E/qRzKgft/H/RcBnhZdfE9Y8MlEN9V9403yiXCZ2SplCE1M1tmZ2clo66SQ5Go0q
	 D5xYrystJLYhzE5VJytgzY9vjrpXHtdhBW+x50vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1755/2651] s390/ptrace: Preserve ILC when updating system call number
Date: Wed, 18 Nov 2026 15:49:55 +0100
Message-ID: <20261118150350.664597763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 125ca4c4e30c2..d8d5e843859c8 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -34,6 +34,7 @@
 #include <asm/ptrace.h>
 #include <asm/rwonce.h>
 #include <asm/fpu.h>
+#include <asm/syscall.h>
 
 #include "entry.h"
 
@@ -345,11 +346,9 @@ static int __poke_user(struct task_struct *child, addr_t addr, addr_t data)
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



