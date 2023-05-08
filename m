Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D55168C2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAEAC433D2;
	Mon,  8 May 2023 10:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541319;
	bh=Dn7/AtU8ESNkh3jYjBIKfJ+iDq7Jl5vSm61UxFUFu5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Cffz6XRPAPOB0OsfusyW9fiHZB7c4mbRRBr80e3Ts/8cY5AMZXSna2lH5VsNBwnm
	 ok7VfVNfT60s9uEqyVZFkuH1Yo/wYW9Zils75cDI08xHIQwQHt4779tuHwGXJ+/az4
	 3wIxxNxQafXcw+H/Ag3xg6QquhUx8IzCp/S/960Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Weijiang <weijiang.yang@intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Like Xu <likexu@tencent.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.2 077/663] KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs are available
Date: Mon,  8 May 2023 11:38:23 +0200
Message-Id: <20230508094430.953849065@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

commit 098f4c061ea10b777033b71c10bd9fd706820ee9 upstream.

Disallow enabling LBR support if the CPU supports architectural LBRs.
Traditional LBR support is absent on CPU models that have architectural
LBRs, and KVM doesn't yet support arch LBRs, i.e. KVM will pass through
non-existent MSRs if userspace enables LBRs for the guest.

Cc: stable@vger.kernel.org
Cc: Yang Weijiang <weijiang.yang@intel.com>
Cc: Like Xu <like.xu.linux@gmail.com>
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Fixes: be635e34c284 ("KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES")
Tested-by: Like Xu <likexu@tencent.com>
Link: https://lore.kernel.org/r/20230128001427.2548858-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7749,9 +7749,11 @@ static u64 vmx_get_perf_capabilities(voi
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
 
-	x86_perf_get_lbr(&lbr);
-	if (lbr.nr)
-		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
+		x86_perf_get_lbr(&lbr);
+		if (lbr.nr)
+			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+	}
 
 	if (vmx_pebs_supported()) {
 		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;


