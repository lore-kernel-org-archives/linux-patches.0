Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92866547059;
	Thu, 17 Sep 2026 17:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667430; cv=none; b=jzU9Q5pibx3fFNQ0obC3NrMZGJPqaR9YqwLwTbkHoteyAOmkhHndS5FTdsUuJ8TcZixNk7iKL2WleQv4VyfD1GYK/Qm5fpFG2ktJ8CnfmBsd7Z/MjbTPw4B/egMjAMsaKFC14vGAMBiw8LvxOv347pQ3F+vxSbEXumpnmBu2KUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667430; c=relaxed/simple;
	bh=kNLN5EED3cNj8peMKJ71gf4ZOJfn4xObKz9y18uPrwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GghDJP95asyEVOsve1/i22dTWQplUxdvKbn6odFVVFZtpom5iBquQyfZ38vFuTux6Rb0d5bIjJKa8JWPtQ9WC0lF62zi8flAx1Ku/X7Pr2sKsjufO68pTznvOkqI1eyhBCzbN93Vo2s/e5xnudOXnv3uUtm9zEr8qsfU+9xabPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egjGhiE5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egjGhiE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ACB1F000FF;
	Thu, 17 Sep 2026 17:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667429;
	bh=ydIJ28OqSmdTvHFI0mpAvH7lVpYOLF55LGCXO3kyceY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egjGhiE5Yi5vf9HmyUIwmDI0ibLABDCpfTyF5bojF7rX1FWPxgCHdHaoWLGjkivxe
	 oK/9MI9rX92uyoss781+NTQAFnJmuat/FWh4Pn9n3qc9lcreSo6SKS3j4U3a27Fo3k
	 i8PyETtOuX5QUdZhyxFIHnlQFwAzvqG93ySJZw0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0052/1102] rtase: Fix flow control configuration
Date: Thu, 17 Sep 2026 15:59:55 +0100
Message-ID: <20260917151540.756075377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Lai <justinlai0215@realtek.com>

[ Upstream commit fea3521e043fa1388ec909205687db7d4b0c57ec ]

The hardware has two sets of registers controlling TX/RX flow control.
The effective flow control state is determined by the logical OR of
these two sets of bits.

RTASE_FORCE_TXFLOW_EN and RTASE_FORCE_RXFLOW_EN in RTASE_CPLUS_CMD are
the bits used by the driver to control TX/RX flow control according to
the ethtool pause configuration.

RTASE_TXFLOW_EN and RTASE_RXFLOW_EN in RTASE_GPHY_STD_00 are another
set of TX/RX flow control enable bits. Clear them by default so they do
not keep flow control enabled independently of the driver setting.

With the RTASE_GPHY_STD_00 bits cleared, the effective flow control
state is controlled through RTASE_CPLUS_CMD, so the ethtool setting can
take effect correctly.

Signed-off-by: Justin Lai <justinlai0215@realtek.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260505064121.31286-1-justinlai0215@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/rtase/rtase.h      | 4 ++++
 drivers/net/ethernet/realtek/rtase/rtase_main.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase.h b/drivers/net/ethernet/realtek/rtase/rtase.h
index 669c12e473fd0..92c2ccb31d5eb 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase.h
+++ b/drivers/net/ethernet/realtek/rtase/rtase.h
@@ -152,6 +152,10 @@ enum rtase_registers {
 #define RTASE_FORCE_TXFLOW_EN BIT(10)
 #define RTASE_RX_CHKSUM       BIT(5)
 
+	RTASE_GPHY_STD_00 = 0x6024,
+#define RTASE_RXFLOW_EN BIT(7)
+#define RTASE_TXFLOW_EN BIT(6)
+
 	RTASE_Q0_RX_DESC_ADDR0 = 0x00E4,
 	RTASE_Q0_RX_DESC_ADDR4 = 0x00E8,
 	RTASE_Q1_RX_DESC_ADDR0 = 0x4000,
diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index afae19cc99314..0d98be1eeb788 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -970,6 +970,9 @@ static void rtase_hw_config(struct net_device *dev)
 	rtase_hw_set_features(dev, dev->features);
 
 	/* enable flow control */
+	reg_data16 = rtase_r16(tp, RTASE_GPHY_STD_00);
+	reg_data16 &= ~(RTASE_TXFLOW_EN | RTASE_RXFLOW_EN);
+	rtase_w16(tp, RTASE_GPHY_STD_00, reg_data16);
 	reg_data16 = rtase_r16(tp, RTASE_CPLUS_CMD);
 	reg_data16 |= (RTASE_FORCE_TXFLOW_EN | RTASE_FORCE_RXFLOW_EN);
 	rtase_w16(tp, RTASE_CPLUS_CMD, reg_data16);
-- 
2.53.0



