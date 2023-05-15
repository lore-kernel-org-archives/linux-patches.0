Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3DEFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B906C4339B;
	Mon, 15 May 2023 17:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170104;
	bh=zufWwYM0zTZqLshi852Nlo3YF+qcJnQnzcq4TTnlyKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2K8uVkEZiu3wz0c6+kRHZg/eygBm9R1ry40p8s1NbI+veeg91dJFp8Q6M1E6MzCg1
	 3D/oqBvmhloU8xlOyn/XuFNatFUkeRWha2cQCBQcDzWE4yirjV+IQ+o7hy12cjvRf9
	 hmGNXd0LyTyelxOV18Jm0ypsy2mFA3MifuwzN3es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Weijiang <weijiang.yang@intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Like Xu <likexu@tencent.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/239] KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs are available
Date: Mon, 15 May 2023 18:24:31 +0200
Message-Id: <20230515161721.824129169@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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

[ Upstream commit 098f4c061ea10b777033b71c10bd9fd706820ee9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8ad5992f61340..5db21d9ef6710 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7714,9 +7714,11 @@ static u64 vmx_get_perf_capabilities(void)
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
-- 
2.39.2



