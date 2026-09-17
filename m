Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1734E06F5;
	Thu, 17 Sep 2026 18:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670418; cv=none; b=WV91X/63/hc4h3A9e1gktuQTr/5jcpCcNp2nlwwv/mmkoX2JMB2damtlPgMGNOSYpYZ2PlfRGdJNvqE3T61X+6rcP9NKz7/79fICDiCecYEUvHD16W1vH+N0cJquH8gqQlItDTPnNBQIbVYt54UtuMx7UjWffASFzXNLSqD70Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670418; c=relaxed/simple;
	bh=3jblMEegBmfDvyQRqYvlkJiWji+o01RHByK0/y8ixXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uq9m+Wo+unyhUcqOaflHBZliTsw+rhjTP0TAoQtoUiHYzn7FS7AFlkbC74YV8o1dwj2cdZVSrTBU7GP79NDpRdKioWnjUCdqbskJKgYErz3oXJej1DtRTrjB+gyD7bXor+1UtwEvw/MpL5hTGHNCv3x8RAu8evYM3t4+zz9iQa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMZUmN5F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMZUmN5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C6C1F000FF;
	Thu, 17 Sep 2026 18:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670416;
	bh=iGEbEcjyIY6GyjC9e5WGlnEq/Pnjq7oEvCIa5lnV8Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMZUmN5Fn7v71gzl5Z+6FGWEEUTgrO6jMniaYFGT9DAxjOpEjAt9CrxGied9ZmNKj
	 LX8R6jr3IbkGhHSPVQWBx3qTDRJtcK+C5eUJkXzj0ndyaMBzREpDbWLX9hoqrCBxqd
	 Nsdj+O6Wxd0/flTr5WKCOBn+ls0ZKy9Z8WfWn+Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0655/1102] bpf: Mark faultable stack helpers as sleepable
Date: Thu, 17 Sep 2026 16:09:58 +0100
Message-ID: <20260917151556.618254836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit 9d02927fdf4e930893c92e35fed01a2704496900 ]

The faultable variants of bpf_get_stack() and bpf_get_task_stack() pass
may_fault=true into the common stack collection code. Resolving user-space
build IDs may then call build_id_parse_file() and block on filesystem
reads.

Neither helper prototype sets might_sleep. Since prototype selection uses
the sleepability of the whole program, the verifier can still allow these
helpers from a non-sleepable region within that program, such as an
explicit RCU or preemption-disabled region. The task-stack helper can also
be called from a non-sleepable timer callback of a sleepable program.

Mark both faultable prototypes as sleepable. The existing helper context
check then rejects these calls while continuing to allow them in genuinely
sleepable contexts.

Fixes: d4dd9775ec24 ("bpf: wire up sleepable bpf_get_stack() and bpf_get_task_stack() helpers")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260903214758.2727663-6-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 1cbcaf0d1c5e1..0fc3777156beb 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -539,6 +539,7 @@ BPF_CALL_4(bpf_get_stack_sleepable, struct pt_regs *, regs, void *, buf, u32, si
 const struct bpf_func_proto bpf_get_stack_sleepable_proto = {
 	.func		= bpf_get_stack_sleepable,
 	.gpl_only	= true,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_PTR_TO_UNINIT_MEM,
@@ -589,6 +590,7 @@ BPF_CALL_4(bpf_get_task_stack_sleepable, struct task_struct *, task, void *, buf
 const struct bpf_func_proto bpf_get_task_stack_sleepable_proto = {
 	.func		= bpf_get_task_stack_sleepable,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
 	.arg1_btf_id	= &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
-- 
2.53.0



