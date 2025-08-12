Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ADC3FE7;
	Tue, 12 Aug 2025 19:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025227; cv=none; b=bmgbmb+INerL76p6wF1EUvWCcyrGzpAlC2O91t38ru9zr3FHxyNB0pUDX7ezxHdYhQbj4toTBRSEZaxzAgyxWW+oeh3K/lhKQ9NOovIi9IZ7RNrtb/U0fGrgrsJkgwoEVYW6AOa6mZuzw9/KLzW3/CODsDiqBQzFA+q1nPt2ahA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025227; c=relaxed/simple;
	bh=efi7lNhH6vUoNjRZk7ZklSN7s1v+HcNEYKGV+KzpK9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4hOi0vF5FfrbvgQEc/OGoXu9UDsT27rFsYaiHqREd1vP6hh5Xy+Y9wQXa5av1dPQ7uZb31Hca5EQXsX2WWvWuLKfJo1oN9KIqLc9BL1vSssaUyDBlVYRvI5H/2rlNaDy8PRKiTpVpQFTDu14omluEo0VS/8zEew85IZH6APkS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SImZSZUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SImZSZUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F85CC4CEF1;
	Tue, 12 Aug 2025 19:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025227;
	bh=efi7lNhH6vUoNjRZk7ZklSN7s1v+HcNEYKGV+KzpK9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SImZSZUXG+0U3GxfgoAEX+qqumfhmI7zEerpCNtF2uT9Ual+banL5QlX1mF0AjWlC
	 Z5yDxw0fW7UT7h1pIUkqCi4C4pMfRTktSnpz+b7tYZZV6N9kVPjlyHkgDQ5HWogr0Y
	 ecQbV8nbuqEOhV1oX5hyknujDHDG77V92u0oI8f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.16 607/627] KVM: arm64: Check for SYSREGS_ON_CPU before accessing the CPU state
Date: Tue, 12 Aug 2025 19:35:02 +0200
Message-ID: <20250812173454.962790147@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit c6e35dff58d348c1a9489e9b3b62b3721e62631d upstream.

Mark Brown reports that since we commit to making exceptions
visible without the vcpu being loaded, the external abort selftest
fails.

Upon investigation, it turns out that the code that makes registers
affected by an exception visible to the guest is completely broken
on VHE, as we don't check whether the system registers are loaded
on the CPU at this point. We managed to get away with this so far,
but that's obviously as bad as it gets,

Add the required checksm and document the absolute need to check
for the SYSREGS_ON_CPU flag before calling into any of the
__vcpu_write_sys_reg_to_cpu()__vcpu_read_sys_reg_from_cpu() helpers.

Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/18535df8-e647-4643-af9a-bb780af03a70@sirena.org.uk
Link: https://lore.kernel.org/r/20250720102229.179114-1-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |    4 ++++
 arch/arm64/kvm/hyp/exception.c    |    6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1149,6 +1149,8 @@ static inline bool __vcpu_read_sys_reg_f
 	 * System registers listed in the switch are not saved on every
 	 * exit from the guest but are only saved on vcpu_put.
 	 *
+	 * SYSREGS_ON_CPU *MUST* be checked before using this helper.
+	 *
 	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
 	 * should never be listed below, because the guest cannot modify its
 	 * own MPIDR_EL1 and MPIDR_EL1 is accessed for VCPU A from VCPU B's
@@ -1200,6 +1202,8 @@ static inline bool __vcpu_write_sys_reg_
 	 * System registers listed in the switch are not restored on every
 	 * entry to the guest but are only restored on vcpu_load.
 	 *
+	 * SYSREGS_ON_CPU *MUST* be checked before using this helper.
+	 *
 	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
 	 * should never be listed below, because the MPIDR should only be set
 	 * once, before running the VCPU, and never changed later.
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -26,7 +26,8 @@ static inline u64 __vcpu_read_sys_reg(co
 
 	if (unlikely(vcpu_has_nv(vcpu)))
 		return vcpu_read_sys_reg(vcpu, reg);
-	else if (__vcpu_read_sys_reg_from_cpu(reg, &val))
+	else if (vcpu_get_flag(vcpu, SYSREGS_ON_CPU) &&
+		 __vcpu_read_sys_reg_from_cpu(reg, &val))
 		return val;
 
 	return __vcpu_sys_reg(vcpu, reg);
@@ -36,7 +37,8 @@ static inline void __vcpu_write_sys_reg(
 {
 	if (unlikely(vcpu_has_nv(vcpu)))
 		vcpu_write_sys_reg(vcpu, val, reg);
-	else if (!__vcpu_write_sys_reg_to_cpu(val, reg))
+	else if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU) ||
+		 !__vcpu_write_sys_reg_to_cpu(val, reg))
 		__vcpu_assign_sys_reg(vcpu, reg, val);
 }
 


