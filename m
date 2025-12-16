Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34F033066D;
	Tue, 16 Dec 2025 12:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888238; cv=none; b=Kmi41e55PgtmO2yeZN31SCoSbGuA+LcbawT6b2F/dVPe56W8U1m8D4jRi1CY1MYrfbQ7gwO+IXVpGAplm99h/HEkcYpmfXk+bV8im5nM6wWAIbRt/QkQwwcgYnVSw+94eT3T7pxhczNDvy4M6QRR8npAR0qcixMYMPxBai+ibKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888238; c=relaxed/simple;
	bh=VotkHHEI0qIzWyn9UF6H+VgqkXP0mKhz8aq7C6xVQ9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScTR/cFvAYLUIX7A88NckLuDC+PacyHxtp+chePFBeXi8ipEcItou121vXSC4oqbL3v5OWcHR5NOr1jCkB5/3Ke0/KB93NDzzMEs/DM+cGPsZfE+4rprofDGdnDaOjsJZpg/iEP2B1U91qR+1t3koKjyIQOpXAp5RmXcRroL4ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnsP5mLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnsP5mLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69FEC4CEF1;
	Tue, 16 Dec 2025 12:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888238;
	bh=VotkHHEI0qIzWyn9UF6H+VgqkXP0mKhz8aq7C6xVQ9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnsP5mLoB5VnJZq72Rjr5fNjHJw/00TGRFuI5z8YTaQP0uYwXDICvYz+cbl8b5rig
	 hnQ1gOP49X60GpGjfRaM5pftWDUQjb+ofasuWCRNzu+brnDlCDUzT8Hr/FRFBFkz1D
	 hTTeTnypp4bMi7o03y/PI1F2khKofgCzdy08qf2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 473/614] soc: samsung: exynos-pmu: Fix structure initialization
Date: Tue, 16 Dec 2025 12:14:00 +0100
Message-ID: <20251216111418.507630038@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 2224ea67c75d0a0b9eaf803d0dfdab8d0c601c35 ]

Commit 78b72897a5c8 ("soc: samsung: exynos-pmu: Enable CPU Idle for
gs101") added system wide suspend/resume callbacks to Exynos PMU driver,
but some items used by these callbacks are initialized only on
GS101-compatible boards. Move that initialization to exynos_pmu_probe()
to avoid potential lockdep warnings like below observed during system
suspend/resume cycle:

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 2134 Comm: rtcwake Not tainted 6.18.0-rc7-next-20251126-00039-g1d656a1af243 #11794 PREEMPT
Hardware name: Samsung Exynos (Flattened Device Tree)
Call trace:
 unwind_backtrace from show_stack+0x10/0x14
 show_stack from dump_stack_lvl+0x68/0x88
 dump_stack_lvl from register_lock_class+0x970/0x988
 register_lock_class from __lock_acquire+0xc8/0x29ec
 __lock_acquire from lock_acquire+0x134/0x39c
 lock_acquire from _raw_spin_lock+0x38/0x48
 _raw_spin_lock from exynos_cpupm_suspend_noirq+0x18/0x34
 exynos_cpupm_suspend_noirq from dpm_run_callback+0x98/0x2b8
 dpm_run_callback from device_suspend_noirq+0x8c/0x310

Fixes: 78b72897a5c8 ("soc: samsung: exynos-pmu: Enable CPU Idle for gs101")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20251126110038.3326768-1-m.szyprowski@samsung.com
[krzk: include calltrace into commit msg]
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/samsung/exynos-pmu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
index 22c50ca2aa79b..df5b1f299a260 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -585,10 +585,6 @@ static int setup_cpuhp_and_cpuidle(struct device *dev)
 	if (!pmu_context->in_cpuhp)
 		return -ENOMEM;
 
-	raw_spin_lock_init(&pmu_context->cpupm_lock);
-	pmu_context->sys_inreboot = false;
-	pmu_context->sys_insuspend = false;
-
 	/* set PMU to power on */
 	for_each_online_cpu(cpu)
 		gs101_cpuhp_pmu_online(cpu);
@@ -657,6 +653,9 @@ static int exynos_pmu_probe(struct platform_device *pdev)
 
 	pmu_context->pmureg = regmap;
 	pmu_context->dev = dev;
+	raw_spin_lock_init(&pmu_context->cpupm_lock);
+	pmu_context->sys_inreboot = false;
+	pmu_context->sys_insuspend = false;
 
 	if (pmu_context->pmu_data && pmu_context->pmu_data->pmu_cpuhp) {
 		ret = setup_cpuhp_and_cpuidle(dev);
-- 
2.51.0



