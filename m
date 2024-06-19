Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F2E146016;
	Wed, 19 Jun 2024 13:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802736; cv=none; b=uT/Tp2wszU1trvfdebxGImo1gn4W9XVyEaQ+E0UtzIRv+rkcRLUbDqUtalszBGBXItTeCTe9iSf2qx4msnFH/ZfDMwsVjjL5XCs0uzJJtNJAygIW7E0fQ6NF4XRit2YiBADkZLj9e+wnhUmVts8T4sDufU9hZstPcfEHl+f5KEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802736; c=relaxed/simple;
	bh=623eSG/ub38iZ5YpZoZEcMdQy2rkyicg0Ooj8qrg/XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQzqfrQGVBt81TfkZ3coUsNhk23qD2sKRasieksM51Uwtoc/ZjLCbzzl41q7jeIlSOUldjrTD0xgMI7/Riz8hgDParBf071ae+4alFI5OFS7dE2LcDj96ibaHTZCxef6aqGvqxwLPjwxoKG6iADU7dhszwxQYVYSriQOjSlrecs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDmWS52i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDmWS52i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF76C2BBFC;
	Wed, 19 Jun 2024 13:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802735;
	bh=623eSG/ub38iZ5YpZoZEcMdQy2rkyicg0Ooj8qrg/XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDmWS52iFbuYNwOfXONYP+ZGzSMAkdtRgU/Tm3vejZKc83/QE0t8+hyFGfxVmX0L6
	 ftYtmO2GvaIXO3Y0jqlaJnGHkH5LjbCtypF98X2gW6w5uGCs5msRNlWzdSqZY8Rt+S
	 D8ZPFF3qWcLcuqsocrJuCtgeAZA7aZkhi4nLSjgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 029/281] KVM: SEV-ES: Disallow SEV-ES guests when X86_FEATURE_LBRV is absent
Date: Wed, 19 Jun 2024 14:53:08 +0200
Message-ID: <20240619125610.967653895@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 759581bb2128d..43b7d76a27a56 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2269,6 +2269,12 @@ void __init sev_hardware_setup(void)
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
index 308416b50b036..3363e5ba0fff5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -215,7 +215,7 @@ int vgif = true;
 module_param(vgif, int, 0444);
 
 /* enable/disable LBR virtualization */
-static int lbrv = true;
+int lbrv = true;
 module_param(lbrv, int, 0444);
 
 static int tsc_scaling = true;
@@ -5260,6 +5260,12 @@ static __init int svm_hardware_setup(void)
 
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
@@ -5313,14 +5319,6 @@ static __init int svm_hardware_setup(void)
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
index 33878efdebc82..4bf9af529ae03 100644
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



