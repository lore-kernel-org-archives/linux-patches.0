Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8083A5422;
	Sat, 12 Sep 2026 11:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212683; cv=none; b=ACkAW83WRBD7ihelhCeL6GznuBiE/ujvx9x59wTczD8qjwEx2v0yetAAvfiEfOIrPRLiekvDwqwi1gSgg4wyuKPElM9TtigKJAeBhfJKkvht2e0aWjOyCLU+BrzziEMM6bYWT0sMzIjZNFxj0WjHGGJAZs8mXpthx/A7Usqw5oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212683; c=relaxed/simple;
	bh=U2T9YRE4g5nf3pFzsxQTvJwi+fUemtOrK+tchem+cpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdZVQvxRG6SoV/zJJ42KwH+att/IOfuzTv2gPJhJf42ZiMz5Tbpp1E07Dhq5nPWYE3jPF4rab0e7BLk1Osjjv7CiJhcnwJTlFSwSctDdc3BeZZUcx/99Aeut6P8g6MjBmabsW2ki92prXIxPx+B4xa+/xFYjGLqJolFBdcXWCcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haiX6GMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haiX6GMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D931F000FF;
	Sat, 12 Sep 2026 11:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212682;
	bh=pGFgLQxTecLkKwBecSK9hJAkbRaHauD7wevRZ6ctZu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=haiX6GMfWovn0CqDMtFGQlY8Zh2RqnGHVXFzjoMAYMz5wIbcSiK6tHv04JP+YeU37
	 OXDYcCo40WBDKRtzGJ+Z+Dh6Y2gmuD/0xhWaq6YwQ3aK9E9zbySCAYN+kB22L6Lf2f
	 Y61k6qdt+D8EeOEFqZj6yYXDas54oIKl8JHFwziQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	EDAMAMEX <edame8080@gmail.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1469/1518] cpufreq/amd-pstate: handle missing policy in dynamic EPP callbacks
Date: Sat, 12 Sep 2026 09:00:38 +0200
Message-ID: <20260912065656.785918742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0b29213a019f5..627d578c7e13a 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1113,6 +1113,9 @@ static int amd_pstate_power_supply_notifier(struct notifier_block *nb,
 	if (cpudata->current_profile != PLATFORM_PROFILE_BALANCED)
 		return 0;
 
+	if (!policy)
+		return NOTIFY_OK;
+
 	epp = amd_pstate_get_balanced_epp(policy);
 
 	ret = amd_pstate_set_epp(policy, epp);
@@ -1148,6 +1151,9 @@ static int amd_pstate_profile_set(struct device *dev,
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



