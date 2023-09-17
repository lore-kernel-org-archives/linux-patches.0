Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8246FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B141C433C8;
	Sun, 17 Sep 2023 19:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979784;
	bh=iQY4Og23v3o8zQmp9mKbc6a7Ie+IPQWAYKbbHIJhIqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxuMjOwvTmaF4PiT0NmPxfEqZPamMTrXLjty2uTtK4pitoiABzY3CM2th7znh3MsN
	 6JjLAX8q2i1Dz6XT33Q98I7frjE4xpYo/PX4ZIhtluFVcPyk0U30PglLXFHtHThl5S
	 SPeTEWm/pRR6uiBQIXePwBMNI6NKNcrRDxODXm+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 395/406] net: ethernet: mtk_eth_soc: fix possible NULL pointer dereference in mtk_hwlro_get_fdir_all()
Date: Sun, 17 Sep 2023 21:14:09 +0200
Message-ID: <20230917191111.693868527@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit e4c79810755f66c9a933ca810da2724133b1165a ]

rule_locs is allocated in ethtool_get_rxnfc and the size is determined by
rule_cnt from user space. So rule_cnt needs to be check before using
rule_locs to avoid NULL pointer dereference.

Fixes: 7aab747e5563 ("net: ethernet: mediatek: add ethtool functions to configure RX flows of HW LRO")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a8319295f1ab2..aa9e616cc1d59 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2013,6 +2013,9 @@ static int mtk_hwlro_get_fdir_all(struct net_device *dev,
 	int i;
 
 	for (i = 0; i < MTK_MAX_LRO_IP_CNT; i++) {
+		if (cnt == cmd->rule_cnt)
+			return -EMSGSIZE;
+
 		if (mac->hwlro_ip[i]) {
 			rule_locs[cnt] = i;
 			cnt++;
-- 
2.40.1



