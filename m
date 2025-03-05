Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983CD254840;
	Wed,  5 Mar 2025 18:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198587; cv=none; b=nOCehBNRWbqonYOyGehKjEUg6CUsGFOVkBmVYGS+vLo2hqDmu5AdQ+T/Auct8wyLY0mCJiIsCK9uo7oUVlvtyhUq7aPIC7QYlS3JuIzyioarCMv0V8u5wURJs/uLJwATJQ4q6Sn7bbbnfF4BnWAXeKhY/s6VQqfl4NbONbfdqek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198587; c=relaxed/simple;
	bh=Ljirv+FxH60ZpfH+0gIfuPRmr1NH+GBWfJlQh81swJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txR4VnvL5n1ypiBc3jGkh8PY4Dx7EDcHdfXINjjuGBbsLaLb4IiU3WUHAVKRL6c0/zx9olwSgEIoszwAyubOrIspE0Y3iiEZkc5DoYiuCcBH000rzG8Uh32PzdT5lOPI6NS8PZAQ88o92moBvL44QyM2clBRRiRsr6FL6sWhOfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoYIfBOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoYIfBOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E1AC4CEEC;
	Wed,  5 Mar 2025 18:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198587;
	bh=Ljirv+FxH60ZpfH+0gIfuPRmr1NH+GBWfJlQh81swJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoYIfBObHFtE/b77k/psbLEBC4evbKyKrtrzlcJW0WRiToxglbTWAm8xEhF2oknVa
	 3BHmqKYYm69vgf07sh1yp84bzZ01yDYxnlazL4KrZiOg/+W8s/bySDfKGajfRsCcdF
	 dnZCa4x7LPbT826k69Nqxl6l8ev9TTT5pAdjM8Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 079/157] riscv: KVM: Fix SBI IPI error generation
Date: Wed,  5 Mar 2025 18:48:35 +0100
Message-ID: <20250305174508.485532646@linuxfoundation.org>
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

[ Upstream commit 0611f78f83c93c000029ab01daa28166d03590ed ]

When an invalid function ID of an SBI extension is used we should
return not-supported, not invalid-param. Also, when we see that at
least one hartid constructed from the base and mask parameters is
invalid, then we should return invalid-param. Finally, rather than
relying on overflowing a left shift to result in zero and then using
that zero in a condition which [correctly] skips sending an IPI (but
loops unnecessarily), explicitly check for overflow and exit the loop
immediately.

Fixes: 5f862df5585c ("RISC-V: KVM: Add v0.1 replacement SBI extensions defined in v0.2")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20250217084506.18763-10-ajones@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 9c2ab3dfa93aa..74e3a38c6a29e 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -51,9 +51,10 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 	unsigned long hmask = cp->a0;
 	unsigned long hbase = cp->a1;
+	unsigned long hart_bit = 0, sentmask = 0;
 
 	if (cp->a6 != SBI_EXT_IPI_SEND_IPI) {
-		retdata->err_val = SBI_ERR_INVALID_PARAM;
+		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
 		return 0;
 	}
 
@@ -62,15 +63,23 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (hbase != -1UL) {
 			if (tmp->vcpu_id < hbase)
 				continue;
-			if (!(hmask & (1UL << (tmp->vcpu_id - hbase))))
+			hart_bit = tmp->vcpu_id - hbase;
+			if (hart_bit >= __riscv_xlen)
+				goto done;
+			if (!(hmask & (1UL << hart_bit)))
 				continue;
 		}
 		ret = kvm_riscv_vcpu_set_interrupt(tmp, IRQ_VS_SOFT);
 		if (ret < 0)
 			break;
+		sentmask |= 1UL << hart_bit;
 		kvm_riscv_vcpu_pmu_incr_fw(tmp, SBI_PMU_FW_IPI_RCVD);
 	}
 
+done:
+	if (hbase != -1UL && (hmask ^ sentmask))
+		retdata->err_val = SBI_ERR_INVALID_PARAM;
+
 	return ret;
 }
 
-- 
2.39.5



