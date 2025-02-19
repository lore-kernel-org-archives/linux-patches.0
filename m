Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD321E0DCE;
	Wed, 19 Feb 2025 08:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954184; cv=none; b=Ggk2U62icfx5HXLJagpJ8LeET/LdmOUEgQJSQ/g75gF2Sg4tc2vNIaRXCfW1mlL2w0hXQ3qGDXbUiWnZy9V/IxMuvu1+lv7Fvk0dIS842d2B0VAbtMR+Np0X6d2szM16jO1rAIQWqm9ePb3LNes+8jMtXacOBPWJFX0iLaKFyoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954184; c=relaxed/simple;
	bh=MAnoizBRhFpaU27LfDCFw/TGncCVxrgeS9Ck0xb5oQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWL5ZBTLjMXMRrZkpWXL3HiZ4wYUfF/6X89OoS2u5ZHZgYwmKBHdR6sAbAh1m35bUe61ztSm8NGnT4/9WGvEew6ESWTWVbaCciKwLat1I6xw2RiRGenfbaFGxyylFXNQwLvm32cibmbCpdH6irbnZ63Mof5coquciGNj30qvhyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bk6bb3Oz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bk6bb3Oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7152C4CED1;
	Wed, 19 Feb 2025 08:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954184;
	bh=MAnoizBRhFpaU27LfDCFw/TGncCVxrgeS9Ck0xb5oQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bk6bb3OzcEeSPITdl8Ixh9y5B05lvW92xTbsQ2BHGPtzHPRm57qcXX5qSm8YwGmA/
	 57Xz9swqJHujWhUGnU8V1PH6/VxeUmb4QwsF5SeI3eu+nWtwV/GIEh3YVD7GCIPkJ7
	 bElMIiNz6sgbOc2o2Aq/64eHqIzJ30Tjz2sBPf0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.13 123/274] perf/x86/intel: Ensure LBRs are disabled when a CPU is starting
Date: Wed, 19 Feb 2025 09:26:17 +0100
Message-ID: <20250219082614.430205863@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5024,8 +5024,11 @@ static void intel_pmu_cpu_starting(int c
 
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
@@ -395,7 +395,8 @@
 #define MSR_IA32_PASID_VALID		BIT_ULL(31)
 
 /* DEBUGCTLMSR bits (others vary by model): */
-#define DEBUGCTLMSR_LBR			(1UL <<  0) /* last branch recording */
+#define DEBUGCTLMSR_LBR_BIT		0	     /* last branch recording */
+#define DEBUGCTLMSR_LBR			(1UL <<  DEBUGCTLMSR_LBR_BIT)
 #define DEBUGCTLMSR_BTF_SHIFT		1
 #define DEBUGCTLMSR_BTF			(1UL <<  1) /* single-step on branches */
 #define DEBUGCTLMSR_BUS_LOCK_DETECT	(1UL <<  2)


