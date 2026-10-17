Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED093AE713;
	Sat, 17 Oct 2026 16:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255475; cv=none; b=ApYgqQypR/p2KK6kyTvli7avRrX8GqRVc9L5LhD10fHIs5JZzIJJUh7Px4Di5qvViUtQgP232cBYPGXuy6Y0gTn8YH4/zBztWm1epAouSBqB1E8d1apAPMbVoPTsviYIGfpBNScE0XtXLt6i4FVNixxGgxN7EvNkpNTA2J10aTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255475; c=relaxed/simple;
	bh=gaW+fwoVxXG3AdQN1GbESSYf2jcp9vrfvmJZDhjVZRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzCC3kl17aiXkk+Ou9BeKLxEpmTNIBjRTTQl/fA2j1MS4+7llL4gpDJfBQbpD88KjQVQ10XY1VOcnRn8/s+xUmvAjQUOgu/+avDvl8bYtalepg7NJdnyzkeygEC9aiJAuP2JvGp3js+mTgp3MXKURuN4dvXOFTSo7xdyQTnLoeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axzH0dyJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axzH0dyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF231F000C4;
	Sat, 17 Oct 2026 16:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255473;
	bh=ByqrRZWlRlYCaYpcosJfcZsYOhXvqUWylUvyfxwX9M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axzH0dyJvfP+pc52CQO/zu4sYcUqdk/xHBaEubVxxq6Fl422o5kYOxdgLbECYrELu
	 LsjCpOeIskG282Uy3M4DdHIxJle/GMkTOOem6XEojJFY7d83v9uhtL8QlAqqYRbXPL
	 masy60MHS6Xj2ux4lpaywXKqciCGy34kkABSUlrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 786/869] bpf: Mark syscall helpers as sleepable
Date: Sat, 17 Oct 2026 18:00:27 +0200
Message-ID: <20261017160057.064605342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 43081a7fb283a..9b3d067e47420 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5899,6 +5899,7 @@ EXPORT_SYMBOL_NS(kern_sys_bpf, BPF_INTERNAL);
 static const struct bpf_func_proto bpf_sys_bpf_proto = {
 	.func		= bpf_sys_bpf,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
 	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
@@ -5924,6 +5925,7 @@ BPF_CALL_1(bpf_sys_close, u32, fd)
 static const struct bpf_func_proto bpf_sys_close_proto = {
 	.func		= bpf_sys_close,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
 };
-- 
2.53.0



