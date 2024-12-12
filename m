Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6FF228C8D;
	Thu, 12 Dec 2024 16:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020075; cv=none; b=kEeYcHbjSdzKBEUKeycsppfKotQAH0u6hqSy6s9TpB0tnqwZy32lX0ZPcII19zLjtYj2Nh6jXqHD7PzNA759jBrp8HmacWqoIjdj5TTCsImulCLZPBj/y7CZLE0YwE1yfcajNTkSIW4XlwnemFmDuhYKn3tPyXo+yw+AhKs6rds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020075; c=relaxed/simple;
	bh=q+x1aDQMZ2bNv1tqaKzneIrhFs6FFfjXX1Q/D3FFuM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rp6W2+Ix9VSjKrdGVWxep1acLYZn5E2B3g405vWVLF0zXeEDVgxF4kEwiROXd4AdSiXB6YEE8EyiT7khLBzRvFsJs4QkoyDz+aRdEOgr1zObtwcF1CtTeEin3pMX+zipOs6U/D2ZKCMb3exjYsz6ikNRKwqv/QFlFqjclafZgHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQO4wVQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQO4wVQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80605C4CECE;
	Thu, 12 Dec 2024 16:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020075;
	bh=q+x1aDQMZ2bNv1tqaKzneIrhFs6FFfjXX1Q/D3FFuM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQO4wVQim8+ry7KrO5itAEOSrhJcMlS0n+yewSxmZyPb1LyU7su3eAmMzVwlWST14
	 RdOtR3zWw2Q1oTiN7b+YPWF8ew7vnffRmiOCtXaodqnpNx8xSe67OirUlOg+QQ2XHc
	 vRxwRYauGvL2m2H0FMIASjP+fGuComAffkLcCHcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghavendra Rao Ananta <rananta@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.1 372/772] KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status
Date: Thu, 12 Dec 2024 15:55:17 +0100
Message-ID: <20241212144405.280122644@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -294,7 +294,6 @@ static u64 kvm_pmu_overflow_status(struc
 
 	if ((__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E)) {
 		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
-		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 	}
 


