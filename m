Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D711429AB13;
	Wed, 17 Sep 2025 13:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114159; cv=none; b=Et17pVRV8dOwuKFn2Ka+jHYDzEQTAd9Vl1hAI1R5teML6It6WZaSZn7hzimqTB2oBilftC/VFPi9bzkp/wAYcN5CHV2dyLBE+n9Rd1ojpiBTETFM73D1pG+HsCqSZ84ozZ3ALWInduYUrz9BNkeSYjtl9REd5wOl9A8wt2sOJgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114159; c=relaxed/simple;
	bh=SCFiyAHvXeOdM+YE8h5AFFce5MjlYFv8pEU2/XJMDDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpF5o05TjPMm8CVunsuGIeHNV4gjFAi07ecmy8xGvKhph1fhripg253Ea/5RzPwg7wzcuflrPoHI+729b/0H+Gqmu4P309Qb/9NONeEInlhD34ljQRpwcBtFFWtioNw1WgEwMzgszSeQ1ueBBWmumxl2od+/I/k5MGMdEN6hDSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gqhou7YA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gqhou7YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9EEC4CEF0;
	Wed, 17 Sep 2025 13:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114159;
	bh=SCFiyAHvXeOdM+YE8h5AFFce5MjlYFv8pEU2/XJMDDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gqhou7YAzS97JDISQ42bQzk7uyUqDlpkcG9jrqNQsW5uI/VchKdAzf3ZUui1Df/id
	 GLVJ1gsvkEM7bzGqzGKSVes3lXqD5R5mC770FZEHtyknhS9fWJX/6iFsZqLHG5M+Js
	 0EDEig9EznAbC4V1+E1/QRylhYgZ/CrgEUhdge60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 63/78] hsr: use hsr_for_each_port_rtnl in hsr_port_get_hsr
Date: Wed, 17 Sep 2025 14:35:24 +0200
Message-ID: <20250917123331.113897125@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 393c841fe4333cdd856d0ca37b066d72746cfaa6 ]

hsr_port_get_hsr() iterates over ports using hsr_for_each_port(),
but many of its callers do not hold the required RCU lock.

Switch to hsr_for_each_port_rtnl(), since most callers already hold
the rtnl lock. After review, all callers are covered by either the rtnl
lock or the RCU lock, except hsr_dev_xmit(). Fix this by adding an
RCU read lock there.

Fixes: c5a759117210 ("net/hsr: Use list_head (and rcu) instead of array for slave devices.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250905091533.377443-3-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 3 +++
 net/hsr/hsr_main.c   | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 8b98b3f3b71d9..0b23d52b8d87a 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -228,6 +228,7 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct hsr_priv *hsr = netdev_priv(dev);
 	struct hsr_port *master;
 
+	rcu_read_lock();
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	if (master) {
 		skb->dev = master->dev;
@@ -240,6 +241,8 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		dev_core_stats_tx_dropped_inc(dev);
 		dev_kfree_skb_any(skb);
 	}
+	rcu_read_unlock();
+
 	return NETDEV_TX_OK;
 }
 
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index c325ddad539a7..76a1958609e29 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -125,7 +125,7 @@ struct hsr_port *hsr_port_get_hsr(struct hsr_priv *hsr, enum hsr_port_type pt)
 {
 	struct hsr_port *port;
 
-	hsr_for_each_port(hsr, port)
+	hsr_for_each_port_rtnl(hsr, port)
 		if (port->type == pt)
 			return port;
 	return NULL;
-- 
2.51.0



