Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23131D5141;
	Wed, 25 Feb 2026 01:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983559; cv=none; b=rx+x4/FKKjoedre3ySbRtC5bT2GeG6oUMAa6qFSXq/WfU1fNfXTgD/69qMbslcd+zz5koEsWn5oqkQ43vXqOMvhZU6HaZPF8OezC+gt58QSoGlgHdkdFQa/jhqC+rpar6h7sdZPAlsxb7f6VVRTugRzOW4XWA3DkZuqHylQ9vdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983559; c=relaxed/simple;
	bh=eBZFCHV9IjMYVtwCsf8s35rdhq/hQf6iIjkS/okB6LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViE/AQJl21Ayn2yYz+bOJ9ayQTG/H8kh9o+MdXWQ41qa30rWO78UZd4XYdJq4r5x1wICLxGVp0iWW/SGyW734yUqznLcw4uvk4LnMML03uEeFYTbFCKc+WumAL3Ud62eEIaBkiAavL0f/M6mUcI8VzhP8omSlVe2HuHBNST0+7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKUDda5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKUDda5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A616DC2BC86;
	Wed, 25 Feb 2026 01:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983558;
	bh=eBZFCHV9IjMYVtwCsf8s35rdhq/hQf6iIjkS/okB6LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKUDda5gKa1CzZLKt82UiAaKXJIGO0nbG6J7bpb587besQ9TpB4UWNFrAQ/a07Soy
	 nUB5NQR/sU3b2ASz5AYnnOf0f7r0orR9A5hK3snwHY3ESXcbpCsRTMxlhVw/c0KtV7
	 OREj+ebvSML3WIGFAUd0aVMSyGnE51R4SooJi46c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Furquim Ulisses <ulisses.furquim@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 623/781] powercap: intel_rapl: Remove incorrect CPU check in PMU context
Date: Tue, 24 Feb 2026 17:22:12 -0800
Message-ID: <20260225012415.093984728@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit 7537bae8b6eb635583e0e6260f61d13ddbd52087 ]

The RAPL MSR read path incorrectly validates CPU context when called
from the PMU subsystem:

    if (atomic) {
        if (unlikely(smp_processor_id() != cpu))
            return -EIO;
        rdmsrq(ra->reg.msr, ra->value);
    }

This check fails for package-scoped MSRs like RAPL energy counters,
which are readable from any CPU within the package.

The perf tool avoids hitting this check by validating against
/sys/bus/event_source/devices/power/cpumask before opening events.
However, turbostat does not perform this validation and may attempt
reads from non-lead CPUs, causing the check to fail and return zero
power values.

Since package-scoped MSRs are architecturally accessible from any CPU
in the package, remove the CPU matching check.

Also rename 'atomic' to 'pmu_ctx' to clarify this indicates PMU context
where rdmsrq() can be used directly instead of rdmsrl_safe_on_cpu().

Fixes: 748d6ba43afd ("powercap: intel_rapl: Enable MSR-based RAPL PMU support")
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Tested-by: Furquim Ulisses <ulisses.furquim@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260209234310.1440722-2-sathyanarayanan.kuppuswamy@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c |  6 +++---
 drivers/powercap/intel_rapl_msr.c    | 12 +++++-------
 include/linux/intel_rapl.h           |  2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 3ff6da3bf4e63..3705d0608a0fb 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -254,7 +254,7 @@ static void rapl_init_domains(struct rapl_package *rp);
 static int rapl_read_data_raw(struct rapl_domain *rd,
 			      enum rapl_primitives prim,
 			      bool xlate, u64 *data,
-			      bool atomic);
+			      bool pmu_ctx);
 static int rapl_write_data_raw(struct rapl_domain *rd,
 			       enum rapl_primitives prim,
 			       unsigned long long value);
@@ -832,7 +832,7 @@ prim_fixups(struct rapl_domain *rd, enum rapl_primitives prim)
  */
 static int rapl_read_data_raw(struct rapl_domain *rd,
 			      enum rapl_primitives prim, bool xlate, u64 *data,
-			      bool atomic)
+			      bool pmu_ctx)
 {
 	u64 value;
 	enum rapl_primitives prim_fixed = prim_fixups(rd, prim);
@@ -854,7 +854,7 @@ static int rapl_read_data_raw(struct rapl_domain *rd,
 
 	ra.mask = rpi->mask;
 
-	if (rd->rp->priv->read_raw(get_rid(rd->rp), &ra, atomic)) {
+	if (rd->rp->priv->read_raw(get_rid(rd->rp), &ra, pmu_ctx)) {
 		pr_debug("failed to read reg 0x%llx for %s:%s\n", ra.reg.val, rd->rp->name, rd->name);
 		return -EIO;
 	}
diff --git a/drivers/powercap/intel_rapl_msr.c b/drivers/powercap/intel_rapl_msr.c
index 9a7e150b3536b..152893dca5653 100644
--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -110,16 +110,14 @@ static int rapl_cpu_down_prep(unsigned int cpu)
 	return 0;
 }
 
-static int rapl_msr_read_raw(int cpu, struct reg_action *ra, bool atomic)
+static int rapl_msr_read_raw(int cpu, struct reg_action *ra, bool pmu_ctx)
 {
 	/*
-	 * When called from atomic-context (eg PMU event handler)
-	 * perform MSR read directly using rdmsrq().
+	 * When called from PMU context, perform MSR read directly using
+	 * rdmsrq() without IPI overhead. Package-scoped MSRs are readable
+	 * from any CPU in the package.
 	 */
-	if (atomic) {
-		if (unlikely(smp_processor_id() != cpu))
-			return -EIO;
-
+	if (pmu_ctx) {
 		rdmsrq(ra->reg.msr, ra->value);
 		goto out;
 	}
diff --git a/include/linux/intel_rapl.h b/include/linux/intel_rapl.h
index f479ef5b3341c..fa1f328d67120 100644
--- a/include/linux/intel_rapl.h
+++ b/include/linux/intel_rapl.h
@@ -152,7 +152,7 @@ struct rapl_if_priv {
 	union rapl_reg reg_unit;
 	union rapl_reg regs[RAPL_DOMAIN_MAX][RAPL_DOMAIN_REG_MAX];
 	int limits[RAPL_DOMAIN_MAX];
-	int (*read_raw)(int id, struct reg_action *ra, bool atomic);
+	int (*read_raw)(int id, struct reg_action *ra, bool pmu_ctx);
 	int (*write_raw)(int id, struct reg_action *ra);
 	void *defaults;
 	void *rpi;
-- 
2.51.0



