Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD84C129;
	Mon,  1 Apr 2024 16:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988445; cv=none; b=myYnJkYhsKZ4otO/shHlWBdr5o8sXyyX+03p2t43yhmRBHZnkiPWbGcTO/N6ZUC7Ka5MUzoWJcL1ypzrHiLLbVqw72RzEhQ/MWRODVQ3QVsMXInMMbVlUlN5Ety5mhQmDAki7X0jVWTNMmCDCOzbFFmheLpp9v+ZzcP3hazSHM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988445; c=relaxed/simple;
	bh=iRs9DJiCOoQpghQfP54b2JJXfTI29DrV6uUCT0gfjk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kB2NeUP/C6yNJExu1WfaP04OCI9lzn/115KxIAja/xGqEo3vKWmK+gpgJ4u+SkfgRhYK3cUzsm0wrSJiwt41ypwtNkyYI9+hdsybUn7oHlIW0Pi5JRguEMjSg/R1cSgfnjYtdmx/lLIH89CmiCbTDj5eqUI5LmtlQqxUhzIcpSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8DfLUz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8DfLUz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86306C433F1;
	Mon,  1 Apr 2024 16:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988445;
	bh=iRs9DJiCOoQpghQfP54b2JJXfTI29DrV6uUCT0gfjk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8DfLUz+qSYO0iq82PndpoGaMMk+dD6FwSFJ+rp1PJduzH6J5imXGIADTYppV3ead
	 uNIC2Fpkz4FpXmDgxhS8qJpe1ppk9i8gKJ1wjV1On4Me95JmNo77ioXjrZD75UynkC
	 TjIQkKJobD9P8C/69nQgTghfOI5oDfVGc5kwnX9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"Christoph Lameter (Ampere)" <cl@linux.com>,
	Dhruva Gole <d-gole@ti.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 186/432] cpufreq: dt: always allocate zeroed cpumask
Date: Mon,  1 Apr 2024 17:42:53 +0200
Message-ID: <20240401152558.689833484@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



