Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73488202963;
	Mon, 27 Oct 2025 19:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593249; cv=none; b=g4tgMaVF6BnxLb4hrUcbZ5Q4wRTCT+xDxORRDdshE/u5Q/VciXrkphKPABOioaE+LTgbok3h04tR1/hZ3FvC4jljfNEAYvagejqphjrY80nu54FX/UIMD9xJmuxoVeYLIEyCvCvAtHhnkNyprttk81y6W1Ld5HX2QRtdDweByRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593249; c=relaxed/simple;
	bh=S936Mfz8q9sOH6x+0rf1IlDWH4pxWq5DjmQUEwxtKSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f636U5qivBe6AcpI6jSUtk/OjAJUUAIJpx4z2FnyRZ2+12xnlvARrxI+3/Zy17jhH4Wph86QBZl75Lx7zHjLFGnn9M9XtVfoA659PhzC7K/mT3v5gdnBmRyKDTUk9CRzNZ+Rd+HwyGKm1q0Msiv0Y02sOtdlenOB1dddjAxp7ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8cNfA7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8cNfA7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3678C4CEF1;
	Mon, 27 Oct 2025 19:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593249;
	bh=S936Mfz8q9sOH6x+0rf1IlDWH4pxWq5DjmQUEwxtKSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8cNfA7S2PeMjdgJy/DQZ9etbmEDOZIp6Oa2Wrw2BucAPz3H/3gCajFFTaPzkOBWK
	 ZIjUa2fTMkKxMctLq1ecgPhCBrQam8WHcYPuebf+gju0cblWqK3mfMbRNxOn1vxlxc
	 JnZ+5B9mH0fSUL/7LXMOllBIWymjUxlEH08rL5Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 033/184] platform/mellanox: mlxbf-pmc: add sysfs_attr_init() to count_clock init
Date: Mon, 27 Oct 2025 19:35:15 +0100
Message-ID: <20251027183515.811957206@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit a7b4747d8e0e7871c3d4971cded1dcc9af6af9e9 ]

The lock-related debug logic (CONFIG_LOCK_STAT) in the kernel is noting
the following warning when the BlueField-3 SOC is booted:

  BUG: key ffff00008a3402a8 has not been registered!
  ------------[ cut here ]------------
  DEBUG_LOCKS_WARN_ON(1)
  WARNING: CPU: 4 PID: 592 at kernel/locking/lockdep.c:4801 lockdep_init_map_type+0x1d4/0x2a0
<snip>
  Call trace:
   lockdep_init_map_type+0x1d4/0x2a0
   __kernfs_create_file+0x84/0x140
   sysfs_add_file_mode_ns+0xcc/0x1cc
   internal_create_group+0x110/0x3d4
   internal_create_groups.part.0+0x54/0xcc
   sysfs_create_groups+0x24/0x40
   device_add+0x6e8/0x93c
   device_register+0x28/0x40
   __hwmon_device_register+0x4b0/0x8a0
   devm_hwmon_device_register_with_groups+0x7c/0xe0
   mlxbf_pmc_probe+0x1e8/0x3e0 [mlxbf_pmc]
   platform_probe+0x70/0x110

The mlxbf_pmc driver must call sysfs_attr_init() during the
initialization of the "count_clock" data structure to avoid
this warning.

Fixes: 5efc800975d9 ("platform/mellanox: mlxbf-pmc: Add support for monitoring cycle count")
Reviewed-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Signed-off-by: David Thompson <davthompson@nvidia.com>
Link: https://patch.msgid.link/20251013155605.3589770-1-davthompson@nvidia.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index 4776013e07649..16a2fd9fdd9b8 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -2015,6 +2015,7 @@ static int mlxbf_pmc_init_perftype_counter(struct device *dev, unsigned int blk_
 	if (pmc->block[blk_num].type == MLXBF_PMC_TYPE_CRSPACE) {
 		/* Program crspace counters to count clock cycles using "count_clock" sysfs */
 		attr = &pmc->block[blk_num].attr_count_clock;
+		sysfs_attr_init(&attr->dev_attr.attr);
 		attr->dev_attr.attr.mode = 0644;
 		attr->dev_attr.show = mlxbf_pmc_count_clock_show;
 		attr->dev_attr.store = mlxbf_pmc_count_clock_store;
-- 
2.51.0



