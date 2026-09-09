Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0C8595748;
	Wed,  9 Sep 2026 14:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963568; cv=none; b=C2xZfaaVPMKZ38mvsqK+TAUR+csibF9v2QixBG7iqyLXlFaGQtW1cL7tw3WR9yoBG97fKyIzdEn4lX3n0x95wMmgDOSGUKk0ReVT1Y5McbQnZpn9Vmet1+Co+34bwerd9oVIcoojjgGg4d8BBHVvaa8Ky5DAiMfx93MT3YVZ2/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963568; c=relaxed/simple;
	bh=I5WIa43DNR5T1bpe6j96ZB79HfVqsMgo2gq2bHmw67s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAdPtJ/XwhIZaOWtry6tq2KkaPZzfVGSoris7vWuw03oJkDVN4Ll/h87SO7Bkmt8nHseK9Me/4K8HHr2UTUmlw+Lq0Ciu0xlhNAbllASoL3i/mIUrUtnXD86kj25IyGUVsxDyfFHfy9JLQuZNA5TkHQHXLgWQF8FLtaIeB8gi8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBiHji7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBiHji7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10801F00A3A;
	Wed,  9 Sep 2026 14:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963566;
	bh=qdc4j7+YAyQmcOEOk51BcgkqBT+Mh+i+IcP2mCSyd0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eBiHji7HIetbrYt76Wl1/KBNJhIPEHWsjSuhcAc+WYkZnhRFZEbRju1wAakB/rQZk
	 yN3OAKrpI6iQQiRpkCxwMeHi5jEqyrim1u4dnzzppVF+bpdRH63ldrOh4SEsvvNmq3
	 BGz0ly/b0Ffg5Q9qoYSOCQHvMwhfMdr6x/O9PP8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 075/583] cpuidle: psci: Fix support for probe deferral by dropping the faux device
Date: Wed,  9 Sep 2026 15:36:00 +0200
Message-ID: <20260909134240.685115374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Ulf Hansson <ulf.hansson@oss.qualcomm.com>

commit 0606f2114e2dc88fe293858fd991cda2688b8c3a upstream.

At the conversion to the faux driver/device we broke the support for probe
deferral. In hindsight, the move to the faux device seems questionable, as
it simply makes the code more complicated and for no good reason.

To fix the support for the probe deferral let's therefore restore the old
code and drop the faux device.

Fixes: af5376a77e87 ("cpuidle: psci: Transition to the faux device interface")
Fixes: 5836ebeb4a2b ("cpuidle: psci: Avoid initializing faux device if no DT idle states are present")
Fixes: 39cdf87a97fd ("cpuidle: psci: Fix uninitialized variable in dt_idle_state_present()")
Cc: stable@vger.kernel.org
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/cpuidle-psci.c |   42 +++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

--- a/drivers/cpuidle/cpuidle-psci.c
+++ b/drivers/cpuidle/cpuidle-psci.c
@@ -16,7 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/device/faux.h>
+#include <linux/platform_device.h>
 #include <linux/psci.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
@@ -424,14 +424,14 @@ deinit:
  * to register cpuidle driver then rollback to cancel all CPUs
  * registration.
  */
-static int psci_cpuidle_probe(struct faux_device *fdev)
+static int psci_cpuidle_probe(struct platform_device *pdev)
 {
 	int cpu, ret;
 	struct cpuidle_driver *drv;
 	struct cpuidle_device *dev;
 
 	for_each_present_cpu(cpu) {
-		ret = psci_idle_init_cpu(&fdev->dev, cpu);
+		ret = psci_idle_init_cpu(&pdev->dev, cpu);
 		if (ret)
 			goto out_fail;
 	}
@@ -451,36 +451,26 @@ out_fail:
 	return ret;
 }
 
-static struct faux_device_ops psci_cpuidle_ops = {
+static struct platform_driver psci_cpuidle_driver = {
 	.probe = psci_cpuidle_probe,
+	.driver = {
+		.name = "psci-cpuidle",
+	},
 };
 
-static bool __init dt_idle_state_present(void)
-{
-	struct device_node *cpu_node __free(device_node) =
-			of_cpu_device_node_get(cpumask_first(cpu_possible_mask));
-	if (!cpu_node)
-		return false;
-
-	struct device_node *state_node __free(device_node) =
-			of_get_cpu_state_node(cpu_node, 0);
-	if (!state_node)
-		return false;
-
-	return !!of_match_node(psci_idle_state_match, state_node);
-}
-
 static int __init psci_idle_init(void)
 {
-	struct faux_device *fdev;
+	struct platform_device *pdev;
+	int ret;
 
-	if (!dt_idle_state_present())
-		return 0;
+	ret = platform_driver_register(&psci_cpuidle_driver);
+	if (ret)
+		return ret;
 
-	fdev = faux_device_create("psci-cpuidle", NULL, &psci_cpuidle_ops);
-	if (!fdev) {
-		pr_err("Failed to create psci-cpuidle device\n");
-		return -ENODEV;
+	pdev = platform_device_register_simple("psci-cpuidle", -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		platform_driver_unregister(&psci_cpuidle_driver);
+		return PTR_ERR(pdev);
 	}
 
 	return 0;


