Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D368253F28;
	Tue, 29 Apr 2025 18:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950291; cv=none; b=IIpay+o4COn6LCIur6nt0qhinaD+3Xux/ju4qlqhEakHpgmSB2SK3RQ3H+4tX+WLjOGy+krTymj+ZOVQu9oM8PDyOdTrtcDO1nkDRe5YIuI6/Z+rAXtr2sKX8jv+zMPKDW5d2GA6cLq1ksPx7IAvZRJCYaS4QOE+TE/vK7bgDuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950291; c=relaxed/simple;
	bh=X98L+CujK/K0wJrxoIJixCSzP+1YQ0W1F4TFouJmwUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKSzRA3v2afHTKrcAJeqc0YAnP2W96Wzq/7VgNyY3SelC3acvj4jV1ev8s2zwCnxRgOWJoha7BzLJOa7NSKH6HHjb5N6Da58geoFh0Y/QB+VK6ftKGePu0516ne5yNmhnx0PC/mLfSzo1Y3stwq4Ny67vsWSHJVysuKp8rUtswA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nqljosrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nqljosrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9C8C4CEE3;
	Tue, 29 Apr 2025 18:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950291;
	bh=X98L+CujK/K0wJrxoIJixCSzP+1YQ0W1F4TFouJmwUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqljosrcWmJarws2CEQpaqif0dTUlRs/RtnDjqU7irYr8+AmRVWTpIN8RRaXF26dp
	 Kf06LNVEtAlk4yE7SSytoPTE5SgJMJb6tDty/78Ew1698JZ8Ff8xv8IYiSd1sMf5Ha
	 n7VrfHlLAUssSgQTNyqFQOgzcTLFTyRUSyaS46/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/204] cpufreq: scpi: Fix null-ptr-deref in scpi_cpufreq_get_rate()
Date: Tue, 29 Apr 2025 18:42:17 +0200
Message-ID: <20250429161101.413354523@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bfc2e65e1e502..2aef39bff7d6f 100644
--- a/drivers/cpufreq/scpi-cpufreq.c
+++ b/drivers/cpufreq/scpi-cpufreq.c
@@ -29,9 +29,16 @@ static struct scpi_ops *scpi_ops;
 
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



