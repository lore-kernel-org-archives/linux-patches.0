Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AB61A619B;
	Tue, 30 Jul 2024 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357460; cv=none; b=ohSe1hv2oLazFgEFD3n/16XYZaw9eQ5/3Sfvn6ptwbEU9GddlLjoce422df5UvJyayqYZPeje/TIVqLgnjCfw9a8FnwMKdL/BfJDsU4igc1JZO2A1GaE2mrX3wVUZdSBJqLUlI+wIhBYKYgGwfHyfTzLK+gBOW22q6x9ojTYhuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357460; c=relaxed/simple;
	bh=0nMfxBHt9qclRKl97+ju7Z/KVMIcZ+CBjZXrQ68mHy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3YTQ/+br+QbhPbHaAJw/27UeARLrlgJNMRy8N81X+PSQsLoaXtuii2P+DYYdvCaaEzP+70ydgjm/8b7o2EsbtSQY++4FBVfgOy7rzokPFV6eBCg0Vvuh+JYHWvvZiLlZ31KvnIxaooS7cwLs0MFPdVmNgNbuCin49oom9g6mos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihQQIvsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihQQIvsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F7FC32782;
	Tue, 30 Jul 2024 16:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357459;
	bh=0nMfxBHt9qclRKl97+ju7Z/KVMIcZ+CBjZXrQ68mHy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihQQIvsMTH2BYTANpU39O5+5AjhbtDkCq5iMyuRef1+/jM4aAWoYx4nZrLQ0oKctr
	 IcWJDTmSgVZg6jwNTm9QL+fs6zBhzDLmCX7G3kYCq/p6fkGdCFivfPLDTwM9uNMLJG
	 zEs/27lQJUSjtOATFTx1NmYeJ88HEOG6oOxK7DfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/568] KVM: PPC: Book3S HV: Fix the set_one_reg for MMCR3
Date: Tue, 30 Jul 2024 17:46:04 +0200
Message-ID: <20240730151649.923093576@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

[ Upstream commit f9ca6a10be20479d526f27316cc32cfd1785ed39 ]

The kvmppc_set_one_reg_hv() wrongly get() the value
instead of set() for MMCR3. Fix the same.

Fixes: 5752fe0b811b ("KVM: PPC: Book3S HV: Save/restore new PMU registers")
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/171759276847.1480.16387950124201117847.stgit@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 0429488ba170d..1e668e238a288 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2484,7 +2484,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		vcpu->arch.mmcrs = set_reg_val(id, *val);
 		break;
 	case KVM_REG_PPC_MMCR3:
-		*val = get_reg_val(id, vcpu->arch.mmcr[3]);
+		kvmppc_set_mmcr_hv(vcpu, 3, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_PMC1 ... KVM_REG_PPC_PMC8:
 		i = id - KVM_REG_PPC_PMC1;
-- 
2.43.0



