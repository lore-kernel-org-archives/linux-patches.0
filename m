Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD778171BB;
	Tue, 21 Jul 2026 21:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668835; cv=none; b=AfItw49Y1gHvyafPm8lOuN6UnERsHsYcDwDJp8LIIn7OG42AeiKpik6YOWze5G4gmKHDy2k22Mqa5Hi81a3Q8W2mou4Rwf6Hggq8rufClXdwcsyqNH5a29ai8/7Uni8zdzchLFuASFE7kLr6z2Fu7/qXYTVsnyUofObab/2pIFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668835; c=relaxed/simple;
	bh=8yDB7MrMCj0NiUZQVRptgbotdp6qlyz3NbAJJbDI1FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clIder2FBLLOxBuw6VEpeMkxk76wpPMUhWzAXN5WlIw5yRL7aWvLiIV7JNSIGmMNiIhxStMk28KqYbKTE6jwmPt4xPR3PxUWSBhn/KfAROWeIOASkrzhbw6XvhEVs5gshn0BunTC8yog63lIhS4JYUT3i4ZGuTpnr0Qu0iq9buY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NcT9O3V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NcT9O3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5F81F000E9;
	Tue, 21 Jul 2026 21:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668834;
	bh=jOAgWcVWyOjncDQb23kTVDOgeDldcTcFBCsDeIisqVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1NcT9O3VGg5sZYjTTIlYhNRPFPWBN6s8cZHyi8izFo6AvSXqy+sK65XHYHye1APsn
	 v+/0123t4kf6b1UAwuswal7XncB/Qfjp5MmqEDSHOYwzDC19gMAR5qRX2W73GfgHbU
	 GNHEZGeNVlnUXPd3mElbI4VIwCdkQO8W62OC5dkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0324/1067] cpufreq: conservative: Simplify frequency limit handling
Date: Tue, 21 Jul 2026 17:15:25 +0200
Message-ID: <20260721152431.840018145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index efdcc4ab43340a..24fbb7313c9500 100644
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
@@ -124,13 +120,7 @@ static unsigned int cs_dbs_update(struct cpufreq_policy *policy)
 
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



