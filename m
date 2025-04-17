Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CD62550DD;
	Thu, 17 Apr 2025 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913208; cv=none; b=euq7hZQBj/WXEtTAVcP+27lv+CmPuWrl0eyJ25Jb06vzTeLlmsaRVWFQ9qU3yBgrbKUBEkhAp4X/tswblYs+ZxZZKULWS4Ktg1KcAWnu4lh8SLaehdyI5b9UDmhN8WsyQuNtG2uDrAJUNF4wTuSJl/H0SnU0RuiWJAqMOrLnFfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913208; c=relaxed/simple;
	bh=110j60b3N878W2AGpRpg6RQCb/U1fNJJ9KFyDVH/4hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyynR3VlDvWynNq10ANRGUCB7y2TuC5IWnjP9oMYoBBI9d+dvm5Qb6f7teKllaXmwHAObVqHRVrYhM4+NhHAo+iaVc6/8fg2TJLDNyeawdM35l6iKsvW1MGZ7YKi7H0HI6tmYKs53jksHZiS24Xny78K1F/dJJM0PmxR4tivhWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HotVhY4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HotVhY4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4636C4CEE4;
	Thu, 17 Apr 2025 18:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913207;
	bh=110j60b3N878W2AGpRpg6RQCb/U1fNJJ9KFyDVH/4hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HotVhY4J/koe6uzsUoZL3ZFgxZlRX8weOnveTMF7+NgVZ4yW6mWZ+yZJ9SYgVnEGy
	 AlYypJhIEbpLwxEGgletq2c0LzUGN+7rgkMgAkJ4ByzDW8nJIkaLG/swArFkXYqZgV
	 Ml05V6SPqoQIkkrwYjpQr9CnShZ44AMsFiSKowz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.14 232/449] KVM: arm64: PMU: Set raw values from user to PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
Date: Thu, 17 Apr 2025 19:48:40 +0200
Message-ID: <20250417175127.334751220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1051,26 +1051,9 @@ static bool access_pmu_evtyper(struct kv
 
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
 


