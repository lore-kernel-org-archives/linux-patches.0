Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3688C147C60;
	Wed, 19 Jun 2024 12:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801928; cv=none; b=sFzmPHDwU2wlOif0pprS4khNivXupBtjt0EkFPeMoeYrgyz5vnW7nVTk6sVbn1uE9so9Ia+lpNQsJYCLCOxn3Z/Fu+DLRzl2CTqIZIKPcY0u1/ASYSAqL2uUIl3iQdI7lrb9hqnWQBZdGmEIL5ME/O994KgFme6DTHvbif+vbTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801928; c=relaxed/simple;
	bh=/YuYYYZUjYPolwEMdaIVX6hRAmi7FDUXhBicJt9B3lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etESfe9TI0wL7ft43NBvvdihwJB7fnqO7f/1H6/hHbOQtKJqjJDQ9ccYxHsH3uRtYpFtnLCU1cqDuhLaOPXg6/qaPvcRoyOwrP/AaNU93G832p5aC0inkIminBe87SHqMAQgKuqv3s+I0KkRVmL95FfaustSod3Svz7oOWKJ2jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APB2kVBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APB2kVBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F228C2BBFC;
	Wed, 19 Jun 2024 12:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801927;
	bh=/YuYYYZUjYPolwEMdaIVX6hRAmi7FDUXhBicJt9B3lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APB2kVBjbkHcH9VMzZGxLzBWMMD+WfDioGJyLz0CoqsMM1e45+wHScDe7HLn0gIZ3
	 YdbimZ5O2VKxYocZWf22l7oTHvNg+eqb+DmptTL8mn/jBXc2+H4BxYe4wnzZsuP7La
	 x6N7pCT3bfgIR9a1a5z0DBkFuUnYLibtcyZGMF9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/267] KVM: SEV-ES: Disallow SEV-ES guests when X86_FEATURE_LBRV is absent
Date: Wed, 19 Jun 2024 14:52:55 +0200
Message-ID: <20240619125607.287087376@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit d922056215617eedfbdbc29fe49953423686fe5e ]

As documented in APM[1], LBR Virtualization must be enabled for SEV-ES
guests. So, prevent SEV-ES guests when LBRV support is missing.

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 15.35.2 Enabling SEV-ES.
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Message-ID: <20240531044644.768-3-ravi.bangoria@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c |  6 ++++++
 arch/x86/kvm/svm/svm.c | 16 +++++++---------
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c5845f31c34dc..0e643d7a06d9e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2264,6 +2264,12 @@ void __init sev_hardware_setup(void)
 	if (!boot_cpu_has(X86_FEATURE_SEV_ES))
 		goto out;
 
+	if (!lbrv) {
+		WARN_ONCE(!boot_cpu_has(X86_FEATURE_LBRV),
+			  "LBRV must be present for SEV-ES support");
+		goto out;
+	}
+
 	/* Has the system been allocated ASIDs for SEV-ES? */
 	if (min_sev_asid == 1)
 		goto out;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1efbe8b33f6a1..9e084e22a12f7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -214,7 +214,7 @@ int vgif = true;
 module_param(vgif, int, 0444);
 
 /* enable/disable LBR virtualization */
-static int lbrv = true;
+int lbrv = true;
 module_param(lbrv, int, 0444);
 
 static int tsc_scaling = true;
@@ -5248,6 +5248,12 @@ static __init int svm_hardware_setup(void)
 
 	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
 
+	if (lbrv) {
+		if (!boot_cpu_has(X86_FEATURE_LBRV))
+			lbrv = false;
+		else
+			pr_info("LBR virtualization supported\n");
+	}
 	/*
 	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
 	 * may be modified by svm_adjust_mmio_mask()), as well as nrips.
@@ -5301,14 +5307,6 @@ static __init int svm_hardware_setup(void)
 		svm_x86_ops.set_vnmi_pending = NULL;
 	}
 
-
-	if (lbrv) {
-		if (!boot_cpu_has(X86_FEATURE_LBRV))
-			lbrv = false;
-		else
-			pr_info("LBR virtualization supported\n");
-	}
-
 	if (!enable_pmu)
 		pr_info("PMU virtualization is disabled\n");
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index be67ab7fdd104..53bc4b0e388be 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -39,6 +39,7 @@ extern int vgif;
 extern bool intercept_smi;
 extern bool x2avic_enabled;
 extern bool vnmi;
+extern int lbrv;
 
 /*
  * Clean bits in VMCB.
-- 
2.43.0



