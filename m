Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623E81F473A;
	Tue,  3 Dec 2024 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238946; cv=none; b=S8i9P1jAXAZQBAFAE0IRgC6Qhi37o74eUmN7DWeVL3wGcPEFd0jv5tyiiPvi5bZ0LXEK4J2mSUmL5/NEyE/cQh+BTsDNdCmQRrd/MFclFHVSIeDKBYRyZAJlhApwsjPWLpB5lEIFr26kFujoNGVPjH4InT38hrjqqoA/WpxOnIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238946; c=relaxed/simple;
	bh=Q5SGKjJa/GIw4GfSEL5at/6irve++3Ve3TkP/drU29Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4ashZ5UfaPemy5rSRgkjR9SferkLhyUzTkosEb3a6wA1znXpPh+19iL/qrr1TfeD0VGG/MQj0IUTb2mtxEVTzyCa5Oxr++NLoCeqKu8pdvrSPFZt34jWjieaOVDvqB18YNc5R2RWTiRMewJITPAHLPZ+TUBALcdSNcdfY6WNLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3nSXZkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3nSXZkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2AAC4CECF;
	Tue,  3 Dec 2024 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238946;
	bh=Q5SGKjJa/GIw4GfSEL5at/6irve++3Ve3TkP/drU29Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3nSXZkUhNhyL+C1vZT5JqpvuXylU+qOL3MM/OapxmFXaCiMMnCOtr5vKkGgS4wEA
	 deDvFLsJzA0OJapBP60tqAIpkeQhcAikfWtNTQWmcn9ppDqNgSznNiOzaFV+8UHBmi
	 DCCWY8iT+2AVZKLffgRcvHstI0nbrJI5GII7SZec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 452/817] cpufreq: CPPC: Fix wrong return value in cppc_get_cpu_power()
Date: Tue,  3 Dec 2024 15:40:24 +0100
Message-ID: <20241203144013.520834981@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 27508b396846e..6bea89bfe3e95 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -424,7 +424,7 @@ static int cppc_get_cpu_power(struct device *cpu_dev,
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
 	if (!policy)
-		return 0;
+		return -EINVAL;
 
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
-- 
2.43.0



