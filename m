Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B308F5C;
	Mon,  1 Apr 2024 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987930; cv=none; b=TIfZMAJGj+0NUyveLuseHIlHds28S5Js4CHqUM7FipcczUTd/vB72PaHyZrzhN4qsNGZTKhfe5OwFTmMLM8iyMpz1tgwGiKr6D90NVMCLnrqo2olMRd52YXQUb+FDditeXh8BPdqjQ5lQVP3sGCHcjWpwUECfTz+VaPGwFSjo3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987930; c=relaxed/simple;
	bh=VBr4k26UrpuESnoTl5+LjlVMXVLIBsfXGWx2fa8U5ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siEZOSw1jtWe0gzY7ar/hD0fPveHJXmSY1/P09hFmWAudLK3OW7V5dbFdMxtuMPYg+08Bo3SFy6WCz6HG2UULxV6cYcVLEJNv2AZpgm5cdC6wnBtRZyq4kj43maXhS04kywdy2A05mKLI0jIZT4u0rRMNZkMLslLFPgE1hwqhtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lc/6RJem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lc/6RJem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B44C433F1;
	Mon,  1 Apr 2024 16:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987929;
	bh=VBr4k26UrpuESnoTl5+LjlVMXVLIBsfXGWx2fa8U5ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lc/6RJemYb7FtEufudvwpyyhHpo7UbFbEVwglWaYq0zAt2WLUI/W4of2bhPFSBUPG
	 82MOBhTX5vBzqRrPvcVWApoGxizqIFHRMqcN2sf7p2GtnvESOfaTUUwe9s186Gjvks
	 PONgjvJhfTw5dTIzxv6SSj/v2A1HVOCX+aPsf5LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 033/432] powercap: intel_rapl: Fix locking in TPMI RAPL
Date: Mon,  1 Apr 2024 17:40:20 +0200
Message-ID: <20240401152554.120658408@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 1aa09b9379a7a644cd2f75ae0bac82b8783df600 ]

The RAPL framework uses CPU hotplug locking to protect the rapl_packages
list and rp->lead_cpu to guarantee that

 1. the RAPL package device is not unprobed and freed
 2. the cached rp->lead_cpu is always valid

for operations like powercap sysfs accesses.

Current RAPL APIs assume being called from CPU hotplug callbacks which
hold the CPU hotplug lock, but TPMI RAPL driver invokes the APIs in the
driver's .probe() function without acquiring the CPU hotplug lock.

Fix the problem by providing both locked and lockless versions of RAPL
APIs.

Fixes: 9eef7f9da928 ("powercap: intel_rapl: Introduce RAPL TPMI interface driver")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: 6.5+ <stable@vger.kernel.org> # 6.5+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c          | 29 +++++++++++++++++--
 drivers/powercap/intel_rapl_msr.c             |  8 ++---
 .../int340x_thermal/processor_thermal_rapl.c  |  8 ++---
 include/linux/intel_rapl.h                    |  6 ++++
 4 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 1a739afd47d96..9d3e102f1a76b 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -5,6 +5,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cleanup.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/list.h>
@@ -1504,7 +1505,7 @@ static int rapl_detect_domains(struct rapl_package *rp)
 }
 
 /* called from CPU hotplug notifier, hotplug lock held */
-void rapl_remove_package(struct rapl_package *rp)
+void rapl_remove_package_cpuslocked(struct rapl_package *rp)
 {
 	struct rapl_domain *rd, *rd_package = NULL;
 
@@ -1533,10 +1534,18 @@ void rapl_remove_package(struct rapl_package *rp)
 	list_del(&rp->plist);
 	kfree(rp);
 }
+EXPORT_SYMBOL_GPL(rapl_remove_package_cpuslocked);
+
+void rapl_remove_package(struct rapl_package *rp)
+{
+	guard(cpus_read_lock)();
+	rapl_remove_package_cpuslocked(rp);
+}
 EXPORT_SYMBOL_GPL(rapl_remove_package);
 
 /* caller to ensure CPU hotplug lock is held */
