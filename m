Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812621A6160;
	Tue, 30 Jul 2024 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356524; cv=none; b=GfBtzR4wSE2bxVR6wrTQBKZ3bQzdZn/qk0V1ZjpCKqN0fFJ18MCoozgb2avmbehCkzI7+395rWpfGU/K94j9CDT4aHbpICVxK1aVDjHmJD40OS24AgXquCE/zymQg9W4VmsD7nVuB/exnKLN9CwdGWoXCBC+B9A8evyYVM7S6vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356524; c=relaxed/simple;
	bh=B3d5gyojsmSE3GzX2AR8HOOYqxBD+SZ4hz6nXDXMIOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAYYauzjbULa1YZxX2W24Q5h23V6KWaDyAGf3fA5yheA95il9kt6y0mTS8B//fOTvdrry8m1B4VRJ4lLDtgCzbrwXAfOAAV1/DdCJSsf/Ccqs+PVIcZNFOx4fPokzbBGpllv0bCe1zVqTqMSrdm3E7euG0PSIvsgNz4lm75EzLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyBhPWZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyBhPWZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5AFC4AF0C;
	Tue, 30 Jul 2024 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356524;
	bh=B3d5gyojsmSE3GzX2AR8HOOYqxBD+SZ4hz6nXDXMIOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyBhPWZXRmEk1/miJ9tyNhgiqNN7LKoYhl9z6X11j66/CBP7HUnDJKdEwcKnVyrIL
	 5NNHyt6Rgh26/NQtMABWwa3brS6RPDl3rEeGATuw5GGMjHLsk5T2j5Dz4Gvmdn/d0E
	 m4YENvJthcuT+yKG6iLB4cfyboSbm/stQ+b93B3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 139/809] cpufreq/amd-pstate: Fix the scaling_max_freq setting on shared memory CPPC systems
Date: Tue, 30 Jul 2024 17:40:15 +0200
Message-ID: <20240730151730.100854434@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

[ Upstream commit 738d7d03571c7e38565bd245c0815a2c74665018 ]

On shared memory CPPC systems, with amd_pstate=active mode, the change
in scaling_max_freq doesn't get written to the shared memory
region. Due to this, the writes to the scaling_max_freq sysfs file
don't take effect. Fix this by propagating the scaling_max_freq
changes to the shared memory region.

Fixes: ffa5096a7c33 ("cpufreq: amd-pstate: implement Pstate EPP support for the AMD processors")
Reported-by: David Arcari <darcari@redhat.com>
Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20240702081413.5688-3-Dhananjay.Ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 43 +++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 9ad62dbe8bfbf..a092b13ffbc2f 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -247,6 +247,26 @@ static int amd_pstate_get_energy_pref_index(struct amd_cpudata *cpudata)
 	return index;
 }
 
+static void pstate_update_perf(struct amd_cpudata *cpudata, u32 min_perf,
+			       u32 des_perf, u32 max_perf, bool fast_switch)
+{
+	if (fast_switch)
+		wrmsrl(MSR_AMD_CPPC_REQ, READ_ONCE(cpudata->cppc_req_cached));
+	else
+		wrmsrl_on_cpu(cpudata->cpu, MSR_AMD_CPPC_REQ,
+			      READ_ONCE(cpudata->cppc_req_cached));
+}
+
+DEFINE_STATIC_CALL(amd_pstate_update_perf, pstate_update_perf);
+
+static inline void amd_pstate_update_perf(struct amd_cpudata *cpudata,
+					  u32 min_perf, u32 des_perf,
+					  u32 max_perf, bool fast_switch)
+{
+	static_call(amd_pstate_update_perf)(cpudata, min_perf, des_perf,
+					    max_perf, fast_switch);
+}
+
 static int amd_pstate_set_epp(struct amd_cpudata *cpudata, u32 epp)
 {
 	int ret;
@@ -263,6 +283,9 @@ static int amd_pstate_set_epp(struct amd_cpudata *cpudata, u32 epp)
 		if (!ret)
 			cpudata->epp_cached = epp;
 	} else {
+		amd_pstate_update_perf(cpudata, cpudata->min_limit_perf, 0U,
+					     cpudata->max_limit_perf, false);
+
 		perf_ctrls.energy_perf = epp;
 		ret = cppc_set_epp_perf(cpudata->cpu, &perf_ctrls, 1);
 		if (ret) {
@@ -452,16 +475,6 @@ static inline int amd_pstate_init_perf(struct amd_cpudata *cpudata)
 	return static_call(amd_pstate_init_perf)(cpudata);
 }
 
-static void pstate_update_perf(struct amd_cpudata *cpudata, u32 min_perf,
-			       u32 des_perf, u32 max_perf, bool fast_switch)
-{
-	if (fast_switch)
-		wrmsrl(MSR_AMD_CPPC_REQ, READ_ONCE(cpudata->cppc_req_cached));
-	else
-		wrmsrl_on_cpu(cpudata->cpu, MSR_AMD_CPPC_REQ,
-			      READ_ONCE(cpudata->cppc_req_cached));
-}
-
 static void cppc_update_perf(struct amd_cpudata *cpudata,
 			     u32 min_perf, u32 des_perf,
 			     u32 max_perf, bool fast_switch)
@@ -475,16 +488,6 @@ static void cppc_update_perf(struct amd_cpudata *cpudata,
 	cppc_set_perf(cpudata->cpu, &perf_ctrls);
 }
 
-DEFINE_STATIC_CALL(amd_pstate_update_perf, pstate_update_perf);
-
-static inline void amd_pstate_update_perf(struct amd_cpudata *cpudata,
-					  u32 min_perf, u32 des_perf,
-					  u32 max_perf, bool fast_switch)
-{
-	static_call(amd_pstate_update_perf)(cpudata, min_perf, des_perf,
-					    max_perf, fast_switch);
-}
-
 static inline bool amd_pstate_sample(struct amd_cpudata *cpudata)
 {
 	u64 aperf, mperf, tsc;
-- 
2.43.0



