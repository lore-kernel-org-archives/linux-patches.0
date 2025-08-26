Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697552405E1;
	Tue, 26 Aug 2025 13:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214268; cv=none; b=Fzx44ho1QzVonema9cEp535Emw9qnLi26rwW36ca+ApCy2tXVpNSdA9ztmHxAWoavkqMcF7rtQGP5UdncpbPXbPC6FxIVAlEH+kRPjt9bRRLEhc+HZEtWkTRXU3QqtpJ1LV9TDgttq9Mqhs5WOT4p3LI4LD+VXIlcSmv5SKcg98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214268; c=relaxed/simple;
	bh=ol/1tBdWBJM12u5MUwaIJQfY44IuF1gjj712BiaW494=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uc7Hu5LireU8sDvrzKVNXA450a62GQkS8NxOSlAnIINMou8iQTtT60YPE5tdpF3RsPTq7RZZ3do32rLFdN/BrQwI0Yug166jWSIvn8NxrIGJI8mC8Bd0/LKEvv9yxhitXgbA0xokr6qaO8X1Pj7HQyGP8XBrwgO0YfLaBulmzI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YofyZh7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YofyZh7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A09C4CEF1;
	Tue, 26 Aug 2025 13:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214268;
	bh=ol/1tBdWBJM12u5MUwaIJQfY44IuF1gjj712BiaW494=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YofyZh7k1B5po82AIi19L/95q5ziMqMbGeuYf5W9FGMTovHjk53XWlOxmxgTgvOFc
	 DzmwH8KSMIjdtnFc0hAJa4TRNmp+ARf8675+q/MYmkoObBajMC5iSGq19cMxS/4dU5
	 C5NCGjc9MLreWs+txj5XVOson0YLB43FfGw4kTGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/482] cpufreq: Exit governor when failed to start old governor
Date: Tue, 26 Aug 2025 13:05:27 +0200
Message-ID: <20250826110932.662958972@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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
index 805b4d26e9d2..90bdccab1dff 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2649,10 +2649,12 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
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



