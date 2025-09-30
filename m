Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A120223DD6;
	Tue, 30 Sep 2025 15:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245189; cv=none; b=CSyaDvUFZxhy+1TT1HO4sLZIHMBc9my2ho0sWcyQO+jdlMqgEcqMAqUrJeWQqKJTM0GS16ZTZamNIpi7r4j1TzjDXR5QWO+LhqMp5uV0ZuMdEkEpfw0HquOPp63pd0PXJ6nRyblLeenVvlSv5fIIibwnn1qUmU8tB3EOL3bkFGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245189; c=relaxed/simple;
	bh=tQhoWgXAOf0bfMsLZv6B8SluWfXi6lhGVlk/0G/yqlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KikOTCbRdmwWCEAOPSmktXDhC9vMyUdDpgeeG7jRz1FImNGQhNKyaKesLRIIPJSJi8hzXL7iFE9YIhXbuaGiY130ILbOA5gmFHAG1rB0p5dVCjHE2cbn+tsnVEyMbCYg7r3HR6ier+9xBCRni9KIg2ZaEaoOSRajkmvkNM+AsVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYILFf7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYILFf7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD48C4CEF0;
	Tue, 30 Sep 2025 15:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245189;
	bh=tQhoWgXAOf0bfMsLZv6B8SluWfXi6lhGVlk/0G/yqlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYILFf7pnarY0+O5wuz8PO8RyqJ0gN18EmOFMXZaDl0yQKM02N+CY2c1RsGEin65F
	 qfmbltXLF5Gp0ajJfxhYR6pgI5yEknHNKs5d684vAA7ED/LqErIAYtb0GK7Km/Becw
	 j4YEQyXQDQ6fxAitLrrdASDD6PRXlM0fvg00pKOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/151] hsr: use hsr_for_each_port_rtnl in hsr_port_get_hsr
Date: Tue, 30 Sep 2025 16:46:21 +0200
Message-ID: <20250930143829.640661245@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ff27935a29523..503f2064e7323 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -231,6 +231,7 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct hsr_priv *hsr = netdev_priv(dev);
 	struct hsr_port *master;
 
+	rcu_read_lock();
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	if (master) {
 		skb->dev = master->dev;
@@ -243,6 +244,8 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		atomic_long_inc(&dev->tx_dropped);
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



