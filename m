Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31D64315A;
	Sun,  7 Sep 2025 20:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277474; cv=none; b=bJvZtqZzbnU29VMBpHO+U/inp3uWe3u44VBbRFdQq7+SyPLb8OA+sEwtYUsShYNRO4ts5XHYmIIy4aZw6t8d40nLkEk0qtqIkGLJH0U4hzWhOYL3j1iygF6ThWFAaRdMnbEKbuWJvJwR54vBPL6yY2mdKyvs9q9VwMOYPPhY39c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277474; c=relaxed/simple;
	bh=n4ajM+P8hZq02rx4s9zdL+D6rWCbNtB4OBF2C2YaGuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDtBERpFS4KXePEDy8GNfJyGXsuUc695Fm2hmuNRoVSh2ik9qc4e0+uFQHDRYw8UKmgx98hpgqbkPLrLPqvdoSaA/DoU0uItDN4bxMmYCM9qJjBmIZsxF0wpTN4+5HHm13ViB6EBwE0tWG7HwTV2GW2VaMEeBOVDGR6YpY9HP9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2BUQhM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2BUQhM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272DCC4CEF0;
	Sun,  7 Sep 2025 20:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277474;
	bh=n4ajM+P8hZq02rx4s9zdL+D6rWCbNtB4OBF2C2YaGuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2BUQhM3zh94zxvAjASkeFASHixP9IVNacUrJaUWQ/FsOxSCzxaIEmiFIxDAr08w6
	 VEnoPEFED0Xw6dHiVvk7FdpK+6TgS2tS7uBRxYpDJ5Ja3BKurKt85Ypr6gUb5bv7Tk
	 Wlo1Qgol5dxoINZJt43uQLinFAWh6Kt38Qzgx5ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianglai Li <lixianglai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 009/183] LoongArch: Add cpuhotplug hooks to fix high cpu usage of vCPU threads
Date: Sun,  7 Sep 2025 21:57:16 +0200
Message-ID: <20250907195616.014886509@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianglai Li <lixianglai@loongson.cn>

[ Upstream commit 8ef7f3132e4005a103b382e71abea7ad01fbeb86 ]

When the CPU is offline, the timer of LoongArch is not correctly closed.
This is harmless for real machines, but resulting in an excessively high
cpu usage rate of the offline vCPU thread in the virtual machines.

To correctly close the timer, we have made the following modifications:

Register the cpu hotplug event (CPUHP_AP_LOONGARCH_ARCH_TIMER_STARTING)
for LoongArch. This event's hooks will be called to close the timer when
the CPU is offline.

Clear the timer interrupt when the timer is turned off. Since before the
timer is turned off, there may be a timer interrupt that has already been
in the pending state due to the interruption of the disabled, which also
affects the halt state of the offline vCPU.

Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/time.c | 22 ++++++++++++++++++++++
 include/linux/cpuhotplug.h   |  1 +
 2 files changed, 23 insertions(+)

diff --git a/arch/loongarch/kernel/time.c b/arch/loongarch/kernel/time.c
index 367906b10f810..f3092f2de8b50 100644
--- a/arch/loongarch/kernel/time.c
+++ b/arch/loongarch/kernel/time.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
  */
 #include <linux/clockchips.h>
+#include <linux/cpuhotplug.h>
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/init.h>
@@ -102,6 +103,23 @@ static int constant_timer_next_event(unsigned long delta, struct clock_event_dev
 	return 0;
 }
 
+static int arch_timer_starting(unsigned int cpu)
+{
+	set_csr_ecfg(ECFGF_TIMER);
+
+	return 0;
+}
+
+static int arch_timer_dying(unsigned int cpu)
+{
+	constant_set_state_shutdown(this_cpu_ptr(&constant_clockevent_device));
+
+	/* Clear Timer Interrupt */
+	write_csr_tintclear(CSR_TINTCLR_TI);
+
+	return 0;
+}
+
 static unsigned long get_loops_per_jiffy(void)
 {
 	unsigned long lpj = (unsigned long)const_clock_freq;
@@ -172,6 +190,10 @@ int constant_clockevent_init(void)
 	lpj_fine = get_loops_per_jiffy();
 	pr_info("Constant clock event device register\n");
 
+	cpuhp_setup_state(CPUHP_AP_LOONGARCH_ARCH_TIMER_STARTING,
+			  "clockevents/loongarch/timer:starting",
+			  arch_timer_starting, arch_timer_dying);
+
 	return 0;
 }
 
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index df366ee15456b..e62064cb9e08a 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -169,6 +169,7 @@ enum cpuhp_state {
 	CPUHP_AP_QCOM_TIMER_STARTING,
 	CPUHP_AP_TEGRA_TIMER_STARTING,
 	CPUHP_AP_ARMADA_TIMER_STARTING,
+	CPUHP_AP_LOONGARCH_ARCH_TIMER_STARTING,
 	CPUHP_AP_MIPS_GIC_TIMER_STARTING,
 	CPUHP_AP_ARC_TIMER_STARTING,
 	CPUHP_AP_REALTEK_TIMER_STARTING,
-- 
2.50.1



