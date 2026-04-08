Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261BF26FA5A;
	Wed,  8 Apr 2026 18:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673163; cv=none; b=ZG16X3PLvzg0I+bOqraP+ZGtxnTrYN5n/2djLy9j3fGkvvx2s51/wvOvBYBefKTSBdjJa7LKBfuwXfaSmZgDgnMlr2ej9dwmtT4ukoH6ZuYZmwgor4N9Z2KMc+v31YlytIu4BB/IUMkwVkGcCWlUxBZq882Y6hYuZ3ujAHUA+5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673163; c=relaxed/simple;
	bh=r65fmGZdjwOiXdCeqveA/9T0G//zaSFC9O4IczDuROk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6aT3ygR13vHeqLaWZtw4bDNab4G0Kle0wfZUP0xVQlcVN7Uo6xdEon8vYa1Lv1NDjIQCqv4Hgt5gkwePAE+mbtUSqXw2/m+HUTm5YQiSfpEfEKBu49NkG8fW2+HNsW9ULB+T8Bz9PtEEAQCbT6rRYBwlb1FbRs5dx6VvhI1yrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2i5+5mNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2i5+5mNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B182EC19421;
	Wed,  8 Apr 2026 18:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673163;
	bh=r65fmGZdjwOiXdCeqveA/9T0G//zaSFC9O4IczDuROk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2i5+5mNVBlpJkBiUjdRfWSun+S/fMWXE50ZUoC54OfYy7BNH6u/SxUlaADakwb8Si
	 uIx5s9K4Xy+Etr+17vDYWQWZ0SQ6n2ANsOVtDhy1PliYplivMDddUiKpTmOr4djld+
	 UpRq/4QDGMYvmp4TbALA5qHKUemzykwe0j5E2q8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Chen <vincent.chen@sifive.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/277] riscv: kgdb: fix several debug register assignment bugs
Date: Wed,  8 Apr 2026 20:01:51 +0200
Message-ID: <20260408175938.580987328@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Paul Walmsley <pjw@kernel.org>

[ Upstream commit 834911eb8eef2501485d819b4eabebadc25c3497 ]

Fix several bugs in the RISC-V kgdb implementation:

- The element of dbg_reg_def[] that is supposed to pertain to the S1
  register embeds instead the struct pt_regs offset of the A1
  register.  Fix this to use the S1 register offset in struct pt_regs.

- The sleeping_thread_to_gdb_regs() function copies the value of the
  S10 register into the gdb_regs[] array element meant for the S9
  register, and copies the value of the S11 register into the array
  element meant for the S10 register.  It also neglects to copy the
  value of the S11 register.  Fix all of these issues.

Fixes: fe89bd2be8667 ("riscv: Add KGDB support")
Cc: Vincent Chen <vincent.chen@sifive.com>
Link: https://patch.msgid.link/fde376f8-bcfd-bfe4-e467-07d8f7608d05@kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/kgdb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/kgdb.c b/arch/riscv/kernel/kgdb.c
index 15fec5d1e6dec..0bf629204c76a 100644
--- a/arch/riscv/kernel/kgdb.c
+++ b/arch/riscv/kernel/kgdb.c
@@ -175,7 +175,7 @@ struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] = {
 	{DBG_REG_T1, GDB_SIZEOF_REG, offsetof(struct pt_regs, t1)},
 	{DBG_REG_T2, GDB_SIZEOF_REG, offsetof(struct pt_regs, t2)},
 	{DBG_REG_FP, GDB_SIZEOF_REG, offsetof(struct pt_regs, s0)},
-	{DBG_REG_S1, GDB_SIZEOF_REG, offsetof(struct pt_regs, a1)},
+	{DBG_REG_S1, GDB_SIZEOF_REG, offsetof(struct pt_regs, s1)},
 	{DBG_REG_A0, GDB_SIZEOF_REG, offsetof(struct pt_regs, a0)},
 	{DBG_REG_A1, GDB_SIZEOF_REG, offsetof(struct pt_regs, a1)},
 	{DBG_REG_A2, GDB_SIZEOF_REG, offsetof(struct pt_regs, a2)},
@@ -244,8 +244,9 @@ sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *task)
 	gdb_regs[DBG_REG_S6_OFF] = task->thread.s[6];
 	gdb_regs[DBG_REG_S7_OFF] = task->thread.s[7];
 	gdb_regs[DBG_REG_S8_OFF] = task->thread.s[8];
-	gdb_regs[DBG_REG_S9_OFF] = task->thread.s[10];
-	gdb_regs[DBG_REG_S10_OFF] = task->thread.s[11];
+	gdb_regs[DBG_REG_S9_OFF] = task->thread.s[9];
+	gdb_regs[DBG_REG_S10_OFF] = task->thread.s[10];
+	gdb_regs[DBG_REG_S11_OFF] = task->thread.s[11];
 	gdb_regs[DBG_REG_EPC_OFF] = task->thread.ra;
 }
 
-- 
2.53.0



