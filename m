Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8EC1E525;
	Mon,  1 Apr 2024 16:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989468; cv=none; b=BNB1cgO9AK3Pto7W2LES19BzL9KZCBxciKFom8+CYW2HLgCBdnixdRJwzfwZwqp1czC4gLh61xgHK9vbN42P7znhaMtPVGEsdXrgDJ05NVBFKal1Nu4qYsghAWGzHY0vH8pWE1sDTXF7YL/XyKk3NSqEz93q1RHyzkKZrCHJP0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989468; c=relaxed/simple;
	bh=JDSWNQ2FvrFcrp+jfq3d8KPj5qg8zPGUjYrczqUrs+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujMfV6lFUy41NELvIUrdeJ3BpyVaLwv9kDHzAa5mE/10WCSpTm0vGhjaCEGm/oM/IAAzvBs+EhiCyhlWZrm0ZHJgGPue/euwDXHNllWxFzxiYroAxtMurMB59xHQnQ+bD1XDrrN2QsDZpHd6u0GNArSz6r5nou/uzvfzCdmyFEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zABx2aj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zABx2aj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD92C433F1;
	Mon,  1 Apr 2024 16:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989468;
	bh=JDSWNQ2FvrFcrp+jfq3d8KPj5qg8zPGUjYrczqUrs+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zABx2aj058QJECC9W0Fo+HZXOLW1hAYEczvKVZc6ohIpbe1qDXL6uvOosRKqSRt7Z
	 Z/xH3bKFM7iQesj9bv+GNcXzksgJzP1++VevrkQ02Emu0GO4PsQL6hXCwgC3jEapMB
	 i0DJGZOnTfbaakn+xmddhY2GEUbLC0681qfLyu5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/396] thermal/intel: Fix intel_tcc_get_temp() to support negative CPU temperature
Date: Mon,  1 Apr 2024 17:41:18 +0200
Message-ID: <20240401152548.773913259@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 7251b9e8a007ddd834aa81f8c7ea338884629fec ]

CPU temperature can be negative in some cases. Thus the negative CPU
temperature should not be considered as a failure.

Fix intel_tcc_get_temp() and its users to support negative CPU
temperature.

Fixes: a3c1f066e1c5 ("thermal/intel: Introduce Intel TCC library")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Cc: 6.3+ <stable@vger.kernel.org> # 6.3+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/int340x_thermal/processor_thermal_device.c |  8 ++++----
 drivers/thermal/intel/intel_tcc.c                    | 12 ++++++------
 drivers/thermal/intel/x86_pkg_temp_thermal.c         |  8 ++++----
 include/linux/intel_tcc.h                            |  2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index 3ca0a2f5937f2..cdf88cadfc4f1 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -113,14 +113,14 @@ static int proc_thermal_get_zone_temp(struct thermal_zone_device *zone,
 					 int *temp)
 {
 	int cpu;
-	int curr_temp;
+	int curr_temp, ret;
 
 	*temp = 0;
 
 	for_each_online_cpu(cpu) {
-		curr_temp = intel_tcc_get_temp(cpu, false);
-		if (curr_temp < 0)
-			return curr_temp;
+		ret = intel_tcc_get_temp(cpu, &curr_temp, false);
+		if (ret < 0)
+			return ret;
 		if (!*temp || curr_temp > *temp)
 			*temp = curr_temp;
 	}
diff --git a/drivers/thermal/intel/intel_tcc.c b/drivers/thermal/intel/intel_tcc.c
index 2e5c741c41ca0..5e8b7f34b3951 100644
--- a/drivers/thermal/intel/intel_tcc.c
+++ b/drivers/thermal/intel/intel_tcc.c
@@ -103,18 +103,19 @@ EXPORT_SYMBOL_NS_GPL(intel_tcc_set_offset, INTEL_TCC);
 /**
  * intel_tcc_get_temp() - returns the current temperature
  * @cpu: cpu that the MSR should be run on, nagative value means any cpu.
+ * @temp: pointer to the memory for saving cpu temperature.
  * @pkg: true: Package Thermal Sensor. false: Core Thermal Sensor.
  *
  * Get the current temperature returned by the CPU core/package level
  * thermal sensor, in degrees C.
  *
- * Return: Temperature in degrees C on success, negative error code otherwise.
+ * Return: 0 on success, negative error code otherwise.
  */
-int intel_tcc_get_temp(int cpu, bool pkg)
+int intel_tcc_get_temp(int cpu, int *temp, bool pkg)
 {
 	u32 low, high;
 	u32 msr = pkg ? MSR_IA32_PACKAGE_THERM_STATUS : MSR_IA32_THERM_STATUS;
-	int tjmax, temp, err;
+	int tjmax, err;
 
 	tjmax = intel_tcc_get_tjmax(cpu);
 	if (tjmax < 0)
@@ -131,9 +132,8 @@ int intel_tcc_get_temp(int cpu, bool pkg)
 	if (!(low & BIT(31)))
 		return -ENODATA;
 
-	temp = tjmax - ((low >> 16) & 0x7f);
+	*temp = tjmax - ((low >> 16) & 0x7f);
 
-	/* Do not allow negative CPU temperature */
-	return temp >= 0 ? temp : -ENODATA;
+	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(intel_tcc_get_temp, INTEL_TCC);
diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
index 11a7f8108bbbf..61c3d450ee605 100644
--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -108,11 +108,11 @@ static struct zone_device *pkg_temp_thermal_get_dev(unsigned int cpu)
 static int sys_get_curr_temp(struct thermal_zone_device *tzd, int *temp)
 {
 	struct zone_device *zonedev = thermal_zone_device_priv(tzd);
-	int val;
+	int val, ret;
 
-	val = intel_tcc_get_temp(zonedev->cpu, true);
-	if (val < 0)
-		return val;
+	ret = intel_tcc_get_temp(zonedev->cpu, &val, true);
+	if (ret < 0)
+		return ret;
 
 	*temp = val * 1000;
 	pr_debug("sys_get_curr_temp %d\n", *temp);
diff --git a/include/linux/intel_tcc.h b/include/linux/intel_tcc.h
index f422612c28d6b..8ff8eabb4a987 100644
--- a/include/linux/intel_tcc.h
+++ b/include/linux/intel_tcc.h
@@ -13,6 +13,6 @@
 int intel_tcc_get_tjmax(int cpu);
 int intel_tcc_get_offset(int cpu);
 int intel_tcc_set_offset(int cpu, int offset);
-int intel_tcc_get_temp(int cpu, bool pkg);
+int intel_tcc_get_temp(int cpu, int *temp, bool pkg);
 
 #endif /* __INTEL_TCC_H__ */
-- 
2.43.0



