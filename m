Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EE453A7;
	Fri,  6 Dec 2024 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497419; cv=none; b=NxBhWqvVT/kNqk/S/0MdAXNpLvw7KdnI62gGKt0uvk6JkETzKDmqXLqQYvG6PAiRgsTMRMDdfFNgZRXhIsF/qHSe9k6j54FHhQ8NgR8CjDiIGt4Kib5kIqqmT2FQdooDGM44x6NSkMB66tfR4etX957rLLFU2P0esYSigDpCiA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497419; c=relaxed/simple;
	bh=jYz5EjdlbFeA8loIpJqiXncd9rZtGlSBLTFr74D1h3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvGjbaVYFBsG7dDai0WwfjUD40ug41ADW1SVbB/j27+sAyuL0R1s3JA25pG/7inJZChx0zBidpPXp4Tdj88VJZAGxZ9p8cM7ovHPnziDfPXPafOEx6aHw1u57BBziRqsLLJyNCQEamB1ncb7h9/NdFVU65DU+VDna3uxjNstdhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rpddi3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rpddi3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16C0C4CED1;
	Fri,  6 Dec 2024 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497419;
	bh=jYz5EjdlbFeA8loIpJqiXncd9rZtGlSBLTFr74D1h3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rpddi3p8uUXsadXBIBzG8eHG0ZplIuB8SKP5tVhVDgM/sOA5jpxrANmZprV1H6Vb
	 KyBHhrAf78UU3wgDtlq3h5U97qvIP1F2Z1ireKgBZ2vvtqybhbRrNT+/kNWEdpROe5
	 3cbwJ271AafVku45CRiNctMRgfyCsRz25J/w4WUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 279/676] cpufreq: CPPC: Fix possible null-ptr-deref for cpufreq_cpu_get_raw()
Date: Fri,  6 Dec 2024 15:31:38 +0100
Message-ID: <20241206143704.240091303@linuxfoundation.org>
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

[ Upstream commit a78e7207564258db6e373e86294a85f9d646d35a ]

cpufreq_cpu_get_raw() may return NULL if the cpu is not in
policy->cpus cpu mask and it will cause null pointer dereference.

Fixes: 740fcdc2c20e ("cpufreq: CPPC: Register EM based on efficiency class information")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 9d476264075d8..284c328a1d3d1 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -428,6 +428,9 @@ static int cppc_get_cpu_power(struct device *cpu_dev,
 	struct cppc_cpudata *cpu_data;
 
 	policy = cpufreq_cpu_get_raw(cpu_dev->id);
+	if (!policy)
+		return 0;
+
 	cpu_data = policy->driver_data;
 	perf_caps = &cpu_data->perf_caps;
 	max_cap = arch_scale_cpu_capacity(cpu_dev->id);
-- 
2.43.0



