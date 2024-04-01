Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76884AED4;
	Mon,  1 Apr 2024 16:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989826; cv=none; b=ZfZf6vqOSkWON2TSmzhzayCOYqK+UYj0VGYN+C1w0pzlWy80upjJKgUNjgNk5JWDV4zTdJXb1/ditKF7JZfgD8K8EBochNg0w6e+oHHEBVlbwPJn4Ko0k7qfbSMixrZfS/XoAc4DOSdjNgNsCAwVly+G2310cIxQfP9BrBgO0Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989826; c=relaxed/simple;
	bh=1bKizJToSKSQEZsa/8DxrytX+CV6hA1q/VKlIqtNUCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyAe/+sStdf5avzrbVPoVjgxOUppxQf7NO+OpBkcsyGt8JZU+rnrL92xMz900e1QkQkCpo9DajSHjVm4e7AtMg27CJ1LGMXCKpdMY3CBFuBv4pjFL189i725RsgxgFtfP6a/6A3ZfSNArXwO5ab8mC/jReiR+gaERCQjDEaAJ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gs0c+/zA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gs0c+/zA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D14C433C7;
	Mon,  1 Apr 2024 16:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989826;
	bh=1bKizJToSKSQEZsa/8DxrytX+CV6hA1q/VKlIqtNUCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gs0c+/zAlFMbQq9AH8b+oJjhUS8760+hwaEpd7gOolv6PLAr2CGD0r4rd40EInb18
	 ZkLTIojiG1ecR3JDsr/sUm22b4W0XVNYmX3mxT3B3n5GgY07KXDvK097DpxQCGfshc
	 SKehn296VOFOP1ZmbwflHu2e8JXutWPs4zEmWN6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"Christoph Lameter (Ampere)" <cl@linux.com>,
	Dhruva Gole <d-gole@ti.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/396] cpufreq: dt: always allocate zeroed cpumask
Date: Mon,  1 Apr 2024 17:43:34 +0200
Message-ID: <20240401152552.859851712@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit d2399501c2c081eac703ca9597ceb83c7875a537 ]

Commit 0499a78369ad ("ARM64: Dynamically allocate cpumasks and increase
supported CPUs to 512") changed the handling of cpumasks on ARM 64bit,
what resulted in the strange issues and warnings during cpufreq-dt
initialization on some big.LITTLE platforms.

This was caused by mixing OPPs between big and LITTLE cores, because
OPP-sharing information between big and LITTLE cores is computed on
cpumask, which in turn was not zeroed on allocation. Fix this by
switching to zalloc_cpumask_var() call.

Fixes: dc279ac6e5b4 ("cpufreq: dt: Refactor initialization to handle probe deferral properly")
CC: stable@vger.kernel.org # v5.10+
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Christoph Lameter (Ampere) <cl@linux.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq-dt.c b/drivers/cpufreq/cpufreq-dt.c
index 8bd6e5e8f121c..2d83bbc65dd0b 100644
--- a/drivers/cpufreq/cpufreq-dt.c
+++ b/drivers/cpufreq/cpufreq-dt.c
@@ -208,7 +208,7 @@ static int dt_cpufreq_early_init(struct device *dev, int cpu)
 	if (!priv)
 		return -ENOMEM;
 
-	if (!alloc_cpumask_var(&priv->cpus, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&priv->cpus, GFP_KERNEL))
 		return -ENOMEM;
 
 	cpumask_set_cpu(cpu, priv->cpus);
-- 
2.43.0



