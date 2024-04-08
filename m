Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3D27E56B;
	Mon,  8 Apr 2024 13:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582229; cv=none; b=YMoLYkvVFmvTu3cTuTVllX9pM2tz5/cpxX2hHl1O1ycyBkt60KnQbgXt1f3TZapVCgkrdbCYlRJ1LwikSQEFWxvKnEpFfFPDe9LrWDMLrgTc0SHsFHbjerljp4ortnXmAfnLT9abZgGYWhfUQomoPuxptceUisgsSne7pben58U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582229; c=relaxed/simple;
	bh=GzLaC5EbcS9c63zcdtro13xSVwdKDZHFhoqX4RUmGZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYN+oS8OA+xj0Wj3R3h4PYfgzpTUYG1/qO1D9weluzbrs4mra9NN+OLs8Vabhknivz3wnMNN2kp5OepYuC/Zzq9D6f3qtDycGgtaJ0yrWlmVNHA9/f0PWHfcM2xxNrJUAq04WbqtabfYCOrHO80FvX84UUnTAXAqn9pT1aU1Hlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebGPaVBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebGPaVBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E03C433C7;
	Mon,  8 Apr 2024 13:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582229;
	bh=GzLaC5EbcS9c63zcdtro13xSVwdKDZHFhoqX4RUmGZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebGPaVBrtP8gevRMmVqSGn7Z7RqHDvUv1OOTz6OxiE7+CdjoVMXPOZ2FewFQSHPG+
	 L7ZOULedHM9HUESX5EiO+pPR0gyD+eWyKcbxrO8ULtWdh/508699n9CgG7XQ1UR3oA
	 6duAMLRePus3xQUuuN7RK19L2IAa9DiYm00zrAXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.6 071/252] KVM: arm64: Fix host-programmed guest events in nVHE
Date: Mon,  8 Apr 2024 14:56:10 +0200
Message-ID: <20240408125308.836967513@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oliver.upton@linux.dev>

commit e89c928bedd77d181edc2df01cb6672184775140 upstream.

Programming PMU events in the host that count during guest execution is
a feature supported by perf, e.g.

  perf stat -e cpu_cycles:G ./lkvm run

While this works for VHE, the guest/host event bitmaps are not carried
through to the hypervisor in the nVHE configuration. Make
kvm_pmu_update_vcpu_events() conditional on whether or not _hardware_
supports PMUv3 rather than if the vCPU as vPMU enabled.

Cc: stable@vger.kernel.org
Fixes: 84d751a019a9 ("KVM: arm64: Pass pmu events to hyp via vcpu")
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240305184840.636212-3-oliver.upton@linux.dev
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/kvm/arm_pmu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -86,7 +86,7 @@ void kvm_vcpu_pmu_resync_el0(void);
  */
 #define kvm_pmu_update_vcpu_events(vcpu)				\
 	do {								\
-		if (!has_vhe() && kvm_vcpu_has_pmu(vcpu))		\
+		if (!has_vhe() && kvm_arm_support_pmu_v3())		\
 			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
 	} while (0)
 


