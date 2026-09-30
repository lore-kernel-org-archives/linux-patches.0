Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127FB51B178;
	Wed, 30 Sep 2026 18:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792907; cv=none; b=tc1IRKcBPJnIEyme2MK+9M+8IUISKBqnLNBhHpc/3zcNlEdCQc2/8uLOVB4tKU2UwCBthlWXdbAGL0ALc0Vp32Bju3AOvpITiO/wewPzuPv8cuxTuZQJF61rkTil9jmcmXyLvlzBmcPegxp87VAmzZKLyu9bY/9nGQZk8svaMgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792907; c=relaxed/simple;
	bh=Hq4hOSeu3Ycs/qI4KhuVYrp5TD1EMQ/BZE1IJWfrp0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKlgkBb1ggxb3Y5uEHnt9DEFOenVlK6E293lGgwehDH+ODb3SjSX7hK/cmV8N2y88pByb/xInwgFE667gNuDStWP8hNF7HoWE9zSKrZX8mwEOmNBBFyVLIqbpm7IgM6m8V8iJYBR+kSvr/dhd3T1rtLnt+Vmm6vR5XIiLzY/1ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZy/RDIg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZy/RDIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215A01F000FF;
	Wed, 30 Sep 2026 18:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792905;
	bh=hNfDxm9fRu4qfGc3/lS4x3FVzW04l7RajlKNJ5M4Lt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZy/RDIgqIJo3Nvh1Of/2Xt8YEacSLtKBe27vmSPeIyTWPSTNIuXsFpXVO7JQYFvB
	 gL8Ly8xjsN1nvLZ7zCqwUNMExm0Vr+mhC42IC51Zh4f5GJrpYg/8OUJbJeKIfY9reE
	 AR6mPwbo/EDpVBxEvZj1KJIvGF54nCxVWS7oy0dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/395] RISC-V: KVM: Report snapshot write failure to the guest
Date: Wed, 30 Sep 2026 17:24:52 +0200
Message-ID: <20260930152341.272536008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f3a8fd52d13a5..a32a12df726da 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -700,9 +700,10 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
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



