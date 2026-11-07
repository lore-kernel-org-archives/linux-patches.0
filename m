Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063102;
	b=NFZRvMbfxQklshy5SAJASz75cNr6LxJAmNKlsScfrhdoqWlM3OXu5h1Qs+Pw043Hk1+P
	 zRHrvq4wfBuxTaIpJUb5sN8cGUdkq5qBHNE0uIpJZuZoWhG6AVvjo9XJRKc4cJurydIW0
	 9VbsykrpsR8HZRaPhmEodtj2a6yfTwpc/7OHJcSz2zsDHAYDra9DXiHXzvIFJ/roCt7PO
	 c9Co5TcxRlJ5YF1aLedcR6WU3bD+zsz+WmGyGsP3EIpDz5Gb22ju2iyBg7IyJ6AFz0g+s
	 zU5C80mCPgVH1b3oL3u9bFoiJf75HGy1aHrG5Apl8qmRexGugKX2H5HIjxtvWSMXmVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gU795GKm4k6WJ8iphR7kqVL2zGuBcZzj7UV+ElbATqc=;
	b=e6gJNJyLJ5hL/cOwnTXDOeZ/KE5yD1d0oeUm/SZA5Rds3yNeZZx6om30F+hCJ1DBRAcX
	 woPMkBi+dZQoAj4f48OxmIsV10aGn5LrgPno0fGTg+VMrvpI4lDAfNoWFNOq7fvcRTD8C
	 6wuwtp2X/2IJ0hFvTkiIhIznIjZCCOw39sDprzyCFNSEZIX4CybNUEmtX1+QoLaP+kdLl
	 L1NsA7LxvdE6RdU/NrH38OHbV70gJQKa611UdakQ8faforFVC6238+f7N9CeCS2iPYgE9
	 t3ULxsJ1owkfft5kdGxrUL9HwpGRJvqhnWxsAcIkzrsih+caGKlOMjpMeAH23py+aIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZC6kORg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFF6606D804;
	Sat,  7 Nov 2026 14:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZC6kORg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893471F0089F;
	Sat,  7 Nov 2026 14:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063101;
	bh=gU795GKm4k6WJ8iphR7kqVL2zGuBcZzj7UV+ElbATqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZC6kORgbOPGWhXYlh0HBICFPmRyaawzWBgK8utpPOG74WRCaSVI9t8jPN5sIUBDO
	 LcAo3qOrx+NSvqYWBRffKST40keOym3RF4hVzO3jrYQFA0FXw1LMr5qDgK0pnOL7qV
	 eFko0nvtwm4GyAtz1ktyqQmOuzIBkvmVf3Ph8Q1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 336/869] soc: samsung: exynos-pmu: fix error paths in cpuhotplug/idle states setup
Date: Sat,  7 Nov 2026 08:50:18 -0500
Message-ID: <20261107134903.804250720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit f7b2b6acf658be412b0c4746d07d210a9e18f13b ]

The setup_cpuhp_and_cpuidle() initialisation sequence currently ignores
the return values of cpuhp_setup_state(), cpu_pm_register_notifier(), and
register_reboot_notifier(). If any of these registrations fail during
probe() routine, the driver returns 0, leaving the driver partially
configured.

Furthermore, if anything after setup_cpuhp_and_cpuidle() fails in probe()
routine, for instance devm_mfd_add_devices(), the probe() lacks an error
path and leaves notifiers and cpu hotplug states registered.

Introduce variables for the cpu hotplug state IDs in exynos_pmu_context
struct, that should be initialised to CPUHP_INVALID by default. Check all
return codes in setup_cpuhp_and_cpuidle(), and add an error path to remove
registered states on failure. Finally, add destroy_cpuhp_and_cpuidle()
helper to safely tear down notifiers and cpu hotplug states.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260513-exynos850-cpuhotplug-v4-0-54fec5f65362@linaro.org?part=3
Fixes: 78b72897a5c8 ("soc: samsung: exynos-pmu: Enable CPU Idle for gs101")
Cc: stable@vger.kernel.org
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/20260930-exynos-pmu-cpuhp-idle-fixes-v3-1-4269d8425978@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/samsung/exynos-pmu.c | 61 +++++++++++++++++++++++++++-----
 1 file changed, 53 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
