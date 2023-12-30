Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5879879DE;
	Sat, 30 Dec 2023 12:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1RHz0ZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A696C433C8;
	Sat, 30 Dec 2023 12:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938159;
	bh=KgoZ0KlYHaNzC02IX3CUEXCi6J5rfPaoI+1AlPCfwbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1RHz0ZMz/+rwGjI2aRI67eG7rto8IuzEU+MvZytQhXIkp+VsaPKxDqCkYt6At1zK
	 FepiKFnMqzU1Q8I6NJdJpVMx2TGAqISSp8HrerUmWhJxNn/f3p9VWaWFPPQeBD40YJ
	 O5YFS4mwh5llVibSsg82Oc+V4nTXEhSFirxZptWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/112] octeontx2-pf: Fix graceful exit during PFC configuration failure
Date: Sat, 30 Dec 2023 11:58:59 +0000
Message-ID: <20231230115807.597832336@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 8c97ab5448f2096daba11edf8d18a44e1eb6f31d ]

During PFC configuration failure the code was not handling a graceful
exit. This patch fixes the same and add proper code for a graceful exit.

Fixes: 99c969a83d82 ("octeontx2-pf: Add egress PFC support")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_dcbnl.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
index bfddbff7bcdfb..28fb643d2917f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
@@ -399,9 +399,10 @@ static int otx2_dcbnl_ieee_getpfc(struct net_device *dev, struct ieee_pfc *pfc)
 static int otx2_dcbnl_ieee_setpfc(struct net_device *dev, struct ieee_pfc *pfc)
 {
 	struct otx2_nic *pfvf = netdev_priv(dev);
+	u8 old_pfc_en;
 	int err;
 
-	/* Save PFC configuration to interface */
+	old_pfc_en = pfvf->pfc_en;
 	pfvf->pfc_en = pfc->pfc_en;
 
 	if (pfvf->hw.tx_queues >= NIX_PF_PFC_PRIO_MAX)
@@ -411,13 +412,17 @@ static int otx2_dcbnl_ieee_setpfc(struct net_device *dev, struct ieee_pfc *pfc)
 	 * supported by the tx queue configuration
 	 */
 	err = otx2_check_pfc_config(pfvf);
-	if (err)
+	if (err) {
+		pfvf->pfc_en = old_pfc_en;
 		return err;
+	}
 
 process_pfc:
 	err = otx2_config_priority_flow_ctrl(pfvf);
-	if (err)
+	if (err) {
+		pfvf->pfc_en = old_pfc_en;
 		return err;
+	}
 
 	/* Request Per channel Bpids */
 	if (pfc->pfc_en)
@@ -425,6 +430,12 @@ static int otx2_dcbnl_ieee_setpfc(struct net_device *dev, struct ieee_pfc *pfc)
 
 	err = otx2_pfc_txschq_update(pfvf);
 	if (err) {
+		if (pfc->pfc_en)
+			otx2_nix_config_bp(pfvf, false);
+
+		otx2_pfc_txschq_stop(pfvf);
+		pfvf->pfc_en = old_pfc_en;
+		otx2_config_priority_flow_ctrl(pfvf);
 		dev_err(pfvf->dev, "%s failed to update TX schedulers\n", __func__);
 		return err;
 	}
-- 
2.43.0



