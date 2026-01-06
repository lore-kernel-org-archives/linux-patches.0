Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600A1218E91;
	Tue,  6 Jan 2026 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719812; cv=none; b=Y5Sp0KV3Tuw03SoYCWgEcpz27aY9Pz3T+TphoS8CFKE981bxrKrmXrbmxL5+/YmOx7nzOqTsf1r/eMqUn8h64B0sPEHpFxyjxfYOyaYMWLBeXVGA/AALOA/K88v922DUqlnjikuNVqhenJ8sGqqampRZmOEQVX+6zjnWSfKNmIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719812; c=relaxed/simple;
	bh=41sNM0I36C2R7+8ka4kNAuYp0VIqup63KmCSe71P3tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3yHNasa5jJZmAzitEf6XjyXL4QGA6UrsBebkBwI9VcTIpvamw3IKYg2MhfX0dE0F1fANgK5qUVwSp/Tu08Y2ZbgWVarS5Ic2o49nA2zvHHSJVoMlfLhpFEYBiJwHmpDVPVPrPdLIvJtyJTwq+bMM5VTiXh25JsKjRiCkaGbbxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDc/Q7Rj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDc/Q7Rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B4EC116C6;
	Tue,  6 Jan 2026 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719812;
	bh=41sNM0I36C2R7+8ka4kNAuYp0VIqup63KmCSe71P3tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDc/Q7RjKdekpr0ddOMJT6sTp50Th55H+pskZ1ytaGI3O4pvweMoZHsdRl13087ra
	 c/+FjKZ+MtZTT7wooA2h77E9kVvisfqJWjSypac8qa7sjvPJixDOY+GSCJcWsNItwg
	 bz5EY7Mv/aZsEvFPcLPROkHEfstFCu+KnPIpj7H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Skorodumov <skorodumov.dmitry@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/567] ipvlan: Ignore PACKET_LOOPBACK in handle_mode_l2()
Date: Tue,  6 Jan 2026 17:57:10 +0100
Message-ID: <20260106170453.116744411@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Dmitry Skorodumov <skorodumov.dmitry@huawei.com>

[ Upstream commit 0c57ff008a11f24f7f05fa760222692a00465fec ]

Packets with pkt_type == PACKET_LOOPBACK are captured by
handle_frame() function, but they don't have L2 header.
We should not process them in handle_mode_l2().

This doesn't affect old L2 functionality, since handling
was anyway incorrect.

Handle them the same way as in br_handle_frame():
just pass the skb.

To observe invalid behaviour, just start "ping -b" on bcast address
of port-interface.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Signed-off-by: Dmitry Skorodumov <skorodumov.dmitry@huawei.com>
Link: https://patch.msgid.link/20251202103906.4087675-1-skorodumov.dmitry@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index ca62188a317ad..83bd65a227709 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -737,6 +737,9 @@ static rx_handler_result_t ipvlan_handle_mode_l2(struct sk_buff **pskb,
 	struct ethhdr *eth = eth_hdr(skb);
 	rx_handler_result_t ret = RX_HANDLER_PASS;
 
+	if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
+		return RX_HANDLER_PASS;
+
 	if (is_multicast_ether_addr(eth->h_dest)) {
 		if (ipvlan_external_frame(skb, port)) {
 			struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
-- 
2.51.0



