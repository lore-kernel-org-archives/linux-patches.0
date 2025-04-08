Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5475E1FBCB2;
	Tue,  8 Apr 2025 11:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110308; cv=none; b=rWxPzdsdQ1HTfVRHdS7jSgDpdx5rPx0BPcpcA6rIEIRApP4qKioljxOhyTQhXlD2XPX11qrSfu90oLAHogbhiu2G2W30mXNPgGMbYoW0SP109nncVnchMTNwbGQXWdqM98+0TBw7WLBiKkOVniY/m3XgItPcXHDXKNzTIgMsFaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110308; c=relaxed/simple;
	bh=D4tHkwPylcxeniTVtqmz/2EpTHWjnj93rem9n1yk1xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z43EMh797YAe72cH6PC0pg6KxI60tiFq/94cnlNI3aV36XqDqw+M6XGuuuxYYRYFhkckn0dk9LP8Ch0Y64Cz73MztVB7frLRmnJx3KzI/9gSBhEcLXGyHlsAFL5iU7DIehog1zBvqOJTynm1dlXyx5bA5wXKIAv5hMaU/Bkq1v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W401QISP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W401QISP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0626C4CEE5;
	Tue,  8 Apr 2025 11:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110308;
	bh=D4tHkwPylcxeniTVtqmz/2EpTHWjnj93rem9n1yk1xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W401QISP5rWawlc97NbD1DlFvrdfkpCNa/YsxKKjpeGJVPeYA7kUE/icn3TkVVMzX
	 CfAwhp6LlogDcmikdwJ6BIcg3ltFRUiODmEr76n3WSzId+wz6P4Sz1HNPfHtCnhynA
	 t70/tQL59yvGMImkZY/8tGOWfvaqQBTOnYqLGG+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 017/731] cpufreq/amd-pstate: Modify the min_perf calculation in adjust_perf callback
Date: Tue,  8 Apr 2025 12:38:34 +0200
Message-ID: <20250408104914.663178363@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>

[ Upstream commit 6ceb877d5cecd5417d63239bf833a1cd5f8f271c ]

Instead of setting a fixed floor at lowest_nonlinear_perf, use the
min_limit_perf value, so that it gives the user the freedom to lower the
floor further.

There are two minimum frequency/perf limits that we need to consider in
the adjust_perf callback. One provided by schedutil i.e. the sg_cpu->bw_min
value passed in _min_perf arg, another is the effective value of
min_freq_qos request that is updated in cpudata->min_limit_perf. Modify the
code to use the bigger of these two values.

Signed-off-by: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20250205112523.201101-4-dhananjay.ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Stable-dep-of: 426db24d4db2 ("cpufreq/amd-pstate: Add missing NULL ptr check in amd_pstate_update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 313550fa62d41..17595a2454e1c 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -672,7 +672,7 @@ static void amd_pstate_adjust_perf(unsigned int cpu,
 				   unsigned long capacity)
 {
 	unsigned long max_perf, min_perf, des_perf,
-		      cap_perf, lowest_nonlinear_perf;
+		      cap_perf, min_limit_perf;
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
 	struct amd_cpudata *cpudata;
 
@@ -684,20 +684,20 @@ static void amd_pstate_adjust_perf(unsigned int cpu,
 	if (policy->min != cpudata->min_limit_freq || policy->max != cpudata->max_limit_freq)
 		amd_pstate_update_min_max_limit(policy);
 
-
 	cap_perf = READ_ONCE(cpudata->highest_perf);
-	lowest_nonlinear_perf = READ_ONCE(cpudata->lowest_nonlinear_perf);
+	min_limit_perf = READ_ONCE(cpudata->min_limit_perf);
 
 	des_perf = cap_perf;
 	if (target_perf < capacity)
 		des_perf = DIV_ROUND_UP(cap_perf * target_perf, capacity);
 
-	min_perf = READ_ONCE(cpudata->lowest_perf);
 	if (_min_perf < capacity)
 		min_perf = DIV_ROUND_UP(cap_perf * _min_perf, capacity);
+	else
+		min_perf = cap_perf;
 
-	if (min_perf < lowest_nonlinear_perf)
-		min_perf = lowest_nonlinear_perf;
+	if (min_perf < min_limit_perf)
+		min_perf = min_limit_perf;
 
 	max_perf = cpudata->max_limit_perf;
 	if (max_perf < min_perf)
-- 
2.39.5



