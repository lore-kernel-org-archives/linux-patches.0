Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06E639CCE6;
	Sat, 17 Oct 2026 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253304; cv=none; b=MRwY7Emt9uQxzD8BWqGIPkj+A7mINgZk87ATaN25mRk6/rfDtgvm361+c/FfF00ehkVUJ5jCHD7/neSNS8/qBZuhcHwXnkDpPkyLGNwB6lDC4seybWaL6HWeaMGVKoXKtye5xu1J5j/89ApyQFE3m3aAAyS4uv++TtZOQ6gi0WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253304; c=relaxed/simple;
	bh=2c1a4Dxn8jTesHfPEHe4PZ5q7ngz9MUDTJIf0Divc3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XX8SpAeylIGiDsWUNREb9LNplkeO0BquMh1YTfe9W/ldGOsJMRUS2NZqi8ITGjF3TI7RWbvsVpjzUbVrvdMiM9Rn/ccR1kG7vg5qLIBfH+vOacHmzI14r94zpZcFnhp+OzJQTRJuSb2TyeyBB5joIDnFLExrup3tA9+V98Fvpp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khv8bgPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khv8bgPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD731F000C4;
	Sat, 17 Oct 2026 16:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253302;
	bh=u43jmJZf6ORczQfXFUxo/CFIYx0HZuyug4IS2i3JLDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khv8bgPTagyuMbzulmMh5eQO7jlUnRhBP9S+ro+auLEOVOF/MuHj+5F2NZi2y+6fK
	 rYkovr1DkCOwJpVrbOO8huEWldlHuO9qCHZZzYPyOJ3hG/Ht/yfexUG8ISFflzYSnd
	 4kS7NJVpQo1VfAoxrhEKGPRr+rP4H/zmMYBHPWzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/869] coresight: holding cscfg_csdev_lock while removing cscfg from csdev
Date: Sat, 17 Oct 2026 17:48:36 +0200
Message-ID: <20261017160038.949758844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 30a561d874819..55f36ed1af13c 100644
--- a/drivers/hwtracing/coresight/coresight-syscfg.c
+++ b/drivers/hwtracing/coresight/coresight-syscfg.c
@@ -395,6 +395,8 @@ static void cscfg_remove_owned_csdev_configs(struct coresight_device *csdev, voi
 	if (list_empty(&csdev->config_csdev_list))
 		return;
 
+	guard(spinlock_irqsave)(&csdev->cscfg_csdev_lock);
+
 	list_for_each_entry_safe(config_csdev, tmp, &csdev->config_csdev_list, node) {
 		if (config_csdev->config_desc->load_owner == load_owner)
 			list_del(&config_csdev->node);
-- 
2.53.0



