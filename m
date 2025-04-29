Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A03248883;
	Tue, 29 Apr 2025 17:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949427; cv=none; b=odF/2HfZw+b8uLQK9M2IX0Hhn9VKnT2Us2oPn8JeeaNcYrwCOAsXBnV+X7SP1ov/XFseGMNjoD/Smy5q1VUFc2wQQOuN7DrnoBdy6hBcIGz1VXGWi6KFBJ0CSFIKM27x0Z4xoLIO8GdQE3gim9qLL51zQ2BPGNiUPle77T37830=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949427; c=relaxed/simple;
	bh=3owN6UxaJdTPtTk1BVJ45wT9yy52nvRIXpGDzFjk/3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pP8M8AoyMz2oOlCUQkszFlclJoAinSeAQWQQFCRvx3LKo8+L8KwBjWq1+SUwux783VOGtVnVRBLkOahORQv7XlXvDGS//eXrXi+Rx4VXvxSjPe6IhnNEe9K0C5Ue55NmezSUSts9iTURqFJJ82wHBooSc7SnYsNxQ4qLe6RzNr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WU+wXKiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WU+wXKiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DFCC4CEE3;
	Tue, 29 Apr 2025 17:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949427;
	bh=3owN6UxaJdTPtTk1BVJ45wT9yy52nvRIXpGDzFjk/3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WU+wXKiwL4lYcrVnZv6SWvE58B+qEitbgSxuDWTKF5iKeHu9Wq0jWQ8H06LItL5U0
	 EFImWR+91j1kKdRP3574bYOn6uF8JcyqsQWMmIaB+IZg/ioHv6n8HJPv/FR/9q03z1
	 c6zbNUQSKTuQcJQfxcxb6/pZunN5G5BAPW64Ct38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 287/373] cpufreq: scmi: Fix null-ptr-deref in scmi_cpufreq_get_rate()
Date: Tue, 29 Apr 2025 18:42:44 +0200
Message-ID: <20250429161134.915104684@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/cpufreq/scmi-cpufreq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index eb3f1952f9864..8c9c2f710790f 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -32,11 +32,17 @@ static const struct scmi_perf_proto_ops *perf_ops;
 
 static unsigned int scmi_cpufreq_get_rate(unsigned int cpu)
 {
-	struct cpufreq_policy *policy = cpufreq_cpu_get_raw(cpu);
-	struct scmi_data *priv = policy->driver_data;
+	struct cpufreq_policy *policy;
+	struct scmi_data *priv;
 	unsigned long rate;
 	int ret;
 
+	policy = cpufreq_cpu_get_raw(cpu);
+	if (unlikely(!policy))
+		return 0;
+
+	priv = policy->driver_data;
+
 	ret = perf_ops->freq_get(ph, priv->domain_id, &rate, false);
 	if (ret)
 		return 0;
-- 
2.39.5



