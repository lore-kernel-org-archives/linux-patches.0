Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C86F332610;
	Sat, 12 Sep 2026 07:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198643; cv=none; b=kKkUawlCwi7m3chhiKuySbUyWtS+OBYJ75l8/o9AnQHvHXsJ4fP6YC/5iNLdCB3RJ285BE64Ns0+1/5mWTiKm9Jyr28Lj1x59K/kK+2bPqk37MwbSES6sim8UVcWN1RqBUGht2QkZP1X6GLA3iPhisDPztqgM2At8M3ZiMkiYJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198643; c=relaxed/simple;
	bh=w4OMN3k2gDIxY9w+kbNnujenR7MSbe0+Ri+eUuLwffY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdzscXUG2oDZw0gjTxfSfuwkzaqT9gayg4LfmnGfffRDz/6SOR1RN+akayFOn8Iu3U9WGsV/zon/6f6z1PhLqMFv3Ms/B+IRn4JmUhDQhN+RJ32o+EnVQou1hMYlJ4i57GTmMbPYjxpSz7/S3RL55NRftzCliOjPPH+8OY6MJak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FrjjC7VL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrjjC7VL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA981F000FF;
	Sat, 12 Sep 2026 07:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198642;
	bh=1tBFm7reVrzskLjlSrso6/3V1pHCbOfChOklZOP2OsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrjjC7VL2Xkk8vWEyqYLkRM4xiYfpqnr+gMavO9BnpJp13ag8qk6KC5Bs/4PFlH50
	 t+hftpIagt6BaC1rCckfv6ITfsP1fCQ03KGMwmTc1aMf5ypfYic0aHtXGu3iQamjaX
	 YxbmGdXJbWinJBVx36xzD3jC2zuQ/iNjxlH5RXPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0424/1815] cpufreq: spear: Fix an IS_ERR() vs NULL bug in spear1340_set_cpu_rate()
Date: Sat, 12 Sep 2026 08:36:14 +0200
Message-ID: <20260912065658.849674451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 81a0780b2ebf0..ffe5eda82f0b1 100644
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



