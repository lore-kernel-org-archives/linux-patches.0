Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7309F7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812E1C433C1;
	Wed,  2 Nov 2022 02:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357484;
	bh=rLfYED5AZ5jf+AUKF9eta3uIgPVw9S9AyD/G4WnU2AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxJWiVtzYJ8jgtbYhqHeleZeu3q99Z2n3yTcQvm8xpu4v6WwVJ6dA5U5CrhmNg1qM
	 k4dtMDUJyOPP8ovlv8QaBDzcErTCz8UU5AnmhomtNAziWDXHSuQexcaSKCC1GlYZqf
	 3vO5dBqqrY5aiLQKGc/tYetvMhksKygdaX8GRZKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 177/240] amd-xgbe: Yellow carp devices do not need rrc
Date: Wed,  2 Nov 2022 03:32:32 +0100
Message-Id: <20221102022115.390442286@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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

[ Upstream commit f97fc7ef414603189d5ba6f529407c5341c03c2a ]

Link stability issues are noticed on Yellow carp platforms when Receiver
Reset Cycle is issued. Since the CDR workaround is disabled on these
platforms, the Receiver Reset Cycle is not needed.

So, avoid issuing rrc on Yellow carp platforms.

Fixes: dbb6c58b5a61 ("net: amd-xgbe: Add Support for Yellow Carp Ethernet device")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c    | 5 +++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 2 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h        | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 2af3da4b2d05..f409d7bd1f1e 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -285,6 +285,9 @@ static int xgbe_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 		/* Yellow Carp devices do not need cdr workaround */
 		pdata->vdata->an_cdr_workaround = 0;
+
+		/* Yellow Carp devices do not need rrc */
+		pdata->vdata->enable_rrc = 0;
 	} else {
 		pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
 		pdata->xpcs_window_sel_reg = PCS_V2_WINDOW_SELECT;
@@ -483,6 +486,7 @@ static struct xgbe_version_data xgbe_v2a = {
 	.tx_desc_prefetch		= 5,
 	.rx_desc_prefetch		= 5,
 	.an_cdr_workaround		= 1,
+	.enable_rrc			= 1,
 };
 
 static struct xgbe_version_data xgbe_v2b = {
@@ -498,6 +502,7 @@ static struct xgbe_version_data xgbe_v2b = {
 	.tx_desc_prefetch		= 5,
 	.rx_desc_prefetch		= 5,
 	.an_cdr_workaround		= 1,
+	.enable_rrc			= 1,
 };
 
 static const struct pci_device_id xgbe_pci_table[] = {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 2156600641b6..19b943eba560 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2640,7 +2640,7 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 	}
 
 	/* No link, attempt a receiver reset cycle */
-	if (phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
+	if (pdata->vdata->enable_rrc && phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
 		phy_data->rrc_count = 0;
 		xgbe_phy_rrc(pdata);
 	}
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index b875c430222e..49d23abce73d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -1013,6 +1013,7 @@ struct xgbe_version_data {
 	unsigned int tx_desc_prefetch;
 	unsigned int rx_desc_prefetch;
 	unsigned int an_cdr_workaround;
+	unsigned int enable_rrc;
 };
 
 struct xgbe_prv_data {
-- 
2.35.1



