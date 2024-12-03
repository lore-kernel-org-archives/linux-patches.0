Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941FE1F76BF;
	Tue,  3 Dec 2024 16:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241946; cv=none; b=UT9xyUWNljlQQoPDDWVP4pF2kH2/DgSIwqGU3CLGABEKb4et0xNSyfgsQvrSCH7fu8KmovZJXhgQUhvNa6NQtRfHvBKEl1SWp5afvhDEBBlHWSGzcuZJT98QrbYe/Zz2QdX6AI6uVDCaPU3zbcj8h21iYCkhL+jw8kVUhXIjsN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241946; c=relaxed/simple;
	bh=k26xzvTTsUz5QLRZok2KG4MZyzrYBz0EtthK0sgQJpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Th4SIjzEZ8q1VFtBuov2kAR5FFFNdZmcwQxM8V95OVKWGuTtYdqiT32mdhNe/ZIuilUi895bqAgbLlkB/oyCPcwGxSWLcX9KDYQH7MsOOvgZeGHb9iqML7GkwCm1rX//hFCSyMFF4rRAxP9/vKEJZwY3+noZY3+bOFOHSNRwItU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ee1QGkP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ee1QGkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EEAC4CECF;
	Tue,  3 Dec 2024 16:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241946;
	bh=k26xzvTTsUz5QLRZok2KG4MZyzrYBz0EtthK0sgQJpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ee1QGkPIab8EX3AyDj0PrjLllbFwp5dLlryqv6Ayg641Ws68aHuvY8Pyd+L/ebIU
	 Ln+awB9NN8Sq0zuTfOtIinI1IEzpeua1+fR9hM2BNQSFmnYoO4oGo23fPqbJdpL7in
	 EKNa/H5Fnz2HdCB6BoBTssk1DTkS/txCg5lbzycw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 563/826] rtase: Refactor the rtase_check_mac_version_valid() function
Date: Tue,  3 Dec 2024 15:44:50 +0100
Message-ID: <20241203144805.706531417@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Lai <justinlai0215@realtek.com>

[ Upstream commit a1f8609ff1f658e410f78d800ca947d57e51996a ]

Different hardware requires different configurations, but this distinction
was not made previously. Additionally, the error message was not clear
enough. Therefore, this patch will address the issues mentioned above.

Fixes: a36e9f5cfe9e ("rtase: Add support for a pci table in this module")
Signed-off-by: Justin Lai <justinlai0215@realtek.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/rtase/rtase.h    |  7 ++++-
 .../net/ethernet/realtek/rtase/rtase_main.c   | 28 +++++++++++--------
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase.h b/drivers/net/ethernet/realtek/rtase/rtase.h
index 583c33930f886..4a4434869b10a 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase.h
+++ b/drivers/net/ethernet/realtek/rtase/rtase.h
@@ -9,7 +9,10 @@
 #ifndef RTASE_H
 #define RTASE_H
 
-#define RTASE_HW_VER_MASK 0x7C800000
+#define RTASE_HW_VER_MASK     0x7C800000
+#define RTASE_HW_VER_906X_7XA 0x00800000
+#define RTASE_HW_VER_906X_7XC 0x04000000
+#define RTASE_HW_VER_907XD_V1 0x04800000
 
 #define RTASE_RX_DMA_BURST_256       4
 #define RTASE_TX_DMA_BURST_UNLIMITED 7
@@ -327,6 +330,8 @@ struct rtase_private {
 	u16 int_nums;
 	u16 tx_int_mit;
 	u16 rx_int_mit;
+
+	u32 hw_ver;
 };
 
 #define RTASE_LSO_64K 64000
diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index f8777b7663d35..c2999e24904d1 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -1972,20 +1972,21 @@ static void rtase_init_software_variable(struct pci_dev *pdev,
 	tp->dev->max_mtu = RTASE_MAX_JUMBO_SIZE;
 }
 
-static bool rtase_check_mac_version_valid(struct rtase_private *tp)
+static int rtase_check_mac_version_valid(struct rtase_private *tp)
 {
-	u32 hw_ver = rtase_r32(tp, RTASE_TX_CONFIG_0) & RTASE_HW_VER_MASK;
-	bool known_ver = false;
+	int ret = -ENODEV;
 
-	switch (hw_ver) {
-	case 0x00800000:
-	case 0x04000000:
-	case 0x04800000:
-		known_ver = true;
+	tp->hw_ver = rtase_r32(tp, RTASE_TX_CONFIG_0) & RTASE_HW_VER_MASK;
+
+	switch (tp->hw_ver) {
+	case RTASE_HW_VER_906X_7XA:
+	case RTASE_HW_VER_906X_7XC:
+	case RTASE_HW_VER_907XD_V1:
+		ret = 0;
 		break;
 	}
 
-	return known_ver;
+	return ret;
 }
 
 static int rtase_init_board(struct pci_dev *pdev, struct net_device **dev_out,
@@ -2105,9 +2106,12 @@ static int rtase_init_one(struct pci_dev *pdev,
 	tp->pdev = pdev;
 
 	/* identify chip attached to board */
-	if (!rtase_check_mac_version_valid(tp))
-		return dev_err_probe(&pdev->dev, -ENODEV,
-				     "unknown chip version, contact rtase maintainers (see MAINTAINERS file)\n");
+	ret = rtase_check_mac_version_valid(tp);
+	if (ret != 0) {
+		dev_err(&pdev->dev,
+			"unknown chip version: 0x%08x, contact rtase maintainers (see MAINTAINERS file)\n",
+			tp->hw_ver);
+	}
 
 	rtase_init_software_variable(pdev, tp);
 	rtase_init_hardware(tp);
-- 
2.43.0



