Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AD3156C5F;
	Mon, 16 Sep 2024 12:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488270; cv=none; b=DN5QPOJgNSMElEVc1bYby2AUIDv2L+ErMzlkceU4aYgePBhNZN6i6gp4W9B20nKcSELZzIciCKxH2+nbZaPf68HeLejMq9gCT9i2D+a283AG0EVK5bbXb5jvSRdk0Bf+9Cek1SM7g7NyxGcTt6b621qV2wMhIYnoI8ttB0VNQN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488270; c=relaxed/simple;
	bh=YO0K6lGVtmQzZSfZvKcsxTZ713wCldFT85ErA532ljU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJNDlPeNmpDSroXu8fmSqHERokR/EL0axRh77J+C/CTSwf2NDWjP8gsbO6T3k2RunGOzJj1s8I8vogeUgc49axp9IWlFkQDRoi9E6tJ3FnO864ToT/4K8Dl3457MNYmemViCjBGzyqgK9wDZiKhIfuMrvisTYVVvc1jXLvzvyWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aYRWNOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aYRWNOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4766BC4CEC4;
	Mon, 16 Sep 2024 12:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488270;
	bh=YO0K6lGVtmQzZSfZvKcsxTZ713wCldFT85ErA532ljU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2aYRWNOHtAGK6Lls8ADyu78FyTVDiE+DT9/fhTQyzJCkMvVxXqGds9DzHhmIGAbtT
	 Ja4C0IQSsWPhotPjHkx4xJtQz6C3XlQw8DAty7YMgDHw55BjSMrI5QvkljvzXBoDBK
	 7nNuOB03SOW7+ZcNRIAzSLY6QtAKqB2KdVtose4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.10 054/121] x86/hyperv: fix kexec crash due to VP assist page corruption
Date: Mon, 16 Sep 2024 13:43:48 +0200
Message-ID: <20240916114230.934349389@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>

commit b9af6418279c4cf73ca073f8ea024992b38be8ab upstream.

commit 9636be85cc5b ("x86/hyperv: Fix hyperv_pcpu_input_arg handling when
CPUs go online/offline") introduces a new cpuhp state for hyperv
initialization.

cpuhp_setup_state() returns the state number if state is
CPUHP_AP_ONLINE_DYN or CPUHP_BP_PREPARE_DYN and 0 for all other states.
For the hyperv case, since a new cpuhp state was introduced it would
return 0. However, in hv_machine_shutdown(), the cpuhp_remove_state() call
is conditioned upon "hyperv_init_cpuhp > 0". This will never be true and
so hv_cpu_die() won't be called on all CPUs. This means the VP assist page
won't be reset. When the kexec kernel tries to setup the VP assist page
again, the hypervisor corrupts the memory region of the old VP assist page
causing a panic in case the kexec kernel is using that memory elsewhere.
This was originally fixed in commit dfe94d4086e4 ("x86/hyperv: Fix kexec
panic/hang issues").

Get rid of hyperv_init_cpuhp entirely since we are no longer using a
dynamic cpuhp state and use CPUHP_AP_HYPERV_ONLINE directly with
cpuhp_remove_state().

Cc: stable@vger.kernel.org
Fixes: 9636be85cc5b ("x86/hyperv: Fix hyperv_pcpu_input_arg handling when CPUs go online/offline")
Signed-off-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/20240828112158.3538342-1-anirudh@anirudhrb.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240828112158.3538342-1-anirudh@anirudhrb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/hyperv/hv_init.c       |    5 +----
 arch/x86/include/asm/mshyperv.h |    1 -
 arch/x86/kernel/cpu/mshyperv.c  |    4 ++--
 3 files changed, 3 insertions(+), 7 deletions(-)

--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -35,7 +35,6 @@
 #include <clocksource/hyperv_timer.h>
 #include <linux/highmem.h>
 
-int hyperv_init_cpuhp;
 u64 hv_current_partition_id = ~0ull;
 EXPORT_SYMBOL_GPL(hv_current_partition_id);
 
@@ -607,8 +606,6 @@ skip_hypercall_pg_init:
 
 	register_syscore_ops(&hv_syscore_ops);
 
-	hyperv_init_cpuhp = cpuhp;
-
 	if (cpuid_ebx(HYPERV_CPUID_FEATURES) & HV_ACCESS_PARTITION_ID)
 		hv_get_partition_id();
 
@@ -637,7 +634,7 @@ skip_hypercall_pg_init:
 clean_guest_os_id:
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
 	hv_ivm_msr_write(HV_X64_MSR_GUEST_OS_ID, 0);
-	cpuhp_remove_state(cpuhp);
+	cpuhp_remove_state(CPUHP_AP_HYPERV_ONLINE);
 free_ghcb_page:
 	free_percpu(hv_ghcb_pg);
 free_vp_assist_page:
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -40,7 +40,6 @@ static inline unsigned char hv_get_nmi_r
 }
 
 #if IS_ENABLED(CONFIG_HYPERV)
-extern int hyperv_init_cpuhp;
 extern bool hyperv_paravisor_present;
 
 extern void *hv_hypercall_pg;
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -199,8 +199,8 @@ static void hv_machine_shutdown(void)
 	 * Call hv_cpu_die() on all the CPUs, otherwise later the hypervisor
 	 * corrupts the old VP Assist Pages and can crash the kexec kernel.
 	 */
-	if (kexec_in_progress && hyperv_init_cpuhp > 0)
-		cpuhp_remove_state(hyperv_init_cpuhp);
+	if (kexec_in_progress)
+		cpuhp_remove_state(CPUHP_AP_HYPERV_ONLINE);
 
 	/* The function calls stop_other_cpus(). */
 	native_machine_shutdown();


