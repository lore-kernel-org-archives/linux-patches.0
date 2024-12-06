Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B0753A7;
	Fri,  6 Dec 2024 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497638; cv=none; b=Id/G9+PfYV7LtcJGIkXhor/pEpQ4fwxuoFtUqhGGF3PmQNFdWTE9bwUuRhKrfiIOrjOjpVkVud62l3NIgttc1Tm4kGvRKU2FSBZjMe1YUR6LgAJXWitgU6aSRtczMQ72V3ncJgbTsUfLCjsR1D9z88ab3Shce7w88+kPFVt2Wr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497638; c=relaxed/simple;
	bh=plLTkJIdOoNsuesyIMnfDAxvIJD2qz3JuQqWBWyja/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLmO0hxZTPoqXwL/dTzzvuYJojuy09WKg3y887q2qogkMMBu8FrLJEsQ8BzNhbyG1ILjiiVJ+xbxccaskAvthQwsuMGZdcajRe7qIT4DxyxNjZCXoDSlsgldSrQ/smN5eZ80F8IYntrkeO81e4av3glQ0dkV+ECfslhcpER2qjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPVcrU6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPVcrU6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF0AC4CED1;
	Fri,  6 Dec 2024 15:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497638;
	bh=plLTkJIdOoNsuesyIMnfDAxvIJD2qz3JuQqWBWyja/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPVcrU6VZT19eZiCCCtkLB6MprzFuOUx3lmfRguF9B17Zy2g/F7AHVbaHSjs6Ifw/
	 JKpfoYGmOYitoS9ps40P+NP0NF4ZYRljErir2a/SK1Fbc1ELwcij0dBb1EzStpdJjM
	 Bhr0JF1MnCHwRLTc8z5XG8OKtRDLaci+HJgzFcDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 316/676] cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_power()
Date: Fri,  6 Dec 2024 15:32:15 +0100
Message-ID: <20241206143705.678502644@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit b51eb0874d8170028434fbd259e80b78ed9b8eca ]

cppc_get_cpu_power() return 0 if the policy is NULL. Then in
em_create_perf_table(), the later zero check for power is not valid
as power is uninitialized. As Quentin pointed out, kernel energy model
core check the return value of active_power() first, so if the callback
failed it should tell the core. So return -EINVAL to fix it.

Fixes: a78e72075642 ("cpufreq: CPPC: Fix possible null-ptr-deref for cpufreq_cpu_get_raw()")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Quentin Perret <qperret@google.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 05a8418485079..c8447ecad797e 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -429,7 +429,7 @@ static int cppc_get_cpu_power(struct device *cpu_dev,
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
 	if (!policy)
-		return 0;
+		return -EINVAL;
 
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
-- 
2.43.0



