Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651131E5B9A;
	Wed, 30 Sep 2026 16:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786911; cv=none; b=eDbNfbSb5hhot94lHpq+OWIxK7cvA4xYdf3C3x8O3QGgW3PD8IIIar8u1792oLx32Jwpl7KcA9FqUR0w4w5dc3iXXTwPMc7kyEQI2/FK/mCotJSaqx6UWopxRtmaOZY/p6NNF8u0YKs1SAfnPqptYeb45J+arTh9flNNxiDuqzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786911; c=relaxed/simple;
	bh=w8eSfT1GiLl71oWkUrk6uq93jch9JACh+Tl0nZLX9lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ax747C4FBirHXJtVCbi1tjQeVzBfEmv6wx/50kJllb/O5VmdQ5jeogOKhNUihQi3VgIT4MXKHTC20EVpZUBzCuuQV4g4jQnQJK6XCfEBTHu/0YmYVFUInC+RmNoOPFNPXZL+aaFVdsz8MqAdi8U04pkb1Xrh99DC/ZxTRizfiE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7QTBJR9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7QTBJR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D651F000FF;
	Wed, 30 Sep 2026 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786910;
	bh=cc0pQ9fnFgR2r3ZYvedNpfrokFsgIqs+xXuhDH4Haqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7QTBJR9WSuBSFDYpehpEDKRVE/eFSDlbHysfUmC1FIhosQ6JX5lTYmILvk7okYLR
	 eII5OKrZzDiNi+TF0nN98Vhqb2hAKdQRbkLsp9XqrM2J1GQK+stpj/1QJB+Xo+8VaQ
	 2nkVkgHx6tlTcvCyLlxzXdm/OPZXJ3Zy1SrD7ZAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 044/457] KVM: arm64: Do not clear VM-wide SVE feature on vCPU init failure
Date: Wed, 30 Sep 2026 17:22:29 +0200
Message-ID: <20260930152346.988654831@linuxfoundation.org>
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
index 095ebfce91b08..73e6ee059eebb 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -451,7 +451,7 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 	unsigned int sve_max_vl;
 	size_t sve_state_size;
 	void *sve_state;
-	int ret = 0;
+	int ret;
 
 	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
 		vcpu_clear_flag(vcpu, VCPU_SVE_FINALIZED);
@@ -462,24 +462,19 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
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



