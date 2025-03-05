Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1AE253B64;
	Wed,  5 Mar 2025 18:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198584; cv=none; b=CBvGYF7/JImERzXk5mJ10JLC139rNt3+Kl+fqrwpT3rXE2htWvQDTfVA1J9KDl6r8Z+K9IQ8YeH+JO4TrYubVxgLHxlKRUgsi98Mo9eMMCsIratmRULcAyyn+/A7M8OeoxFR1dH51li6weY2aidOdeHEt8kxPpApXGXVR4CJfUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198584; c=relaxed/simple;
	bh=rEux6wVrUXf4x6t+UdqrruoMoYP0qEuLMhIP1GRSO68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3apaxDG2BpeAuBsXcmDY66GANRoseLZfxacuHKHihsurfH+XBM7gV+sQVNZZbOd1RVomJ9ta67YUCEn9TbGOmzBiRVV+wG7N5XFxP8xV+8FaV21jfT1cbFp+b14kmiKXOzdMkxu0Q3Y1XtbwnGVfW2r2/UdR2eigwmm9wkJX+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdkpPJ/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdkpPJ/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429B2C4CED1;
	Wed,  5 Mar 2025 18:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198584;
	bh=rEux6wVrUXf4x6t+UdqrruoMoYP0qEuLMhIP1GRSO68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdkpPJ/9/v0Qp4bubM3udFrT7/NS2pPRMrsTvPVeYewFcoD8QATZlW35j1PrfXnbr
	 IljjrgFaBIW2rNtRDPKK+gMqSfO88ZH/CxOsUiUbZ3HWXD/FHRz0AD/o1Dc6iF2ys/
	 5A/lig9+Q9p0RdwfbsNeMbeFSuDU10V/RtEP39HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 078/157] riscv: KVM: Fix hart suspend_type use
Date: Wed,  5 Mar 2025 18:48:34 +0100
Message-ID: <20250305174508.444090632@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit e3219b0c491f2aa0e0b200a39d3352ab05cdda96 ]

The spec says suspend_type is 32 bits wide and "In case the data is
defined as 32bit wide, higher privilege software must ensure that it
only uses 32 bit data." Mask off upper bits of suspend_type before
using it.

Fixes: 763c8bed8c05 ("RISC-V: KVM: Implement SBI HSM suspend call")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20250217084506.18763-9-ajones@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi_hsm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 13a35eb77e8e3..3070bb31745de 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -9,6 +9,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
+#include <linux/wordpart.h>
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_sbi.h>
 
@@ -109,7 +110,7 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		}
 		return 0;
 	case SBI_EXT_HSM_HART_SUSPEND:
-		switch (cp->a0) {
+		switch (lower_32_bits(cp->a0)) {
 		case SBI_HSM_SUSPEND_RET_DEFAULT:
 			kvm_riscv_vcpu_wfi(vcpu);
 			break;
-- 
2.39.5



