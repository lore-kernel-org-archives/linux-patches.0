Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096441F75B3;
	Tue,  3 Dec 2024 15:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238837; cv=none; b=WJOHqBBN38vfN31GrCNyHEhus8FrwGV4awmsXvRKtqLmpGhVm95APPoPsiTMUeOqP+VCshi/yBNZJDrSwfGYaeX61WqAEwImj7UQEoXqnnq9udUR3k21s5FiYbnB6br/72cx2jmZVZNDK2/DzNHH9h8hQGnu+yQ/I6w7njkXius=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238837; c=relaxed/simple;
	bh=263pwEM8s73w7/afPP/zY5st0A8pfAm6qC3VteUJdos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5iILvmbxAs7qw/d6lqWrh7euX0knQB6YYfwsP4FbCRED5AkTKGxr98L980Cf4FMW8qTWC0DDGMJosc8deTdoayJnYBvDqRoJ4YU4DGOjSUe7dvizZg0bIQidpICLb5mk56z/fO82iG4ybTdeBWuyCtgY2Azp0bmLUCObODQyQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/ot4Zao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/ot4Zao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FBEC4CECF;
	Tue,  3 Dec 2024 15:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238836;
	bh=263pwEM8s73w7/afPP/zY5st0A8pfAm6qC3VteUJdos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/ot4ZaoEfr8FroRcaAzNmO7IYoTocYax/oR2i6bOgIsIKI9BUPYJsx+4euSPUClt
	 YNY7QqbJk2L4Ln3MmVqIcMMAIeIjvziYmcXQ7EE3mZ+gGBrT7W84fTptoT7W2zPJA2
	 b5pwgRleu4sTrZ587WYqzpl+6iSV48PiMciSdjvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 406/817] cpufreq: CPPC: Fix possible null-ptr-deref for cppc_get_cpu_cost()
Date: Tue,  3 Dec 2024 15:39:38 +0100
Message-ID: <20241203144011.722493001@linuxfoundation.org>
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

[ Upstream commit 1a1374bb8c5926674973d849feed500bc61ad535 ]

cpufreq_cpu_get_raw() may return NULL if the cpu is not in
policy->cpus cpu mask and it will cause null pointer dereference,
so check NULL for cppc_get_cpu_cost().

Fixes: 740fcdc2c20e ("cpufreq: CPPC: Register EM based on efficiency class information")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 32045075c596f..00556b4d83f83 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -493,6 +493,9 @@ static int cppc_get_cpu_cost(struct device *cpu_dev, unsigned long KHz,
 	int step;
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
+	if (!policy)
+		return 0;
+
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
 	max_cap = arch_scale_cpu_capacity(cpu_dev->id);
-- 
2.43.0



