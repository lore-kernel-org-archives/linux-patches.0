Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AF74C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64188C433D6;
	Mon, 14 Nov 2022 12:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430288;
	bh=jqCPru3y732058yacaCblkiHERY4EMkNIoNU3ZxoKmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bWhVfAVq3p82yP4xd2DL6q51xfFQ93SJOsHkBs/KY2CCATTsOgaYjvq3/v+SSiLD
	 T9vnftpoEq2SDpN1O0MbGPxSXj2t4WBtnq9Ep07rAWun942EGH6hOj6er7FbwAQdyK
	 BPZV3czVfqVize7zKrPzg5/XxnfIXPXh3/8zFWfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/95] riscv: process: fix kernel info leakage
Date: Mon, 14 Nov 2022 13:45:44 +0100
Message-Id: <20221114124444.606890069@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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
index dd5f985b1f40..9a8b2e60adcf 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -111,6 +111,8 @@ int copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 
+	memset(&p->thread.s, 0, sizeof(p->thread.s));
+
 	/* p->thread holds context to be restored by __switch_to() */
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		/* Kernel thread */
-- 
2.35.1



