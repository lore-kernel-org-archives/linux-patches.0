Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBFC2EAD15;
	Fri, 15 May 2026 15:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860712; cv=none; b=JZA870cXFK6uEsYZQVJyDncd9i+Na8mKSX2zgWNCPLU6YSJKNar6C4P6LvHR7iHT0+cYn3LEVZrqceCVKV0Rl6aYyLDkoYUPieWOE4TcWSmzGRWV8dDb+uJYMGTz8+rZUfhkYc2/FcmXY9qjnZxyD0t2Euz/HdFv3kz3MAx4SmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860712; c=relaxed/simple;
	bh=QWaRBDJvdvEWKuObKu39n/5/ZeNbDI9WRAQHdmgiiFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uP5V2yxvblOBMNxFEE/7tQa7aMad3HrQa3hEHzpVSW24vODi+2tJEBfgRercrK5BtNEFM10u2qvv/lWCU5KZlnu5z3IiKwbsAA1HYsb+LAAC0nZ1u8kpzHdFT7GTo3nQiH7pMTpy0BBiOkMZQpr+spWpgawwziiYoeTMeBiN/iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8UztbNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8UztbNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B1DC2BCB3;
	Fri, 15 May 2026 15:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860712;
	bh=QWaRBDJvdvEWKuObKu39n/5/ZeNbDI9WRAQHdmgiiFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8UztbNwREtsu91hSVBr0IJdNygxPyYubE/8cCCjBm/+gYWzAAYFs4ZyxEO73+Z49
	 yliDkmC+NZaq0fE9lttm436IQ54964d24l0arYBLlhhGQl3y95SimnGyJtuFAN+Myg
	 L+VqausMDsLZAoUSxqITg1R1X9oOTjtM0ZGt8Wcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/474] LoongArch: Add spectre boundry for syscall dispatch table
Date: Fri, 15 May 2026 17:42:12 +0200
Message-ID: <20260515154715.554286046@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 0c965d2784fbbd7f8e3b96d875c9cfdf7c00da3d ]

The LoongArch syscall number is directly controlled by userspace, but
does not have a array_index_nospec() boundry to prevent access past the
syscall function pointer tables.

Cc: stable@vger.kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/syscall.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/syscall.c b/arch/loongarch/kernel/syscall.c
index b4c5acd7aa3b3..f4e3bd219b1d7 100644
--- a/arch/loongarch/kernel/syscall.c
+++ b/arch/loongarch/kernel/syscall.c
@@ -9,6 +9,7 @@
 #include <linux/entry-common.h>
 #include <linux/errno.h>
 #include <linux/linkage.h>
+#include <linux/nospec.h>
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
 
@@ -55,7 +56,7 @@ void noinstr do_syscall(struct pt_regs *regs)
 	nr = syscall_enter_from_user_mode(regs, nr);
 
 	if (nr < NR_syscalls) {
-		syscall_fn = sys_call_table[nr];
+		syscall_fn = sys_call_table[array_index_nospec(nr, NR_syscalls)];
 		regs->regs[4] = syscall_fn(regs->orig_a0, regs->regs[5], regs->regs[6],
 					   regs->regs[7], regs->regs[8], regs->regs[9]);
 	}
-- 
2.53.0



