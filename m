Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EB31DF750;
	Tue,  8 Oct 2024 12:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391357; cv=none; b=d8156flMVMzdHBCb4FcYnhIg/H0IcgZnBfhAUmHlL+U3OeTwHg+nVjvac+Fy+MAE1nPllpUAH43puuth5bNt4MUnLILtta8B17XpE/col5Jqgn6Vuoxb+vnFuSQZNTBpuzQbr1aeai/VXtq7v2Vv4oIycP+ZKjCoQzuDJdpGoUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391357; c=relaxed/simple;
	bh=RJwTbR5x75tke//PoFP42nT3YBzBD3DUxZUtkuV4Hws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tz6+lcN5WVF5hF9eunbGQc3DN35mtW3A6UkU/8cOzjcmLTthmQb06LthZCOf0LwHt3WDhup9k2pzqSnwmIdhrskL2l8A1O7j/VppOVPLm4h8YNhMH9ajCcdAcHJqH/JAA4tW4pm6DzlfZRhFsUIwNuVW44kbEHshR3eb5MrzVPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxRTI4ZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxRTI4ZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5399DC4CEC7;
	Tue,  8 Oct 2024 12:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391356;
	bh=RJwTbR5x75tke//PoFP42nT3YBzBD3DUxZUtkuV4Hws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxRTI4ZYAFNq+FbuzABzRJtQkp0YtfGee+s+UYrigGGQIlQ/rj2Ald00lQ8mEJyVV
	 7qb4W8cZUDkyOQ6OtIKdxkVAl/DS8DVO5Nc+kJegL37XGmFwZtd1/1Urb5KpymVjDF
	 XLf4Ri7f/LLXAiyiObb7VdPqROyrnlTz3RSRTTV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 088/558] intel_idle: Disable promotion to C1E on Jasper Lake and Elkhart Lake
Date: Tue,  8 Oct 2024 14:01:58 +0200
Message-ID: <20241008115705.834153588@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 5bb33212b5c664396e5de4cd5a2999abb84a3978 ]

PCIe ethernet throughut is sub-optimal on Jasper Lake and Elkhart Lake.

The CPU can take long time to exit to C0 to handle IRQ and perform DMA
when C1E has been entered.

For this reason, adjust intel_idle to disable promotion to C1E and still
use C-states from ACPI _CST on those two platforms.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219023
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://patch.msgid.link/20240820041128.102452-1-kai.heng.feng@canonical.com
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 88470602b789e..67aebfe0fed66 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1530,6 +1530,10 @@ static const struct idle_cpu idle_cpu_dnv __initconst = {
 	.use_acpi = true,
 };
 
+static const struct idle_cpu idle_cpu_tmt __initconst = {
+	.disable_promotion_to_c1e = true,
+};
+
 static const struct idle_cpu idle_cpu_snr __initconst = {
 	.state_table = snr_cstates,
 	.disable_promotion_to_c1e = true,
@@ -1594,6 +1598,8 @@ static const struct x86_cpu_id intel_idle_ids[] __initconst = {
 	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&idle_cpu_bxt),
 	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&idle_cpu_bxt),
 	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_D,	&idle_cpu_dnv),
+	X86_MATCH_VFM(INTEL_ATOM_TREMONT,       &idle_cpu_tmt),
+	X86_MATCH_VFM(INTEL_ATOM_TREMONT_L,     &idle_cpu_tmt),
 	X86_MATCH_VFM(INTEL_ATOM_TREMONT_D,	&idle_cpu_snr),
 	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT,	&idle_cpu_grr),
 	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X,	&idle_cpu_srf),
@@ -2142,7 +2148,7 @@ static void __init intel_idle_cpuidle_driver_init(struct cpuidle_driver *drv)
 
 	drv->state_count = 1;
 
-	if (icpu)
+	if (icpu && icpu->state_table)
 		intel_idle_init_cstates_icpu(drv);
 	else
 		intel_idle_init_cstates_acpi(drv);
@@ -2276,7 +2282,11 @@ static int __init intel_idle_init(void)
 
 	icpu = (const struct idle_cpu *)id->driver_data;
 	if (icpu) {
-		cpuidle_state_table = icpu->state_table;
+		if (icpu->state_table)
+			cpuidle_state_table = icpu->state_table;
+		else if (!intel_idle_acpi_cst_extract())
+			return -ENODEV;
+
 		auto_demotion_disable_flags = icpu->auto_demotion_disable_flags;
 		if (icpu->disable_promotion_to_c1e)
 			c1e_promotion = C1E_PROMOTION_DISABLE;
-- 
2.43.0



