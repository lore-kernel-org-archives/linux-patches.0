Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BB23AE5C
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2241EC4339B;
	Wed,  7 Jun 2023 20:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169934;
	bh=egqMW5JWLZ9ExfwvPYLIZNZRm+NkVGcYZXJ0MT2kE64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeU/nMo5vfsBc+soE0UFVrhNHXM9l9haIKrzFvbNa2ckN1ej5pHaLo6bQUV5O94bk
	 QjNa6j+WFpM6/HfKV2Vof48CYjrt61DvrbFn5nEaegrngYOW34B1mn3E2z9EesxQnF
	 E+h/FFCPEEeyS/KA+f3ixf2cE8JkZpAQ/MwE1LZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH 6.3 270/286] KVM: arm64: Populate fault info for watchpoint
Date: Wed,  7 Jun 2023 22:16:09 +0200
Message-ID: <20230607200932.120600515@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akihiko Odaki <akihiko.odaki@daynix.com>

commit 811154e234db72f0a11557a84ba9640f8b3bc823 upstream.

When handling ESR_ELx_EC_WATCHPT_LOW, far_el2 member of struct
kvm_vcpu_fault_info will be copied to far member of struct
kvm_debug_exit_arch and exposed to the userspace. The userspace will
see stale values from older faults if the fault info does not get
populated.

Fixes: 8fb2046180a0 ("KVM: arm64: Move early handlers to per-EC handlers")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230530024651.10014-1-akihiko.odaki@daynix.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |    8 ++++++--
 arch/arm64/kvm/hyp/nvhe/switch.c        |    2 ++
 arch/arm64/kvm/hyp/vhe/switch.c         |    1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -351,17 +351,21 @@ static bool kvm_hyp_handle_cp15_32(struc
 	return false;
 }
 
-static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
+static bool kvm_hyp_handle_memory_fault(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (!__populate_fault_info(vcpu))
 		return true;
 
 	return false;
 }
+static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
+	__alias(kvm_hyp_handle_memory_fault);
+static bool kvm_hyp_handle_watchpt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
+	__alias(kvm_hyp_handle_memory_fault);
 
 static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	if (!__populate_fault_info(vcpu))
+	if (kvm_hyp_handle_memory_fault(vcpu, exit_code))
 		return true;
 
 	if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -186,6 +186,7 @@ static const exit_handler_fn hyp_exit_ha
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
@@ -196,6 +197,7 @@ static const exit_handler_fn pvm_exit_ha
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -110,6 +110,7 @@ static const exit_handler_fn hyp_exit_ha
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 


