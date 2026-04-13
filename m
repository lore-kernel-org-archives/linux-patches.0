Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617BC320393;
	Mon, 13 Apr 2026 16:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099324; cv=none; b=fTvexMBByVQzPn5PXgt30uchazvWQsssYAyWhCOpIHlJXg4lfbpbbwsR87YOPXxMGgHjGQSPuIJkR17SEnJCBzxQ6KI3ih/PATXM5llROWEsmBGojP8837tS5spgZVA3In48HSzkeUA4lviMxeIuyQ4pnhhmcPFtnSfmXRwqfVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099324; c=relaxed/simple;
	bh=/4hDDq8UYmDzlei9dCXhhVChGa1bziKr167cw6lSnpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2uLYsxEx1HfqNR4SBIxyMeGtk32i9RLPGN6+Bl/6REQydmgPmMN5A4sXh5XUZ5xP2YDrpB1+U8ch6sPMUdkwtAPrkP4knRsg4CgHiRblmdvjGRbt4i5Lo9USN9VXu7cABDSmnCR27R5TLu86KLVKT124xmsWv1d6c3oz4CI3K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbKaBjiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbKaBjiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CDDC2BCAF;
	Mon, 13 Apr 2026 16:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099324;
	bh=/4hDDq8UYmDzlei9dCXhhVChGa1bziKr167cw6lSnpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbKaBjiB62QqqXWRC7lVm4WAcbXydDXUC+TadNBzU0u8Mq0Acgd+zIiMRpz7VU2Mh
	 +QZfjO7kal/Qv1DE6TTocvfbdLRoKFJ7IKJOFR2sQG28Dfg8K/1og0q1vUteP3difW
	 4m+yoxIErN2BHcQvXVEzIGSFYRaDoMfR4MGmi42s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 297/491] cpufreq: conservative: Reset requested_freq on limits change
Date: Mon, 13 Apr 2026 17:59:02 +0200
Message-ID: <20260413155830.162589842@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -555,6 +555,7 @@ EXPORT_SYMBOL_GPL(cpufreq_dbs_governor_s
 
 void cpufreq_dbs_governor_limits(struct cpufreq_policy *policy)
 {
+	struct dbs_governor *gov = dbs_governor_of(policy);
 	struct policy_dbs_info *policy_dbs;
 
 	/* Protect gov->gdbs_data against cpufreq_dbs_governor_exit() */
@@ -566,6 +567,8 @@ void cpufreq_dbs_governor_limits(struct
 	mutex_lock(&policy_dbs->update_mutex);
 	cpufreq_policy_apply_limits(policy);
 	gov_update_sample_delay(policy_dbs, 0);
+	if (gov->limits)
+		gov->limits(policy);
 	mutex_unlock(&policy_dbs->update_mutex);
 
 out:
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -139,6 +139,7 @@ struct dbs_governor {
 	int (*init)(struct dbs_data *dbs_data);
 	void (*exit)(struct dbs_data *dbs_data);
 	void (*start)(struct cpufreq_policy *policy);
+	void (*limits)(struct cpufreq_policy *policy);
 };
 
 static inline struct dbs_governor *dbs_governor_of(struct cpufreq_policy *policy)


