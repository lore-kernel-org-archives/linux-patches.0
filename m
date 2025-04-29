Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F10521ABDB;
	Tue, 29 Apr 2025 17:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947748; cv=none; b=figM7y3L8hYn7vjC2bj+qmqtt1UW38wKkK/rqTmftPF097thmcvJyUAt3km9/n/9ehGXiBtdU68Q35qjjaXwBFILDFizcZMBVhWIQqMqSZ1QptjuXQufGxHYkotlXGMe37sB93r7AFdrxc9MGRn+AXZ8+c3Nb5Lkm0c/Thu/suY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947748; c=relaxed/simple;
	bh=CVAtSQDBI9kiyzJA3euki7chjFE407t1zbzJUDyUs3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uvUi5itI3c9yCXk4yeSyij2pks6w/Dhsgyq6Gh2LH9NNQQh8LT7seScIwrv9yDI2+OoqVJWp/2Slu3WQ3/8Ha9NAnaLEs1B0znAojMftRN3lxfvW8RTrpR2nk/pcou1ujsldMDnbUu4OKYbDEP0eEDvGBMsAm18auwP7eRfHkjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyRFoMWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyRFoMWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036F5C4CEE9;
	Tue, 29 Apr 2025 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947748;
	bh=CVAtSQDBI9kiyzJA3euki7chjFE407t1zbzJUDyUs3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyRFoMWVN7gqsbTI7sLmyPH5BVVSIn2zn7j1AkXfqKyr41vIxv4qwSVdoegAOcRTY
	 9siwhol6iYrsFlc/9Sfrw+2oMYuIgGPL0g0XHc3hgoGpeccUWkKTiJmTvjdaObIs7O
	 2DHgWYTHTCPQ8W+I+jMemcieNYAmAKSq5IL7Pyao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Naveen N Rao <naveen@kernel.org>
Subject: [PATCH 6.12 092/280] KVM: SVM: Disable AVIC on SNP-enabled system without HvInUseWrAllowed feature
Date: Tue, 29 Apr 2025 18:40:33 +0200
Message-ID: <20250429161118.872352268@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit d81cadbe164265337f149cf31c9462d7217c1eed upstream.

On SNP-enabled system, VMRUN marks AVIC Backing Page as in-use while
the guest is running for both secure and non-secure guest. Any hypervisor
write to the in-use vCPU's AVIC backing page (e.g. to inject an interrupt)
will generate unexpected #PF in the host.

Currently, attempt to run AVIC guest would result in the following error:

    BUG: unable to handle page fault for address: ff3a442e549cc270
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x80000003) - RMP violation
    PGD b6ee01067 P4D b6ee02067 PUD 10096d063 PMD 11c540063 PTE 80000001149cc163
    SEV-SNP: PFN 0x1149cc unassigned, dumping non-zero entries in 2M PFN region: [0x114800 - 0x114a00]
    ...

Newer AMD system is enhanced to allow hypervisor to modify the backing page
for non-secure guest on SNP-enabled system. This enhancement is available
when the CPUID Fn8000_001F_EAX bit 30 is set (HvInUseWrAllowed).

This table describes AVIC support matrix w.r.t. SNP enablement:

               | Non-SNP system |     SNP system
-----------------------------------------------------
 Non-SNP guest |  AVIC Activate | AVIC Activate iff
               |                | HvInuseWrAllowed=1
-----------------------------------------------------
     SNP guest |      N/A       |    Secure AVIC

Therefore, check and disable AVIC in kvm_amd driver when the feature is not
available on SNP-enabled system.

See the AMD64 Architecture Programmer’s Manual (APM) Volume 2 for detail.
(https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/
programmer-references/40332.pdf)

Fixes: 216d106c7ff7 ("x86/sev: Add SEV-SNP host initialization support")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20241104075845.7583-1-suravee.suthikulpanit@amd.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Cc: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kvm/svm/avic.c            |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -449,6 +449,7 @@
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" AMD SEV-ES full debug state swap support */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
+#define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1199,6 +1199,12 @@ bool avic_hardware_setup(void)
 		return false;
 	}
 
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
+	    !boot_cpu_has(X86_FEATURE_HV_INUSE_WR_ALLOWED)) {
+		pr_warn("AVIC disabled: missing HvInUseWrAllowed on SNP-enabled system\n");
+		return false;
+	}
+
 	if (boot_cpu_has(X86_FEATURE_AVIC)) {
 		pr_info("AVIC enabled\n");
 	} else if (force_avic) {


