Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7425158B7;
	Wed, 30 Sep 2026 16:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787059; cv=none; b=m2pFffI4tEUYQVm7RhFTEKuQtegdWoA2A+Xo7SVa4XizbPmfVmzcIp2i72wGztOuCrRQouqZyp4nky0xe+fiwxEQnpeAfKCv1mdmdRaRQmIizLkMWKLkZixkFP2R4FOxdBj10l/8cKjK7kKM1gYIvD9R+L3JonnmOerbEK9wU98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787059; c=relaxed/simple;
	bh=HZrCLyDGEGg1Xjt5Uu5UguYfqSS/JJZzozBC4w7/Jv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbDY32BOhdVt4s5cCWIo9pPem4n1OrbZzO6IlHAA+lC640BorTw2aJWnJVd7NrrsIqxLPtNfjjfzHvK6Sv3wWGx4tq2ekoU9CO/81XT1Uf7eyIoFiwB4OOfEfPXOmbqbZu5kf/A6ZFcjAs6zSpxt84drJMJaDgyAIwV8QxNnWAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+nqc6mZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+nqc6mZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4051F000FF;
	Wed, 30 Sep 2026 16:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787058;
	bh=hZiR/KmSboiIhxpRYQuJa6sDMCo+3iG5FkEZLAmrqOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+nqc6mZ6eK5aq5GxPNPeBo7CsxUbP8LiVH1V2RflNX5ZlYM3RLK9nIxLlfdEPkS4
	 5ZJPVb/8kAeZvgeBlbvATI18jLkVz5esfQm03aYYDBdpOdJqshRnL/8zLy5Yr7d102
	 KQlG18DbsWSzJONRKyNsIl4nov5cCz9eVKfNaHTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 096/457] net: ethtool: keep rtnl_lock for the ioctl self test
Date: Wed, 30 Sep 2026 17:23:21 +0200
Message-ID: <20260930152348.120336420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit 1b82958f3f035df5ccaab5430a2302f08a5d5351 ]

An offline self test that brings the interface down and back up with
netif_close() / netif_open() requires rtnl_lock for both. Since the
ethtool IOCTL path became rtnl-optional for ops-locked drivers, the
ETHTOOL_TEST ioctl runs holding only the netdev instance lock, so on an
ops-locked driver the self test now tears the device down without
rtnl_lock.

With lockdep this reproduces deterministically on every offline self
test on such a driver; note the sole lock held is the instance lock, not
rtnl:

  WARNING: suspicious RCU usage
  net/core/netpoll.c:207 suspicious rcu_dereference_protected() usage!
  1 lock held by ethtool/107:
   #0: (&dev->lock){+.+.}, at: dev_ethtool
  Call Trace:
   netpoll_poll_disable
   __dev_close_many
   netif_close_many
   netif_close
   fbnic_self_test
   dev_ethtool_locked
   dev_ethtool
   dev_ioctl
   sock_ioctl
   __x64_sys_ioctl

Without lockdep the same condition trips ASSERT_RTNL() in
__dev_close_many() / __dev_open(); that check only samples the global
rtnl state, so it can be masked by a concurrent rtnl holder, but the
device is still being reconfigured without the lock it requires.

The ethtool self_test is a legacy ioctl-only command, so an ETHTOOL_TEST
case is only needed on the ioctl path. Add an opt-in bit for drivers whose
self test needs rtnl_lock and set it on the ops-locked drivers whose
offline self test tears the interface down and up:

  - fbnic (ops-locked via queue_mgmt_ops): fbnic_self_test() offline path
    uses netif_close() / netif_open().
  - bnxt (ops-locked via queue_mgmt_ops): bnxt_self_test() offline path
    goes through bnxt_close_nic() / bnxt_half_open_nic() /
    bnxt_half_close_nic() / bnxt_open_nic(), which close and reopen the
    device.

Fixes: f994752b1127 ("net: ethtool: optionally skip rtnl_lock on IOCTL path")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/178942019771.7700.338431553546884773.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 3 ++-
 drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c   | 3 ++-
 include/linux/ethtool.h                           | 2 ++
 net/ethtool/common.h                              | 2 ++
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 62bc9cae613c3..622e89587e5db 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -5733,7 +5733,8 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 	.op_needs_rtnl			= ETHTOOL_OP_NEEDS_RTNL_SCHANNELS |
 					  ETHTOOL_OP_NEEDS_RTNL_SRINGPARAM |
 					  ETHTOOL_OP_NEEDS_RTNL_SCOALESCE |
-					  ETHTOOL_OP_NEEDS_RTNL_RSS,
+					  ETHTOOL_OP_NEEDS_RTNL_RSS |
+					  ETHTOOL_OP_NEEDS_RTNL_TEST,
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
 				     ETHTOOL_COALESCE_USECS_IRQ |
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c b/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c
index 0e47088ec44ba..423f179c9d475 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c
@@ -2025,7 +2025,8 @@ static const struct ethtool_ops fbnic_ethtool_ops = {
 					  ETHTOOL_OP_NEEDS_RTNL_SPAUSEPARAM |
 					  ETHTOOL_OP_NEEDS_RTNL_SCHANNELS |
 					  ETHTOOL_OP_NEEDS_RTNL_SRINGPARAM |
-					  ETHTOOL_OP_NEEDS_RTNL_GLINK,
+					  ETHTOOL_OP_NEEDS_RTNL_GLINK |
+					  ETHTOOL_OP_NEEDS_RTNL_TEST,
 	.get_drvinfo			= fbnic_get_drvinfo,
 	.get_regs_len			= fbnic_get_regs_len,
 	.get_regs			= fbnic_get_regs,
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 12683b5d125e4..97a1adbd9eaee 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -944,6 +944,7 @@ struct kernel_ethtool_ts_info {
 #define ETHTOOL_OP_NEEDS_RTNL_SPAUSEPARAM	BIT(6)
 #define ETHTOOL_OP_NEEDS_RTNL_RSS		BIT(7)
 #define ETHTOOL_OP_NEEDS_RTNL_GLINK		BIT(8)
+#define ETHTOOL_OP_NEEDS_RTNL_TEST		BIT(9)
 
 /**
  * struct ethtool_ops - optional netdev operations
@@ -981,6 +982,7 @@ struct kernel_ethtool_ts_info {
  *	 - netdev_update_features()
  *	 - netif_set_real_num_tx_queues()
  *	 - ethtool_op_get_link() (syncs link watch under rtnl_lock)
+ *	 - netif_open() / netif_close() (used by @self_test)
  *
  * @get_drvinfo: Report driver/device information. Modern drivers no
  *	longer have to implement this callback. Most fields are
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 4e5356e26f400..ae32e7fdb563c 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -163,6 +163,8 @@ ethtool_ioctl_needs_rtnl(const struct net_device *dev, u32 ethcmd)
 		return ops->op_needs_rtnl & ETHTOOL_OP_NEEDS_RTNL_RSS;
 	case ETHTOOL_GLINK:
 		return ops->op_needs_rtnl & ETHTOOL_OP_NEEDS_RTNL_GLINK;
+	case ETHTOOL_TEST:
+		return ops->op_needs_rtnl & ETHTOOL_OP_NEEDS_RTNL_TEST;
 	}
 	return false;
 }
-- 
2.53.0



