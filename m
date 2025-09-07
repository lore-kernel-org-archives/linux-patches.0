Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96E6D528;
	Sun,  7 Sep 2025 20:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276814; cv=none; b=MpHyS2SyaUV+bpKtoI0X5pVvkZSYn55WBizELqZ7vbez6nqJM+dfXTLG+JaSs8dz1obe34yRi4Fm2gXqmyJfaAhL37k98PK/IUZpLrXKNVaxEUtImWVF3gI7WgaQinoPMKRoe44gbB3z92XE7SO9LxnSBxwGUEuNyYPkiHc84N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276814; c=relaxed/simple;
	bh=r4pFhoGSA23+KhCmimx4d4kEbSfDuN7/0G8NfffCcXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJjN/4zMjf2F73Uez+clEDJTHbxngEhFET3a4lhJBHzSahLtaPW1piFEVDKO/e3nsadQvrOtbFi1//BARC4G36ybl1XdUhSs9Uwl1mmBG7rdpqRtQI90ZGmy/Uu9qIg9nJG7Ql4XV646dbo7Th7fNNYUomc4EhpPQZKIKUBtTIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAqrf1sl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAqrf1sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705E9C4CEF0;
	Sun,  7 Sep 2025 20:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276813;
	bh=r4pFhoGSA23+KhCmimx4d4kEbSfDuN7/0G8NfffCcXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAqrf1slgJEZO6VcLEA1U68b5LVRJvpgEQ/rBYPj+T7r87lRtrKsvgRzTb0841qvb
	 rbgpeR9+/QpD6mb/whr59lpBdy8tWYxcSWuCbgv3xbpXeVys5hmwgSjBB5D8auI65r
	 7XESqGRuYV4uxwTHqOPDtKDxNmLiN/VUf4IjtZTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/121] cpufreq: intel_pstate: Read global.no_turbo under READ_ONCE()
Date: Sun,  7 Sep 2025 21:59:14 +0200
Message-ID: <20250907195612.878434693@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 9558fae8ce97b3b320b387dd7c88309df2c36d4d ]

Because global.no_turbo is generally not read under intel_pstate_driver_lock
make store_no_turbo() use WRITE_ONCE() for updating it (this is the only
place at which it is updated except for the initialization) and make the
majority of places reading it use READ_ONCE().

Also remove redundant global.turbo_disabled checks from places that
depend on the 'true' value of global.no_turbo because it can only be
'true' if global.turbo_disabled is also 'true'.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Stable-dep-of: 350cbb5d2f67 ("cpufreq: intel_pstate: Check turbo_is_disabled() in store_no_turbo()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 8bac7afb13a3d..05aae7e6da157 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1297,7 +1297,7 @@ static ssize_t store_no_turbo(struct kobject *a, struct kobj_attribute *b,
 		goto unlock_driver;
 	}
 
-	global.no_turbo = no_turbo;
+	WRITE_ONCE(global.no_turbo, no_turbo);
 
 	mutex_lock(&intel_pstate_limits_lock);
 
@@ -1766,7 +1766,7 @@ static u64 atom_get_val(struct cpudata *cpudata, int pstate)
 	u32 vid;
 
 	val = (u64)pstate << 8;
-	if (global.no_turbo && !global.turbo_disabled)
+	if (READ_ONCE(global.no_turbo) && !global.turbo_disabled)
 		val |= (u64)1 << 32;
 
 	vid_fp = cpudata->vid.min + mul_fp(
@@ -1931,7 +1931,7 @@ static u64 core_get_val(struct cpudata *cpudata, int pstate)
 	u64 val;
 
 	val = (u64)pstate << 8;
-	if (global.no_turbo && !global.turbo_disabled)
+	if (READ_ONCE(global.no_turbo) && !global.turbo_disabled)
 		val |= (u64)1 << 32;
 
 	return val;
@@ -2229,7 +2229,7 @@ static inline int32_t get_target_pstate(struct cpudata *cpu)
 
 	sample->busy_scaled = busy_frac * 100;
 
-	target = global.no_turbo || global.turbo_disabled ?
+	target = READ_ONCE(global.no_turbo) ?
 			cpu->pstate.max_pstate : cpu->pstate.turbo_pstate;
 	target += target >> 2;
 	target = mul_fp(target, busy_frac);
@@ -2490,7 +2490,7 @@ static void intel_pstate_clear_update_util_hook(unsigned int cpu)
 
 static int intel_pstate_get_max_freq(struct cpudata *cpu)
 {
-	return global.turbo_disabled || global.no_turbo ?
+	return READ_ONCE(global.no_turbo) ?
 			cpu->pstate.max_freq : cpu->pstate.turbo_freq;
 }
 
@@ -2627,7 +2627,7 @@ static void intel_pstate_verify_cpu_policy(struct cpudata *cpu,
 
 	if (hwp_active) {
 		intel_pstate_get_hwp_cap(cpu);
-		max_freq = global.no_turbo || global.turbo_disabled ?
+		max_freq = READ_ONCE(global.no_turbo) ?
 				cpu->pstate.max_freq : cpu->pstate.turbo_freq;
 	} else {
 		max_freq = intel_pstate_get_max_freq(cpu);
-- 
2.51.0



