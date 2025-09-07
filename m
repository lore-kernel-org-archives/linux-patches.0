Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA691A2389;
	Sun,  7 Sep 2025 20:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276437; cv=none; b=vGch2ZMo/WSAPD/2ilZTqAs5R+yJ0R94Gfc8rv0eUl4+EaQ/ExMU80n7Hp08DMLCNjK0eJnzGpbegV3bLO5lwL8JBP32gWOdwknR9PJNOCaT7Qdr4GmbymxJ1O4PNj5IF9vvYOb74EjQLaNSObIligHkcdImFpnm4Q7jQRti5dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276437; c=relaxed/simple;
	bh=EKDAJ2ucm82fv9IXm1qX1u7bLa/mqCdR9k82JALYSFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOkTHoCay51SalWPhv+7lwQixAmcqohknQ+D6k5cDW4aE4r2CmGZqnkXvbXnHgaCnWcFWsensz2gJQGEEuLNtdxDCbxa78kj609pSAi7nhJpPOHdIkRYzpTr9eTtV/aDHtXanGE/TqoxknEOVIDhZf8ScFkWdZpSS/gL5oEyyzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2arky+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2arky+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669B1C4CEF0;
	Sun,  7 Sep 2025 20:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276437;
	bh=EKDAJ2ucm82fv9IXm1qX1u7bLa/mqCdR9k82JALYSFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2arky+MLs8WFw0a3T2Gv66zOj3IrH6u4brEO8jEPDg8lSOc28Tmxy+TRxwRph2vW
	 O7LIwZkp+h2334gPjV/Fo4G4n2ZD2ozcySgD3mN/z892uRgj7cr0llZj7KE/6chXzk
	 VNkcTg2ux4urSaNKHFHljpHPSRQREOqnQAAnFwvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/104] cpufreq: intel_pstate: Rearrange show_no_turbo() and store_no_turbo()
Date: Sun,  7 Sep 2025 21:58:59 +0200
Message-ID: <20250907195610.309312903@linuxfoundation.org>
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

[ Upstream commit c626a438452079824139f97137f17af47b1a8989 ]

Now that global.turbo_disabled can only change at the cpufreq driver
registration time, initialize global.no_turbo at that time too so they
are in sync to start with (if the former is set, the latter cannot be
updated later anyway).

That allows show_no_turbo() to be simlified because it does not need
to check global.turbo_disabled and store_no_turbo() can be rearranged
to avoid doing anything if the new value of global.no_turbo is equal
to the current one and only return an error on attempts to clear
global.no_turbo when global.turbo_disabled.

While at it, eliminate the redundant ret variable from store_no_turbo().

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Stable-dep-of: 350cbb5d2f67 ("cpufreq: intel_pstate: Check turbo_is_disabled() in store_no_turbo()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 7d28bf7548cfa..0395bc0317a18 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1230,10 +1230,7 @@ static ssize_t show_no_turbo(struct kobject *kobj,
 		return -EAGAIN;
 	}
 
-	if (global.turbo_disabled)
-		ret = sprintf(buf, "%u\n", global.turbo_disabled);
-	else
-		ret = sprintf(buf, "%u\n", global.no_turbo);
+	ret = sprintf(buf, "%u\n", global.no_turbo);
 
 	mutex_unlock(&intel_pstate_driver_lock);
 
@@ -1244,31 +1241,34 @@ static ssize_t store_no_turbo(struct kobject *a, struct kobj_attribute *b,
 			      const char *buf, size_t count)
 {
 	unsigned int input;
-	int ret;
+	bool no_turbo;
 
-	ret = sscanf(buf, "%u", &input);
-	if (ret != 1)
+	if (sscanf(buf, "%u", &input) != 1)
 		return -EINVAL;
 
 	mutex_lock(&intel_pstate_driver_lock);
 
 	if (!intel_pstate_driver) {
-		mutex_unlock(&intel_pstate_driver_lock);
-		return -EAGAIN;
+		count = -EAGAIN;
+		goto unlock_driver;
 	}
 
-	mutex_lock(&intel_pstate_limits_lock);
+	no_turbo = !!clamp_t(int, input, 0, 1);
+
+	if (no_turbo == global.no_turbo)
+		goto unlock_driver;
 
 	if (global.turbo_disabled) {
 		pr_notice_once("Turbo disabled by BIOS or unavailable on processor\n");
-		mutex_unlock(&intel_pstate_limits_lock);
-		mutex_unlock(&intel_pstate_driver_lock);
-		return -EPERM;
+		count = -EPERM;
+		goto unlock_driver;
 	}
 
-	global.no_turbo = clamp_t(int, input, 0, 1);
+	global.no_turbo = no_turbo;
+
+	mutex_lock(&intel_pstate_limits_lock);
 
-	if (global.no_turbo) {
+	if (no_turbo) {
 		struct cpudata *cpu = all_cpu_data[0];
 		int pct = cpu->pstate.max_pstate * 100 / cpu->pstate.turbo_pstate;
 
@@ -1280,8 +1280,9 @@ static ssize_t store_no_turbo(struct kobject *a, struct kobj_attribute *b,
 	mutex_unlock(&intel_pstate_limits_lock);
 
 	intel_pstate_update_policies();
-	arch_set_max_freq_ratio(global.no_turbo);
+	arch_set_max_freq_ratio(no_turbo);
 
+unlock_driver:
 	mutex_unlock(&intel_pstate_driver_lock);
 
 	return count;
@@ -3078,6 +3079,7 @@ static int intel_pstate_register_driver(struct cpufreq_driver *driver)
 	memset(&global, 0, sizeof(global));
 	global.max_perf_pct = 100;
 	global.turbo_disabled = turbo_is_disabled();
+	global.no_turbo = global.turbo_disabled;
 
 	arch_set_max_freq_ratio(global.turbo_disabled);
 
-- 
2.51.0



