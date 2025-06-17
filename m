Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729502ED14D;
	Tue, 17 Jun 2025 15:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175581; cv=none; b=F+rTJ0jiNYaRb9nFD8Ar+EgzWkKVE0hjv7VNX2lBAUTNivQo8RopmN7zhIqlXX2+xVZmb6c2AHIymkdxHGLmbjg52nE81MhRjkJ/htqa3tf6lND7WWTZOgEm191rx5Wx2kto5QFloCEpklkytwHDwR0hoxQC8T3K9nmPVyophdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175581; c=relaxed/simple;
	bh=MCPv01huxpg2eu8cLkpx1AqtzFSOZCo2bK7QsLKSRxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ck78zHfSApIqciXk/gMbOmicXh4zcs0wCLpG1cDdO2A8izAM4yUrAs2tSBqNqjBvmV8Z5e0LLyhThXLlGPXh78uG9IjPrvcUbHtWEVH+aHf0xcVzvilJA/pjQvTpq42plbh+kS/yFn0E59QUbnUPBa+5HT8gDXYJIysCGbD3qU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZw9xiG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZw9xiG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E86C4CEE3;
	Tue, 17 Jun 2025 15:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175581;
	bh=MCPv01huxpg2eu8cLkpx1AqtzFSOZCo2bK7QsLKSRxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZw9xiG1pHrKBl8/Lvh/YIeVSRda1ZZ7ACciMTrNaKWyqNGlgzoQ9UGhNwlyKsgnm
	 XWI84FofF9NxCSlzV5Z6ttrNi0dRgxpX2dXAnZ+do9P0tdcLg3I4EAN0BvA+HpZAqB
	 NrGqB88ljzxNbib+SCfICWrGFyCpwTNOFUH/P3Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 103/780] arm64/fpsimd: Avoid clobbering kernel FPSIMD state with SMSTOP
Date: Tue, 17 Jun 2025 17:16:51 +0200
Message-ID: <20250617152455.703292593@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 01098d893fa8a6edb2b56e178b798e3e6b674f02 ]

On system with SME, a thread's kernel FPSIMD state may be erroneously
clobbered during a context switch immediately after that state is
restored. Systems without SME are unaffected.

If the CPU happens to be in streaming SVE mode before a context switch
to a thread with kernel FPSIMD state, fpsimd_thread_switch() will
restore the kernel FPSIMD state using fpsimd_load_kernel_state() while
the CPU is still in streaming SVE mode. When fpsimd_thread_switch()
subsequently calls fpsimd_flush_cpu_state(), this will execute an
SMSTOP, causing an exit from streaming SVE mode. The exit from
streaming SVE mode will cause the hardware to reset a number of
FPSIMD/SVE/SME registers, clobbering the FPSIMD state.

Fix this by calling fpsimd_flush_cpu_state() before restoring the kernel
FPSIMD state.

Fixes: e92bee9f861b ("arm64/fpsimd: Avoid erroneous elide of user state reload")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250409164010.3480271-8-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 9466b3c5021ac..72ab9649c705b 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1575,8 +1575,8 @@ void fpsimd_thread_switch(struct task_struct *next)
 		fpsimd_save_user_state();
 
 	if (test_tsk_thread_flag(next, TIF_KERNEL_FPSTATE)) {
-		fpsimd_load_kernel_state(next);
 		fpsimd_flush_cpu_state();
+		fpsimd_load_kernel_state(next);
 	} else {
 		/*
 		 * Fix up TIF_FOREIGN_FPSTATE to correctly describe next's
-- 
2.39.5



