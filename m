Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026443;
	b=hlNZHdKEcozRIjXAEMwWoX7k4FAk8hZ7TYMh2y4WL/6FkYPcEC1KMcTFV9cetxai2E4J
	 KDT1PappfwWFJ4wc6qFVRB5kf08CraGPSx6vcH8/jvSCBMl0ceOHycpoFCFcSnYk9tr5S
	 IgixmeKz4UP656Oj/TiHjmpDBaqHu8R5vJrAdEseMnJLqN9LFSb2WL/CAsb6Nuvdj/V/w
	 aerOh2OmhcBr4JPIMyrg11ZVDCoNxRGnV5HTaQxgS4jodw5NnqbHkaxXeftmmyt2dzY/s
	 g+ao937cqE+taE2bMv0Y32z1YVek8o+yxPgVyE26YiYs8t/TVc1zA9yNZrn7oAkXU3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yQnC/QjUz9xR8sVdGMq//34h3RhhsuXOhVUACUjtI+w=;
	b=RhhB/+p+nhxYRY6Ms955bCOtIK2STGoAMyzY6fUAd/pb7buPavoOGp2WT0VlfWfdDfST
	 Sj+Iv+UfoX9hYu7LAfd8SDX3KdF4yo+goNbTTz35NkqcnLQqVHrFDg5ACKAEtvZqwFNUk
	 d0Gvst2KRXUW3fttxoC3x047fcJQD+UBKm8lx2yquFtmc+TjexcHuZNrOy+9wKyiW5Ken
	 ARF/OC9v8wLS8Ivx/p2PP3Ge35XXczIRLPItaackViyWu+w+hSpxIqEH5ACCu4MtLph8z
	 cVSiYV31nM+z2be94jIEApamLdtouiW5aKQC+QgMAm9yZJhXnLoSncK4h6rF5epXdHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MOq8aM4j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BA5606A32A;
	Wed, 18 Nov 2026 18:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MOq8aM4j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC5F1F000C4;
	Wed, 18 Nov 2026 18:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026443;
	bh=yQnC/QjUz9xR8sVdGMq//34h3RhhsuXOhVUACUjtI+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOq8aM4jqL1PbvQx5mknfLKLQQN1kjls85sPKLHpnSRGOfB62bPTMeNac+fiMrURK
	 0ZRhI4GbLQ89MP2iinOKR6z9r9Q/qIwyZAlp7ke7xhghyEOU3b0UMYJBfqHk0sFmsf
	 +Xwjt6UvXV6jgeGepktYHTWlK2w1yc3GLXzUZnk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1438/2151] s390/ptrace: Preserve ILC when updating system call number
Date: Wed, 18 Nov 2026 15:52:53 +0100
Message-ID: <20261118150214.318767986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 494216c4b4f3d..42fd1a42058a7 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -35,6 +35,7 @@
 #include <asm/ptrace.h>
 #include <asm/rwonce.h>
 #include <asm/fpu.h>
+#include <asm/syscall.h>
 
 #include "entry.h"
 
@@ -350,11 +351,9 @@ static int __poke_user(struct task_struct *child, addr_t addr, addr_t data)
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



