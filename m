Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B671C4613;
	Tue,  8 Oct 2024 12:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391686; cv=none; b=UYG8piMAVoGg9lp81Q84qrv1RFkPmjtdG+IC4SdV723u3SbTtQgtcg4DnJHvjZQpq1mIO/T16LpIp4E4KZE3VUi+BQxpe58AjaTSe2kES4DysfQ1TWLjfl9N/+bLANBfSET6Z6cSeKjLNJX3eOfEibEx2Mqcspso54t9sBNEwLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391686; c=relaxed/simple;
	bh=3woU2VNTKjtG/hg9UMXtOGLLA/kQH8U9g9fGsqSeups=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTwe+ml+oCpCjdC1TWa3/KFWWjKW0y2mCuyvtLjOYRE+1I17dcFGS5mcKUx9FdXbqtXzV9rKLI+ZCmlZqxd3wkMOEb2bjW4sonIFGEkyxJ3pO4gpRWEDvjVGkhqx5AhQTwEPzn+khI1AtAKawZXYwldADPkzLXvuaMUNuKWhzzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wb4QYhbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wb4QYhbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1217BC4CEC7;
	Tue,  8 Oct 2024 12:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391686;
	bh=3woU2VNTKjtG/hg9UMXtOGLLA/kQH8U9g9fGsqSeups=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wb4QYhbPMNwxvaEdhT/02F9pyg9FdTVt/gaUT6UOAOYlhpcybFdGxHkfAnyV5oEIp
	 t5NGgE/GGwMhkVox1q0kHH6xqfNaedFp1od0U1kbrRzwSza5pmJ15ye1ncdq/fsVwm
	 hwNsi6lRuNa1eg4tmki6PpTQl2pkWtInzXWFqkwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	Raghavendra Kakarla <quic_rkakarla@quicinc.com>
Subject: [PATCH 6.11 192/558] pmdomain: core: Dont hold the genpd-lock when calling dev_pm_domain_set()
Date: Tue,  8 Oct 2024 14:03:42 +0200
Message-ID: <20241008115709.905109664@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index acdc3e7b2eae2..ca7f780582cf4 100644
--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -1758,7 +1758,6 @@ static int genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 	genpd_lock(genpd);
 
 	genpd_set_cpumask(genpd, gpd_data->cpu);
-	dev_pm_domain_set(dev, &genpd->domain);
 
 	genpd->device_count++;
 	if (gd)
@@ -1767,6 +1766,7 @@ static int genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 	list_add_tail(&gpd_data->base.list_node, &genpd->dev_list);
 
 	genpd_unlock(genpd);
+	dev_pm_domain_set(dev, &genpd->domain);
  out:
 	if (ret)
 		genpd_free_dev_data(dev, gpd_data);
@@ -1823,12 +1823,13 @@ static int genpd_remove_device(struct generic_pm_domain *genpd,
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



