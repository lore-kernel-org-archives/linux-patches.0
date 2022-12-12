Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFE428ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C6DC433EF;
	Mon, 12 Dec 2022 13:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852705;
	bh=FxE5szdoYANSUgtPcX1ir9q6H+5H7pfzSJ+xkYsxJ94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aF2M/rz/jHLJEE+Ng0Rbn3Sz025CTB88L7+LYMllMOxdwiaLm7RoQGlTMcuXb9N3/
	 LZofXXXOb23eL6ctV0kyJ+K1ui5Zh9AFWMKXi54BdeNfkA/lzbkRc+4BfzjCpWsLCz
	 s1VmdcpUbTEc+NM6R5kiaSDwLs7es/pbG1Gbb4vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 135/157] ravb: Fix potential use-after-free in ravb_rx_gbeth()
Date: Mon, 12 Dec 2022 14:18:03 +0100
Message-Id: <20221212130940.462893107@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 5a5a3e564de6a8db987410c5c2f4748d50ea82b8 ]

The skb is delivered to napi_gro_receive() which may free it, after calling this,
dereferencing skb may trigger use-after-free.

Fixes: 1c59eb678cbd ("ravb: Fillup ravb_rx_gbeth() stub")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20221203092941.10880-1-yuehaibing@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 44f9b31f8b99..77d4f3eab971 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -835,7 +835,7 @@ static bool ravb_rx_gbeth(struct net_device *ndev, int *quota, int q)
 				napi_gro_receive(&priv->napi[q],
 						 priv->rx_1st_skb);
 				stats->rx_packets++;
-				stats->rx_bytes += priv->rx_1st_skb->len;
+				stats->rx_bytes += pkt_len;
 				break;
 			}
 		}
-- 
2.35.1



