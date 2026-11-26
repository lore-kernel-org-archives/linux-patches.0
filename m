Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705319;
	b=5C7zGGs/b5PhyihMo/nfOPqG6GbOc6ogSjvhgiwWqZNpe4gmSkbMrBDkoaotFu51mQVA
	 qlZX2RmKt4QbH9/Ugxlpbd8WbgnZQ7e4XY71oK6uOZ64VSIcTT/jCX/m/zzKxw+D87Tgs
	 NzzSa/WKBB1sM0iI/gcKboIe5xtUtJ+Stssq5wCHbCJ15kwUaP8SUpJMZ+fGNfWupSO52
	 5iSnXbqVff2mBPHL7SJD6tzud+SEFvefu6EN9TP5L+OEWI0oiAX21o3HZ9EEPAQHynjpv
	 /Sd6uAqkh3e2EH2aARFXWhq2i67k/LL9bcc/b0m6XUJPoq84/m05nPQLCihIC9XIk6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FBDCwiUkewKc0L6F1PjiPkB5GCYfqVCDZpv7bvbYVcc=;
	b=Qw9y+tP+/ajHUfhEobyhDk4K3psPrfu9HMSWAuYMZ7VX111Nq4CbFKLWJTNxEpr4nxn5
	 cCKi9eb/w6NIxU37TO4mV8iknYWs3lmOOBVtnr77nqyw/4iT4Q83Jwqp9qBa6NCRHmseG
	 X4YALhTY6hr8dhKDIdhk2nYq8QgrrxLmlSXsJaokdSQ/PxbiRAxkJndsb9MAXlX37H4H3
	 VOxPZ/f+0KpRbAGYq3KeRQkRACmi+ltiusx4auAvmplETq1fr1TqQew0424hKv8P5pMfw
	 sMSMfvdeWepPtpkNgg2TPA0C+idE5v5Sd4yCBWG1IKNOZVgCDkUVhxJc4h5UoTURFGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLHL+zFQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D963D606A32C;
	Thu, 26 Nov 2026 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLHL+zFQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264541F000C6;
	Thu, 26 Nov 2026 15:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705319;
	bh=FBDCwiUkewKc0L6F1PjiPkB5GCYfqVCDZpv7bvbYVcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLHL+zFQ1mDF8NkmwIMjqf0rH9Norpq+KuwYaUZng1y+eU3K8HrtsL9Pi0DmKd1K2
	 B5CB8qoKIu3aw3mPGuKrknY0aoHQs4PuBdKzaL70XVdA4NDcmHFMEmik/QbPV3nWwg
	 6wOlHGPCYzrHHtFgS6eN7yJ5Q3zndkarJXRR/db8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/319] net: ena: avoid RX copybreak for multi-descriptor packets
Date: Thu, 26 Nov 2026 15:38:45 +0100
Message-ID: <20261126144010.289873287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 999aa8abc3e9a..be6c6e8c35b77 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1502,7 +1502,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	page_offset = rx_info->page_offset;
 	buf_addr = page_address(rx_info->page) + page_offset;
 
-	if (len <= rx_ring->rx_copybreak) {
+	if (len <= rx_ring->rx_copybreak && likely(descs == 1)) {
 		skb = ena_alloc_skb(rx_ring, NULL, len);
 		if (unlikely(!skb))
 			return NULL;
@@ -1808,7 +1808,8 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 
 		skb_record_rx_queue(skb, rx_ring->qid);
 
-		if (rx_ring->ena_bufs[0].len <= rx_ring->rx_copybreak)
+		if (rx_ring->ena_bufs[0].len <= rx_ring->rx_copybreak &&
+		    ena_rx_ctx.descs == 1)
 			rx_copybreak_pkt++;
 
 		total_len += skb->len;
-- 
2.53.0



