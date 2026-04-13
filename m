Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F6C2D8364;
	Mon, 13 Apr 2026 16:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098125; cv=none; b=PvTTwo427sZ8yZhDPrSHyejFFpQ2+8/YDq+r9+WUxSsoO4CdIk1GqVD9f6Ma+61UJWUid7MVgu2/+BetpYiQHsHbJE0zzBQFxehVLuqaOcL7MbJ2iK86jFkFlWMcZ5eCuu2xW7VJMi97jjJQInv12qHbZY325mrnVuqIq4lp3HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098125; c=relaxed/simple;
	bh=x+Hr0nys4A4qGS2u4Tme/cLu0huml+cUhM9HMRmJoh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLsV4Snnz1Jcwi/RVPEWhxDOdELBDZoggpe1WVZ1KBN3GY4j3kTVjoJOnzSglN8F9+hLpGmVmZTQTuFkE0MAkUca3MUcBWH6e0UqNivVE6iE6LndISo5l3K/RfH7acbZ7Wb6NZ9dS08/iVpkK6ic9U77RSx8Dh+t0PZ3EEdCV3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhkIwaDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhkIwaDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF786C2BCAF;
	Mon, 13 Apr 2026 16:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098125;
	bh=x+Hr0nys4A4qGS2u4Tme/cLu0huml+cUhM9HMRmJoh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhkIwaDu8mYakTq5VyHvKXeODXsxFUsm9kYFsrOR+zNhBVqK69uVs8DifKRBwpQJ5
	 GKcvrYx5Y3lRJcU/vDsaBZvKkNprS33v0DqAh0LLGU0TsUc6Xc3Bla093T5/RV6jLi
	 ZdVKqw/n6gPMtOyXqZ0tuuorMnS/TpoGOuPkfsNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 371/570] cpufreq: conservative: Reset requested_freq on limits change
Date: Mon, 13 Apr 2026 17:58:22 +0200
Message-ID: <20260413155844.376072677@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 6a28fb8cb28b9eb39a392e531d938a889eacafc5 upstream.

A recently reported issue highlighted that the cached requested_freq
is not guaranteed to stay in sync with policy->cur. If the platform
changes the actual CPU frequency after the governor sets one (e.g.
due to platform-specific frequency scaling) and a re-sync occurs
later, policy->cur may diverge from requested_freq.

This can lead to incorrect behavior in the conservative governor.
For example, the governor may assume the CPU is already running at
the maximum frequency and skip further increases even though there
is still headroom.

Avoid this by resetting the cached requested_freq to policy->cur on
detecting a change in policy limits.

Reported-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Tested-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://lore.kernel.org/all/20260210115458.3493646-1-zhenglifeng1@huawei.com/
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/d846a141a98ac0482f20560fcd7525c0f0ec2f30.1773999467.git.viresh.kumar@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq_conservative.c |   12 ++++++++++++
 drivers/cpufreq/cpufreq_governor.c     |    3 +++
 drivers/cpufreq/cpufreq_governor.h     |    1 +
 3 files changed, 16 insertions(+)

--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -311,6 +311,17 @@ static void cs_start(struct cpufreq_poli
 	dbs_info->requested_freq = policy->cur;
 }
 
+static void cs_limits(struct cpufreq_policy *policy)
+{
+	struct cs_policy_dbs_info *dbs_info = to_dbs_info(policy->governor_data);
+
+	/*
+	 * The limits have changed, so may have the current frequency. Reset
+	 * requested_freq to avoid any unintended outcomes due to the mismatch.
+	 */
+	dbs_info->requested_freq = policy->cur;
+}
+
 static struct dbs_governor cs_governor = {
 	.gov = CPUFREQ_DBS_GOVERNOR_INITIALIZER("conservative"),
 	.kobj_type = { .default_attrs = cs_attributes },
@@ -320,6 +331,7 @@ static struct dbs_governor cs_governor =
 	.init = cs_init,
 	.exit = cs_exit,
 	.start = cs_start,
+	.limits = cs_limits,
 };
 
 #define CPU_FREQ_GOV_CONSERVATIVE	(cs_governor.gov)
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -561,6 +561,7 @@ EXPORT_SYMBOL_GPL(cpufreq_dbs_governor_s
 
 void cpufreq_dbs_governor_limits(struct cpufreq_policy *policy)
 {
+	struct dbs_governor *gov = dbs_governor_of(policy);
 	struct policy_dbs_info *policy_dbs;
 
 	/* Protect gov->gdbs_data against cpufreq_dbs_governor_exit() */
@@ -572,6 +573,8 @@ void cpufreq_dbs_governor_limits(struct
 	mutex_lock(&policy_dbs->update_mutex);
 	cpufreq_policy_apply_limits(policy);
 	gov_update_sample_delay(policy_dbs, 0);
+	if (gov->limits)
+		gov->limits(policy);
 	mutex_unlock(&policy_dbs->update_mutex);
 
 out:
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -140,6 +140,7 @@ struct dbs_governor {
 	int (*init)(struct dbs_data *dbs_data);
 	void (*exit)(struct dbs_data *dbs_data);
 	void (*start)(struct cpufreq_policy *policy);
+	void (*limits)(struct cpufreq_policy *policy);
 };
 
 static inline struct dbs_governor *dbs_governor_of(struct cpufreq_policy *policy)


