Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF57428B4FA;
	Sat, 12 Sep 2026 07:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199606; cv=none; b=VAIdYmXUqNi7iMAalWwJBaE6Zzy4iVrpmOq2pz+/s1Efli4OC9/8djXP92asH6wiWsXxPmS/yjzy9EXbfzN9SVjAPf/Ec4Qfn8gsWUGS8E06t5Qxrmcyr2BGoYg7rz917JXqHkEKvzHGnnhKY0eSYDHlRJ4qNhljhTM1kiPKjTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199606; c=relaxed/simple;
	bh=DbtUwuq5TWMKzWoW75qAwFf3GCEP23q0SEfviBvexGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/wB7QjDZqk7MlfH2EUInY43EzgTbi6LpT40aELy2QB4c+WGKUVR7IUmrdJU8S68ojB1+vv5EkguDcpQnaqpzOxu8U406GQFB0i0W5ydvgpo97BJtgbqwXxcoE5ZVS7wMOGo34JDdhJopA0mI7dGZ0YifwWyVkAAIaVBgGtf8wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAF0xAxP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAF0xAxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D681A1F000FF;
	Sat, 12 Sep 2026 07:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199604;
	bh=7kYOnHmM+V/skhX07dGfXXEh2iRB/zAbW8LlexrxZqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NAF0xAxPSUPFg8qbhpENEYHa21B5k7h0uasNOVGzm2VRueDfw24sFs3NUw+J7r8of
	 4dbY02zUVx5QGaZLKn4Eg0/BSFb13UaKTZIjwzzZrdLsojyC5kj5sRRVHiVSNt4Jaa
	 9jcmGgSTEysuagVdIiCywc0R9iXYTlxNAWqAmOzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	EDAMAMEX <edame8080@gmail.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0619/1815] cpufreq/amd-pstate: handle missing policy in dynamic EPP callbacks
Date: Sat, 12 Sep 2026 08:39:29 +0200
Message-ID: <20260912065703.411994837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: EDAMAMEX <edame8080@gmail.com>

[ Upstream commit 39c0cf62fc7851a17782e7efe8dfb2948739c681 ]

cpufreq_cpu_get() returns NULL when no cpufreq policy is associated with
the requested CPU, for example because the CPU is offline or the policy
has already been torn down.  Both amd_pstate_power_supply_notifier() and
amd_pstate_profile_set() acquire a policy via cpufreq_cpu_get() and then
pass that pointer to amd_pstate_get_balanced_epp() and
amd_pstate_set_epp(), which dereference it unconditionally.  A racing
CPU hotplug or driver teardown can therefore lead to a NULL pointer
dereference on either of these dynamic EPP paths.

The third cpufreq_cpu_get() caller in this file, amd_pstate_verify(),
already handles the NULL case.  Bring the two new callers in line with
that pattern: return NOTIFY_OK from the power-supply notifier (matching
the other "nothing to do" exits) and -ENODEV from amd_pstate_profile_set()
(the usual cpufreq error for a missing CPU policy).

Found by code inspection; not tested on hardware.

Fixes: e30ca6dd5345 ("cpufreq/amd-pstate: Add dynamic energy performance preference")
Fixes: 798c47593cca ("cpufreq/amd-pstate: Add support for platform profile class")
Signed-off-by: EDAMAMEX <edame8080@gmail.com>
Link: https://lore.kernel.org/r/20260520070211.2753183-1-edame8080@gmail.com
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 3c2995686a504..31b320f329290 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1170,6 +1170,9 @@ static int amd_pstate_power_supply_notifier(struct notifier_block *nb,
 	if (cpudata->current_profile != PLATFORM_PROFILE_BALANCED)
 		return 0;
 
+	if (!policy)
+		return NOTIFY_OK;
+
 	epp = amd_pstate_get_balanced_epp(policy);
 
 	ret = amd_pstate_set_epp(policy, epp);
@@ -1205,6 +1208,9 @@ static int amd_pstate_profile_set(struct device *dev,
 	struct cpufreq_policy *policy __free(put_cpufreq_policy) = cpufreq_cpu_get(cpudata->cpu);
 	int ret;
 
+	if (!policy)
+		return -ENODEV;
+
 	switch (profile) {
 	case PLATFORM_PROFILE_LOW_POWER:
 		ret = amd_pstate_set_epp(policy, AMD_CPPC_EPP_POWERSAVE);
-- 
2.53.0