-struct rapl_package *rapl_find_package_domain(int id, struct rapl_if_priv *priv, bool id_is_cpu)
+struct rapl_package *rapl_find_package_domain_cpuslocked(int id, struct rapl_if_priv *priv,
+							 bool id_is_cpu)
 {
 	struct rapl_package *rp;
 	int uid;
@@ -1554,10 +1563,17 @@ struct rapl_package *rapl_find_package_domain(int id, struct rapl_if_priv *priv,
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(rapl_find_package_domain_cpuslocked);
+
+struct rapl_package *rapl_find_package_domain(int id, struct rapl_if_priv *priv, bool id_is_cpu)
+{
+	guard(cpus_read_lock)();
+	return rapl_find_package_domain_cpuslocked(id, priv, id_is_cpu);
+}
 EXPORT_SYMBOL_GPL(rapl_find_package_domain);
 
 /* called from CPU hotplug notifier, hotplug lock held */
-struct rapl_package *rapl_add_package(int id, struct rapl_if_priv *priv, bool id_is_cpu)
+struct rapl_package *rapl_add_package_cpuslocked(int id, struct rapl_if_priv *priv, bool id_is_cpu)
 {
 	struct rapl_package *rp;
 	int ret;
@@ -1603,6 +1619,13 @@ struct rapl_package *rapl_add_package(int id, struct rapl_if_priv *priv, bool id
 	kfree(rp);
 	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL_GPL(rapl_add_package_cpuslocked);
+
+struct rapl_package *rapl_add_package(int id, struct rapl_if_priv *priv, bool id_is_cpu)
+{
+	guard(cpus_read_lock)();
+	return rapl_add_package_cpuslocked(id, priv, id_is_cpu);
+}
 EXPORT_SYMBOL_GPL(rapl_add_package);
 
 static void power_limit_state_save(void)
diff --git a/drivers/powercap/intel_rapl_msr.c b/drivers/powercap/intel_rapl_msr.c
index 250bd41a588c7..b4b6930cacb0b 100644
--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -73,9 +73,9 @@ static int rapl_cpu_online(unsigned int cpu)
 {
 	struct rapl_package *rp;
 
-	rp = rapl_find_package_domain(cpu, rapl_msr_priv, true);
+	rp = rapl_find_package_domain_cpuslocked(cpu, rapl_msr_priv, true);
 	if (!rp) {
-		rp = rapl_add_package(cpu, rapl_msr_priv, true);
+		rp = rapl_add_package_cpuslocked(cpu, rapl_msr_priv, true);
 		if (IS_ERR(rp))
 			return PTR_ERR(rp);
 	}
@@ -88,14 +88,14 @@ static int rapl_cpu_down_prep(unsigned int cpu)
 	struct rapl_package *rp;
 	int lead_cpu;
 
-	rp = rapl_find_package_domain(cpu, rapl_msr_priv, true);
+	rp = rapl_find_package_domain_cpuslocked(cpu, rapl_msr_priv, true);
 	if (!rp)
 		return 0;
 
 	cpumask_clear_cpu(cpu, &rp->cpumask);
 	lead_cpu = cpumask_first(&rp->cpumask);
 	if (lead_cpu >= nr_cpu_ids)
-		rapl_remove_package(rp);
+		rapl_remove_package_cpuslocked(rp);
 	else if (rp->lead_cpu == cpu)
 		rp->lead_cpu = lead_cpu;
 	return 0;
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c
index 2f00fc3bf274a..e964a9375722a 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c
@@ -27,9 +27,9 @@ static int rapl_mmio_cpu_online(unsigned int cpu)
 	if (topology_physical_package_id(cpu))
 		return 0;
 
-	rp = rapl_find_package_domain(cpu, &rapl_mmio_priv, true);
+	rp = rapl_find_package_domain_cpuslocked(cpu, &rapl_mmio_priv, true);
 	if (!rp) {
-		rp = rapl_add_package(cpu, &rapl_mmio_priv, true);
+		rp = rapl_add_package_cpuslocked(cpu, &rapl_mmio_priv, true);
 		if (IS_ERR(rp))
 			return PTR_ERR(rp);
 	}
@@ -42,14 +42,14 @@ static int rapl_mmio_cpu_down_prep(unsigned int cpu)
 	struct rapl_package *rp;
 	int lead_cpu;
 
-	rp = rapl_find_package_domain(cpu, &rapl_mmio_priv, true);
+	rp = rapl_find_package_domain_cpuslocked(cpu, &rapl_mmio_priv, true);
 	if (!rp)
 		return 0;
 
 	cpumask_clear_cpu(cpu, &rp->cpumask);
 	lead_cpu = cpumask_first(&rp->cpumask);
 	if (lead_cpu >= nr_cpu_ids)
-		rapl_remove_package(rp);
+		rapl_remove_package_cpuslocked(rp);
 	else if (rp->lead_cpu == cpu)
 		rp->lead_cpu = lead_cpu;
 	return 0;
diff --git a/include/linux/intel_rapl.h b/include/linux/intel_rapl.h
index 33f21bd85dbf2..f3196f82fd8a1 100644
--- a/include/linux/intel_rapl.h
+++ b/include/linux/intel_rapl.h
@@ -178,6 +178,12 @@ struct rapl_package {
 	struct rapl_if_priv *priv;
 };
 
+struct rapl_package *rapl_find_package_domain_cpuslocked(int id, struct rapl_if_priv *priv,
+						       bool id_is_cpu);
+struct rapl_package *rapl_add_package_cpuslocked(int id, struct rapl_if_priv *priv,
+						 bool id_is_cpu);
+void rapl_remove_package_cpuslocked(struct rapl_package *rp);
+
 struct rapl_package *rapl_find_package_domain(int id, struct rapl_if_priv *priv, bool id_is_cpu);
 struct rapl_package *rapl_add_package(int id, struct rapl_if_priv *priv, bool id_is_cpu);
 void rapl_remove_package(struct rapl_package *rp);
-- 
2.43.0



