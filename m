Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973564FDE56;
	Wed, 30 Sep 2026 16:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786894; cv=none; b=tZvlYomLtgj0PJZz2DEFilLGp3GZ8yOfD4LD7djVFU1ATobOdc2P7+roRD+yMNiKJM3Iapl2Lvw6zjP0gFzAsIy+xra/4Vlv7NHVLQsgDIf+13pE+Ik93T+sSmmKgoGBkyDWZ+TaoCYUxcd00n/LEcjXFjHlRiKab+bNVhZ4/c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786894; c=relaxed/simple;
	bh=mn2aZwsSxg5QkPIrHqBkE7DKJyccoroGGtQz4m/R4L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VD4seiy2QkhPFuY4O0b0RDp8p3jHu8WlQIuMJb4d8biqgJusTpG0r/oJ2GFHEnUNkeEb8OgVI+eV0q0tY+hxpRGuSIOKKuXl2v09GBwvBqVWHX8jeTdjLKLBMnK0WbPaRHtRyduvVJW+7CI19aI17ieZLcsUCMoACjrqo0NRUyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Q4CfW1h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Q4CfW1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCEB1F000FF;
	Wed, 30 Sep 2026 16:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786893;
	bh=P2hHzNFyyYy/IYtmCTSL/hYgzEzgD1MlGc2sZOw7VEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Q4CfW1hkZMwkHumfalJgk+Zx3ZgO3aSPCSitD13MKPYxbwa+QKzij8j/7FDdLyNo
	 rb4wK/ysbnmbu92yK5G6qY5qtuk9tcOKOgstZYpchusyMJwSBcrwsjkCCy9KiR/kwJ
	 FtBtFU1B7dR3fZaKCcT3S++fA0aFF+UjAs+tyBMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 039/457] RISC-V: KVM: Report snapshot write failure to the guest
Date: Wed, 30 Sep 2026 17:22:24 +0200
Message-ID: <20260930152346.878852888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeungJu Cheon <suunj1331@gmail.com>

[ Upstream commit 057dd2639ceae79adced5d8fe52c32d562edcb3a ]

If kvm_vcpu_write_guest() fails while updating the PMU snapshot area
on counter stop, the guest may receive SBI_SUCCESS without the
snapshot being updated, leaving stale data in shared memory.

Return SBI_ERR_FAILURE when the snapshot write fails.

Fixes: c2f41ddbcdd7 ("RISC-V: KVM: Implement SBI PMU Snapshot feature")
Signed-off-by: SeungJu Cheon <suunj1331@gmail.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260825083719.643970-3-suunj1331@gmail.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_pmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 904d266a66c44..a749591a675de 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -727,9 +727,10 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 		}
 	}
 
-	if (shmem_needs_update)
-		kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr, kvpmu->sdata,
-					     sizeof(struct riscv_pmu_snapshot_data));
+	if (shmem_needs_update &&
+	    kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr, kvpmu->sdata,
+				 sizeof(struct riscv_pmu_snapshot_data)))
+		sbiret = SBI_ERR_FAILURE;
 
 out:
 	retdata->err_val = sbiret;
-- 
2.53.0



