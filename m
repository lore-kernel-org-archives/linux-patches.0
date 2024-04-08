Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D83A2E405;
	Mon,  8 Apr 2024 13:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581486; cv=none; b=kmiEpOgY1ia0YGxjIy7My76MTmsLNakUJ9qhL9Zcp/mL0kmJMLyB4Cny5Hrfs/48BrysjAXfd2f1/EKtZtRGwSCUyI/C72+FyXLcEur9iSzhGBSSMg+PFgr1bs9ACJEYd4cSpPE8wDX8WzD6MyP4vpml8XA8IU5SJ5D3DrULgLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581486; c=relaxed/simple;
	bh=2n/AXk4A0FS5Kj6BgO/Ar3+q4xs8T1l3O9VBN08WhFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCD/V6fwgXz/bL2QQ4RynAbYYJSSuInm6aecnQ9awFWyILAlmcJOke6cvEIm7tsS3UEdMPLft+EqTGybD6SZdRZZvo3ciUw9m7TQGsxUMv1SI7t0fEKwVTGNrYmweOU3M23meSTTjItjIwLN8i4eiFT91MnBCMRHeJ6Gk/TcOcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFhD0tP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFhD0tP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29A1C433C7;
	Mon,  8 Apr 2024 13:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581486;
	bh=2n/AXk4A0FS5Kj6BgO/Ar3+q4xs8T1l3O9VBN08WhFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFhD0tP75iiy01MCbwdF14HfYvQEJUaB6LCjn2c76Y+EsRdJeG+Xkza0LS7fgzpza
	 T2kU3fANTzmQT/DXb69jjQ2UHU8Wv8mmgXyWs6VSlO09hHfUo7yzKgMXhNpi+iH8jQ
	 afAslX/Qy7jcv6p8N6kvoVTuz9218n5l6BVoJ2FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.1 026/138] KVM: arm64: Fix host-programmed guest events in nVHE
Date: Mon,  8 Apr 2024 14:57:20 +0200
Message-ID: <20240408125257.041337141@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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
@@ -85,7 +85,7 @@ void kvm_vcpu_pmu_restore_host(struct kv
  */
 #define kvm_pmu_update_vcpu_events(vcpu)				\
 	do {								\
-		if (!has_vhe() && kvm_vcpu_has_pmu(vcpu))		\
+		if (!has_vhe() && kvm_arm_support_pmu_v3())		\
 			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
 	} while (0)
 


