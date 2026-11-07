Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062279;
	b=Ey4UpobLd2yMUaC+gBpCP/xo4YJgbj5v1jD2zBUZRzeZcKUPS/6QR/RYH6skT/Lv+VHS
	 jPlfJBLToPK1oPVUE6n8qCUM4fPeYgrsQnuoYrM13X9yt+zvBwF76gaSN0GOuYKp4q5ky
	 XwHfDyBK9fwPtQ0rbNjDU80z3adUlqomQo1RWS/hDUttH2ln/KEr+2HQwRBJpyKYksx/s
	 dyl61//07pbK9kX/JcWTW4fU/Qj6ci03nsWU4dkv7l/BgKnxOUhI1SxQyoaLrBi/jTbQc
	 H2GRvrKNxUYQyf9NrFQSXtvS+lrUUSdALFpHOR+Qbz4EbyISZ9K2Br91kKMkFeVPN2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0GxI2GrjHkzAnsQnt2ZevW11JMFQdRBvShE+qPfqzLo=;
	b=UzRnYHlM8cCbpDfL6DuCp75c1fJ+Qt5IPUEA7HDrD1euh28GzBhlwhmUewO3fgmSiukH
	 z0IUJT+cQt33rLVZxCwTPhislXKuyPnToufgh03YC6ijqwgofApsdHnzWNmbwpP4xSBmx
	 mwORAJRI9tJQiUvp6NAbBKabI1V4SQjGl8vG5SDG3OSMWtGUDbdc09XPriCMR537Yvz4B
	 +tDYqJl75fgxpJo+wk+BHzPBb3Km0FNMX/UOoFUhrDVWk07eWOqVO6e0ILmw8F2JQ4siC
	 jnVtF3Vzif+nVE4XIyg5C9cSWLN0sgI30pvQO/80Hnzq/RS8waP8f1ASTIYLBmPoo/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DcNqlk9f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5C460A3823;
	Sat,  7 Nov 2026 14:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DcNqlk9f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4253F1F0089F;
	Sat,  7 Nov 2026 14:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062279;
	bh=0GxI2GrjHkzAnsQnt2ZevW11JMFQdRBvShE+qPfqzLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcNqlk9fU4zzc3S+mY/o+XbObMfJTfwLaKnhTTQ0X1iFQ1DQ2P2+jLUtKOSFalniD
	 6kcjp4Po8eSzeNRcb5YpeObzbTBzuqZXs1RGiMMNTryG71VfX43WTQ2gOGxS3kNC1C
	 wzXtQ+J6gwRbzXwICe6OpM/hXfcm7IkwGvbA0Pf4=
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
Subject: [PATCH 6.12 1219/1536] RISC-V: KVM: Fix IPI delivery for out-of-order vcpu_id
Date: Sat,  7 Nov 2026 08:53:55 -0500
Message-ID: <20261107135031.992902161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b17fad091babd..0a706d2a73066 100644
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



