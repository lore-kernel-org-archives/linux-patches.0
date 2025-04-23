Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D6427055F;
	Wed, 23 Apr 2025 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419961; cv=none; b=ZHPZaDb4036BoQpT5pcZ0ObD+AcXYbPKmII4RfFs6PSjVM6djVv4l8VK2MId78VsAS8vBe7qoaH5vSXvwMvmMZYAIwvAedM12YyNW7okgUA3kNR5fWqBt9hGC5Gbr67S4g2eynOEdOAeH4PudX5ls7vJCqogroDenMWKyQgYat0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419961; c=relaxed/simple;
	bh=QP4xP2iBSi6Flm5EqM5B3N2nQ56CQThPPtmCk9QJJI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSaDjtP/Kkcsg301J+Dfq9uqafr8iei7yI8BUvbGWN0O7dJ6TaoZAMgmJxg2rmguKDJ6+JNXvCeEj8qG7NKYePYQaBnM7kt/vvahIH2dKhe+Z414y/t4bDESVTL0DTa2g/6TO3HzIcU2S7+kp8MPGNzGJzjqVzvAQSLtlY/EmyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjK6pThp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjK6pThp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74170C4CEE3;
	Wed, 23 Apr 2025 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419960;
	bh=QP4xP2iBSi6Flm5EqM5B3N2nQ56CQThPPtmCk9QJJI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjK6pThpULiJ8Nf5mMkY2onS6NKx8pdOJPyEExBcwfZ3LFffvh/E9QFwMYBZIBRPt
	 pC3TjfaqYhojhYik7r6AKNcX13GbTq5bXTWAneAzajkD7aHoCByxiA+vMIXK14DukR
	 NA8IM5fjLmSGJ1+Gav0ONSn488kQnQvuf8nselpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 047/241] net: hibmcge: fix incorrect pause frame statistics issue
Date: Wed, 23 Apr 2025 16:41:51 +0200
Message-ID: <20250423142622.429431439@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 5b04080cd6028f0737bbbd0c5b462d226cff9052 ]

The driver supports pause frames,
but does not pass pause frames based on rx pause enable configuration,
resulting in incorrect pause frame statistics.

like this:
mz eno3 '01 80 c2 00 00 01 00 18 2d 04 00 9c 88 08 00 01 ff ff' \
	-p 64 -c 100

ethtool -S enp132s0f2 | grep -v ": 0"
NIC statistics:
     rx_octets_total_filt_cnt: 6800
     rx_filt_pkt_cnt: 100

The rx pause frames are filtered by the MAC hardware.

This patch configures pass pause frames based on the
rx puase enable status to ensure that
rx pause frames are not filtered.

mz eno3 '01 80 c2 00 00 01 00 18 2d 04 00 9c 88 08 00 01 ff ff' \
        -p 64 -c 100

ethtool --include-statistics -a enp132s0f2
Pause parameters for enp132s0f2:
Autonegotiate:	on
RX:		on
TX:		on
RX negotiated: on
TX negotiated: on
Statistics:
  tx_pause_frames: 0
  rx_pause_frames: 100

Fixes: 3a03763f3876 ("net: hibmcge: Add pauseparam supported in this module")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250410021327.590362-2-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c  | 3 +++
 drivers/net/ethernet/hisilicon/hibmcge/hbg_reg.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c b/drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c
index e7798f2136450..169e6a0bac496 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c
@@ -232,6 +232,9 @@ void hbg_hw_set_pause_enable(struct hbg_priv *priv, u32 tx_en, u32 rx_en)
 			    HBG_REG_PAUSE_ENABLE_TX_B, tx_en);
 	hbg_reg_write_field(priv, HBG_REG_PAUSE_ENABLE_ADDR,
 			    HBG_REG_PAUSE_ENABLE_RX_B, rx_en);
+
+	hbg_reg_write_field(priv, HBG_REG_REC_FILT_CTRL_ADDR,
+			    HBG_REG_REC_FILT_CTRL_PAUSE_FRM_PASS_B, rx_en);
 }
 
 void hbg_hw_get_pause_enable(struct hbg_priv *priv, u32 *tx_en, u32 *rx_en)
diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_reg.h b/drivers/net/ethernet/hisilicon/hibmcge/hbg_reg.h
index f12efc12f3c54..e7bc5435d51ba 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_reg.h
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_reg.h
@@ -60,6 +60,7 @@
 #define HBG_REG_TRANSMIT_CTRL_AN_EN_B		BIT(5)
 #define HBG_REG_REC_FILT_CTRL_ADDR		(HBG_REG_SGMII_BASE + 0x0064)
 #define HBG_REG_REC_FILT_CTRL_UC_MATCH_EN_B	BIT(0)
+#define HBG_REG_REC_FILT_CTRL_PAUSE_FRM_PASS_B	BIT(4)
 #define HBG_REG_LINE_LOOP_BACK_ADDR		(HBG_REG_SGMII_BASE + 0x01A8)
 #define HBG_REG_CF_CRC_STRIP_ADDR		(HBG_REG_SGMII_BASE + 0x01B0)
 #define HBG_REG_CF_CRC_STRIP_B			BIT(0)
-- 
2.39.5



