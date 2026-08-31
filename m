Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B6D4B0C82;
	Mon, 31 Aug 2026 13:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184221; cv=none; b=SXME7dClAL3WqfbtmcPs8K6FdrNJtSSd9nIDG8u9RkO4vWSdSemtS10NrW5OR+sjvtJ3IE6EpYT+hSDK1yVHWe6Kf//AXu32GXRU4hVY+unJw5anTyBN6+m/67hBFOqYLChwBjfRp8PZ4rd2uu6EaKFNgLTU8HUpW1FR4/D6V6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184221; c=relaxed/simple;
	bh=6McxkPjq+JhMJa9F+pAjZXrxcyCZiB7vqWeH/sER1d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtmfZOeX4n+CD5Voc3GRYcfXT52WcNBkre3u+HJ2OEl6++w8iWutVmI6zsUPTj0awpGGUs+df3k5dmUzCiWOFgoAv+2dexLgGwcYA958/VHVbBAaDyB76GPnw0Rdjn7JanK7NuDnVJY8wEJqTidlKGehd8AEP+XOXMUE/9WlyTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clNz52MO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clNz52MO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ED11F00A3F;
	Mon, 31 Aug 2026 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184219;
	bh=6A+MbXV4uXsdwfY4ZbFYtR7DsQlzBCN2s1/efSVvgA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clNz52MO+VfHjE7eFNX+mA4vPYoseLqOU00aXgZ3jNN1TZe/HxSYUIGsfOZvCk/97
	 Mm8cXWO7nRdJAyhDNZuIzh5ZIMDcCU1juWqZICOzac/TYLepBU3fl0MnDFswlunEpT
	 Ge8RguBw8f67X+Qgj8Up+BS1tfaGfRlemK3DTckI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Neuling <mikey@neuling.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 32/99] riscv: Fix register corruption from uninitialized cregs on error
Date: Mon, 31 Aug 2026 15:34:01 +0200
Message-ID: <20260831133401.615392120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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
index 92731ff8c79ad..69e669ef48107 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -330,8 +330,8 @@ static int compat_riscv_gpr_set(struct task_struct *target,
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



