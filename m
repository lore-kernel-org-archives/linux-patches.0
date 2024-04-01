Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD321DFF4;
	Mon,  1 Apr 2024 17:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990982; cv=none; b=MK60ojgw2FnbGVhy75p/dgSmW7wL0HSos9KwCjM9wJhQY5k5dFYwZTGUD9inPmevdT9Ya+lGd+dTVt91r+8Uw4j41AWyRb1ryXYdh8FIVKlOs1m/1sS4MZ+WsWp/D5A9sU0CWMjJsQh3SyjMeLy/RUZTJ16fuYEZ9r0fTLB4kzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990982; c=relaxed/simple;
	bh=42YCWH+M64dqHGnPkFAeBYznAGcW1pyLJfYOY7wK1m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyXKyjtHG/gJUnXab8wd4OfHBEQoXNVmxd6b1viZGpEYVaLVHRTYgumlgN7cDTRba7fFqPtHyFrS4y8y0O2FsUevgfxB1vW3iMImO1dUD/a9+I0b8Uu0OOi+rg3kD4FbqtX3/zHcYZVCFeydrTT+uVRCdd8jc9+v1++9YPMaCkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kjp24DHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kjp24DHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E0CC433C7;
	Mon,  1 Apr 2024 17:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990982;
	bh=42YCWH+M64dqHGnPkFAeBYznAGcW1pyLJfYOY7wK1m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kjp24DHYlBv+Lx5t2/ZCianMJ+AmXhZ01weJat23alri83hQBFoL2RSOXa91tQJiL
	 2dVPz0OZQ/MbYKp2E6KCrlJHMIvqkQHLrefpQjjJhX1dc6x/UsjLDUMB4dOk/UqTV4
	 2JQMZ9IkqCupz2pN6ofxwRtYQEsmi7xu4ZmEkfeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"Christoph Lameter (Ampere)" <cl@linux.com>,
	Dhruva Gole <d-gole@ti.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/272] cpufreq: dt: always allocate zeroed cpumask
Date: Mon,  1 Apr 2024 17:45:17 +0200
Message-ID: <20240401152534.636987272@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4aec4b2a52259..8f8f1949d66f6 100644
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



