Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F152517A4;
	Tue, 29 Apr 2025 17:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947378; cv=none; b=t5jIoNV+KfApN1oc/K4IE4HTd/+FnAEG12bNrbbq8HWX4s23ghDTE1wxmoWkznzOAQ34jXZCphMBZJMwjhnf0f0Nh870Vnx8N09rC+uN6YNSR+iVibvyJhckT6Mca3XGW+htOdPMwQ5eNNjwAkqnu7pCkVhzWOO4J9DY0qZ4tgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947378; c=relaxed/simple;
	bh=5ah1r9Xdz4+YxdMAzdHLiG5FBJYHBaOx7buk7D8MwyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s40WI9Z6aWhmEpSrLwun/+iRzHTJytDAp1RnGtue97Leycx0OaoS/f9hgALRSW7F4KqPnLbwZDjjR1b64rXlc0CyfxNS7UQqeRflrd5PIF1KKJaMCDmw7XPckwWmYE3Kq1ZiF5EfNf5XBgQ3c9/mAv4M+etcFJDJlGcKbHo0aOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/r4kI83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/r4kI83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A082C4CEE3;
	Tue, 29 Apr 2025 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947377;
	bh=5ah1r9Xdz4+YxdMAzdHLiG5FBJYHBaOx7buk7D8MwyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/r4kI837sW1LfKC6yCHYXJSjeBFd7h9vF1I2qm2VCfjbx1oJTQbFBLrjf8Fm+CAE
	 UBN8itOa7WGFVjj6OgyMKbQ39tlWSfVVcv7+ORXF/sjw6AIPnjcz0T4kHjL6jGGokD
	 rOlFaQh8ar28gRQRs1wHIsZDNCFN3ckgrzHSUl9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/286] cpufreq: scpi: Fix null-ptr-deref in scpi_cpufreq_get_rate()
Date: Tue, 29 Apr 2025 18:42:15 +0200
Message-ID: <20250429161117.437394094@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 73b24dc731731edf762f9454552cb3a5b7224949 ]

cpufreq_cpu_get_raw() can return NULL when the target CPU is not present
in the policy->cpus mask. scpi_cpufreq_get_rate() does not check for
this case, which results in a NULL pointer dereference.

Fixes: 343a8d17fa8d ("cpufreq: scpi: remove arm_big_little dependency")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scpi-cpufreq.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/scpi-cpufreq.c b/drivers/cpufreq/scpi-cpufreq.c
index c79cdf1be7803..f990de8c6ed03 100644
--- a/drivers/cpufreq/scpi-cpufreq.c
+++ b/drivers/cpufreq/scpi-cpufreq.c
@@ -37,9 +37,16 @@ static struct scpi_ops *scpi_ops;
 
 static unsigned int scpi_cpufreq_get_rate(unsigned int cpu)
 {
-	struct cpufreq_policy *policy = cpufreq_cpu_get_raw(cpu);
-	struct scpi_data *priv = policy->driver_data;
-	unsigned long rate = clk_get_rate(priv->clk);
+	struct cpufreq_policy *policy;
+	struct scpi_data *priv;
+	unsigned long rate;
+
+	policy = cpufreq_cpu_get_raw(cpu);
+	if (unlikely(!policy))
+		return 0;
+
+	priv = policy->driver_data;
+	rate = clk_get_rate(priv->clk);
 
 	return rate / 1000;
 }
-- 
2.39.5



