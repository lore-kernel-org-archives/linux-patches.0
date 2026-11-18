Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042285;
	b=J+60o1itvoGHAQ8B4Jafai81KNjBxfMOjnbL54SR/N5ZKqogXiuBk/F574ujlms6Pz/X
	 RQA0PRi5MciUZ4cbzGjo8AS4j68hnSEhcfLqIw5EuW2/OjkfVNe1IK9CnFymSgXKYimQ3
	 TWHLtkMJTDoWafoR8nuUtfXC9qK2AloXuRnh2xPAWl4Prk0gNmANsO0HSDV6A4zupR0hr
	 WiWE9mDlKZiXxH6EEpkkGLjMBLWbGfj0+szxUkDt/sADt4X4eGhadXrjuIzy02zRPQ95/
	 s7nQAxA+GL+2ij2U4V4F+1NIt+9RNkCVpjJCTAeh/N4rJ0Q9ESEgmWO1vm3T96MS4YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pea2sGk60nZxKBvNA/qXJwgZuZ5bbjJ+Q+fO+3wIQ1Y=;
	b=y+LElabVruPbFTDtI86TGm7L/qWoBR5ISsWufYm+t+jx+ur3NZSiWE1jExC9+6mxvJmm
	 cPovCd3jvZly5B8tBdjv6JRWa34chfSGWEPfJTpxHCzpv3KE4e96g+KJ03LKmY6EgQh/4
	 fjZkx3gD/MQSSCB+k7fHyBFpSF73jUWFCxYVVXLtRQlb2FkxmcGkGMyOk94BaAxEOF5+F
	 HGF2SAupa0IirkHR9b2ZDqnoZamt5eCyYnZyXFOJ1xdoFQYdsd+D7XIdqj2sz+ZVtq4d/
	 Pg6XBHtUuObRi58nPs+x2AY6zCSw7oW1jvLJC9/lgdRa4brZb6LOneXTCieaVnXscxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dSbp7Y+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86210606A320;
	Wed, 18 Nov 2026 22:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dSbp7Y+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C079A1F000C5;
	Wed, 18 Nov 2026 22:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042285;
	bh=pea2sGk60nZxKBvNA/qXJwgZuZ5bbjJ+Q+fO+3wIQ1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSbp7Y+3hvVWIyUxgZqg3E8p2Dm8X2MBxu91uDdMFCzxtCfKOQWKZG+e+jjbgUW2O
	 ZNqyaeuEpMSdBoKUdmHS1/6eQLJVQcaHbdtteaBRiJo/6zo8a+EoBHrTUe/ujO4m2g
	 DFu31HETHfYLgjLPD5oJ641tMgdiSTjJkOkFvrfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3075/3318] net: bcmasp: validate minimum RX packet size in bcmasp_rx_poll()
Date: Wed, 18 Nov 2026 16:01:37 +0100
Message-ID: <20261118150452.340250731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 07b624d2f5a4517d7d0022fbd4aef17e884b5686 ]

In bcmasp_rx_poll(), the driver removes a 2-byte alignment pad and
optionally strips the ETH_FCS_LEN CRC from received packets before
passing them to eth_type_trans().

If the hardware reports a descriptor size smaller than the sum of the
2-byte pad, the Ethernet header (ETH_HLEN), and optional CRC
(ETH_FCS_LEN), subtracting the pad and CRC lengths underflows u32 len.
This adds ~4 GiB to rx_bytes statistics, while the undersized frame
reaches eth_type_trans(), which reads past skb->len into stale buffer
data.

Check that desc->size is at least (2 + ETH_HLEN + (crc_fwd ? ETH_FCS_LEN
: 0)) before proceeding to process the descriptor.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261013204439.3494046-4-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 2b6b66ee63978..4a795ffc7f00f 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -559,6 +559,12 @@ static int bcmasp_rx_poll(struct napi_struct *napi, int budget)
 					DMA_FROM_DEVICE);
 
 		len = desc->size;
+		if (unlikely(len < 2 + ETH_HLEN + (intf->crc_fwd ? ETH_FCS_LEN : 0))) {
+			u64_stats_update_begin(&stats->syncp);
+			u64_stats_inc(&stats->rx_dropped);
+			u64_stats_update_end(&stats->syncp);
+			goto next;
+		}
 
 		skb = napi_alloc_skb(napi, len);
 		if (!skb) {
-- 
2.53.0



