Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41032371887;
	Sat, 12 Sep 2026 10:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208111; cv=none; b=AymA+oFytgGo+TJb0diTnbgKHBVxdqG6v/KXglGhYFmtbt1vXshaJTFpIQY1NOX25h6EwmtTI/kCmr8jwvFvjalqeSZoPXKrIrs7P11Ker5svtGDl/rK5zMlMSJW+tWFpoyVJoQSIzCRf2sejujv1+kdGa8LCF7q0MYJnM29aVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208111; c=relaxed/simple;
	bh=VA9CQUj1XyzBq5VPxsBArCMxyVlsZlYjLCPRSoYvl2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBHsabowf/1qYUGxUndQf2AdL/BM90/K/sMnAP3mW+dVU6dXxoLC4ZlwY5IKoV6ePimPGmox6aJmDHhTscSl/T5dWVYm1Cp1l/4+zYX4YWrQpZSFbIklIp7sVXVNrYIuntky8c0JtL3rNIkD3Re+lc1a5Hf2S56eC/qOZy4Z6eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gX6QkgAn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gX6QkgAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB731F000FF;
	Sat, 12 Sep 2026 10:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208110;
	bh=Hxm34tqlFH4XsZ0L5HWrY7L4h+fGGowdJi2ij9/wx2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gX6QkgAngqCFCOX8PxLK4inKQ+oKgjC2GLBaaDww+PnZsY1G1Uy81IxzuWxoB/oyx
	 r+P2q63Osm8cqfcBO3XeRxjzJkMsqlveKSwZ6HmzDqYGKo0cmDb+bww2Zd5cg1r3mF
	 PMDIG6RIDFhaUETKNOWq3wIOM6fg6GpdijCbwKj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Marco Scardovi <scardracs@disroot.org>,
	K Prateek Nayak <kprateek.anayk@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0549/1518] cpufreq/amd-pstate: Fix EPP return type and handle errors during initialization
Date: Sat, 12 Sep 2026 08:45:18 +0200
Message-ID: <20260912065635.859552569@linuxfoundation.org>
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

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit 57476909c3000a04e84a1d6018d63ba1b2aa20ab ]

Currently, the EPP getter helper functions (msr_get_epp, shmem_get_epp, and
the static call wrapper amd_pstate_get_epp) return u8 or s16. This makes it
difficult to correctly propagate negative error values returned by the
underlying MSR read or CPPC helpers (such as rdmsrq_on_cpu or
cppc_get_epp_perf).

Modify the return type of these functions to int, allowing them to return
negative error codes properly.

Additionally, in amd_pstate_epp_cpu_init(), fetch the firmware-programmed
default EPP value and validate it before assigning it to the EPP variables.
If amd_pstate_get_epp() returns an error code, propagate the error and abort
the CPU initialization to prevent subsequent configuration failures.

Fixes: 555bbe67a622 ("cpufreq/amd-pstate: Convert all perf values to u8")
Assisted-by: Antigravity:gemini-3.5-flash
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Reviewed-by: K Prateek Nayak <kprateek.anayk@amd.com>
Link: https://lore.kernel.org/r/20260609073042.81275-2-scardracs@disroot.org
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 9bec26f4e842d..259f04d89a79c 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -197,7 +197,7 @@ static inline int get_mode_idx_from_str(const char *str, size_t size)
 
 static DEFINE_MUTEX(amd_pstate_driver_lock);
 
-static u8 msr_get_epp(struct amd_cpudata *cpudata)
+static int msr_get_epp(struct amd_cpudata *cpudata)
 {
 	u64 value;
 	int ret;
@@ -213,12 +213,12 @@ static u8 msr_get_epp(struct amd_cpudata *cpudata)
 
 DEFINE_STATIC_CALL(amd_pstate_get_epp, msr_get_epp);
 
-static inline s16 amd_pstate_get_epp(struct amd_cpudata *cpudata)
+static inline int amd_pstate_get_epp(struct amd_cpudata *cpudata)
 {
 	return static_call(amd_pstate_get_epp)(cpudata);
 }
 
-static u8 shmem_get_epp(struct amd_cpudata *cpudata)
+static int shmem_get_epp(struct amd_cpudata *cpudata)
 {
 	u64 epp;
 	int ret;
@@ -1716,6 +1716,7 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 	struct amd_cpudata *cpudata;
 	union perf_cached perf;
 	struct device *dev;
+	int default_epp;
 	int ret;
 
 	/*
@@ -1767,6 +1768,13 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 
 	policy->boost_supported = READ_ONCE(cpudata->boost_supported);
 
+	/* Fetch the firmware programmed default EPP value */
+	default_epp = amd_pstate_get_epp(cpudata);
+	if (default_epp < 0) {
+		ret = default_epp;
+		goto free_cpudata1;
+	}
+
 	/*
 	 * Set the policy to provide a valid fallback value in case
 	 * the default cpufreq governor is neither powersave nor performance.
@@ -1774,7 +1782,7 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 	if (amd_pstate_acpi_pm_profile_server() ||
 	    amd_pstate_acpi_pm_profile_undefined()) {
 		policy->policy = CPUFREQ_POLICY_PERFORMANCE;
-		cpudata->epp_default_ac = cpudata->epp_default_dc = amd_pstate_get_epp(cpudata);
+		cpudata->epp_default_ac = cpudata->epp_default_dc = default_epp;
 		cpudata->current_profile = PLATFORM_PROFILE_PERFORMANCE;
 	} else {
 		policy->policy = CPUFREQ_POLICY_POWERSAVE;
-- 
2.53.0



