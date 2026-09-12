Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEFB2F617C;
	Sat, 12 Sep 2026 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229566; cv=none; b=dHs+5GET0orK2U8Fp5X3cmdcjfpwcSK8slSaQ1VGo0QlVCLHCTPAScvkGD+TB7KdXdWkyyEgCPdklhsPVU/zqgMczLPg+ac11x75NHSCNmCoGu8ke8GsSvdrepjHUgi2SFTCNADzHtpJPaTcgjgf3686ow4mghoNXtD7VAcCQ8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229566; c=relaxed/simple;
	bh=u/dxGZfrLfG3Brdnd40GWNBurT84kx62746MZ1jEqOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J98kdMKO564F7VLrq/h3csDPQhq/jRrBJPAPc7uQhs5D5i2i1P3q4+uGUW45Mna0oKxZn7RLDJbQdcO5CGC6tAdk+zlK2WalXbHYpFFMOLwvtTess1ai+BwuQOm8jJ7ou/n7jiQK+u6PzoTmDwJL8hYmV0vsznjY+rxH0ToHrU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mW0wiYVW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mW0wiYVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9EC1F000FF;
	Sat, 12 Sep 2026 16:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229565;
	bh=oal+gx9px1MRYmHiJP7ltayFv3dYTDl5yLBou7RDoy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mW0wiYVW/585B/E+s4tsbdR6vPrRasD3+MXefvgCXIBc80DUWqnjLagsWJsVK8hZj
	 Pg2Vx9X18OVvbBubsOhWs9zxbA+JThKDHeo8vmbVgdYryqfTAv23bFIi0+1DLsvpsK
	 hgbuYNHaui3iIu83dyefMmlSXqy2q0mv0RABRAlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0617/1191] cpufreq: spear: Fix an IS_ERR() vs NULL bug in spear1340_set_cpu_rate()
Date: Sat, 12 Sep 2026 08:55:45 +0200
Message-ID: <20260912065602.111481801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7d0d62a06bf3f..79b3d69d1764e 100644
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



