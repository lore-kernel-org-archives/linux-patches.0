Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E797D1E378C;
	Wed, 19 Feb 2025 08:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955260; cv=none; b=ScIY/sc/mqxy9p9gZb/lsqRMBq0FqeMb2RGiqlb5U08xxiNJssPsovrtazQW+S+OoOA4rsACFE5uyMLM33tgLek2kinlDUm0C/N+LviyUeZcEMR7V3N3quArS6bXesuNUon8Ds76IEf33TDwXDTO8ZVFRQfG1J5zQYI7BxEk/ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955260; c=relaxed/simple;
	bh=ExTw6N0WjvaOu0hI1N+bqq/zmCQMaJKQWFfjpg89N3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zs17wUs+IG+Sk1GBW9bURz9JDFaeE5Wl/C02RCQtsWNW/uexlTnzTWiZnBLo/6qC0WY0jVeD/d4ZqYzWzYKQLHM0njSKHHyGSQKP7QpGbO+E29V1wYR+H8rNhrDCR/Lspcw5y/+T8Epz8qZXuy3+lPjU6QvdWbJSWp3OkdCHn6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVgiN290; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVgiN290"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04280C4CED1;
	Wed, 19 Feb 2025 08:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955257;
	bh=ExTw6N0WjvaOu0hI1N+bqq/zmCQMaJKQWFfjpg89N3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVgiN290CASK2P92YbYod30jFIv1Afo6LNzqWFux4dey5OySPzFP4Q7VzYHjQZp7q
	 bvc8u4vAmaXZfGqd4nn138KHGO97/pQOGgl3jxNqh+TTGoUpZLQXJGJyM8E5Xb70PL
	 V/S9cOqK72hAuJ23o4j3Vwa/J9M9MDpiUgAIxLnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/230] cpufreq/amd-pstate: Fix cpufreq_policy ref counting
Date: Wed, 19 Feb 2025 09:28:18 +0100
Message-ID: <20250219082608.783154006@linuxfoundation.org>
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
index 33777f5ab7d16..bdfd8ffe04398 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -778,20 +778,21 @@ static void amd_pstate_init_prefcore(struct amd_cpudata *cpudata)
 
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



