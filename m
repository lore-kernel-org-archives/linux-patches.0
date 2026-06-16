Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553FC44CAF5;
	Tue, 16 Jun 2026 16:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628497; cv=none; b=ewgcKlwkjLASy7afd4ZEglZEfmYiFHwssbrTtbyLjQgFBHX0OpyAiLSpkRx136SgWSpkG8tf854vfRhHuvwuZzucIG5C+qhyh18UFFh2WIBIACcQ34QMoRyIa9L9mSGcdybGLpsDoYVILmVD36OVUNCxTU/3sRYd9XsY2QhuHlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628497; c=relaxed/simple;
	bh=2BobDIupSuGxIih/crSHUbkdDnMLiewJFm7x2i7d+FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jizmPAHWesT8Sw7CkWqc/NbGDDBgRSkuqbqi2UpX7R0QBdaqLtViqfguHaosKBHcr6tvppi317oAbcKuzW9BCvcDVctWQUPSCaH74mpT1GtEhlPG6w8Wa1tCCJo+w+SJIc32nEVqpZnnMRkG3zpl08lsZkqeGlabJ2T22y4K4pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDkCyWy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDkCyWy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41FF1F000E9;
	Tue, 16 Jun 2026 16:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628495;
	bh=Xr3kQ2CZ4950ZX9aVY3kXNtgF3c2jbveRBrkAf2VwKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDkCyWy4N9Eee8mqrrOjF3ZDdlxRQEtTdQ5wgrDX8cLY1V8X0SB59wgxIje2Msr5i
	 900+2wt2G4JTA1L0dSnK7bHzcA+Aqglpsovr4cWSk4gP+e/AiNvsXiEHm4axW6zdpZ
	 EuVJCgZKDhwqhY2cksg/pOSMq+vSr08MBg16IAEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 105/452] KVM: arm64: PMU: Preserve AArch32 counter low bits
Date: Tue, 16 Jun 2026 20:25:32 +0530
Message-ID: <20260616145123.298520816@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Ma <maqianga@uniontech.com>

commit 1750ad1388e03fb27068cd1f22c9c8b4590fe936 upstream.

AArch32 writes to PMU event counters cannot update the top 32 bits,
even when PMUv3p5 makes the counters 64-bit. KVM therefore needs to
preserve the existing high half and only update the low half written by
the guest, unless the caller explicitly forces a full reset through
PMCR.P.

The current code masks @val down to the old high half before taking
lower_32_bits(val), which means the low half is always zero. As a
result, AArch32 writes to event counters discard the guest-provided low
32 bits instead of storing them.

Build the new value from the old high 32 bits and the low 32 bits of
the value supplied by the guest.

Fixes: 26d2d0594d70 ("KVM: arm64: PMU: Do not let AArch32 change the counters' top 32 bits")
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260526074640.791991-1-maqianga@uniontech.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/pmu-emul.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -146,8 +146,8 @@ static void kvm_pmu_set_pmc_value(struct
 		 * action is to use PMCR.P, which will reset them to
 		 * 0 (the only use of the 'force' parameter).
 		 */
-		val  = __vcpu_sys_reg(vcpu, reg) & GENMASK(63, 32);
-		val |= lower_32_bits(val);
+		val = (__vcpu_sys_reg(vcpu, reg) & GENMASK(63, 32)) |
+		      lower_32_bits(val);
 	}
 
 	__vcpu_sys_reg(vcpu, reg) = val;


