Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84483EF0A2;
	Tue, 31 Mar 2026 16:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976026; cv=none; b=acf6+wVO33gKFrjNvGPdolAxeAGJDuklnitTkMmHxBBCzviNggxwz3JvTdmbW4+IgZErr67jgBCgxWG0+QP0wmrq0e03zQ3zd7OOL5S0VC677aUMi4a9eT/mFfBVJ6V9Y7Xdl5Cz+vAXgqtXWh//VyXykrt/Dr6ZL0PNSZOnhBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976026; c=relaxed/simple;
	bh=wFovXf2HDDEktjKZ4Qxs6EibCQJeUcbQ7UmdWeDzyI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpJPptBTCiDCNCrEqGheQx/+qxQ+Q9OFSa617rGjbrhI3z0NFM6/Y4dMzqw4TocJ1+1rIJ7Ah6gOC2wKOAsUfgOnUKPu9ePUZsgbMb8GWZcpE6ro5BStiGfQ9Lgxw6VGEpvnYva0aMBxZbzNJBs+uPnpp0ZZfuB3HmEDJHWwvYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ff3K9uEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ff3K9uEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603CCC19423;
	Tue, 31 Mar 2026 16:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976026;
	bh=wFovXf2HDDEktjKZ4Qxs6EibCQJeUcbQ7UmdWeDzyI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ff3K9uEIoY5YTQ66JOBW1tERN2sbxJhT6+9yFKOHox9+O0soi7uTZqGsy2mTSKJnH
	 sXSOD7R+JmopsL8kKmr0D+V+slVobRKHDwrPuZl8l4zki+wGovpIfKEh1B0yv2rIKv
	 j39frmdtLnx28yi4sn7I+egj52Ktqc7324dUegLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 146/244] cpufreq: conservative: Reset requested_freq on limits change
Date: Tue, 31 Mar 2026 18:21:36 +0200
Message-ID: <20260331161747.157285850@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -313,6 +313,17 @@ static void cs_start(struct cpufreq_poli
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
 	.kobj_type = { .default_groups = cs_groups },
@@ -322,6 +333,7 @@ static struct dbs_governor cs_governor =
 	.init = cs_init,
 	.exit = cs_exit,
 	.start = cs_start,
+	.limits = cs_limits,
 };
 
 #define CPU_FREQ_GOV_CONSERVATIVE	(cs_governor.gov)
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -563,6 +563,7 @@ EXPORT_SYMBOL_GPL(cpufreq_dbs_governor_s
 
 void cpufreq_dbs_governor_limits(struct cpufreq_policy *policy)
 {
+	struct dbs_governor *gov = dbs_governor_of(policy);
 	struct policy_dbs_info *policy_dbs;
 
 	/* Protect gov->gdbs_data against cpufreq_dbs_governor_exit() */
@@ -574,6 +575,8 @@ void cpufreq_dbs_governor_limits(struct
 	mutex_lock(&policy_dbs->update_mutex);
 	cpufreq_policy_apply_limits(policy);
 	gov_update_sample_delay(policy_dbs, 0);
+	if (gov->limits)
+		gov->limits(policy);
 	mutex_unlock(&policy_dbs->update_mutex);
 
 out:
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -138,6 +138,7 @@ struct dbs_governor {
 	int (*init)(struct dbs_data *dbs_data);
 	void (*exit)(struct dbs_data *dbs_data);
 	void (*start)(struct cpufreq_policy *policy);
+	void (*limits)(struct cpufreq_policy *policy);
 };
 
 static inline struct dbs_governor *dbs_governor_of(struct cpufreq_policy *policy)


