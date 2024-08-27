Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E6F19EEDB;
	Tue, 27 Aug 2024 14:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770523; cv=none; b=MTJTZ68tU/MVgv6GRV5JB28Z0obrlij+0P1OTh1EoT8t2jQt9jeu1tiWHHx7Hy1KBmeYLuilCO7wZhqFQthOFAR7AKPL6afPZY6ZfIaoW9ahxxpUs/5Ia679xBG3EPraOczdMM0+O/VJm2bcjpFjSxxJear34ykHNdh7Zd6Psgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770523; c=relaxed/simple;
	bh=jQTQ7DkM3iX9u2YC0Rj7LgztclmoJLnNLGn6HdYXv68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O/7pokfQV/fAZIdsHEi5N+o0l42Z5qyR4tDvZJE5t7jp57YE1obyjscUX7QtVCnfVgJKxhK+H9tspHcfgkqveQamfBgRm3Jy5/XA7X15E3rBTuZgIRVzrpTiwcqDYZ7XatcYl9lf8frgzNgwl+n1p19lA0aDU60VBOwiFXMqhKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mviBEPgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mviBEPgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAE6C4E691;
	Tue, 27 Aug 2024 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770523;
	bh=jQTQ7DkM3iX9u2YC0Rj7LgztclmoJLnNLGn6HdYXv68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mviBEPghsRw2oQ8j6BDsakBnY38VtVafqSokYbzs/0Kwa3ltLBLD2p+qBM5+NQFlm
	 NdnNJiwsUE+65yCc0wYPYNgQgGjf+5ghYDJl/8857K1gxq/DqQHO4bDpmuSwA/YXXD
	 HEXisGqOq4T3XQkasxR9Z0hQCmk4iu6DyjvhLG2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dmitry V. Levin" <ldv@strace.io>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Celeste Liu <CoelacanthusHex@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 224/341] riscv: entry: always initialize regs->a0 to -ENOSYS
Date: Tue, 27 Aug 2024 16:37:35 +0200
Message-ID: <20240827143851.936180385@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Celeste Liu <coelacanthushex@gmail.com>

[ Upstream commit 61119394631f219e23ce98bcc3eb993a64a8ea64 ]

Otherwise when the tracer changes syscall number to -1, the kernel fails
to initialize a0 with -ENOSYS and subsequently fails to return the error
code of the failed syscall to userspace. For example, it will break
strace syscall tampering.

Fixes: 52449c17bdd1 ("riscv: entry: set a0 = -ENOSYS only when syscall != -1")
Reported-by: "Dmitry V. Levin" <ldv@strace.io>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Cc: stable@vger.kernel.org
Signed-off-by: Celeste Liu <CoelacanthusHex@gmail.com>
Link: https://lore.kernel.org/r/20240627142338.5114-2-CoelacanthusHex@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 67d0073fb624d..2158b7a65d74f 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -311,6 +311,7 @@ asmlinkage __visible __trap_section void do_trap_ecall_u(struct pt_regs *regs)
 
 		regs->epc += 4;
 		regs->orig_a0 = regs->a0;
+		regs->a0 = -ENOSYS;
 
 		riscv_v_vstate_discard(regs);
 
@@ -318,8 +319,6 @@ asmlinkage __visible __trap_section void do_trap_ecall_u(struct pt_regs *regs)
 
 		if (syscall >= 0 && syscall < NR_syscalls)
 			syscall_handler(regs, syscall);
-		else if (syscall != -1)
-			regs->a0 = -ENOSYS;
 
 		syscall_exit_to_user_mode(regs);
 	} else {
-- 
2.43.0



