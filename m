Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732AF79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED18DC433D6;
	Wed, 30 Nov 2022 18:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834207;
	bh=+Tq7M76UhYUvnjkxcTKZtDvi4CI3IqupRz7SxAbZunE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q50lftRuwUsY6gFwHm6bNaYBahcrmrnZWRm7GNtRaV4qQ7CNcv0NwRR/U2stT7gbi
	 IvMH9cy6/aHBfx4ehDfCLNkb/Akjip+JMpzunYAQ5TutEI4JkZ2MaWLozj8yBtiC8t
	 gfNPfHGmlZlVAhDDYworB6cqAFUWOa28YaUZxVe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 141/289] net: dm9051: Fix missing dev_kfree_skb() in dm9051_loop_rx()
Date: Wed, 30 Nov 2022 19:22:06 +0100
Message-Id: <20221130180547.334274864@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit bac81f40c2c1484a2bd416b3fbf983f6e76488cd ]

The dm9051_loop_rx() returns without release skb when dm9051_stop_mrcmd()
returns error, free the skb to avoid this leak.

Fixes: 2dc95a4d30ed ("net: Add dm9051 driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/davicom/dm9051.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
index a523ddda7609..de7105a84747 100644
--- a/drivers/net/ethernet/davicom/dm9051.c
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -798,8 +798,10 @@ static int dm9051_loop_rx(struct board_info *db)
 		}
 
 		ret = dm9051_stop_mrcmd(db);
-		if (ret)
+		if (ret) {
+			dev_kfree_skb(skb);
 			return ret;
+		}
 
 		skb->protocol = eth_type_trans(skb, db->ndev);
 		if (db->ndev->features & NETIF_F_RXCSUM)
-- 
2.35.1



