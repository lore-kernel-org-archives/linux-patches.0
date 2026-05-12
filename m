Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE4F36C5A1;
	Tue, 12 May 2026 18:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609661; cv=none; b=gCOxpH55XxbSlWkWQlfo6trLN26h2E6Tef54B/5hUXKMPsrOn6XSBEzhPFCZ7I9bdJegZAlrSNtQRcut03JudPlNRf3koKz70OKYsQV42uR3bApJ1fmDg087T6Kt1WPz6xXJmHDkgR8dPwYritWjY3P1vIvEnh4plxtsHak+j7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609661; c=relaxed/simple;
	bh=19SpEmfWLHt0eMtdknSRlLQwQL2Qft35cSDYs+9GC6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erCcYpHMhHQsVxvkme1Sb+GeuUmyGUqJPkYdS4nrhRtxsxIfZq59YgYWathhjQgM/aDesZqvxZnLyytDpUZEdNMl4jSmKyO7B3ImSQqZFvUuWvtI/4/DzlQW8sjGE5hNF80Y3hDQ6xWQWHo/uClSydHoSzyhqUdW25nDQuVLZec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqnkZdp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqnkZdp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28142C2BCF5;
	Tue, 12 May 2026 18:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609661;
	bh=19SpEmfWLHt0eMtdknSRlLQwQL2Qft35cSDYs+9GC6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqnkZdp9lWjeqk9zJyhjUaKmnT4455XKgMY3CS+OEf86r5wQyRvyE1L7YU62wlfFv
	 SMwa3CuS5/PJgxwpappOLRZlj0m3p7QghyoaoxqK/mgvt32UdLDji8+fIM7jMdrnxS
	 3NT7DHFjWcNafOJ2De4JludOVO8tBkeRk/ci722s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.0 281/307] KVM: arm64: Fix FEAT_SPE_FnE to use PMSIDR_EL1.FnE, not PMSVer
Date: Tue, 12 May 2026 19:41:16 +0200
Message-ID: <20260512173946.058169151@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <tabba@google.com>

commit 08d715338287a1affb4c7ad5733decef4558a5c8 upstream.

FEAT_SPE_FnE is architecturally detected via PMSIDR_EL1.FnE [6], not
ID_AA64DFR0_EL1.PMSVer. The FEAT_X macro form (register, field, value)
cannot encode a PMSIDR_EL1-based feature, so FEAT_SPE_FnE was defined
identically to FEAT_SPEv1p2 (ID_AA64DFR0_EL1, PMSVer, V1P2), producing
a duplicate that used PMSVer >= V1P2 as a proxy.

Replace the macro with feat_spe_fne(), following the same pattern as
the sibling feat_spe_fds(): guard on FEAT_SPEv1p2 and read
PMSIDR_EL1.FnE [6] directly. Wire the two NEEDS_FEAT consumers to use
the new function.

Remove the now-unused FEAT_SPE_FnE macro.

Fixes: 63d423a7635b ("KVM: arm64: Switch to table-driven FGU configuration")
Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260424084908.370776-4-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/config.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -131,7 +131,6 @@ struct reg_feat_map_desc {
 	}
 
 #define FEAT_SPE		ID_AA64DFR0_EL1, PMSVer, IMP
-#define FEAT_SPE_FnE		ID_AA64DFR0_EL1, PMSVer, V1P2
 #define FEAT_BRBE		ID_AA64DFR0_EL1, BRBE, IMP
 #define FEAT_TRC_SR		ID_AA64DFR0_EL1, TraceVer, IMP
 #define FEAT_PMUv3		ID_AA64DFR0_EL1, PMUVer, IMP
@@ -301,6 +300,16 @@ static bool feat_spe_fds(struct kvm *kvm
 		(read_sysreg_s(SYS_PMSIDR_EL1) & PMSIDR_EL1_FDS));
 }
 
+static bool feat_spe_fne(struct kvm *kvm)
+{
+	/*
+	 * Revisit this if KVM ever supports SPE -- this really should
+	 * look at the guest's view of PMSIDR_EL1.
+	 */
+	return (kvm_has_feat(kvm, FEAT_SPEv1p2) &&
+		(read_sysreg_s(SYS_PMSIDR_EL1) & PMSIDR_EL1_FnE));
+}
+
 static bool feat_trbe_mpam(struct kvm *kvm)
 {
 	/*
@@ -536,7 +545,7 @@ static const struct reg_bits_to_feat_map
 		   HDFGRTR_EL2_PMBPTR_EL1	|
 		   HDFGRTR_EL2_PMBLIMITR_EL1,
 		   FEAT_SPE),
-	NEEDS_FEAT(HDFGRTR_EL2_nPMSNEVFR_EL1, FEAT_SPE_FnE),
+	NEEDS_FEAT(HDFGRTR_EL2_nPMSNEVFR_EL1, feat_spe_fne),
 	NEEDS_FEAT(HDFGRTR_EL2_nBRBDATA		|
 		   HDFGRTR_EL2_nBRBCTL		|
 		   HDFGRTR_EL2_nBRBIDR,
@@ -604,7 +613,7 @@ static const struct reg_bits_to_feat_map
 		   HDFGWTR_EL2_PMBPTR_EL1	|
 		   HDFGWTR_EL2_PMBLIMITR_EL1,
 		   FEAT_SPE),
-	NEEDS_FEAT(HDFGWTR_EL2_nPMSNEVFR_EL1, FEAT_SPE_FnE),
+	NEEDS_FEAT(HDFGWTR_EL2_nPMSNEVFR_EL1, feat_spe_fne),
 	NEEDS_FEAT(HDFGWTR_EL2_nBRBDATA		|
 		   HDFGWTR_EL2_nBRBCTL,
 		   FEAT_BRBE),


