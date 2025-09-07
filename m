Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F871A2389;
	Sun,  7 Sep 2025 20:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276440; cv=none; b=oMrZ2mGTUwQYffZwUIneWWA7bhWUbUWfLyOeFkTuaP2A1MpvBslQCteNe1xEK+NFkikMOefoN3nUKT46wIbcGCMdPe++XrZGizvK842s15cI4pVzaLDGBei8/hYMu8PuZZ/1hSt1FPcS5HczlWZMnPzmAFY4/8+Nm8f6tzEZVsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276440; c=relaxed/simple;
	bh=N3Us1O8027yb6VRehi/XzhI6zFjFjhjJoOz7AcuYDEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sL8t0gjj4GlaZitsDK3FKuPHzq9l952EKitP+Lo5Qf5rf2hdXTRfqokyt1Ajj9kPk74vg34FWBwpHNrL4J89qcr2UxwV2LqcZFfGWmENVeHyk63NSbVDas2+r/vJ6noskqm9ef/V3B5Dr44VAs9rUAZpCQ+FUmiUtAQtuTKOv2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vn3u0hT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vn3u0hT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E9BC4CEF0;
	Sun,  7 Sep 2025 20:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276440;
	bh=N3Us1O8027yb6VRehi/XzhI6zFjFjhjJoOz7AcuYDEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vn3u0hT6sW0B09E3+kozJPdGwkY01gViUXPrhGOtVoAmkJpSzb1KtSCpahbX7UKXy
	 3MdULlrfaal6qUxKvzD3jJyMMbbZdG5jILFqluQGB45+D5PYXGeLsrY0aBFXlGrml+
	 eBjVz0MAZ2MZdESLWkAl9ETX/BKHT1+fxbQa8ztk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/104] cpufreq: intel_pstate: Read global.no_turbo under READ_ONCE()
Date: Sun,  7 Sep 2025 21:59:00 +0200
Message-ID: <20250907195610.334686696@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0395bc0317a18..7570d6d1ca8c0 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1264,7 +1264,7 @@ static ssize_t store_no_turbo(struct kobject *a, struct kobj_attribute *b,
 		goto unlock_driver;
 	}
 
-	global.no_turbo = no_turbo;
+	WRITE_ONCE(global.no_turbo, no_turbo);
 
 	mutex_lock(&intel_pstate_limits_lock);
 
@@ -1730,7 +1730,7 @@ static u64 atom_get_val(struct cpudata *cpudata, int pstate)
 	u32 vid;
 
 	val = (u64)pstate << 8;
-	if (global.no_turbo && !global.turbo_disabled)
+	if (READ_ONCE(global.no_turbo) && !global.turbo_disabled)
 		val |= (u64)1 << 32;
 
 	vid_fp = cpudata->vid.min + mul_fp(
@@ -1900,7 +1900,7 @@ static u64 core_get_val(struct cpudata *cpudata, int pstate)
 	u64 val;
 
 	val = (u64)pstate << 8;
-	if (global.no_turbo && !global.turbo_disabled)
+	if (READ_ONCE(global.no_turbo) && !global.turbo_disabled)
 		val |= (u64)1 << 32;
 
 	return val;
@@ -2186,7 +2186,7 @@ static inline int32_t get_target_pstate(struct cpudata *cpu)
 
 	sample->busy_scaled = busy_frac * 100;
 
-	target = global.no_turbo || global.turbo_disabled ?
+	target = READ_ONCE(global.no_turbo) ?
 			cpu->pstate.max_pstate : cpu->pstate.turbo_pstate;
 	target += target >> 2;
 	target = mul_fp(target, busy_frac);
@@ -2455,7 +2455,7 @@ static void intel_pstate_clear_update_util_hook(unsigned int cpu)
 
 static int intel_pstate_get_max_freq(struct cpudata *cpu)
 {
-	return global.turbo_disabled || global.no_turbo ?
+	return READ_ONCE(global.no_turbo) ?
 			cpu->pstate.max_freq : cpu->pstate.turbo_freq;
 }
 
@@ -2592,7 +2592,7 @@ static void intel_pstate_verify_cpu_policy(struct cpudata *cpu,
 
 	if (hwp_active) {
 		intel_pstate_get_hwp_cap(cpu);
-		max_freq = global.no_turbo || global.turbo_disabled ?
+		max_freq = READ_ONCE(global.no_turbo) ?
 				cpu->pstate.max_freq : cpu->pstate.turbo_freq;
 	} else {
 		max_freq = intel_pstate_get_max_freq(cpu);
-- 
2.51.0



