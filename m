Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0C0449EC3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301145; cv=none; b=PPrlfhQ+o5gFVjfnLHAR6HRGOl/z3t54qbnl7zTQEdxQ+47/pE+cHt0k77XBzepWZ3pnLt3TEp2cINzDLIPybxAnVZns30DkLA13eqaObqW4Nselngn64SK+ofYQZSAC9XYP+DkJE47IGzYzA3tTxEDSNnQPWBLcMyfAJwTbk2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301145; c=relaxed/simple;
	bh=Ay+j5DD0fGd7brSD6TMH/vFN55gblWpCNHFfop7lH1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnQSFg+GKJ2xCnS8VcyHW6Rby+q+bjpS9lMGMqDeG2PPtn7IWg+xRYui7B8HudN2itoMaFrxtlyjFt0ETZjUi5mwEbQNClC07W+e2kN001mFhqJzJAXrGcUaLX8Rt9XZ9MzALV2OhkllX3YTfaPpw54Wu/SFIOnKGvBwy/Lpa7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3bfmAjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3bfmAjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1883C19423;
	Sat, 28 Feb 2026 17:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301145;
	bh=Ay+j5DD0fGd7brSD6TMH/vFN55gblWpCNHFfop7lH1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3bfmAjXu3+cGT9f+/75X75i7bkx9jFzsLgU9ZP8BI1Z5oGB+JRsmy0vwP8w9WIhj
	 yr1STbeLo1htgH5jAJllBu0KAX6yd1AWdg//qwJ/JgWifm/q9RPsZSWJ1MQ81g9AD6
	 PQiHbDSaweCi5YI2hCu9Fz0FAzhD6Cx0VEKDF9U1CVzac6xMCAW2p7Z2tImG4f9n+A
	 kh0BSEdeuLWKW+wFIO3ouvhfIY07skPhghPa+SFQzWnM7+pdp9IBK7WszHhicVJNdV
	 b8D1WfCSkHbsaYWROxNJYLg4gSVZxwRya02ktefxA5yyIPfjZRvRPFyB3aUTHaBSd0
	 Qn+Hi626eSDBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sergey Matyukevich <geomatsi@gmail.com>,
	Andy Chiu <andybnac@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 307/752] riscv: vector: init vector context with proper vlenb
Date: Sat, 28 Feb 2026 12:40:18 -0500
Message-ID: <20260228174750.1542406-307-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sergey Matyukevich <geomatsi@gmail.com>

[ Upstream commit ef3ff40346db8476a9ef7269fc9d1837e7243c40 ]

The vstate in thread_struct is zeroed when the vector context is
initialized. That includes read-only register vlenb, which holds
the vector register length in bytes. Zeroed state persists until
mstatus.VS becomes 'dirty' and a context switch saves the actual
hardware values.

This can expose the zero vlenb value to the user-space in early
debug scenarios, e.g. when ptrace attaches to a traced process
early, before any vector instruction except the first one was
executed.

Fix this by specifying proper vlenb on vector context init.

Signed-off-by: Sergey Matyukevich <geomatsi@gmail.com>
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Tested-by: Andy Chiu <andybnac@gmail.com>
Link: https://patch.msgid.link/20251214163537.1054292-3-geomatsi@gmail.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vector.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
index 901e67adf5760..34048c4c26dcd 100644
--- a/arch/riscv/kernel/vector.c
+++ b/arch/riscv/kernel/vector.c
@@ -109,8 +109,8 @@ bool insn_is_vector(u32 insn_buf)
 	return false;
 }
 
-static int riscv_v_thread_zalloc(struct kmem_cache *cache,
-				 struct __riscv_v_ext_state *ctx)
+static int riscv_v_thread_ctx_alloc(struct kmem_cache *cache,
+				    struct __riscv_v_ext_state *ctx)
 {
 	void *datap;
 
@@ -120,13 +120,15 @@ static int riscv_v_thread_zalloc(struct kmem_cache *cache,
 
 	ctx->datap = datap;
 	memset(ctx, 0, offsetof(struct __riscv_v_ext_state, datap));
+	ctx->vlenb = riscv_v_vsize / 32;
+
 	return 0;
 }
 
 void riscv_v_thread_alloc(struct task_struct *tsk)
 {
 #ifdef CONFIG_RISCV_ISA_V_PREEMPTIVE
-	riscv_v_thread_zalloc(riscv_v_kernel_cachep, &tsk->thread.kernel_vstate);
+	riscv_v_thread_ctx_alloc(riscv_v_kernel_cachep, &tsk->thread.kernel_vstate);
 #endif
 }
 
@@ -212,12 +214,14 @@ bool riscv_v_first_use_handler(struct pt_regs *regs)
 	 * context where VS has been off. So, try to allocate the user's V
 	 * context and resume execution.
 	 */
-	if (riscv_v_thread_zalloc(riscv_v_user_cachep, &current->thread.vstate)) {
+	if (riscv_v_thread_ctx_alloc(riscv_v_user_cachep, &current->thread.vstate)) {
 		force_sig(SIGBUS);
 		return true;
 	}
+
 	riscv_v_vstate_on(regs);
 	riscv_v_vstate_set_restore(current, regs);
+
 	return true;
 }
 
-- 
2.51.0

