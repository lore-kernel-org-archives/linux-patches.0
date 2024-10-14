Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF2524B34;
	Mon, 14 Oct 2024 14:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916365; cv=none; b=iKbRGwYOQsYioX1tjaPjJx/qBckJvBtaFiy+PWeS/E0ifrbDgu5U/5yjMNn04plPectmA7OTy79XN96tXRJn0rkvMuucKIz7QLxIV8vzrrFZjGo+CiaVppxgp8NCRipOJ1QHAj79LNhXDcFLBTdnTo+Lxs1q17xV53qHV3AqedU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916365; c=relaxed/simple;
	bh=34XnZspkRSdBE+ZwTINkqDh/NyUXne+f2Pgv+zupuRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cE63zzpXFmW297Y0Pju7sLlQY4Y06Y8qhJjQfqDuBeMjh8IoJZjbWfmAz3dIViX6XgiGNlyIOcqRtFb57BYMak1QSLyMwxAf5uIdnqGgnfGbltiLNZoR+8wGhZ1zB2fQQ1NUTVfF7UsZ5DIWLiqXwaP7bZe4a+lPoe1sb2xog5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSHCeDSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSHCeDSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C204CC4CEC7;
	Mon, 14 Oct 2024 14:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916365;
	bh=34XnZspkRSdBE+ZwTINkqDh/NyUXne+f2Pgv+zupuRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSHCeDSpG7FBYM8l2VR0Gs2bmgtOWGvF5mLNXIvZTzHswR3nS8LGTubgY9S7AHwgm
	 pIgGbPQkUmkJzXNSRDBReVRNI55S0+eevftLQxsrDl1WKzCqnzLOHgkzIfrGTwBL1s
	 RmP0oz+uynQT5nhKDmTjknWUuTmjf5LpxQJCqLew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 131/214] net: ti: icssg-prueth: Fix race condition for VLAN table access
Date: Mon, 14 Oct 2024 16:19:54 +0200
Message-ID: <20241014141050.104436253@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit ff8ee11e778520c5716b7f165d2c7ce14d6a068b ]

The VLAN table is a shared memory between the two ports/slices
in a ICSSG cluster and this may lead to race condition when the
common code paths for both ports are executed in different CPUs.

Fix the race condition access by locking the shared memory access

Fixes: 487f7323f39a ("net: ti: icssg-prueth: Add helper functions to configure FDB")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_config.c | 2 ++
 drivers/net/ethernet/ti/icssg/icssg_prueth.c | 1 +
 drivers/net/ethernet/ti/icssg/icssg_prueth.h | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_config.c b/drivers/net/ethernet/ti/icssg/icssg_config.c
index dae52a83a3786..5be020d0887ac 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_config.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_config.c
@@ -733,6 +733,7 @@ void icssg_vtbl_modify(struct prueth_emac *emac, u8 vid, u8 port_mask,
 	u8 fid_c1;
 
 	tbl = prueth->vlan_tbl;
+	spin_lock(&prueth->vtbl_lock);
 	fid_c1 = tbl[vid].fid_c1;
 
 	/* FID_C1: bit0..2 port membership mask,
@@ -748,6 +749,7 @@ void icssg_vtbl_modify(struct prueth_emac *emac, u8 vid, u8 port_mask,
 	}
 
 	tbl[vid].fid_c1 = fid_c1;
+	spin_unlock(&prueth->vtbl_lock);
 }
 EXPORT_SYMBOL_GPL(icssg_vtbl_modify);
 
diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index e3451beed3238..33cb3590a5cde 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -1262,6 +1262,7 @@ static int prueth_probe(struct platform_device *pdev)
 		icss_iep_init_fw(prueth->iep1);
 	}
 
+	spin_lock_init(&prueth->vtbl_lock);
 	/* setup netdev interfaces */
 	if (eth0_node) {
 		ret = prueth_netdev_init(prueth, eth0_node);
diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.h b/drivers/net/ethernet/ti/icssg/icssg_prueth.h
index f678d656a3ed3..4d1c895dacdb6 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.h
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.h
@@ -282,6 +282,8 @@ struct prueth {
 	bool is_switchmode_supported;
 	unsigned char switch_id[MAX_PHYS_ITEM_ID_LEN];
 	int default_vlan;
+	/** @vtbl_lock: Lock for vtbl in shared memory */
+	spinlock_t vtbl_lock;
 };
 
 struct emac_tx_ts_response {
-- 
2.43.0



