Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50E614263
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B83C433C8;
	Tue, 25 Jul 2023 10:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282541;
	bh=U+f7jxSkS5p41itbuAQrU+0C7MX5X1FDgOdBJzLd1uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QF8SmeMqn1hQBZJuBOkiNcKqJ2J/tS+toctHBeQaDJa7S6YGbeS3dqq14czqUJ/k9
	 cdKgFNKiQv5xOJRtiiNSfj4NRUg2nmUGFpGvgKocX8Bw2Nop0wOaD9YFlqutVs1iAQ
	 Ssvcpj/1PJvfoK5z9ASwE7v0MtQo6oP4ZraYizWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <Tristram.Ha@microchip.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 167/227] net: dsa: microchip: correct KSZ8795 static MAC table access
Date: Tue, 25 Jul 2023 12:45:34 +0200
Message-ID: <20230725104521.825909744@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tristram Ha <Tristram.Ha@microchip.com>

[ Upstream commit 4bdf79d686b49ac49373b36466acfb93972c7d7c ]

The KSZ8795 driver code was modified to use on KSZ8863/73, which has
different register definitions.  Some of the new KSZ8795 register
information are wrong compared to previous code.

KSZ8795 also behaves differently in that the STATIC_MAC_TABLE_USE_FID
and STATIC_MAC_TABLE_FID bits are off by 1 when doing MAC table reading
than writing.  To compensate that a special code was added to shift the
register value by 1 before applying those bits.  This is wrong when the
code is running on KSZ8863, so this special code is only executed when
KSZ8795 is detected.

Fixes: 4b20a07e103f ("net: dsa: microchip: ksz8795: add support for ksz88xx chips")
Signed-off-by: Tristram Ha <Tristram.Ha@microchip.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c    | 8 +++++++-
 drivers/net/dsa/microchip/ksz_common.c | 8 ++++----
 drivers/net/dsa/microchip/ksz_common.h | 7 +++++++
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index f56fca1b1a222..cc5b19a3d0df2 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -506,7 +506,13 @@ static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 		(data_hi & masks[STATIC_MAC_TABLE_FWD_PORTS]) >>
 			shifts[STATIC_MAC_FWD_PORTS];
 	alu->is_override = (data_hi & masks[STATIC_MAC_TABLE_OVERRIDE]) ? 1 : 0;
-	data_hi >>= 1;
+
+	/* KSZ8795 family switches have STATIC_MAC_TABLE_USE_FID and
+	 * STATIC_MAC_TABLE_FID definitions off by 1 when doing read on the
+	 * static MAC table compared to doing write.
+	 */
+	if (ksz_is_ksz87xx(dev))
+		data_hi >>= 1;
 	alu->is_static = true;
 	alu->is_use_fid = (data_hi & masks[STATIC_MAC_TABLE_USE_FID]) ? 1 : 0;
 	alu->fid = (data_hi & masks[STATIC_MAC_TABLE_FID]) >>
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index a4428be5f483c..a0ba2605bb620 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -331,13 +331,13 @@ static const u32 ksz8795_masks[] = {
 	[STATIC_MAC_TABLE_VALID]	= BIT(21),
 	[STATIC_MAC_TABLE_USE_FID]	= BIT(23),
 	[STATIC_MAC_TABLE_FID]		= GENMASK(30, 24),
-	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(26),
-	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(24, 20),
+	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(22),
+	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(20, 16),
 	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(6, 0),
-	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(8),
+	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(7),
 	[DYNAMIC_MAC_TABLE_NOT_READY]	= BIT(7),
 	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 29),
-	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(26, 20),
+	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(22, 16),
 	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(26, 24),
 	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
 	[P_MII_TX_FLOW_CTRL]		= BIT(5),
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 8abecaf6089ef..33d9a2f6af27a 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -569,6 +569,13 @@ static inline void ksz_regmap_unlock(void *__mtx)
 	mutex_unlock(mtx);
 }
 
+static inline bool ksz_is_ksz87xx(struct ksz_device *dev)
+{
+	return dev->chip_id == KSZ8795_CHIP_ID ||
+	       dev->chip_id == KSZ8794_CHIP_ID ||
+	       dev->chip_id == KSZ8765_CHIP_ID;
+}
+
 static inline bool ksz_is_ksz88x3(struct ksz_device *dev)
 {
 	return dev->chip_id == KSZ8830_CHIP_ID;
-- 
2.39.2



