Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A11263F54;
	Wed, 23 Apr 2025 14:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419940; cv=none; b=PorqEG389RJP0Wx/jBasAUy6UlPNEhjpmomeGlKSjktYWzX5acqjOVEXqoOrYSzE5tdjnV37++diFEL/1KBmRh8yBLfaW9H6UlUDU50hFHw4ENkxg2QZ72uKyD/LXGcicoiUk3P+k7i2DqIjp6ZwXxnmbCD3ktoTy9kppnMr11E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419940; c=relaxed/simple;
	bh=hgnEN94KL20AbiXYedQICSJT/cfjPOO5Y87tBo7VhmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2QCmhJAWU0t+0b9VORjlulUW8WAvzyzNsd0DPF8ugg9XF/aDjVlb+sar87+s++1ndra4u9I8HVO2DARSfGRpodcqS+/NPh6MgpDHTgSvt/Vj5HJBDvz7sXpAgaERiDfOcOTpTjbW3VFqlmZbCbJ8zNG5Hn4+tZIctgQkmoBV7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WH95EN9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WH95EN9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7800DC4CEE2;
	Wed, 23 Apr 2025 14:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419939;
	bh=hgnEN94KL20AbiXYedQICSJT/cfjPOO5Y87tBo7VhmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WH95EN9zkQhCsZVN0dtFv5nBgVcyfMsYX9Fmpnwfo8P6QkrYhrC1u2/EkOw6ffTT3
	 v4RxTik8CsvpPrCmXG81mdlB8HFoTQwdUWh2kP1+BdfyrcwTJxyzgbm4/NvWJouLg1
	 RxUVEbFx1k0VdYqZTidkVPXSf9UQESGk4p2y6T+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 045/241] ethtool: cmis_cdb: use correct rpl size in ethtool_cmis_module_poll()
Date: Wed, 23 Apr 2025 16:41:49 +0200
Message-ID: <20250423142622.348724026@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>

[ Upstream commit f3fdd4fba16c74697d8bc730b82fb7c1eff7fab3 ]

rpl is passed as a pointer to ethtool_cmis_module_poll(), so the correct
size of rpl is sizeof(*rpl) which should be just 1 byte.  Using the
pointer size instead can cause stack corruption:

Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ethtool_cmis_wait_for_cond+0xf4/0x100
CPU: 72 UID: 0 PID: 4440 Comm: kworker/72:2 Kdump: loaded Tainted: G           OE      6.11.0 #24
Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
Hardware name: Dell Inc. PowerEdge R760/04GWWM, BIOS 1.6.6 09/20/2023
Workqueue: events module_flash_fw_work
Call Trace:
 <TASK>
 panic+0x339/0x360
 ? ethtool_cmis_wait_for_cond+0xf4/0x100
 ? __pfx_status_success+0x10/0x10
 ? __pfx_status_fail+0x10/0x10
 __stack_chk_fail+0x10/0x10
 ethtool_cmis_wait_for_cond+0xf4/0x100
 ethtool_cmis_cdb_execute_cmd+0x1fc/0x330
 ? __pfx_status_fail+0x10/0x10
 cmis_cdb_module_features_get+0x6d/0xd0
 ethtool_cmis_cdb_init+0x8a/0xd0
 ethtool_cmis_fw_update+0x46/0x1d0
 module_flash_fw_work+0x17/0xa0
 process_one_work+0x179/0x390
 worker_thread+0x239/0x340
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xcc/0x100
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2d/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Fixes: a39c84d79625 ("ethtool: cmis_cdb: Add a layer for supporting CDB commands")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250409173312.733012-1-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/cmis_cdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/cmis_cdb.c b/net/ethtool/cmis_cdb.c
index 0e2691ccb0df3..3057576bc81e3 100644
--- a/net/ethtool/cmis_cdb.c
+++ b/net/ethtool/cmis_cdb.c
@@ -351,7 +351,7 @@ ethtool_cmis_module_poll(struct net_device *dev,
 	struct netlink_ext_ack extack = {};
 	int err;
 
-	ethtool_cmis_page_init(&page_data, 0, offset, sizeof(rpl));
+	ethtool_cmis_page_init(&page_data, 0, offset, sizeof(*rpl));
 	page_data.data = (u8 *)rpl;
 
 	err = ops->get_module_eeprom_by_page(dev, &page_data, &extack);
-- 
2.39.5



