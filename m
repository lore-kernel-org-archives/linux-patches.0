Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCF51E5B97;
	Wed, 19 Mar 2025 14:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395126; cv=none; b=GuqQN06up0REcFHLBOM4Lrj/LbQb2HQCFAozeN4oKCZrwE5gjrftq77Tx+/rwMkCB9GIc5Ih0In7ptAQ7Jp7yVC0AEgu2cwy1+HlkZFJZKUthoTjKDAQ+eSbG76XtaNbVct0015dD6Jkfk6sl644LI579ib581VcfaNbiuayji0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395126; c=relaxed/simple;
	bh=WmxnX+pVBhrAhDeRqQKzQ6h69LjuTj4GtmO7FxJ9BXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyUUbpphrv5Y8r8TokgpohZ4Db8DpsuoZ70TeMtA3/CBnCLQWjCwwWl9ZxBuESiUZRo6AsUi8r29yoQ7odMrYt1sl1OeX1pKJK5ihhCi0khpl342982Aoa1RF6pdPFOhNv6/Wanv5YRMGlzGv8ZXA6bOYobI4An+MSPuOMJyW/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PadSFvyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PadSFvyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5438DC4CEE9;
	Wed, 19 Mar 2025 14:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395126;
	bh=WmxnX+pVBhrAhDeRqQKzQ6h69LjuTj4GtmO7FxJ9BXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PadSFvyGqbinMsEstnd/mXREcubbMfBLGBXuD8hPc1QirgYkg0jasaOHvCG7vvLeu
	 UV7HJ3BKKXqH/mfK/bFVuUJ7PneMh/tA4LGnwyHhJNTNNru2QC0HkNp3fL1BFdy5aJ
	 f8JGEU7qnQrqRiB+scd92Z6qulxwciNH48JnFNqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH 6.12 189/231] netmem: prevent TX of unreadable skbs
Date: Wed, 19 Mar 2025 07:31:22 -0700
Message-ID: <20250319143031.505256910@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Mina Almasry <almasrymina@google.com>

commit f3600c867c99a2cc8038680ecf211089c50e7971 upstream.

Currently on stable trees we have support for netmem/devmem RX but not
TX. It is not safe to forward/redirect an RX unreadable netmem packet
into the device's TX path, as the device may call dma-mapping APIs on
dma addrs that should not be passed to it.

Fix this by preventing the xmit of unreadable skbs.

Tested by configuring tc redirect:

sudo tc qdisc add dev eth1 ingress
sudo tc filter add dev eth1 ingress protocol ip prio 1 flower ip_proto \
	tcp src_ip 192.168.1.12 action mirred egress redirect dev eth1

Before, I see unreadable skbs in the driver's TX path passed to dma
mapping APIs.

After, I don't see unreadable skbs in the driver's TX path passed to dma
mapping APIs.

Fixes: 65249feb6b3d ("net: add support for skbs with unreadable frags")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250306215520.1415465-1-almasrymina@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3723,6 +3723,9 @@ static struct sk_buff *validate_xmit_skb
 {
 	netdev_features_t features;
 
+	if (!skb_frags_readable(skb))
+		goto out_kfree_skb;
+
 	features = netif_skb_features(skb);
 	skb = validate_xmit_vlan(skb, features);
 	if (unlikely(!skb))


