Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D9F3D348D;
	Thu, 15 Jan 2026 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499927; cv=none; b=fN54560siBPjx1AN9tQn9gePakWs3q9M5ZmwpcwUFk0BQ6GuxRn50iWobqskAClCirWK3Ne3qgMwHzlEoCjwtl7BojQGFHzzrPVWQX8pPqBkjLgpcfF+HFqU5+hRDSb1GUa0q9leClxoYy0WMgVv5lmp//ItJxl/gQVxy2BHJcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499927; c=relaxed/simple;
	bh=IIGAQPZxNo6JhDR/Y0x9jXaR30VFHnXcpeCBUGyWMMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iF8f0BJTsIs4A9TsCgZHUTXoARZc5ru73IQ5av8O/t92i54rMQzxW46G2W4Cjm4p3hYthhoSgkMsDhv+XAv1DV0QwBvVBaEGc/IQ3SIwRfDqmeKaO15NszyVlYI/l2N82ugA/Olr2ygMpuhUWOB7jHimepbjwOB82j71fR+I3lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkUEjvi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkUEjvi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B53C19423;
	Thu, 15 Jan 2026 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499927;
	bh=IIGAQPZxNo6JhDR/Y0x9jXaR30VFHnXcpeCBUGyWMMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkUEjvi9sfXjPjsC9mnCArWHHHEf7VKPz7TbHYx4tkEE4/7vj65NiwjOlSCFJhNpQ
	 3LO+4cbtcjgyiuukXDtDuEflLuvcD4wc8qaQhX9MTjmr+P2QuuFHeuKNZ/HxLHFT3T
	 ZZHniDDyWwcn0OnniS3ZIg8QUd4lD87dQGWwPzck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.10 397/451] cpufreq: scmi: Fix null-ptr-deref in scmi_cpufreq_get_rate()
Date: Thu, 15 Jan 2026 17:49:58 +0100
Message-ID: <20260115164245.297473080@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 484d3f15cc6cbaa52541d6259778e715b2c83c54 ]

cpufreq_cpu_get_raw() can return NULL when the target CPU is not present
in the policy->cpus mask. scmi_cpufreq_get_rate() does not check for
this case, which results in a NULL pointer dereference.

Add NULL check after cpufreq_cpu_get_raw() to prevent this issue.

Fixes: 99d6bdf33877 ("cpufreq: add support for CPU DVFS based on SCMI message protocol")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/scmi-cpufreq.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -29,12 +29,18 @@ static const struct scmi_handle *handle;
 
 static unsigned int scmi_cpufreq_get_rate(unsigned int cpu)
 {
-	struct cpufreq_policy *policy = cpufreq_cpu_get_raw(cpu);
+	struct cpufreq_policy *policy;
+	struct scmi_data *priv;
 	const struct scmi_perf_ops *perf_ops = handle->perf_ops;
-	struct scmi_data *priv = policy->driver_data;
 	unsigned long rate;
 	int ret;
 
+	policy = cpufreq_cpu_get_raw(cpu);
+	if (unlikely(!policy))
+		return 0;
+
+	priv = policy->driver_data;
+
 	ret = perf_ops->freq_get(handle, priv->domain_id, &rate, false);
 	if (ret)
 		return 0;


