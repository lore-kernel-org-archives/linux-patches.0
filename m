Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393EA2F531B;
	Sat, 12 Sep 2026 12:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215518; cv=none; b=Rpz+GnLSR+YIp+SQtiawKPArkdw7zIdcMLnih/jIu9pOBmnjBt8v14EZCtWgIevsRNijYTZniQzoThWtiCmeVTrgrnomLaPBhOjZdmO4Qd0q8F2NdWjDEfppNc2eZYxvlAFrULTVA2w52Dh8wS4i6xMXlWSavwzNfhTHZr9wfIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215518; c=relaxed/simple;
	bh=S8tddhRcUojRWs5NEuZ29vQX7W1BkcdURZZBQD7phDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2Rw3/NkYQjEHpDvDRLGkbEslmp9Y7FPZfjfA9WlgKp81B62f0onTu8SgOSAN5O9wvI8BhivVU1t1+rdHBVAe6JT5JrzJF5EODobdr45SlPyFTkmTDv5aVVPA3Kb1h+pIGVt+B7V5Zx7S7KLR9T6EJumULtOv1tswS8oC5fSbh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYo3qVuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYo3qVuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072571F000FF;
	Sat, 12 Sep 2026 12:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215516;
	bh=jx+ti9xavQZ+8SayEU9qPMc+k0XwdVxfjvTfI0c/2e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYo3qVuDTedsdzghS9E/hOVNKKrqgexHBgOkNdgWLyjUGukuy7DvtZj/F0rpMGl9q
	 efZwY2qFM1f+XxdhTF36GVn6FBLI2HKe0zBtIMHe2XJwynue14SGxSYvxqcNqipufg
	 YL7rk5ou95osTGiHc6EHqFJ/UaMeUyGieYnq/p6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0547/1376] cpufreq: spear: Fix an IS_ERR() vs NULL bug in spear1340_set_cpu_rate()
Date: Sat, 12 Sep 2026 08:49:33 +0200
Message-ID: <20260912065619.730418007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c032dd5d12d3c..ae038eec35bc1 100644
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



