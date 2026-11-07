Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063722;
	b=a7PTGIy/inmeEeq4qpKEG+NREnbwBU3hJKF44aROD0ZShmkJWfemIK9fXVpMkixaXdgy
	 nG0ctCGsu0TIcy7cvbrt1WhokA9QXaOrJTyV4cc9M6CiE7wPyB7+O7I1NzTx/BXUlsdd4
	 LI3CDrHw8MRFD4VNQQa96GnwwuT8+RcVj1+fzrxE4Uv/Arpb3XPBtfmbREDXBsHnJfiUc
	 3uRTTlzqkalMWipqiV5ncAN8PpBELTRT0NkGsMaCUW/Xou144ZPu6aupGeHmya3GEyCmx
	 pohQBb8VpTTodddU0rF0xiyzIkxuXhAZBjJ+EWpecBs9YopBWIyhMAXmLJEoRoa1VFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7SAHRPEHor1E2CBYxMMfIAV2MUrO4/SSDje+jhEDQSM=;
	b=JZGlqZSplQT5Ek9Vu1QirCOXB2kS4bk/dYhRxhkxZOoIROi3YNeK94j4FsBmu/rzbVLY
	 wFzHBBN+hGPMyEc2u+0aFCntDkIc8gDhUaPzApY+8UZ64hMWm06FHwJRZHCHV7sg1i4Ha
	 hkK4IyiKBBL4xg8wa0gE4zYmmJCV6rPrvmdM5IFUtIhXour5b7hCDA3Hynksalus77sfh
	 9ioSXosSwOT5dGkDNlbSjZH2NjqlUFoHiyvWiQGECnWF3/v3bazKTCoTXpGY7QdINc87x
	 A7H1QezdZY8I4rVoE/2HLbCBQIP2WRgCAHD4Ef+TqhCDwYMUnYgXmBt47xObxRQR2oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cMj/MeGC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8503B606D83F;
	Sat,  7 Nov 2026 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cMj/MeGC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D051F0089F;
	Sat,  7 Nov 2026 15:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063722;
	bh=7SAHRPEHor1E2CBYxMMfIAV2MUrO4/SSDje+jhEDQSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMj/MeGCdC+lstJvyhrzNY8zWeTVMMb46oMjvxhLXiLkD0HIaBknbJ3h5Q3T6L/rr
	 ordDINzbDh1fHxbJ3FLyZXYp6U7wq0KCjr5OeyA3VSByQAvL2HQaU74UNj1SGlaQ+E
	 30hC0fumCUmqZIGJMzcyK9E2EvTvK4WEiJcVKWts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 822/869] net: hisilicon: hisi_femac: Stop the receiver before releasing the RX ring
Date: Sat,  7 Nov 2026 08:58:24 -0500
Message-ID: <20261107134920.848463510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit d54b21d824302af52d06574870817fbe14774dab ]

hisi_femac_net_close() frees the receive ring while the RX address queue
still holds every address that was pushed to IQ_ADDR.

A port that keeps receiving then DMAs arrived frames into buffers that
other slab caches have already taken back; on an EC6108V9C (hi3798mv100)
the queue still held all 52 armed addresses right after the interface
was closed, and had dropped to 43 after 15 s of broadcast traffic.

Reset the port before the buffers are released, so that the receiver no
longer holds any of their addresses.

Fixes: 542ae60af24f ("net: hisilicon: Add Fast Ethernet MAC driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Yang <mmyangfl@gmail.com>
Link: https://patch.msgid.link/20261025182022.2959333-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hisi_femac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index d244a40df4309..fba68035c9691 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -491,6 +491,7 @@ static int hisi_femac_net_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	napi_disable(&priv->napi);
 
+	hisi_femac_port_reset(priv);
 	hisi_femac_free_skb_rings(priv);
 
 	return 0;
-- 
2.53.0



