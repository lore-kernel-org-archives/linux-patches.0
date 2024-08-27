Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912461C7B6F;
	Tue, 27 Aug 2024 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770929; cv=none; b=Bk7Bxl1Pq1VtisnDPEfYPN58nVcN8XmSoyhvngpd2o56b6Da9mKYcabmvnuWykrXFCknDNRuRMmAs8/Oa/1udB7RGyY/E/nZtaHVF4a3XBOSu/A8POFwB4sK2+W5LGw4RzyC3Dr9cZoX9LSpj6URatfFKLeL90U2qKwbi/+Hy2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770929; c=relaxed/simple;
	bh=LQ0EAmPOUUu8DdZibmMuLskhjjknjTWTRatM2YrB3DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VDiFYyhzCL9MOsiVLFyHQrXir94eItqhVwXtFuh8AUyeLTVNvaBakgUcic/Btiz9DJPZZKPISYU88ZyluhMO8s1jOFRYogJnZdAi40WKv4O3SuREFpk5Uc9NlqpmBhyZPgu5Z0mNMicWsxJ+v6xCeQFosgj3mDjA2UE96pcqG4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVxQodak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVxQodak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A39C4DDF5;
	Tue, 27 Aug 2024 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770929;
	bh=LQ0EAmPOUUu8DdZibmMuLskhjjknjTWTRatM2YrB3DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVxQodakSga4kxSnCBP/mJPc/YqXi1LGsuXpKWwHBO6p0A7J4HZY1yKOEGc2R/fqs
	 /HZcKGoSJJXexFoEfQWWGIp49CGc2jSEl4xjRgxNow+i6c6W/04X7FmtQzghySkSrT
	 lla7RKO44bnoU3wesleeGoElEHWkcV4mBmoiUOhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dmitry V. Levin" <ldv@strace.io>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Celeste Liu <CoelacanthusHex@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.10 028/273] riscv: entry: always initialize regs->a0 to -ENOSYS
Date: Tue, 27 Aug 2024 16:35:52 +0200
Message-ID: <20240827143834.464714731@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Celeste Liu <coelacanthushex@gmail.com>

commit 61119394631f219e23ce98bcc3eb993a64a8ea64 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/traps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -319,6 +319,7 @@ void do_trap_ecall_u(struct pt_regs *reg
 
 		regs->epc += 4;
 		regs->orig_a0 = regs->a0;
+		regs->a0 = -ENOSYS;
 
 		riscv_v_vstate_discard(regs);
 
@@ -328,8 +329,7 @@ void do_trap_ecall_u(struct pt_regs *reg
 
 		if (syscall >= 0 && syscall < NR_syscalls)
 			syscall_handler(regs, syscall);
-		else if (syscall != -1)
-			regs->a0 = -ENOSYS;
+
 		/*
 		 * Ultimately, this value will get limited by KSTACK_OFFSET_MAX(),
 		 * so the maximum stack offset is 1k bytes (10 bits).


