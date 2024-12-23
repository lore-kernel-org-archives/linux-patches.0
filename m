Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D92812D1F1;
	Mon, 23 Dec 2024 16:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969833; cv=none; b=dqklNZ/Pi3YHtUJ8qXWX/xRiGDapUugV5uuimokNUm8xZFrG/ux1nfKc4CyD1Tquu9CD9zw4ho/ccun5CxnPvyJQqJivSVCjmoMXrkF9X2aISDyxRmSAX5tIQRhszenF505X6jv8a+hqESwzr3asvPjMEPuD8+Po6cHHZI8+G5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969833; c=relaxed/simple;
	bh=apeAc3CvGqqqCct7uG+Tui3jlV1ueaNZ779EQcIgsuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/SvCzsz9+hPHKUrYpiv2s7Pfg/ymt+pdxvUlAU0ODSh+v6GykwUcNfwUn32H3o0xj+VNlSvINTG4nxJLOsVHRDn1WCYfhr0h43CkOluGcb1iPQOgWWHgUB5joO5ev95p1ORDb+Y3En16EJ37idtRPpFFV3Fzao4O4LVbWBatdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S28rKmmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S28rKmmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14B8C4CED3;
	Mon, 23 Dec 2024 16:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969833;
	bh=apeAc3CvGqqqCct7uG+Tui3jlV1ueaNZ779EQcIgsuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S28rKmmn3rti2QqI1WOFobwxGROL5BMEcnQtZzMU9cNnWfBxDxIb9o0QHcfgGM6/L
	 XGSwRUHyRNiqQ9x1d+r16LLuYoVtybDFkQTlqaSO5Qlpp9jRVOlB4cYqMFDgyBIw5l
	 dOK5EcoUwEyRhNk+tvBuDHF9sc9bea20fsYyucUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.12 067/160] KVM: arm64: Do not allow ID_AA64MMFR0_EL1.ASIDbits to be overridden
Date: Mon, 23 Dec 2024 16:57:58 +0100
Message-ID: <20241223155411.267211510@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 03c7527e97f73081633d773f9f8c2373f9854b25 upstream.

Catalin reports that a hypervisor lying to a guest about the size
of the ASID field may result in unexpected issues:

- if the underlying HW does only supports 8 bit ASIDs, the ASID
  field in a TLBI VAE1* operation is only 8 bits, and the HW will
  ignore the other 8 bits

- if on the contrary the HW is 16 bit capable, the ASID field
  in the same TLBI operation is always 16 bits, irrespective of
  the value of TCR_ELx.AS.

This could lead to missed invalidations if the guest was lead to
assume that the HW had 8 bit ASIDs while they really are 16 bit wide.

In order to avoid any potential disaster that would be hard to debug,
prenent the migration between a host with 8 bit ASIDs to one with
wider ASIDs (the converse was obviously always forbidden). This is
also consistent with what we already do for VMIDs.

If it becomes absolutely mandatory to support such a migration path
in the future, we will have to trap and emulate all TLBIs, something
that nobody should look forward to.

Fixes: d5a32b60dc18 ("KVM: arm64: Allow userspace to change ID_AA64MMFR{0-2}_EL1")
Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20241203190236.505759-1-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/sys_regs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2503,7 +2503,8 @@ static const struct sys_reg_desc sys_reg
 	ID_WRITABLE(ID_AA64MMFR0_EL1, ~(ID_AA64MMFR0_EL1_RES0 |
 					ID_AA64MMFR0_EL1_TGRAN4_2 |
 					ID_AA64MMFR0_EL1_TGRAN64_2 |
-					ID_AA64MMFR0_EL1_TGRAN16_2)),
+					ID_AA64MMFR0_EL1_TGRAN16_2 |
+					ID_AA64MMFR0_EL1_ASIDBITS)),
 	ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
 					ID_AA64MMFR1_EL1_HCX |
 					ID_AA64MMFR1_EL1_TWED |


