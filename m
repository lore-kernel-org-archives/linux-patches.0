Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EA92DF3C9;
	Tue, 17 Jun 2025 15:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174877; cv=none; b=ZTp1eD8BV+8j+7srpzzXuwjqD2CDEL9ibfCTJ8b55NdmDa5/UFuNEcKGDLNJdt5xLqYecYSSpxfv3yIuf6voPzd9rjKtjLy3CE6tdKY7ExEdO2CTFQrFcd8fVbdNT7YmzogWOjuSkcUfh/7Kdh7iDZhAq9sSJS0madoc4BnTC9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174877; c=relaxed/simple;
	bh=8/BUnz/WVVss0rWuggSOzDVoUIk5DA4oykRPgDmIIgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDeQleTz41/kx4feY8PT4eMubKnFTbmi//JcCv0UgZukbtnxiQCciVnkh+Pfzy8QstTQTB3AAAfjv5Y1pBXd0TIIt9RXQ7QfxT1MLqztmxJk6Ukr/viUWhNlWhIndAJktypbwRH8fJBSZYDwStSpAhaKrhOsQq5PUPi2rilcSSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rw2wYVSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rw2wYVSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7EEC4CEE3;
	Tue, 17 Jun 2025 15:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174877;
	bh=8/BUnz/WVVss0rWuggSOzDVoUIk5DA4oykRPgDmIIgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rw2wYVSdSqbwg7AwfsB0CLJcHae7N2zvr7EQPK8abeAV/zU3er7xz/E/QiW8myB8V
	 +K6IZJmm4Mbav+Cyo0333VkFpdGkM7YKBDkJzgwAm7bptAXv6xhAlNMMO0hgeC4CMg
	 SFI+vrSDGmDUt77lcTeBkEy9MnUgGXpthwyF3SyI=
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
Subject: [PATCH 6.12 069/512] arm64/fpsimd: Avoid clobbering kernel FPSIMD state with SMSTOP
Date: Tue, 17 Jun 2025 17:20:35 +0200
Message-ID: <20250617152422.368275431@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 12982f1570fca..9f2b83c50f7d9 100644
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



