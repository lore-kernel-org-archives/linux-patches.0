Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C08C1DE2DE;
	Wed, 19 Feb 2025 09:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957368; cv=none; b=aa88EFSwsc4pCP1/FlUR7OKb8et1sGJ5Kj58dzVGjb/G0vFcBIFbphqwF0SMeAFaZZHMM/yCrF13X/1lZfEppW5+p3qixt8WXrVB4h0lOKw7IntkziSDnmtjQvO63OcZ17sG3juXr5yHhWOm1nuTVmIr6+F3aCJJIwEGCJBmFnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957368; c=relaxed/simple;
	bh=zy+GKTGiY+/hcdgj4WxboflP/XVoQ/eV0BMgLWs4NuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXXwUIb//+NxxGcQaY6Yx/kKr2A+3qbmziG44+K5ms2s6SMTS0VvH3iyHjxt5W0q4kj15k4PD8ofaYagyPN8yN6qW16/9eIRFDwBAsAQQokMpR+qKVIjqyLsf3nlbK+qyHy5TDOuC8D2dFgCEQN0/9PU5UVjq2TLlJu5I0fSGkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxtPBG4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxtPBG4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90601C4CEE6;
	Wed, 19 Feb 2025 09:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957367;
	bh=zy+GKTGiY+/hcdgj4WxboflP/XVoQ/eV0BMgLWs4NuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxtPBG4SUCYaPbyu6v+/TOR7wyg1slrgmwCY3FuxaC+x/f5QTwFoRXd1WY+s1Az0B
	 i7lj8dydiHDtWcHtn8WN65Qg8tJwV62K8s+X/oPofzFD1HX+l4hO43aYmrajAoFReC
	 POtAbg/Ap1EOPiXfq+VHvDkP5/9wDXx1U2cYvlkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 502/578] perf/x86/intel: Ensure LBRs are disabled when a CPU is starting
Date: Wed, 19 Feb 2025 09:28:26 +0100
Message-ID: <20250219082712.735170052@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit c631a2de7ae48d50434bdc205d901423f8577c65 upstream.

Explicitly clear DEBUGCTL.LBR when a CPU is starting, prior to purging the
LBR MSRs themselves, as at least one system has been found to transfer
control to the kernel with LBRs enabled (it's unclear whether it's a BIOS
flaw or a CPU goof).  Because the kernel preserves the original DEBUGCTL,
even when toggling LBRs, leaving DEBUGCTL.LBR as is results in running
with LBRs enabled at all times.

Closes: https://lore.kernel.org/all/c9d8269bff69f6359731d758e3b1135dedd7cc61.camel@redhat.com
Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250131010721.470503-1-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c     |    5 ++++-
 arch/x86/include/asm/msr-index.h |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4582,8 +4582,11 @@ static void intel_pmu_cpu_starting(int c
 
 	init_debug_store_on_cpu(cpu);
 	/*
-	 * Deal with CPUs that don't clear their LBRs on power-up.
+	 * Deal with CPUs that don't clear their LBRs on power-up, and that may
+	 * even boot with LBRs enabled.
 	 */
+	if (!static_cpu_has(X86_FEATURE_ARCH_LBR) && x86_pmu.lbr_nr)
+		msr_clear_bit(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR_BIT);
 	intel_pmu_lbr_reset();
 
 	cpuc->lbr_sel = NULL;
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -357,7 +357,8 @@
 #define MSR_IA32_PASID_VALID		BIT_ULL(31)
 
 /* DEBUGCTLMSR bits (others vary by model): */
-#define DEBUGCTLMSR_LBR			(1UL <<  0) /* last branch recording */
+#define DEBUGCTLMSR_LBR_BIT		0	     /* last branch recording */
+#define DEBUGCTLMSR_LBR			(1UL <<  DEBUGCTLMSR_LBR_BIT)
 #define DEBUGCTLMSR_BTF_SHIFT		1
 #define DEBUGCTLMSR_BTF			(1UL <<  1) /* single-step on branches */
 #define DEBUGCTLMSR_BUS_LOCK_DETECT	(1UL <<  2)


