Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8765F25BEE5;
	Wed,  3 Dec 2025 15:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776427; cv=none; b=AXvkZ6O/42FLNsMQRK0UiV5TGr4D3vfprclLwFpMQofXTd1z1YuR69rrSJpQi+lg5KwXNwwModW994BbZu9ClwfgW1Zy+L+pZ9k/QnzExiHT9DQJd1r+aCDELe9posqzmd7Dgg/ZsikDW4FAzI242IPJfmLz/SJLrUrSVRVCz50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776427; c=relaxed/simple;
	bh=668ZlH4eIW7ct00rsrBkQd6eNoBB5C7tIiYwvG7C+NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCDvVq3IpF4lBi7We1WxFAv4K/qAsM1rNMzT7zDX1682RMxy6SfGoWXT415y06Adn4by6Gmeec6bxxSd6b81Gxazij2XvfY58RJX/lQdMSDR9e/RwZPQlmV5O/zBPioZnkKV2GVn6MTMpUg+rXu7BoKZZ51Uc3d4g9KGqYWNhWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5hwlQcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5hwlQcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9640C4CEF5;
	Wed,  3 Dec 2025 15:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776427;
	bh=668ZlH4eIW7ct00rsrBkQd6eNoBB5C7tIiYwvG7C+NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5hwlQcT8exl6ZPdKNCocpLR50gWLCjVjVUoUNJQsgU4Z0c/d177jn0WqkSTNB9i/
	 SNk6PlomkXnOBUMyn2xTERtsOmryRUYBgYgxYyG76dmF/2mXb6puFP13mfn7C+sR0e
	 WX4fPlad1CrCvJZzVBj0bOnuqf1ziflXWyo18/Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/300] Bluetooth: 6lowpan: reset link-local header on ipv6 recv path
Date: Wed,  3 Dec 2025 16:26:24 +0100
Message-ID: <20251203152407.296077202@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 3b78f50918276ab28fb22eac9aa49401ac436a3b ]

Bluetooth 6lowpan.c netdev has header_ops, so it must set link-local
header for RX skb, otherwise things crash, eg. with AF_PACKET SOCK_RAW

Add missing skb_reset_mac_header() for uncompressed ipv6 RX path.

For the compressed one, it is done in lowpan_header_decompress().

Log: (BlueZ 6lowpan-tester Client Recv Raw - Success)
------
kernel BUG at net/core/skbuff.c:212!
Call Trace:
<IRQ>
...
packet_rcv (net/packet/af_packet.c:2152)
...
<TASK>
__local_bh_enable_ip (kernel/softirq.c:407)
netif_rx (net/core/dev.c:5648)
chan_recv_cb (net/bluetooth/6lowpan.c:294 net/bluetooth/6lowpan.c:359)
------

Fixes: 18722c247023 ("Bluetooth: Enable 6LoWPAN support for BT LE devices")
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 7e698b0ac7bc7..32dc74115dcbc 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -317,6 +317,7 @@ static int recv_pkt(struct sk_buff *skb, struct net_device *dev,
 		local_skb->pkt_type = PACKET_HOST;
 		local_skb->dev = dev;
 
+		skb_reset_mac_header(local_skb);
 		skb_set_transport_header(local_skb, sizeof(struct ipv6hdr));
 
 		if (give_skb_to_upper(local_skb, dev) != NET_RX_SUCCESS) {
-- 
2.51.0



