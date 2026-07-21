Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA0243E9C9;
	Tue, 21 Jul 2026 22:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673534; cv=none; b=Rme3g8YyVE45x+e57FqNwAHbCx3aB2rtmyPDdvEYR4CbDM96RNQiw4Ipu775zaTjC1v0d365X9pZnlPTryZfq8n6CLVgpyelqhPPiUH5N/sAwmjGMTb2ygFncMD/IxOlnzRrt0/TIIn1qEOPeTZdcwvcIDB37h8sVo4THVZ+SuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673534; c=relaxed/simple;
	bh=PIjCIVkOwDYmAcLHA5CwnSGgcrje9kpyX1vVAsqOBg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMKbWXYksXP2Ap3e4BRP1YtF1U5pdyH/QiENoZBI1NwAT8aFvHsU7PE+1PBsmXvxzBENp8kCgZUnBaljadyiJ0lLBCAjYNhje50LvydMKDNvVTdDMEFT6P33xN8SfvOA1+nOdVuSjFLt1fi48eB9BUvFozlP+7YFeTTQK2D6u44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQx4EDPY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQx4EDPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F031F000E9;
	Tue, 21 Jul 2026 22:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673533;
	bh=n2ReYJWfP35FYMMHp7jk7/gDHu8mO8YZoK9EjJEgpW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nQx4EDPYHIuKNN+v/XRf4TV6rAxaMRh5RU4c2ixozr4b3dJAjRHRaFQYb4mfOKg5g
	 4fKPk9GDoSHXhoSH8RO7/Bno8QNl89GZWQF9B6+PuzMWmhz8ail3js3wf3l02SE4fC
	 hHZEk27XS9HBmpGxulZ5Q9kzspo6lY83ge47tBP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/699] cpufreq: conservative: Simplify frequency limit handling
Date: Tue, 21 Jul 2026 17:19:17 +0200
Message-ID: <20260721152400.163967368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 3494dff89779b73a6c70481c982e0e96d336454a ]

cs_dbs_update() performs explicit checks against policy->min/max
before updating the target frequency. These checks are redundant as
__cpufreq_driver_target() already clamps the requested frequency to
the valid policy limits.

Remove the unnecessary boundary checks and simplify the update logic.

This also fixes an issue introduced by commit 00bfe05889e9 ("cpufreq:
conservative: Decrease frequency faster for deferred updates"), where
stale target comparisons could cause frequency updates to be skipped
entirely after deferred adjustments.

Closes: https://lore.kernel.org/all/20260421123545.1745998-1-zhenglifeng1@huawei.com/
Fixes: 00bfe05889e9 ("cpufreq: conservative: Decrease frequency faster for deferred updates")
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Co-developed-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Link: https://patch.msgid.link/292e6d937890f135e30ec0d2107eaad47cb9a976.1779423281.git.viresh.kumar@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq_conservative.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 3225c7b747b08e..5817a3b9d5b2ef 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -103,10 +103,6 @@ static unsigned int cs_dbs_update(struct cpufreq_policy *policy)
 	if (load > dbs_data->up_threshold) {
 		dbs_info->down_skip = 0;
 
-		/* if we are already at full speed then break out early */
-		if (requested_freq == policy->max)
-			goto out;
-
 		requested_freq += freq_step;
 		if (requested_freq > policy->max)
 			requested_freq = policy->max;
@@ -123,13 +119,7 @@ static unsigned int cs_dbs_update(struct cpufreq_policy *policy)
 
 	/* Check for frequency decrease */
 	if (load < cs_tuners->down_threshold) {
-		/*
-		 * if we cannot reduce the frequency anymore, break out early
-		 */
-		if (requested_freq == policy->min)
-			goto out;
-
-		if (requested_freq > freq_step)
+		if (requested_freq > policy->min + freq_step)
 			requested_freq -= freq_step;
 		else
 			requested_freq = policy->min;
-- 
2.53.0



