Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C62A269894;
	Tue,  8 Apr 2025 11:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110395; cv=none; b=kbyr6ej2d7i6lbCD5lUO9a4asaTLOF/zzTSbfZ/rU1WyB0t0Rlfn19Qplcqx1Ct5ZrirrL/ioy5BOtVXqoBaloM5fZeJV2GwifW/t/3vrwGy4dyowudf3rmYn5a6KWjHZ0+M8SglYQrUbfqrVUpUGysx//dnkYaWMUcYp6MBNTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110395; c=relaxed/simple;
	bh=+NHQUS/kS3F3ca342vX3cIaIGLimSIqvEKdRfV7H6Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXf6fvfURojoLhHljK3ivs1oqTv5MdkOo2nNF0fQmLmSPQmpLgw0WHXZRQZf3gsH42nPBabQyMA6QsUAHdAkMSRgaqm76OzcCHxJf0ZielJnqy927AwTjdG87LIoQ4184qeMFQ08XSYkJjZ3o6Lj2uZ302G+/IdrKqmTk/5vb1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LS76Gmvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LS76Gmvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C9CC4CEE5;
	Tue,  8 Apr 2025 11:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110393;
	bh=+NHQUS/kS3F3ca342vX3cIaIGLimSIqvEKdRfV7H6Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LS76Gmvt5Szg3Qh7CQ4mbdKyHYdt4pAjSW3a7PfInuIVZTvgB2mpqG0NrhHxQMCH8
	 mo6F73YtN6NHUlTECOdRHj0X6dpZuDinrAyxhCqo3exz0haceV1v4y+fW6Z0jah0m+
	 4Bhr+j/LelSWnaG2wAiwi9eInt19qJsjL/ni56dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Yuanjie Yang <quic_yuanjiey@quicinc.com>,
	Jacky Bai <ping.bai@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 040/731] cpuidle: Init cpuidle only for present CPUs
Date: Tue,  8 Apr 2025 12:38:57 +0200
Message-ID: <20250408104915.209645304@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Bai <ping.bai@nxp.com>

[ Upstream commit 68cb0139fec8e05b93978dc0ef1bc8df90a86419 ]

for_each_possible_cpu() is currently used to initialize cpuidle
in below cpuidle drivers:
  drivers/cpuidle/cpuidle-arm.c
  drivers/cpuidle/cpuidle-big_little.c
  drivers/cpuidle/cpuidle-psci.c
  drivers/cpuidle/cpuidle-qcom-spm.c
  drivers/cpuidle/cpuidle-riscv-sbi.c

However, in cpu_dev_register_generic(), for_each_present_cpu()
is used to register CPU devices which means the CPU devices are
only registered for present CPUs and not all possible CPUs.

With nosmp or maxcpus=0, only the boot CPU is present, lead
to the failure:

  |  Failed to register cpuidle device for cpu1

Then rollback to cancel all CPUs' cpuidle registration.

Change for_each_possible_cpu() to for_each_present_cpu() in the
above cpuidle drivers to ensure it only registers cpuidle devices
for CPUs that are actually present.

Fixes: b0c69e1214bc ("drivers: base: Use present CPUs in GENERIC_CPU_DEVICES")
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Yuanjie Yang <quic_yuanjiey@quicinc.com>
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://patch.msgid.link/20250307145547.2784821-1-ping.bai@nxp.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-arm.c        | 8 ++++----
 drivers/cpuidle/cpuidle-big_little.c | 2 +-
 drivers/cpuidle/cpuidle-psci.c       | 4 ++--
 drivers/cpuidle/cpuidle-qcom-spm.c   | 2 +-
 drivers/cpuidle/cpuidle-riscv-sbi.c  | 4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-arm.c b/drivers/cpuidle/cpuidle-arm.c
