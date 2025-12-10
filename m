Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E735C613;
	Wed, 10 Dec 2025 07:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352143; cv=none; b=cvQxVjMw3vQ/Y+mOYdOD1gev4zCEuGprqRxhtTV+/AZzLEHpNYNOE5w3hVuAjjPYxM3fDlqwysnCfZWJmXrmekjALma72N2y957Q9tN0V08dypvQeqe6KKyTv/p+w9L1FC8hH1s43xWDXu0EhIY5u8niOu1AWQfBPD7OLs+XV0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352143; c=relaxed/simple;
	bh=UgZIIvUusjLGrYQSuFHVIQnhxwWukiEBZ0UF5ga6oAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHwFT3XzvMZ62FGwxAwU1W4y8/O/YXcCY1nUCVLUOR8HnmpjkLgzPV99EQBgEBh5xQCBGEc/SkIuBagbRqPG6DzSVqghm9ngi5QuS8g1v3wwr9W+0/ojG9Irlr7vIvmnyCiOekinXWOVbrKTVm4db49pSekDe9kjgQ/Wjykn0Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9ARcE9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9ARcE9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106E1C4CEF1;
	Wed, 10 Dec 2025 07:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352143;
	bh=UgZIIvUusjLGrYQSuFHVIQnhxwWukiEBZ0UF5ga6oAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9ARcE9LpH1h9ViVG/O/fQ4asYtaCAzUdb6/CbTzi1HODpDplg0oxptKxEng7fCh7
	 4ToC1H5GnJQc5B7TO7VkWhzFNRR9+c03dcqHGGZ1JViIvy51aF4DCL7f75yyaLy7of
	 mgteQZrBCxwPnN5i1E5DqbvYA4TB8KKvpOXemytM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 48/60] LoongArch: Mask all interrupts during kexec/kdump
Date: Wed, 10 Dec 2025 16:30:18 +0900
Message-ID: <20251210072949.060774742@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index f9381800e291c..8ef4e4595d61a 100644
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



