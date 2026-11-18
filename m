Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032559;
	b=NAstT7osbL7vpRXx+dd4OltfimLqLLv7zsAk5Tqls5aNbImDuq11jhFlAXTcajqUrDi6
	 O9lz9yQvBx4M9JWH3QJ6ErKBxMwmIbv9H3MQD8CaeCnEvGrInSx1ptfkUZPW9XCp4rpF8
	 TVwRYufTQqwIVA1TryVS/nO5VpWdgcLpTUY4x8le8kNlSnNCUx2pAHkhnOLdVvv3OMEFg
	 QvYh4nn4DnbOB14zvU6LemzuhmopUqseU+g3ygcVjvGYDDbB1OISyIUpcJD48CEIm4qwW
	 9tWMr3354sctnLVgKequGKUKCZc+iUikP13rx5PqqAEND+ExM6A/bIT4F2tVmXzz1Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uyClaR7KsoZdt6lkopYRshkIQg2BbXUxw1HktJJ8pnA=;
	b=RP/QFbecRbTayAp5Agds3X29in1iqJ3BPrGaOYmJtrNtFZHvVhLAxwXUOTI4GEt4Wx8q
	 EQ3Y1ySiXZslNv6LO8tfGqt0X28Fgvs8Ob2caXPARNBOXx25Dnm+n9IIu9LfQkIdLt8M6
	 6ll02m7hYrpw7DehKEe2/+bzcqqlQ8LHcnOLzzgSkfNT+avFKxqb8A5EqHx19Way8nXT/
	 M/38vH52Tl36AWGREUaTxBTzG7+t2OVD23fXanGt5KE3VUYepwyAhCX9MuQynKibG5N8Q
	 fCTLRDMozPHp12/D5zkAioh2n5iMTl4JVBzU19Jtw1xu6Kr/cEpGO7wWjqZiFwRf1ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PuEf8cTr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD1460A2608;
	Wed, 18 Nov 2026 20:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PuEf8cTr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF38E1F000C4;
	Wed, 18 Nov 2026 20:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032559;
	bh=uyClaR7KsoZdt6lkopYRshkIQg2BbXUxw1HktJJ8pnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuEf8cTrOXJyr/PzFGC5yOO2eJPTPZzIO/VpWcCClMqiJsME24vPcmu7HLqFy0iGZ
	 jlnqHunWLuSDuhga2ku3jN+zBoAbkwHkcomcZHtSqpKD6jgirkseu4W0QMRoE9SaUK
	 sRdlUiY3lFsayZkHViJqECDpxBp7NreCHs1EzZKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1453/1756] net: bcmasp: validate minimum RX packet size in bcmasp_rx_poll()
Date: Wed, 18 Nov 2026 15:59:40 +0100
Message-ID: <20261118150106.941952487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a67205cf9647f..74df12df941f1 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -560,6 +560,12 @@ static int bcmasp_rx_poll(struct napi_struct *napi, int budget)
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



