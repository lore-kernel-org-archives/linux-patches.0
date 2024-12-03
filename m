Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6931F7540;
	Tue,  3 Dec 2024 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239632; cv=none; b=cbmVtvKBMUi1ioWMOGeb6H9AOUpDI845+teFJjtyviQqb3PCC8Q2BUZ0ANgJXGIFs/eUmwjc4aSoceAtyBppSQztePVA4h76fAMUZ9Pa9rGYHB/OCcjyfUltFTZL3/b+UBRGm9aTjLytQicipc9bF3cDNh94DL8o0OzW67Rv5zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239632; c=relaxed/simple;
	bh=KEqGxzFT5PMoETbsSfyZQc7R7jSIdL2wGhmDkO3glAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvPkdjkS7epc9Qgwwn5NyY3VfN5OT6dUbI7Yyf55GBPJXGkGu4ANR1DtRVO1eFpSk1RzICdhYKXpsMEun10tcgFmLfJyop+DYdPxFRO7fUTEzm5finX80+Nv+HKbIaMI2dYQ185HUBeFtI5EXftsVz8Wa1tYBx+hjM1Ec5mjs3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K41NMrQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K41NMrQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEA5C4CECF;
	Tue,  3 Dec 2024 15:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239631;
	bh=KEqGxzFT5PMoETbsSfyZQc7R7jSIdL2wGhmDkO3glAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K41NMrQyVyK7tc/TkPBpxRm0Jb/ZszhhQxqbeq+TboCzuLletZSCZ7Lc4ChJ6lUp7
	 xocGN4mqgvIqThuqmhvoxyox1gkJQOZ+rMahBdJn1AJmk8WvIaiYOf37viO2yHvlJ4
	 tKp4aB2kQUvcbSUMJCoqEqf4LlX/02OOhUERVzZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghavendra Rao Ananta <rananta@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.11 649/817] KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status
Date: Tue,  3 Dec 2024 15:43:41 +0100
Message-ID: <20241203144021.292149348@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raghavendra Rao Ananta <rananta@google.com>

commit 54bbee190d42166209185d89070c58a343bf514b upstream.

DDI0487K.a D13.3.1 describes the PMU overflow condition, which evaluates
to true if any counter's global enable (PMCR_EL0.E), overflow flag
(PMOVSSET_EL0[n]), and interrupt enable (PMINTENSET_EL1[n]) are all 1.
Of note, this does not require a counter to be enabled
(i.e. PMCNTENSET_EL0[n] = 1) to generate an overflow.

Align kvm_pmu_overflow_status() with the reality of the architecture
and stop using PMCNTENSET_EL0 as part of the overflow condition. The
bug was discovered while running an SBSA PMU test [*], which only sets
PMCR.E, PMOVSSET<0>, PMINTENSET<0>, and expects an overflow interrupt.

Cc: stable@vger.kernel.org
Fixes: 76d883c4e640 ("arm64: KVM: Add access handler for PMOVSSET and PMOVSCLR register")
Link: https://github.com/ARM-software/sbsa-acs/blob/master/test_pool/pmu/operating_system/test_pmu001.c
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
[ oliver: massaged changelog ]
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20241120005230.2335682-2-oliver.upton@linux.dev
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/pmu-emul.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -342,7 +342,6 @@ static u64 kvm_pmu_overflow_status(struc
 
 	if ((kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)) {
 		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
-		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 	}
 


