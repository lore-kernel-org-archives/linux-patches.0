Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64E65F56B;
	Tue, 13 Feb 2024 17:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845506; cv=none; b=E7xYJ/GFyPLkI2gmgRR29ANiNANeThMJrIfCY0L4aREoukrMs+K+eh9R91+2X2L5AFrRRDk4FwkXODgRx7JiNVk20h3GC4iDVJ+yFn/qiAKatHjaeMOhi9Bk8dNeFYSTNLewGljWnGPCUCNXqMApJqq1Z7/oJAy9oRqDy+cFV7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845506; c=relaxed/simple;
	bh=VGGKE5ppvxRax8i/AsDWAJ6fohwXGYxPLs/gSN8yv/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHXjyM+GT88w8TxByGkB/k4g7nePb0QSVcN9KCIAL2/+CrkFGMfJVTPHhE4Bh7hZSWy1EaJUdJG87ihv/P04flewrNbYrXBAt3lNeX75hPbZVGklQPsZLhHm3PnCiXBkFii1HEkzqUeA8wb10VAN5u6ye3Zz8IDPYK2FimcW4p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtSb+jIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtSb+jIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1729FC433F1;
	Tue, 13 Feb 2024 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845505;
	bh=VGGKE5ppvxRax8i/AsDWAJ6fohwXGYxPLs/gSN8yv/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtSb+jIk2Udn7jeccru0DHHEFZabXqNL2kV0XxPsEwrzNhH9pkgIq6D+2zt2Z/zmJ
	 1hBz26KPyiBc2LFojER2epLWjNvS97MLRdS/fGCLMfBFDGFf9Nw+Atje3xBa4E7PtD
	 0qXr6k3RS3OplD8GZhsJH24MUFHzN7C6/Nm3/dKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/121] riscv: declare overflow_stack as exported from traps.c
Date: Tue, 13 Feb 2024 18:21:46 +0100
Message-ID: <20240213171855.827215010@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 2cf963787529f615f7c93bdcf13a5e82029e7f38 ]

The percpu area overflow_stacks is exported from arch/riscv/kernel/traps.c
for use in the entry code, but is not declared anywhere. Add the relevant
declaration to arch/riscv/include/asm/stacktrace.h to silence the following
sparse warning:

arch/riscv/kernel/traps.c:395:1: warning: symbol '__pcpu_scope_overflow_stack' was not declared. Should it be static?

We don't add the stackinfo_get_overflow() call as for some of the other
architectures as this doesn't seem to be used yet, so just silence the
warning.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Fixes: be97d0db5f44 ("riscv: VMAP_STACK overflow detection thread-safe")
Link: https://lore.kernel.org/r/20231123134214.81481-1-ben.dooks@codethink.co.uk
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/stacktrace.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/include/asm/stacktrace.h b/arch/riscv/include/asm/stacktrace.h
index f7e8ef2418b9..b1495a7e06ce 100644
--- a/arch/riscv/include/asm/stacktrace.h
+++ b/arch/riscv/include/asm/stacktrace.h
@@ -21,4 +21,9 @@ static inline bool on_thread_stack(void)
 	return !(((unsigned long)(current->stack) ^ current_stack_pointer) & ~(THREAD_SIZE - 1));
 }
 
+
+#ifdef CONFIG_VMAP_STACK
+DECLARE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
+#endif /* CONFIG_VMAP_STACK */
+
 #endif /* _ASM_RISCV_STACKTRACE_H */
-- 
2.43.0



