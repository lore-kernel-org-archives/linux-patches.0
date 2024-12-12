Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7B91F8ACC;
	Thu, 12 Dec 2024 16:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019590; cv=none; b=CpYGWzuO2YFotL1LPgC6r+9TeWscK/+zosVRbKoZM3gG5VEqpA/RQYIzc9HFOQul2pYD4yoWrv0wxxm2g31Z6ggS7L0+eXdiz/1/wDtLhYR9l3d4pV2OSOmdGYWGtgfdf0Wp6HxiJVaPlP/0vIigYeAa926dpF+Zqx5hLRuZ6/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019590; c=relaxed/simple;
	bh=sY5uW/qX8Qvim3C4H3QREYMWY0LqoSQnkoAN31ULMxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I42InQMhuNsikvLBzJNC/Ckb7DEF+4tVk5wl+xz0oaBy8yPNIrCKwchmZEqlU4o4E9VDYLqPE/3Sja3g5e8gzck1zSwfNPqcQKyvF0znDtrO7Yj4FmK7p+4Ii8ojcguxZ1LCW3EiP/ULQLMGtowLyfCquAU0B71xexsAVCIPWRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8CZ38XC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8CZ38XC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79D7C4CECE;
	Thu, 12 Dec 2024 16:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019590;
	bh=sY5uW/qX8Qvim3C4H3QREYMWY0LqoSQnkoAN31ULMxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8CZ38XCmvnOt9TIykHLDiCdrfDlqaCykCgHRCu31RRBBWLXcLNamU3A55RpcYncD
	 CiRoiJqSBpHX+fHWMzQEDbWBmunx1UElC10WrPsqNfnX3x3E9lFWOU5TFoy9EFYnOd
	 U/9+w5qLRh+EDaQJmGqwx+Z+n4jiGCfa14zp15yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 246/772] cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_power()
Date: Thu, 12 Dec 2024 15:53:11 +0100
Message-ID: <20241212144400.072124222@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fd02702de504c..12fc07ed3502b 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -423,7 +423,7 @@ static int cppc_get_cpu_power(struct device *cpu_dev,
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
 	if (!policy)
-		return 0;
+		return -EINVAL;
 
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
-- 
2.43.0



