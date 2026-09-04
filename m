Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF324195A0;
	Fri,  4 Sep 2026 05:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499110; cv=none; b=aCam30Y1uOBrOoKvJzeNXGDX1YsMXI1YYbWGCpqan1Oghl0aQIvyyfhpl+aMt5Sma9F1hl6LiSnVDmqx9oS5rNKC3qEl0/gMrab+EsKS1OQuyoGTE7VHSSC1AkXyawX3tCySDl+OnIQrbHMjbdx/NFfpqucurhCNL7+3E7S6u+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499110; c=relaxed/simple;
	bh=Ry/rRhRwak5UpLuqx+S0LZggmQP7sVZ8cj3tJK66MkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hm4QGu6uorMuO/kVtQ030m220JQ6SJLMRh0kNPEg/PhQGQaxXK47CP3f9ipvQ5dH5m4ferakhP2g/JXNAdPDomACib32NuwDlk6lyTtf3/EcXtpDqOic0O2qIiPuonsDo1bjW5kHngNVqAzkvAjrnWUArdFBnWrh0tgWYTs5Lto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e67g2azL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e67g2azL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E4F1F00A3D;
	Fri,  4 Sep 2026 05:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499109;
	bh=BiY6vPhgkMZsiBsec/PfWWBR30GJc85yJlZvh02byVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e67g2azLqABzQHRN+bZSZNzQp5TdATJ+rYS1pcoVluXweGZShyt6mxi21RaLKvXQd
	 AVpJqpdmx6GuGhdNkx/T5kH1crEY63pb8RphxA5Dn1vZqkyhb+/WtsIQ8No9xJEBSm
	 OTwWgTKBtCx9jLWcWp5ivTspeU3DU6CGfHCVl26M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.2 300/713] ACPI: CPPC: Skip desired_perf read in cppc_get_perf()
Date: Fri,  4 Sep 2026 06:54:28 +0200
Message-ID: <20260904045810.565696324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

commit d3576424e8fa702a15a1963718a07eb672db9be7 upstream.

ACPI 6.5 defines _CPC revision 3 and lists Read/Write as the Optional
Attribute of Desired Performance. ACPI 6.6 advances _CPC to revision 4 and
lists only Write. cppc_get_perf() nevertheless reads the register when
initializing performance controls, even though cppc-cpufreq overwrites the
value before using it.

Use the _CPC revision check from cppc_get_desired_perf() and leave
desired_perf zero instead of reading it for _CPC revision 4 or later. Also
exclude the register from PCC read-command detection so it cannot trigger
an otherwise unnecessary read command.

Fixes: 658fa7b1c47a ("ACPI: CPPC: Add cppc_get_perf() API to read performance controls")
Cc: stable@vger.kernel.org
Suggested-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260803203531.1268651-3-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 42aeb749ebe0..becb7e442b30 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1845,12 +1845,14 @@ int cppc_get_perf(int cpu, struct cppc_perf_ctrls *perf_ctrls)
 	u64 desired_perf = 0, min = 0, max = 0, energy_perf = 0, auto_sel = 0;
 	int pcc_ss_id = per_cpu(cpu_pcc_subspace_idx, cpu);
 	struct cppc_pcc_data *pcc_ss_data = NULL;
+	bool read_desired_perf;
 	int ret = 0, regs_in_pcc = 0;
 
 	if (!cpc_desc) {
 		pr_debug("No CPC descriptor for CPU:%d\n", cpu);
 		return -ENODEV;
 	}
+	read_desired_perf = cppc_desired_perf_readable(cpc_desc);
 
 	if (!perf_ctrls) {
 		pr_debug("Invalid perf_ctrls pointer\n");
@@ -1864,7 +1866,8 @@ int cppc_get_perf(int cpu, struct cppc_perf_ctrls *perf_ctrls)
 	auto_sel_reg = &cpc_desc->cpc_regs[AUTO_SEL_ENABLE];
 
 	/* Are any of the regs PCC ?*/
-	if (CPC_IN_PCC(desired_perf_reg) || CPC_IN_PCC(min_perf_reg) ||
+	if ((read_desired_perf && CPC_IN_PCC(desired_perf_reg)) ||
+	    CPC_IN_PCC(min_perf_reg) ||
 	    CPC_IN_PCC(max_perf_reg) || CPC_IN_PCC(energy_perf_reg) ||
 	    CPC_IN_PCC(auto_sel_reg)) {
 		if (pcc_ss_id < 0) {
@@ -1896,7 +1899,7 @@ int cppc_get_perf(int cpu, struct cppc_perf_ctrls *perf_ctrls)
 	}
 	perf_ctrls->min_perf = min;
 
-	if (CPC_SUPPORTED(desired_perf_reg)) {
+	if (read_desired_perf && CPC_SUPPORTED(desired_perf_reg)) {
 		ret = cpc_read(cpu, desired_perf_reg, &desired_perf);
 		if (ret)
 			goto out_err;
-- 
2.55.0



