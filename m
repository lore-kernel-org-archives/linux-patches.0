Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12026446C4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTG+myRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B63C433CB;
	Wed, 15 Nov 2023 22:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085740;
	bh=egJinm0++qnpLLKs9OYkQrYf66vRSOlVEDmyQxYeGic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTG+myRh0/yZhQOOcrfR/jKbCCW0nvv/rKKeclXiPvNiAKE5zaFQu6BcAgLno2obz
	 WdfRZu9JndEfJ5PsSJZlhGLgT0OT+9l0YtKpgGMcixxZv+Ofti8oJCOcFMH9OAshNH
	 cE4dRLI7xV4vgrCvaXhmcbLpGzjxCF4Vf5foXV9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Mahesh Bandewar <maheshb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/119] ipvlan: properly track tx_errors
Date: Wed, 15 Nov 2023 17:00:12 -0500
Message-ID: <20231115220133.309424999@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ff672b9ffeb3f82135488ac16c5c5eb4b992999b ]

Both ipvlan_process_v4_outbound() and ipvlan_process_v6_outbound()
increment dev->stats.tx_errors in case of errors.

Unfortunately there are two issues :

1) ipvlan_get_stats64() does not propagate dev->stats.tx_errors to user.

2) Increments are not atomic. KCSAN would complain eventually.

Use DEV_STATS_INC() to not miss an update, and change ipvlan_get_stats64()
to copy the value back to user.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mahesh Bandewar <maheshb@google.com>
Link: https://lore.kernel.org/r/20231026131446.3933175-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_core.c | 8 ++++----
 drivers/net/ipvlan/ipvlan_main.c | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index ab09d110760ec..b5a61b16a7eab 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -442,12 +442,12 @@ static int ipvlan_process_v4_outbound(struct sk_buff *skb)
 
 	err = ip_local_out(net, skb->sk, skb);
 	if (unlikely(net_xmit_eval(err)))
-		dev->stats.tx_errors++;
+		DEV_STATS_INC(dev, tx_errors);
 	else
 		ret = NET_XMIT_SUCCESS;
 	goto out;
 err:
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	kfree_skb(skb);
 out:
 	return ret;
@@ -483,12 +483,12 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
 
 	err = ip6_local_out(net, skb->sk, skb);
 	if (unlikely(net_xmit_eval(err)))
-		dev->stats.tx_errors++;
+		DEV_STATS_INC(dev, tx_errors);
 	else
 		ret = NET_XMIT_SUCCESS;
 	goto out;
 err:
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	kfree_skb(skb);
 out:
 	return ret;
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 5fea2e4a93101..4edec38437d00 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -320,6 +320,7 @@ static void ipvlan_get_stats64(struct net_device *dev,
 		s->rx_dropped = rx_errs;
 		s->tx_dropped = tx_drps;
 	}
+	s->tx_errors = DEV_STATS_READ(dev, tx_errors);
 }
 
 static int ipvlan_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid)
-- 
2.42.0



