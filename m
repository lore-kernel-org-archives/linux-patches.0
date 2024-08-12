Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD65134AC;
	Mon, 12 Aug 2024 16:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479987; cv=none; b=WI+uVMFp2SlpqkhKUWGn5hpKMgbCGHc2DZrFSqkBsSnykpEL4Q9nOLKnPBCLEIZpWJ0Cyv41eqJWKNG0nJ3gN2QAo2dujTjBz7JVNXShd9P9yiy+Qa8jjoGVNmW3d08ATos1ykQ0Up2WXPLCrU3DhiI2EncTHnhjt6G9E1hs7TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479987; c=relaxed/simple;
	bh=fitv/k/vLUvp7pwHXv1mTgxQKmhJ1DWz5lA78b4/TIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvT3DbopK97W0tKzEcD6sw6pYoAMda23R2jlUBuqQMok5z/Lm2oJgdGj95HJiID/J4yq1V2SblRRED3oxYcFW5syj1Pd/24MgD8dVSIaGpvpoMQzGerJba9jRtsUUfCuy0OqgrOXoEYm2M4JvBcBfuoFSyK8Jq7xGfNswkxZS+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIE0fvik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIE0fvik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5F7C32782;
	Mon, 12 Aug 2024 16:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479987;
	bh=fitv/k/vLUvp7pwHXv1mTgxQKmhJ1DWz5lA78b4/TIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIE0fvikrOjWOAYaldFzQkYf6+swOoccTYvVe983f4KJmX4/col3d6nDSHOk4astJ
	 4JSRI7jCt1LLcJCcMofzxXZ5t48byX/VzVva80xTsWp0wY7p1HMyeQNcCFiNSCJoMi
	 vYpopDYL/6bh3O//IoItWITBfLyVTXFp1GWxPOec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 062/263] thermal: intel: hfi: Give HFI instances package scope
Date: Mon, 12 Aug 2024 18:01:03 +0200
Message-ID: <20240812160148.918051083@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit b755367602d70deade956cbe0b8a3f5a12f569dc ]

The Intel Software Developer's Manual defines the scope of HFI (registers
and memory buffer) as a package. Use package scope(*) in the software
representation of an HFI instance.

Using die scope in HFI instances has the effect of creating multiple
conflicting instances for the same package: each instance allocates its
own memory buffer and configures the same package-level registers.
Specifically, only one of the allocated memory buffers can be set in the
MSR_IA32_HW_FEEDBACK_PTR register. CPUs get incorrect HFI data from the
table.

The problem does not affect current HFI-capable platforms because they
all have single-die processors.

(*) We used die scope for HFI instances because there had been
    processors with packages enumerated as dies. None of those systems
    supported HFI, though. If such a system emerged, it would need to
    be quirked.

Co-developed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Link: https://patch.msgid.link/20240703055445.125362-1-rui.zhang@intel.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_hfi.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/thermal/intel/intel_hfi.c b/drivers/thermal/intel/intel_hfi.c
index a180a98bb9f15..5b18a46a10b06 100644
--- a/drivers/thermal/intel/intel_hfi.c
+++ b/drivers/thermal/intel/intel_hfi.c
@@ -401,10 +401,10 @@ static void hfi_disable(void)
  * intel_hfi_online() - Enable HFI on @cpu
  * @cpu:	CPU in which the HFI will be enabled
  *
- * Enable the HFI to be used in @cpu. The HFI is enabled at the die/package
- * level. The first CPU in the die/package to come online does the full HFI
+ * Enable the HFI to be used in @cpu. The HFI is enabled at the package
+ * level. The first CPU in the package to come online does the full HFI
  * initialization. Subsequent CPUs will just link themselves to the HFI
- * instance of their die/package.
+ * instance of their package.
  *
  * This function is called before enabling the thermal vector in the local APIC
  * in order to ensure that @cpu has an associated HFI instance when it receives
@@ -414,31 +414,31 @@ void intel_hfi_online(unsigned int cpu)
 {
 	struct hfi_instance *hfi_instance;
 	struct hfi_cpu_info *info;
-	u16 die_id;
+	u16 pkg_id;
 
 	/* Nothing to do if hfi_instances are missing. */
 	if (!hfi_instances)
 		return;
 
 	/*
-	 * Link @cpu to the HFI instance of its package/die. It does not
+	 * Link @cpu to the HFI instance of its package. It does not
 	 * matter whether the instance has been initialized.
 	 */
 	info = &per_cpu(hfi_cpu_info, cpu);
-	die_id = topology_logical_die_id(cpu);
+	pkg_id = topology_logical_package_id(cpu);
 	hfi_instance = info->hfi_instance;
 	if (!hfi_instance) {
-		if (die_id >= max_hfi_instances)
+		if (pkg_id >= max_hfi_instances)
 			return;
 
-		hfi_instance = &hfi_instances[die_id];
+		hfi_instance = &hfi_instances[pkg_id];
 		info->hfi_instance = hfi_instance;
 	}
 
 	init_hfi_cpu_index(info);
 
 	/*
-	 * Now check if the HFI instance of the package/die of @cpu has been
+	 * Now check if the HFI instance of the package of @cpu has been
 	 * initialized (by checking its header). In such case, all we have to
 	 * do is to add @cpu to this instance's cpumask and enable the instance
 	 * if needed.
@@ -504,7 +504,7 @@ void intel_hfi_online(unsigned int cpu)
  *
  * On some processors, hardware remembers previous programming settings even
  * after being reprogrammed. Thus, keep HFI enabled even if all CPUs in the
- * die/package of @cpu are offline. See note in intel_hfi_online().
+ * package of @cpu are offline. See note in intel_hfi_online().
  */
 void intel_hfi_offline(unsigned int cpu)
 {
@@ -674,9 +674,13 @@ void __init intel_hfi_init(void)
 	if (hfi_parse_features())
 		return;
 
-	/* There is one HFI instance per die/package. */
-	max_hfi_instances = topology_max_packages() *
-			    topology_max_dies_per_package();
+	/*
+	 * Note: HFI resources are managed at the physical package scope.
+	 * There could be platforms that enumerate packages as Linux dies.
+	 * Special handling would be needed if this happens on an HFI-capable
+	 * platform.
+	 */
+	max_hfi_instances = topology_max_packages();
 
 	/*
 	 * This allocation may fail. CPU hotplug callbacks must check
-- 
2.43.0



