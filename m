Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EA4301712;
	Wed, 17 Sep 2025 13:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114020; cv=none; b=pWT2LKMXlDpmWkhbCMvMFow3HlGSVsaGlCsTyaXYd+m1ys9f7fsoz0WUflTO/2RZr96h6Z4iBWIT1NiAehISrRhx2XhWuo/vT9Pd5nmnEzjviacE3fRCmQwmrD2cNGxrDbpL6Wf+CHTtNy2UD/Dz63lyxOaVj8ZVMlouUH7723A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114020; c=relaxed/simple;
	bh=AhrhwMa38YCGoUatGp7dfW3YAeQhZe6Cf7Ykpd2sPaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/ufeRCuUPYVcB/BJEEv41OalIGuTcFRYU8r1n5GisEcg8FcnYCBCe4rh3JrIcFyNIRH/TrP5Xlo8nHkFhzbZ6a7ROu5SBosl5+IYeHcZT3M3f2IU6fmRiO3j0isQESFOFV+PxDtVBxqQpUqYejczebLmi6dMJPUsrd4YOC+qCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpBp/oPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpBp/oPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E771C4CEF0;
	Wed, 17 Sep 2025 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114020;
	bh=AhrhwMa38YCGoUatGp7dfW3YAeQhZe6Cf7Ykpd2sPaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpBp/oPeDQqlFHj2Pzb4hj58Kd5Px91Unlx7Jq6IulNz2PbeA3Si4qBNDeQLw3iWW
	 8aGrDECTWh/z+u0jZJ3GEJv9yygmNTaLPIQXNUW53MHTwQKL+xZZHYS2Go1+DoHXqJ
	 A8A2PBLgOR0xTosnYHg8VMm/RRqw45ioZvI2d4yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinpu Wang <jinpu.wang@ionos.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 6.1 22/78] KVM: SVM: Set synthesized TSA CPUID flags
Date: Wed, 17 Sep 2025 14:34:43 +0200
Message-ID: <20250917123330.108366456@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Commit f3f9deccfc68a6b7c8c1cc51e902edba23d309d4 in the LTS tree.

VERW_CLEAR is supposed to be set only by the hypervisor to denote TSA
mitigation support to a guest. SQ_NO and L1_NO are both synthesizable,
and are going to be set by hw CPUID on future machines.

So keep the kvm_cpu_cap_init_kvm_defined() invocation *and* set them
when synthesized.

This fix is stable-only.

Co-developed-by: Jinpu Wang <jinpu.wang@ionos.com>
Signed-off-by: Jinpu Wang <jinpu.wang@ionos.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org> # 6.1.y
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -770,10 +770,15 @@ void kvm_set_cpu_caps(void)
 	if (cpu_feature_enabled(X86_FEATURE_SRSO_NO))
 		kvm_cpu_cap_set(X86_FEATURE_SRSO_NO);
 
+	kvm_cpu_cap_check_and_set(X86_FEATURE_VERW_CLEAR);
+
 	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0021_ECX,
 		F(TSA_SQ_NO) | F(TSA_L1_NO)
 	);
 
+	kvm_cpu_cap_check_and_set(X86_FEATURE_TSA_SQ_NO);
+	kvm_cpu_cap_check_and_set(X86_FEATURE_TSA_L1_NO);
+
 	/*
 	 * Hide RDTSCP and RDPID if either feature is reported as supported but
 	 * probing MSR_TSC_AUX failed.  This is purely a sanity check and


