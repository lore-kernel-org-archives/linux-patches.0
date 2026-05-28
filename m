Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9A326B973;
	Thu, 28 May 2026 20:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998494; cv=none; b=harQ95rYDYQ9IO7asy9znDszc7CBm42/B/EOwUP6ZJxB/vrEsRAIgI4fubGTjKHU7fjVdflPQyYfEvNYKouPYLCJQC5vNaljrk5jS5vHcXQhIbLi69hCU2tjN8uU06xheofCvXxd2zqDU8JRbR/VzyavxbbUs2wqE9wJvK5iAsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998494; c=relaxed/simple;
	bh=gvdg7NThHvXcUJt8T/sZ0HDcMWnUeh1Atj/a057K4eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaoiVxFRiZLe03NW42yv2ZeZ8cQLvsIEQe9EcblRQa5A2hkgGVpD1h9cEUr4xnq/reYcRV1+XawvZsI7DpOeQe4SxRpZefw0IwARSd/TxI3HWokdiUBwpm00VCaBZqRoAF89bWEy+K2yo8lILx/NFl5UzK93CmalTNrm3XIotmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbakMQhr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbakMQhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9061F000E9;
	Thu, 28 May 2026 20:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998493;
	bh=z0Ncv8Pv93EjVrG4FJCWOVWHPjEDEXJvp4QOKtSzJBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbakMQhrrHDqOpKiQQDqvjcHmhRVoFWr5kKlPa/tYx2mjZj6EReu1N3+JoskgAGt+
	 3RiVvaocYEhpYKCIdVYxplYs1KfqUF9xPUtH1FxTqQ+eTrRM6xqXfpfyA8lkYQmN1J
	 ew3uvgJrZ+9Uh7Ws4ZGDbV0WsfLuB0+wQQMr1ty4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Neuling <mikey@neuling.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 192/461] riscv: Fix register corruption from uninitialized cregs on error
Date: Thu, 28 May 2026 21:45:21 +0200
Message-ID: <20260528194652.637904738@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

[ Upstream commit 6ebcbb53fc9bc30843054ed99fd60b8e542628f4 ]

compat_riscv_gpr_set() calls cregs_to_regs() unconditionally, even when
user_regset_copyin() fails. Since cregs is an uninitialized stack
variable, a copyin failure causes uninitialized stack data to be written
into the target task's pt_regs, corrupting its register state and
potentially leaking kernel stack contents.

compat_restore_sigcontext() has the same issue: it calls cregs_to_regs()
even when __copy_from_user() fails, leading to the same corruption of
the signal-returning task's register state on error.

Only call cregs_to_regs() when the user copy succeeds.

Fixes: 4608c159594f ("riscv: compat: ptrace: Add compat_arch_ptrace implement")
Fixes: 7383ee05314b ("riscv: compat: signal: Add rt_frame implementation")
Signed-off-by: Michael Neuling <mikey@neuling.org>
Assisted-by: Cursor:claude-4.6-opus-high-thinking
Link: https://patch.msgid.link/20260501062320.2339562-1-mikey@neuling.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/compat_signal.c | 2 ++
 arch/riscv/kernel/ptrace.c        | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/compat_signal.c b/arch/riscv/kernel/compat_signal.c
index 6ec4e34255a9a..cf3eb33a11e46 100644
--- a/arch/riscv/kernel/compat_signal.c
+++ b/arch/riscv/kernel/compat_signal.c
@@ -107,6 +107,8 @@ static long compat_restore_sigcontext(struct pt_regs *regs,
 
 	/* sc_regs is structured the same as the start of pt_regs */
 	err = __copy_from_user(&cregs, &sc->sc_regs, sizeof(sc->sc_regs));
+	if (unlikely(err))
+		return err;
 
 	cregs_to_regs(&cregs, regs);
 
diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index 93de2e7a30747..793bcee461828 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -577,8 +577,8 @@ static int compat_riscv_gpr_set(struct task_struct *target,
 	struct compat_user_regs_struct cregs;
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &cregs, 0, -1);
-
-	cregs_to_regs(&cregs, task_pt_regs(target));
+	if (!ret)
+		cregs_to_regs(&cregs, task_pt_regs(target));
 
 	return ret;
 }
-- 
2.53.0



