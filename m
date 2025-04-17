Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9182571BA;
	Thu, 17 Apr 2025 18:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914475; cv=none; b=hFYfbDoXs2AsrFNIlNWgL3TAizgM4FsNw0b8aun4oaOguiuTw7N/GSCpV5MNcxn0Jh6+BpBeBe0cldwVxB5VXnE24soLeZxrULTyRA2XHsMDR1/1Tr23ph32xo3GJf23ENPKN2cNLM52U3nmqs5mRnlX/a6SNxszky4/9XSpdJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914475; c=relaxed/simple;
	bh=QIReCUEVHXFzR3QZ2JIviRSm93SJoLQA661ox/ZltzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNpQbUCpCEqsOFdkNs/Q9HKIxwHcRK9IHWVjdiY3QGcZOoNN1ZDj1mJiUPP+m/lXoyCOOFiXrOi6pRts8pHSvZuJrjb0Ayu5d/CVBZsk+MJ0RgptZOZQrYwkMbuSQ0K9LiHRIfofQInBWM8SJaU/Mc+ILvp6OsPTA98M9YiGNeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZ8rY7bR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZ8rY7bR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E74C4CEEA;
	Thu, 17 Apr 2025 18:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914475;
	bh=QIReCUEVHXFzR3QZ2JIviRSm93SJoLQA661ox/ZltzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZ8rY7bRUTM0tmX5XTr3QueLH2vh7LvSWT9wgnCtAuNC7I9a9t5t3qkPM8NgZ68oI
	 6jB2q0rf/ZDznH29cfiAUm8W/sOuKtI2nS3z1haTABdnvM6v1kkfaydHN+MgmREsVR
	 zE0jzRDuVEMnamO2GnjPW/BRA//Hj2/XmE15Pd6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.13 210/414] KVM: arm64: PMU: Set raw values from user to PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
Date: Thu, 17 Apr 2025 19:49:28 +0200
Message-ID: <20250417175119.886663147@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akihiko Odaki <akihiko.odaki@daynix.com>

commit f2aeb7bbd5745fbcf7f0769e29a184e24924b9a9 upstream.

Commit a45f41d754e0 ("KVM: arm64: Add {get,set}_user for
PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}") changed KVM_SET_ONE_REG to update
the mentioned registers in a way matching with the behavior of guest
register writes. This is a breaking change of a UAPI though the new
semantics looks cleaner and VMMs are not prepared for this.

Firecracker, QEMU, and crosvm perform migration by listing registers
with KVM_GET_REG_LIST, getting their values with KVM_GET_ONE_REG and
setting them with KVM_SET_ONE_REG. This algorithm assumes
KVM_SET_ONE_REG restores the values retrieved with KVM_GET_ONE_REG
without any alteration. However, bit operations added by the earlier
commit do not preserve the values retried with KVM_GET_ONE_REG and
potentially break migration.

Remove the bit operations that alter the values retrieved with
KVM_GET_ONE_REG.

Cc: stable@vger.kernel.org
Fixes: a45f41d754e0 ("KVM: arm64: Add {get,set}_user for PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20250315-pmc-v5-1-ecee87dab216@daynix.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/sys_regs.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1166,26 +1166,9 @@ static bool access_pmu_evtyper(struct kv
 
 static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 val)
 {
-	bool set;
-
-	val &= kvm_pmu_accessible_counter_mask(vcpu);
-
-	switch (r->reg) {
-	case PMOVSSET_EL0:
-		/* CRm[1] being set indicates a SET register, and CLR otherwise */
-		set = r->CRm & 2;
-		break;
-	default:
-		/* Op2[0] being set indicates a SET register, and CLR otherwise */
-		set = r->Op2 & 1;
-		break;
-	}
-
-	if (set)
-		__vcpu_sys_reg(vcpu, r->reg) |= val;
-	else
-		__vcpu_sys_reg(vcpu, r->reg) &= ~val;
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
 
+	__vcpu_sys_reg(vcpu, r->reg) = val & mask;
 	return 0;
 }
 


