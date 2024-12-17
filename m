Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0821140E38;
	Tue, 17 Dec 2024 17:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456199; cv=none; b=aTGo9ZDaEDdPE8YbUaD/0eiANbdQneL6QL7o9Tt4Ieuf/PcBnZNMwF397dduvLZVolQ0C5YlFo1G/oqEejKxaPCtGFp/UWOYYgPGsmG6iXh/aHiBhToyaKd/ePy0v84SVnz0V5aG50RFqPF9Y0caXQ5I/2jKKVZdwWRns0WzVwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456199; c=relaxed/simple;
	bh=aJDrVryTonbKKRowdZt3r785ehrpR1NLhZz9ygbYFM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOVIR35bGE1PuvSpcmwDpWlyvEuJda2KsCviGiapfsJtfu7Wy9YllYwR0wccaed1QEvHSfGRy9fW9cPT6/GLblIi8BEdSRKka1kv0j57Jw9FvwByE99FWCd5IbmYY9O+Pmq+dRCjGrLCvecvKS5jjHJ+vMCv01/fXL5ccKVwZW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0w5NBNxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0w5NBNxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F09C4CED3;
	Tue, 17 Dec 2024 17:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456199;
	bh=aJDrVryTonbKKRowdZt3r785ehrpR1NLhZz9ygbYFM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0w5NBNxMgrBsXlsqkSN9ZV+aczi/5jCRDUQGORGsMBzhFfEfWOmNNlyR7/Z+HrF+e
	 zuXf9KVQ1JxAB28xQWl3OcUYPDNyCh84eIn0gQ9Z9pcW2eLx+HypllW4PZ/8cCtvLG
	 V5vdp3e38zeXfMp0+1967xgMKs+gH9+eW1y516w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/109] net: renesas: rswitch: fix initial MPIC register setting
Date: Tue, 17 Dec 2024 18:08:15 +0100
Message-ID: <20241217170537.183918933@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

[ Upstream commit fb9e6039c325cc205a368046dc03c56c87df2310 ]

MPIC.PIS must be set per phy interface type.
MPIC.LSC must be set per speed.

Do that strictly per datasheet, instead of hardcoding MPIC.PIS to GMII.

Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20241211053012.368914-1-nikita.yoush@cogentembedded.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 27 ++++++++++++++++++++------
 drivers/net/ethernet/renesas/rswitch.h | 14 ++++++-------
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 4dd218b6f308..3665258cec31 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1047,25 +1047,40 @@ static int rswitch_etha_wait_link_verification(struct rswitch_etha *etha)
 
 static void rswitch_rmac_setting(struct rswitch_etha *etha, const u8 *mac)
 {
-	u32 val;
+	u32 pis, lsc;
 
 	rswitch_etha_write_mac_address(etha, mac);
 
+	switch (etha->phy_interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+		pis = MPIC_PIS_GMII;
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+	case PHY_INTERFACE_MODE_5GBASER:
+		pis = MPIC_PIS_XGMII;
+		break;
+	default:
+		pis = FIELD_GET(MPIC_PIS, ioread32(etha->addr + MPIC));
+		break;
+	}
+
 	switch (etha->speed) {
 	case 100:
-		val = MPIC_LSC_100M;
+		lsc = MPIC_LSC_100M;
 		break;
 	case 1000:
-		val = MPIC_LSC_1G;
+		lsc = MPIC_LSC_1G;
 		break;
 	case 2500:
-		val = MPIC_LSC_2_5G;
+		lsc = MPIC_LSC_2_5G;
 		break;
 	default:
-		return;
+		lsc = FIELD_GET(MPIC_LSC, ioread32(etha->addr + MPIC));
+		break;
 	}
 
-	iowrite32(MPIC_PIS_GMII | val, etha->addr + MPIC);
+	rswitch_modify(etha->addr, MPIC, MPIC_PIS | MPIC_LSC,
+		       FIELD_PREP(MPIC_PIS, pis) | FIELD_PREP(MPIC_LSC, lsc));
 }
 
 static void rswitch_etha_enable_mii(struct rswitch_etha *etha)
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 327873b637d7..f2d1cd47187d 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -723,13 +723,13 @@ enum rswitch_etha_mode {
 
 #define EAVCC_VEM_SC_TAG	(0x3 << 16)
 
-#define MPIC_PIS_MII		0x00
-#define MPIC_PIS_GMII		0x02
-#define MPIC_PIS_XGMII		0x04
-#define MPIC_LSC_SHIFT		3
-#define MPIC_LSC_100M		(1 << MPIC_LSC_SHIFT)
-#define MPIC_LSC_1G		(2 << MPIC_LSC_SHIFT)
-#define MPIC_LSC_2_5G		(3 << MPIC_LSC_SHIFT)
+#define MPIC_PIS		GENMASK(2, 0)
+#define MPIC_PIS_GMII		2
+#define MPIC_PIS_XGMII		4
+#define MPIC_LSC		GENMASK(5, 3)
+#define MPIC_LSC_100M		1
+#define MPIC_LSC_1G		2
+#define MPIC_LSC_2_5G		3
 
 #define MDIO_READ_C45		0x03
 #define MDIO_WRITE_C45		0x01
-- 
2.39.5



