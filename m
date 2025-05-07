Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8867714A4C7;
	Wed,  7 May 2025 18:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643392; cv=none; b=EVWQU2qoSyhzeLoL04v1A13FP1ka7+uc9b9rk5KpDOw4gCF5qyaNj/pjSPShx1krMVwOYHXcNOZ8/uwgXdabtTxfMxlz0pfWtVm4ATa/F2RlsoiwIL6WkZf5t9ZyTOO7+OOaW6n6vz6RV0POBzEmSH85+l2XtaNkdEz50Mnjy1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643392; c=relaxed/simple;
	bh=DRZLoQJlv53JZu7mIS09UtRdc53fSn/Gi0CE8eQ8YWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBPbT12bJ/GMUCeRXTag+vZCLKAe9QgcOX0OEqo3WWrSDiUUZPw6bAf8tMG1fHgXcMU/pwLeaGN1IEk0/3vkf7R8ClMisvsblL9/84yiLFOxm3UfmdneLqH2nF24w5eMPM09emi5IddZ9CK0eaJSIORk99/1JYFEQpOGvU0e1M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g89uCnPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g89uCnPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1227EC4CEE2;
	Wed,  7 May 2025 18:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643392;
	bh=DRZLoQJlv53JZu7mIS09UtRdc53fSn/Gi0CE8eQ8YWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g89uCnPuqRCkNpR/q3jjssYd+jMTH4x8SYKzz1C8dgNe4gWioH2AqzmrPGMMs5yIE
	 gVxO8axc9Bx4UE68JRsxf7YB5xrBu8c28DJs6Sn9EIr+gdpiefGG1zMve+ss7xaomI
	 zvF8QxNeyLx6ONjj4CpxaYBxiar/T48TWybV57d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 44/55] net: hns3: fix deadlock issue when externel_lb and reset are executed together
Date: Wed,  7 May 2025 20:39:45 +0200
Message-ID: <20250507183800.815541220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonglong Liu <liuyonglong@huawei.com>

commit ac6257a3ae5db5193b1f19c268e4f72d274ddb88 upstream.

When externel_lb and reset are executed together, a deadlock may
occur:
[ 3147.217009] INFO: task kworker/u321:0:7 blocked for more than 120 seconds.
[ 3147.230483] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3147.238999] task:kworker/u321:0  state:D stack:    0 pid:    7 ppid:     2 flags:0x00000008
[ 3147.248045] Workqueue: hclge hclge_service_task [hclge]
[ 3147.253957] Call trace:
[ 3147.257093]  __switch_to+0x7c/0xbc
[ 3147.261183]  __schedule+0x338/0x6f0
[ 3147.265357]  schedule+0x50/0xe0
[ 3147.269185]  schedule_preempt_disabled+0x18/0x24
[ 3147.274488]  __mutex_lock.constprop.0+0x1d4/0x5dc
[ 3147.279880]  __mutex_lock_slowpath+0x1c/0x30
[ 3147.284839]  mutex_lock+0x50/0x60
[ 3147.288841]  rtnl_lock+0x20/0x2c
[ 3147.292759]  hclge_reset_prepare+0x68/0x90 [hclge]
[ 3147.298239]  hclge_reset_subtask+0x88/0xe0 [hclge]
[ 3147.303718]  hclge_reset_service_task+0x84/0x120 [hclge]
[ 3147.309718]  hclge_service_task+0x2c/0x70 [hclge]
[ 3147.315109]  process_one_work+0x1d0/0x490
[ 3147.319805]  worker_thread+0x158/0x3d0
[ 3147.324240]  kthread+0x108/0x13c
[ 3147.328154]  ret_from_fork+0x10/0x18

In externel_lb process, the hns3 driver call napi_disable()
first, then the reset happen, then the restore process of the
externel_lb will fail, and will not call napi_enable(). When
doing externel_lb again, napi_disable() will be double call,
cause a deadlock of rtnl_lock().

This patch use the HNS3_NIC_STATE_DOWN state to protect the
calling of napi_disable() and napi_enable() in externel_lb
process, just as the usage in ndo_stop() and ndo_start().

Fixes: 04b6ba143521 ("net: hns3: add support for external loopback test")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20230807113452.474224-5-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5656,6 +5656,9 @@ void hns3_external_lb_prepare(struct net
 	if (!if_running)
 		return;
 
+	if (test_and_set_bit(HNS3_NIC_STATE_DOWN, &priv->state))
+		return;
+
 	netif_carrier_off(ndev);
 	netif_tx_disable(ndev);
 
@@ -5679,7 +5682,16 @@ void hns3_external_lb_restore(struct net
 	if (!if_running)
 		return;
 
-	hns3_nic_reset_all_ring(priv->ae_handle);
+	if (hns3_nic_resetting(ndev))
+		return;
+
+	if (!test_bit(HNS3_NIC_STATE_DOWN, &priv->state))
+		return;
+
+	if (hns3_nic_reset_all_ring(priv->ae_handle))
+		return;
+
+	clear_bit(HNS3_NIC_STATE_DOWN, &priv->state);
 
 	hns3_enable_irqs_and_tqps(ndev);
 


