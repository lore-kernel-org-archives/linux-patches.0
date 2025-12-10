Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D0C1DD0EF;
	Wed, 10 Dec 2025 07:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351941; cv=none; b=XSzpnZuQIAlpUPT0NT32FDZrJGN0ugy2zxoJQQvnotBHAJ8qPhsKj4HqVTfNEIUdU9FsNCaaEOKymzvzDyv2nuwN2e1U9HcDNETIw75IwhiaVxcSiOnr1qczvmCshvdLeLDlVJHpfxwg65R7KWoyRuSeYQzSUe0FyRjnHN16FGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351941; c=relaxed/simple;
	bh=tgZziLNnEL7fzH4WHtBohMQSEOKaQcQP07wuRAgJs5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IahEHsziIGO3FrdX+HRDRMGAggERDKGdmccUjPIkUJ+69sVrOsaEkSyUfQFtdORHbpI/45lmuScDTliIjX2XePvWS99y/wMiNc3cNEj/Ab/8MjFirXrb7yPT/PD6aSGnMbYY2TynOoPDYfr3ACIk/5PIB2q3DMChsDAidQb//Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCdcW85/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCdcW85/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7154C4CEF1;
	Wed, 10 Dec 2025 07:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351940;
	bh=tgZziLNnEL7fzH4WHtBohMQSEOKaQcQP07wuRAgJs5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCdcW85/V0Q8NDsivo+nEUevNrxIHerWiKAdixi7cIE7nnloQ+8e9n6hiqIlib1F2
	 kbPhi+B5R3vq3mixFEXxbLJK8luq90uahnkZkKrEJGWyUk+xuxVvMMwOyefE2xXpjx
	 D37byxYQXCQr26JBYNFwgy0wIEnQ9LcK4RhBF9LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 38/49] LoongArch: Mask all interrupts during kexec/kdump
Date: Wed, 10 Dec 2025 16:30:08 +0900
Message-ID: <20251210072949.111871502@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



