Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7B2134CC2;
	Thu, 11 Apr 2024 10:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831771; cv=none; b=EPbmeMxlsfMrPhDWTd7q9XHK/eLwitD6UUfRdgV8JDJm2bt+dbA8zG18q5dBmNaUjJGd7DIFsoGkQjG54jTgE8179EmtbTt51/fA96XhF/Qv/ZDoU7fkasMXWI8daeZyhoU0Ru2ePA9bPU3qknJ/oJInCAVHvNdpC3yQs8WZdFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831771; c=relaxed/simple;
	bh=4DsftsmgsEF+zFjGj8SunzlUMOOLKJzCujgcJEc7xNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGNoApCFVZt3aUf7RqRG0NKDSrC30Px8lOHgr9InzIvfN8QLvWIwpNj/Id39B9T3CSvFi8PBCkYwpMonpa40bjM4hR40uarFmjkkw7EyNutnnmZk4mpDOA6iGtKIwDc+KWO1mnH1HG5oODNP+2gqf1+1ux1TWY4rJpLSS/e4M78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXqcrCut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXqcrCut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65390C433F1;
	Thu, 11 Apr 2024 10:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831770;
	bh=4DsftsmgsEF+zFjGj8SunzlUMOOLKJzCujgcJEc7xNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXqcrCutyLMP1pBe2nnyMzzcHoMUKtfk/fy9grIhuSO/fncMrr/JkUmjsdMS4Rq0v
	 OEN+KhJYDN+j8imCqYD7kcw1KmFBsvVJmiJTjnTDw0kL2i7OV7Dwu1eXd0psmjblq4
	 nwn675XJkp+MVFp8pI9CCgHz7ikJA1Ntk28mGza0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"Christoph Lameter (Ampere)" <cl@linux.com>,
	Dhruva Gole <d-gole@ti.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/294] cpufreq: dt: always allocate zeroed cpumask
Date: Thu, 11 Apr 2024 11:54:26 +0200
Message-ID: <20240411095438.772509380@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e363ae04aac62..44cc596ca0a5e 100644
--- a/drivers/cpufreq/cpufreq-dt.c
+++ b/drivers/cpufreq/cpufreq-dt.c
@@ -251,7 +251,7 @@ static int dt_cpufreq_early_init(struct device *dev, int cpu)
 	if (!priv)
 		return -ENOMEM;
 
-	if (!alloc_cpumask_var(&priv->cpus, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&priv->cpus, GFP_KERNEL))
 		return -ENOMEM;
 
 	priv->cpu_dev = cpu_dev;
-- 
2.43.0



