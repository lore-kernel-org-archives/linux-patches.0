Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BE01F758F;
	Tue, 17 Dec 2024 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455420; cv=none; b=NkaNKvJZwozcOtyfQUvbGpdI273J4Ueus+6dBXdm5jrA0TExG7lCDL5p4ooJVxM+KLH76uRVLgP4LDZDfFiLYvzl6WBI6w0ZPRSzYvclMBbh2Ltn6xZgX8AIXaRPDbB8EkdxZPihlm+yJzFNjQp9qrCbu4xiS933eB2qVylLun8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455420; c=relaxed/simple;
	bh=o5yViNZgxRJrGNTD0U/QjxyEd41CJ58aCFsNkmPqazY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TULqwpInd5gWMzG2Houm+Nq0pXUhlldFWke/W0CDPXm2+WzazWLBelhlD/5TbTVDNNGt5GI5iG7RNOi7CIMmvnigbsEVdqGLyghZh6/r3w4VSuZlU70spN/Ah+NQ/OoOBJ693jUCIc1OIwsVUPmkx128Wmh+eNUVoiDjfgHshaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swxHfi4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swxHfi4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6657AC4CED3;
	Tue, 17 Dec 2024 17:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455417;
	bh=o5yViNZgxRJrGNTD0U/QjxyEd41CJ58aCFsNkmPqazY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swxHfi4zt8PQB6cr42LBuGNUL5RgNxC6/8AqbCuk1E0e2F5hZmKGaHbiFK0ipb323
	 QalLAZHhe4xVCt0geNh8u84uENSrJ30qDNFIqQnc7fp3rDk/owHaz5vTsFUthZ/Fs9
	 bj99Gwo2h3YDR+EKSxNv4qYwi3qS5xG9F0gOB9qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghavendra Rao Ananta <rananta@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 5.4 21/24] KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status
Date: Tue, 17 Dec 2024 18:07:19 +0100
Message-ID: <20241217170519.871417632@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
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
 virt/kvm/arm/pmu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -357,7 +357,6 @@ static u64 kvm_pmu_overflow_status(struc
 
 	if ((__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E)) {
 		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
-		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 		reg &= kvm_pmu_valid_counter_mask(vcpu);
 	}