index 0fcbc08633f6b..748be7ff2affb 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -47,6 +47,8 @@ struct exynos_pmu_context {
 	unsigned long *in_cpuhp;
 	bool sys_insuspend;
 	bool sys_inreboot;
+	int cpuhp_prepare_state;
+	int cpuhp_online_state;
 };
 
 void __iomem *pmu_base_addr;
@@ -589,16 +591,55 @@ static int setup_cpuhp_and_cpuidle(struct device *dev)
 		gs101_cpuhp_pmu_online(cpu);
 
 	/* register CPU hotplug callbacks */
-	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN,	"soc/exynos-pmu:prepare",
-			  gs101_cpuhp_pmu_online, NULL);
+	pmu_context->cpuhp_prepare_state = CPUHP_INVALID;
+	pmu_context->cpuhp_online_state = CPUHP_INVALID;
 
-	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "soc/exynos-pmu:online",
-			  NULL, gs101_cpuhp_pmu_offline);
+	ret = cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "soc/exynos-pmu:prepare",
+				gs101_cpuhp_pmu_online, NULL);
+	if (ret < 0)
+		return ret;
+
+	pmu_context->cpuhp_prepare_state = ret;
+
+	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "soc/exynos-pmu:online",
+				NULL, gs101_cpuhp_pmu_offline);
+	if (ret < 0)
+		goto clean_cpuhp_state_prepare;
+
+	pmu_context->cpuhp_online_state = ret;
 
 	/* register CPU PM notifiers for cpuidle */
-	cpu_pm_register_notifier(&gs101_cpu_pm_notifier);
-	register_reboot_notifier(&exynos_cpupm_reboot_nb);
-	return 0;
+	ret = cpu_pm_register_notifier(&gs101_cpu_pm_notifier);
+	if (ret)
+		goto clean_cpuhp_states;
+
+	ret = register_reboot_notifier(&exynos_cpupm_reboot_nb);
+	if (!ret)
+		/* Success */
+		return ret;
+
+	cpu_pm_unregister_notifier(&gs101_cpu_pm_notifier);
+
+clean_cpuhp_states:
+	cpuhp_remove_state(pmu_context->cpuhp_online_state);
+	pmu_context->cpuhp_online_state = CPUHP_INVALID;
+
+clean_cpuhp_state_prepare:
+	cpuhp_remove_state(pmu_context->cpuhp_prepare_state);
+	pmu_context->cpuhp_prepare_state = CPUHP_INVALID;
+
+	return ret;
+}
+
+static void destroy_cpuhp_and_cpuidle(void)
+{
+	cpu_pm_unregister_notifier(&gs101_cpu_pm_notifier);
+	unregister_reboot_notifier(&exynos_cpupm_reboot_nb);
+
+	if (pmu_context->cpuhp_prepare_state != CPUHP_INVALID)
+		cpuhp_remove_state(pmu_context->cpuhp_prepare_state);
+	if (pmu_context->cpuhp_online_state != CPUHP_INVALID)
+		cpuhp_remove_state(pmu_context->cpuhp_online_state);
 }
 
 static int exynos_pmu_probe(struct platform_device *pdev)
@@ -669,8 +710,12 @@ static int exynos_pmu_probe(struct platform_device *pdev)
 
 	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, exynos_pmu_devs,
 				   ARRAY_SIZE(exynos_pmu_devs), NULL, 0, NULL);
-	if (ret)
+	if (ret) {
+		if (pmu_context->pmu_data && pmu_context->pmu_data->pmu_cpuhp)
+			destroy_cpuhp_and_cpuidle();
+
 		return ret;
+	}
 
 	if (devm_of_platform_populate(dev))
 		dev_err(dev, "Error populating children, reboot and poweroff might not work properly\n");
-- 
2.53.0



