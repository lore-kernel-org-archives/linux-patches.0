Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD27E26ED46;
	Sat, 12 Sep 2026 19:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242550; cv=none; b=SQcvNqMnYpuWR+wSvEpnu+Slh0go8fxx1hIX3XPE2YTTdiqyPgRkFDh8UKdphS0b+z+44mvFHVIpKYOAgE0FkHrhi3xbvVmcaATxclzMd/Q6AWhvBcZah9tEJ4YaoNb8KFs1PoHZ/xhVOep2ehoIDUJv66wr280QUDrw/ZhozEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242550; c=relaxed/simple;
	bh=bYA/WOxCZ0hsr0fSna7gj7GAYUZY3vC/uxh/9TFS5jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSwmc2Nwm7V0uhDb0EEbDpcBEm7YSx3Rr0vt93XZihmKx9Cy8EepNerP2ZFaidnB/lbm8wZ0Cl6J5LSxHcQeZ3EUMU1mqyadvQA+bckkxLuvLYulgvIKUU5n5ZHxRbIhi0fTvG+MmRg/S9X4IA73F1OwIwI9QWCEd/iQAOcVksg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BuLu74ua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BuLu74ua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359BD1F000FF;
	Sat, 12 Sep 2026 19:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242549;
	bh=EJ30j/7LXwz3P5SWh3iN90wNZyRbitYXVUh3+o3xitY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BuLu74uaTt/8BJFqdaZ4tGm/W67s+amclqIc4c6pujzUsU2mLUJgMSSiqRMr8We63
	 zMxlkwRExywun+AT0Ml3pOgBQThInuwqYnmYYh1vC8bINGi84mGx5b4QwG/2uXYAL8
	 QNGzZC164TruuTLNp6RfX9VofhvmZD1/Wsz012hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 443/798] cpufreq: spear: Fix an IS_ERR() vs NULL bug in spear1340_set_cpu_rate()
Date: Sat, 12 Sep 2026 09:01:11 +0200
Message-ID: <20260912065527.293505011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 6a9e0e0f7592313ace66303cf5eca68e04c10f30 ]

The clk_get_parent() function doesn't return error pointers, it returns
NULL on error.  Update the error checking to match.

Fixes: 420993221175 ("cpufreq: SPEAr: Add CPUFreq driver")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/spear-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index 73bd8dc470742..d7874433654a1 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -79,9 +79,9 @@ static int spear1340_set_cpu_rate(struct clk *sys_pclk, unsigned long newfreq)
 	int ret = 0;
 
 	sys_clk = clk_get_parent(spear_cpufreq.clk);
-	if (IS_ERR(sys_clk)) {
+	if (!sys_clk) {
 		pr_err("failed to get cpu's parent (sys) clock\n");
-		return PTR_ERR(sys_clk);
+		return -EINVAL;
 	}
 
 	/* Set the rate of the source clock before changing the parent */
-- 
2.53.0



