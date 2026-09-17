Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DD74ABBD2;
	Thu, 17 Sep 2026 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659380; cv=none; b=W/2Mj0tk7kH0b3l4E5LMSdeJh32+CSlHlCijmtuMzCFdJWdBdN/yjLfHpf4QfK0AdXYTBcEolpmiEZBMnMpIclvf80otUSBI7guP3oz2uSCePghygOdw/EfkxmIdUA3SG4yrTAxqY+ikdEk0Vzmj0ZlsXi6ot3WXFReSxq/5ecI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659380; c=relaxed/simple;
	bh=H+3frkQNa9g7VluPF6dQwZtDMqpssP9spglN/K4DbNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klVx0WDT212NGkpnb5s6m/APPkFFUcEk+1SLBfDzSaJZUyH/F4548kOGvAGyYbtUk/bU/HGhItCbgxOfgXEwwKtrw/ojfMufnmfFJcg9yETCSWJvu8oGJ0/i7DQ3nWQKDtUpUfKQrhTy+aEg9YYie3yWr6LedF/fvPjNxjG8aS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmwwxA2O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmwwxA2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CC51F00899;
	Thu, 17 Sep 2026 15:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659371;
	bh=i46zJ2tebZgUP/gFCVRSL56tI/zz9HjKji+C4YY4MJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmwwxA2OPqXgfgqJhA2IVEDwiN8OEru9gs9gtvle+YUbFzmeUYWia6pYXv/DwugD+
	 s7L/5CbSH7b8sqASz8dlLkPXVxfwl4om0ybiIdguw5/i3ztIKk8asqQXYpoM2JbRZZ
	 KL0cg4A5/9Y3CIaCovf0HWeQqS2RyqqWSfKxNCd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 233/733] bpf: Mark syscall helpers as sleepable
Date: Thu, 17 Sep 2026 16:09:01 +0100
Message-ID: <20260917151357.041715289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index fb678b9dcd3e6..c7cb336fb0648 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -6633,6 +6633,7 @@ EXPORT_SYMBOL_NS(kern_sys_bpf, "BPF_INTERNAL");
 static const struct bpf_func_proto bpf_sys_bpf_proto = {
 	.func		= bpf_sys_bpf,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
 	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
@@ -6658,6 +6659,7 @@ BPF_CALL_1(bpf_sys_close, u32, fd)
 static const struct bpf_func_proto bpf_sys_close_proto = {
 	.func		= bpf_sys_close,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
 };
-- 
2.53.0



