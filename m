Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D0E1C9B91;
	Wed,  2 Oct 2024 13:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876928; cv=none; b=q6yu1FO3RwYQLar0CMeh2WysJOzFzLbMIg0CLkrO4n1r556pgD393REo/YPjb55AJlfNyn93rD10oGg6IxJX9exmTY8RBxKzEP42RTall/H/PvPNZBcMes3fveu3T2tgpJaLsDKx7/6tEqvqmK1UKAkTKZVe8nWcxqJ9AsUaozU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876928; c=relaxed/simple;
	bh=DuikLKpRBFKeBSzRs4PHOieVDZskttduFWre9lLAErU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niIeKxMXAKPQNSAU/QAYiWRCcdEMaSAfbJYuLuwPSE/SZUbzgz+dt6z3CXgCNOOhSMzmJ4Stb7OmtCMNSWgUsNTEs+z/9S15o8f4js7A+PMtnccw1M3rCp7WlSOVqO4y7iQvLA9F53ILsrT97gcR+V/HQ0jr5cF+qI9tGofW6oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuo/Cm5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuo/Cm5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765CFC4CECF;
	Wed,  2 Oct 2024 13:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876927;
	bh=DuikLKpRBFKeBSzRs4PHOieVDZskttduFWre9lLAErU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wuo/Cm5JuQadjlpl5Bx2UU6IA6w0qyZPqMUwfbJaezNznrxmBJdAEzGuBZjotf68+
	 pnypz1W1Q42tiJxgZlyIMBlPQ+3wfS5iIqTlJ4V3neEXcDXEsv+f9zW6+TCsbX7Ukd
	 Zg38HF0/eOLV5mpRYWqfFtjQ+2nXn/I1NshB5Zxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 608/695] intel_idle: add Granite Rapids Xeon support
Date: Wed,  2 Oct 2024 15:00:06 +0200
Message-ID: <20241002125846.785351246@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 370406bf5738dade8ac95a2ee95c29299d4ac902 upstream.

Add Granite Rapids Xeon C-states, which are C1, C1E, C6, and C6P.

Comparing to previous Xeon Generations (e.g., Emerald Rapids), C6
requests end up only in core C6 state, and no package C-state promotion
takes place even if all cores in the package are in core C6.

C6P requests also end up in core C6, but if all cores have requested
C6P, the SoC will enter the package C6 state.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Link: https://patch.msgid.link/20240806160310.3719205-1-artem.bityutskiy@linux.intel.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/idle/intel_idle.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1022,6 +1022,45 @@ static struct cpuidle_state spr_cstates[
 		.enter = NULL }
 };
 
+static struct cpuidle_state gnr_cstates[] __initdata = {
+	{
+		.name = "C1",
+		.desc = "MWAIT 0x00",
+		.flags = MWAIT2flg(0x00),
+		.exit_latency = 1,
+		.target_residency = 1,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.name = "C1E",
+		.desc = "MWAIT 0x01",
+		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_ALWAYS_ENABLE,
+		.exit_latency = 4,
+		.target_residency = 4,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.name = "C6",
+		.desc = "MWAIT 0x20",
+		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED |
+					   CPUIDLE_FLAG_INIT_XSTATE,
+		.exit_latency = 170,
+		.target_residency = 650,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.name = "C6P",
+		.desc = "MWAIT 0x21",
+		.flags = MWAIT2flg(0x21) | CPUIDLE_FLAG_TLB_FLUSHED |
+					   CPUIDLE_FLAG_INIT_XSTATE,
+		.exit_latency = 210,
+		.target_residency = 1000,
+		.enter = &intel_idle,
+		.enter_s2idle = intel_idle_s2idle, },
+	{
+		.enter = NULL }
+};
+
 static struct cpuidle_state atom_cstates[] __initdata = {
 	{
 		.name = "C1E",
@@ -1453,6 +1492,12 @@ static const struct idle_cpu idle_cpu_sp
 	.use_acpi = true,
 };
 
+static const struct idle_cpu idle_cpu_gnr __initconst = {
+	.state_table = gnr_cstates,
+	.disable_promotion_to_c1e = true,
+	.use_acpi = true,
+};
+
 static const struct idle_cpu idle_cpu_avn __initconst = {
 	.state_table = avn_cstates,
 	.disable_promotion_to_c1e = true,
@@ -1533,6 +1578,7 @@ static const struct x86_cpu_id intel_idl
 	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT,	&idle_cpu_gmt),
 	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X,	&idle_cpu_spr),
 	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X,	&idle_cpu_spr),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X,	&idle_cpu_gnr),
 	X86_MATCH_VFM(INTEL_XEON_PHI_KNL,	&idle_cpu_knl),
 	X86_MATCH_VFM(INTEL_XEON_PHI_KNM,	&idle_cpu_knl),
 	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&idle_cpu_bxt),