index caba6f4bb1b79..e044fefdb8167 100644
--- a/drivers/cpuidle/cpuidle-arm.c
+++ b/drivers/cpuidle/cpuidle-arm.c
@@ -137,9 +137,9 @@ static int __init arm_idle_init_cpu(int cpu)
 /*
  * arm_idle_init - Initializes arm cpuidle driver
  *
- * Initializes arm cpuidle driver for all CPUs, if any CPU fails
- * to register cpuidle driver then rollback to cancel all CPUs
- * registration.
+ * Initializes arm cpuidle driver for all present CPUs, if any
+ * CPU fails to register cpuidle driver then rollback to cancel
+ * all CPUs registration.
  */
 static int __init arm_idle_init(void)
 {
@@ -147,7 +147,7 @@ static int __init arm_idle_init(void)
 	struct cpuidle_driver *drv;
 	struct cpuidle_device *dev;
 
-	for_each_possible_cpu(cpu) {
+	for_each_present_cpu(cpu) {
 		ret = arm_idle_init_cpu(cpu);
 		if (ret)
 			goto out_fail;
diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
index 74972deda0ead..4abba42fcc311 100644
--- a/drivers/cpuidle/cpuidle-big_little.c
+++ b/drivers/cpuidle/cpuidle-big_little.c
@@ -148,7 +148,7 @@ static int __init bl_idle_driver_init(struct cpuidle_driver *drv, int part_id)
 	if (!cpumask)
 		return -ENOMEM;
 
-	for_each_possible_cpu(cpu)
+	for_each_present_cpu(cpu)
 		if (smp_cpuid_part(cpu) == part_id)
 			cpumask_set_cpu(cpu, cpumask);
 
diff --git a/drivers/cpuidle/cpuidle-psci.c b/drivers/cpuidle/cpuidle-psci.c
index 2562dc001fc1d..a4594c3d6562d 100644
--- a/drivers/cpuidle/cpuidle-psci.c
+++ b/drivers/cpuidle/cpuidle-psci.c
@@ -400,7 +400,7 @@ static int psci_idle_init_cpu(struct device *dev, int cpu)
 /*
  * psci_idle_probe - Initializes PSCI cpuidle driver
  *
- * Initializes PSCI cpuidle driver for all CPUs, if any CPU fails
+ * Initializes PSCI cpuidle driver for all present CPUs, if any CPU fails
  * to register cpuidle driver then rollback to cancel all CPUs
  * registration.
  */
@@ -410,7 +410,7 @@ static int psci_cpuidle_probe(struct platform_device *pdev)
 	struct cpuidle_driver *drv;
 	struct cpuidle_device *dev;
 
-	for_each_possible_cpu(cpu) {
+	for_each_present_cpu(cpu) {
 		ret = psci_idle_init_cpu(&pdev->dev, cpu);
 		if (ret)
 			goto out_fail;
diff --git a/drivers/cpuidle/cpuidle-qcom-spm.c b/drivers/cpuidle/cpuidle-qcom-spm.c
index 3ab240e0e1229..5f386761b1562 100644
--- a/drivers/cpuidle/cpuidle-qcom-spm.c
+++ b/drivers/cpuidle/cpuidle-qcom-spm.c
@@ -135,7 +135,7 @@ static int spm_cpuidle_drv_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "set warm boot addr failed");
 
-	for_each_possible_cpu(cpu) {
+	for_each_present_cpu(cpu) {
 		ret = spm_cpuidle_register(&pdev->dev, cpu);
 		if (ret && ret != -ENODEV) {
 			dev_err(&pdev->dev,
diff --git a/drivers/cpuidle/cpuidle-riscv-sbi.c b/drivers/cpuidle/cpuidle-riscv-sbi.c
index 0c92a628bbd40..0fe1ece9fbdca 100644
--- a/drivers/cpuidle/cpuidle-riscv-sbi.c
+++ b/drivers/cpuidle/cpuidle-riscv-sbi.c
@@ -529,8 +529,8 @@ static int sbi_cpuidle_probe(struct platform_device *pdev)
 			return ret;
 	}
 
-	/* Initialize CPU idle driver for each CPU */
-	for_each_possible_cpu(cpu) {
+	/* Initialize CPU idle driver for each present CPU */
+	for_each_present_cpu(cpu) {
 		ret = sbi_cpuidle_init_cpu(&pdev->dev, cpu);
 		if (ret) {
 			pr_debug("HART%ld: idle driver init failed\n",
-- 
2.39.5



