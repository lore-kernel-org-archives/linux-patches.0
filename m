Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519495803BB;
	Wed,  9 Sep 2026 14:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964670; cv=none; b=ENuLtK39XYys/aRm2ieda2nBwv7fG57135+q/38kQrQhUvnrvteEXUDz1UbPaq4/cf6QQ3oF/q6v60rUzqJfZFtPCWvB4eOmxrQ6Q57aSD9R7MhWz1WgsD8pVRGb0LSzdK9yTK13qZJGiJ2TJnrXl5sLwZIVBr2Goon1ST9wAlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964670; c=relaxed/simple;
	bh=iNc9zi8TxsrdtinetAA9x5/R9VubyHOYLmC6Wzklcbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNVnIYz7Fe9gPtWs4gZN5DKtbDeNTllTkk510t9OYBRBRNBdL4SlSkktx2Hm+WsyNDtRvPUFhqshhe66QtTsrSnR6vMorXs43/VLeaHsdgTtLE+eCb7MiMxw2DknpEUHC7pfTNYkEdAcXLjXy3zGlAXLavC/PnL0aUU2U8dGnrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxGcQarr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxGcQarr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A791F00A3A;
	Wed,  9 Sep 2026 14:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964669;
	bh=Yre+eW3GegnpbYTC3JwzZ49X+rx4g2gW0JBrIsb2y9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VxGcQarr8kWhsTMDPeY5VM89E2B5GsRAyOBYKHSXCNxemkXYuX5GgMwgrzHkBi/5f
	 Iymkzkec+BF4Yv7oUEkAEJ2kslr+4A2m6/7npypcF23v6t9zujx29/+kUYX1v86f3Y
	 qg1ux4sO/13eoAgEcFXjVplVa/51RG8PBXsic448=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 476/583] ACPI: CPPC: Reject desired_perf reads on _CPC revision 4+
Date: Wed,  9 Sep 2026 15:42:41 +0200
Message-ID: <20260909134254.347350347@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit df5a1d4a8cdfda20eb2581a85e81c7d436866534 ]

When CPPC feedback counters cannot provide a usable sample, cppc-cpufreq
calls cppc_get_desired_perf() because some platforms repurpose Desired
Performance to report actual delivered performance.

ACPI 6.5 defines _CPC revision 3 and lists Read/Write as the Optional
Attribute of Desired Performance. ACPI 6.6 advances _CPC to revision 4 and
lists only Write, so invoking that workaround for revision 4 or later would
require a register read that the interface no longer specifies.

Make cppc_get_desired_perf() return -EOPNOTSUPP for _CPC revision 4 or
later. Use the revision retained in the per-CPU CPC descriptor rather than
the platform-wide FADT revision.

The _CPC revision may still not accurately describe the implemented
register semantics. If a nominally revision 3 platform implements a
non-readable Desired Performance register, a read may return zero and make
cppc_cpufreq_get_rate() report 0 kHz. Treat a zero read as unusable and
fall back to the cached OSPM request, just as for a failed read.

Fixes: c47195631960 ("cppc_cpufreq: Use desired perf if feedback ctrs are 0 or unchanged")
Cc: stable@vger.kernel.org
Suggested-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260803203531.1268651-2-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ preserved the raw firmware revision while limiting parsing to the v3-sized register prefix ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c       |   13 +++++++++++--
 drivers/cpufreq/cppc_cpufreq.c |    2 +-
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -768,7 +768,6 @@ int acpi_cppc_processor_probe(struct acp
 	}
 	if (cpc_rev > CPPC_V3_REV) {
 		num_ent = CPPC_V3_NUM_ENT;
-		cpc_rev = CPPC_V3_REV;
 	}
 
 	cpc_ptr->num_entries = num_ent;
@@ -1289,10 +1288,20 @@ static int cppc_set_reg_val(int cpu, enu
  * @cpunum: CPU from which to get desired performance.
  * @desired_perf: Return address.
  *
- * Return: 0 for success, -EIO otherwise.
+ * Return: 0 for success, -EOPNOTSUPP for _CPC revision 4 or later, and a
+ * negative errno otherwise.
  */
 int cppc_get_desired_perf(int cpunum, u64 *desired_perf)
 {
+	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpunum);
+
+	if (!cpc_desc)
+		return -ENODEV;
+
+	/* _CPC revision 4 no longer specifies Desired Performance as readable. */
+	if (cpc_desc->version > CPPC_V3_REV)
+		return -EOPNOTSUPP;
+
 	return cppc_get_reg_val(cpunum, DESIRED_PERF, desired_perf);
 }
 EXPORT_SYMBOL_GPL(cppc_get_desired_perf);
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -766,7 +766,7 @@ out_invalid_counters:
 	 * value first as some platforms may update the actual delivered perf
 	 * there; if failed, resort to the cached desired perf.
 	 */
-	if (cppc_get_desired_perf(cpu, &delivered_perf))
+	if (cppc_get_desired_perf(cpu, &delivered_perf) || !delivered_perf)
 		delivered_perf = cpu_data->perf_ctrls.desired_perf;
 
 	return cppc_perf_to_khz(&cpu_data->perf_caps, delivered_perf);


