Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE561DDA36;
	Tue,  8 Oct 2024 12:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390011; cv=none; b=eAndAahH0t1xEBTmxPNLLSiDAMizUIQTXQgnA6YXb4ipureQk4hWg9F/QRGstNkzVLB6lHL/0AE19TwaC5EbOvK4g3T6F8pvefJEWhgcwiAgJ/I9jWTmwBbEToqZA3ENxjKoNR+fCwXmImk97iZ3YsOERfk18J/T2DKUmZUEYM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390011; c=relaxed/simple;
	bh=1Y+ytk3MYnIV5xoqtbZgeK1sNhr+1GnLV2kCYuX8lBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7TzrTkQ+LiZ8b6WEF/1x6yKUsnqUXclGIuWOWaukIsm6V/zbnJg/tsTZ4tvYL3B5re+Edg1UmhEX+libaoii/+R2SgSiQ4LCurhvD4YZbO8nYpjMq7emJRYvcq3IdzQ4gWlE01/55Mn5bL8FDDibWRozgx6WhUR840ZF90SDNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hl9LpUxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hl9LpUxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07C0C4CEC7;
	Tue,  8 Oct 2024 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390011;
	bh=1Y+ytk3MYnIV5xoqtbZgeK1sNhr+1GnLV2kCYuX8lBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hl9LpUxP9myz2vAKgQzRyThKFfOLAgjaePaEOrIEBVrloP+Ci8Fo89c7xu6KO3ord
	 4mpCWxrTlRVMDt4oOT6qtxEDrTh9tcHbq3EabWGEd61siD2AaFzgUvwIUBZzPW8mWW
	 f62MfygSPIE7bagQP4SWCL7tJnVwt2FYq1WGIGaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	Raghavendra Kakarla <quic_rkakarla@quicinc.com>
Subject: [PATCH 6.10 164/482] pmdomain: core: Dont hold the genpd-lock when calling dev_pm_domain_set()
Date: Tue,  8 Oct 2024 14:03:47 +0200
Message-ID: <20241008115654.758564429@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit b87eee38605c396f0e1fa435939960e5c6cd41d6 ]

There is no need to hold the genpd-lock, while assigning the
dev->pm_domain. In fact, it becomes a problem on a PREEMPT_RT based
configuration as the genpd-lock may be a raw spinlock, while the lock
acquired through the call to dev_pm_domain_set() is a regular spinlock.

To fix the problem, let's simply move the calls to dev_pm_domain_set()
outside the genpd-lock.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Raghavendra Kakarla <quic_rkakarla@quicinc.com>  # qcm6490 with PREEMPT_RT set
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20240527142557.321610-3-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pmdomain/core.c b/drivers/pmdomain/core.c
index 0ab6008e863e8..4134a8344d2da 100644
--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -1694,7 +1694,6 @@ static int genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 	genpd_lock(genpd);
 
 	genpd_set_cpumask(genpd, gpd_data->cpu);
-	dev_pm_domain_set(dev, &genpd->domain);
 
 	genpd->device_count++;
 	if (gd)
@@ -1703,6 +1702,7 @@ static int genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 	list_add_tail(&gpd_data->base.list_node, &genpd->dev_list);
 
 	genpd_unlock(genpd);
+	dev_pm_domain_set(dev, &genpd->domain);
  out:
 	if (ret)
 		genpd_free_dev_data(dev, gpd_data);
@@ -1759,12 +1759,13 @@ static int genpd_remove_device(struct generic_pm_domain *genpd,
 		genpd->gd->max_off_time_changed = true;
 
 	genpd_clear_cpumask(genpd, gpd_data->cpu);
-	dev_pm_domain_set(dev, NULL);
 
 	list_del_init(&pdd->list_node);
 
 	genpd_unlock(genpd);
 
+	dev_pm_domain_set(dev, NULL);
+
 	if (genpd->detach_dev)
 		genpd->detach_dev(genpd, dev);
 
-- 
2.43.0



