Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A366F7BAE4;
	Mon,  8 Apr 2024 13:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582623; cv=none; b=XhR+OqqzrzZHcInwWIXuYxjxL9zEaPTChQ+Of8vFt48t3nk8pjnCK7Vo6cm8kCchSTC0p3dZ5j1Qw77BHfsBU5wsuoPTi2mYo9pssR5/n0R6dssoQ0X9ZNl9+X6I9PnSm1voMOz3ld/e1IO4EdGMbz5gCViRlShYaNNZhOMsfUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582623; c=relaxed/simple;
	bh=R1SgYRTmZXosVK482rCcirfdkzY6KilmQgQDSPBEKj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuZjniFzV5JdGSgC+9WJH0vCF8NJ8L6bF/hIiNwroXZdj90OOd+DvQNHX9yMAbaMFvAdNBH8vjoSj30YMTTJMPfu0gxflRPSscSgmIz4fNoTvCsTE/VNvIXXIpgqJliPk+U8C3mXahJsYiJkBG/nYlxc1b3KsS8Ad7T4Ph6SOZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5Pa59Aw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5Pa59Aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B12C433C7;
	Mon,  8 Apr 2024 13:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582623;
	bh=R1SgYRTmZXosVK482rCcirfdkzY6KilmQgQDSPBEKj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5Pa59Awzin51+Tg114xi28aTv9AsdziRQr/mLA2t4nyiZ1dVOs85Q/mNV4fOcJhz
	 +FUKxX17pbn9/JIOVWLJTW9PH+KdcWpJ9xUvP4pgC5kbcBOqYcEFrlpNCDDBzowlnk
	 W7ocQPNwwQnB2WkTgO0tzC4HCJK7emwDnMB8rBZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 5.15 160/690] KVM/x86: Export RFDS_NO and RFDS_CLEAR to guests
Date: Mon,  8 Apr 2024 14:50:26 +0200
Message-ID: <20240408125405.337123299@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 2a0180129d726a4b953232175857d442651b55a0 upstream.

Mitigation for RFDS requires RFDS_CLEAR capability which is enumerated
by MSR_IA32_ARCH_CAPABILITIES bit 27. If the host has it set, export it
to guests so that they can deploy the mitigation.

RFDS_NO indicates that the system is not vulnerable to RFDS, export it
to guests so that they don't deploy the mitigation unnecessarily. When
the host is not affected by X86_BUG_RFDS, but has RFDS_NO=0, synthesize
RFDS_NO to the guest.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1498,7 +1498,8 @@ static unsigned int num_msr_based_featur
 	 ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
 	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
 	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
-	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO | ARCH_CAP_GDS_NO)
+	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO | ARCH_CAP_GDS_NO | \
+	 ARCH_CAP_RFDS_NO | ARCH_CAP_RFDS_CLEAR)
 
 static u64 kvm_get_arch_capabilities(void)
 {
@@ -1535,6 +1536,8 @@ static u64 kvm_get_arch_capabilities(voi
 		data |= ARCH_CAP_SSB_NO;
 	if (!boot_cpu_has_bug(X86_BUG_MDS))
 		data |= ARCH_CAP_MDS_NO;
+	if (!boot_cpu_has_bug(X86_BUG_RFDS))
+		data |= ARCH_CAP_RFDS_NO;
 
 	if (!boot_cpu_has(X86_FEATURE_RTM)) {
 		/*


