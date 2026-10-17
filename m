Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCECA3A2559;
	Sat, 17 Oct 2026 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258092; cv=none; b=eFkjQztReBU4N3DsF4fo+BOGZpBLBRPDA1fh8rzlzs4uZqR36Rk1N12WsH/TIY3rLS0DXfwlAo00kef8+eucgZIELd31b+wO+FHfdMy3D/wmbIVKrG7mIpuenCOzxW3p6NefXMOpwiazQHnbVJs0Nd1w2wym0XjyOUQvli4cGqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258092; c=relaxed/simple;
	bh=VqZ0YaXRladGlFf6Kc0irm7Thu4VshSz7UFhjSCyYrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rf8qA2Tta4CDLbIhhv8cBkCvwGCNvHdGpYZIqLh4VQPUfN9oryDsHk25iblw+UfxkBiWHEPnzI8TJKaV80XwG8Pr/pscmvyjMEc6ucgsX2HHAV9hCQLHUN6LrqWJwuhGQLDsyEtCkNu8GvQWNbpUN/NKYhZ3VIgjtU+hl0++AMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTtobsTx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTtobsTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12691F000C4;
	Sat, 17 Oct 2026 17:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258090;
	bh=SskKf6B7f/hosQm/PHm0UkRtIkHGupK/TkaCFWm+Guk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTtobsTx3t9iYWARC8UDltbjusci1H88Jnf4UjEIOHi3vhsJVxgOL+4aOsCwp4N3u
	 8KU5NkifE7VN5T73H6SmP0hYYBc9lx37Qq/yQsvJ7qh+FnIeZnC/ICD3MmjwoCApa0
	 FPt97anOHXDFGVMynAgOnTTmvHfQtze3fAQ+friM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0752/1674] coresight: holding cscfg_csdev_lock while removing cscfg from csdev
Date: Sat, 17 Oct 2026 17:50:24 +0200
Message-ID: <20261017160450.404176914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



