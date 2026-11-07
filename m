Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063247;
	b=U1vJC/J42QwKcrtVCVzESNo/c2qeoWeDfOhLljvgUKtm0ZLuBX/PV5EaxX5XWVy0DRNr
	 3Kq0UXpy42xdzB9JYOVAJe5oZPED8BsDcf3ZOoPwa3x0XFNPHFoAQZdjdtoPppWHjqjsh
	 pZtePzoSnu8x0HQO5fUcIk3V15P9pyi6OYzqlY9mj/A5IZbaAyrTTEUl9bpfBlG1m8/Mz
	 B548hxEQ8gTII3SkMmd7/NAQzKMC+McVzW4DCQSdASj4Y7Vj5jmcLnD8/6jxxs43JC+Q3
	 8CSc8Vw+y9OCvFuvdLZAMok+eebXgx+np+B/UgNOfWPdzUByN7M5oObCQnaPBf9sSNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mcnjCr4i6z5KX2YNOflU4pEea2F77XDby4yslqsSb44=;
	b=fKjuRF+QSw6YVnDfXfxD2g1Jotd9F4uEqgrvDCgmWZ/uOSr+OUa74PnMCJcbSxS2fhKz
	 MysZf0b+Cjignv5ScQgIhzo76SZPpmY2te2wrwjFHd0KUGquz8uD8zhbaE6DywgneFtH2
	 seLWWbCOtDvoclKE60Ej5hAOub8eRxdOacvBhugbzPIy9zAturAK5RpWJD7MHMVO7L5Yd
	 +TzvaAtRdDSipFKlQFmPvcEMrjGoxpy/YkcPmpFLwzH9VSjwT6EzqXu2Pwvjtmt8TvBgk
	 hzhiiPzRpr9CAUfyLZNSKeS3xMYppj+1aQH8080eQhcRqTYfHhCMD4fej/A4OEf0Gzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jx2JVJSv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38876606A32E;
	Sat,  7 Nov 2026 14:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jx2JVJSv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02D11F0089F;
	Sat,  7 Nov 2026 14:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063247;
	bh=mcnjCr4i6z5KX2YNOflU4pEea2F77XDby4yslqsSb44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jx2JVJSvs1uSyQDccyAaFPaSBdphCJLWPlhi5/GpvCe1/lXov58T19QgzLh7q1R1A
	 7Qe3cOggAnvRPFwI2c4jGaxBCp1OU/LTOIZc6Zkc1VBTslOO5UyzXRbYYvuxwqp+xK
	 l0SzR7D1Q7g9NVczFx7Pr0sio4S+C9BnEB2LU8dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Xiaofeng Yuan <yuanxiaofeng@eswincomputing.com>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 451/869] RISC-V: KVM: Fix IPI delivery for out-of-order vcpu_id
Date: Sat,  7 Nov 2026 08:52:13 -0500
Message-ID: <20261107134909.011918730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaofeng Yuan <yuanxiaofeng@eswincomputing.com>

[ Upstream commit c367d3bf721f2bc391d6cfb47f6884e99d563df0 ]

The SBI IPI handler walks vCPUs with kvm_for_each_vcpu(), which
iterates by vcpu_idx (creation order) rather than vcpu_id order.
Since vcpu_id can be assigned out of order by userspace, a vCPU whose
hart_bit falls outside the XLEN-bit hart_mask range may be reached
before vCPUs the mask actually targets. In that case the handler jumps
to "done" and stops sending IPIs, leaving valid target vCPUs without
an interrupt.

Replace the early "goto done" with "continue" so vCPUs outside the
hart_mask range are skipped without aborting the loop.

Reproduced with a minimal userspace VMM driving KVM inside a QEMU
(RISC-V virt) guest: three vCPUs are created with ids 100, 0, 1 (in
creation order) and sbi_send_ipi(hart_mask=bit0, hbase=0) is called
from vcpu_id 1. Before this change the IPI is dropped and the ecall
returns SBI_ERR_INVALID_PARAM; with this change the IPI is delivered
and the ecall returns SBI_SUCCESS.

Fixes: 0611f78f83c9 ("riscv: KVM: Fix SBI IPI error generation")
Cc: stable@vger.kernel.org
Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Xiaofeng Yuan <yuanxiaofeng@eswincomputing.com>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260917122012.2577-1-yuanxiaofeng@eswincomputing.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index b490ed1428a68..df3818fec0bfa 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -64,8 +64,17 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			if (tmp->vcpu_id < hbase)
 				continue;
 			hart_bit = tmp->vcpu_id - hbase;
+			/*
+			 * kvm_for_each_vcpu() walks kvm->vcpus[] by
+			 * vcpu_idx, i.e. the creation order, which has
+			 * nothing to do with the vcpu_id (hart id) space
+			 * that the SBI IPI operates on. vcpu_ids need not
+			 * increase along the iteration, so harts outside
+			 * the hart_mask window must be skipped instead of
+			 * aborting the loop.
+			 */
 			if (hart_bit >= __riscv_xlen)
-				goto done;
+				continue;
 			if (!(hmask & (1UL << hart_bit)))
 				continue;
 		}
@@ -76,7 +85,6 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		kvm_riscv_vcpu_pmu_incr_fw(tmp, SBI_PMU_FW_IPI_RCVD);
 	}
 
-done:
 	if (hbase != -1UL && (hmask ^ sentmask))
 		retdata->err_val = SBI_ERR_INVALID_PARAM;
 
-- 
2.53.0



