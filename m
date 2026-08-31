Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C965398C8;
	Mon, 31 Aug 2026 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183931; cv=none; b=R2c14jdH/f0XFpHxUeptLedFr7drxgkO5vKTzYO6AeSHOL6LHXCM7NPTL1e6UsufZo5mcuKe1MVcRxRqeblYCPzlKztNaiTShYWIKbdTr5j7uJeNzDf94Il0JTO4GvxWffqeZxkla3qRfKHhh409qyhHb0HUdgAw8S6SgE6uhpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183931; c=relaxed/simple;
	bh=56ksBMN5zF9z9I2+ENumqnmmJndRSHmjB7wKq51E6sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVJsdfe4U6fVrNu/7/Pd6+9JobPvpRiydyXOON7hUGvj9nolOPpLzYEBS06lPzp21I7vJyi/ZRX4wwvOWkwNPAFS4Gl/2hBh8Dd6xik/xhLxavwaW1IP169VckPNMx4Y8ohG2cdv2aHQ7LNfsXeUbSQtet+x3+DPnONfQpp7QqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9tpkLRJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9tpkLRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6111F00A3D;
	Mon, 31 Aug 2026 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183929;
	bh=sHbcAgf5+OhDpjsltjbnRmIOwIBzbOblVUSnhA/L3NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9tpkLRJ1cLh92NoAiN88/866wD8ZBm23+aVqvgkmewI670f/FngDz6ZMjuPykqSN
	 whAKdxYFthduGCHW/DIMxYt2Y+y4mYQf1RvGW7t/wig8vIhRp/uc8T7QI2MkigX43P
	 iuX6iFocpOnEXh6PrMqnbh/OKRlt47LVUwX92+js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Neuling <mikey@neuling.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 15/83] riscv: Fix register corruption from uninitialized cregs on error
Date: Mon, 31 Aug 2026 15:33:51 +0200
Message-ID: <20260831133359.994110063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8e86305831ea4..32cd48a4cebb8 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -372,8 +372,8 @@ static int compat_riscv_gpr_set(struct task_struct *target,
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



