Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A417EEDE;
	Tue, 20 May 2025 14:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749805; cv=none; b=pRxCxy0oqiuCOzAyID7w1R6kCnqj4M6fk2NsdskRQPqJ2CN55dcIhojNQvQSNxOvVjJtM6H+ti8dBC/iEiFTWvfpPTY1gIlLo4cJS79HOo9bCPn/hupXpY3u1TwPJotDURzs0hVLoqST8sWFJW2I1FmFMZ7tBiiBqLN7eJQnTDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749805; c=relaxed/simple;
	bh=7LxPmxdNyLFMWai6jP2FvvEYoFJkY/Wh+QuaJ1910Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZkoz5npMjQq7xLwZFtDI6AEPUZWddu9wrn5tLo4b/TUMQbLGcBrUWBtNa5ADOOWnQpHFrFcygk0hIOnzhivzQcA7sXbNKzm8E+Quox/QBsq4tylc3jJzaP1ViSkAggw93VPkVJ+uG144onB22Fcv7VgPNEoxEuOAu582Sj6yjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XL6u25SI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XL6u25SI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837A8C4CEE9;
	Tue, 20 May 2025 14:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749805;
	bh=7LxPmxdNyLFMWai6jP2FvvEYoFJkY/Wh+QuaJ1910Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XL6u25SIEV/UED2XOIPwb4He1G4XFYUi6Dn5z0TXkvjfM98ewAUWpOzmUqKTAGboC
	 JQnmlKFYYcTYvKSGCG8dLLBTFrwZSIEYhy3oYHpkAwaDGIqF0yQuA1dDhWaSjb8ovl
	 Bbs5C5nXhvlP9w8OOPIOw+j6iTb2Kh/rr8fIPoHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 066/117] LoongArch: uprobes: Remove user_{en,dis}able_single_step()
Date: Tue, 20 May 2025 15:50:31 +0200
Message-ID: <20250520125806.611562268@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 0b326b2371f94e798137cc1a3c5c2eef2bc69061 upstream.

When executing the "perf probe" and "perf stat" test cases about some
cryptographic algorithm, the output shows that "Trace/breakpoint trap".
This is because it uses the software singlestep breakpoint for uprobes
on LoongArch, and no need to use the hardware singlestep. So just remove
the related function call to user_{en,dis}able_single_step() for uprobes
on LoongArch.

How to reproduce:

Please make sure CONFIG_UPROBE_EVENTS is set and openssl supports sm2
algorithm, then execute the following command.

cd tools/perf && make
./perf probe -x /usr/lib64/libcrypto.so BN_mod_mul_montgomery
./perf stat -e probe_libcrypto:BN_mod_mul_montgomery openssl speed sm2

Cc: stable@vger.kernel.org
Fixes: 19bc6cb64092 ("LoongArch: Add uprobes support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/uprobes.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/loongarch/kernel/uprobes.c
+++ b/arch/loongarch/kernel/uprobes.c
@@ -42,7 +42,6 @@ int arch_uprobe_pre_xol(struct arch_upro
 	utask->autask.saved_trap_nr = current->thread.trap_nr;
 	current->thread.trap_nr = UPROBE_TRAP_NR;
 	instruction_pointer_set(regs, utask->xol_vaddr);
-	user_enable_single_step(current);
 
 	return 0;
 }
@@ -59,8 +58,6 @@ int arch_uprobe_post_xol(struct arch_upr
 	else
 		instruction_pointer_set(regs, utask->vaddr + LOONGARCH_INSN_SIZE);
 
-	user_disable_single_step(current);
-
 	return 0;
 }
 
@@ -70,7 +67,6 @@ void arch_uprobe_abort_xol(struct arch_u
 
 	current->thread.trap_nr = utask->autask.saved_trap_nr;
 	instruction_pointer_set(regs, utask->vaddr);
-	user_disable_single_step(current);
 }
 
 bool arch_uprobe_xol_was_trapped(struct task_struct *t)


