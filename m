Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C950330D41;
	Wed, 17 Sep 2025 12:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113552; cv=none; b=JnrLYbhrONVo+uFJQOOFGmfvMFLZ3h2+zPWIV/+w6QDK5R1N2aU+KvmpHomlm3mNKkKG67vfIs+tAGMvuZTu43DNoOcD3YEpm5rN2IEAV+pLO8VZOF/mKW8hY5tbjettE0HQwI34i7tXa6+SBkjQ0s5iqLgYc9TIsZ+TMcecCow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113552; c=relaxed/simple;
	bh=dibLRZQWQWa7mLCLNysN/f5BgNR5eoMF1h3748U6EXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7liXv7etx7cxTFjZQ59b1CVxhWXFOFml2YsBXFum6n20uM4RgC9qaOKjo9ALp5TqNAn2KzxEB9Oowj05OBmIJt+KqIiodMfkohkZO4J0jSDnhd2bguCtTmhAD/FVM+uXpN+XwYqAFe45s1zoUA4FnPKPNhezU4tTepwox0Y0s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/IuO5lA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/IuO5lA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15761C4CEF0;
	Wed, 17 Sep 2025 12:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113552;
	bh=dibLRZQWQWa7mLCLNysN/f5BgNR5eoMF1h3748U6EXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/IuO5lAM3pUfz1VwMoTssi179msd8dZKbNoJXkEJqed+ZSU3CG132SeZLflr/0Zg
	 FgJJo+itV909+pi3xOvoZLmDuxV8PW5LEmd/+m3k7npym5ipd6LQ5amXhMTS/9Uz4/
	 o6F/yYPjgTX2O8LjbUmU81Cp67hHq/PSUXAgVcgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/140] hsr: use hsr_for_each_port_rtnl in hsr_port_get_hsr
Date: Wed, 17 Sep 2025 14:34:51 +0200
Message-ID: <20250917123347.214213387@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 56b49d477bec0..d2ae9fbed9e30 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -226,6 +226,7 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct hsr_priv *hsr = netdev_priv(dev);
 	struct hsr_port *master;
 
+	rcu_read_lock();
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	if (master) {
 		skb->dev = master->dev;
@@ -238,6 +239,8 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		dev_core_stats_tx_dropped_inc(dev);
 		dev_kfree_skb_any(skb);
 	}
+	rcu_read_unlock();
+
 	return NETDEV_TX_OK;
 }
 
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index e1afa54b3fba8..9e4ce1ccc0229 100644
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



