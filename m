Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76432857F0;
	Tue, 11 Nov 2025 01:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825190; cv=none; b=syUIrwoY8d9JphjtPtuT9gB0zLjJhqCLm39jJFzUiSd0w8JOs9N8x3Gi+f0NpOPbYrmBmwhirSsmRUUhPT3QxfmbyY52Jk6j4/BbUFaquv0F5UQKMC5ajawLPUY+BP1Qrt8xvmVASKRFCE5ciLYFJBRTgPiXVcpR+fH41VI7QOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825190; c=relaxed/simple;
	bh=AbZBVSo3tr4WDeDZSn/U7eNcfemDE24+Skdh10lmwBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwUUFI6+JPllO2AiPNS8LE9m7Zlpk2J0Rn6cqYBt0yfXaa0OWgh5px4VaDRvQVJb/FTIFCRtU4WCb1dnrbZyEIf0rjz0JvFlJuEu2xE7g6YIQOksC385wTpIXvjP0iNpiaQo8HC0AfXKJSvplmMMoJwbi72eUshzPlTi5dB6N+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weAkyNnR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weAkyNnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66555C116B1;
	Tue, 11 Nov 2025 01:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825190;
	bh=AbZBVSo3tr4WDeDZSn/U7eNcfemDE24+Skdh10lmwBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=weAkyNnRiK21/A28CpfAR42MEhlraxQE0vMrDSSpvfyyO3SheudWOXGg/IUqfYJtg
	 x1IQolW3Vuy575KF5BOTj/fMW2Rsb6RmZ/yS1gciY+6tCqr8E0y+sPAWNVC/vSbcw8
	 69YCmgRBBZ0uj+SdMFmuFObgg+2SSODDIjsCInUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 698/849] clocksource: hyper-v: Skip unnecessary checks for the root partition
Date: Tue, 11 Nov 2025 09:44:28 +0900
Message-ID: <20251111004553.308923426@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu@kernel.org>

[ Upstream commit 47691ced158ab3a7ce2189b857b19c0c99a9aa80 ]

The HV_ACCESS_TSC_INVARIANT bit is always zero when Linux runs as the
root partition. The root partition will see directly what the hardware
provides.

The old logic in ms_hyperv_init_platform caused the native TSC clock
source to be incorrectly marked as unstable on x86. Fix it.

Skip the unnecessary checks in code for the root partition. Add one
extra comment in code to clarify the behavior.

Reviewed-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mshyperv.c     | 11 ++++++++++-
 drivers/clocksource/hyperv_timer.c | 10 +++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index c78f860419d69..25773af116bc4 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -565,6 +565,11 @@ static void __init ms_hyperv_init_platform(void)
 	machine_ops.crash_shutdown = hv_machine_crash_shutdown;
 #endif
 #endif
+	/*
+	 * HV_ACCESS_TSC_INVARIANT is always zero for the root partition. Root
+	 * partition doesn't need to write to synthetic MSR to enable invariant
+	 * TSC feature. It sees what the hardware provides.
+	 */
 	if (ms_hyperv.features & HV_ACCESS_TSC_INVARIANT) {
 		/*
 		 * Writing to synthetic MSR 0x40000118 updates/changes the
@@ -636,8 +641,12 @@ static void __init ms_hyperv_init_platform(void)
 	 * TSC should be marked as unstable only after Hyper-V
 	 * clocksource has been initialized. This ensures that the
 	 * stability of the sched_clock is not altered.
+	 *
+	 * HV_ACCESS_TSC_INVARIANT is always zero for the root partition. No
+	 * need to check for it.
 	 */
-	if (!(ms_hyperv.features & HV_ACCESS_TSC_INVARIANT))
+	if (!hv_root_partition() &&
+	    !(ms_hyperv.features & HV_ACCESS_TSC_INVARIANT))
 		mark_tsc_unstable("running on Hyper-V");
 
 	hardlockup_detector_disable();
diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index 2edc13ca184e0..10356d4ec55c3 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -549,14 +549,22 @@ static void __init hv_init_tsc_clocksource(void)
 	union hv_reference_tsc_msr tsc_msr;
 
 	/*
+	 * When running as a guest partition:
+	 *
 	 * If Hyper-V offers TSC_INVARIANT, then the virtualized TSC correctly
 	 * handles frequency and offset changes due to live migration,
 	 * pause/resume, and other VM management operations.  So lower the
 	 * Hyper-V Reference TSC rating, causing the generic TSC to be used.
 	 * TSC_INVARIANT is not offered on ARM64, so the Hyper-V Reference
 	 * TSC will be preferred over the virtualized ARM64 arch counter.
+	 *
+	 * When running as the root partition:
+	 *
+	 * There is no HV_ACCESS_TSC_INVARIANT feature. Always lower the rating
+	 * of the Hyper-V Reference TSC.
 	 */
-	if (ms_hyperv.features & HV_ACCESS_TSC_INVARIANT) {
+	if ((ms_hyperv.features & HV_ACCESS_TSC_INVARIANT) ||
+	    hv_root_partition()) {
 		hyperv_cs_tsc.rating = 250;
 		hyperv_cs_msr.rating = 245;
 	}
-- 
2.51.0



