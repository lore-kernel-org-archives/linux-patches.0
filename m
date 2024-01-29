Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5771157E6D;
	Mon, 29 Jan 2024 17:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548640; cv=none; b=TDdDwVI8sc2PupQYy1aKZsgH05vxjJLWfz3L+7KLOS22Mvr60x6Q9E8WyKpEFdDAe+FO6AGCmvuRfCSi9WdfiIt9CM89avV27BeykYI7lkOXD9j15OOS5Rc6Tw2BSAD6MI1mvPiTQWROBwPMMLzn1YloCQ8+btvQKWA/A6TUHnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548640; c=relaxed/simple;
	bh=p7W3aBZBuLq/cNR90beVlueD0n/Aq/TX4nB0hnrdmpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmTrLw1VrYwCnHD14a5eX4rAdK7bjnsS6TPphyRQdYx08A3qKQQ55JaajF5ddFVCKpazUBwN9kwJRpsw7t85FS/aZHJOqp651CzPR3nytAXyDb+qAhCG5ZArhNk3WVS/CwnGz/C9fMbJqMzHA2eIadVKuoJt5zHbnwdTrdv2XmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxRH2tS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxRH2tS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD74C433F1;
	Mon, 29 Jan 2024 17:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548640;
	bh=p7W3aBZBuLq/cNR90beVlueD0n/Aq/TX4nB0hnrdmpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxRH2tS0kj13PCOWEmAasigEp6pnx8+YmRro86gbVAr+QUiSDN9/Pd64BcaAm/DgG
	 PUgBXObhwSPd/ZUGK0UjUJB3qcKdPlSEx1RLHkIB7ZO7VNVLCZ3Dj7kc6254skee7n
	 6n8aaIi81tJVuKqZ2UESyGioj3ctEa6x0ACmUmSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Wyes Karny <wkarny@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 317/331] cpufreq/amd-pstate: Fix setting scaling max/min freq values
Date: Mon, 29 Jan 2024 09:06:21 -0800
Message-ID: <20240129170024.162048288@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 22fb4f041999f5f16ecbda15a2859b4ef4cbf47e ]

Scaling min/max freq values were being cached and lagging a setting
each time.  Fix the ordering of the clamp call to ensure they work.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217931
Fixes: febab20caeba ("cpufreq/amd-pstate: Fix scaling_min_freq and scaling_max_freq update")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Wyes Karny <wkarny@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 1f6186475715..1791d37fbc53 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1232,14 +1232,13 @@ static void amd_pstate_epp_update_limit(struct cpufreq_policy *policy)
 	max_limit_perf = div_u64(policy->max * cpudata->highest_perf, cpudata->max_freq);
 	min_limit_perf = div_u64(policy->min * cpudata->highest_perf, cpudata->max_freq);
 
+	WRITE_ONCE(cpudata->max_limit_perf, max_limit_perf);
+	WRITE_ONCE(cpudata->min_limit_perf, min_limit_perf);
+
 	max_perf = clamp_t(unsigned long, max_perf, cpudata->min_limit_perf,
 			cpudata->max_limit_perf);
 	min_perf = clamp_t(unsigned long, min_perf, cpudata->min_limit_perf,
 			cpudata->max_limit_perf);
-
-	WRITE_ONCE(cpudata->max_limit_perf, max_limit_perf);
-	WRITE_ONCE(cpudata->min_limit_perf, min_limit_perf);
-
 	value = READ_ONCE(cpudata->cppc_req_cached);
 
 	if (cpudata->policy == CPUFREQ_POLICY_PERFORMANCE)
-- 
2.43.0



