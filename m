Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062E615884E;
	Tue,  9 Jul 2024 11:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523784; cv=none; b=SNZPDG1Ln7HsfYS87Ep6KSJzddQhPYqNF9U2DFdnQ/QPGnHXov9PnTXgsJMO0COMk0jAc2leqkEZHAnNltahY1CseKRX1ikJix8/bNbryuw3Y65m6GIop+IaBl2Uy+iBaJNX0VeIKe4Vpg+Lstv1BwqoDv1AYGZL2F1SS22CmK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523784; c=relaxed/simple;
	bh=llCRE0DQaskomsa9CYbL2yy1S+UDqKHNPV8kSuSRRV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/cKZakBSuQdsfrFHLBk456EdiGm69FSp6RgpKHC+z/i/g9V0M+C1hEm0GxAb0DgSXB1j6PnhtmUAfjpfC5hnXQQHiOpVYhJm2EmUKjts0qW2I6Kn/6uy8k4RdQueboH6tq2uIPWltYYLltXXp6XLY10Fx5e/OiiYnpHk71C/KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Za2W+YP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Za2W+YP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F92C3277B;
	Tue,  9 Jul 2024 11:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523783;
	bh=llCRE0DQaskomsa9CYbL2yy1S+UDqKHNPV8kSuSRRV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Za2W+YP3YTEtoluhwxtZuP0LNzARpYUwtSfASTMRZw7sXfB6ENoqkqh6dfuELWuA3
	 vw1te5mnNKi2trAZqOeRAA9R6extxc+lf4U++qXlVVpolcS84WhzZFNJ6L5BNqVALg
	 SuMOGYR7gFS8gpfPJ14042jx32saL46LvVb0bNaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Gautam Menghani <gautam@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.6 107/139] powerpc/pseries: Fix scv instruction crash with kexec
Date: Tue,  9 Jul 2024 13:10:07 +0200
Message-ID: <20240709110702.309851727@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

commit 21a741eb75f80397e5f7d3739e24d7d75e619011 upstream.

kexec on pseries disables AIL (reloc_on_exc), required for scv
instruction support, before other CPUs have been shut down. This means
they can execute scv instructions after AIL is disabled, which causes an
interrupt at an unexpected entry location that crashes the kernel.

Change the kexec sequence to disable AIL after other CPUs have been
brought down.

As a refresher, the real-mode scv interrupt vector is 0x17000, and the
fixed-location head code probably couldn't easily deal with implementing
such high addresses so it was just decided not to support that interrupt
at all.

Fixes: 7fa95f9adaee ("powerpc/64s: system call support for scv/rfscv instructions")
Cc: stable@vger.kernel.org # v5.9+
Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Closes: https://lore.kernel.org/3b4b2943-49ad-4619-b195-bc416f1d1409@linux.ibm.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Gautam Menghani <gautam@linux.ibm.com>
Tested-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Link: https://msgid.link/20240625134047.298759-1-npiggin@gmail.com
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kexec/core_64.c             |   11 +++++++++++
 arch/powerpc/platforms/pseries/kexec.c   |    8 --------
 arch/powerpc/platforms/pseries/pseries.h |    1 -
 arch/powerpc/platforms/pseries/setup.c   |    1 -
 4 files changed, 11 insertions(+), 10 deletions(-)

--- a/arch/powerpc/kexec/core_64.c
+++ b/arch/powerpc/kexec/core_64.c
@@ -26,6 +26,7 @@
 #include <asm/paca.h>
 #include <asm/mmu.h>
 #include <asm/sections.h>	/* _end */
+#include <asm/setup.h>
 #include <asm/smp.h>
 #include <asm/hw_breakpoint.h>
 #include <asm/svm.h>
@@ -316,6 +317,16 @@ void default_machine_kexec(struct kimage
 	if (!kdump_in_progress())
 		kexec_prepare_cpus();
 
+#ifdef CONFIG_PPC_PSERIES
+	/*
+	 * This must be done after other CPUs have shut down, otherwise they
+	 * could execute the 'scv' instruction, which is not supported with
+	 * reloc disabled (see configure_exceptions()).
+	 */
+	if (firmware_has_feature(FW_FEATURE_SET_MODE))
+		pseries_disable_reloc_on_exc();
+#endif
+
 	printk("kexec: Starting switchover sequence.\n");
 
 	/* switch to a staticly allocated stack.  Based on irq stack code.
--- a/arch/powerpc/platforms/pseries/kexec.c
+++ b/arch/powerpc/platforms/pseries/kexec.c
@@ -61,11 +61,3 @@ void pseries_kexec_cpu_down(int crash_sh
 	} else
 		xics_kexec_teardown_cpu(secondary);
 }
-
-void pseries_machine_kexec(struct kimage *image)
-{
-	if (firmware_has_feature(FW_FEATURE_SET_MODE))
-		pseries_disable_reloc_on_exc();
-
-	default_machine_kexec(image);
-}
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -38,7 +38,6 @@ static inline void smp_init_pseries(void
 #endif
 
 extern void pseries_kexec_cpu_down(int crash_shutdown, int secondary);
-void pseries_machine_kexec(struct kimage *image);
 
 extern void pSeries_final_fixup(void);
 
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -1153,7 +1153,6 @@ define_machine(pseries) {
 	.machine_check_exception = pSeries_machine_check_exception,
 	.machine_check_log_err	= pSeries_machine_check_log_err,
 #ifdef CONFIG_KEXEC_CORE
-	.machine_kexec          = pseries_machine_kexec,
 	.kexec_cpu_down         = pseries_kexec_cpu_down,
 #endif
 #ifdef CONFIG_MEMORY_HOTPLUG


