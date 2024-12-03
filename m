Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC0B1F669E;
	Tue,  3 Dec 2024 14:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237927; cv=none; b=Y6fW2HCiySSbxJ8v3xr1Lpp+9mpcuu32Whh4zYVidI/LSRcz/RelVBksKyxmiETnDi/mhjjIP36JP39D9/3194VEyFk9gfBYvdF00livgpqgj9k/NxSW24ahgilgpXe8TJ9nCgKCLgSraY0V/GqU72fClEkeRIeyjzJXQYtI+eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237927; c=relaxed/simple;
	bh=hM0PEXOsNxq7N09uICdvfC/W4d0rV/Mxw8XxYPePOdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azQ/NKzuBqnedgtHqDgh9X8nQHacLJButgy9+aRS+pDJ1Hg9OmsCn9W3M1m6McYSL+/aNEAUIyRTGgxLBbqhs/eMCS54Amce75GZ6fy3mpAi+iI4GtT3L6bqFbKYarN3Sd+ES2PP/a8F2DkA5kuWm2wh1EGWdYcHz2K3VDp9BjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKVSNrpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKVSNrpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE980C4CECF;
	Tue,  3 Dec 2024 14:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237927;
	bh=hM0PEXOsNxq7N09uICdvfC/W4d0rV/Mxw8XxYPePOdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JKVSNrpiQSt3BRRn/VGIA48mOFeeI9IxqU0xPJzySib+kS4GHyQJXRub3cXwtEw/2
	 WI1bB3VOh8ZFUdX1CpRRb7ZnJsech/DPhWjj8N3/U3Pj1Z5O2m15N2Pz/H266kchWN
	 8sXZ7E3GrF1NpD004rDl30zfZKRpM5S34zYZSIKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 110/817] amd-pstate: Set min_perf to nominal_perf for active mode performance gov
Date: Tue,  3 Dec 2024 15:34:42 +0100
Message-ID: <20241203144000.005547826@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit 0c411b39e4f4ce8861301fa201cb4f817751311e ]

The amd-pstate driver sets CPPC_REQ.min_perf to CPPC_REQ.max_perf when
in active mode with performance governor. Typically CPPC_REQ.max_perf
is set to CPPC.highest_perf. This causes frequency throttling on
power-limited platforms which causes performance regressions on
certain classes of workloads.

Hence, set the CPPC_REQ.min_perf to the CPPC.nominal_perf or
CPPC_REQ.max_perf, whichever is lower of the two.

Fixes: ffa5096a7c33 ("cpufreq: amd-pstate: implement Pstate EPP support for the AMD processors")
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20241021101836.9047-2-gautham.shenoy@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 62ae4ff290379..c2d650ac0a9f1 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1584,7 +1584,7 @@ static void amd_pstate_epp_update_limit(struct cpufreq_policy *policy)
 	value = READ_ONCE(cpudata->cppc_req_cached);
 
 	if (cpudata->policy == CPUFREQ_POLICY_PERFORMANCE)
-		min_perf = max_perf;
+		min_perf = min(cpudata->nominal_perf, max_perf);
 
 	/* Initial min/max values for CPPC Performance Controls Register */
 	value &= ~AMD_CPPC_MIN_PERF(~0L);
-- 
2.43.0



