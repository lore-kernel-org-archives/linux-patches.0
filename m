Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E807E78B73;
	Wed, 21 Feb 2024 14:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525180; cv=none; b=Pn5MyevyiD+0ZJXw2QmSP/MqNyuJb3usNh2+LngSuutgf6nMAX9RsdkDzHzsiaIT/p2em2GNSshY6Pe/S2lna4QiLT2hRZnLxFb2QPirPKxGLMsfjEs9JKf2WvNNHsJwbhfJrtTHdp6agxSyqjwhANWuT5zVWaR3AoEa9uhop90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525180; c=relaxed/simple;
	bh=Uz4ffUujdoD1MtwuaHYtzUcswFbrz7sT6f/74CQepf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jbzi8wNdpkG3ektoFtRKLwAknbC17kmwkYVkE7KzXaZxsG6Yk6aAru2hGmb1/w6/U5GOslSOiYadB2UP3P+Hgkf3MKuo2fuBPW1T8t/MtYjcuzgZO8YFGbnlVLDv4duPq8Jpb9kRY2puNkqt9uM4vofc7cj338R8DEC44EW8LbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQ5oMx3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQ5oMx3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094A8C433F1;
	Wed, 21 Feb 2024 14:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525179;
	bh=Uz4ffUujdoD1MtwuaHYtzUcswFbrz7sT6f/74CQepf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQ5oMx3kGwRXd2rsjp2MWaobNGI+z7vIjW8IEQh+AUwA+lk0117gpLxCHMmRtRNKp
	 h5IkPieWlU+Bhlk/usSv/XeK46fz8A38zIdkoXu2hLTbW9H2L/fRI5/KcvdrO2yy/d
	 S65PyK6wsnAAH9Skl2wyzyYYkSLVIqzxMubvJK1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/267] s390/ptrace: handle setting of fpc register correctly
Date: Wed, 21 Feb 2024 14:07:04 +0100
Message-ID: <20240221125942.574062157@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 34ca344039bb..05e1367c23d5 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -413,6 +413,7 @@ static int __poke_user(struct task_struct *child, addr_t addr, addr_t data)
 		/*
 		 * floating point control reg. is in the thread structure
 		 */
+		save_fpu_regs();
 		if ((unsigned int) data != 0 ||
 		    test_fp_ctl(data >> (BITS_PER_LONG - 32)))
 			return -EINVAL;
@@ -773,6 +774,7 @@ static int __poke_user_compat(struct task_struct *child,
 		/*
 		 * floating point control reg. is in the thread structure
 		 */
+		save_fpu_regs();
 		if (test_fp_ctl(tmp))
 			return -EINVAL;
 		child->thread.fpu.fpc = data;
@@ -1006,9 +1008,7 @@ static int s390_fpregs_set(struct task_struct *target,
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



