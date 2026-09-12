Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611593750D6;
	Sat, 12 Sep 2026 09:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205838; cv=none; b=XYCSQo83LeB2Lq8yABmbTAc93xHu6AqkHh/VUub2WG70i83D8dcFv+ZyOBF9QqS++ZQYKGZlBQbO2stShGdV7i6aUa5cwE/VTStH98nWbyBcjgIczmPIE+9BXPCuTZwmhrY8oITN0kHJdScLUnVM3Jmgy8Ei44MSz3Qnw/gW+7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205838; c=relaxed/simple;
	bh=u+z0WwHTVOwB/+JaeMFSB92zsUxQFZaO4FE+lBpHmdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1KJn8vxkjycvNBTcJAuKU+HTzi9prLAJyGyovx+2BnEa/+oItyqAw4hYiXhAnG4HPhLOneA791N9lN09y/bSQTGzHtCynOsKy81IGoXTwr48fl8NBVgkp5WCxQByPP9TDps3RxaioRF8YRQ4ekPWvyblLvhN1RnqhMBXbhoogI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3qXnJ36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3qXnJ36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B311F000FF;
	Sat, 12 Sep 2026 09:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205837;
	bh=yGSJmxlIG9ojhHdLMyqcl7dVau9OISb7HelQg7kSz9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E3qXnJ36PXWROEU4eodKRobpUILsvBwa5bF1ukXQaQr/mNIZsM7Rz7LPEix1/YL1f
	 Lzo4/raYsP8L2WsUdsEHUgI0StjOSNfkXfivCchDBtu/ig90neJzBRdk9S16+dp2A6
	 xb30aaDWHnjWh55JvQ8lDVuZniFgBREoKxPnW6OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0082/1518] KVM: arm64: nv: Fully update VNCR fixmap state in kvm_translate_vncr()
Date: Sat, 12 Sep 2026 08:37:31 +0200
Message-ID: <20260912065625.313296397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Oliver Upton <oupton@kernel.org>

[ Upstream commit 5949004d7032767e8fde1e8c986a33f241b2a192 ]

kvm_translate_vncr() first invalidates the pseudo-TLB entry and
corresponding fixmap in anticipation of installing a new translation.

While the fixmap invalidation does clear the mapping from host stage-1,
it does not clear the L1_VNCR_MAPPED flag. Depending on the state of the
VNCR TLB at vcpu_put(), this could potentially precipitate a BUG_ON() if
vt->cpu is reset.

Share a helper with kvm_vcpu_put_hw_mmu(), ensuring that KVM's view of
the VNCR fixmap is in sync with the state of the VNCR TLB. Give it a
slightly verbose name to make it obvious that it is meant to be used
local to a CPU, unlike other VNCR TLB maintenance.

Fixes: 069a05e535496 ("KVM: arm64: nv: Handle VNCR_EL2-triggered faults")
Signed-off-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260602235450.103057-3-oupton@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Stable-dep-of: 38640bc32be3 ("KVM: arm64: Handle VNCR TLB invalidation race with vcpu_put() VNCR unmapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/nested.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -771,18 +771,24 @@ void kvm_vcpu_load_hw_mmu(struct kvm_vcp
 	}
 }
 
+static void this_cpu_reset_vncr_fixmap(struct kvm_vcpu *vcpu)
+{
+	if (!host_data_test_flag(L1_VNCR_MAPPED))
+		return;
+
+	BUG_ON(vcpu->arch.vncr_tlb->cpu != smp_processor_id());
+	BUG_ON(is_hyp_ctxt(vcpu));
+
+	clear_fixmap(vncr_fixmap(vcpu->arch.vncr_tlb->cpu));
+	vcpu->arch.vncr_tlb->cpu = -1;
+	host_data_clear_flag(L1_VNCR_MAPPED);
+	atomic_dec(&vcpu->kvm->arch.vncr_map_count);
+}
+
 void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
 {
 	/* Unconditionally drop the VNCR mapping if we have one */
-	if (host_data_test_flag(L1_VNCR_MAPPED)) {
-		BUG_ON(vcpu->arch.vncr_tlb->cpu != smp_processor_id());
-		BUG_ON(is_hyp_ctxt(vcpu));
-
-		clear_fixmap(vncr_fixmap(vcpu->arch.vncr_tlb->cpu));
-		vcpu->arch.vncr_tlb->cpu = -1;
-		host_data_clear_flag(L1_VNCR_MAPPED);
-		atomic_dec(&vcpu->kvm->arch.vncr_map_count);
-	}
+	this_cpu_reset_vncr_fixmap(vcpu);
 
 	/*
 	 * Keep a reference on the associated stage-2 MMU if the vCPU is
@@ -1244,7 +1250,8 @@ static int kvm_translate_vncr(struct kvm
 	 * We also prepare the next walk wilst we're at it.
 	 */
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
-		invalidate_vncr(vt);
+		this_cpu_reset_vncr_fixmap(vcpu);
+		vt->valid = false;
 
 		vt->wi = (struct s1_walk_info) {
 			.regime	= TR_EL20,


