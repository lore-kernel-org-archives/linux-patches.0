Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A8835B125;
	Fri,  9 Jan 2026 12:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961587; cv=none; b=Y0ezmczA6ked04zJwhcmM4a7PckXqd2BjOzvf+ZB+L//RmsaTrO/oW1sVcLFQb2V/ACPEFPhnhPdTAomLHsLPHf/DHjBS+Ci8cf57tw8KeBOYQfJOV0KhWuX0dDjIB+PASzQWaN0kerdnjcJ7BSyIUta/Cg3+0a31I1bE9EZ8go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961587; c=relaxed/simple;
	bh=3FsuxU+NyZlky4uBTKOU6PJQeaZeZzOTUgLI2XjdsjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akkd7HT3OyvhFbtN8OuXBZFW3/vgDeVkJUTG6FW9trLAjyHysbTMG+S+ecKrY028/dbbmv5fjmrrEDf9bsQmcsCguBOEevo+drt1WxjvNVOVJhBSgGK06wtdDthMY6I9obYUxdNh8c/VTXWw8PatErkhaRTLfmoDWSAlSRuS+TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXD7YT53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXD7YT53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74ED9C4CEF1;
	Fri,  9 Jan 2026 12:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961586;
	bh=3FsuxU+NyZlky4uBTKOU6PJQeaZeZzOTUgLI2XjdsjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXD7YT53OOYn7Q4MbaD1Xk5NhGt97u6ueqdm0TEHBTErlz+IxH70nMe1UFcpMrXHz
	 UOwepUzXY29xHuunbd6Ec+bHUihByn68vk8jNMhMO3+msOj6ukhJjDmx9sLhxn/MaP
	 qI5Cwhjdwz/dMuzHbkVOj+VBS2dGFrMrtvm6JRes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/634] LoongArch: Mask all interrupts during kexec/kdump
Date: Fri,  9 Jan 2026 12:35:11 +0100
Message-ID: <20260109112118.693877447@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



