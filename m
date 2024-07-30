Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669A31A76A2;
	Tue, 30 Jul 2024 17:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359724; cv=none; b=j7AFb3N6iCoO7PK2Vevg3oZvpb06Ae56+GNxibn5b0zJ0/vNGG3qgbtC4uqhVIRtPTtvNAYpuf7tJtW2KsS2yqXnLXB0WJ5Po2fpLeWa0fyuP9joujN2VvZ+MHQ9qZgpyIAt0SVKfs2CkPvc9mIBYkjla7ELgKurSUoHxYWVrU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359724; c=relaxed/simple;
	bh=acISr0ANHkcKZhkqultyz/qb9Ms2CZsUKZIK1Qhaydo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQyt3xPCbg1FGB95dk+y/PDD4ZgqYfF5ljWFETwBVB89rZpVB3owEVDU9d3doP4t8sAjhkUITMylaDMLVVEmoAbfcLGnk599DSV5jNi3ei3mGoyie1NPjtHNH4r5F/EB/fhKTJpdR2Cj7c2iKqQ88+0OMHSvul0um6GJOgJnD3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzh43lYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzh43lYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9769EC4AF0A;
	Tue, 30 Jul 2024 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359724;
	bh=acISr0ANHkcKZhkqultyz/qb9Ms2CZsUKZIK1Qhaydo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzh43lYDL2aXxLeu52QbCalZf+728oJ1pquW3i+nKbtM8D5NMWgaxALskYMCayLne
	 uFW8JBn4Xciy/qXkzt+xmaOD4YlMhxQYzBTPBPlI51eCOKQJBn4DmLVz5Tww3/SvZ2
	 lpT8CxclIBZONLjI/ukILRJ64kSirOfbt7U7iUlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 524/809] LoongArch: Check TIF_LOAD_WATCH to enable user space watchpoint
Date: Tue, 30 Jul 2024 17:46:40 +0200
Message-ID: <20240730151745.435182826@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 3892b11eac5aaaeefbf717f1953288b77759d9e2 ]

Currently, there are some places to set CSR.PRMD.PWE, the first one is
in hw_breakpoint_thread_switch() to enable user space singlestep via
checking TIF_SINGLESTEP, the second one is in hw_breakpoint_control() to
enable user space watchpoint. For the latter case, it should also check
TIF_LOAD_WATCH to make the logic correct and clear.

Fixes: c8e57ab0995c ("LoongArch: Trigger user-space watchpoints correctly")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/hw_breakpoint.c | 2 +-
 arch/loongarch/kernel/ptrace.c        | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/hw_breakpoint.c b/arch/loongarch/kernel/hw_breakpoint.c
index 621ad7634df71..a6e4b605bfa8d 100644
--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -221,7 +221,7 @@ static int hw_breakpoint_control(struct perf_event *bp,
 		}
 		enable = csr_read64(LOONGARCH_CSR_CRMD);
 		csr_write64(CSR_CRMD_WE | enable, LOONGARCH_CSR_CRMD);
-		if (bp->hw.target)
+		if (bp->hw.target && test_tsk_thread_flag(bp->hw.target, TIF_LOAD_WATCH))
 			regs->csr_prmd |= CSR_PRMD_PWE;
 		break;
 	case HW_BREAKPOINT_UNINSTALL:
diff --git a/arch/loongarch/kernel/ptrace.c b/arch/loongarch/kernel/ptrace.c
index 200109de1971a..19dc6eff45ccc 100644
--- a/arch/loongarch/kernel/ptrace.c
+++ b/arch/loongarch/kernel/ptrace.c
@@ -589,6 +589,7 @@ static int ptrace_hbp_set_ctrl(unsigned int note_type,
 	struct perf_event *bp;
 	struct perf_event_attr attr;
 	struct arch_hw_breakpoint_ctrl ctrl;
+	struct thread_info *ti = task_thread_info(tsk);
 
 	bp = ptrace_hbp_get_initialised_bp(note_type, tsk, idx);
 	if (IS_ERR(bp))
@@ -613,8 +614,10 @@ static int ptrace_hbp_set_ctrl(unsigned int note_type,
 		if (err)
 			return err;
 		attr.disabled = 0;
+		set_ti_thread_flag(ti, TIF_LOAD_WATCH);
 	} else {
 		attr.disabled = 1;
+		clear_ti_thread_flag(ti, TIF_LOAD_WATCH);
 	}
 
 	return modify_user_hw_breakpoint(bp, &attr);
-- 
2.43.0



