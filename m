Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912951C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C362FC433D6;
	Wed, 23 Nov 2022 09:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194808;
	bh=7yT/qy9CpyKuApulMTuLV7GxoWs9DfN329EH5pEAS10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucYsgEg53w4viQ6nYau8y38KyP4TVdQApxX0C8bKJWYc3iKPSfIeohrOgFpSah0vi
	 TutEI+ihN5ZiTHbdawDuWasBC0eic6iO9oi+H7lNvyFuQzsIEPqgSleM3+w8rEMhQk
	 dYCdfgA+91ktpnBusYDCKQdU3eua7X5jwHOvoOIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/156] riscv: process: fix kernel info leakage
Date: Wed, 23 Nov 2022 09:49:54 +0100
Message-Id: <20221123084559.273096806@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 6510c78490c490a6636e48b61eeaa6fb65981f4b ]

thread_struct's s[12] may contain random kernel memory content, which
may be finally leaked to userspace. This is a security hole. Fix it
by clearing the s[12] array in thread_struct when fork.

As for kthread case, it's better to clear the s[12] array as well.

Fixes: 7db91e57a0ac ("RISC-V: Task implementation")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Tested-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20221029113450.4027-1-jszhang@kernel.org
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/CAJF2gTSdVyAaM12T%2B7kXAdRPGS4VyuO08X1c7paE-n4Fr8OtRA@mail.gmail.com/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/process.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 330b34706aa0..9d4b4098874b 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -104,6 +104,8 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long usp,
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 
+	memset(&p->thread.s, 0, sizeof(p->thread.s));
+
 	/* p->thread holds context to be restored by __switch_to() */
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		/* Kernel thread */
-- 
2.35.1



