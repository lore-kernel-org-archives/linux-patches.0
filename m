Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527D624886F;
	Tue, 20 May 2025 14:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750642; cv=none; b=LvzAL3+0Vd4jgnubv9e8aVkPCRh7f+jMce/KX19h96c+dtcg1S0OAj6R804lmJtkUhwmtx6x7YXhVPBVbhF+aNC7lYL6WSGQztYnDZIsLX9yIL5jdVQiAbsD/o1I3sFy1NWngeoy8zMyEy/gbBAZUnHX1wDGcJncvrRcjUTQ3AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750642; c=relaxed/simple;
	bh=38usTZq/Ov/wFqnGjq2rMDTOum/AMTxNarGIIX22Y6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YX59rQvW3YNMqM8mG6IkUJYZYyFka+dsFUNtbHVL555tLEYQUAUJ+QzfsSjPaVjVLT31OMjkxJc3RZi9sliPG21Rq7h2xEIv9QkRYnPvcf0jStNKr5Ic2HJe+2QR8J7eHO+zuixtTbVwoqLlrBgM/I/AXpiw12VmCJ2qcj6svMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioWUrwrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioWUrwrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B9AC4CEEB;
	Tue, 20 May 2025 14:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750642;
	bh=38usTZq/Ov/wFqnGjq2rMDTOum/AMTxNarGIIX22Y6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ioWUrwrKZo9JpElDodEL7rAAyVqjD6/NQzukAs1gahJpeGY27CIAeuUqSx4np5Fz2
	 Fql/15oQ5CslRcIMY+pyjY3W1RrO2Cy7CgGXqZO485A/+ZLmPFW6eMCQvxoeWyzMWX
	 lAB5zocGKNZ77Z/EfITgXEPsviEcCwCXURQMBvNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 073/145] LoongArch: uprobes: Remove user_{en,dis}able_single_step()
Date: Tue, 20 May 2025 15:50:43 +0200
Message-ID: <20250520125813.444394056@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


