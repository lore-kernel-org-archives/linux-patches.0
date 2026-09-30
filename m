Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457D151DE18;
	Wed, 30 Sep 2026 18:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792943; cv=none; b=L3Tu8qEhcqxaSwpDC+uxu9PfKmc6zLxHmExuiexNwq9lFCsDggVNiVWDSkiC4z6MuLvScRoOTF3VZmh5hrv/1KeCUY4AWDvzk9rzZJ9BaGajw9nmxViTK0ECHmlN4ntnEnILwPEUvO1/2nrYIJjZi7bnLo4wYiR9Tx3lSnekdo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792943; c=relaxed/simple;
	bh=ou1HNmfzYvSsuJ2H7l+PmizHdsK9+BqU9AejWct9w58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3Z/rf0ja6tEMOY/kOep2WLrCNoXni11dI2mYqeQl0YsxZUJz8DXmPF7snwKzbzqE0MncvTXtCyEybWwdfhytTqf5f1iQszLiy856fJLBtxhaDCi1K63vA324AAEb9Q1EvsgAt2qu0LpsWw6th/SgG86s4gpPSlmSLOHNWwCVdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpDiq/af; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpDiq/af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3901F00898;
	Wed, 30 Sep 2026 18:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792942;
	bh=lMXZsCm1UYO3afyoTCqxhoi68i/zv+3YEIEYpXmHTCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpDiq/af3glsa24sON/Pwvh3JP2zOQRlXXcBc7JQpQJ/+Kr4ZzSFvktqek+Ywyf7f
	 BObhc3zeroGHa/3oGGXLGRRfVwbHWK0pxqi+r27Aq0vhbCgnpLk2yfWGxGqhJvQNio
	 tYAWqH7LwBoftaeYYyW/ZGK28IbLiNSmtv3h5pc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/395] KVM: arm64: Do not clear VM-wide SVE feature on vCPU init failure
Date: Wed, 30 Sep 2026 17:24:57 +0200
Message-ID: <20260930152341.384144221@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit a1b3c788ad31837e348075e93dbba3f447492776 ]

pkvm_vcpu_init_sve() clears KVM_ARM_VCPU_SVE in kvm->arch.vcpu_features
when it fails, but vcpu_has_sve() tests KVM_ARCH_FLAG_GUEST_HAS_SVE,
which is left set. Later vCPUs on that VM then skip the SVE setup and
register with a NULL sve_state, which the guest's first FP access hands
to sve_load_state().

Return the error without touching vcpu_features.

Fixes: 5db1bef93342 ("KVM: arm64: Track SVE state in the hypervisor vcpu structure")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260825085948.1674721-3-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index c33bd7d376c66..b3ea49f121870 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -441,7 +441,7 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 	unsigned int sve_max_vl;
 	size_t sve_state_size;
 	void *sve_state;
-	int ret = 0;
+	int ret;
 
 	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
 		vcpu_clear_flag(vcpu, VCPU_SVE_FINALIZED);
@@ -452,24 +452,19 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 	sve_max_vl = min(READ_ONCE(host_vcpu->arch.sve_max_vl), kvm_host_sve_max_vl);
 	sve_state = kern_hyp_va(READ_ONCE(host_vcpu->arch.sve_state));
 
-	if (!sve_vl_valid(sve_max_vl) || !sve_state) {
-		ret = -EINVAL;
-		goto err;
-	}
+	if (!sve_vl_valid(sve_max_vl) || !sve_state)
+		return -EINVAL;
 
 	sve_state_size = sve_state_size_from_vl(sve_max_vl);
 
 	ret = hyp_pin_shared_mem(sve_state, sve_state + sve_state_size);
 	if (ret)
-		goto err;
+		return ret;
 
 	vcpu->arch.sve_state = sve_state;
 	vcpu->arch.sve_max_vl = sve_max_vl;
 
 	return 0;
-err:
-	clear_bit(KVM_ARM_VCPU_SVE, vcpu->kvm->arch.vcpu_features);
-	return ret;
 }
 
 static int vm_copy_id_regs(struct pkvm_hyp_vcpu *hyp_vcpu)
-- 
2.53.0



