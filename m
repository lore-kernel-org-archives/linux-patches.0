Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F9BF9E1
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81135C433C8;
	Mon, 11 Sep 2023 14:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442760;
	bh=tIMFiffZKRUW3WkZxP46aNBlsfFAhvHkOygP8g4tv8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liqlSZO15yYcW8++Q2jOGpnVHQxPTrjlUqZtV3T6IsJnY2w/puIfCD6Ib2xBxKajo
	 tTEbSXMVhAtlpqXP2u6r4rciFwHPY+2ql72sYVMpnn4QptrkgBCdLJYIB/PM3Q4D8q
	 RqR8ipjRlnoPkGsY9ITa/LYk84K6iMWn9Z59lxDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sumit Gupta <sumitg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 138/737] cpufreq: tegra194: add online/offline hooks
Date: Mon, 11 Sep 2023 15:39:57 +0200
Message-ID: <20230911134654.356075505@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit a3aa97be69a7cc14ddc2bb0add0b9c51cb74bf83 ]

Implement the light-weight tear down and bring up helpers to reduce the
amount of work to do on CPU offline/online operation.
This change helps to make the hotplugging paths much faster.

Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://lore.kernel.org/lkml/20230816033402.3abmugb5goypvllm@vireshk-i7/
[ Viresh: Fixed rebase conflict ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: de0e85b29edf ("cpufreq: tegra194: remove opp table in exit hook")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/tegra194-cpufreq.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/cpufreq/tegra194-cpufreq.c b/drivers/cpufreq/tegra194-cpufreq.c
index 36dad5ea59475..4f572eb7842f5 100644
--- a/drivers/cpufreq/tegra194-cpufreq.c
+++ b/drivers/cpufreq/tegra194-cpufreq.c
@@ -508,6 +508,21 @@ static int tegra194_cpufreq_init(struct cpufreq_policy *policy)
 	return 0;
 }
 
+static int tegra194_cpufreq_online(struct cpufreq_policy *policy)
+{
+	/* We did light-weight tear down earlier, nothing to do here */
+	return 0;
+}
+
+static int tegra194_cpufreq_offline(struct cpufreq_policy *policy)
+{
+	/*
+	 * Preserve policy->driver_data and don't free resources on light-weight
+	 * tear down.
+	 */
+	return 0;
+}
+
 static int tegra194_cpufreq_set_target(struct cpufreq_policy *policy,
 				       unsigned int index)
 {
@@ -535,6 +550,8 @@ static struct cpufreq_driver tegra194_cpufreq_driver = {
 	.target_index = tegra194_cpufreq_set_target,
 	.get = tegra194_get_speed,
 	.init = tegra194_cpufreq_init,
+	.online = tegra194_cpufreq_online,
+	.offline = tegra194_cpufreq_offline,
 	.attr = cpufreq_generic_attr,
 };
 
-- 
2.40.1



