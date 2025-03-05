Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234961ACEDD;
	Wed,  5 Mar 2025 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198246; cv=none; b=Zu48alvh/LreaSWtYdyG3Qto6cJg19YvqnwVJl+MfPxYw7fY+NDDRp9jZXHFzbR98xVxa/w5DVXRrzIU3UQiO1R1NP6YibVbpZrioEyLNV+NZ627XOBfvmECG5Fs/ZhJvbCmIU+49M+EGQa17fmn8s7kEke+gOvjnHFKqIefIoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198246; c=relaxed/simple;
	bh=W0kl6dXQQJHXkCX8gK6ugid0hLGc6yLkvcJdLTyAEy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BE4NtamB1ryU6zWehSpKQNo0PMhu91fdNaKQh9NZ1jOMS5ZbM3jbVSYNw/jr+jjsWut4Xb9Z3QLqhwyN1R15ycT+mB4L5OP6Y517LQLvquWUdEOplsRSuV6idfBEjLGNcZFFTPF/Z7n//ewgI6qh0/iySgjLiqO2JtG5XGS6vms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcPE3m49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcPE3m49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE09C4CEE0;
	Wed,  5 Mar 2025 18:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198246;
	bh=W0kl6dXQQJHXkCX8gK6ugid0hLGc6yLkvcJdLTyAEy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcPE3m49iQ9V8F92ehn8SoXRzfQi+/VmxvVwWqx/ZAkMvpXG2bmNdux+Md6iEAGUY
	 pVua08HNJsR8MnkgPvcezV+90RYgA23nCoWeB8sT89oADDAqwQxbt2vaWNYCqx2Zc6
	 FAjTlCa2gfficepjQX8uVu5Pf9rYd/evGJQgQT/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/150] riscv: KVM: Fix hart suspend_type use
Date: Wed,  5 Mar 2025 18:48:31 +0100
Message-ID: <20250305174507.109804576@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



