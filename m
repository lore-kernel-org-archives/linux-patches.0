Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6349C7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120ECC433D6;
	Wed,  2 Nov 2022 02:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357390;
	bh=PaYLz9a3Av4QApHyKMJNX7rMRmK8DqVdnbbYSxFwd2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0ENsxUrh7FiNlns6UGtrQ8XlHx2QWc0dXyARRlsQHDB26mBwJd43pxRAiRTJ6Bhz
	 QnUnXWy/aqmeE8OYYzcCLTYgDCR1EbS8F1mpyLnF3NPRbTmNjWNJ6Nou5W9g6uvKYi
	 gVg7vbTx0wFOLnMIzULfg/dqvRULEuULM+pI4kHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 162/240] net: lan966x: Fix the rx drop counter
Date: Wed,  2 Nov 2022 03:32:17 +0100
Message-Id: <20221102022115.047147301@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit f8c1c66b99a570c08b9d26e4347276f00e49bba7 ]

Currently the rx drop is calculated as the sum of multiple HW drop
counters. The issue is that not all the HW drop counters were added for
the rx drop counter. So if for example you have a police that drops
frames, they were not see in the rx drop counter.
Fix this by updating how the rx drop counter is calculated. It is
required to add also RX_RED_PRIO_* HW counters.

Fixes: 12c2d0a5b8e2 ("net: lan966x: add ethtool configuration and statistics")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20221019083056.2744282-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/lan966x/lan966x_ethtool.c   | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
index e58a27fd8b50..fea42542be28 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
@@ -656,7 +656,15 @@ void lan966x_stats_get(struct net_device *dev,
 	stats->rx_dropped = dev->stats.rx_dropped +
 		lan966x->stats[idx + SYS_COUNT_RX_LONG] +
 		lan966x->stats[idx + SYS_COUNT_DR_LOCAL] +
-		lan966x->stats[idx + SYS_COUNT_DR_TAIL];
+		lan966x->stats[idx + SYS_COUNT_DR_TAIL] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_0] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_1] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_2] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_3] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_4] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_5] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_6] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_7];
 
 	for (i = 0; i < LAN966X_NUM_TC; i++) {
 		stats->rx_dropped +=
-- 
2.35.1



