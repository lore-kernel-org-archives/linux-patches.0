Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3BA762C1;
	Wed, 21 Feb 2024 14:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525182; cv=none; b=qllTZkaGA3bQEqxJ+avXTgxp+Mtu85W8rafkRBIlv6TCDu18wEUt3S2JvK/OVzuJcm9PZoYmtOn5D6l/uJGAIjyXUcCJYW8c+A0rEw5kTEi7Bv+pfuHolM9RxvaAWosI3IqSuUijcC0ZNjS9xjxkjG3WNJCJKEEn0beKMpVBmg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525182; c=relaxed/simple;
	bh=zwgAhRmwiY7PsEQCrmLjIrGSoJ7Gi/3Oi8oxB/MzhPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1lzH4sYWNa6ZP/4MNYzt8rsURrc154RRjd8uz2gH21mj8apUP8YZ+9Wr5IYLPxmRAQohNlyDK+FX0ipQ9+oZiA9U5sXbCIw2I++pgj9ZJlkGLv0lOkes4uDwL2A3QPoaSpScRqzFvQr5RkDW2yAtPJ2OIhEod/fweXHdnqTyMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4Rh5mDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4Rh5mDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE94C43399;
	Wed, 21 Feb 2024 14:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525182;
	bh=zwgAhRmwiY7PsEQCrmLjIrGSoJ7Gi/3Oi8oxB/MzhPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4Rh5mDWcMcE9priHEh2EMpp5BZjInONXeCsGOHeLQitQ6K9mdYXK2boXF/Y3ivTf
	 pN0lrOkU4cTbIgTy0S8i1dof1A4E33Njl2itYmOiAaiOW8QQOB8Ji6jPRt2FNCMtEA
	 TijC6SMJWv25T5oivgrlM7sCVCPH+BCNL7GWw4BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/267] KVM: s390: fix setting of fpc register
Date: Wed, 21 Feb 2024 14:07:05 +0100
Message-ID: <20240221125942.602323841@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit b988b1bb0053c0dcd26187d29ef07566a565cf55 ]

kvm_arch_vcpu_ioctl_set_fpu() allows to set the floating point control
(fpc) register of a guest cpu. The new value is tested for validity by
temporarily loading it into the fpc register.

This may lead to corruption of the fpc register of the host process:
if an interrupt happens while the value is temporarily loaded into the fpc
register, and within interrupt context floating point or vector registers
are used, the current fp/vx registers are saved with save_fpu_regs()
assuming they belong to user space and will be loaded into fp/vx registers
when returning to user space.

test_fp_ctl() restores the original user space / host process fpc register
value, however it will be discarded, when returning to user space.

In result the host process will incorrectly continue to run with the value
that was supposed to be used for a guest cpu.

Fix this by simply removing the test. There is another test right before
the SIE context is entered which will handles invalid values.

This results in a change of behaviour: invalid values will now be accepted
instead of that the ioctl fails with -EINVAL. This seems to be acceptable,
given that this interface is most likely not used anymore, and this is in
addition the same behaviour implemented with the memory mapped interface
(replace invalid values with zero) - see sync_regs() in kvm-s390.c.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b11eb11e2f49..6a1b46e85dac 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3348,10 +3348,6 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	vcpu_load(vcpu);
 
-	if (test_fp_ctl(fpu->fpc)) {
-		ret = -EINVAL;
-		goto out;
-	}
 	vcpu->run->s.regs.fpc = fpu->fpc;
 	if (MACHINE_HAS_VX)
 		convert_fp_to_vx((__vector128 *) vcpu->run->s.regs.vrs,
@@ -3359,7 +3355,6 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	else
 		memcpy(vcpu->run->s.regs.fprs, &fpu->fprs, sizeof(fpu->fprs));
 
-out:
 	vcpu_put(vcpu);
 	return ret;
 }
-- 
2.43.0



