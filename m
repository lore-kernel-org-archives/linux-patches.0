Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842F57F465;
	Mon,  8 Apr 2024 13:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581999; cv=none; b=rVJCkktxoL+fiQkPQx+rG2hD6AP0w2MR5jc7OBHTqN4jMfEReslS3etMQHKKbpIjjqTti36+VtyIk/G+lnoQ2bc3JSxj+fWYrX9e7bY3QOtgIOtFmPaAyk6uxeU9UeRXazLtb1eEWalz7/XBXFbX73au6GYQ48TaqZFBIrRZPW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581999; c=relaxed/simple;
	bh=otvRA00S5e8zQFnBTH9saAuS8E8uxNmxDIoP298utZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXyDmpli9QeJAiJlK+JwNQWJy+ABai8V2oxPajzvr0alRggC5lUKcmMWDwpPWDX/llQF9r+ugpsKpuZ4bMCBV0DKxQFOZf7bjxrmYIJDrukZdkd5Co5VNeSXDmxfzW90dsI4gGbgom54bhz/pQBnu19J0WHqI5HFtuKHyhxo4lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bflZEyp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bflZEyp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A00C433F1;
	Mon,  8 Apr 2024 13:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581999;
	bh=otvRA00S5e8zQFnBTH9saAuS8E8uxNmxDIoP298utZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bflZEyp1lOKnNo29NyAyGVERf/6NZGG6Ib9IRnIry1l0xYisJLWTwQr98vRG08Ies
	 ccoYJkwLx+H5Ff4TVZuMvRwTEB7pYvxA9Cl/sHJmhnVrcqQXeTz6BtAHq7aVuZEgzz
	 bpzoCwqkC0Oi1P0JdviXMlsD4Ia/NCFOPuEdBqXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"Christoph Lameter (Ampere)" <cl@linux.com>,
	Dhruva Gole <d-gole@ti.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/690] cpufreq: dt: always allocate zeroed cpumask
Date: Mon,  8 Apr 2024 14:49:29 +0200
Message-ID: <20240408125403.231752040@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8fcaba541539b..1bfdfa7e25c17 100644
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



