Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4AA2AE68;
	Tue, 26 Aug 2025 14:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217666; cv=none; b=uhrg4ttn0Z65WwaxLHAKkdIzzEb/pd88i+xPzCqZaZciB5WekttyMZS64o3/XphZaUGkcMkYFV/aDO2RWfejh8rN76a6+RgwQA2WqOBVnRlTzO10MzTgzw8Y7fxdptNlLiEG8d33/gFxG7ffb114Wpv8giqDhKKaff67hwsBTo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217666; c=relaxed/simple;
	bh=pu7/bk5ktm2PQxfuYE9H8koFKRfdP4nEOHmiS6ObiMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaxzCNG7r/HJk1GXN0RjjnGfohScLCgeskdzydyKugSu44RTjmykPKbndxxfDg2srq2BuWkzioWhh3Lm+V6unhFD64os6J3KOMCZ3u9V71T2Q7g6YvjA5lPIZVfv4KF2hhi83avtja+Ec/YEQCXdqGIEQUoMA0yUED+RswEtAoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhEswRoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhEswRoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E55C4CEF1;
	Tue, 26 Aug 2025 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217666;
	bh=pu7/bk5ktm2PQxfuYE9H8koFKRfdP4nEOHmiS6ObiMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhEswRoZvk+FCd4dpQxi6AAy2N9figomAUc9qeqg9q99GXUQ+ccTAGluzqMQMFFu6
	 O224yEZ8htQEn9gaVv3fvbH3jYCjFjruy5ETG+6WTWddjBlTwxPjCFTsrWFb/O7uYT
	 2CzBgTthcBslgzs13L5oUQCq2auZG4iVCVnMghRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/523] cpufreq: Exit governor when failed to start old governor
Date: Tue, 26 Aug 2025 13:07:19 +0200
Message-ID: <20250826110930.103802562@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 0ae204405095abfbc2d694ee0fbb49bcbbe55c57 ]

Detect the result of starting old governor in cpufreq_set_policy(). If it
fails, exit the governor and clear policy->governor.

Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://patch.msgid.link/20250709104145.2348017-5-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index d1277f98d1fd..149ba2e39a96 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2545,10 +2545,12 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	pr_debug("starting governor %s failed\n", policy->governor->name);
 	if (old_gov) {
 		policy->governor = old_gov;
-		if (cpufreq_init_governor(policy))
+		if (cpufreq_init_governor(policy)) {
 			policy->governor = NULL;
-		else
-			cpufreq_start_governor(policy);
+		} else if (cpufreq_start_governor(policy)) {
+			cpufreq_exit_governor(policy);
+			policy->governor = NULL;
+		}
 	}
 
 	return ret;
-- 
2.39.5



