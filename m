Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4301BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D283C433EF;
	Tue,  7 Mar 2023 17:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209542;
	bh=+L8c6t1GA8Q4YAy7iNEjKchtUVA5LabF+Cm/zx3WlNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0z34ZOK3TRI9/Sw38B5CojVB5VNHuYnnSF6UAN8kEVeOX2OI3rIl6tC35F95WdJp
	 5EPi/BD08ZX/8mExCttzIcKhLE8+Rd4JpLnzyWQSZh6vlCHg7tdS2yMHGz/P0KYZEZ
	 GzTSxlBHWMB1HVPMPlj1gaQKOH3EIOqRLd3a9Hlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deren Wu <deren.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0251/1001] wifi: mt76: add memory barrier to SDIO queue kick
Date: Tue,  7 Mar 2023 17:50:23 +0100
Message-Id: <20230307170032.680312727@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 5f54237ad798f41cb6a503271aa9ca47188cfb9b ]

Ensure the entry has been fully updated before SDIO bus worker access
it. This patch would fix potential memory risk in both mt7663s and
mt7921s.

Fixes: 764dee47e2c1 ("mt76: sdio: move common code in mt76_sdio module")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index 228bc7d45011c..419723118ded8 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -562,6 +562,10 @@ mt76s_tx_queue_skb_raw(struct mt76_dev *dev, struct mt76_queue *q,
 
 	q->entry[q->head].buf_sz = len;
 	q->entry[q->head].skb = skb;
+
+	/* ensure the entry fully updated before bus access */
+	smp_wmb();
+
 	q->head = (q->head + 1) % q->ndesc;
 	q->queued++;
 
-- 
2.39.2



