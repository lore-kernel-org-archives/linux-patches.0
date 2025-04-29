Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C679624A07B;
	Tue, 29 Apr 2025 16:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945748; cv=none; b=Hfu60IxkPb5v/SczC/jwVPsn8gqpyEEths0ksphcFPfKg1XWLA8MZ92ZXHKunsjz+7iD4Y2mVLvaGHpVJJkKw3p7ahXZTnhj0kWTmYRx3HknjLb1ZxH3148Muto+XldM5PkxpIR1f11IKC0N4VBqmRuvm6p+PTiGdxi6VFvG8kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945748; c=relaxed/simple;
	bh=T234Es4ev/ZojHxZEb8lci0oLfCyQZba2SFeKJv+N8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSU+x3GZYQbEzatAEkkkrvkYxyd3QvLfe8Z3gTe2KECEtw3ohYfs78Y0SZU91WinWmqvxUYztOFis8Iis5lHp2nvBZVC6I4LU7Gc3yRQtl7mFxE/z4siPyfbarOu9USoLpDkHs0bWuApya+7Rt8CYby4Ti5XaSmx0FKNpx5fWXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uI95COyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uI95COyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AE9C4CEE3;
	Tue, 29 Apr 2025 16:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945748;
	bh=T234Es4ev/ZojHxZEb8lci0oLfCyQZba2SFeKJv+N8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uI95COyZYPpes4e4VEZnOduuQ+zjuanHkM6zPhVUX+IK5MLHV7Jjz8yNMm9OUkbmo
	 yn2kljjPAMHK8f3+C00rQFpxl8ZVL/PhS2FRZ2XG7HbZDhQkaF1Y/Ai8RI66Gdmw1k
	 rwyf1bXepf7pcadIlmc50hvjtKuWvIdESxQFJgeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 037/311] cpufreq: scmi: Fix null-ptr-deref in scmi_cpufreq_get_rate()
Date: Tue, 29 Apr 2025 18:37:54 +0200
Message-ID: <20250429161122.547613089@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 914bf2c940a03..9c6eb1238f1be 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -37,11 +37,17 @@ static struct cpufreq_driver scmi_cpufreq_driver;
 
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



