Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EC9301EE4;
	Sat, 28 Feb 2026 17:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301401; cv=none; b=Gjo12dQgVj8pQJ/vu1DHHE0IykhyGcTc0/JC05f7Vpg6dDmlF9JCoe4N8MRnXGO8evvsD/LPT8A60jDQjzDWoxZQulC7y1UrqHasn++tCMkw8kLwmZjOq5sF8LSfSBM+6BtM8uRHeBbJHoTJctqes1tNjMdjlkNmXDqW09HGo/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301401; c=relaxed/simple;
	bh=QR45+H+PlYDCm+HpbNLhOxLuXNzrpI9pZ2tdfedIGM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4NpQG3hQRHcqNny6pntYODFJYEUGvXQiZerHMJPutJ+oePREYJhmxzGehfEJCm1ZKghpaqJQwXzBR0xU0Go2BHOvdCPU9bWzfHrCS8bqiE3uNy/frUaFJzn9QzGS5dVtQ6o7q0WFOfsRwgAtw+TXWz5Jek2u2oHLygPoCunKBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngOvnGxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngOvnGxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADB6C19423;
	Sat, 28 Feb 2026 17:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301401;
	bh=QR45+H+PlYDCm+HpbNLhOxLuXNzrpI9pZ2tdfedIGM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngOvnGxCqq5TfrInH5PEHfdYoc3isD5Gi5dgUjzc/PmKvKVbPQXKTCIg0NDhVSQuS
	 BfqON+Zo6CErWvbqnHotB0ijqcHPbTivrbVZk3t2wLemG6Nu9flz/xQXcHpLlDdrQI
	 2VsSLtxSCGco8e3oUgZCg6chgiUbCn2quKrgK3mZohee5yOxONqoeZYktPXc11v2mC
	 /LlM4eN6DDJ95dW7MEcoy8U8AiiPy/2RTgeZzPLAGPZl46jiKJVW6rW2cRF9ou4QCe
	 Gfiwxau07tb1B8t8Q+hKhPXoI7VsCN1o9ehkp5A5ZO7RMlXdtsWk/SXvp1b9VRRKbU
	 EnSBXFYmFYFQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 590/752] KVM: arm64: nv: Return correct RES0 bits for FGT registers
Date: Sat, 28 Feb 2026 12:45:01 -0500
Message-ID: <20260228174750.1542406-590-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

[ Upstream commit 2eb80a2eee18762a33aa770d742d64fe47852c7e ]

We had extended the sysreg masking infrastructure to more general
registers, instead of restricting it to VNCR-backed registers, since
commit a0162020095e ("KVM: arm64: Extend masking facility to arbitrary
registers"). Fix kvm_get_sysreg_res0() to reflect this fact.

Note that we're sure that we only deal with FGT registers in
kvm_get_sysreg_res0(), the

	if (sr < __VNCR_START__)

is actually a never false, which should probably be removed later.

Fixes: 69c19e047dfe ("KVM: arm64: Add TCR2_EL2 to the sysreg arrays")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Link: https://patch.msgid.link/20260121101631.41037-1-zenghui.yu@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 834f13fb1fb7d..2d04fb56746ea 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2428,7 +2428,7 @@ static u64 kvm_get_sysreg_res0(struct kvm *kvm, enum vcpu_sysreg sr)
 
 	masks = kvm->arch.sysreg_masks;
 
-	return masks->mask[sr - __VNCR_START__].res0;
+	return masks->mask[sr - __SANITISED_REG_START__].res0;
 }
 
 static bool check_fgt_bit(struct kvm_vcpu *vcpu, enum vcpu_sysreg sr,
-- 
2.51.0

