Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBCE3A0E9A;
	Thu, 15 Jan 2026 17:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497815; cv=none; b=mK/nD8vTnGbnHLP8f0BDl4I6vWV9YH6tZc/COBpoF5O0Mx7aMmD7nObb15rfcZ/UXs5DUze4McRX+D20409JompiTlDUzjDHQ5z9lHVYZwRU0zHxMm9KM7hY9n7+4JLP3frKo3qno12crmrm7/uWCuhl+xM2vLkR95fHVvxFbYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497815; c=relaxed/simple;
	bh=JLk5KTEQ+GuZM3DABOBMIFzRcFTK6wXahe0KH4bND7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uia/5qLBpIIAyhr5R9n/6VosakpP/OfDcL03j3QAFTisYmwBIG1erFF09yazc+m7nfmjfq7PpEEGLTnvyTuAKv9ehQoHBTlX7mZaqMsFTKwJyyZSPWzopO5bPdd+lkj2Rh879odeLmjwt7srMp8Z9gJQun9vnCdYZvAb2678xDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qArxfcul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qArxfcul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A3BC16AAE;
	Thu, 15 Jan 2026 17:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497815;
	bh=JLk5KTEQ+GuZM3DABOBMIFzRcFTK6wXahe0KH4bND7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qArxfculER8Bd+wIPFJwKvjBKfNw8x8ZDNURKqWg+JG8HnvZhyt5m4H1Lxzr7DwHp
	 RAPs30ATXKx6cWS2yshfoeekEFgZOxGva/+QHhWi3TSN2PeTtcaAGHldMZppSortca
	 cq1bRpXHR2oYK6+6Tgb1oxa2f7HUFbCuuDbtXOdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/554] cpufreq: s5pv210: fix refcount leak
Date: Thu, 15 Jan 2026 17:44:40 +0100
Message-ID: <20260115164253.996317529@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit 2de5cb96060a1664880d65b120e59485a73588a8 ]

In function `s5pv210_cpu_init`, a possible refcount inconsistency has
been identified, causing a resource leak.

Why it is a bug:
1. For every clk_get, there should be a matching clk_put on every
successive error handling path.
2. After calling `clk_get(dmc1_clk)`, variable `dmc1_clk` will not be
freed even if any error happens.

How it is fixed: For every failed path, an extra goto label is added to
ensure `dmc1_clk` will be freed regardlessly.

Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/s5pv210-cpufreq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index ad7d4f272ddcb..f51b2e84ef63d 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -518,7 +518,7 @@ static int s5pv210_cpu_init(struct cpufreq_policy *policy)
 
 	if (policy->cpu != 0) {
 		ret = -EINVAL;
-		goto out_dmc1;
+		goto out;
 	}
 
 	/*
@@ -530,7 +530,7 @@ static int s5pv210_cpu_init(struct cpufreq_policy *policy)
 	if ((mem_type != LPDDR) && (mem_type != LPDDR2)) {
 		pr_err("CPUFreq doesn't support this memory type\n");
 		ret = -EINVAL;
-		goto out_dmc1;
+		goto out;
 	}
 
 	/* Find current refresh counter and frequency each DMC */
@@ -544,6 +544,8 @@ static int s5pv210_cpu_init(struct cpufreq_policy *policy)
 	cpufreq_generic_init(policy, s5pv210_freq_table, 40000);
 	return 0;
 
+out:
+	clk_put(dmc1_clk);
 out_dmc1:
 	clk_put(dmc0_clk);
 out_dmc0:
-- 
2.51.0



