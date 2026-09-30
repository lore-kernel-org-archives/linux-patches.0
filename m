Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEC136A37E;
	Wed, 30 Sep 2026 17:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788997; cv=none; b=F7Tvqq+JoU4+RPRHUhzCuEY2WEfD2ncugnynEGVKGo8jbAiUF4zhKNLXRm5zSCntd/y5BRkcNikK19dkjWNbYrSfFgIfltKhFBAtxKkcmM73sfl+hYxNqlCQE2RanI1HUv8tsyFGXUEpORoH2ZrQThjanV67bAI/UlP9oD9OWJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788997; c=relaxed/simple;
	bh=JLhIOTVeW+j2ioNV54LDseHk7Wqb0vYmklT1dSBOa/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ndg2781zHkrDsbCIXav3LDwoR1s+Xjsct9WqANZo33ElL1cI+mYLZLhhbA5i1Jrbg5HPj2AVMdgIxNlT7gFOv5Vx5D85ARx+bFOZlfFLVRmeMlpkcPFL7qiDL4OVMLvM7IIh3I4tjsI1GlAc1jgjsBBmplOghXStLpVLNWlf6HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFEpselO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFEpselO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998801F000FF;
	Wed, 30 Sep 2026 17:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788994;
	bh=PdvYMh6TmRyYWMVr8v0Wp3oiq6IHqFya0/6YPsOQqCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FFEpselOs3WrwHsoTYIMwXcgm5WPvsuAT0nmGTdlJCaH9Yl2+5V0/TfAZ5s69CGoL
	 NNqqRXNt3y8+cXyOvyvPY5PCkp9L13mNSSzZ6pwFvJBXxzJ3WgHcYpu7NbdobvCqnr
	 e4KljjivMDaI+bzpn2iqGaSj0g/moatRoFbKyn4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/877] RISC-V: KVM: Report snapshot write failure to the guest
Date: Wed, 30 Sep 2026 17:20:33 +0200
Message-ID: <20260930152421.633838387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 4073adf4f91a3..468e58f152153 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -642,9 +642,10 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
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



