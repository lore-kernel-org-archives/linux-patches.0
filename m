Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58542D9494;
	Thu, 15 Jan 2026 17:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497850; cv=none; b=WtzDHuTJJzgIaznz5NKRylagvIVsGUz3I/+7J417tKI/w5phwxBFeZFdjC0z+Kskdv9pn2ZiNl+eUu65qmJij2g3ZZsFWQATYEAblA2JDtqdTHHyGY6yBdRo53PH+GsLH5ifcclVcEfD3txg93DxK3Ao4OBV9GRC3ZO4XkDkvIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497850; c=relaxed/simple;
	bh=mE6I6U4Cvebo4fodznGB+VFlixQqMRf5QmqwvZxVod4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtFnT5bRxIWCTxWdua/Bzl50A8+WIBJywzcd6BrbbQjzMz6qTRsvcg0bxSqI9YunHOLXwcm+MyFSYXkE1fuMAA4McgGs2vZcIYVB3OrawPsRcAMLW5c/CoWDf0ptdZqt/FbOYbL8JJSLRpqwmstYGSESQkxCi2biQH94GNmRxKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/+6J0Xf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/+6J0Xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A37C116D0;
	Thu, 15 Jan 2026 17:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497849;
	bh=mE6I6U4Cvebo4fodznGB+VFlixQqMRf5QmqwvZxVod4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/+6J0XfQiWvjrp/nioxTHkup1K/AqtZrZw8esTLGKKIxBf5J6RRpKSF3IenWXUXV
	 2xhQHzG/6/etzTVUtNs4gKNkb51uC2jh3hZUbcrioLDHSn6OnJUm0MOnYUiyBWH2XV
	 OGCUZZ3wKzgsmXjnNXbcNL4hcEpv+AdCBoQOqfJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Skorodumov <skorodumov.dmitry@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 225/554] ipvlan: Ignore PACKET_LOOPBACK in handle_mode_l2()
Date: Thu, 15 Jan 2026 17:44:51 +0100
Message-ID: <20260115164254.390605324@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index a18b49db38ee0..35ec6d1af6ea6 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -725,6 +725,9 @@ static rx_handler_result_t ipvlan_handle_mode_l2(struct sk_buff **pskb,
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



