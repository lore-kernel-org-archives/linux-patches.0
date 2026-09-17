Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21A44ABBAC;
	Thu, 17 Sep 2026 16:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661078; cv=none; b=uthaI3CWlHoXpF2OeqlrQRZ3AV55+MSSKt0/brGJC6DqnY+GuOPLZ3ZfYlIWXjDBziqH8FN/yKk2Amj87AemniUI3xAFcRHw44MRMbrkCAvUpHC9ICv9PwbJ2tfG9bFGjYgOin/tTt4Pihr6n3qLVZ7hsla09zEdDLUOVKXecC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661078; c=relaxed/simple;
	bh=huxL8nIfjqeLd/u5DWcE/wPpgznjh1fB1XVu9DVYDjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BP3KpWHsGjGXXR1ViMGQraLHaM0ufcURwOGQf1PWMhFX34VrfoXc1Jb9X+H5Xc1j4us9yZ0YdGdzh3PEdgMwxazTii2Mzw7Ojz/dI+3pYBJhTDjJU2Us8SsvVz4g6BFoewvDBmUnW8t6B7WwxCFE9rAnmz9ziwyCJKmm/RINfgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDfhnko3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDfhnko3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AEF1F000FF;
	Thu, 17 Sep 2026 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661077;
	bh=+rfJsoY3oRRdD/NOAztkmWWSe726NIcOqcCYMPcKjUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDfhnko3hf8DVX3doIow4hNMmqDeJwawPTadJhufCj068J9nSjNYdyMA5Fmq9TgGz
	 cUf9LppgG4IfmpCrEuDdXmjhIeaCBYM44URUwaP6lfIPozOVwy3ddsnZCh/hfAGErR
	 qyL4r5QAR+5ODrUTAf2uksTzX6VULttDsy2qqyr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0073/1250] rtase: Fix flow control configuration
Date: Thu, 17 Sep 2026 15:57:48 +0100
Message-ID: <20260917151553.927699413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 43087b17a0ff2..03b12d83f6e9d 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase.h
+++ b/drivers/net/ethernet/realtek/rtase/rtase.h
@@ -153,6 +153,10 @@ enum rtase_registers {
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
index bc9b14614f7a7..e3cd4f7c13804 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -977,6 +977,9 @@ static void rtase_hw_config(struct net_device *dev)
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



