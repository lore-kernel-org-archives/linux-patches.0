Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129F01FCF41;
	Tue, 13 Oct 2026 12:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895461; cv=none; b=lSVp37bp3Z+CtoZJIdLVVxXdIeHMuSLB/ctjCWPyy8xZAghK5DPItzgvUBmoejqHBw3QdusYd5xnfwJuCWKWB0FEmzF7cikAmvHUJQpOalx7gC3cT/wVqCNvAGf54izweksIFGi9ryJoKVGZq80VDXHUP3HuovHaWot1CilGB4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895461; c=relaxed/simple;
	bh=/njsI3ofZ+oRacqp1y2yK7Lvxmp80pQqFhfioxxtg1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISNZnZT9vDrkY3AjpB6KkSzroC4bFLl4OAR06y5LQeKaVrLygMi1/oXWgS6S6IzlOkvg8OT9z26GcwovgiXCrwPEHVC1x7uYGtbEwBsd2fkGHf/zy5cdYl+paUTh/k88Gwe7WLJO/FkBvV3fUBYZFMAd3bSUrsLIaA7VVCAvcvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmwySocj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmwySocj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A151F000FF;
	Tue, 13 Oct 2026 12:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895459;
	bh=jShrU0Rvqm6+UslgXYqQmyi9VT25BXoVdEyGEQQiH/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmwySocjF14fyJ0KqhKu/I6O8TI21UYhK0bpPF+qR2JrM4DatGzXtHDCZWss7H5+8
	 4qk/DPn5Yby2vJhEVKO4wDE3/XGS/mLFYT1RDIJzPFWV8yu2xtMHics11ZgjsN0och
	 YiZqDbRaqBpH97g0PQJmkvtIDqwumv57R1ViaR0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 283/497] arm64/fpsimd: signal: Clear PSTATE.SM when restoring FPSIMD frame only
Date: Tue, 13 Oct 2026 13:37:30 +0200
Message-ID: <20261013112914.611396394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 1bf663a86a4505a97f08d06c373704de9441c891 ]

On systems with SVE and/or SME, the kernel will always create SVE and
FPSIMD signal frames when delivering a signal, but a user can manipulate
signal frames such that a signal return only observes an FPSIMD signal
frame. When this happens, restore_fpsimd_context() will restore state
such that fp_type==FP_STATE_FPSIMD, but will leave PSTATE.SM as-is.

It is possible for a user to set PSTATE.SM between syscall entry and
execution of the sigreturn logic (e.g. via ptrace), and consequently the
sigreturn may result in the task having PSTATE.SM==1 and
fp_type==FP_STATE_FPSIMD.

For various reasons it is not legitimate for a task to be in a state
where PSTATE.SM==1 and fp_type==FP_STATE_FPSIMD. Portions of the user
ABI are written with the requirement that streaming SVE state is always
presented in SVE format rather than FPSIMD format, and as there is no
mechanism to permit access to only the FPSIMD subset of streaming SVE
state, streaming SVE state must always be saved and restored in SVE
format.

Fix restore_fpsimd_context() to clear PSTATE.SM when restoring an FPSIMD
signal frame without an SVE signal frame. This matches the current
behaviour when an SVE signal frame is present, but the SVE signal frame
has no register payload (e.g. as is the case on SME-only systems which
lack SVE).

This change should have no effect for applications which do not alter
signal frames (i.e. almost all applications). I do not expect
non-{malicious,buggy} applications to hide the SVE signal frame, but
I've chosen to clear PSTATE.SM rather than mandating the presence of an
SVE signal frame in case there is some legacy (non-SME) usage that I am
not currently aware of.

For context, the SME handling was originally introduced in commit:

  85ed24dad290 ("arm64/sme: Implement streaming SVE signal handling")

... and subsequently updated/fixed to handle SME-only systems in commits:

  7dde62f0687c ("arm64/signal: Always accept SVE signal frames on SME only systems")
  f26cd7372160 ("arm64/signal: Always allocate SVE signal frames on SME only systems")

Fixes: 85ed24dad290 ("arm64/sme: Implement streaming SVE signal handling")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20250508132644.1395904-3-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/signal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index f7b05267a76b2..6a5d83d9179da 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -278,6 +278,7 @@ static int restore_fpsimd_context(struct user_ctxs *user)
 	__get_user_error(fpsimd.fpcr, &(user->fpsimd->fpcr), err);
 
 	clear_thread_flag(TIF_SVE);
+	current->thread.svcr &= ~SVCR_SM_MASK;
 	current->thread.fp_type = FP_STATE_FPSIMD;
 
 	/* load the hardware registers from the fpsimd_state structure */
-- 
2.53.0



