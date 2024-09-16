Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F43158A18;
	Mon, 16 Sep 2024 12:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488265; cv=none; b=Kx5Nf56ejXwE4Ezw3VItVCL2UzuQGjkKiaCsn2h0MkzzdN/rqnB0mmKyO1uEgxJrhsZq0gKw0qCWYLE/UqkOY6+xNO4Qxqxq9dSbhdzXqslr0Mwek0T2qmtISfeks3tlL7fDFL6pKqjrO8OTy6VPgg6psiuajp2QXds4hEPvrkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488265; c=relaxed/simple;
	bh=OXNGa64MhFEH3IKgQTR+pgCMuCIz9h63w/RVVtZdq7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG7asKzdMZz+T5bgWfZ+wfh5psOj4Ebnz3adc+4++SyGd4/ocnUFE9Ph9L/JvZhU0ko/YOuiB0hLyVNmV7AWHXKNC0F+BxT2FvHFUecIUYSPc69a32ug08yO9KsnjXkGPdMvnPClpEIxwUYD2Z3QBd4DcJmaxQaw3e0MBOwYFvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mulnug/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mulnug/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA8FC4CEC4;
	Mon, 16 Sep 2024 12:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488264;
	bh=OXNGa64MhFEH3IKgQTR+pgCMuCIz9h63w/RVVtZdq7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mulnug/MfA4Rm73rzyvnmRbcFF90d6uVB8m6CrlP4Xsid2bEeKQPM5z9tJG1jJwT7
	 saUWPZQSYP6fFiKVjnurXnZoCI/4vgGvGNWSN5T8NGCPXApumeO4c5teOFvKGuaEEQ
	 gSiqxq6J8W7IWNwbF2XbL2t95kYQ/oAaJWFiGgfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Kisel <romank@linux.microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.10 053/121] clocksource: hyper-v: Use lapic timer in a TDX VM without paravisor
Date: Mon, 16 Sep 2024 13:43:47 +0200
Message-ID: <20240916114230.896959629@linuxfoundation.org>
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

From: Dexuan Cui <decui@microsoft.com>

commit 7f828d5fff7d24752e1ecf6bebb6617a81f97b93 upstream.

In a TDX VM without paravisor, currently the default timer is the Hyper-V
timer, which depends on the slow VM Reference Counter MSR: the Hyper-V TSC
page is not enabled in such a VM because the VM uses Invariant TSC as a
better clocksource and it's challenging to mark the Hyper-V TSC page shared
in very early boot.

Lower the rating of the Hyper-V timer so the local APIC timer becomes the
the default timer in such a VM, and print a warning in case Invariant TSC
is unavailable in such a VM. This change should cause no perceivable
performance difference.

Cc: stable@vger.kernel.org # 6.6+
Reviewed-by: Roman Kisel <romank@linux.microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/20240621061614.8339-1-decui@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240621061614.8339-1-decui@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mshyperv.c     |   16 +++++++++++++++-
 drivers/clocksource/hyperv_timer.c |   16 +++++++++++++++-
 2 files changed, 30 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -449,9 +449,23 @@ static void __init ms_hyperv_init_platfo
 			ms_hyperv.hints &= ~HV_X64_APIC_ACCESS_RECOMMENDED;
 
 			if (!ms_hyperv.paravisor_present) {
-				/* To be supported: more work is required.  */
+				/*
+				 * Mark the Hyper-V TSC page feature as disabled
+				 * in a TDX VM without paravisor so that the
+				 * Invariant TSC, which is a better clocksource
+				 * anyway, is used instead.
+				 */
 				ms_hyperv.features &= ~HV_MSR_REFERENCE_TSC_AVAILABLE;
 
+				/*
+				 * The Invariant TSC is expected to be available
+				 * in a TDX VM without paravisor, but if not,
+				 * print a warning message. The slower Hyper-V MSR-based
+				 * Ref Counter should end up being the clocksource.
+				 */
+				if (!(ms_hyperv.features & HV_ACCESS_TSC_INVARIANT))
+					pr_warn("Hyper-V: Invariant TSC is unavailable\n");
+
 				/* HV_MSR_CRASH_CTL is unsupported. */
 				ms_hyperv.misc_features &= ~HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
 
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -137,7 +137,21 @@ static int hv_stimer_init(unsigned int c
 	ce->name = "Hyper-V clockevent";
 	ce->features = CLOCK_EVT_FEAT_ONESHOT;
 	ce->cpumask = cpumask_of(cpu);
-	ce->rating = 1000;
+
+	/*
+	 * Lower the rating of the Hyper-V timer in a TDX VM without paravisor,
+	 * so the local APIC timer (lapic_clockevent) is the default timer in
+	 * such a VM. The Hyper-V timer is not preferred in such a VM because
+	 * it depends on the slow VM Reference Counter MSR (the Hyper-V TSC
+	 * page is not enbled in such a VM because the VM uses Invariant TSC
+	 * as a better clocksource and it's challenging to mark the Hyper-V
+	 * TSC page shared in very early boot).
+	 */
+	if (!ms_hyperv.paravisor_present && hv_isolation_type_tdx())
+		ce->rating = 90;
+	else
+		ce->rating = 1000;
+
 	ce->set_state_shutdown = hv_ce_shutdown;
 	ce->set_state_oneshot = hv_ce_set_oneshot;
 	ce->set_next_event = hv_ce_set_next_event;


