Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910A51A3024;
	Tue, 30 Jul 2024 16:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355926; cv=none; b=SVjwzjF24bS0njiH2n7lYRfO7yhp3cDuvtnKHVUNWXZ1LxWdj6jySgr6gFBqMynByuT5YINfuaTvI5x2d7xpZGaMwfdU0w9a4IQCKQ0PW2pihFJKH8OevkUf7OascWHfbAvtWSd1X5tMVl77uYhPCTafF8s6rqm682gkNgp27FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355926; c=relaxed/simple;
	bh=VZGpgR/BqS7ZXsQDLOcR/0pxGt+vOsEVRrEa90KtyPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHoQPTvsb7HNrQVYSNyOs0q79wbZ9nClef+dqn5NBmbFvknXgFjSTZIPY5caMTxm4qOtBOHQ7HCkf/dx3t4ZJqMSoYXt6h9P/UVmlItfrWx4+8IGsq9MhhmeG9E5yDQ4L1CMVN67pP8sVe/VnYgjpGec4BV6bAz4hPAWRUfXRZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NInkhyZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NInkhyZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6DAC32782;
	Tue, 30 Jul 2024 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355926;
	bh=VZGpgR/BqS7ZXsQDLOcR/0pxGt+vOsEVRrEa90KtyPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NInkhyZjhae8DhpeYEwzNHwRafSShaef65tDkBSF0hsPeiCg1i1rM9OOcu7nI74f2
	 nbcHd5+Jxt9SyTH2nrhxwmfpf3TseoeOMIt8ocfwwC1PRg8KjyHeL+N/ROov3Grq+m
	 gHP838g1kN+ml8aQcGvopKKXKqHzsBnlVnjGPma4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/568] cpufreq/amd-pstate: Fix the scaling_max_freq setting on shared memory CPPC systems
Date: Tue, 30 Jul 2024 17:43:30 +0200
Message-ID: <20240730151643.901751962@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 3efc2aef31ce4..23c74e9f04c48 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -175,6 +175,26 @@ static int amd_pstate_get_energy_pref_index(struct amd_cpudata *cpudata)
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
@@ -191,6 +211,9 @@ static int amd_pstate_set_epp(struct amd_cpudata *cpudata, u32 epp)
 		if (!ret)
 			cpudata->epp_cached = epp;
 	} else {
+		amd_pstate_update_perf(cpudata, cpudata->min_limit_perf, 0U,
+					     cpudata->max_limit_perf, false);
+
 		perf_ctrls.energy_perf = epp;
 		ret = cppc_set_epp_perf(cpudata->cpu, &perf_ctrls, 1);
 		if (ret) {
@@ -361,16 +384,6 @@ static inline int amd_pstate_init_perf(struct amd_cpudata *cpudata)
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
@@ -384,16 +397,6 @@ static void cppc_update_perf(struct amd_cpudata *cpudata,
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



