Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722202FA622;
	Tue, 17 Jun 2025 16:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178728; cv=none; b=A+egFwpt62gUY8Oqohl4SP0T3qPV00aOjmHf8W54RKctY+53PSliK/o4x3Ba/ErlfmpFoHXn0cu/EmVWaJVolLU80/phz41rO8nrSmeP/FTR2wxXHhGKsoa3beK65e1Y8B45zTZes7E6koLB5UrUEPCE9HgY1WNWUV6wbAMiyEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178728; c=relaxed/simple;
	bh=9RFEfGTuxXh+7Ea9bHdmcjYFv83F4vrG/Wu0Dhm4p3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pU1RderOEJH/Wls33RQpY+gZHzXuLy3VJYlHz+LwIhlAMww3vzATCNcd11EFE6sOJ030g0nAGzcp6yIPlgHQd8UH9UNtH/FzFwmNtXPyggfz9t+Mjw0anzfmxC496r8BY5mRktLQnHGkuTgnx+Z+cEgLRhqNTc279fG8ZDmUAYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xf2EWrm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xf2EWrm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0775C4CEE3;
	Tue, 17 Jun 2025 16:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178728;
	bh=9RFEfGTuxXh+7Ea9bHdmcjYFv83F4vrG/Wu0Dhm4p3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xf2EWrm6kIWaP4L6mDNLUyS31PJCitLnAWYIQD7oeirQKzSLPRU47WDiGIRUIYDue
	 ogqduFa/OAGV3otcuFIn5wqcJJxyLcpg05QPdd/dtRAMsseA8MiWvF/u1ihKE/78Xo
	 p/a8HAP+n+4D0bEQ4YkMyBiUSdO80chLUo3eg8MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 535/780] coresight: holding cscfg_csdev_lock while removing cscfg from csdev
Date: Tue, 17 Jun 2025 17:24:03 +0200
Message-ID: <20250617152513.296204596@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 53b9e2659719b04f5ba7593f2af0f2335f75e94a ]

There'll be possible race scenario for coresight config:

CPU0                                          CPU1
(perf enable)                                 load module
                                              cscfg_load_config_sets()
                                              activate config. // sysfs
                                              (sys_active_cnt == 1)
...
cscfg_csdev_enable_active_config()
  lock(csdev->cscfg_csdev_lock)
                                              deactivate config // sysfs
                                              (sys_activec_cnt == 0)
                                              cscfg_unload_config_sets()
  <iterating config_csdev_list>               cscfg_remove_owned_csdev_configs()
  // here load config activate by CPU1
  unlock(csdev->cscfg_csdev_lock)

iterating config_csdev_list could be raced with config_csdev_list's
entry delete.

To resolve this race , hold csdev->cscfg_csdev_lock() while
cscfg_remove_owned_csdev_configs()

Fixes: 02bd588e12df ("coresight: configuration: Update API to permit dynamic load/unload")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250514161951.3427590-3-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-syscfg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-syscfg.c b/drivers/hwtracing/coresight/coresight-syscfg.c
index a70c1454b4106..23017612f2eae 100644
--- a/drivers/hwtracing/coresight/coresight-syscfg.c
+++ b/drivers/hwtracing/coresight/coresight-syscfg.c
@@ -395,6 +395,8 @@ static void cscfg_remove_owned_csdev_configs(struct coresight_device *csdev, voi
 	if (list_empty(&csdev->config_csdev_list))
 		return;
 
+  guard(raw_spinlock_irqsave)(&csdev->cscfg_csdev_lock);
+
 	list_for_each_entry_safe(config_csdev, tmp, &csdev->config_csdev_list, node) {
 		if (config_csdev->config_desc->load_owner == load_owner)
 			list_del(&config_csdev->node);
-- 
2.39.5



