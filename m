Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E56118990F;
	Tue, 30 Jul 2024 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358374; cv=none; b=ujt4023BW6hsQlGuAL4iLyVYPbgb6A1sRkm0OrnvyCrwIYw0+peiJRoLDsmNv19k8Lqaev899jqTx6gq6pZayLj5bq3nYnVd5RpssEh6zKhEx+2E5S8GSm9OpDS/5j08KBMsKwhVqlp5YfCEjqOdUh4AWuBRBYn+bb6XTAyl1WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358374; c=relaxed/simple;
	bh=g08NX8RCgw5QWkW6V4z6kfHEWHEezv5hbrbXcQZTlKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6KTDckBer5ak6uPpvl0RNOdFRDFWeIt/Mz4CQmDYF35lBfTH3J/0Af/4EnDN8k0+rsysEtC+cb7aifIbCv+4IMuyg9dbEvG0OLETLUeZHNEwGrqESF4kIRgxJfb6xqHbkQXQ1asQ5wAmmQySW4YfJQuHIRlRf0Nv0GOq+iY/y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4czmV1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4czmV1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F73BC4AF0C;
	Tue, 30 Jul 2024 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358374;
	bh=g08NX8RCgw5QWkW6V4z6kfHEWHEezv5hbrbXcQZTlKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4czmV1l5HU/ZsqifW4WRth0/uqURQYaHIshndMZBLgUG1+TkeMPuMFD3cUDzcs0C
	 tvcIzHf5GdaSqzHjfLTIrkCcO1NMy9GAsaCIhhu+h1avrcIhxKVSarFKXCSsV/i4d2
	 Cj7HELRXh4h4gU9y4yEtZG7ugJr4jl9Vk88S2y7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 356/568] LoongArch: Check TIF_LOAD_WATCH to enable user space watchpoint
Date: Tue, 30 Jul 2024 17:47:43 +0200
Message-ID: <20240730151653.778918299@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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



