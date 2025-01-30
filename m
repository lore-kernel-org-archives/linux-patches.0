Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253FC1E98FF;
	Thu, 30 Jan 2025 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245761; cv=none; b=Q9XAkHkt7pXgkRiw1rnaptulscThfu+fXrdVSZEJazdeU/eiUO5o9Nd0HMoGHs2IVNHXYNrOVIEukkqAxrA9wr3ZNkstkeXh58qfmd1MGZHZtnXq9FBtpk4BjN81SxBZaOhG8g3BVx70ntOflzZLieqH4yf50A9q6snsMSbHXFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245761; c=relaxed/simple;
	bh=xCMVdCqKML4t35RYfwH11i4LwqumZzBir3EuwqtsgSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px+SILt1mIR/rZmc3isMaWPi74i3elxy46PoHJ8r3XMRZnG+MQer27wrtPhljwkG/gspQphD9dj9cz3a8qyDNx6/V0mYkal4gV+31Mfo/IimnqtY5lQ8D5vZH02DJT/tq1impvhuNQsENl1MKyny8keJ+kIFfgfqO9jYvVTpJkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQ3IXFv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQ3IXFv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9F2C4CED2;
	Thu, 30 Jan 2025 14:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245760;
	bh=xCMVdCqKML4t35RYfwH11i4LwqumZzBir3EuwqtsgSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQ3IXFv3nay2ju7HPi5D2aXOxZuMUzbBnljN/Rr3w+iPEYBHY7IDu5ngjFrARKj0Z
	 SSALxxrpBgtYJ5lPQfNgEhJ2hxy+B+WxxKVliec7YzWR+Plt2pt8CLmOd6vic4Ksxl
	 op8tz3X8yDy206Tas+wTn17qYotGCAZ4DafS25Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Perry Yuan <perry.yuan@amd.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Rajani Kantha <rajanikantha@engineer.com>
Subject: [PATCH 6.6 11/43] cpufreq: amd-pstate: add check for cpufreq_cpu_gets return value
Date: Thu, 30 Jan 2025 14:59:18 +0100
Message-ID: <20250130133459.357948757@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anastasia Belova <abelova@astralinux.ru>

commit 5493f9714e4cdaf0ee7cec15899a231400cb1a9f upstream.

cpufreq_cpu_get may return NULL. To avoid NULL-dereference check it
and return in case of error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Reviewed-by: Perry Yuan <perry.yuan@amd.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
[ Raj: on 6.6, there don't have function amd_pstate_update_limits()
  so applied the NULL checking in amd_pstate_adjust_perf() only ]
Signed-off-by: Rajani Kantha <rajanikantha@engineer.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -579,8 +579,13 @@ static void amd_pstate_adjust_perf(unsig
 	unsigned long max_perf, min_perf, des_perf,
 		      cap_perf, lowest_nonlinear_perf, max_freq;
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
-	struct amd_cpudata *cpudata = policy->driver_data;
 	unsigned int target_freq;
+	struct amd_cpudata *cpudata;
+
+	if (!policy)
+		return;
+
+	cpudata = policy->driver_data;
 
 	if (policy->min != cpudata->min_limit_freq || policy->max != cpudata->max_limit_freq)
 		amd_pstate_update_min_max_limit(policy);


