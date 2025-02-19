Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DED1AF0C8;
	Wed, 19 Feb 2025 08:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954570; cv=none; b=tUvtuRC7YfJH9XtSrx0ZUtop+rZsikubwbHQCtGOtM1PsMTEeK+Vgj7l2/0iB7ZopZwQztFOJ0nbdjFjFx14Vg4RZmH1dHS/tIh++tJys0fvRnPw2cOORSvPfU2mpClGTWcn7EtUUeqlw8P4hb9rGjAUwOXhPeGXWTreA0i1Gjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954570; c=relaxed/simple;
	bh=4R30CfWaMPAQkfVQEyRa7U0dSrPacwMgbyOnoaal4gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DE1HZjCBcgFDp487sPseU8LJeqGazd5frRlbCOk1nEjtCVYBA7bzXOgLO8wM7qW3Cl/CmofC4Z2mWoFFtRQviBOyfpsFWgZycPf6t7gEiWf6ZXo5WwFwZ3Nd5ykMh1G0vlTbsxzDQnBEWAqxryE/fAOWpi4WKKY/+k6FMg5k66Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2cXO+dM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2cXO+dM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250D0C4CED1;
	Wed, 19 Feb 2025 08:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954570;
	bh=4R30CfWaMPAQkfVQEyRa7U0dSrPacwMgbyOnoaal4gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2cXO+dM7QCVh/qe/471L2Dy57eYJZTWkp6IbITjeZiIyGUSRob48eLU2EY3CzmH/
	 mYRznt/tZlWrQoM21ZVwugbuiM6ksmwtU++NLaDsUhd00HEbYrzJRYiDrmOdZM08Ue
	 ft3KLQo09Mcu0yFUNgChOueP12c/nuLS8ZzbY1Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 213/274] cpufreq/amd-pstate: Fix cpufreq_policy ref counting
Date: Wed, 19 Feb 2025 09:27:47 +0100
Message-ID: <20250219082617.912642742@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>

[ Upstream commit 3ace20038e19f23fe73259513f1f08d4bf1a3c83 ]

amd_pstate_update_limits() takes a cpufreq_policy reference but doesn't
decrement the refcount in one of the exit paths, fix that.

Fixes: 45722e777fd9 ("cpufreq: amd-pstate: Optimize amd_pstate_update_limits()")
Signed-off-by: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250205112523.201101-10-dhananjay.ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index bdaa19c25887b..0aea414b8ac4a 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -809,20 +809,21 @@ static void amd_pstate_init_prefcore(struct amd_cpudata *cpudata)
 
 static void amd_pstate_update_limits(unsigned int cpu)
 {
-	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+	struct cpufreq_policy *policy = NULL;
 	struct amd_cpudata *cpudata;
 	u32 prev_high = 0, cur_high = 0;
 	int ret;
 	bool highest_perf_changed = false;
 
+	if (!amd_pstate_prefcore)
+		return;
+
+	policy = cpufreq_cpu_get(cpu);
 	if (!policy)
 		return;
 
 	cpudata = policy->driver_data;
 
-	if (!amd_pstate_prefcore)
-		return;
-
 	guard(mutex)(&amd_pstate_driver_lock);
 
 	ret = amd_get_highest_perf(cpu, &cur_high);
-- 
2.39.5



