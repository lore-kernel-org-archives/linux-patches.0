Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371181FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91197C433EF;
	Fri,  3 Feb 2023 10:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419336;
	bh=p/tGzGjicmqwdqUVLNUDEIOVQpajKwrYAts6gMSMAm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2Y2UujOPSbHPA7VqykD4bH9pz9jOFxNArRUs94OVs1uJW+BsyoYtO0Cx89MisZWM
	 ReNZDqLwxgfAHgaFY+aAqEhtxTgHnrMNrfW2hjPhRw3XFDfjJ5K6Zn7d1cCLPC9uzn
	 hhFvmESaVLxxDQT1jbCRbbbiDMMHUJsz73iEzllE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajith Nayak <Ajith.Nayak@amd.com>,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/62] amd-xgbe: TX Flow Ctrl Registers are h/w ver dependent
Date: Fri,  3 Feb 2023 11:12:04 +0100
Message-Id: <20230203101013.350380105@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 579923d84b04abb6cd4cd1fd9974096a2dd1832b ]

There is difference in the TX Flow Control registers (TFCR) between the
revisions of the hardware. The older revisions of hardware used to have
single register per queue. Whereas, the newer revision of hardware (from
ver 30H onwards) have one register per priority.

Update the driver to use the TFCR based on the reported version of the
hardware.

Fixes: c5aa9e3b8156 ("amd-xgbe: Initial AMD 10GbE platform driver")
Co-developed-by: Ajith Nayak <Ajith.Nayak@amd.com>
Signed-off-by: Ajith Nayak <Ajith.Nayak@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index 1e4bb33925e6..39d4df40700f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -523,19 +523,28 @@ static void xgbe_disable_vxlan(struct xgbe_prv_data *pdata)
 	netif_dbg(pdata, drv, pdata->netdev, "VXLAN acceleration disabled\n");
 }
 
+static unsigned int xgbe_get_fc_queue_count(struct xgbe_prv_data *pdata)
+{
+	unsigned int max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
+
+	/* From MAC ver 30H the TFCR is per priority, instead of per queue */
+	if (XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER) >= 0x30)
+		return max_q_count;
+	else
+		return min_t(unsigned int, pdata->tx_q_count, max_q_count);
+}
+
 static int xgbe_disable_tx_flow_control(struct xgbe_prv_data *pdata)
 {
-	unsigned int max_q_count, q_count;
 	unsigned int reg, reg_val;
-	unsigned int i;
+	unsigned int i, q_count;
 
 	/* Clear MTL flow control */
 	for (i = 0; i < pdata->rx_q_count; i++)
 		XGMAC_MTL_IOWRITE_BITS(pdata, i, MTL_Q_RQOMR, EHFC, 0);
 
 	/* Clear MAC flow control */
-	max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
-	q_count = min_t(unsigned int, pdata->tx_q_count, max_q_count);
+	q_count = xgbe_get_fc_queue_count(pdata);
 	reg = MAC_Q0TFCR;
 	for (i = 0; i < q_count; i++) {
 		reg_val = XGMAC_IOREAD(pdata, reg);
@@ -552,9 +561,8 @@ static int xgbe_enable_tx_flow_control(struct xgbe_prv_data *pdata)
 {
 	struct ieee_pfc *pfc = pdata->pfc;
 	struct ieee_ets *ets = pdata->ets;
-	unsigned int max_q_count, q_count;
 	unsigned int reg, reg_val;
-	unsigned int i;
+	unsigned int i, q_count;
 
 	/* Set MTL flow control */
 	for (i = 0; i < pdata->rx_q_count; i++) {
@@ -578,8 +586,7 @@ static int xgbe_enable_tx_flow_control(struct xgbe_prv_data *pdata)
 	}
 
 	/* Set MAC flow control */
-	max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
-	q_count = min_t(unsigned int, pdata->tx_q_count, max_q_count);
+	q_count = xgbe_get_fc_queue_count(pdata);
 	reg = MAC_Q0TFCR;
 	for (i = 0; i < q_count; i++) {
 		reg_val = XGMAC_IOREAD(pdata, reg);
-- 
2.39.0



