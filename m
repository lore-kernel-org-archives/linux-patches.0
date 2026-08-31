Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D9A436BEA;
	Mon, 31 Aug 2026 13:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184509; cv=none; b=kNazuJhpLgpLphDfwwmdq0AXeqFJ7lsrP0NQ19+iiUQ1IIiT2bhiJteGYEru4+niRou/FobxN1mJ+Vq3bts9XRS/f6+yfwgmL4ufhMVAGrA9XsDmvI3FCVjLXT72gnYEhmZPpGYO3oyAEW4RGDkqMHa4kzGvl3vhw2sI3T58s9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184509; c=relaxed/simple;
	bh=STy5Ld5IlTbpjZGA+cZgFPft35l46CD9GrvtwUC8Gcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVoV4HvNRwC5EEylk/QT3FTIM7BKZRdUJAgBTd2Ce3OW8wM57HKtnlaG+U1RYnOypGLHEEe612kAu8FN0HzEeUorDzp9fz/GZAenivgU5jQp2RbkTqCxNH3J3BiqGka/VM+rjFiaYOhp8AOSZ39pO9PLoRfp4KfFkNPwCU/ZFoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZCd50NF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZCd50NF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9396A1F00A3D;
	Mon, 31 Aug 2026 13:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184508;
	bh=wJEaMsW02Q1U+XkVtzQ1bj3/CElSEjz3hAducyTauoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZCd50NFiy8leQfj+nvk1YEUgygZ/I/b7jEGMpwCos2H8LVKipauioFANzLZnMt06
	 Bo/PpZm6orMzuEg9u1lnaJqQeU/TyvUUQlwBaVRd/2WYN6hdVJd/ewaCpLNrv+pWjq
	 zvLHGg8UTU+3juGf7fH9knYKPL9skyVdgVw2Ee/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Neuling <mikey@neuling.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 25/91] riscv: Fix register corruption from uninitialized cregs on error
Date: Mon, 31 Aug 2026 15:34:13 +0200
Message-ID: <20260831133400.962961439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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
index 2afe460de16a6..be412db2ba1f3 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -327,8 +327,8 @@ static int compat_riscv_gpr_set(struct task_struct *target,
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



