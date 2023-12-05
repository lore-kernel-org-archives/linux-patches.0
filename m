Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F156AC2;
	Tue,  5 Dec 2023 03:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCtLGKCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD45C433C7;
	Tue,  5 Dec 2023 03:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747805;
	bh=2RIc/wPlmDifUl+IH/xvChhpLQBTxNANNu5Nugj0aOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCtLGKCdcPJA8a6SdvVHysG++dKnuzwSHh4eCfBQTjsfJ9TtnIjF78f5D8Ftc4Lwc
	 gvVvigtlhtWWFCd52lotuvRcc5/rDHBLa4rQtU/PrDIGCvBVqSrTqAj9w18I+Gd3iV
	 VUnCFDKSyTjFOSX8I/TV6lbk80x6ivbYK6qL0nQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 66/67] r8169: disable ASPM in case of tx timeout
Date: Tue,  5 Dec 2023 12:17:51 +0900
Message-ID: <20231205031523.690149197@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 80c0576ef179311f624bc450fede30a89afe9792 ]

There are still single reports of systems where ASPM incompatibilities
cause tx timeouts. It's not clear whom to blame, so let's disable
ASPM in case of a tx timeout.

v2:
- add one-time warning for informing the user

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/92369a92-dc32-4529-0509-11459ba0e391@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 59d395ed606d ("r8169: fix deadlock on RTL8125 in jumbo mtu mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 84fb739679298..c640896f7b7e2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -588,6 +588,7 @@ struct rtl8169_tc_offsets {
 enum rtl_flag {
 	RTL_FLAG_TASK_ENABLED = 0,
 	RTL_FLAG_TASK_RESET_PENDING,
+	RTL_FLAG_TASK_TX_TIMEOUT,
 	RTL_FLAG_MAX
 };
 
@@ -4029,7 +4030,7 @@ static void rtl8169_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-	rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
+	rtl_schedule_task(tp, RTL_FLAG_TASK_TX_TIMEOUT);
 }
 
 static int rtl8169_tx_map(struct rtl8169_private *tp, const u32 *opts, u32 len,
@@ -4624,6 +4625,7 @@ static void rtl_task(struct work_struct *work)
 {
 	struct rtl8169_private *tp =
 		container_of(work, struct rtl8169_private, wk.work);
+	int ret;
 
 	rtnl_lock();
 
@@ -4631,7 +4633,17 @@ static void rtl_task(struct work_struct *work)
 	    !test_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags))
 		goto out_unlock;
 
+	if (test_and_clear_bit(RTL_FLAG_TASK_TX_TIMEOUT, tp->wk.flags)) {
+		/* ASPM compatibility issues are a typical reason for tx timeouts */
+		ret = pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_L1 |
+							  PCIE_LINK_STATE_L0S);
+		if (!ret)
+			netdev_warn_once(tp->dev, "ASPM disabled on Tx timeout\n");
+		goto reset;
+	}
+
 	if (test_and_clear_bit(RTL_FLAG_TASK_RESET_PENDING, tp->wk.flags)) {
+reset:
 		rtl_reset_work(tp);
 		netif_wake_queue(tp->dev);
 	}
-- 
2.42.0



