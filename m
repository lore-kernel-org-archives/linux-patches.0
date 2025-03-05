Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD6F1A83E4;
	Wed,  5 Mar 2025 18:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197668; cv=none; b=n7I3FD5ROg53Pmz4tJGi/t47kF7jtked6xWz9m1cB3ZkqvBusM4yGthplmxjRw2n71dYCUP4u3wGG8PY67yxfdywWd/MTaTPzJNXPdYNmvwIC5+7TDOF4b/rmOdmUDdAhvU0j1Eo8e8NuNYN4V0VgHnfvEwOQyCkvPIsRwquW+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197668; c=relaxed/simple;
	bh=A1cda03CUGpZelKw0BNKSddqbJl1nhqnSay0EMIHR5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1zBXkkemliuNDFtgdUFav8Dug4JCO9HyGSb8q0VjlOQzSD4qrU7cMP+I8iKHCmIJhZ9dYbF5GwIYJt/y0Cy51NRVfEIjoiypJXev8YOSeYUZoZgL1G7ceIE+kKLRTnGy88mRWZmX9N2514CCZBFcXlDlBlLDEk3iAJ+Wmn3Llc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L48F4LiW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L48F4LiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEB0C4CED1;
	Wed,  5 Mar 2025 18:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197667;
	bh=A1cda03CUGpZelKw0BNKSddqbJl1nhqnSay0EMIHR5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L48F4LiWA63/JfsSPEgbJqcXBAbFYZHEoxf1jq8jduMcBtcQFn0ND9r9nBcp0HL+E
	 RhNhEXReMUNcl9NuvIWapZgjDF+Dr70WCTy/1dqDjMzze8C1wzu6V2IXIHqeqMVp7i
	 jGrlADd/7LXhjTeMTnsfyI/VDdqJTJIri1LoUglo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/142] riscv: KVM: Fix hart suspend status check
Date: Wed,  5 Mar 2025 18:47:57 +0100
Message-ID: <20250305174502.669067582@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit c7db342e3b4744688be1e27e31254c1d31a35274 ]

"Not stopped" means started or suspended so we need to check for
a single state in order to have a chance to check for each state.
Also, we need to use target_vcpu when checking for the suspend
state.

Fixes: 763c8bed8c05 ("RISC-V: KVM: Implement SBI HSM suspend call")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20250217084506.18763-8-ajones@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi_hsm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 827d946ab8714..7e349b4ee926c 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -76,12 +76,12 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
 	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
 	if (!target_vcpu)
 		return SBI_ERR_INVALID_PARAM;
-	if (!kvm_riscv_vcpu_stopped(target_vcpu))
-		return SBI_HSM_STATE_STARTED;
-	else if (vcpu->stat.generic.blocking)
+	if (kvm_riscv_vcpu_stopped(target_vcpu))
+		return SBI_HSM_STATE_STOPPED;
+	else if (target_vcpu->stat.generic.blocking)
 		return SBI_HSM_STATE_SUSPENDED;
 	else
-		return SBI_HSM_STATE_STOPPED;
+		return SBI_HSM_STATE_STARTED;
 }
 
 static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
-- 
2.39.5



