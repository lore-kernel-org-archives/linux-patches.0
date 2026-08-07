Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E0638E8A9;
	Fri,  7 Aug 2026 14:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114756; cv=none; b=kgtgRbNizRht9+N5P3SJ/Np0vW4OKjFaBfDvOasX68Erc7h6+4ju4wW+nEcDLYQHZFx7k33pNL4WMPSwQEMymAjaTTXV/XVWDUtjTATgKXr+I1DD/oTSJ1TSteB0CQGjL2MTxP+6gBVLdy5zG5OqfuNMLnkVPZWz5THmfqpwYbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114756; c=relaxed/simple;
	bh=4pOKd/uDDP6W2G5W5+tRAIhWfSC0jGdORuTbt8HfAfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I06h4vwUR11D27Qy6tOExeBuJq5hELZnJ4672Ba3/WsfV47yWDYHvo34UPbdcdgZzhgK5gzst/Z2FkAFhpzg2O3h+RwxglVZINv4k/zrVofkAPfzqQaco6yMnhFHORejid3p5IHMkpEp3s0Mk4uHHRg73WAOQWRXUjMwCWtlRCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6z1K2FA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6z1K2FA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE56C1F000E9;
	Fri,  7 Aug 2026 14:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114755;
	bh=UGOFke7z+khIvTOuycQ40auNlGiSDTSrlxgNqkehbs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6z1K2FAuF5YlXGsa4yxXtMkw2t6Ed71aCSeE1/sFHiHOA0OVIDnkqk7v/IYYrakS
	 YNLhvjgdM015dXdeoU7AfPLcwgkuFEyVFeUlAixwf+JT/oXFjMpIjNGkailyeawyS7
	 o8El4B1S4Zcu3FHGiFyHiwRKaSVCXsXe/N63C7S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Kisel <romank@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/396] arch/x86: mshyperv: Discover Confidential VMBus availability
Date: Fri,  7 Aug 2026 16:33:16 +0200
Message-ID: <20260807143425.051852807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Kisel <romank@linux.microsoft.com>

[ Upstream commit 7c8b6c326d830ca5c6b95f390c703966e14167e6 ]

Confidential VMBus requires enabling paravisor SynIC, and
the x86_64 guest has to inspect the Virtualization Stack (VS)
CPUID leaf to see if Confidential VMBus is available. If it is,
the guest shall enable the paravisor SynIC.

Read the relevant data from the VS CPUID leaf. Refactor the
code to avoid repeating CPUID and add flags to the struct
ms_hyperv_info. For ARM64, the flag for Confidential VMBus
is not set which provides the desired behaviour for now as
it is not available on ARM64 just yet. Once ARM64 CCA guests
are supported, this flag will be set unconditionally when
running such a guest.

Signed-off-by: Roman Kisel <romank@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Stable-dep-of: 8c7ab779c885 ("Drivers: hv: vmbus: Replace lockdep_hardirq_threaded() with lockdep annotation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mshyperv.c | 28 +++++++++++++++-------------
 include/asm-generic/mshyperv.h |  2 ++
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index c4febdbcfe4d8..cae0dcd9006bd 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -440,7 +440,7 @@ EXPORT_SYMBOL_GPL(hv_get_hypervisor_version);
 
 static void __init ms_hyperv_init_platform(void)
 {
-	int hv_max_functions_eax;
+	int hv_max_functions_eax, eax;
 
 #ifdef CONFIG_PARAVIRT
 	pv_info.name = "Hyper-V";
@@ -475,6 +475,19 @@ static void __init ms_hyperv_init_platform(void)
 		pr_info("Hyper-V: running on a nested hypervisor\n");
 	}
 
+	/*
+	 * There is no check against the max function for HYPERV_CPUID_VIRT_STACK_* CPUID
+	 * leaves as the hypervisor doesn't handle them. Even a nested root partition (L2
+	 * root) will not get them because the nested (L1) hypervisor filters them out.
+	 * These are handled through intercept processing by the Windows Hyper-V stack
+	 * or the paravisor.
+	 */
+	eax = cpuid_eax(HYPERV_CPUID_VIRT_STACK_PROPERTIES);
+	ms_hyperv.confidential_vmbus_available =
+		eax & HYPERV_VS_PROPERTIES_EAX_CONFIDENTIAL_VMBUS_AVAILABLE;
+	ms_hyperv.msi_ext_dest_id =
+		eax & HYPERV_VS_PROPERTIES_EAX_EXTENDED_IOAPIC_RTE;
+
 	if (ms_hyperv.features & HV_ACCESS_FREQUENCY_MSRS &&
 	    ms_hyperv.misc_features & HV_FEATURE_FREQUENCY_MSRS_AVAILABLE) {
 		x86_platform.calibrate_tsc = hv_get_tsc_khz;
@@ -675,21 +688,10 @@ static bool __init ms_hyperv_x2apic_available(void)
  * pci-hyperv host bridge.
  *
  * Note: for a Hyper-V root partition, this will always return false.
- * The hypervisor doesn't expose these HYPERV_CPUID_VIRT_STACK_* cpuids by
- * default, they are implemented as intercepts by the Windows Hyper-V stack.
- * Even a nested root partition (L2 root) will not get them because the
- * nested (L1) hypervisor filters them out.
  */
 static bool __init ms_hyperv_msi_ext_dest_id(void)
 {
-	u32 eax;
-
-	eax = cpuid_eax(HYPERV_CPUID_VIRT_STACK_INTERFACE);
-	if (eax != HYPERV_VS_INTERFACE_EAX_SIGNATURE)
-		return false;
-
-	eax = cpuid_eax(HYPERV_CPUID_VIRT_STACK_PROPERTIES);
-	return eax & HYPERV_VS_PROPERTIES_EAX_EXTENDED_IOAPIC_RTE;
+	return ms_hyperv.msi_ext_dest_id;
 }
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index b89c7e3a20474..8862f77241e6c 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -62,6 +62,8 @@ struct ms_hyperv_info {
 		};
 	};
 	u64 shared_gpa_boundary;
+	bool msi_ext_dest_id;
+	bool confidential_vmbus_available;
 };
 extern struct ms_hyperv_info ms_hyperv;
 extern bool hv_nested;
-- 
2.53.0



