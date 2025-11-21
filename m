Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5694F274FE3;
	Fri, 21 Nov 2025 13:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731676; cv=none; b=iXtW4R92X4f3hpsHvPSJHEtBOyKzNEOlJtXjllRpYfMGSejWyviS6KdQcnR3PxYhZzaIeQhw5gDTaeCNKMgksdDO6bEslZ3BFqxDpR6C68Uwz25oph8E1NjZ6efEoJyweeFm3dzqtOxhMZgTvPkuLUVDAUXIZRShMyUgzU5LAdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731676; c=relaxed/simple;
	bh=KgeflNdAEJ2/RMKO3gYYB3TUWHxnBZcTt+0dXmcIHDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgTSN5MkY2OHQ2Ww5r2g6OYuR0kbZbeVmJcgs3rPedgVGAAXLcmwVm0XOqCY7V6SBNTW+ABbd16RvpfkJKmi6NXl8N4K2T5yghG9JAnvO8LjKMx5X8KTEEbELkAIjzBvYBGIdjbQ08351JlulKdvRz0NeaZeWcJLIi7HNS7G3IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gM7mDNSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gM7mDNSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46B9C4CEF1;
	Fri, 21 Nov 2025 13:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731676;
	bh=KgeflNdAEJ2/RMKO3gYYB3TUWHxnBZcTt+0dXmcIHDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gM7mDNSIH5Fx9hrU4AFFAMoITnbldKRNifHgLZ7DAA06AoFfNPcKtC2+XfnUYBlNN
	 8C6CqgxAPV4GxoP0cSR7pga46KPRPVfj2DrQjLK5zC24AsGgbib44KPVZKvkb43aYV
	 QYzEM5DTfedyHsR1AR82Kd9ay9vJ87CvSGO9JKp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/185] Bluetooth: 6lowpan: reset link-local header on ipv6 recv path
Date: Fri, 21 Nov 2025 14:11:08 +0100
Message-ID: <20251121130145.362008326@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3c29778171c58..e313b066733f8 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -288,6 +288,7 @@ static int recv_pkt(struct sk_buff *skb, struct net_device *dev,
 		local_skb->pkt_type = PACKET_HOST;
 		local_skb->dev = dev;
 
+		skb_reset_mac_header(local_skb);
 		skb_set_transport_header(local_skb, sizeof(struct ipv6hdr));
 
 		if (give_skb_to_upper(local_skb, dev) != NET_RX_SUCCESS) {
-- 
2.51.0



