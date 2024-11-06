Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EDB1EF955;
	Wed,  6 Nov 2024 12:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897482; cv=none; b=Wgmto2qgOJ0XQI5C82LXWm017sESYPOtefdDtruw2nG6sMAFDBPY7EIIJu2f0FyKHbF744OXVPjY/7K7+XoZt2VloPkWbGQ0HkdM29VayEJXILTD4IgRzyLC4B3GT8qWSvIjSkq0j516h1fFwTAUUzTQbusuWquEUmpJYeugs5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897482; c=relaxed/simple;
	bh=aV6aK5EL8ZoKSNWUexjhrQD8X2Z8+ZimVJi9iOGUnTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V13474wVwpQGpZad5JSbLmwsiLEtTv/n3dagYxjtYt+8A5wm76gL8ZWfulVklWNHgtygAWmSuW0f5b9Y49wd903JL5FaAfRmVaAAJjfbQ0loYjcGOU+FOb2ScFsfSEGCG07ZvHh5f1IkiAETAIuNnv5yEaenncRUWB4EOQEPXsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoR949Op; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoR949Op"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E0DC4CECD;
	Wed,  6 Nov 2024 12:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897482;
	bh=aV6aK5EL8ZoKSNWUexjhrQD8X2Z8+ZimVJi9iOGUnTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xoR949Opgwv/Ux9ogiJvxAfZY0n034ZD+By422Vxkg3NQ3IObruGs2NCJaaKrCBJQ
	 DkxDduOjVTtSGxXKEPdq8jhpLmrn9tDJKPg87bsUuVJag0GQljQCCCmwRPwq8Q+3Me
	 WUcizjQ55axMszcfHjPwogZIJkO9XjuB3blBWrfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/151] thermal: intel: int340x: processor: Remove MMIO RAPL CPU hotplug support
Date: Wed,  6 Nov 2024 13:04:15 +0100
Message-ID: <20241106120310.682953333@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

[ Upstream commit bfc6819e4bf56a55df6178f93241b5845ad672eb ]

CPU0/package0 is always online and the MMIO RAPL driver runs on single
package systems only, so there is no need to handle CPU hotplug in it.

Always register a RAPL package device for package 0 and remove the
unnecessary CPU hotplug support.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20240930081801.28502-6-rui.zhang@intel.com
[ rjw: Subject edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../int340x_thermal/processor_thermal_rapl.c  | 66 +++++++------------
 1 file changed, 22 insertions(+), 44 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c
index e964a9375722a..f7ab1f47ca7a6 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rapl.c
@@ -19,42 +19,6 @@ static const struct rapl_mmio_regs rapl_mmio_default = {
 	.limits[RAPL_DOMAIN_DRAM] = BIT(POWER_LIMIT2),
 };
 
-static int rapl_mmio_cpu_online(unsigned int cpu)
-{
-	struct rapl_package *rp;
-
-	/* mmio rapl supports package 0 only for now */
-	if (topology_physical_package_id(cpu))
-		return 0;
-
-	rp = rapl_find_package_domain_cpuslocked(cpu, &rapl_mmio_priv, true);
-	if (!rp) {
-		rp = rapl_add_package_cpuslocked(cpu, &rapl_mmio_priv, true);
-		if (IS_ERR(rp))
-			return PTR_ERR(rp);
-	}
-	cpumask_set_cpu(cpu, &rp->cpumask);
-	return 0;
-}
-
-static int rapl_mmio_cpu_down_prep(unsigned int cpu)
-{
-	struct rapl_package *rp;
-	int lead_cpu;
-
-	rp = rapl_find_package_domain_cpuslocked(cpu, &rapl_mmio_priv, true);
-	if (!rp)
-		return 0;
-
-	cpumask_clear_cpu(cpu, &rp->cpumask);
-	lead_cpu = cpumask_first(&rp->cpumask);
-	if (lead_cpu >= nr_cpu_ids)
-		rapl_remove_package_cpuslocked(rp);
-	else if (rp->lead_cpu == cpu)
-		rp->lead_cpu = lead_cpu;
-	return 0;
-}
-
 static int rapl_mmio_read_raw(int cpu, struct reg_action *ra)
 {
 	if (!ra->reg.mmio)
@@ -82,6 +46,7 @@ static int rapl_mmio_write_raw(int cpu, struct reg_action *ra)
 int proc_thermal_rapl_add(struct pci_dev *pdev, struct proc_thermal_device *proc_priv)
 {
 	const struct rapl_mmio_regs *rapl_regs = &rapl_mmio_default;
+	struct rapl_package *rp;
 	enum rapl_domain_reg_id reg;
 	enum rapl_domain_type domain;
 	int ret;
@@ -109,25 +74,38 @@ int proc_thermal_rapl_add(struct pci_dev *pdev, struct proc_thermal_device *proc
 		return PTR_ERR(rapl_mmio_priv.control_type);
 	}
 
-	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "powercap/rapl:online",
-				rapl_mmio_cpu_online, rapl_mmio_cpu_down_prep);
-	if (ret < 0) {
-		powercap_unregister_control_type(rapl_mmio_priv.control_type);
-		rapl_mmio_priv.control_type = NULL;
-		return ret;
+	/* Register a RAPL package device for package 0 which is always online */
+	rp = rapl_find_package_domain(0, &rapl_mmio_priv, false);
+	if (rp) {
+		ret = -EEXIST;
+		goto err;
+	}
+
+	rp = rapl_add_package(0, &rapl_mmio_priv, false);
+	if (IS_ERR(rp)) {
+		ret = PTR_ERR(rp);
+		goto err;
 	}
-	rapl_mmio_priv.pcap_rapl_online = ret;
 
 	return 0;
+
+err:
+	powercap_unregister_control_type(rapl_mmio_priv.control_type);
+	rapl_mmio_priv.control_type = NULL;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(proc_thermal_rapl_add);
 
 void proc_thermal_rapl_remove(void)
 {
+	struct rapl_package *rp;
+
 	if (IS_ERR_OR_NULL(rapl_mmio_priv.control_type))
 		return;
 
-	cpuhp_remove_state(rapl_mmio_priv.pcap_rapl_online);
+	rp = rapl_find_package_domain(0, &rapl_mmio_priv, false);
+	if (rp)
+		rapl_remove_package(rp);
 	powercap_unregister_control_type(rapl_mmio_priv.control_type);
 }
 EXPORT_SYMBOL_GPL(proc_thermal_rapl_remove);
-- 
2.43.0



