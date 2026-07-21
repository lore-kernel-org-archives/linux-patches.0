Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0914743C7DB;
	Tue, 21 Jul 2026 21:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667817; cv=none; b=un3LPojkoENSWsJOjBE8cBoC/sl7Qr1p3oBVNnLEr57szdOwOolKyT+KdIYrYMgb9J/9IFkux/4Hw7/wgMmPOgLgJ/0msX6fM59yIx1JiAnKhYlPK6lcWuWPoc+fKpVM64kTDwEHpVyCALaJSO69rR9WW6muX/IaMnTb5fFo8FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667817; c=relaxed/simple;
	bh=tCXvdYrt62eT1bpZBo4Pz79MSa/11bMWVmObQ9jJSyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMMfQABlWruzGjKHrpmHJm67n3FeirR4Cmf/2cF/jqIVGm0uPO7aJQ7PFack+foccSWv8B2b0qxs+T7kV2OXOktbPH1LQ6UGq1YtZUodl/Zc4+k+jSTtkArjUclzqDFYCm4SgZFhSPKkpzJ/dx8zyHJC1mODVGvlXcwgXRayjWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWb0PNUK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWb0PNUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FC01F000E9;
	Tue, 21 Jul 2026 21:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667813;
	bh=BN2G2pG4DDT5P6JD5uZEWYb9Qb+u8ICyJd5pDWaBwoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DWb0PNUKaY35xrzYaX4Qz/tcO/jGoDopS+tPfg2NjUUOQz1Br7o8QG5YcX1c7vYrl
	 3GKkmUVg0N8MKDprhW9ea+rU7r22P9zVErPARnr/KVjTnL++DmGpg/HEtnIdkiNiun
	 MHpp0wh7tDvKKFo/WfcKuEj/Fep5tR7rDS1BTIwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1204/1266] cpufreq: qcom-cpufreq-hw: Fix possible double free
Date: Tue, 21 Jul 2026 17:27:21 +0200
Message-ID: <20260721152508.743107578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -583,7 +583,6 @@ static void qcom_cpufreq_hw_cpu_exit(str
 	dev_pm_opp_of_cpumask_remove_table(policy->related_cpus);
 	qcom_cpufreq_hw_lmh_exit(data);
 	kfree(policy->freq_table);
-	kfree(data);
 }
 
 static void qcom_cpufreq_ready(struct cpufreq_policy *policy)


