Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC837F489;
	Wed, 21 Feb 2024 14:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524146; cv=none; b=OLJ5vE0fUK6xaj6Qf8dosUlA8tjLfeNEJ8tKBbGgE6InAqZfTK4mtY67Ltt1ercLv80Ewpdm1avSvA0iBSKYS1xwTxoIS2T4CQ0wWX7hmbg0dxR66JUmdTXDE82o9DiZ6YRhRoGWeJwnRWk22d8tLvZRVWB3H20CHypt/Llnm8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524146; c=relaxed/simple;
	bh=ifL4tlibGLxYKvpuOkS7+F/Rk84rEGQYAEXKcP22YEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqsfR41n3qRjE4LHcrI7UHQOJ7O+PYM2FZdbexw5lcF8knFQBJLP5AJKG2QLC7OWKbV+M7E8ZgJwkCQ0Tr7hKP4nCLLsuVXYbY3pZMg/YLDZiwCGfNcdXhiUsO6QTm07CpjKvSEQNB4W+Yd5S49RgkXHCt9y8Frnycxi5Okb1D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/Wlp1cp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/Wlp1cp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9A7C433F1;
	Wed, 21 Feb 2024 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524146;
	bh=ifL4tlibGLxYKvpuOkS7+F/Rk84rEGQYAEXKcP22YEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/Wlp1cp/8ScPgp4cXLd6p1r5pXda7ncJgLVuKzC4SCxOcedx7Ax+JoS9FlYv086w
	 jcldXnLMDez7SG1qh8LNFQsABEciMNI5kL8QARi3cROMvCHuAmBHS8Kly6eoAEq9tv
	 7HqGRN9nyq6Pp+LSh5eo4Tu3Avb+J9Iv0gg8m39U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/379] s390/ptrace: handle setting of fpc register correctly
Date: Wed, 21 Feb 2024 14:05:08 +0100
Message-ID: <20240221125958.743137696@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 8b13601d19c541158a6e18b278c00ba69ae37829 ]

If the content of the floating point control (fpc) register of a traced
process is modified with the ptrace interface the new value is tested for
validity by temporarily loading it into the fpc register.

This may lead to corruption of the fpc register of the tracing process:
if an interrupt happens while the value is temporarily loaded into the
fpc register, and within interrupt context floating point or vector
registers are used, the current fp/vx registers are saved with
save_fpu_regs() assuming they belong to user space and will be loaded into
fp/vx registers when returning to user space.

test_fp_ctl() restores the original user space fpc register value, however
it will be discarded, when returning to user space.

In result the tracer will incorrectly continue to run with the value that
was supposed to be used for the traced process.

Fix this by saving fpu register contents with save_fpu_regs() before using
test_fp_ctl().

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ptrace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 3009bb527252..f381caddd905 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -411,6 +411,7 @@ static int __poke_user(struct task_struct *child, addr_t addr, addr_t data)
 		/*
 		 * floating point control reg. is in the thread structure
 		 */
+		save_fpu_regs();
 		if ((unsigned int) data != 0 ||
 		    test_fp_ctl(data >> (BITS_PER_LONG - 32)))
 			return -EINVAL;
@@ -771,6 +772,7 @@ static int __poke_user_compat(struct task_struct *child,
 		/*
 		 * floating point control reg. is in the thread structure
 		 */
+		save_fpu_regs();
 		if (test_fp_ctl(tmp))
 			return -EINVAL;
 		child->thread.fpu.fpc = data;
@@ -1010,9 +1012,7 @@ static int s390_fpregs_set(struct task_struct *target,
 	int rc = 0;
 	freg_t fprs[__NUM_FPRS];
 
-	if (target == current)
-		save_fpu_regs();
-
+	save_fpu_regs();
 	if (MACHINE_HAS_VX)
 		convert_vx_to_fp(fprs, target->thread.fpu.vxrs);
 	else
-- 
2.43.0



