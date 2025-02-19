Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7821E2842;
	Wed, 19 Feb 2025 08:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955239; cv=none; b=AzuFrmrwPPmz/dEvRZl5JDKvpK+BXX17QiUnRv4ChF7pcoDqXIN0z6ZfoJIYs6AqthHqa/TRZ79DFABHpeFQjVcoxxr39zODtcTNe9pYvzjZZpDsNiB3bDGDTs2aGRVNVT0DEz0nRV4emEt3S8pFlvizhHsyRooZ2kEzDBP+L/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955239; c=relaxed/simple;
	bh=S9N+BfPdfpLsr73oc8VO4k4xWiXbs6nqLIpmYBcd+z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3kOBVVOBTfdQ5TnbepgWKUxy9KrZ9Br0qDhEJ89Pjhy9SC9DpsZF8VrcGEFVQ+q6BIvy+x96UeUNMPHuWU4GI/0JlCCeG5VZr+eDe7lUQ5XC3DjWVwwvSaTyeAVUJsLxz4wdOwwLL5Cg/VkMywT0t2sb4RYDJO2ubKwhMlPauM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBCMvvG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBCMvvG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89753C4CEE6;
	Wed, 19 Feb 2025 08:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955238;
	bh=S9N+BfPdfpLsr73oc8VO4k4xWiXbs6nqLIpmYBcd+z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBCMvvG31kvr6iAgSYqxCW8jY4TdrqMOPwB2a1L0z0dEyzQ1hoazBh8+zh8Q1bB0r
	 aWA/OvcY27P8l8NE+4ZRl4sjg7tV71+HtNBBiM0wezxdFA5XSoES9LbcqOjHqVum2Q
	 Xxzxu21uNch52Y7FDKNn3zjOHaCjoymDosNsFJVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/230] cpufreq/amd-pstate: Call cppc_set_epp_perf in the reenable function
Date: Wed, 19 Feb 2025 09:28:12 +0100
Message-ID: <20250219082608.554064197@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

[ Upstream commit 796ff50e127af8362035f87ba29b6b84e2dd9742 ]

The EPP value being set in perf_ctrls.energy_perf is not being propagated
to the shared memory, fix that.

Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Perry Yuan <perry.yuan@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20241023102108.5980-4-Dhananjay.Ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Stable-dep-of: 3ace20038e19 ("cpufreq/amd-pstate: Fix cpufreq_policy ref counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 91d3c3b1c2d3b..161334937090c 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1594,8 +1594,9 @@ static void amd_pstate_epp_reenable(struct amd_cpudata *cpudata)
 		wrmsrl_on_cpu(cpudata->cpu, MSR_AMD_CPPC_REQ, value);
 	} else {
 		perf_ctrls.max_perf = max_perf;
-		perf_ctrls.energy_perf = AMD_CPPC_ENERGY_PERF_PREF(cpudata->epp_cached);
 		cppc_set_perf(cpudata->cpu, &perf_ctrls);
+		perf_ctrls.energy_perf = AMD_CPPC_ENERGY_PERF_PREF(cpudata->epp_cached);
+		cppc_set_epp_perf(cpudata->cpu, &perf_ctrls, 1);
 	}
 }
 
@@ -1636,8 +1637,9 @@ static void amd_pstate_epp_offline(struct cpufreq_policy *policy)
 	} else {
 		perf_ctrls.desired_perf = 0;
 		perf_ctrls.max_perf = min_perf;
-		perf_ctrls.energy_perf = AMD_CPPC_ENERGY_PERF_PREF(HWP_EPP_BALANCE_POWERSAVE);
 		cppc_set_perf(cpudata->cpu, &perf_ctrls);
+		perf_ctrls.energy_perf = AMD_CPPC_ENERGY_PERF_PREF(HWP_EPP_BALANCE_POWERSAVE);
+		cppc_set_epp_perf(cpudata->cpu, &perf_ctrls, 1);
 	}
 	mutex_unlock(&amd_pstate_limits_lock);
 }
-- 
2.39.5



