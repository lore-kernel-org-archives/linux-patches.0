Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887C0268C66;
	Tue,  8 Apr 2025 11:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113041; cv=none; b=VYp0R2vOz+n8h/WADRfNLTZXf4zC8dUu3Cbi8z37+n9dwgYPUjX/CnuC2G0eAG2+QrqduWwaFAu2YUM8OWywIbFe6czTvGRkM9lM+RVjYVsgnODQPWJ7ZzlyqvdQVy3nKubMiBCNK6zcz+g/BqolZYq6OwcWihDlNl5/fY0h5RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113041; c=relaxed/simple;
	bh=F/kMBogxKCQE/kWV+R5w6FzMyhzpcVpvp3k96avBRJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrpKCZObZWztqjLZzq8sqVqhLBzBK1cHYmOOnC+wZd+6Utie2nIrhJBOqAn72W4xsM2ouPzOl0S+Rht+v5pPe1nGhmWZ7IG8rGrbYNGo5RnSE/8ihuJHqKabrLJjgj3XUeXLiYP46ykDhs13QIqPx4qo7BfXauB8g9jeDfwYBEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwPxVfaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwPxVfaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1993EC4CEE5;
	Tue,  8 Apr 2025 11:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113041;
	bh=F/kMBogxKCQE/kWV+R5w6FzMyhzpcVpvp3k96avBRJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwPxVfaOJVvQm030i56OV/Lxd+NiE3RiFz+eVb9iLXu+8OQxXM9ZcqPLBHtQNQBAW
	 MVzXhw4jAWJxRafoFnN8hTH8lliFw/2BK5BlTF3Z8mUuNdk0N/rw/dCkfVcK34//8Z
	 hTU1eiw/KszyQHNkjCrC6ArtPmV9im9WbL7dgTqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/268] RISC-V: KVM: Disable the kernel perf counter during configure
Date: Tue,  8 Apr 2025 12:47:04 +0200
Message-ID: <20250408104828.869865155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

From: Atish Patra <atishp@rivosinc.com>

[ Upstream commit bbb622488749478955485765ddff9d56be4a7e4b ]

The perf event should be marked disabled during the creation as
it is not ready to be scheduled until there is SBI PMU start call
or config matching is called with auto start. Otherwise, event add/start
gets called during perf_event_create_kernel_counter function.
It will be enabled and scheduled to run via perf_event_enable during
either the above mentioned scenario.

Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20250303-kvm_pmu_improve-v2-1-41d177e45929@rivosinc.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index cee1b9ca4ec48..e2e2a115afb5c 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -468,6 +468,7 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 		.type = etype,
 		.size = sizeof(struct perf_event_attr),
 		.pinned = true,
+		.disabled = true,
 		/*
 		 * It should never reach here if the platform doesn't support the sscofpmf
 		 * extension as mode filtering won't work without it.
-- 
2.39.5



