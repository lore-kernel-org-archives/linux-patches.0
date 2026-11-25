Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619205;
	b=ErFD8e3lKoy4rbb9Nh1qq+E3NxbPOFHrJ1HkNnCYZ47rFdYdFmDl5PfEKXZaEsVmhVXq
	 S8NqsPunSWHHGq8GoZlbSMaArxJjc4ir8PaJqiG1i692BQh9DJElV9ct7JK43tPdeW/Re
	 wOrgAS7/YFrr+73KFeZd4oQnwRe57keFLsstx880Z8yeHafN3gVAUMTkufaa+P/g6YoIr
	 P1u4yw09GVkXkmfhHulFVeqGGfyzvWvn36VWUMXX8a/oCW9Hu1D4+APIOFS67o8BYqf1m
	 Qh5Rmad1sbUigoe0sVEL60UuHZk2RTYL/+i09KNX+PLSuYUf3WFiA52KRgmFuucK1Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JWdDQx0GHZLG2cni8Dwm1zLLttz7uu3WyK54GgWMpVA=;
	b=mcjBuPP6hi3u1NztppfUwihQvNHDFvbdy8ucJ1dM8iIddX2xwI26BxxfsDjfVSBF3JEJ
	 /yv3kYesrfSuzXH0+92hJhycpLysV3UTnc7a1sfRgxHkjs6d1nrDBXPOHt1W+py8yPPLY
	 4W/nNDl2vJqkPnMCNS1TmE/l3HN9Ytx7QGPsO7XtgjEw1UbK0PR0rY+IOOuZHJx10qQ57
	 nP51e88ttKav4ZqeO66b5MFVzpnoYZQgfparkGVF3qdxTIRyhOGxgsZ3OewOWgAWMHGwa
	 SYzkSj/Gzb46KC73Z5Y2kuFcEHpXNQYasGT5XIOPZw7uvKeHghmm5H3NI1/jFm3Z7+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YNOYgyQ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3161D606A321;
	Wed, 25 Nov 2026 15:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YNOYgyQ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1661F000C6;
	Wed, 25 Nov 2026 15:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619204;
	bh=JWdDQx0GHZLG2cni8Dwm1zLLttz7uu3WyK54GgWMpVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNOYgyQ7GOT55UW0Q5Xq52xq2vkmsrzORkCuptgHpWTxAL++2AYbqxbuze/hEYkzO
	 3Gil21ChIYcXabDxjYMr7Y2EoaPhK2majYuFdxE3iTp+JgpVCa9aQWI/2sS+bkvdpv
	 MVoV28kd5axFX26MWCu7SKp7hWpRqeDcnPW4BA2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0523/1005] net: ena: avoid RX copybreak for multi-descriptor packets
Date: Wed, 25 Nov 2026 15:31:01 +0100
Message-ID: <20261125143833.997105502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit f3c790c34d228d46c4a05fe5d001d1bbea444e2b ]

ena_rx_skb() selects the copybreak path based on the first RX
descriptor's length without checking the number of descriptors. When
a packet spans multiple descriptors, this copies only the first
buffer into the skb and fails to recycle the remaining request IDs,
while RX cleanup advances by the full descriptor count.

Restrict copybreak to single-descriptor packets and apply the same
restriction to the rx_copybreak_pkt statistic. Multi-descriptor
packets then use the existing fragment-processing path.

Discovered by comparing the in-tree ENA driver with Amazon's
standalone ENA driver.

Compiled with W=1 under x86_64 defconfig.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://patch.msgid.link/20261109141343.920187-2-thnkslprpt@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 15e5cfeb0abe7..ecc6f1d827f9c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -986,7 +986,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	page_offset = rx_info->page_offset;
 	buf_addr = page_address(rx_info->page) + page_offset;
 
-	if (len <= rx_ring->rx_copybreak) {
+	if (len <= rx_ring->rx_copybreak && likely(descs == 1)) {
 		skb = ena_alloc_skb(rx_ring, NULL, len);
 		if (unlikely(!skb))
 			return NULL;
@@ -1293,7 +1293,8 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 
 		skb_record_rx_queue(skb, rx_ring->qid);
 
-		if (rx_ring->ena_bufs[0].len <= rx_ring->rx_copybreak)
+		if (rx_ring->ena_bufs[0].len <= rx_ring->rx_copybreak &&
+		    ena_rx_ctx.descs == 1)
 			rx_copybreak_pkt++;
 
 		total_len += skb->len;
-- 
2.53.0



