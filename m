Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4766733290A;
	Fri,  9 Jan 2026 11:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959491; cv=none; b=u/4JrRIkXBSVKgfwc0ltVGikb4RhB7c5jf6kz3kLFyHILAQItVyUY9KmczOaSaU0FwAuXyclPYDAz0GyvDz3kfKa3DhFj1/AgtpmTvprP4EHaMAhW00UX9V2NOqkNgUv5HRxsyzWYxgwdEvHgFUr0cv3M3ltxbnWwtwLafBkARM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959491; c=relaxed/simple;
	bh=ZrelkOIVCaWIIBzXcTjSQvTPQTtUqqBkRlmPmh6NPUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miGJvsmdx/IvqqYov7ExavdBOB4ceLBYkIZSbrXpo6DjFqxjmrW2o0aLEAc3+9ciOvtQ56IH1NqMgbdAs9aicqG4CcIAlKjlLph9HXASXt0xbn48PKIrlrqPRaX6z/LoA9Da1RXaVYUP5RptG4lpZMMDQiDYxiC+IIPxqklG9FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOImzAJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOImzAJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A2AC16AAE;
	Fri,  9 Jan 2026 11:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959491;
	bh=ZrelkOIVCaWIIBzXcTjSQvTPQTtUqqBkRlmPmh6NPUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOImzAJQ4l0el9KsntElu8FZLQ460aWNUH8vkZ5n4rmxYbqGvXuWrb5PZ1cnfP//B
	 hvvlSzWikTPo4L360S302CJKAUYnCWRWfe+IXE9lTrVrCRBdOfMqKWFeZeoQQDMr6j
	 /GUpQpuOgIf0u8rVqPI5Lw1SbwCY6lOROMOtGq84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/737] LoongArch: Mask all interrupts during kexec/kdump
Date: Fri,  9 Jan 2026 12:32:57 +0100
Message-ID: <20260109112135.427873150@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 863a320dc6fd7c855f47da4bb82a8de2d9102ea2 ]

If the default state of the interrupt controllers in the first kernel
don't mask any interrupts, it may cause the second kernel to potentially
receive interrupts (which were previously allocated by the first kernel)
immediately after a CPU becomes online during its boot process. These
interrupts cannot be properly routed, leading to bad IRQ issues.

This patch calls machine_kexec_mask_interrupts() to mask all interrupts
during the kexec/kdump process.

Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/machine_kexec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kernel/machine_kexec.c b/arch/loongarch/kernel/machine_kexec.c
index 30aa420610a06..e50c9a81ff1aa 100644
--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -249,6 +249,7 @@ void machine_crash_shutdown(struct pt_regs *regs)
 #ifdef CONFIG_SMP
 	crash_smp_send_stop();
 #endif
+	machine_kexec_mask_interrupts();
 	cpumask_set_cpu(crashing_cpu, &cpus_in_crash);
 
 	pr_info("Starting crashdump kernel...\n");
@@ -286,6 +287,7 @@ void machine_kexec(struct kimage *image)
 
 	/* We do not want to be bothered. */
 	local_irq_disable();
+	machine_kexec_mask_interrupts();
 
 	pr_notice("EFI boot flag 0x%lx\n", efi_boot);
 	pr_notice("Command line at 0x%lx\n", cmdline_ptr);
-- 
2.51.0



