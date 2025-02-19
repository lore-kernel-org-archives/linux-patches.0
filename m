Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E33A1C175A;
	Wed, 19 Feb 2025 08:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955008; cv=none; b=g7pfuGMh76dsMdToaprTLbjM7wMR7+x43fbnVXIeu21ozTkXrLEPZ1H/u/OHX4rdDbUC3GKoJcZq5aUVfyBHhMix/CiX/JQ59nCaN10pAQHallZ8PBHSS39sZBt0OqhMqz3ts+XbVL+KbhTp+GKeLBirbUji6Ghwg441stTYBmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955008; c=relaxed/simple;
	bh=U9BsFx7otg+43fKwIVKcozKSSDorW+sr35XXdjMXaVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIUwyDawy/xU3/QaansmamFa9L3TXd7dG3PThlxWPAK3hrEV2dEvj7Aq7n5YDJVfpLoSkLAcoMaS0EZr/Hse4Eyzp6+kS3z4Y8jOdWz6RlxbguvFVmEtbw4k5k6pd6zhP+cZgFF9UfMeJjnwJedyep3GK7r/+l0qyq2i1aHWmaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5lv8ROq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5lv8ROq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BEDC4CED1;
	Wed, 19 Feb 2025 08:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955007;
	bh=U9BsFx7otg+43fKwIVKcozKSSDorW+sr35XXdjMXaVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5lv8ROq6JfT+86Wu4aoqQSU6TIyaIP8V/wpOki2RL7HRin6LdS5eavmiBoMFjE1c
	 rB6bwbJYNtVbHc8ZZOuM1Jt+F/yiabpx7p9avFOWxGe8EtgOSKR97elbmM0POjKIN6
	 mab37wvd4BYK2CpeucOXGSYwjUcmOTWuOzk2xtZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.12 104/230] perf/x86/intel: Ensure LBRs are disabled when a CPU is starting
Date: Wed, 19 Feb 2025 09:27:01 +0100
Message-ID: <20250219082605.761946674@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4993,8 +4993,11 @@ static void intel_pmu_cpu_starting(int c
 
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


