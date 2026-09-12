Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D9A455162;
	Sat, 12 Sep 2026 11:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212143; cv=none; b=KEGyBtNBm/G1PJlvjrLi3fuuYrdtXSm30Qpcjh+QhSVCeCrIN4LRvRbH4zbuR6myoDs3b/ajPBIelDS7/5OA2eYiriIRnF40SQf/EHxM1JhFvUPL9Onn/9018EYYO5erZsNifQQ0XDBkUHdxJ4Vw+KdyBhImUqYhWxHHLNAFNtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212143; c=relaxed/simple;
	bh=k/MZQNUowVhGZlEBMsh4gsX6IAbMkvzlJt7rS0o0uhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGLWClnT2zwsb1g5eXoN6CKHbbqUaSLet/9LrZAZdaXfvyO43g2TzH0TMXio+DkZ8dAVeYcKeB3+bz0w53od3iZCFqBFpU7zaFbq+yyShKnymaUd+fYkYlTHDo0BWvf+iXaS49UvhSAU6SRQ1KOLsFjUDBN4Sgzy4AbDS26eqtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Qav5j7p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Qav5j7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AF11F000FF;
	Sat, 12 Sep 2026 11:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212142;
	bh=1z16/MMla4leU4X8kcOgGz6xnVEXh8NWWGMfHIdXBEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Qav5j7p9nmEdvQhCpv9FZCo1jZKiZ/lPjBP92D4S9bmVP743qpbqB9Ebyos6Tnug
	 hvWijL1c9ev90M79LfaAWTflhv7Epu4Ei/jb2aFe7T9LF6t0X12exgkc4TtYG+5HAX
	 JceVSEmPmzXIbeIdcV36BRKQhyDn6RoVq0RLtZ6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1374/1518] net: wangxun: replace busy-wait reset flag with kernel mutex
Date: Sat, 12 Sep 2026 08:59:03 +0200
Message-ID: <20260912065654.625821890@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit d48df7e7c3fb456d2dc907707a124dab8462eb19 ]

Replace the busy-wait loop using test_and_set_bit(WX_STATE_RESETTING)
with a proper per-device mutex to serialize reset operations.

The reset flag is reserved for other code paths (like watchdog), which
need tocheck if a reset is in process.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20260407025616.33652-5-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7bf29145d7a9 ("net: txgbe: fix MISC interrupt unmasking in non-MSI-X mode and device shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c       |  1 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h     | 16 +---------------
 .../net/ethernet/wangxun/libwx/wx_vf_common.c    |  6 ++++--
 drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c |  6 +++---
 .../net/ethernet/wangxun/txgbe/txgbe_ethtool.c   |  6 +++---
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c  | 10 +++-------
 6 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 51c36cde13c1c..a696d30673346 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -2508,6 +2508,7 @@ int wx_sw_init(struct wx *wx)
 		return -ENOMEM;
 	}
 
+	mutex_init(&wx->reset_lock);
 	bitmap_zero(wx->state, WX_STATE_NBITS);
 	bitmap_zero(wx->flags, WX_PF_FLAGS_NBITS);
 	wx->misc_irq_domain = false;
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index f4dcdf1474587..0e46f29a0a75d 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -1394,6 +1394,7 @@ struct wx {
 
 	struct timer_list service_timer;
 	struct work_struct service_task;
+	struct mutex reset_lock; /* mutex for reset */
 };
 
 #define WX_INTR_ALL (~0ULL)
@@ -1472,21 +1473,6 @@ static inline struct wx *phylink_to_wx(struct phylink_config *config)
 	return container_of(config, struct wx, phylink_config);
 }
 
-static inline int wx_set_state_reset(struct wx *wx)
-{
-	u8 timeout = 50;
-
-	while (test_and_set_bit(WX_STATE_RESETTING, wx->state)) {
-		timeout--;
-		if (!timeout)
-			return -EBUSY;
-
-		usleep_range(1000, 2000);
-	}
-
-	return 0;
-}
-
 static inline unsigned int wx_rx_pg_order(struct wx_ring *ring)
 {
 #if (PAGE_SIZE < 8192)
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c b/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
index 5478f2fdfce88..bf3424ec43d9b 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
@@ -339,14 +339,16 @@ static void wxvf_down(struct wx *wx)
 
 static void wxvf_reinit_locked(struct wx *wx)
 {
-	while (test_and_set_bit(WX_STATE_RESETTING, wx->state))
-		usleep_range(1000, 2000);
+	mutex_lock(&wx->reset_lock);
+	set_bit(WX_STATE_RESETTING, wx->state);
+
 	wxvf_down(wx);
 	wx_free_irq(wx);
 	wx_configure_vf(wx);
 	wx_request_msix_irqs_vf(wx);
 	wxvf_up_complete(wx);
 	clear_bit(WX_STATE_RESETTING, wx->state);
+	mutex_unlock(&wx->reset_lock);
 }
 
 static void wxvf_reset_subtask(struct wx *wx)
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
index 662f28bdde8a4..646977521d39a 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
@@ -64,9 +64,8 @@ static int ngbe_set_ringparam(struct net_device *netdev,
 	    new_rx_count == wx->rx_ring_count)
 		return 0;
 
-	err = wx_set_state_reset(wx);
-	if (err)
-		return err;
+	mutex_lock(&wx->reset_lock);
+	set_bit(WX_STATE_RESETTING, wx->state);
 
 	if (!netif_running(wx->netdev)) {
 		for (i = 0; i < wx->num_tx_queues; i++)
@@ -97,6 +96,7 @@ static int ngbe_set_ringparam(struct net_device *netdev,
 
 clear_reset:
 	clear_bit(WX_STATE_RESETTING, wx->state);
+	mutex_unlock(&wx->reset_lock);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
index d7f9053594588..659006b4b8282 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
@@ -58,9 +58,8 @@ static int txgbe_set_ringparam(struct net_device *netdev,
 	    new_rx_count == wx->rx_ring_count)
 		return 0;
 
-	err = wx_set_state_reset(wx);
-	if (err)
-		return err;
+	mutex_lock(&wx->reset_lock);
+	set_bit(WX_STATE_RESETTING, wx->state);
 
 	if (!netif_running(wx->netdev)) {
 		for (i = 0; i < wx->num_tx_queues; i++)
@@ -90,6 +89,7 @@ static int txgbe_set_ringparam(struct net_device *netdev,
 
 clear_reset:
 	clear_bit(WX_STATE_RESETTING, wx->state);
+	mutex_unlock(&wx->reset_lock);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 57e0904f6887c..55c2b53e92b68 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -602,20 +602,16 @@ int txgbe_setup_tc(struct net_device *dev, u8 tc)
 
 static void txgbe_reinit_locked(struct wx *wx)
 {
-	int err = 0;
-
 	netif_trans_update(wx->netdev);
 
-	err = wx_set_state_reset(wx);
-	if (err) {
-		wx_err(wx, "wait device reset timeout\n");
-		return;
-	}
+	mutex_lock(&wx->reset_lock);
+	set_bit(WX_STATE_RESETTING, wx->state);
 
 	txgbe_down(wx);
 	txgbe_up(wx);
 
 	clear_bit(WX_STATE_RESETTING, wx->state);
+	mutex_unlock(&wx->reset_lock);
 }
 
 void txgbe_do_reset(struct net_device *netdev)
-- 
2.53.0



