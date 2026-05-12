Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DB63DD874;
	Tue, 12 May 2026 17:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608528; cv=none; b=hJJSHu5fB+dq2R65J3OkYIRyUgzpUU5xvNLuwz2wa5eRMrR9SZrlfYPx1xq+0sBtQ5eIR9sbuoVXG1lh3kwRWAMoZ5wncmdNO8b2UwdOr4NdCEVw0d7jSHg1/WR9sQQDU53E2mfCsK7EuXquGelzWq0B0b0cJlhMCpz30u7k1Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608528; c=relaxed/simple;
	bh=akyyWW8IwkcQYz29bpwuDu9KLRR2ywqJmNw2kH7I9vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4nKuDVrgXgjDpnOkCBnxZsI6uq60AxH9QmXxGv/1WA9o+yVIZpSMtPMbhI2xq8k9LjP8trY9qfIMjiz18UAQcrghvtkHbA7AkxKIRJKfYzS6BOCdJPodhP1z3t/luAub6gQPKw1EUWFbJg722pTqolPnLYRTDc+qzO7vuoKaig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByKwt6lQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByKwt6lQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB679C2BCF6;
	Tue, 12 May 2026 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608528;
	bh=akyyWW8IwkcQYz29bpwuDu9KLRR2ywqJmNw2kH7I9vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByKwt6lQoLodHwtBtbFnv/BPRP9ZkNOumTIuJQkLPoRFuH+K8A8f+KyCQ7QRnGn9/
	 yj+E8n9F+mXaUx3w/CR1Cs7rbk4QNxew4+53Csuh0pRtGI7qPI000BU+S9Lgzq3kL5
	 WjMGc+FHJSdRmrd0wxnymJI/ZFTN+12TzPoIgy04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.18 113/270] arm64/fpsimd: ptrace: zero targets fpsimd_state, not the tracers
Date: Tue, 12 May 2026 19:38:34 +0200
Message-ID: <20260512173940.838544148@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 5cbb61bf4168859d97c068d88d364f4f1f440325 upstream.

sve_set_common() is the backend for PTRACE_SETREGSET(NT_ARM_SVE) and
PTRACE_SETREGSET(NT_ARM_SSVE). Every write in the function operates on
the tracee (target) - except a single memset that uses current instead,
zeroing the tracer's saved V0-V31 / FPSR / FPCR shadow on every ptrace
SETREGSET call.

The memset is meant to give the tracee a defined zero register image
before the user-supplied payload is copied in (for partial writes,
header-only writes, and FPSIMD<->SVE format switches). Aiming it at
current both denies the tracee that clean slate and silently corrupts
the tracer.

The corruption of the tracer's saved FPSIMD state is not always
observable. Where the tracer's state is live on a CPU, this may be
reused without loading the corrupted state from memory, and will
eventually be written back over the corrupted state. Where the tracer's
state is saved in SVE_PT_REGS_SVE format, only the FPSR and FPCR are
clobbered, and the effective copy of the vectors is in the task's
sve_state.

Reproducible on an arm64 kernel with SVE: a single-threaded tracer that
loads a known pattern into V0-V31, issues PTRACE_SETREGSET(NT_ARM_SVE)
on a child, and reads V0-V31 back observes them all zeroed within tens
of thousands of iterations when a sibling thread keeps stealing the
FPSIMD CPU binding.

Fixes: 316283f276eb ("arm64/fpsimd: ptrace: Consistently handle partial writes to NT_ARM_(S)SVE")
Cc: <stable@vger.kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -957,8 +957,8 @@ static int sve_set_common(struct task_st
 	}
 
 	/* Always zero V regs, FPSR, and FPCR */
-	memset(&current->thread.uw.fpsimd_state, 0,
-	       sizeof(current->thread.uw.fpsimd_state));
+	memset(&target->thread.uw.fpsimd_state, 0,
+	       sizeof(target->thread.uw.fpsimd_state));
 
 	/* Registers: FPSIMD-only case */
 


