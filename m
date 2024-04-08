Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9650D7FBCF;
	Mon,  8 Apr 2024 13:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582334; cv=none; b=tp4XttSu+XGVQg4bvD/NZgUHf+Rncnkd8U+3KHDFHB/kZGy13T/Eiyfm8aOd8WfH/1ojsMSIQmSNCR3Oc2sBv6yLEMvaYW6bbLf2DBQFtx8O/aTFN4UqOIuJ4qgZS46l72E+V/uc8rnARQUOTiwQNnwwnN8yxGbEKRqaez+4RHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582334; c=relaxed/simple;
	bh=zdNFXsbkz0HWSZaUyjIt4Sfhx9s1bpHXRaEIoN1MatQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gz7q1FxInCpMHOiudDENJKMcCiHeKvJtAZXgK1JT8pEppmTRchewvd9dsk2kq6FSddLVY3K0sz2njFeGMBUVM+iwm21HEZiUBSwsLxUd8RSn8FM2fxNymCsoa4K11XDp2SyzdzhxQq2AMwpxDwLX00hWk/yfOP53UE/+uWevoK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQ++bchW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQ++bchW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8388C433C7;
	Mon,  8 Apr 2024 13:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582334;
	bh=zdNFXsbkz0HWSZaUyjIt4Sfhx9s1bpHXRaEIoN1MatQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQ++bchWZbcu+yBf3eZlA6ElJAOvR4WQm4BDJWVu5uZni/S5v9YeeFM9c5NQrcKYx
	 X/kVsbJsA4qetHceC14GFTsoBfs41Rl8NmhEZ0993g7gqyxt3ZkNpA362tjNRBVnWl
	 PBcWcUU7u4YR4wHRXLJhYYpOKWKq09WncqlhIPow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.8 066/273] KVM: arm64: Fix host-programmed guest events in nVHE
Date: Mon,  8 Apr 2024 14:55:41 +0200
Message-ID: <20240408125311.350905910@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 


