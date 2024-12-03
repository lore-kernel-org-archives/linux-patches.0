Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCAE1F7561;
	Tue,  3 Dec 2024 15:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241324; cv=none; b=fFhAcitjBluY2OoOle4BWJFrC+Yr3D9LZd0ZnEeCyWvSV36qlWLzirZR3aqooWKt0sjmwrElUXvh3x8BfkRDWK9HMlGMEk8zA5oolnn2k+gp1YnWbKofycDqZWwLjb/LXnLQLuKajqJCn833wxEJu0mf8zDibUSlIZXI60CTux8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241324; c=relaxed/simple;
	bh=2pFe8S1FhPcrVGViBg1Bfi3V3NNMp9NLs8LmdpxC9PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arqQ97JTDP/ZQpkSvePx7wugC+o8HG546qx7HWZP9BNhLNjlTTEdJvYKfd7yUiroazLTUsvNwDBuwcUVuTJ/FBr9CjoravwlfwZIGVGhpC61SEO4ldDThDwQn8Vruc5c7LexLWs8n7zI/O1cOSiXUGzf4u5w27LRauFV1mqS8zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwwqOPGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwwqOPGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B281C4CECF;
	Tue,  3 Dec 2024 15:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241323;
	bh=2pFe8S1FhPcrVGViBg1Bfi3V3NNMp9NLs8LmdpxC9PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwwqOPGYqFF+te1yBZO537fYrbGsYieoo2UelmJ/ierxdfcIC2Kgml1h2mLjSVwJ4
	 nnXC3jiFHV4mqkkcZctB+w5qyUfPKLvvOoOAJcj3rFSKqtAHzR7gTUzTS1jkwspy86
	 lfqpoFYts/Bl//H5jzjxmSxhsX64Z6pzbR+pMSgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 388/826] cpufreq: CPPC: Fix possible null-ptr-deref for cppc_get_cpu_cost()
Date: Tue,  3 Dec 2024 15:41:55 +0100
Message-ID: <20241203144758.896897720@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c907638810057..975fb9fa23cac 100644
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



