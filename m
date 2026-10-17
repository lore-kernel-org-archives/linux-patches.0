Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834843BFE2D;
	Sat, 17 Oct 2026 17:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259091; cv=none; b=gLWEE2XPubU7GOkgbVSRJNLVqif6tHjj7FhrPn4lYCUjSEJbYmxg/eTkXse5kHptssfgut/1Ie511A1fKU5E6BUWlcYKNrU2rIjzGKQwDop10mcbhdGd6MZWka3vUsa7aTKAXIZSdUyYEvRffn5cgg7xlOZWTQdwrb2jOB6wfWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259091; c=relaxed/simple;
	bh=oXi2r99jf9wQLwxiC7CnX4DPhBB+xmwILDqs6gdHGbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCY66xUXUlI5vmn59q3Kj/NKbsMxPczuVRrT4b7AIwxNFjwH2gLPfRvk0+qJogQm7ItO4bmnIMs5Ww8wu0TueuJbs1ASwd360iifOGdpEX1JbzhiN6Sz+6oFNWWEF744qMjitS1Xq2HYJ65fCBDEizUbXYY3sDLe0Rmoc2gvq4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cO7f3wSn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cO7f3wSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B291F000C4;
	Sat, 17 Oct 2026 17:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259090;
	bh=bvSEsPyIk1u7v+4W9R6hg0Jg82DhmfDQbaB4SR7BbUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cO7f3wSnDGa6gOiNflN7kV81bNXWxKxi1rygi63J1tePcMxSHvXCWXXcL6U9DSxal
	 GSvOiJcNjrGUkpwJTOHSZKPNXH+R3ycvUI58S2UnMt1xGtwi3zYDaMHUS3SlUoD2qX
	 MhguWByMwr5zhb4wxYNPiM3nr72mx+5C8DQGRp04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1062/1674] cpufreq: qcom-cpufreq-hw: Fix possible double free
Date: Sat, 17 Oct 2026 17:55:34 +0200
Message-ID: <20261017160458.386971904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit bcb8889c4981fdde42d4fd2c29a77d510fe21da2 ]

qcom_cpufreq.data is allocated with devm_kzalloc() in probe() as an
array of per-domain data. qcom_cpufreq_hw_cpu_init() stores a pointer to
one element of this array in policy->driver_data.

qcom_cpufreq_hw_cpu_exit() currently calls kfree() on policy->driver_data.
This is not valid because the memory is devm-managed. For the first
domain, this can free the devm-managed allocation while the devres entry
is still active, leading to a possible double free when the platform
device is later detached. For other domains, the pointer may refer to an
element inside the array rather than the allocation base.

Remove the kfree(data) call and let devres release qcom_cpufreq.data.

This issue was found by a static analysis tool I am developing.

Fixes: 054a3ef683a1 ("cpufreq: qcom-hw: Allocate qcom_cpufreq_data during probe")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 0daf442aedd4b..692673447a2e1 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -583,7 +583,6 @@ static void qcom_cpufreq_hw_cpu_exit(struct cpufreq_policy *policy)
 	dev_pm_opp_of_cpumask_remove_table(policy->related_cpus);
 	qcom_cpufreq_hw_lmh_exit(data);
 	kfree(policy->freq_table);
-	kfree(data);
 }
 
 static void qcom_cpufreq_ready(struct cpufreq_policy *policy)
-- 
2.53.0



