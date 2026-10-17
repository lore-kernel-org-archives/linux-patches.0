Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27FF3A8753;
	Sat, 17 Oct 2026 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260717; cv=none; b=Exg/HjnTd3As8LrNWtUAONf8DfyPj5odAUnRV7jWu2O5E7ZH0uFcw//fyAfc7aGDoRsPzcC3pNrETIx20BK32Msa/nMH/qj4VULDw/f6uNlr1wXmSBAnzqXmME3hj5bJnj5t/3VvNml1pzZx5vu8cx7FZSCQVYC4l2KJFqL3pt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260717; c=relaxed/simple;
	bh=Z5OCofxIsZ2HyebooViCZX/xA1xJKFUomsnCHJdxiXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIdNh90J+0MYjhcBSDR8ekMUvsShX0edKgTJJayfb9Q9Q7s0HzB0fcVEMBLFaM4pwIGU2xVtt3JqlXT9FQZ/NX4Ftr/rjVcwKEEWrgTolTaWHXHF/OU0MFETmbpjcJ+UhVTLeigwuWdRk207Y9HIvmJcTPu5G5Jf3SqcAcVhRt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0pJuPqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0pJuPqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190531F000C4;
	Sat, 17 Oct 2026 18:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260716;
	bh=/iCz5qqChIkrgnPHv7ded9pnWPWaVe0Eg2RY1FKD1uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0pJuPqiXuKDOjnIjZXaN4XoFUAtR9Td1/Zl5ETMm644xdeeZQFJQH0gcNsETEKnl
	 ZgntSM2wBtpi7B87+wVWTRfqnCOXtjraZ/r4R1Ko+G9VqXhwfP61XLy+AfjK11hHIz
	 Kav55phvN0ptdeg5XvAJTAa+Xv3cKqO1Iu0LlioA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1638/1674] bpf: Mark syscall helpers as sleepable
Date: Sat, 17 Oct 2026 18:05:10 +0200
Message-ID: <20261017160513.123158566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit d05524794240b52fdc3b6c1220dd05505715824d ]

bpf_sys_bpf() executes the bpf(2) syscall body, which can take mutexes,
allocate with GFP_KERNEL, and wait for an RCU grace period.
bpf_sys_close() reaches close_fd() and filp_close(), which can sleep as
well.

Both helpers are limited to BPF_PROG_TYPE_SYSCALL, whose main program is
sleepable. That does not make every callback sleepable: a syscall program
can register a bpf_timer callback, and the verifier checks that callback
in a non-sleepable context while retaining the syscall helper set.

Without .might_sleep on the prototypes, such a callback can invoke
bpf_sys_bpf() from hrtimer softirq context and trigger a
scheduling-while-atomic failure. bpf_sys_close() is exposed through the
same missing context check.

Set .might_sleep on both prototypes so the existing helper-context check
rejects them from timer callbacks and other atomic regions. Calls from the
sleepable main body remain valid.

Fixes: 79a7f8bdb159 ("bpf: Introduce bpf_sys_bpf() helper and program type.")
Fixes: 3abea089246f ("bpf: Add bpf_sys_close() helper.")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260903144433.1716731-10-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c5c84dc2159db..599ae0b135916 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5685,6 +5685,7 @@ EXPORT_SYMBOL(kern_sys_bpf);
 static const struct bpf_func_proto bpf_sys_bpf_proto = {
 	.func		= bpf_sys_bpf,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
 	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
@@ -5710,6 +5711,7 @@ BPF_CALL_1(bpf_sys_close, u32, fd)
 static const struct bpf_func_proto bpf_sys_close_proto = {
 	.func		= bpf_sys_close,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
 };
-- 
2.53.0



